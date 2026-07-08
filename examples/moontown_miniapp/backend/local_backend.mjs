#!/usr/bin/env node
import { createServer } from "node:http";
import {
  existsSync,
  mkdirSync,
  readFileSync,
  rmSync,
  writeFileSync,
} from "node:fs";
import { dirname, resolve } from "node:path";

const DEFAULT_HOST = "127.0.0.1";
const DEFAULT_PORT = 18191;
const DEFAULT_STATE = "_build/moontown_miniapp/local_backend_state.json";

function seedState() {
  return {
    nextRun: 2,
    nextMessage: 2,
    nextReview: 2,
    users: [
      { id: "user-a", name: "Ada Builder", roleId: "builder" },
      { id: "user-b", name: "Bo Curator", roleId: "explorer" },
    ],
    profiles: [
      profile("user-a", "Ada Builder", "builder", "avatar://ada", true, true),
      profile("user-b", "Bo Curator", "explorer", "avatar://bo", true, true),
    ],
    shares: [],
    sessions: {},
    buildings: [
      building("policy-hall", "Policy Hall", "policy_hall", "published", "system", "Public policy answers and review routing.", ["policy", "review", "public"], 479, 388, "review"),
      building("private-agent-lab", "Private Agent Lab", "agent_lab", "private_draft", "user-a", "Draft agent creation space visible only to Ada.", ["agent", "private", "draft"], 432, 513, "draft"),
      building("team-studio", "Team Studio", "project_studio", "shared_private", "org-a", "Organization planning room shared by members.", ["team", "project", "shared"], 462, 468, "shared"),
      building("market-square", "Market Square", "market_square", "published", "system", "Published buildings can be searched and placed.", ["market", "public", "search"], 530, 592, "running"),
      building("review-council", "Review Council", "review_council", "published", "system", "Moderation and publishing decisions happen here.", ["review", "publish", "moderation"], 462, 341, "review"),
      building("knowledge-house", "Knowledge House", "knowledge_house", "published", "system", "Book-backed accepted memory for public queries.", ["book", "memory", "public"], 518, 430, "stable"),
      building("gateway", "System Gateway", "system_gateway", "published", "system", "Login, session, and safe backend handoff.", ["system", "login", "session"], 696, 556, "stable"),
      building("book-workshop", "Book Workshop", "knowledge_house", "shared_private", "org-a", "Team book review queue for accepted memories.", ["book", "team", "review"], 662, 415, "shared"),
      building("published-agent-lab", "Published Agent Lab", "agent_lab", "published", "user-b", "A public agent lab Ada can place on her map.", ["agent", "public", "place"], 538, 528, "stable"),
    ],
    placements: [
      placement("placement-user-a-policy-hall", "policy-hall", "user-a", "personal", 479, 388, "pinned", "starter-map"),
    ],
    books: [
      book("book-policy-hall", "policy-hall", "Policy Hall Book", "system", "published", "Accepted public policy memory.", 12, 1, "review"),
      book("book-policy-hall-sources", "policy-hall", "Policy Source Shelf", "system", "published", "Public support sources used by Policy Hall answers.", 9, 0, "stable"),
      book("book-private-agent-lab", "private-agent-lab", "Private Agent Lab Book", "user-a", "private_draft", "Private draft memory.", 0, 0, "draft"),
      book("book-team-studio", "team-studio", "Team Studio Book", "org-a", "shared_private", "Shared organization memory.", 3, 0, "shared"),
      book("book-published-agent-lab", "published-agent-lab", "Published Agent Lab Book", "user-b", "published", "Public agent lab memory.", 8, 0, "stable"),
    ],
    agents: [
      { id: "agent-policy-guide", name: "Policy Guide", buildingId: "policy-hall", status: "waiting-review" },
      { id: "agent-builder", name: "Builder", buildingId: "private-agent-lab", status: "idle" },
    ],
    messages: [
      { id: "msg-welcome", actorId: "agent-policy-guide", threadId: "thread-policy-hall", text: "Policy Hall can answer public review questions.", status: "done" },
    ],
    runs: [
      { id: "run-policy-review", agentId: "agent-policy-guide", buildingId: "policy-hall", bookId: "book-policy-hall", threadId: "thread-policy-hall", title: "Policy answer review", summary: "One accepted answer is waiting for book review.", status: "review", reviewRequired: true, artifactRef: "artifact://book-policy-hall" },
    ],
    reviews: [
      { id: "review-policy-memory", runId: "run-policy-review", buildingId: "policy-hall", bookId: "book-policy-hall", title: "Review policy answer", summary: "Accept this answer into Policy Hall Book.", artifactRef: "artifact://book-policy-hall", reviewerId: "user-a", status: "pending", acceptedMemoryDelta: 1 },
    ],
    notifications: [
      { id: "notice-review", kind: "review", title: "Review waiting", body: "Policy answer needs approval.", targetRef: "thread-policy-hall", buildingId: "policy-hall", unread: true },
      { id: "notice-subscribe", kind: "subscription", title: "Subscribe to town signals", body: "Receive important mini-app notices.", targetRef: "subscription:wechat", buildingId: "", unread: true },
    ],
    auditEvents: [
      audit("audit-policy-review", "review", "Policy answer entered review", "Agent output is held until a reviewer accepts it into the book.", "agent-policy-guide", "run:run-policy-review", "policy-hall", "review", "published"),
    ],
  };
}

