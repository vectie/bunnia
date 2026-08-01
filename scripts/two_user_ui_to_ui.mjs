#!/usr/bin/env node

import assert from "node:assert/strict";
import fs from "node:fs/promises";
import path from "node:path";
import { createRequire } from "node:module";

const require = createRequire(import.meta.url);
const automator = require(
  process.env.MINIPROGRAM_AUTOMATOR_MODULE || "miniprogram-automator",
);

const projectPath = path.resolve(
  process.env.MOONTOWN_MINIAPP_PROJECT ||
    "_build/bunnia/wechat/moontown_miniapp",
);
const cliPath = process.env.WECHAT_DEVTOOLS_CLI || "";
const adaBaseUrl = process.env.MOONTOWN_ADA_BASE_URL || "http://127.0.0.1:18192";
const boBaseUrl = process.env.MOONTOWN_BO_BASE_URL || "http://127.0.0.1:18191";
const adaSession = process.env.MOONTOWN_ADA_SESSION || "";
const boSession = process.env.MOONTOWN_BO_SESSION || "";
const listingId = process.env.MOONTOWN_TEST_LISTING_ID || "ada-policy-guide-card";
const timeoutMs = Number(process.env.MOONTOWN_UI_TIMEOUT_MS || "420000");
const resultPath = path.resolve(
  process.env.MOONTOWN_UI_RESULT || "_build/bunnia/two-user-ui-result.json",
);

assert(cliPath, "WECHAT_DEVTOOLS_CLI is required");
assert(adaSession, "MOONTOWN_ADA_SESSION is required");
assert(boSession, "MOONTOWN_BO_SESSION is required");

const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

async function waitFor(label, check, limit = timeoutMs) {
  const deadline = Date.now() + limit;
  let lastError;
  while (Date.now() < deadline) {
    try {
      const value = await check();
      if (value) return value;
    } catch (error) {
      lastError = error;
    }
    await sleep(750);
  }
  throw new Error(
    `${label} did not become ready within ${limit}ms${lastError ? `: ${lastError}` : ""}`,
  );
}

async function launchUser(baseUrl, session) {
  const miniProgram = await automator.launch({ projectPath, cliPath });
  await miniProgram.reLaunch("/pages/moontown/home");
  let page = await miniProgram.currentPage();
  await page.setData({
    backendBaseUrl: baseUrl,
    bunniaSessionId: session,
    marketplaceSessionId: session,
  });
  return { miniProgram, page };
}

async function openPage(miniProgram, route, baseUrl, session, data = {}) {
  await miniProgram.reLaunch(route);
  const page = await miniProgram.currentPage();
  await page.setData({
    backendBaseUrl: baseUrl,
    bunniaSessionId: session,
    marketplaceSessionId: session,
    ...data,
  });
  return page;
}

async function tap(page, selector, label) {
  const element = await waitFor(label, () => page.$(selector), 30000);
  await element.tap();
  return element;
}

async function requestIds(page) {
  const cards = await page.$$(".moontown-marketplace-request");
  const ids = [];
  for (const card of cards) {
    const id = await card.attribute("data-request-id");
    if (id) ids.push(id);
  }
  return ids;
}

async function loadRequests(miniProgram, baseUrl, session) {
  const page = await openPage(
    miniProgram,
    "/pages/moontown/messages",
    baseUrl,
    session,
    { "messages.mode": "work", "messages.channel": "requests" },
  );
  await tap(
    page,
    '[data-bunnia-message="load-marketplace-action-requests"] button',
    "marketplace request refresh",
  );
  await waitFor("marketplace requests", async () => {
    const data = await page.data();
    return data.requestState && data.requestState.state === "ready";
  });
  return page;
}

const evidence = {
  contract_id: "moontown.two-user-ui-qualification.v1",
  started_at: new Date().toISOString(),
  listing_id: listingId,
  phases: [],
};

