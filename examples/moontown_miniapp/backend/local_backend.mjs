#!/usr/bin/env node
import { createServer } from "node:http";
import { randomUUID } from "node:crypto";
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
const SESSION_TTL_MS = 12 * 60 * 60 * 1000;
const RATE_LIMIT_WINDOW_MS = 60 * 1000;
const RATE_LIMITS = {
  "/miniapp/auth/dev-login": 12,
  "/miniapp/moderation/report": 2,
  "/miniapp/moderation/appeal": 2,
};

function seedState() {
  return {
    nextRun: 2,
    nextMessage: 2,
    nextReview: 2,
    nextModeration: 2,
    users: [
      { id: "user-a", name: "Ada Builder", roleId: "builder" },
      { id: "user-b", name: "Bo Curator", roleId: "explorer" },
    ],
    profiles: [
      profile("user-a", "Ada Builder", "builder", "avatar://ada", true, true),
      profile("user-b", "Bo Curator", "explorer", "avatar://bo", true, true),
    ],
    moderatorIds: ["user-a"],
    shares: [],
    sessions: {},
    rateLimits: {},
    listings: defaultListings(),
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
    bookMemories: [
      bookMemory("memory-policy-public-1", "book-policy-hall", "policy-hall", "Public policy memory seed", "Seeded accepted public memory for Policy Hall.", "system", "review-policy-memory", "run-policy-review", "published"),
    ],
    agents: [
      { id: "agent-policy-guide", name: "Policy Guide", buildingId: "policy-hall", status: "waiting-review" },
      { id: "agent-builder", name: "Builder", buildingId: "private-agent-lab", status: "idle" },
    ],
    threads: [
      thread("thread-policy-hall", "policy-hall", "Policy Hall Thread", "system", "published", "review"),
      thread("thread-market-square", "market-square", "Market Square Thread", "system", "published", "running"),
      thread("thread-private-agent-lab", "private-agent-lab", "Private Agent Lab Thread", "user-a", "private_draft", "draft"),
    ],
    messages: [
      { id: "msg-welcome", actorId: "agent-policy-guide", threadId: "thread-policy-hall", text: "Policy Hall can answer public review questions.", status: "done" },
    ],
    runs: [
      { id: "run-policy-review", agentId: "agent-policy-guide", buildingId: "policy-hall", bookId: "book-policy-hall", threadId: "thread-policy-hall", title: "Policy answer review", summary: "One accepted answer is waiting for book review.", status: "review", reviewRequired: true, artifactRef: "artifact://book-policy-hall" },
    ],
    toolResults: [
      { id: "tool-policy-summary", toolName: "book-summarizer", buildingId: "policy-hall", threadId: "thread-policy-hall", title: "Policy source summary", summary: "Summarized 9 public source notes for the pending policy answer.", artifactRef: "artifact://book-policy-hall-sources", status: "waiting-review", openMessage: "open-tool-policy-summary", acknowledgeMessage: "ack-tool-result" },
      { id: "tool-market-scan", toolName: "placement-scanner", buildingId: "market-square", threadId: "thread-market-square", title: "Placement scan artifact", summary: "Found reusable public buildings that can be pinned into the town map.", artifactRef: "artifact://market-square", status: "running", openMessage: "open-tool-market-scan", acknowledgeMessage: "ack-tool-result" },
    ],
    reviews: [
      { id: "review-policy-memory", runId: "run-policy-review", buildingId: "policy-hall", bookId: "book-policy-hall", title: "Review policy answer", summary: "Accept this answer into Policy Hall Book.", artifactRef: "artifact://book-policy-hall", reviewerId: "user-a", status: "pending", acceptedMemoryDelta: 1 },
    ],
    moderationCases: [
      { id: "mod-policy-hall", buildingId: "policy-hall", reporterId: "user-a", targetRef: "building:policy-hall", title: "Policy Hall safety watch", summary: "Reports become review-council cases before hide or takedown.", status: "watch", actionLabel: "Review", actionMessage: "tab-messages" },
    ],
    notifications: [
      { id: "notice-review", kind: "review", title: "Review waiting", body: "Policy answer needs approval.", targetRef: "thread-policy-hall", buildingId: "policy-hall", unread: true },
      { id: "notice-subscribe", kind: "subscription", title: "Subscribe to town signals", body: "Receive important mini-app notices.", targetRef: "subscription:wechat", buildingId: "", unread: true },
    ],
    notificationStates: [],
    subscriptions: [],
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

function bookMemory(id, bookId, buildingId, title, safeSummary, authorId, reviewId, runId, visibility) {
  return { id, bookId, buildingId, title, safeSummary, authorId, reviewId, runId, visibility, status: "accepted", timestamp: new Date().toISOString() };
}

function thread(id, buildingId, title, ownerId, visibility, status) {
  return { id, buildingId, title, ownerId, visibility, status, unreadCount: 0, updatedAt: new Date().toISOString() };
}

function notificationState(userId, noticeId, unread, state) {
  return { id: `notice-state-${userId}-${noticeId}`, userId, noticeId, unread, state, updatedAt: new Date().toISOString() };
}

function subscription(id, userId, targetRef, noticeId, status) {
  return { id, userId, targetRef, noticeId, status, updatedAt: new Date().toISOString() };
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

function listing(id, kind, title, summary, targetRef, visibility, status) {
  return { id, kind, title, summary, targetRef, visibility, status };
}

function defaultListings() {
  return [
    listing("product-agent-publishing-kit", "product", "Agent Publishing Kit", "Reusable workflow kit for publishing reviewed agent buildings.", "product:agent-publishing-kit", "published", "stable"),
    listing("demand-review-council", "demand", "Review Demand", "Human approval needed before agent output becomes memory.", "demand:review-council", "published", "review"),
    listing("event-team-studio", "event", "Team Studio Session", "Shared organization agent session for map and book planning.", "event:team-studio", "published", "shared"),
    listing("post-agent-lab-field-note", "post", "Agent Lab Field Note", "A public note about placing published agent buildings.", "post:published-agent-lab", "published", "stable"),
  ];
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
  state.nextRun = state.nextRun || 2;
  state.nextMessage = state.nextMessage || 2;
  state.nextReview = state.nextReview || 2;
  state.nextModeration = state.nextModeration || 2;
  state.users = state.users || [];
  state.profiles = state.profiles || [];
  state.moderatorIds = state.moderatorIds && state.moderatorIds.length > 0 ? state.moderatorIds : ["user-a"];
  state.shares = state.shares || [];
  state.listings = state.listings && state.listings.length > 0 ? state.listings : defaultListings();
  state.sessions = normalizeSessions(state.sessions || {});
  state.rateLimits = normalizeRateLimits(state.rateLimits || {});
  state.messages = state.messages || [];
  state.runs = state.runs || [];
  state.toolResults = state.toolResults || [];
  state.threads = state.threads && state.threads.length > 0 ? state.threads : deriveThreads(state);
  state.reviews = state.reviews || [];
  state.bookMemories = state.bookMemories || [];
  state.moderationCases = state.moderationCases || [];
  state.notifications = state.notifications || [];
  state.notificationStates = state.notificationStates || [];
  state.subscriptions = state.subscriptions || [];
  state.auditEvents = state.auditEvents || [];
  for (const user of state.users) {
    ensureProfile(state, user.id, { displayName: user.name, roleId: user.roleId, setupCompleted: true, consentAccepted: true });
  }
  return state;
}

function normalizeSessions(sessions) {
  const output = {};
  for (const [id, raw] of Object.entries(sessions)) {
    const userId = raw && raw.userId ? raw.userId : raw;
    if (!userId) continue;
    output[id] = {
      id: raw.id || id,
      userId,
      issuedAt: raw.issuedAt || new Date().toISOString(),
      expiresAt: raw.expiresAt || new Date(Date.now() + SESSION_TTL_MS).toISOString(),
      revokedAt: raw.revokedAt || "",
    };
  }
  return output;
}

function normalizeRateLimits(rateLimits) {
  const output = {};
  for (const [key, raw] of Object.entries(rateLimits)) {
    if (!raw || !raw.resetAt) continue;
    if (Date.parse(raw.resetAt) <= Date.now()) continue;
    output[key] = {
      key,
      count: Number(raw.count || 0),
      resetAt: raw.resetAt,
    };
  }
  return output;
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

function authFromRequest(state, headers) {
  const token = headers["x-miniapp-session"] || headers["X-Miniapp-Session"];
  if (!token) return { token: "", session: null, userId: "" };
  const session = state.sessions[token];
  if (!session) return { token, session: null, userId: "", error: "invalid_session" };
  if (session.revokedAt) return { token, session, userId: "", error: "session_revoked" };
  if (Date.parse(session.expiresAt) <= Date.now()) return { token, session, userId: "", error: "session_expired" };
  return { token, session, userId: session.userId };
}

function createSession(state, userId) {
  const now = Date.now();
  const id = `session-${randomUUID()}`;
  const session = {
    id,
    userId,
    issuedAt: new Date(now).toISOString(),
    expiresAt: new Date(now + SESSION_TTL_MS).toISOString(),
    revokedAt: "",
  };
  state.sessions[id] = session;
  return session;
}

function rateLimitFor(state, viewer, path) {
  const max = RATE_LIMITS[path] || 0;
  if (max <= 0) return null;
  const userKey = viewer || "anonymous";
  const key = `${userKey}:${path}`;
  const now = Date.now();
  let bucket = state.rateLimits[key];
  if (!bucket || Date.parse(bucket.resetAt) <= now) {
    bucket = { key, count: 0, resetAt: new Date(now + RATE_LIMIT_WINDOW_MS).toISOString() };
    state.rateLimits[key] = bucket;
  }
  bucket.count += 1;
  if (bucket.count <= max) return null;
  return {
    status: 429,
    changed: true,
    body: {
      error: "rate_limited",
      path,
      limit: max,
      resetAt: bucket.resetAt,
    },
  };
}

function healthFor(state) {
  const now = Date.now();
  const sessions = Object.values(state.sessions);
  const activeSessions = sessions.filter((session) => !session.revokedAt && Date.parse(session.expiresAt) > now).length;
  const pendingModeration = state.moderationCases.filter((item) => item.status === "pending" || item.status === "watch").length;
  return {
    status: "ok",
    routeCount: routeCatalog().length,
    userCount: state.users.length,
    activeSessionCount: activeSessions,
    pendingModerationCount: pendingModeration,
    auditEventCount: state.auditEvents.length,
    rateLimitBucketCount: Object.keys(state.rateLimits).length,
  };
}

function requireModerator(state, viewer) {
  if (canModerate(state, viewer)) return null;
  return { status: 403, changed: false, body: { error: "moderator_only" } };
}

function auditForAdmin(state, viewer, query) {
  const denied = requireModerator(state, viewer);
  if (denied) return denied;
  const kind = query.get("kind") || "";
  const buildingId = query.get("buildingId") || "";
  const rawLimit = Number(query.get("limit") || 50);
  const limit = Math.max(1, Math.min(100, Number.isFinite(rawLimit) ? rawLimit : 50));
  let events = state.auditEvents;
  if (kind) events = events.filter((item) => item.kind === kind);
  if (buildingId) events = events.filter((item) => item.buildingId === buildingId);
  return ok({
    items: events.slice(-limit).reverse(),
    total: events.length,
    limit,
    filters: { kind, buildingId },
  });
}

function backupForAdmin(state, viewer) {
  const denied = requireModerator(state, viewer);
  if (denied) return denied;
  const tables = [
    "users",
    "profiles",
    "moderatorIds",
    "shares",
    "listings",
    "buildings",
    "placements",
    "books",
    "bookMemories",
    "agents",
    "threads",
    "messages",
    "runs",
    "toolResults",
    "reviews",
    "moderationCases",
    "notifications",
    "notificationStates",
    "subscriptions",
    "auditEvents",
  ];
  const snapshot = {};
  const counts = {};
  for (const key of tables) {
    snapshot[key] = state[key] || [];
    counts[key] = snapshot[key].length;
  }
  return ok({
    schemaVersion: 1,
    generatedAt: new Date().toISOString(),
    excludes: ["sessions", "rateLimits"],
    counts,
    state: snapshot,
  });
}

function dispatch(state, request) {
  const method = request.method.toUpperCase();
  const path = request.path;
  const body = request.body || {};
  const auth = authFromRequest(state, request.headers || {});
  if (auth.error && path !== "/miniapp/auth/dev-login" && path !== "/miniapp/routes" && path !== "/miniapp/health") {
    return { status: 401, changed: false, body: { error: auth.error } };
  }
  const viewer = auth.userId || body.userId || "user-a";
  const limit = rateLimitFor(state, viewer, path);
  if (limit) return limit;

  if (method === "GET" && path === "/miniapp/routes") {
    return ok({ routes: routeCatalog() });
  }
  if (method === "GET" && path === "/miniapp/health") {
    return ok(healthFor(state));
  }
  if (method === "GET" && path === "/miniapp/admin/audit") {
    return auditForAdmin(state, viewer, request.query);
  }
  if (method === "GET" && path === "/miniapp/admin/backup") {
    return backupForAdmin(state, viewer);
  }
  if (method === "POST" && path === "/miniapp/auth/dev-login") {
    const userId = body.userId || "user-a";
    const profileItem = ensureProfile(state, userId, {
      displayName: body.displayName,
      roleId: body.roleId,
      avatarRef: body.avatarRef,
    });
    const session = createSession(state, userId);
    return changed({ session, profile: profileItem });
  }
  if (method === "POST" && path === "/miniapp/auth/logout") {
    if (!auth.session) return { status: 401, changed: false, body: { error: "missing_session" } };
    auth.session.revokedAt = new Date().toISOString();
    return changed({ session: auth.session, state: "revoked" });
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
  if (method === "POST" && path === "/miniapp/buildings/update") {
    return updateBuilding(state, viewer, body);
  }
  if (method === "POST" && path === "/miniapp/buildings/place") {
    return placeBuilding(state, viewer, body);
  }
  if (method === "POST" && path === "/miniapp/buildings/share") {
    return changeBuildingVisibility(state, viewer, body.buildingId, "shared_private", "shared", "share", body.targetUserId || "org-a");
  }
  if (method === "POST" && path === "/miniapp/buildings/submit") {
    return submitBuilding(state, viewer, body.buildingId);
  }
  if (method === "POST" && path === "/miniapp/buildings/publish") {
    return publishBuilding(state, viewer, body.buildingId);
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
  if (method === "POST" && path === "/miniapp/messages/send") {
    return sendMessage(state, viewer, body);
  }
  if (method === "POST" && path === "/miniapp/runs/cancel") {
    return changeRunStatus(state, viewer, body.runId, "cancelled");
  }
  if (method === "POST" && path === "/miniapp/runs/retry") {
    return changeRunStatus(state, viewer, body.runId, "running");
  }
  if (method === "POST" && path === "/miniapp/reviews/accept") {
    return decideReview(state, viewer, body.reviewId, "accepted");
  }
  if (method === "POST" && path === "/miniapp/reviews/reject") {
    return decideReview(state, viewer, body.reviewId, "rejected");
  }
  if (method === "POST" && path === "/miniapp/messages/ack") {
    return acknowledgeNotification(state, viewer, body);
  }
  if (method === "POST" && path === "/miniapp/tool-results/ack") {
    return acknowledgeToolResult(state, viewer, body);
  }
  if (method === "POST" && path === "/miniapp/messages/subscribe") {
    return requestSubscription(state, viewer, body);
  }
  if (method === "POST" && path === "/miniapp/moderation/report") {
    return reportBuilding(state, viewer, body);
  }
  if (method === "POST" && path === "/miniapp/moderation/hide") {
    return decideModerationCase(state, viewer, body, "hidden");
  }
  if (method === "POST" && path === "/miniapp/moderation/takedown") {
    return decideModerationCase(state, viewer, body, "takedown");
  }
  if (method === "POST" && path === "/miniapp/moderation/appeal") {
    return appealModerationCase(state, viewer, body);
  }
  if (method === "POST" && path === "/miniapp/agents") {
    return createAgent(state, viewer, body);
  }
  if (method === "POST" && path === "/miniapp/agents/handoff") {
    return handoffAgent(state, viewer, body);
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
    "GET /miniapp/health",
    "GET /miniapp/admin/audit",
    "GET /miniapp/admin/backup",
    "POST /miniapp/auth/dev-login",
    "POST /miniapp/auth/logout",
    "GET /miniapp/town/snapshot",
    "GET /miniapp/me/ownership",
    "GET /miniapp/discover/search",
    "POST /miniapp/me/profile",
    "POST /miniapp/buildings",
    "POST /miniapp/buildings/update",
    "POST /miniapp/buildings/place",
    "POST /miniapp/buildings/share",
    "POST /miniapp/buildings/submit",
    "POST /miniapp/buildings/publish",
    "POST /miniapp/buildings/archive",
    "POST /miniapp/buildings/restore",
    "POST /miniapp/buildings/query",
    "POST /miniapp/messages/send",
    "POST /miniapp/runs/cancel",
    "POST /miniapp/runs/retry",
    "POST /miniapp/reviews/accept",
    "POST /miniapp/reviews/reject",
    "POST /miniapp/messages/ack",
    "POST /miniapp/tool-results/ack",
    "POST /miniapp/messages/subscribe",
    "POST /miniapp/moderation/report",
    "POST /miniapp/moderation/hide",
    "POST /miniapp/moderation/takedown",
    "POST /miniapp/moderation/appeal",
    "POST /miniapp/agents",
    "POST /miniapp/agents/handoff",
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

function canModerate(state, viewer) {
  return state.moderatorIds.includes(viewer);
}

function visiblePlacements(state, viewer) {
  return state.placements.filter((item) => item.ownerId === viewer || item.ownerId === "org-a" || item.layer === "town_public");
}

function visibleBooks(state, viewer) {
  const visibleBuildingIds = new Set(visibleBuildings(state, viewer).map((item) => item.id));
  return state.books.filter((item) => item.visibility === "published" || item.ownerId === viewer || item.ownerId === "org-a" || visibleBuildingIds.has(item.buildingId));
}

function visibleBookMemories(state, books) {
  const visibleBookIds = new Set(books.map((item) => item.id));
  return state.bookMemories.filter((item) => visibleBookIds.has(item.bookId));
}

function visibleThreads(state, viewer) {
  const visibleBuildingIds = new Set(visibleBuildings(state, viewer).map((item) => item.id));
  return state.threads.filter((item) => visibleBuildingIds.has(item.buildingId));
}

function visibleNotifications(state, viewer, buildings) {
  const visibleBuildingIds = new Set(buildings.map((item) => item.id));
  return state.notifications
    .filter((item) => !item.buildingId || visibleBuildingIds.has(item.buildingId))
    .map((item) => notificationForViewer(state, viewer, item));
}

function notificationForViewer(state, viewer, item) {
  const viewerState = state.notificationStates.find((candidate) => candidate.userId === viewer && candidate.noticeId === item.id);
  return {
    ...item,
    unread: viewerState ? viewerState.unread : Boolean(item.unread),
    state: viewerState ? viewerState.state : (item.unread ? "unread" : "read"),
  };
}

function snapshotFor(state, viewer) {
  const buildings = visibleBuildings(state, viewer);
  const placements = visiblePlacements(state, viewer);
  const books = visibleBooks(state, viewer);
  const bookMemories = visibleBookMemories(state, books);
  const threads = visibleThreads(state, viewer);
  const notifications = visibleNotifications(state, viewer, buildings);
  const agents = state.agents.filter((item) => buildings.some((building) => building.id === item.buildingId));
  const profile = profileFor(state, viewer);
  return {
    viewer,
    profile,
    permissions: permissionsFor(state, viewer, profile),
    relationships: relationshipsFor(state, viewer, buildings, placements, books, agents),
    users: state.users,
    buildings,
    placements,
    books,
    bookMemories,
    threads,
    agents,
    runs: state.runs.filter((item) => buildings.some((building) => building.id === item.buildingId)),
    toolResults: state.toolResults.filter((item) => buildings.some((building) => building.id === item.buildingId)),
    reviews: state.reviews.filter((item) => item.reviewerId === viewer),
    messages: visibleMessages(state, viewer),
    notifications,
    notificationStates: state.notificationStates.filter((item) => item.userId === viewer),
    subscriptions: state.subscriptions.filter((item) => item.userId === viewer),
    moderationCases: state.moderationCases.filter((item) => item.reporterId === viewer || buildings.some((building) => building.id === item.buildingId)),
    shares: state.shares.filter((item) => item.ownerId === viewer || item.targetUserId === viewer),
    auditEvents: state.auditEvents.filter((item) => item.visibility === "published" || item.actorId === viewer || buildings.some((building) => building.id === item.buildingId)),
  };
}

function visibleMessages(state, viewer) {
  const visibleThreadIds = new Set(visibleThreads(state, viewer).map((item) => item.id));
  return state.messages.filter((item) => visibleThreadIds.has(item.threadId));
}

function buildingIdFromThread(threadId) {
  return String(threadId || "").replace(/^thread-/, "");
}

function deriveThreads(state) {
  const threadsById = new Map();
  const addThread = (threadId, buildingId, status = "stable") => {
    const building = state.buildings.find((item) => item.id === buildingId);
    if (!building || threadsById.has(threadId)) return;
    threadsById.set(threadId, thread(threadId, buildingId, `${building.title} Thread`, building.ownerId, building.visibility, status));
  };
  for (const item of state.messages || []) addThread(item.threadId, buildingIdFromThread(item.threadId), item.status || "stable");
  for (const item of state.runs || []) addThread(item.threadId, item.buildingId, item.status || "stable");
  for (const item of state.toolResults || []) addThread(item.threadId, item.buildingId, item.status || "stable");
  return Array.from(threadsById.values());
}

function ensureThread(state, building, threadId, status) {
  let item = state.threads.find((candidate) => candidate.id === threadId);
  if (!item) {
    item = thread(threadId, building.id, `${building.title} Thread`, building.ownerId, building.visibility, status);
    state.threads.push(item);
  } else {
    item.buildingId = building.id;
    item.title = `${building.title} Thread`;
    item.ownerId = building.ownerId;
    item.visibility = building.visibility;
    item.status = status || item.status;
    item.updatedAt = new Date().toISOString();
  }
  return item;
}

function touchThread(state, threadId, status) {
  const item = state.threads.find((candidate) => candidate.id === threadId);
  if (item) {
    item.status = status || item.status;
    item.unreadCount += 1;
    item.updatedAt = new Date().toISOString();
  }
  return item;
}

function syncThreadsForBuilding(state, building) {
  for (const item of state.threads) {
    if (item.buildingId === building.id) {
      item.ownerId = building.ownerId;
      item.visibility = building.visibility;
      item.status = building.status;
      item.updatedAt = new Date().toISOString();
    }
  }
}

function ownershipFor(state, viewer) {
  const profile = profileFor(state, viewer);
  const permissions = permissionsFor(state, viewer, profile);
  const buildings = state.buildings.filter((item) => item.ownerId === viewer || item.ownerId === "org-a" || (item.visibility === "shared_private" && isBuildingSharedWith(state, item.id, viewer)));
  const placements = visiblePlacements(state, viewer);
  const buildingIds = new Set(buildings.map((item) => item.id));
  const books = state.books.filter((item) => item.ownerId === viewer || item.ownerId === "org-a" || buildingIds.has(item.buildingId));
  const bookMemories = visibleBookMemories(state, books);
  const agents = state.agents.filter((item) => buildingIds.has(item.buildingId));
  const threads = state.threads.filter((item) => buildingIds.has(item.buildingId));
  const relationships = relationshipsFor(state, viewer, buildings, placements, books, agents);
  const reviews = state.reviews.filter((item) => item.reviewerId === viewer);
  const notifications = visibleNotifications(state, viewer, buildings);
  const retryableRuns = state.runs.filter((item) => buildingIds.has(item.buildingId) && ["failed", "rejected", "cancelled"].includes(item.status));
  const stats = [
    { id: "buildings", label: "Buildings", value: buildings.length },
    { id: "placements", label: "Placed", value: placements.length },
    { id: "drafts", label: "Drafts", value: buildings.filter((item) => item.visibility === "private_draft").length },
    { id: "published", label: "Published", value: buildings.filter((item) => item.visibility === "published").length },
    { id: "books", label: "Books", value: books.length },
    { id: "agents", label: "Agents", value: agents.length },
    { id: "threads", label: "Threads", value: threads.length },
  ];
  const items = [
    ...buildings.map((item) => ownedItem("building", item.id, item.title, item.summary, `building:${item.id}`, item.visibility, item.status, actionForVisibility(item.visibility), actionMessageForBuilding(item))),
    ...placements.map((item) => {
      const buildingItem = state.buildings.find((building) => building.id === item.buildingId);
      const title = buildingItem ? buildingItem.title : item.buildingId;
      return ownedItem("placement", item.id, title, `${item.layer} map pin from ${item.source}.`, `placement:${item.id}`, item.layer, item.status, "Open", `select-${item.buildingId}`);
    }),
    ...books.map((item) => ownedItem("book", item.id, item.title, item.summary, `book:${item.id}`, item.visibility, item.status, "Review", "tab-messages")),
    ...agents.map((item) => ownedItem("agent", item.id, item.name, `Agent attached to ${item.buildingId}.`, `agent:${item.id}`, "owned", item.status, "Chat", "tab-messages")),
    ...threads.map((item) => ownedItem("thread", item.id, item.title, `Conversation attached to ${item.buildingId}.`, `thread:${item.id}`, item.visibility, item.status, "Open", "tab-messages")),
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
  return {
    viewer,
    profile,
    permissions,
    relationships,
    stats,
    items,
    alerts,
    reviews,
    shares,
    bookMemories,
    threads,
    notifications,
    notificationStates: state.notificationStates.filter((item) => item.userId === viewer),
    subscriptions: state.subscriptions.filter((item) => item.userId === viewer),
  };
}

function ownedItem(kind, id, title, summary, targetRef, visibility, status, actionLabel, actionMessage) {
  return { id, kind, title, summary, targetRef, visibility, status, actionLabel, actionMessage };
}

function permissionsFor(state, viewer, profile) {
  const profileReady = Boolean(profile.setupCompleted && profile.consentAccepted && profile.roleId);
  return {
    profileReady,
    canCreateBuilding: profileReady,
    canSubmitBuilding: profileReady,
    canPublishBuilding: profileReady,
    canPlacePublicBuilding: profileReady,
    canReportPublicBuilding: true,
    canModerate: canModerate(state, viewer),
    canReview: state.reviews.some((item) => item.reviewerId === viewer && item.status === "pending"),
  };
}

function relationshipsFor(state, viewer, buildings, placements, books, agents) {
  const buildingById = new Map(buildings.map((item) => [item.id, item]));
  return [
    ...buildings.map((item) => relationship("building", item.id, relationForBuilding(state, viewer, item), item.ownerId, item.visibility, item.id)),
    ...placements.map((item) => relationship("placement", item.id, relationForPlacement(item, viewer), item.ownerId, item.layer, item.buildingId)),
    ...books.map((item) => relationship("book", item.id, relationForBook(state, viewer, item, buildingById.get(item.buildingId)), item.ownerId, item.visibility, item.buildingId)),
    ...agents.map((item) => {
      const building = buildingById.get(item.buildingId) || state.buildings.find((candidate) => candidate.id === item.buildingId);
      return relationship("agent", item.id, building ? relationForBuilding(state, viewer, building) : "detached", building ? building.ownerId : "", building ? building.visibility : "unknown", item.buildingId);
    }),
  ];
}

function relationship(kind, id, relation, ownerId, visibility, buildingId) {
  return { kind, id, relation, ownerId, visibility, buildingId };
}

function relationForBuilding(state, viewer, item) {
  if (item.ownerId === viewer) return "owner";
  if (item.ownerId === "system") return "system";
  if (item.ownerId === "org-a") return "team";
  if (isBuildingSharedWith(state, item.id, viewer)) return "shared";
  if (item.visibility === "published") return "public";
  return "visible";
}

function relationForPlacement(item, viewer) {
  if (item.ownerId === viewer) return "owner";
  if (item.ownerId === "org-a") return "team";
  if (item.layer === "town_public") return "public";
  return "visible";
}

function relationForBook(state, viewer, item, building) {
  if (item.ownerId === viewer) return "owner";
  if (item.ownerId === "system") return "system";
  if (item.ownerId === "org-a") return "team";
  if (building) return relationForBuilding(state, viewer, building);
  if (item.visibility === "published") return "public";
  return "visible";
}

function actionForVisibility(visibility) {
  if (visibility === "private_draft") return "Submit";
  if (visibility === "shared_private") return "Submit";
  if (visibility === "submitted") return "Review";
  if (visibility === "published") return "Place";
  if (visibility === "archived") return "Restore";
  return "Open";
}

function actionMessageForBuilding(item) {
  if (item.visibility === "private_draft") return "submit-private-building";
  if (item.visibility === "shared_private") return "submit-private-building";
  if (item.visibility === "submitted") return "tab-messages";
  if (item.visibility === "published") return "tab-discover";
  if (item.visibility === "archived") return "restore-archived-building";
  return `select-${item.id}`;
}

function discoverItems(state, viewer, query) {
  const needle = String(query || "").toLowerCase();
  const buildings = publicDiscoverBuildings(state, viewer);
  const buildingIds = new Set(buildings.map((item) => item.id));
  const items = [
    ...buildings.map((item) => ({
      id: `building-${item.id}`,
      kind: "building",
      title: item.title,
      summary: item.summary,
      targetRef: `building:${item.id}`,
      visibility: item.visibility,
      status: item.status,
    })),
    ...publicDiscoverUsers(state, viewer).map((item) => ({
      id: `user-${item.id}`,
      kind: "user",
      title: item.name,
      summary: `Town ${item.roleId || "member"} with public profile readiness.`,
      targetRef: `user:${item.id}`,
      visibility: item.id === viewer ? "personal" : "published",
      status: "stable",
    })),
    ...state.agents
      .filter((item) => buildingIds.has(item.buildingId))
      .map((item) => ({
        id: `agent-${item.id}`,
        kind: "agent",
        title: item.name,
        summary: `Agent attached to ${item.buildingId}.`,
        targetRef: `agent:${item.id}`,
        visibility: "published",
        status: item.status,
      })),
    ...state.books
      .filter((item) => item.visibility === "published" && buildingIds.has(item.buildingId))
      .map((item) => ({
        id: `book-${item.id}`,
        kind: "book",
        title: item.title,
        summary: item.summary,
        targetRef: `book:${item.id}`,
        visibility: item.visibility,
        status: item.status,
      })),
    ...state.listings
      .filter((item) => item.visibility === "published")
      .map((item) => ({
        id: item.id,
        kind: item.kind,
        title: item.title,
        summary: item.summary,
        targetRef: item.targetRef,
        visibility: item.visibility,
        status: item.status,
      })),
    ...state.reviews
      .filter((item) => item.status === "pending" && buildingIds.has(item.buildingId))
      .map((item) => ({
        id: `demand-${item.id}`,
        kind: "demand",
        title: item.title,
        summary: item.summary,
        targetRef: `review:${item.id}`,
        visibility: "published",
        status: item.status,
      })),
    ...state.runs
      .filter((item) => buildingIds.has(item.buildingId))
      .map((item) => ({
        id: `event-${item.id}`,
        kind: "event",
        title: item.title,
        summary: item.summary,
        targetRef: `run:${item.id}`,
        visibility: "published",
        status: item.status,
      })),
  ];
  return items.filter((item) => discoverMatch(item, needle));
}

function publicDiscoverBuildings(state, viewer) {
  return visibleBuildings(state, viewer).filter((item) => item.visibility === "published");
}

function publicDiscoverUsers(state, viewer) {
  return state.users.filter((item) => {
    if (item.id === viewer) return true;
    const profileItem = state.profiles.find((profile) => profile.userId === item.id);
    return profileItem && profileItem.setupCompleted && profileItem.consentAccepted;
  });
}

function discoverMatch(item, needle) {
  return !needle ||
    item.kind.toLowerCase().includes(needle) ||
    item.title.toLowerCase().includes(needle) ||
    item.summary.toLowerCase().includes(needle) ||
    item.targetRef.toLowerCase().includes(needle) ||
    item.status.toLowerCase().includes(needle);
}

function createBuilding(state, viewer, body) {
  if (!permissionsFor(state, viewer, profileFor(state, viewer)).canCreateBuilding) {
    return { status: 403, changed: false, body: { error: "profile_not_ready", action: "create_building" } };
  }
  const id = body.id || `building-${state.buildings.length + 1}`;
  const title = body.title || "Created Building";
  const item = building(id, title, "agent_lab", "private_draft", viewer, "Local private building created from WeChat DevTools.", body.tags || ["agent", "local"], 432, 513, "draft");
  const memory = book(`book-${id}`, id, `${title} Book`, viewer, "private_draft", "Private book memory created with this building.", 0, 0, "draft");
  state.buildings.push(item);
  state.books.push(memory);
  state.auditEvents.push(audit(`audit-create-${id}`, "create", `${title} created`, "Private building and book were created locally.", viewer, `building:${id}`, id, "draft", "private_draft"));
  return changed({ building: item, book: memory });
}

function updateBuilding(state, viewer, body) {
  const buildingId = body.buildingId || body.id;
  const item = state.buildings.find((building) => building.id === buildingId);
  if (!item) return { status: 404, changed: false, body: { error: "missing_building", buildingId } };
  if (item.ownerId !== viewer && item.ownerId !== "org-a") return { status: 403, changed: false, body: { error: "owner_only", buildingId } };
  if (!["private_draft", "shared_private"].includes(item.visibility)) {
    return { status: 409, changed: false, body: { error: "not_editable", buildingId, visibility: item.visibility } };
  }
  const title = String(body.title || "").trim();
  const summary = String(body.summary || "").trim();
  if (title) item.title = title;
  if (summary) item.summary = summary;
  if (Array.isArray(body.tags)) item.tags = body.tags.filter((tag) => String(tag || "").trim()).map((tag) => String(tag).trim());
  const memory = firstBookForBuilding(state, buildingId);
  if (memory) {
    const bookTitle = String(body.bookTitle || "").trim();
    const bookSummary = String(body.bookSummary || "").trim();
    if (bookTitle) memory.title = bookTitle;
    if (bookSummary) memory.summary = bookSummary;
  }
  syncThreadsForBuilding(state, item);
  state.auditEvents.push(audit(`audit-update-${buildingId}-${state.auditEvents.length + 1}`, "update", `${item.title} updated`, "Draft building profile and safe book summary were updated locally.", viewer, `building:${buildingId}`, buildingId, item.status, item.visibility));
  return changed({ building: item, book: memory });
}

function placeBuilding(state, viewer, body) {
  if (!permissionsFor(state, viewer, profileFor(state, viewer)).canPlacePublicBuilding) {
    return { status: 403, changed: false, body: { error: "profile_not_ready", action: "place_building" } };
  }
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
  if (kind === "share" && !permissionsFor(state, viewer, profileFor(state, viewer)).canSubmitBuilding) {
    return { status: 403, changed: false, body: { error: "profile_not_ready", action: "share_building" } };
  }
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
  syncThreadsForBuilding(state, item);
  for (const memory of state.books) {
    if (memory.buildingId === buildingId) {
      memory.visibility = visibility;
      memory.status = status;
    }
  }
  state.auditEvents.push(audit(`audit-${kind}-${buildingId}`, kind, `${item.title} ${kind}`, `Visibility changed for ${target}.`, viewer, `building:${buildingId}`, buildingId, status, visibility));
  return changed(grant ? { building: item, share: grant } : { building: item });
}

function submitBuilding(state, viewer, buildingId) {
  if (!permissionsFor(state, viewer, profileFor(state, viewer)).canSubmitBuilding) {
    return { status: 403, changed: false, body: { error: "profile_not_ready", action: "submit_building" } };
  }
  const item = state.buildings.find((building) => building.id === buildingId);
  if (!item) return { status: 404, changed: false, body: { error: "missing_building", buildingId } };
  if (item.ownerId !== viewer && item.ownerId !== "org-a") return { status: 403, changed: false, body: { error: "owner_only", buildingId } };
  if (!["private_draft", "shared_private"].includes(item.visibility)) {
    return { status: 409, changed: false, body: { error: "not_submittable", buildingId, visibility: item.visibility } };
  }
  item.visibility = "submitted";
  item.status = "review";
  syncThreadsForBuilding(state, item);
  const memory = firstBookForBuilding(state, buildingId);
  for (const bookItem of state.books) {
    if (bookItem.buildingId === buildingId) {
      bookItem.visibility = "submitted";
      bookItem.status = "review";
      bookItem.pendingReviewCount += 1;
    }
  }
  const review = {
    id: `review-publish-${buildingId}-${state.nextReview++}`,
    runId: `publication-${buildingId}`,
    buildingId,
    bookId: memory ? memory.id : "",
    title: `Review ${item.title} publication`,
    summary: "Approve this building before it appears in public discovery.",
    artifactRef: `building://${buildingId}`,
    reviewerId: viewer,
    status: "pending",
    acceptedMemoryDelta: 0,
  };
  state.reviews.push(review);
  state.notifications.push({ id: `notice-${review.id}`, kind: "review", title: "Publication review waiting", body: review.summary, targetRef: `building:${buildingId}`, buildingId, unread: true });
  state.auditEvents.push(audit(`audit-submit-${buildingId}`, "submit", `${item.title} submitted`, "Building is waiting for town publication review.", viewer, `building:${buildingId}`, buildingId, "review", "submitted"));
  return changed({ building: item, review });
}

function publishBuilding(state, viewer, buildingId) {
  if (!permissionsFor(state, viewer, profileFor(state, viewer)).canPublishBuilding) {
    return { status: 403, changed: false, body: { error: "profile_not_ready", action: "publish_building" } };
  }
  const item = state.buildings.find((building) => building.id === buildingId);
  if (!item) return { status: 404, changed: false, body: { error: "missing_building", buildingId } };
  if (item.ownerId !== viewer && item.ownerId !== "org-a") return { status: 403, changed: false, body: { error: "owner_only", buildingId } };
  if (item.visibility !== "submitted") {
    return { status: 409, changed: false, body: { error: "not_submitted", buildingId, visibility: item.visibility } };
  }
  const review = state.reviews.find((candidate) => candidate.buildingId === buildingId && candidate.runId === `publication-${buildingId}` && candidate.status === "pending");
  acceptPublication(state, viewer, item, review);
  return changed(review ? { building: item, review } : { building: item });
}

function firstBookForBuilding(state, buildingId) {
  return state.books.find((item) => item.buildingId === buildingId) || null;
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
  const threadItem = ensureThread(state, item, body.threadId || `thread-${buildingId}`, "review");
  const run = { id: runId, agentId: "agent-policy-guide", buildingId, bookId, threadId: threadItem.id, title: `${item.title} answer`, summary: body.body || "Local question", status: "review", reviewRequired: true, artifactRef: `artifact://${bookId}` };
  const message = { id: messageId, actorId: "agent-policy-guide", threadId: run.threadId, text: "Local answer recorded as a reviewable run.", status: "waiting-review" };
  const review = { id: reviewId, runId, buildingId, bookId, title: "Review local answer", summary: "Accept this local answer into building memory.", artifactRef: run.artifactRef, reviewerId: viewer, status: "pending", acceptedMemoryDelta: 1 };
  state.runs.push(run);
  state.messages.push(message);
  state.reviews.push(review);
  touchThread(state, threadItem.id, "review");
  state.notifications.push({ id: `notice-${reviewId}`, kind: "review", title: "Review waiting", body: review.summary, targetRef: run.threadId, buildingId, unread: true });
  return changed({ run, message, review, thread: threadItem });
}

function sendMessage(state, viewer, body) {
  const buildingId = body.buildingId || "policy-hall";
  const item = visibleBuildings(state, viewer).find((building) => building.id === buildingId);
  if (!item) return { status: 403, changed: false, body: { error: "building_not_visible", buildingId } };
  const text = String(body.body || body.text || "").trim() || `Message to ${item.title}`;
  const threadItem = ensureThread(state, item, body.threadId || `thread-${buildingId}`, "running");
  const message = {
    id: `msg-local-${state.nextMessage++}`,
    actorId: viewer,
    threadId: threadItem.id,
    text,
    status: "running",
  };
  state.messages.push(message);
  touchThread(state, threadItem.id, "running");
  state.auditEvents.push(audit(`audit-message-${message.id}`, "message", `${item.title} message sent`, "A user message was recorded in the building thread.", viewer, `message:${message.id}`, buildingId, "running", item.visibility));
  return changed({ message, thread: threadItem, threadId: message.threadId, building: item });
}

function acknowledgeNotification(state, viewer, body) {
  const noticeId = body.noticeId || "";
  const notice = state.notifications.find((item) => item.id === noticeId);
  if (!notice) return { status: 404, changed: false, body: { error: "missing_notice", noticeId } };
  let item = state.notificationStates.find((candidate) => candidate.userId === viewer && candidate.noticeId === noticeId);
  if (!item) {
    item = notificationState(viewer, noticeId, false, "acknowledged");
    state.notificationStates.push(item);
  } else {
    item.unread = false;
    item.state = "acknowledged";
    item.updatedAt = new Date().toISOString();
  }
  return changed({ notice: notificationForViewer(state, viewer, notice), notificationState: item, state: "acknowledged" });
}

function requestSubscription(state, viewer, body) {
  const targetRef = body.targetRef || "subscription:wechat";
  const noticeId = body.noticeId || "notice-subscribe";
  let item = state.subscriptions.find((candidate) => candidate.userId === viewer && candidate.targetRef === targetRef);
  if (!item) {
    item = subscription(`subscription-${viewer}-${targetRef.replace(/[^a-z0-9]+/gi, "-")}`, viewer, targetRef, noticeId, "requested");
    state.subscriptions.push(item);
  } else {
    item.noticeId = noticeId;
    item.status = "requested";
    item.updatedAt = new Date().toISOString();
  }
  const notice = state.notifications.find((candidate) => candidate.id === noticeId);
  let noticeResult = null;
  if (notice) {
    noticeResult = acknowledgeNotification(state, viewer, { noticeId }).body.notice;
  }
  return changed({ subscription: item, notice: noticeResult, targetRef, state: "requested" });
}

function reportBuilding(state, viewer, body) {
  const buildingId = body.buildingId || "policy-hall";
  const item = visibleBuildings(state, viewer).find((building) => building.id === buildingId);
  if (!item) return { status: 403, changed: false, body: { error: "building_not_visible", buildingId } };
  if (item.visibility !== "published") {
    return { status: 409, changed: false, body: { error: "not_public", buildingId, visibility: item.visibility } };
  }
  const id = body.id || `mod-${buildingId}-${viewer}`;
  let moderationCase = state.moderationCases.find((candidate) => candidate.id === id);
  if (!moderationCase) {
    moderationCase = {
      id,
      buildingId,
      reporterId: viewer,
      targetRef: `building:${buildingId}`,
      title: `${item.title} report`,
      summary: String(body.reason || "Safety review request").trim(),
      status: "pending",
      actionLabel: "Review",
      actionMessage: "tab-messages",
    };
    state.moderationCases.push(moderationCase);
  } else {
    moderationCase.summary = String(body.reason || moderationCase.summary).trim();
    moderationCase.status = "pending";
  }
  state.notifications.push({ id: `notice-${moderationCase.id}`, kind: "moderation", title: "Moderation case opened", body: moderationCase.summary, targetRef: moderationCase.targetRef, buildingId, unread: true });
  state.auditEvents.push(audit(`audit-report-${moderationCase.id}`, "report", `${item.title} reported`, "A public report was routed to the review council before hide or takedown.", viewer, moderationCase.targetRef, buildingId, "pending", "published"));
  return changed({ case: moderationCase, building: item });
}

function decideModerationCase(state, viewer, body, decision) {
  const caseId = body.caseId || body.moderationCaseId || "";
  const buildingId = body.buildingId || "";
  const moderationCase = state.moderationCases.find((candidate) => candidate.id === caseId) ||
    state.moderationCases.find((candidate) => candidate.buildingId === buildingId);
  if (!moderationCase) return { status: 404, changed: false, body: { error: "missing_moderation_case", caseId, buildingId } };
  const item = state.buildings.find((building) => building.id === moderationCase.buildingId);
  if (!item) return { status: 404, changed: false, body: { error: "missing_building", buildingId: moderationCase.buildingId } };
  if (!canModerate(state, viewer)) {
    return { status: 403, changed: false, body: { error: "moderator_only", caseId: moderationCase.id, buildingId: item.id } };
  }
  const visibility = decision === "takedown" ? "takedown" : "hidden";
  const status = decision === "takedown" ? "removed" : "hidden";
  item.visibility = visibility;
  item.status = status;
  syncThreadsForBuilding(state, item);
  moderationCase.status = status;
  moderationCase.actionLabel = decision === "takedown" ? "Closed" : "Takedown";
  moderationCase.actionMessage = decision === "takedown" ? "tab-messages" : "takedown-public-building";
  for (const memory of state.books) {
    if (memory.buildingId === item.id) {
      memory.visibility = visibility;
      memory.status = status;
    }
  }
  state.notifications.push({ id: `notice-${decision}-${moderationCase.id}`, kind: "moderation", title: `Moderation ${decision}`, body: `${item.title} is ${status}.`, targetRef: moderationCase.targetRef, buildingId: item.id, unread: true });
  state.auditEvents.push(audit(`audit-${decision}-${moderationCase.id}`, decision, `${item.title} ${decision}`, "Reviewer action changed public visibility from a report case.", viewer, moderationCase.targetRef, item.id, status, visibility));
  return changed({ case: moderationCase, building: item, state: status });
}

function appealModerationCase(state, viewer, body) {
  const caseId = body.caseId || body.moderationCaseId || "";
  const buildingId = body.buildingId || "";
  const moderationCase = state.moderationCases.find((candidate) => candidate.id === caseId) ||
    state.moderationCases.find((candidate) => candidate.buildingId === buildingId);
  if (!moderationCase) return { status: 404, changed: false, body: { error: "missing_moderation_case", caseId, buildingId } };
  const item = state.buildings.find((building) => building.id === moderationCase.buildingId);
  if (!item) return { status: 404, changed: false, body: { error: "missing_building", buildingId: moderationCase.buildingId } };
  if (item.ownerId !== viewer) {
    return { status: 403, changed: false, body: { error: "owner_only", caseId: moderationCase.id, buildingId: item.id } };
  }
  if (!["hidden", "removed", "appeal_requested"].includes(moderationCase.status)) {
    return { status: 409, changed: false, body: { error: "appeal_not_ready", caseId: moderationCase.id, status: moderationCase.status } };
  }
  const reason = String(body.reason || "Owner appeal requested").trim();
  moderationCase.status = "appeal_requested";
  moderationCase.summary = reason;
  moderationCase.actionLabel = "Review appeal";
  moderationCase.actionMessage = "tab-messages";
  item.status = "appeal";
  syncThreadsForBuilding(state, item);
  for (const memory of state.books) {
    if (memory.buildingId === item.id) memory.status = "appeal";
  }
  state.notifications.push({ id: `notice-appeal-${moderationCase.id}`, kind: "moderation", title: "Moderation appeal requested", body: reason, targetRef: moderationCase.targetRef, buildingId: item.id, unread: true });
  state.auditEvents.push(audit(`audit-appeal-${moderationCase.id}`, "appeal", `${item.title} appeal requested`, "Owner appealed a moderation decision; visibility stays restricted until review.", viewer, moderationCase.targetRef, item.id, "appeal", item.visibility));
  return changed({ case: moderationCase, building: item, state: "appeal_requested" });
}

function acknowledgeToolResult(state, viewer, body) {
  const toolResultId = body.toolResultId || body.id || "tool-policy-summary";
  const item = state.toolResults.find((result) => result.id === toolResultId);
  if (!item) return { status: 404, changed: false, body: { error: "missing_tool_result", toolResultId } };
  const building = visibleBuildings(state, viewer).find((entry) => entry.id === item.buildingId);
  if (!building) return { status: 403, changed: false, body: { error: "building_not_visible", buildingId: item.buildingId } };
  const threadItem = ensureThread(state, building, item.threadId, "done");
  item.status = "done";
  touchThread(state, threadItem.id, "done");
  state.auditEvents.push(audit(`audit-tool-ack-${toolResultId}`, "tool-result-ack", `${item.title} acknowledged`, "Tool result was reviewed and cleared from the pending agent queue.", viewer, `tool-result:${toolResultId}`, item.buildingId, "done", building.visibility));
  return changed({ toolResult: item, thread: threadItem, building, state: "acknowledged" });
}

function createAgent(state, viewer, body) {
  const buildingId = body.buildingId || "private-agent-lab";
  const building = visibleBuildings(state, viewer).find((item) => item.id === buildingId);
  if (!building) return { status: 403, changed: false, body: { error: "building_not_visible", buildingId } };
  if (building.ownerId !== viewer && building.ownerId !== "org-a") {
    return { status: 403, changed: false, body: { error: "owner_only", buildingId } };
  }
  const id = body.id || `agent-${state.agents.length + 1}`;
  if (state.agents.some((item) => item.id === id)) {
    return { status: 409, changed: false, body: { error: "duplicate_agent", agentId: id } };
  }
  const name = body.displayName || body.name || "Created Agent";
  const agent = { id, name, buildingId, status: "idle" };
  const threadItem = ensureThread(state, building, `thread-${buildingId}`, "done");
  const message = {
    id: `msg-agent-${state.nextMessage++}`,
    actorId: id,
    threadId: threadItem.id,
    text: `${name} is ready inside ${building.title}.`,
    status: "done",
  };
  state.agents.push(agent);
  state.messages.push(message);
  touchThread(state, threadItem.id, "done");
  state.auditEvents.push(audit(`audit-agent-${id}`, "agent-create", `${name} created`, `Agent is attached to ${building.title} and can join building threads.`, viewer, `agent:${id}`, buildingId, "idle", building.visibility));
  return changed({ agent, message, thread: threadItem, building });
}

function handoffAgent(state, viewer, body) {
  const buildingId = body.buildingId || "policy-hall";
  const building = visibleBuildings(state, viewer).find((item) => item.id === buildingId);
  if (!building) return { status: 403, changed: false, body: { error: "building_not_visible", buildingId } };
  const fromAgentId = body.fromAgentId || "agent-policy-guide";
  const toAgentId = body.toAgentId || body.targetAgentId || "agent-builder";
  const fromAgent = state.agents.find((item) => item.id === fromAgentId);
  const toAgent = state.agents.find((item) => item.id === toAgentId);
  if (!fromAgent) return { status: 404, changed: false, body: { error: "missing_from_agent", agentId: fromAgentId } };
  if (!toAgent) return { status: 404, changed: false, body: { error: "missing_to_agent", agentId: toAgentId } };
  const toBuilding = visibleBuildings(state, viewer).find((item) => item.id === toAgent.buildingId);
  if (!toBuilding) return { status: 403, changed: false, body: { error: "target_agent_not_visible", agentId: toAgentId } };
  const book = firstBookForBuilding(state, buildingId) || { id: `book-${buildingId}` };
  const summary = String(body.summary || body.body || `Continue work from ${fromAgent.name}.`).trim();
  const runId = `run-handoff-${state.nextRun++}`;
  const threadItem = ensureThread(state, building, body.threadId || `thread-${buildingId}`, "running");
  const threadId = threadItem.id;
  const message = {
    id: `msg-handoff-${state.nextMessage++}`,
    actorId: fromAgent.id,
    threadId,
    text: `${fromAgent.name} handed work to ${toAgent.name}: ${summary}`,
    status: "running",
  };
  const run = {
    id: runId,
    agentId: toAgent.id,
    buildingId,
    bookId: book.id,
    threadId,
    title: `${toAgent.name} handoff`,
    summary,
    status: "running",
    reviewRequired: true,
    artifactRef: `handoff://${fromAgent.id}/${toAgent.id}/${buildingId}`,
  };
  const notification = {
    id: `notice-handoff-${runId}`,
    kind: "handoff",
    title: "Agent handoff started",
    body: `${fromAgent.name} moved work to ${toAgent.name} inside ${building.title}.`,
    targetRef: `run:${runId}`,
    buildingId,
    unread: true,
  };
  toAgent.status = "running";
  state.messages.push(message);
  state.runs.push(run);
  touchThread(state, threadId, "running");
  state.notifications.push(notification);
  state.auditEvents.push(audit(`audit-handoff-${runId}`, "handoff", `${fromAgent.name} handed off work`, `${toAgent.name} received work in ${building.title}.`, fromAgent.id, `run:${runId}`, buildingId, "running", building.visibility));
  return changed({ message, run, thread: threadItem, notification, fromAgent, toAgent, building });
}

function changeRunStatus(state, viewer, runId, status) {
  const run = state.runs.find((item) => item.id === runId);
  if (!run) return { status: 404, changed: false, body: { error: "missing_run", runId } };
  const building = visibleBuildings(state, viewer).find((item) => item.id === run.buildingId);
  if (!building) {
    return { status: 403, changed: false, body: { error: "run_not_visible", runId, buildingId: run.buildingId } };
  }
  if (status === "running" && !["failed", "rejected", "cancelled"].includes(run.status)) {
    return { status: 409, changed: false, body: { error: "run_not_retryable", runId, status: run.status } };
  }
  if (status === "cancelled" && ["accepted", "done"].includes(run.status)) {
    return { status: 409, changed: false, body: { error: "run_closed", runId, status: run.status } };
  }
  run.status = status;
  if (status === "running") run.reviewRequired = false;
  const threadItem = touchThread(state, run.threadId, status);
  return changed({ run, thread: threadItem, building });
}

function decideReview(state, viewer, reviewId, decision) {
  const review = state.reviews.find((item) => item.id === reviewId) || state.reviews.find((item) => item.status === "pending");
  if (!review) return { status: 404, changed: false, body: { error: "missing_review", reviewId } };
  if (review.reviewerId !== viewer) return { status: 403, changed: false, body: { error: "reviewer_only", reviewId } };
  if (review.status !== "pending") return { status: 409, changed: false, body: { error: "review_closed", reviewId, status: review.status } };
  review.status = decision;
  const building = state.buildings.find((item) => item.id === review.buildingId);
  if (isPublicationReview(review)) {
    if (!building) return { status: 404, changed: false, body: { error: "missing_building", buildingId: review.buildingId } };
    if (decision === "accepted") {
      acceptPublication(state, viewer, building, review);
    } else {
      rejectPublication(state, viewer, building, review);
    }
    return changed({ review, building, book: firstBookForBuilding(state, building.id) });
  }
  const run = state.runs.find((item) => item.id === review.runId);
  if (run) {
    run.status = decision === "accepted" ? "done" : "rejected";
    run.reviewRequired = false;
    touchThread(state, run.threadId, run.status);
  }
  const memory = state.books.find((item) => item.id === review.bookId);
  let acceptedMemory = null;
  if (memory) {
    if (decision === "accepted") {
      memory.acceptedMemoryCount += review.acceptedMemoryDelta || 1;
      memory.status = "stable";
      acceptedMemory = acceptBookMemory(state, viewer, review, memory, building);
    }
    memory.pendingReviewCount = Math.max(0, memory.pendingReviewCount - 1);
  }
  if (building) {
    state.auditEvents.push(audit(`audit-review-${decision}-${review.id}`, `review-${decision}`, `${review.title} ${decision}`, decision === "accepted" ? "Accepted agent output entered book memory." : "Rejected agent output returned to the run.", viewer, `review:${review.id}`, building.id, decision === "accepted" ? "stable" : "rejected", building.visibility));
  }
  return changed(acceptedMemory ? { review, run, book: memory, memory: acceptedMemory } : { review, run, book: memory });
}

function isPublicationReview(review) {
  return String(review.artifactRef || "").startsWith("building://") || String(review.runId || "").startsWith("publication-");
}

function acceptBookMemory(state, viewer, review, memory, building) {
  const id = `memory-${review.id}`;
  let item = state.bookMemories.find((candidate) => candidate.id === id);
  if (!item) {
    item = bookMemory(
      id,
      memory.id,
      memory.buildingId,
      review.title,
      review.summary,
      viewer,
      review.id,
      review.runId,
      building ? building.visibility : memory.visibility,
    );
    state.bookMemories.push(item);
  }
  item.status = "accepted";
  item.visibility = building ? building.visibility : memory.visibility;
  return item;
}

function acceptPublication(state, viewer, building, review) {
  building.visibility = "published";
  building.status = "stable";
  syncThreadsForBuilding(state, building);
  for (const memory of state.books) {
    if (memory.buildingId === building.id) {
      memory.visibility = "published";
      memory.status = "stable";
      memory.pendingReviewCount = Math.max(0, memory.pendingReviewCount - 1);
    }
  }
  if (review) review.status = "accepted";
  state.auditEvents.push(audit(`audit-publish-${building.id}`, "publish", `${building.title} published`, "Publication review accepted; building is searchable and placeable.", viewer, `building:${building.id}`, building.id, "stable", "published"));
}

function rejectPublication(state, viewer, building, review) {
  building.visibility = "private_draft";
  building.status = "draft";
  syncThreadsForBuilding(state, building);
  for (const memory of state.books) {
    if (memory.buildingId === building.id) {
      memory.visibility = "private_draft";
      memory.status = "draft";
      memory.pendingReviewCount = Math.max(0, memory.pendingReviewCount - 1);
    }
  }
  if (review) review.status = "rejected";
  state.auditEvents.push(audit(`audit-reject-${building.id}`, "review-reject", `${building.title} publication rejected`, "Publication review rejected; building returned to private drafts.", viewer, `building:${building.id}`, building.id, "draft", "private_draft"));
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
  assert(login.body.session.id.startsWith("session-"), "login session");
  assert(login.body.session.id !== "session-user-a", "opaque login session");
  assert(login.body.session.expiresAt > login.body.session.issuedAt, "login session expiry");
  const headers = { "x-miniapp-session": login.body.session.id };
  const health = dispatch(state, { method: "GET", path: "/miniapp/health", query: new URLSearchParams(), headers: {}, body: {} });
  assert(health.body.status === "ok", "health ok");
  assert(health.body.routeCount === routeCatalog().length, "health route count");
  assert(health.body.activeSessionCount === 1, "health active sessions");
  assert(health.body.auditEventCount >= 1, "health audit count");
  const logoutProbe = dispatch(state, { method: "POST", path: "/miniapp/auth/dev-login", query: new URLSearchParams(), headers: {}, body: { userId: "user-logout", displayName: "Logout Probe" } });
  const logoutHeaders = { "x-miniapp-session": logoutProbe.body.session.id };
  const loggedOut = dispatch(state, { method: "POST", path: "/miniapp/auth/logout", query: new URLSearchParams(), headers: logoutHeaders, body: {} });
  assert(loggedOut.body.state === "revoked", "logout revokes session");
  const revokedSnapshot = dispatch(state, { method: "GET", path: "/miniapp/town/snapshot", query: new URLSearchParams(), headers: logoutHeaders, body: {} });
  assert(revokedSnapshot.status === 401, "revoked session blocked");
  assert(revokedSnapshot.body.error === "session_revoked", "revoked session reason");
  const expiredProbe = dispatch(state, { method: "POST", path: "/miniapp/auth/dev-login", query: new URLSearchParams(), headers: {}, body: { userId: "user-expired", displayName: "Expired Probe" } });
  state.sessions[expiredProbe.body.session.id].expiresAt = "2000-01-01T00:00:00.000Z";
  const expiredSnapshot = dispatch(state, { method: "GET", path: "/miniapp/town/snapshot", query: new URLSearchParams(), headers: { "x-miniapp-session": expiredProbe.body.session.id }, body: {} });
  assert(expiredSnapshot.status === 401, "expired session blocked");
  assert(expiredSnapshot.body.error === "session_expired", "expired session reason");
  const registered = dispatch(state, { method: "POST", path: "/miniapp/auth/dev-login", query: new URLSearchParams(), headers: {}, body: { userId: "user-c", displayName: "Chen Mapper" } });
  assert(registered.body.profile.displayName === "Chen Mapper", "register profile");
  assert(registered.body.profile.setupCompleted === false, "register starts incomplete");
  const registeredHeaders = { "x-miniapp-session": registered.body.session.id };
  const blockedCreate = dispatch(state, { method: "POST", path: "/miniapp/buildings", query: new URLSearchParams(), headers: registeredHeaders, body: { id: "blocked-lab", title: "Blocked Lab" } });
  assert(blockedCreate.status === 403, "profile blocks building create");
  assert(blockedCreate.body.error === "profile_not_ready", "profile block reason");
  const savedProfile = dispatch(state, { method: "POST", path: "/miniapp/me/profile", query: new URLSearchParams(), headers: registeredHeaders, body: { displayName: "Chen Cartographer", roleId: "explorer", avatarRef: "avatar://chen", consentAccepted: true } });
  assert(savedProfile.body.profile.displayName === "Chen Cartographer", "save profile name");
  assert(savedProfile.body.profile.setupCompleted === true, "save profile setup");
  const registeredSnapshot = dispatch(state, { method: "GET", path: "/miniapp/town/snapshot", query: new URLSearchParams(), headers: registeredHeaders, body: {} });
  assert(registeredSnapshot.body.profile.displayName === "Chen Cartographer", "snapshot saved profile");
  assert(registeredSnapshot.body.permissions.profileReady === true, "snapshot profile ready permission");
  assert(registeredSnapshot.body.permissions.canCreateBuilding === true, "snapshot create permission");
  assert(registeredSnapshot.body.permissions.canModerate === false, "registered user cannot moderate");
  assert(registeredSnapshot.body.users.some((item) => item.id === "user-c" && item.name === "Chen Cartographer"), "registered user list");
  const bobLogin = dispatch(state, { method: "POST", path: "/miniapp/auth/dev-login", query: new URLSearchParams(), headers: {}, body: { userId: "user-b" } });
  const bobHeaders = { "x-miniapp-session": bobLogin.body.session.id };
  const deniedAudit = dispatch(state, { method: "GET", path: "/miniapp/admin/audit", query: new URLSearchParams(), headers: bobHeaders, body: {} });
  assert(deniedAudit.status === 403, "admin audit moderator only");
  const adminAudit = dispatch(state, { method: "GET", path: "/miniapp/admin/audit", query: new URLSearchParams("kind=review&limit=5"), headers, body: {} });
  assert(adminAudit.body.items.some((item) => item.kind === "review"), "admin audit filtered");
  assert(adminAudit.body.filters.kind === "review", "admin audit filter echo");
  const adminBackup = dispatch(state, { method: "GET", path: "/miniapp/admin/backup", query: new URLSearchParams(), headers, body: {} });
  assert(adminBackup.body.schemaVersion === 1, "admin backup schema");
  assert(adminBackup.body.counts.auditEvents >= 1, "admin backup audit count");
  assert(!Object.prototype.hasOwnProperty.call(adminBackup.body.state, "sessions"), "admin backup excludes sessions");
  assert(adminBackup.body.excludes.some((item) => item === "rateLimits"), "admin backup excludes rate limits");
  const sharedDraft = dispatch(state, { method: "POST", path: "/miniapp/buildings", query: new URLSearchParams(), headers, body: { id: "shared-lab", title: "Shared Lab" } });
  assert(sharedDraft.body.building.visibility === "private_draft", "create shared draft");
  const shared = dispatch(state, { method: "POST", path: "/miniapp/buildings/share", query: new URLSearchParams(), headers, body: { buildingId: "shared-lab", targetUserId: "user-b" } });
  assert(shared.body.share.targetUserId === "user-b", "share target");
  assert(shared.body.building.visibility === "shared_private", "share visibility");
  const bobSnapshot = dispatch(state, { method: "GET", path: "/miniapp/town/snapshot", query: new URLSearchParams(), headers: bobHeaders, body: {} });
  assert(bobSnapshot.body.buildings.some((item) => item.id === "shared-lab"), "invited user sees shared building");
  assert(hasRelationship(bobSnapshot.body.relationships, "building", "shared-lab", "shared"), "invited user shared relationship");
  assert(bobSnapshot.body.permissions.profileReady === true, "invited user profile ready");
  assert(bobSnapshot.body.permissions.canModerate === false, "invited user cannot moderate");
  const chenSnapshot = dispatch(state, { method: "GET", path: "/miniapp/town/snapshot", query: new URLSearchParams(), headers: registeredHeaders, body: {} });
  assert(!chenSnapshot.body.buildings.some((item) => item.id === "shared-lab"), "uninvited user cannot see shared building");
  assert(!hasRelationship(chenSnapshot.body.relationships, "building", "shared-lab", "shared"), "uninvited user has no shared relationship");
  assert(!chenSnapshot.body.threads.some((item) => item.id === "thread-private-agent-lab"), "private thread hidden from uninvited user");
  assert(!chenSnapshot.body.messages.some((item) => item.threadId === "thread-private-agent-lab"), "private messages hidden from uninvited user");
  const privateSearch = dispatch(state, { method: "GET", path: "/miniapp/discover/search", query: new URLSearchParams("query=shared"), headers: bobHeaders, body: {} });
  assert(!privateSearch.body.items.some((item) => item.targetRef === "building:shared-lab"), "shared private hidden from public search");
  assert(!privateSearch.body.items.some((item) => item.targetRef === "book:book-shared-lab"), "shared private book hidden from public search");
  const userSearch = dispatch(state, { method: "GET", path: "/miniapp/discover/search", query: new URLSearchParams("query=chen"), headers: registeredHeaders, body: {} });
  assert(userSearch.body.items.some((item) => item.kind === "user" && item.targetRef === "user:user-c"), "public user search");
  const productSearch = dispatch(state, { method: "GET", path: "/miniapp/discover/search", query: new URLSearchParams("query=product"), headers, body: {} });
  assert(productSearch.body.items.some((item) => item.kind === "product" && item.targetRef === "product:agent-publishing-kit"), "public product search");
  const postSearch = dispatch(state, { method: "GET", path: "/miniapp/discover/search", query: new URLSearchParams("query=field"), headers, body: {} });
  assert(postSearch.body.items.some((item) => item.kind === "post" && item.targetRef === "post:published-agent-lab"), "public post search");
  const created = dispatch(state, { method: "POST", path: "/miniapp/buildings", query: new URLSearchParams(), headers, body: { id: "smoke-lab", title: "Smoke Lab" } });
  assert(created.body.building.visibility === "private_draft", "create draft");
  const updated = dispatch(state, { method: "POST", path: "/miniapp/buildings/update", query: new URLSearchParams(), headers, body: { buildingId: "smoke-lab", title: "Smoke Workshop", summary: "Edited smoke building summary.", bookTitle: "Smoke Workshop Book", bookSummary: "Edited smoke memory shelf.", tags: ["agent", "edited"] } });
  assert(updated.body.building.title === "Smoke Workshop", "update draft title");
  assert(updated.body.building.summary === "Edited smoke building summary.", "update draft summary");
  assert(updated.body.building.tags.some((tag) => tag === "edited"), "update draft tags");
  assert(updated.body.book.title === "Smoke Workshop Book", "update draft book title");
  assert(updated.body.book.summary === "Edited smoke memory shelf.", "update draft book summary");
  const deniedUpdate = dispatch(state, { method: "POST", path: "/miniapp/buildings/update", query: new URLSearchParams(), headers: bobHeaders, body: { buildingId: "smoke-lab", title: "Bob Edit" } });
  assert(deniedUpdate.status === 403, "update owner only");
  const createdAgent = dispatch(state, { method: "POST", path: "/miniapp/agents", query: new URLSearchParams(), headers, body: { id: "agent-smoke", displayName: "Smoke Agent", buildingId: "smoke-lab" } });
  assert(createdAgent.body.agent.buildingId === "smoke-lab", "create agent building");
  assert(createdAgent.body.message.threadId === "thread-smoke-lab", "create agent message");
  assert(createdAgent.body.thread.buildingId === "smoke-lab", "create agent thread");
  const helperAgent = dispatch(state, { method: "POST", path: "/miniapp/agents", query: new URLSearchParams(), headers, body: { id: "agent-smoke-helper", displayName: "Smoke Helper", buildingId: "smoke-lab" } });
  assert(helperAgent.body.agent.buildingId === "smoke-lab", "create helper agent");
  const handoff = dispatch(state, { method: "POST", path: "/miniapp/agents/handoff", query: new URLSearchParams(), headers, body: { buildingId: "smoke-lab", fromAgentId: "agent-smoke", toAgentId: "agent-smoke-helper", summary: "Prepare the next publish pass." } });
  assert(handoff.body.run.agentId === "agent-smoke-helper", "handoff target agent");
  assert(handoff.body.message.threadId === "thread-smoke-lab", "handoff thread");
  assert(handoff.body.thread.status === "running", "handoff thread status");
  assert(handoff.body.notification.kind === "handoff", "handoff notification");
  const missingRunCancel = dispatch(state, { method: "POST", path: "/miniapp/runs/cancel", query: new URLSearchParams(), headers, body: { runId: "missing-run" } });
  assert(missingRunCancel.status === 404, "missing run cancel blocked");
  const invisibleRunCancel = dispatch(state, { method: "POST", path: "/miniapp/runs/cancel", query: new URLSearchParams(), headers: bobHeaders, body: { runId: handoff.body.run.id } });
  assert(invisibleRunCancel.status === 403, "invisible run cancel blocked");
  const cancelledRun = dispatch(state, { method: "POST", path: "/miniapp/runs/cancel", query: new URLSearchParams(), headers, body: { runId: handoff.body.run.id } });
  assert(cancelledRun.body.run.status === "cancelled", "cancel visible run");
  assert(cancelledRun.body.thread.status === "cancelled", "cancel thread status");
  const retriedRun = dispatch(state, { method: "POST", path: "/miniapp/runs/retry", query: new URLSearchParams(), headers, body: { runId: handoff.body.run.id } });
  assert(retriedRun.body.run.status === "running", "retry cancelled run");
  assert(retriedRun.body.thread.status === "running", "retry thread status");
  const duplicateAgent = dispatch(state, { method: "POST", path: "/miniapp/agents", query: new URLSearchParams(), headers, body: { id: "agent-smoke", displayName: "Smoke Agent", buildingId: "smoke-lab" } });
  assert(duplicateAgent.status === 409, "duplicate agent blocked");
  const publicAgent = dispatch(state, { method: "POST", path: "/miniapp/agents", query: new URLSearchParams(), headers, body: { id: "agent-public-denied", displayName: "Denied Agent", buildingId: "published-agent-lab" } });
  assert(publicAgent.status === 403, "agent creation owner only");
  const earlyPublish = dispatch(state, { method: "POST", path: "/miniapp/buildings/publish", query: new URLSearchParams(), headers, body: { buildingId: "smoke-lab" } });
  assert(earlyPublish.status === 409, "publish requires submit");
  const submitted = dispatch(state, { method: "POST", path: "/miniapp/buildings/submit", query: new URLSearchParams(), headers, body: { buildingId: "smoke-lab" } });
  assert(submitted.body.building.visibility === "submitted", "submit building");
  assert(submitted.body.review.status === "pending", "submit review");
  const rejectedPublication = dispatch(state, { method: "POST", path: "/miniapp/reviews/reject", query: new URLSearchParams(), headers, body: { reviewId: submitted.body.review.id } });
  assert(rejectedPublication.body.review.status === "rejected", "reject publication review");
  assert(rejectedPublication.body.building.visibility === "private_draft", "rejected publication returns draft");
  const resubmitted = dispatch(state, { method: "POST", path: "/miniapp/buildings/submit", query: new URLSearchParams(), headers, body: { buildingId: "smoke-lab" } });
  const acceptedPublication = dispatch(state, { method: "POST", path: "/miniapp/reviews/accept", query: new URLSearchParams(), headers, body: { reviewId: resubmitted.body.review.id } });
  assert(acceptedPublication.body.review.status === "accepted", "accept publication review");
  assert(acceptedPublication.body.building.visibility === "published", "accepted publication is public");
  const publishedUpdate = dispatch(state, { method: "POST", path: "/miniapp/buildings/update", query: new URLSearchParams(), headers, body: { buildingId: "smoke-lab", title: "Published Edit" } });
  assert(publishedUpdate.status === 409, "published update blocked");
  const archived = dispatch(state, { method: "POST", path: "/miniapp/buildings/archive", query: new URLSearchParams(), headers, body: { buildingId: "smoke-lab" } });
  assert(archived.body.building.visibility === "archived", "archive building");
  const restored = dispatch(state, { method: "POST", path: "/miniapp/buildings/restore", query: new URLSearchParams(), headers, body: { buildingId: "smoke-lab" } });
  assert(restored.body.building.visibility === "private_draft", "restore building");
  dispatch(state, { method: "POST", path: "/miniapp/buildings/submit", query: new URLSearchParams(), headers, body: { buildingId: "smoke-lab" } });
  dispatch(state, { method: "POST", path: "/miniapp/buildings/publish", query: new URLSearchParams(), headers, body: { buildingId: "smoke-lab" } });
  const search = dispatch(state, { method: "GET", path: "/miniapp/discover/search", query: new URLSearchParams("query=smoke"), headers, body: {} });
  assert(search.body.items.some((item) => item.targetRef === "building:smoke-lab"), "published search");
  const agentSearch = dispatch(state, { method: "GET", path: "/miniapp/discover/search", query: new URLSearchParams("query=agent"), headers, body: {} });
  assert(agentSearch.body.items.some((item) => item.kind === "agent"), "agent search");
  assert(agentSearch.body.items.some((item) => item.kind === "book"), "book search");
  const reviewSearch = dispatch(state, { method: "GET", path: "/miniapp/discover/search", query: new URLSearchParams("query=review"), headers, body: {} });
  assert(reviewSearch.body.items.some((item) => item.kind === "demand"), "review demand search");
  const placed = dispatch(state, { method: "POST", path: "/miniapp/buildings/place", query: new URLSearchParams(), headers, body: { buildingId: "published-agent-lab" } });
  assert(placed.body.placement.buildingId === "published-agent-lab", "place building");
  const asked = dispatch(state, { method: "POST", path: "/miniapp/buildings/query", query: new URLSearchParams(), headers, body: { buildingId: "policy-hall", body: "smoke?" } });
  assert(asked.body.review.status === "pending", "query review");
  const sent = dispatch(state, { method: "POST", path: "/miniapp/messages/send", query: new URLSearchParams(), headers, body: { buildingId: "policy-hall", body: "hello policy hall" } });
  assert(sent.body.message.threadId === "thread-policy-hall", "send message thread");
  assert(sent.body.thread.id === "thread-policy-hall", "send message durable thread");
  assert(sent.body.message.text === "hello policy hall", "send message text");
  const ackedNotice = dispatch(state, { method: "POST", path: "/miniapp/messages/ack", query: new URLSearchParams(), headers, body: { noticeId: "notice-review" } });
  assert(ackedNotice.body.notice.unread === false, "ack notice unread false");
  assert(ackedNotice.body.notificationState.userId === "user-a", "ack notice viewer state");
  const subscribed = dispatch(state, { method: "POST", path: "/miniapp/messages/subscribe", query: new URLSearchParams(), headers, body: { noticeId: "notice-subscribe", targetRef: "subscription:wechat" } });
  assert(subscribed.body.subscription.status === "requested", "subscription requested");
  assert(subscribed.body.notice.unread === false, "subscription notice acknowledged");
  const bobAfterAck = dispatch(state, { method: "GET", path: "/miniapp/town/snapshot", query: new URLSearchParams(), headers: bobHeaders, body: {} });
  assert(bobAfterAck.body.notifications.some((item) => item.id === "notice-review" && item.unread === true), "ack is viewer scoped");
  const report = dispatch(state, { method: "POST", path: "/miniapp/moderation/report", query: new URLSearchParams(), headers, body: { buildingId: "published-agent-lab", reason: "smoke safety report" } });
  assert(report.body.case.status === "pending", "report pending");
  assert(report.body.case.targetRef === "building:published-agent-lab", "report target");
  const duplicateReport = dispatch(state, { method: "POST", path: "/miniapp/moderation/report", query: new URLSearchParams(), headers, body: { buildingId: "published-agent-lab", reason: "second smoke safety report" } });
  assert(duplicateReport.body.case.status === "pending", "second report allowed");
  const limitedReport = dispatch(state, { method: "POST", path: "/miniapp/moderation/report", query: new URLSearchParams(), headers, body: { buildingId: "published-agent-lab", reason: "third smoke safety report" } });
  assert(limitedReport.status === 429, "report rate limited");
  assert(limitedReport.body.error === "rate_limited", "report rate limit reason");
  const deniedHide = dispatch(state, { method: "POST", path: "/miniapp/moderation/hide", query: new URLSearchParams(), headers: bobHeaders, body: { caseId: report.body.case.id, buildingId: "published-agent-lab" } });
  assert(deniedHide.status === 403, "moderation reviewer only");
  assert(deniedHide.body.error === "moderator_only", "moderation denial reason");
  const hidden = dispatch(state, { method: "POST", path: "/miniapp/moderation/hide", query: new URLSearchParams(), headers, body: { caseId: report.body.case.id, buildingId: "published-agent-lab" } });
  assert(hidden.body.building.visibility === "hidden", "hide building");
  const hiddenSearch = dispatch(state, { method: "GET", path: "/miniapp/discover/search", query: new URLSearchParams("query=published"), headers, body: {} });
  assert(!hiddenSearch.body.items.some((item) => item.targetRef === "building:published-agent-lab"), "hidden building removed from search");
  const takedown = dispatch(state, { method: "POST", path: "/miniapp/moderation/takedown", query: new URLSearchParams(), headers, body: { caseId: report.body.case.id, buildingId: "published-agent-lab" } });
  assert(takedown.body.building.visibility === "takedown", "takedown building");
  const deniedAppeal = dispatch(state, { method: "POST", path: "/miniapp/moderation/appeal", query: new URLSearchParams(), headers: registeredHeaders, body: { caseId: report.body.case.id, buildingId: "published-agent-lab", reason: "not mine" } });
  assert(deniedAppeal.status === 403, "appeal owner only");
  assert(deniedAppeal.body.error === "owner_only", "appeal denial reason");
  const appealed = dispatch(state, { method: "POST", path: "/miniapp/moderation/appeal", query: new URLSearchParams(), headers: bobHeaders, body: { caseId: report.body.case.id, buildingId: "published-agent-lab", reason: "owner appeal smoke" } });
  assert(appealed.body.case.status === "appeal_requested", "appeal requested");
  assert(appealed.body.case.actionLabel === "Review appeal", "appeal action label");
  assert(appealed.body.building.visibility === "takedown", "appeal keeps restricted visibility");
  assert(appealed.body.building.status === "appeal", "appeal building status");
  const toolAck = dispatch(state, { method: "POST", path: "/miniapp/tool-results/ack", query: new URLSearchParams(), headers, body: { toolResultId: "tool-policy-summary" } });
  assert(toolAck.body.toolResult.status === "done", "tool result acknowledged");
  const accepted = dispatch(state, { method: "POST", path: "/miniapp/reviews/accept", query: new URLSearchParams(), headers, body: { reviewId: asked.body.review.id } });
  assert(accepted.body.review.status === "accepted", "accept review");
  assert(accepted.body.memory.id === `memory-${asked.body.review.id}`, "accepted memory record");
  assert(accepted.body.memory.safeSummary === "Accept this local answer into building memory.", "accepted memory safe summary");
  const ownedAsked = dispatch(state, { method: "POST", path: "/miniapp/buildings/query", query: new URLSearchParams(), headers, body: { buildingId: "smoke-lab", body: "owned memory?" } });
  const ownedAccepted = dispatch(state, { method: "POST", path: "/miniapp/reviews/accept", query: new URLSearchParams(), headers, body: { reviewId: ownedAsked.body.review.id } });
  assert(ownedAccepted.body.memory.bookId === "book-smoke-lab", "owned accepted memory book");
  const snapshot = dispatch(state, { method: "GET", path: "/miniapp/town/snapshot", query: new URLSearchParams(), headers, body: {} });
  assert(snapshot.body.permissions.canModerate === true, "moderator snapshot permission");
  assert(snapshot.body.permissions.canReview === true, "reviewer snapshot permission");
  assert(snapshot.body.bookMemories.some((item) => item.id === accepted.body.memory.id && item.bookId === "book-policy-hall"), "snapshot accepted memory");
  assert(snapshot.body.notifications.some((item) => item.id === "notice-review" && item.unread === false), "snapshot acknowledged notice");
  assert(snapshot.body.notificationStates.some((item) => item.noticeId === "notice-review" && item.state === "acknowledged"), "snapshot notification state");
  assert(snapshot.body.subscriptions.some((item) => item.targetRef === "subscription:wechat" && item.status === "requested"), "snapshot subscription");
  assert(snapshot.body.threads.some((item) => item.id === "thread-policy-hall"), "snapshot policy thread");
  assert(snapshot.body.threads.some((item) => item.id === "thread-smoke-lab" && item.visibility === "published"), "snapshot published thread");
  assert(hasRelationship(snapshot.body.relationships, "building", "private-agent-lab", "owner"), "snapshot owner relationship");
  assert(hasRelationship(snapshot.body.relationships, "building", "team-studio", "team"), "snapshot team relationship");
  assert(hasRelationship(snapshot.body.relationships, "placement", "placement-user-a-policy-hall", "owner"), "snapshot placement relationship");
  assert(snapshot.body.placements.length >= 2, "snapshot placements");
  assert(snapshot.body.messages.some((item) => item.id === sent.body.message.id), "snapshot sent message");
  assert(snapshot.body.toolResults.some((item) => item.id === "tool-policy-summary" && item.status === "done"), "snapshot tool result ack");
  assert(snapshot.body.moderationCases.some((item) => item.id === report.body.case.id), "snapshot moderation case");
  assert(snapshot.body.moderationCases.some((item) => item.status === "appeal_requested"), "snapshot appeal case");
  assert(snapshot.body.runs.some((item) => item.id === handoff.body.run.id), "snapshot handoff run");
  assert(snapshot.body.notifications.some((item) => item.id === handoff.body.notification.id), "snapshot handoff notice");
  const ownership = dispatch(state, { method: "GET", path: "/miniapp/me/ownership", query: new URLSearchParams(), headers, body: {} });
  assert(ownership.body.permissions.canModerate === true, "ownership moderator permission");
  assert(ownership.body.permissions.profileReady === true, "ownership profile ready permission");
  assert(ownership.body.bookMemories.some((item) => item.id === ownedAccepted.body.memory.id), "ownership accepted memory");
  assert(ownership.body.notificationStates.some((item) => item.noticeId === "notice-subscribe"), "ownership notification state");
  assert(ownership.body.subscriptions.some((item) => item.targetRef === "subscription:wechat"), "ownership subscription");
  assert(ownership.body.threads.some((item) => item.id === "thread-smoke-lab"), "ownership thread");
  assert(hasRelationship(ownership.body.relationships, "building", "smoke-lab", "owner"), "ownership building relationship");
  assert(hasRelationship(ownership.body.relationships, "book", "book-smoke-lab", "owner"), "ownership book relationship");
  assert(hasRelationship(ownership.body.relationships, "agent", "agent-smoke", "owner"), "ownership agent relationship");
  assert(ownership.body.items.some((item) => item.targetRef === "building:smoke-lab"), "ownership building");
  assert(ownership.body.items.some((item) => item.targetRef === "agent:agent-smoke"), "ownership agent");
  assert(ownership.body.items.some((item) => item.targetRef === "agent:agent-smoke-helper"), "ownership helper agent");
  assert(ownership.body.items.some((item) => item.targetRef === "building:smoke-lab" && item.actionMessage === "tab-discover"), "ownership building action");
  assert(ownership.body.items.some((item) => item.targetRef === "agent:agent-smoke" && item.actionMessage === "tab-messages"), "ownership agent action");
  assert(ownership.body.stats.some((item) => item.id === "books" && item.value >= 1), "ownership books");
  assert(ownership.body.stats.some((item) => item.id === "threads" && item.value >= 1), "ownership threads");
  saveState(statePath, state);
  rmSync(statePath);
  console.log("moontown-miniapp-backend smoke ok");
}

function assert(condition, label) {
  if (!condition) throw new Error(`smoke failed: ${label}`);
}

function hasRelationship(items, kind, id, relation) {
  return items.some((item) => item.kind === kind && item.id === id && item.relation === relation);
}

const options = parseArgs(process.argv.slice(2));
if (options.smoke) {
  smoke(options);
} else {
  serve(options);
}