function building(id, title, kind, visibility, ownerId, summary, tags, x, y, status) {
  return { id, title, kind, visibility, ownerId, summary, tags, x, y, status };
}

function book(id, buildingId, title, ownerId, visibility, summary, acceptedMemoryCount, pendingReviewCount, status) {
  return { id, buildingId, title, ownerId, visibility, summary, acceptedMemoryCount, pendingReviewCount, status };
}

function placement(id, buildingId, ownerId, layer, x, y, status, source) {
  return { id, buildingId, ownerId, layer, x, y, status, source };
}

function profile(userId, displayName, roleId, avatarRef, consentAccepted, setupCompleted) {
  return { userId, displayName, roleId, avatarRef, consentAccepted, setupCompleted };
}

function shareGrant(id, buildingId, ownerId, targetUserId, scope, status) {
  return { id, buildingId, ownerId, targetUserId, scope, status };
}

function audit(id, kind, title, summary, actorId, targetRef, buildingId, status, visibility) {
  return { id, kind, title, summary, actorId, targetRef, buildingId, status, visibility, timestamp: new Date().toISOString() };
}

function parseArgs(argv) {
  const out = {
    host: DEFAULT_HOST,
    port: DEFAULT_PORT,
    statePath: resolve(DEFAULT_STATE),
    resetState: false,
    smoke: false,
  };
  for (let i = 0; i < argv.length; i += 1) {
    const arg = argv[i];
    if (arg === "--host") out.host = argv[++i] || out.host;
    else if (arg === "--port") out.port = Number(argv[++i] || out.port);
    else if (arg === "--state") out.statePath = resolve(argv[++i] || out.statePath);
    else if (arg === "--reset-state") out.resetState = true;
    else if (arg === "--smoke") out.smoke = true;
    else if (arg === "--help" || arg === "-h") {
      printHelp();
      process.exit(0);
    }
  }
  return out;
}

function printHelp() {
  console.log(`Moontown mini-app local backend

Usage:
  node examples/moontown_miniapp/backend/local_backend.mjs [--host 127.0.0.1] [--port 18191]
  node examples/moontown_miniapp/backend/local_backend.mjs --smoke

Options:
  --state PATH       JSON state file. Default: ${DEFAULT_STATE}
  --reset-state      Reset the state file before serving.
  --smoke            Run a deterministic route smoke test and exit.
`);
}

function loadState(statePath, resetState = false) {
  if (resetState && existsSync(statePath)) rmSync(statePath);
  if (!existsSync(statePath)) {
    const state = seedState();
    saveState(statePath, state);
    return state;
  }
  return normalizeState(JSON.parse(readFileSync(statePath, "utf8")));
}

function normalizeState(state) {
  state.users = state.users || [];
  state.profiles = state.profiles || [];
  state.shares = state.shares || [];
  state.sessions = state.sessions || {};
  for (const user of state.users) {
    ensureProfile(state, user.id, { displayName: user.name, roleId: user.roleId, setupCompleted: true, consentAccepted: true });
  }
  return state;
}

function saveState(statePath, state) {
  mkdirSync(dirname(statePath), { recursive: true });
  writeFileSync(statePath, `${JSON.stringify(state, null, 2)}\n`);
}

async function readJsonBody(req) {
  const chunks = [];
  for await (const chunk of req) chunks.push(chunk);
  const text = Buffer.concat(chunks).toString("utf8").trim();
  if (!text) return {};
  return JSON.parse(text);
}