let active;
try {
  active = await launchUser(adaBaseUrl, adaSession);
  let page = await loadRequests(active.miniProgram, adaBaseUrl, adaSession);
  const requestsBefore = new Set(await requestIds(page));
  page = await openPage(
    active.miniProgram,
    "/pages/moontown/discover",
    adaBaseUrl,
    adaSession,
  );
  await tap(
    page,
    '[data-bunnia-message="load-marketplace-feed"] button',
    "Ada marketplace refresh",
  );
  await tap(page, `[data-listing-id="${listingId}"]`, "published agent card");
  await tap(page, 'button[aria-label="Request trial"]', "Ada Try action");
  await waitFor("Ada request confirmation", async () => {
    const data = await page.data();
    return data.requestState && data.requestState.state === "ready";
  });
  page = await loadRequests(active.miniProgram, adaBaseUrl, adaSession);
  const requestId = await waitFor("Ada newly created request", async () => {
    const cards = await page.$$(".moontown-marketplace-request");
    for (const card of cards) {
      const id = await card.attribute("data-request-id");
      if (!id || requestsBefore.has(id)) continue;
      const text = await card.text();
      if (text.includes(listingId)) return id;
    }
    return "";
  });
  evidence.request_id = requestId;
  evidence.phases.push({
    actor: "ada",
    action: "request",
    request_id: requestId,
    status: "passed",
  });
  await active.miniProgram.close();
  active = undefined;

  active = await launchUser(boBaseUrl, boSession);
  page = await loadRequests(active.miniProgram, boBaseUrl, boSession);
  const requestCard = await waitFor("Bo exact approval card", () =>
    page.$(`.moontown-marketplace-request[data-request-id="${requestId}"]`),
  );
  const request = await requestCard.$(
    '[data-bunnia-message="decide-marketplace-action-request"][data-decision="accept"]',
  );
  assert(request, `Bo cannot approve request ${requestId}`);
  const instruction = await request.$(
    'input[aria-label="Approved worker instruction"]',
  );
  if (instruction) {
    await instruction.input(
      "Create one concise reviewable onboarding note from the installed MoonBook with evidence references.",
    );
  }
  const approve = await request.$('button[aria-label="Approve & queue"]');
  assert(approve, "Bo approval button is missing");
  await approve.tap();
  await waitFor("Bo queued state", async () => {
    const item = await page.$(
      `.moontown-marketplace-request[data-request-id="${requestId}"]`,
    );
    if (!item) return false;
    const text = await item.text();
    return /queued|pending|acknowledged|running|succeeded/i.test(text);
  });
  const currentRequest = await page.$(
    `.moontown-marketplace-request[data-request-id="${requestId}"]`,
  );
  const retry = currentRequest
    ? await currentRequest.$('button[aria-label="Retry MoonClaw handoff"]')
    : null;
  if (retry) await retry.tap();
  evidence.phases.push({
    actor: "bo",
    action: "approve",
    request_id: requestId,
    status: "passed",
  });
  await active.miniProgram.close();
  active = undefined;

  active = await launchUser(adaBaseUrl, adaSession);
  page = await loadRequests(active.miniProgram, adaBaseUrl, adaSession);
  await waitFor("Ada completed receipt", async () => {
    const refresh = await page.$(
      '[data-bunnia-message="load-marketplace-action-requests"] button',
    );
    if (refresh) await refresh.tap();
    await sleep(500);
    const card = await page.$(
      `.moontown-marketplace-request[data-request-id="${requestId}"]`,
    );
    if (!card) return false;
    const text = await card.text();
    return /succeeded|completed/i.test(text);
  });
  evidence.phases.push({
    actor: "ada",
    action: "receipt",
    request_id: requestId,
    status: "passed",
  });
  evidence.status = "passed";
} catch (error) {
  evidence.status = "failed";
  evidence.error = String(error && error.stack ? error.stack : error);
  throw error;
} finally {
  evidence.finished_at = new Date().toISOString();
  await fs.mkdir(path.dirname(resultPath), { recursive: true });
  await fs.writeFile(resultPath, `${JSON.stringify(evidence, null, 2)}\n`);
  if (active) await active.miniProgram.close().catch(() => {});
}