function viewerFromRequest(state, headers, body = {}) {
  const token = headers["x-miniapp-session"] || headers["X-Miniapp-Session"];
  if (token && state.sessions[token]) return state.sessions[token].userId;
  return body.userId || "user-a";
}

function dispatch(state, request) {
  const method = request.method.toUpperCase();
  const path = request.path;
  const body = request.body || {};
  const viewer = viewerFromRequest(state, request.headers || {}, body);

  if (method === "GET" && path === "/miniapp/routes") {
    return ok({ routes: routeCatalog() });
  }
  if (method === "POST" && path === "/miniapp/auth/dev-login") {
    const userId = body.userId || "user-a";
    const profileItem = ensureProfile(state, userId, {
      displayName: body.displayName,
      roleId: body.roleId,
      avatarRef: body.avatarRef,
    });
    const sessionId = `session-${userId}`;
    state.sessions[sessionId] = { id: sessionId, userId };
    return changed({ session: { id: sessionId, userId }, profile: profileItem });
  }
  if (method === "GET" && path === "/miniapp/town/snapshot") {
    return ok(snapshotFor(state, viewer));
  }
  if (method === "GET" && path === "/miniapp/me/ownership") {
    return ok(ownershipFor(state, viewer));
  }
  if (method === "GET" && path === "/miniapp/discover/search") {
    return ok({ query: request.query.get("query") || body.query || "", items: discoverItems(state, viewer, request.query.get("query") || body.query || "") });
  }
  if (method === "POST" && path === "/miniapp/me/profile") {
    return changed({ profile: saveProfile(state, viewer, body) });
  }
  if (method === "POST" && path === "/miniapp/buildings") {
    return createBuilding(state, viewer, body);
  }
  if (method === "POST" && path === "/miniapp/buildings/place") {
    return placeBuilding(state, viewer, body);
  }
  if (method === "POST" && path === "/miniapp/buildings/share") {
    return changeBuildingVisibility(state, viewer, body.buildingId, "shared_private", "shared", "share", body.targetUserId || "org-a");
  }
  if (method === "POST" && path === "/miniapp/buildings/publish") {
    return changeBuildingVisibility(state, viewer, body.buildingId, "published", "stable", "publish", "town");
  }
  if (method === "POST" && path === "/miniapp/buildings/archive") {
    return changeBuildingVisibility(state, viewer, body.buildingId, "archived", "archived", "archive", "archive");
  }
  if (method === "POST" && path === "/miniapp/buildings/restore") {
    return changeBuildingVisibility(state, viewer, body.buildingId, "private_draft", "draft", "restore", "draft");
  }
  if (method === "POST" && path === "/miniapp/buildings/query") {
    return askBuilding(state, viewer, body);
  }
  if (method === "POST" && path === "/miniapp/runs/cancel") {
    return changeRunStatus(state, body.runId, "cancelled");
  }
  if (method === "POST" && path === "/miniapp/runs/retry") {
    return changeRunStatus(state, body.runId, "running");
  }
  if (method === "POST" && path === "/miniapp/reviews/accept") {
    return decideReview(state, body.reviewId, "accepted");
  }
  if (method === "POST" && path === "/miniapp/reviews/reject") {
    return decideReview(state, body.reviewId, "rejected");
  }
  if (method === "POST" && path === "/miniapp/messages/ack") {
    const notice = state.notifications.find((item) => item.id === body.noticeId);
    if (notice) notice.unread = false;
    return changed({ noticeId: body.noticeId, state: "acknowledged" });
  }
  if (method === "POST" && path === "/miniapp/messages/subscribe") {
    return changed({ targetRef: body.targetRef || "subscription:wechat", state: "requested" });
  }
  if (method === "POST" && path === "/miniapp/agents") {
    const agent = { id: body.id || `agent-${state.agents.length + 1}`, name: body.displayName || "Created Agent", buildingId: body.buildingId || "private-agent-lab", status: "idle" };
    state.agents.push(agent);
    return changed({ agent });
  }
  return { status: 404, changed: false, body: { error: "not_found", path, method } };
}

function ok(body) {
  return { status: 200, changed: false, body };
}

function changed(body) {
  return { status: 200, changed: true, body };
}

function routeCatalog() {
  return [
    "POST /miniapp/auth/dev-login",
    "GET /miniapp/town/snapshot",
    "GET /miniapp/me/ownership",
    "GET /miniapp/discover/search",
    "POST /miniapp/me/profile",
    "POST /miniapp/buildings",
    "POST /miniapp/buildings/place",
    "POST /miniapp/buildings/share",
    "POST /miniapp/buildings/publish",
    "POST /miniapp/buildings/archive",
    "POST /miniapp/buildings/restore",
    "POST /miniapp/buildings/query",
    "POST /miniapp/runs/cancel",
    "POST /miniapp/runs/retry",
    "POST /miniapp/reviews/accept",
    "POST /miniapp/reviews/reject",
    "POST /miniapp/messages/ack",
    "POST /miniapp/messages/subscribe",
    "POST /miniapp/agents",
  ];
}

function profileFor(state, userId) {
  return ensureProfile(state, userId, {});
}

function ensureProfile(state, userId, draft) {
  let user = state.users.find((item) => item.id === userId);
  const displayName = draft.displayName || draft.name || (user ? user.name : titleizeUser(userId));
  const roleId = draft.roleId || (user ? user.roleId : "builder");
  if (!user) {
    user = { id: userId, name: displayName, roleId };
    state.users.push(user);
  }
  let profileItem = state.profiles.find((item) => item.userId === userId);
  if (!profileItem) {
    profileItem = profile(
      userId,
      displayName,
      roleId,
      draft.avatarRef || `avatar://${userId}`,
      Boolean(draft.consentAccepted),
      Boolean(draft.setupCompleted),
    );
    state.profiles.push(profileItem);
  }
  user.name = profileItem.displayName;
  user.roleId = profileItem.roleId;
  return profileItem;
}

function saveProfile(state, userId, draft) {
  const profileItem = ensureProfile(state, userId, draft);
  profileItem.displayName = draft.displayName || profileItem.displayName;
  profileItem.roleId = draft.roleId || profileItem.roleId;
  profileItem.avatarRef = draft.avatarRef || profileItem.avatarRef;
  profileItem.consentAccepted = Boolean(draft.consentAccepted);
  profileItem.setupCompleted = true;
  const user = state.users.find((item) => item.id === userId);
  if (user) {
    user.name = profileItem.displayName;
    user.roleId = profileItem.roleId;
  }
  return profileItem;
}

function titleizeUser(userId) {
  return String(userId || "user").split("-").filter(Boolean).map((part) => part.slice(0, 1).toUpperCase() + part.slice(1)).join(" ") || "Local User";
}

function visibleBuildings(state, viewer) {
  return state.buildings.filter((item) => canSeeBuilding(state, item, viewer));
}

function canSeeBuilding(state, item, viewer) {
  return item.visibility !== "archived" && (
    item.visibility === "published" ||
    item.ownerId === viewer ||
    item.ownerId === "org-a" ||
    (item.visibility === "shared_private" && isBuildingSharedWith(state, item.id, viewer))
  );
}

function isBuildingSharedWith(state, buildingId, viewer) {
  return state.shares.some((item) => item.buildingId === buildingId && item.targetUserId === viewer && item.status === "active");
}

function visiblePlacements(state, viewer) {
  return state.placements.filter((item) => item.ownerId === viewer || item.ownerId === "org-a" || item.layer === "town_public");
}

function visibleBooks(state, viewer) {
  const visibleBuildingIds = new Set(visibleBuildings(state, viewer).map((item) => item.id));
  return state.books.filter((item) => item.visibility === "published" || item.ownerId === viewer || item.ownerId === "org-a" || visibleBuildingIds.has(item.buildingId));
}

function snapshotFor(state, viewer) {
  const buildings = visibleBuildings(state, viewer);
  return {
    viewer,
    profile: profileFor(state, viewer),
    users: state.users,
    buildings,
    placements: visiblePlacements(state, viewer),
    books: visibleBooks(state, viewer),
    agents: state.agents.filter((item) => buildings.some((building) => building.id === item.buildingId)),
    runs: state.runs.filter((item) => buildings.some((building) => building.id === item.buildingId)),
    reviews: state.reviews.filter((item) => item.reviewerId === viewer),
    messages: state.messages,
    notifications: state.notifications,
    shares: state.shares.filter((item) => item.ownerId === viewer || item.targetUserId === viewer),
    auditEvents: state.auditEvents.filter((item) => item.visibility === "published" || item.actorId === viewer || buildings.some((building) => building.id === item.buildingId)),
  };
}

function ownershipFor(state, viewer) {
  const profile = profileFor(state, viewer);
  const buildings = state.buildings.filter((item) => item.ownerId === viewer || item.ownerId === "org-a" || (item.visibility === "shared_private" && isBuildingSharedWith(state, item.id, viewer)));
  const placements = visiblePlacements(state, viewer);
  const buildingIds = new Set(buildings.map((item) => item.id));
  const books = state.books.filter((item) => item.ownerId === viewer || item.ownerId === "org-a" || buildingIds.has(item.buildingId));
  const agents = state.agents.filter((item) => buildingIds.has(item.buildingId));
  const reviews = state.reviews.filter((item) => item.reviewerId === viewer);
  const retryableRuns = state.runs.filter((item) => buildingIds.has(item.buildingId) && ["failed", "rejected", "cancelled"].includes(item.status));
  const stats = [
    { id: "buildings", label: "Buildings", value: buildings.length },
    { id: "placements", label: "Placed", value: placements.length },
    { id: "drafts", label: "Drafts", value: buildings.filter((item) => item.visibility === "private_draft").length },
    { id: "published", label: "Published", value: buildings.filter((item) => item.visibility === "published").length },
    { id: "books", label: "Books", value: books.length },
    { id: "agents", label: "Agents", value: agents.length },
  ];
  const items = [
    ...buildings.map((item) => ownedItem("building", item.id, item.title, item.summary, `building:${item.id}`, item.visibility, item.status, actionForVisibility(item.visibility))),
    ...placements.map((item) => {
      const buildingItem = state.buildings.find((building) => building.id === item.buildingId);
      const title = buildingItem ? buildingItem.title : item.buildingId;
      return ownedItem("placement", item.id, title, `${item.layer} map pin from ${item.source}.`, `placement:${item.id}`, item.layer, item.status, "Open");
    }),
    ...books.map((item) => ownedItem("book", item.id, item.title, item.summary, `book:${item.id}`, item.visibility, item.status, "Review")),
    ...agents.map((item) => ownedItem("agent", item.id, item.name, `Agent attached to ${item.buildingId}.`, `agent:${item.id}`, "owned", item.status, "Open")),
  ];
  const alerts = [];
  if (!profile.setupCompleted || !profile.consentAccepted) {
    alerts.push({ id: "profile-setup", severity: "high", title: "Town passport incomplete", summary: "Finish identity setup before publishing.", targetRef: "profile:setup", action: "save-profile", status: "blocked" });
  }
  const blockedDrafts = buildings.filter((item) => item.visibility === "private_draft").length;
  if (blockedDrafts > 0) {
    alerts.push({ id: "blocked-publication", severity: "medium", title: `${blockedDrafts} draft blocked from town`, summary: "Publish requires profile, consent, and review readiness.", targetRef: "building:drafts", action: "ownership-filter-drafts", status: "blocked" });
  }
  if (retryableRuns.length > 0) {
    alerts.push({ id: "retryable-runs", severity: "medium", title: `${retryableRuns.length} agent run can retry`, summary: "Retry failed or cancelled agent work from Messages.", targetRef: "messages:runs", action: "message-channel-runs", status: "retry" });
  }
  const shares = state.shares.filter((item) => item.ownerId === viewer || item.targetUserId === viewer);
  return { viewer, profile, stats, items, alerts, reviews, shares };
}

function ownedItem(kind, id, title, summary, targetRef, visibility, status, actionLabel) {
  return { id, kind, title, summary, targetRef, visibility, status, actionLabel };
}

function actionForVisibility(visibility) {
  if (visibility === "private_draft") return "Publish";
  if (visibility === "shared_private") return "Review";
  if (visibility === "published") return "Place";
  if (visibility === "archived") return "Restore";
  return "Open";
}

function discoverItems(state, viewer, query) {
  const needle = String(query || "").toLowerCase();
  return visibleBuildings(state, viewer)
    .filter((item) => item.visibility === "published")
    .filter((item) => matches(item, needle))
    .map((item) => ({ id: `building-${item.id}`, kind: "building", title: item.title, summary: item.summary, targetRef: `building:${item.id}`, visibility: item.visibility, status: item.status }));
}

function matches(item, needle) {
  return !needle || item.title.toLowerCase().includes(needle) || item.summary.toLowerCase().includes(needle) || item.tags.some((tag) => tag.toLowerCase().includes(needle));
}

function createBuilding(state, viewer, body) {
  const id = body.id || `building-${state.buildings.length + 1}`;
  const title = body.title || "Created Building";
  const item = building(id, title, "agent_lab", "private_draft", viewer, "Local private building created from WeChat DevTools.", body.tags || ["agent", "local"], 432, 513, "draft");
  const memory = book(`book-${id}`, id, `${title} Book`, viewer, "private_draft", "Private book memory created with this building.", 0, 0, "draft");
  state.buildings.push(item);
  state.books.push(memory);
  state.auditEvents.push(audit(`audit-create-${id}`, "create", `${title} created`, "Private building and book were created locally.", viewer, `building:${id}`, id, "draft", "private_draft"));
  return changed({ building: item, book: memory });
}

function placeBuilding(state, viewer, body) {
  const buildingId = body.buildingId;
  const item = state.buildings.find((building) => building.id === buildingId && building.visibility === "published");
  if (!item) return { status: 403, changed: false, body: { error: "not_placeable", buildingId } };
  const id = `placement-${viewer}-${buildingId}`;
  let pin = state.placements.find((placementItem) => placementItem.id === id);
  if (!pin) {
    pin = placement(id, buildingId, viewer, "personal", body.x || item.x, body.y || item.y, "pinned", "discover");
    state.placements.push(pin);
  }
  state.auditEvents.push(audit(`audit-place-${buildingId}`, "place", `${item.title} placed`, "A public building was placed onto this user's map layer.", viewer, `placement:${id}`, buildingId, "stable", "published"));
  return changed({ placement: pin, building: item });
}

function changeBuildingVisibility(state, viewer, buildingId, visibility, status, kind, target) {
  const item = state.buildings.find((building) => building.id === buildingId);
  if (!item) return { status: 404, changed: false, body: { error: "missing_building", buildingId } };
  if (item.ownerId !== viewer && item.ownerId !== "org-a") return { status: 403, changed: false, body: { error: "owner_only", buildingId } };
  let grant = null;
  if (kind === "share" && target !== "org-a") {
    ensureProfile(state, target, {});
    grant = upsertShareGrant(state, item, viewer, target);
  }
  item.visibility = visibility;
  item.status = status;
  for (const memory of state.books) {
    if (memory.buildingId === buildingId) {
      memory.visibility = visibility;
      memory.status = status;
    }
  }
  state.auditEvents.push(audit(`audit-${kind}-${buildingId}`, kind, `${item.title} ${kind}`, `Visibility changed for ${target}.`, viewer, `building:${buildingId}`, buildingId, status, visibility));
  return changed(grant ? { building: item, share: grant } : { building: item });
}

function upsertShareGrant(state, building, ownerId, targetUserId) {
  const id = `share-${building.id}-${targetUserId}`;
  let grant = state.shares.find((item) => item.id === id);
  if (!grant) {
    grant = shareGrant(id, building.id, ownerId, targetUserId, "user", "active");
    state.shares.push(grant);
  } else {
    grant.ownerId = ownerId;
    grant.status = "active";
  }
  return grant;
}

function askBuilding(state, viewer, body) {
  const buildingId = body.buildingId || "policy-hall";
  const item = visibleBuildings(state, viewer).find((building) => building.id === buildingId);
  if (!item) return { status: 403, changed: false, body: { error: "building_not_visible", buildingId } };
  const runId = `run-local-${state.nextRun++}`;
  const messageId = `msg-local-${state.nextMessage++}`;
  const reviewId = `review-local-${state.nextReview++}`;
  const bookId = body.bookId || `book-${buildingId}`;
  const run = { id: runId, agentId: "agent-policy-guide", buildingId, bookId, threadId: `thread-${buildingId}`, title: `${item.title} answer`, summary: body.body || "Local question", status: "review", reviewRequired: true, artifactRef: `artifact://${bookId}` };
  const message = { id: messageId, actorId: "agent-policy-guide", threadId: run.threadId, text: "Local answer recorded as a reviewable run.", status: "waiting-review" };
  const review = { id: reviewId, runId, buildingId, bookId, title: "Review local answer", summary: "Accept this local answer into building memory.", artifactRef: run.artifactRef, reviewerId: viewer, status: "pending", acceptedMemoryDelta: 1 };
  state.runs.push(run);
  state.messages.push(message);
  state.reviews.push(review);
  state.notifications.push({ id: `notice-${reviewId}`, kind: "review", title: "Review waiting", body: review.summary, targetRef: run.threadId, buildingId, unread: true });
  return changed({ run, message, review });
}

function changeRunStatus(state, runId, status) {
  const run = state.runs.find((item) => item.id === runId) || state.runs[state.runs.length - 1];
  if (!run) return { status: 404, changed: false, body: { error: "missing_run", runId } };
  run.status = status;
  if (status === "running") run.reviewRequired = false;
  return changed({ run });
}

function decideReview(state, reviewId, decision) {
  const review = state.reviews.find((item) => item.id === reviewId) || state.reviews.find((item) => item.status === "pending");
  if (!review) return { status: 404, changed: false, body: { error: "missing_review", reviewId } };
  review.status = decision;
  const run = state.runs.find((item) => item.id === review.runId);
  if (run) {
    run.status = decision === "accepted" ? "done" : "rejected";
    run.reviewRequired = false;
  }
  const memory = state.books.find((item) => item.id === review.bookId);
  if (memory && decision === "accepted") {
    memory.acceptedMemoryCount += review.acceptedMemoryDelta || 1;
    memory.pendingReviewCount = Math.max(0, memory.pendingReviewCount - 1);
    memory.status = "stable";
  }
  return changed({ review, run, book: memory });
}

async function serve(options) {
  const state = loadState(options.statePath, options.resetState);
  const server = createServer(async (req, res) => {
    try {
      if (req.method === "OPTIONS") return send(res, 204, {});
      const url = new URL(req.url || "/", `http://${options.host}:${options.port}`);
      const body = req.method === "GET" ? {} : await readJsonBody(req);
      const result = dispatch(state, { method: req.method || "GET", path: url.pathname, query: url.searchParams, headers: req.headers, body });
      if (result.changed) saveState(options.statePath, state);
      return send(res, result.status, result.body);
    } catch (error) {
      return send(res, 500, { error: "backend_error", message: String(error && error.message ? error.message : error) });
    }
  });
  server.listen(options.port, options.host, () => {
    console.log(`moontown-miniapp-backend listening http://${options.host}:${options.port}`);
    console.log(`state=${options.statePath}`);
  });
}

function send(res, status, body) {
  res.writeHead(status, {
    "content-type": "application/json; charset=utf-8",
    "access-control-allow-origin": "*",
    "access-control-allow-methods": "GET,POST,OPTIONS",
    "access-control-allow-headers": "content-type,x-miniapp-session",
  });
  res.end(status === 204 ? "" : `${JSON.stringify(body)}\n`);
}

function smoke(options) {
  const statePath = options.statePath.includes("local_backend_state")
    ? resolve("_build/moontown_miniapp/local_backend_smoke_state.json")
    : options.statePath;
  if (existsSync(statePath)) rmSync(statePath);
  const state = loadState(statePath, true);
  const login = dispatch(state, { method: "POST", path: "/miniapp/auth/dev-login", query: new URLSearchParams(), headers: {}, body: { userId: "user-a" } });
  assert(login.body.session.id === "session-user-a", "login session");
  const headers = { "x-miniapp-session": login.body.session.id };
  const registered = dispatch(state, { method: "POST", path: "/miniapp/auth/dev-login", query: new URLSearchParams(), headers: {}, body: { userId: "user-c", displayName: "Chen Mapper" } });
  assert(registered.body.profile.displayName === "Chen Mapper", "register profile");
  assert(registered.body.profile.setupCompleted === false, "register starts incomplete");
  const registeredHeaders = { "x-miniapp-session": registered.body.session.id };
  const savedProfile = dispatch(state, { method: "POST", path: "/miniapp/me/profile", query: new URLSearchParams(), headers: registeredHeaders, body: { displayName: "Chen Cartographer", roleId: "explorer", avatarRef: "avatar://chen", consentAccepted: true } });
  assert(savedProfile.body.profile.displayName === "Chen Cartographer", "save profile name");
  assert(savedProfile.body.profile.setupCompleted === true, "save profile setup");
  const registeredSnapshot = dispatch(state, { method: "GET", path: "/miniapp/town/snapshot", query: new URLSearchParams(), headers: registeredHeaders, body: {} });
  assert(registeredSnapshot.body.profile.displayName === "Chen Cartographer", "snapshot saved profile");
  assert(registeredSnapshot.body.users.some((item) => item.id === "user-c" && item.name === "Chen Cartographer"), "registered user list");
  const bobLogin = dispatch(state, { method: "POST", path: "/miniapp/auth/dev-login", query: new URLSearchParams(), headers: {}, body: { userId: "user-b" } });
  const bobHeaders = { "x-miniapp-session": bobLogin.body.session.id };
  const sharedDraft = dispatch(state, { method: "POST", path: "/miniapp/buildings", query: new URLSearchParams(), headers, body: { id: "shared-lab", title: "Shared Lab" } });
  assert(sharedDraft.body.building.visibility === "private_draft", "create shared draft");
  const shared = dispatch(state, { method: "POST", path: "/miniapp/buildings/share", query: new URLSearchParams(), headers, body: { buildingId: "shared-lab", targetUserId: "user-b" } });
  assert(shared.body.share.targetUserId === "user-b", "share target");
  assert(shared.body.building.visibility === "shared_private", "share visibility");
  const bobSnapshot = dispatch(state, { method: "GET", path: "/miniapp/town/snapshot", query: new URLSearchParams(), headers: bobHeaders, body: {} });
  assert(bobSnapshot.body.buildings.some((item) => item.id === "shared-lab"), "invited user sees shared building");
  const chenSnapshot = dispatch(state, { method: "GET", path: "/miniapp/town/snapshot", query: new URLSearchParams(), headers: registeredHeaders, body: {} });
  assert(!chenSnapshot.body.buildings.some((item) => item.id === "shared-lab"), "uninvited user cannot see shared building");
  const privateSearch = dispatch(state, { method: "GET", path: "/miniapp/discover/search", query: new URLSearchParams("query=shared"), headers: bobHeaders, body: {} });
  assert(!privateSearch.body.items.some((item) => item.targetRef === "building:shared-lab"), "shared private hidden from public search");
  const created = dispatch(state, { method: "POST", path: "/miniapp/buildings", query: new URLSearchParams(), headers, body: { id: "smoke-lab", title: "Smoke Lab" } });
  assert(created.body.building.visibility === "private_draft", "create draft");
  dispatch(state, { method: "POST", path: "/miniapp/buildings/publish", query: new URLSearchParams(), headers, body: { buildingId: "smoke-lab" } });
  const archived = dispatch(state, { method: "POST", path: "/miniapp/buildings/archive", query: new URLSearchParams(), headers, body: { buildingId: "smoke-lab" } });
  assert(archived.body.building.visibility === "archived", "archive building");
  const restored = dispatch(state, { method: "POST", path: "/miniapp/buildings/restore", query: new URLSearchParams(), headers, body: { buildingId: "smoke-lab" } });
  assert(restored.body.building.visibility === "private_draft", "restore building");
  dispatch(state, { method: "POST", path: "/miniapp/buildings/publish", query: new URLSearchParams(), headers, body: { buildingId: "smoke-lab" } });
  const search = dispatch(state, { method: "GET", path: "/miniapp/discover/search", query: new URLSearchParams("query=smoke"), headers, body: {} });
  assert(search.body.items.some((item) => item.targetRef === "building:smoke-lab"), "published search");
  const placed = dispatch(state, { method: "POST", path: "/miniapp/buildings/place", query: new URLSearchParams(), headers, body: { buildingId: "published-agent-lab" } });
  assert(placed.body.placement.buildingId === "published-agent-lab", "place building");
  const asked = dispatch(state, { method: "POST", path: "/miniapp/buildings/query", query: new URLSearchParams(), headers, body: { buildingId: "policy-hall", body: "smoke?" } });
  assert(asked.body.review.status === "pending", "query review");
  const accepted = dispatch(state, { method: "POST", path: "/miniapp/reviews/accept", query: new URLSearchParams(), headers, body: { reviewId: asked.body.review.id } });
  assert(accepted.body.review.status === "accepted", "accept review");
  const snapshot = dispatch(state, { method: "GET", path: "/miniapp/town/snapshot", query: new URLSearchParams(), headers, body: {} });
  assert(snapshot.body.placements.length >= 2, "snapshot placements");
  const ownership = dispatch(state, { method: "GET", path: "/miniapp/me/ownership", query: new URLSearchParams(), headers, body: {} });
  assert(ownership.body.items.some((item) => item.targetRef === "building:smoke-lab"), "ownership building");
  assert(ownership.body.stats.some((item) => item.id === "books" && item.value >= 1), "ownership books");
  saveState(statePath, state);
  rmSync(statePath);
  console.log("moontown-miniapp-backend smoke ok");
}

function assert(condition, label) {
  if (!condition) throw new Error(`smoke failed: ${label}`);
}

const options = parseArgs(process.argv.slice(2));
if (options.smoke) {
  smoke(options);
} else {
  serve(options);
}
