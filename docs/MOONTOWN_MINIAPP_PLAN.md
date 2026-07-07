# Moontown Mini-App Port Plan

This document plans the Moontown-to-WeChat mini-app product slice that should
dogfood Bunnia without mixing Moontown product semantics into the framework.

The goal is a multi-user Moontown client:

- a full-screen town map as the primary surface
- buildings that users can inspect, query, create, share, publish, search, and
  place
- agent/chat flows for asking buildings questions and creating agents
- durable book-backed memory behind buildings
- clear ownership, permissions, publishing, audit, and review boundaries

## Core Boundary

```text
WeChat mini-app
  -> Bunnia generated frontend
  -> Moontown mini-app backend API
  -> Moontown books, buildings, daemon/runtime, MoonBook, MoonClaw, Moondesk
```

Bunnia owns:

- platform-neutral UI primitives
- generated WeChat output
- route, render, update, map, and agentic UI diagnostics
- the dogfood mini-app example

Moontown owns:

- users, workspaces, town semantics, buildings, books, ledgers, agents, and
  publication policy
- backend contracts and runtime adapters
- real data persistence and execution
- integration with MoonBook, MoonClaw, Moondesk, and daemon state

The generated mini-app must not contain Moontown filesystem paths, local daemon
control, app secrets, privileged keys, or desktop-only runtime assumptions.

## Product Model

Best relationship:

```text
User
  owns profile, sessions, preferences, private work

Organization
  groups users for shared buildings, team maps, and shared books

Workspace
  contains private or organization-scoped drafts, buildings, agents, and runs

Town
  is a map layer or discovery space, not the only source of truth

Building
  is the primary visible product object and protocol place

Book
  is the durable memory, ledger, review queue, and accepted knowledge behind a
  building

Agent
  is a temporary or reusable worker/persona attached to a user, building, book,
  or run

Run
  records a chat/query/tool/review lifecycle with status and audit trail
```

Rule of thumb:

```text
users own intent and permissions
buildings are places
books are memory
agents are workers
towns are map/discovery layers
runs are auditable work records
```

## Visibility And Ownership

Every building and book-backed surface needs both an owner and a scope.

Owner kinds:

- `user`
- `organization`
- `system`

Visibility states:

- `private_draft`: only owner can see and edit
- `shared_private`: visible to explicit members
- `submitted_for_publish`: awaiting review or validation
- `published`: searchable and placeable by allowed users
- `archived`: hidden from normal discovery, preserved for audit/history

Scopes:

- `personal`: visible only to one user
- `team`: visible to an organization or invited members
- `town_public`: searchable and placeable in public town layers
- `system_public`: official/default buildings shipped by the product

Separate the building from its map placement:

```text
Building
  canonical identity, owner, book links, capabilities, publication state

BuildingPlacement
  map layer, x/y/region, display order, pinned state, local user/team overrides
```

This lets one published building appear on many user maps without copying its
knowledge or ownership.

## Phase 0: Product And Architecture Boundary

Classification: foundation.

Goal: define the product slice and prevent framework/product mixing.

Tasks:

- Write the Moontown mini-app boundary and non-goals.
- Decide which repo owns each artifact.
- Define local development flow with this Mac as the backend host.
- Define production flow with deployed HTTPS or WeChat cloud backend.
- Document what cannot run inside a WeChat mini-app: local filesystem, desktop
  daemon, MoonClaw process control, app secrets, and privileged local APIs.

Deliverables:

- This plan.
- A compact architecture diagram.
- Bunnia README pointer to this product integration plan.

Acceptance:

- Bunnia remains a reusable framework.
- Moontown product code stays in Moontown or dogfood examples.
- The first vertical slice can be built without a production backend.

## Phase 1: Contracts And Data Shape

Classification: feature.

Goal: define API and DTO contracts before building real backend behavior.

Moontown packages to add:

```text
src/miniapp_contracts/
src/miniapp_projection/
src/miniapp_runtime/
```

Core DTOs:

- `MiniappUser`
- `MiniappSession`
- `MiniappOrganization`
- `MiniappWorkspace`
- `MiniappTownSnapshot`
- `MiniappTownLayer`
- `MiniappBuilding`
- `MiniappBuildingPlacement`
- `MiniappBuildingPublication`
- `MiniappBookSummary`
- `MiniappAgent`
- `MiniappThread`
- `MiniappMessage`
- `MiniappRun`
- `MiniappPermission`
- `MiniappAuditEvent`

Initial API contract:

```text
POST /auth/wechat/login
POST /auth/dev/login
POST /auth/logout
GET  /me
GET  /workspaces
GET  /town/snapshot
GET  /town/layers
GET  /buildings/search
GET  /buildings/:id
POST /buildings
PATCH /buildings/:id
POST /buildings/:id/share
POST /buildings/:id/publish
POST /buildings/:id/place
DELETE /placements/:id
GET  /buildings/:id/book
GET  /buildings/:id/agents
POST /buildings/:id/query
GET  /agents
POST /agents
PATCH /agents/:id
POST /chat/send
GET  /threads/:id
GET  /runs/:id/status
POST /runs/:id/cancel
POST /runs/:id/retry
POST /reviews/:id/decision
```

Acceptance:

- Contracts are stable enough for fake backend and Bunnia UI to share.
- Every response has ids, versions, timestamps, and permission hints.
- Frontend can tell which actions are allowed without guessing policy.

Current evidence:

- Moontown `src/miniapp_contracts` owns serializable DTOs for users, sessions,
  organizations, workspaces, buildings, placements, books, agents, threads,
  messages, runs, permissions, audit events, search results, and town snapshots,
  plus the endpoint catalog for login, town, building, chat, run, and review
  operations.
- Moontown `src/miniapp_projection` owns pure viewer-context, visibility,
  edit/place/publish permission, snapshot filtering, and building-search policy
  so frontend and backend can share the same product vocabulary before runtime
  storage or HTTP serving exists.

## Phase 2: Identity, Login, And Tenancy

Classification: feature.

Goal: support different users and isolated private data.

Tasks:

- Add dev login for local testing.
- Add WeChat login contract for production.
- Store user profile, session, workspace, organization, and membership data.
- Define permission roles: `owner`, `editor`, `viewer`, `publisher`, `admin`.
- Ensure every building, book, placement, agent, thread, and run is scoped.

Important rules:

- WeChat app secret lives only on the backend.
- Frontend receives a product session token, not raw WeChat secret material.
- Private user data never appears in public town snapshots.
- Organization data requires membership.

Acceptance:

- Two local users can login separately.
- User A cannot see User B private buildings.
- A shared building appears only for invited users.
- Published/system buildings appear in search and public town snapshots.

Current evidence:

- Moontown `src/miniapp_identity` owns pure dev-login/session state,
  user/org/workspace fixtures, membership and workspace-access roles, session
  lookup, session-to-viewer-context conversion, and session-scoped snapshot
  projection/search helpers.
- Identity tests cover separate local sessions for two users, session expiry,
  organization/workspace role propagation, private building isolation, shared
  organization building visibility, and search that excludes invisible private
  buildings.

## Phase 3: Building Registry And Map Placement

Classification: feature.

Goal: make buildings the core product object.

Tasks:

- Implement building creation, update, sharing, publishing state, and archive
  state.
- Implement placement records separate from buildings.
- Model personal, team, public, and system town layers.
- Add tags, category, capabilities, owner label, summary, status, and activity
  fields for search.
- Add search filters for name, tag, owner, capability, visibility, freshness,
  and town layer.

Building kinds to start:

- `agent_lab`
- `policy_hall`
- `knowledge_house`
- `project_studio`
- `market_square`
- `review_council`
- `system_gateway`

Acceptance:

- User can create a private building.
- User can place it on their personal map.
- User can search published buildings.
- User can place a published building on their own map.
- Placement changes do not fork the building's durable book.

Current evidence:

- Moontown `src/miniapp_buildings` owns pure create/update/share/publish/archive,
  place/remove-placement, and filtered search policy over `MiniappTownSnapshot`
  without introducing storage or HTTP coupling.
- Building registry tests cover private building creation with a generated
  book projection, edit/share/submit/publish flow, placement records that do
  not fork building identity, and search filters for tag, owner, visibility,
  capability, and layer while preserving visibility rules.

## Phase 4: Books Behind Buildings

Classification: feature.

Goal: connect buildings to Moontown's durable architecture.

Tasks:

- Define `BuildingBookBinding`.
- Map each building to one primary book and optional support books.
- Project book state into mini-app safe summaries.
- Add ledgers for requests, reviews, accepted memory, and publication events.
- Keep raw/private book content server-side unless explicitly published.

Recommended binding:

```text
Building
  -> primary book: accepted knowledge and building state
  -> request ledger: pending user requests
  -> review ledger: human/agent review items
  -> run ledger: query and agent execution history
  -> projection: mini-app safe summary
```

Acceptance:

- Building detail shows book-backed memory/status.
- Querying a building records a run against the building/book.
- Accepted answers can become book memory through review.
- Public building summaries do not expose private ledgers or drafts.

Current evidence:

- Moontown `src/miniapp_books` owns pure building-to-book binding, primary and
  support book projection, ledger id derivation for requests, reviews, accepted
  memory, publication, and runs, plus safe building book detail projection.
- Book tests cover editor-visible private ledger ids, public viewer projection
  without ledger exposure, query recording as a run against the building book,
  accepted reviewed output becoming book memory counters, and hidden buildings
  rejecting book detail/query access.

## Phase 5: Bunnia Mini-App Vertical Slice

Classification: feature.

Goal: build the smallest real Moontown mini-app experience.

Bunnia example:

```text
examples/moontown_miniapp/
```

First screen:

- full-screen town map
- building markers
- selected building drawer
- agent/chat drawer
- search drawer
- create building form
- create agent form

Use fake backend data first:

- 2 users
- 1 organization
- 8 to 12 buildings
- public, private, shared, and system examples
- 2 to 3 agents
- a few threads and run statuses

Acceptance:

- Generated WeChat output opens in DevTools.
- User can switch mock user in local backend.
- Private/shared/public building visibility is visible.
- User can tap building, ask a question, and see a mock response.
- User can create a private building and place it.
- User can search and place a published building.
- Bunnia inspect reports first-screen, update-payload, scene, repeated-list,
  agent, and backend pressure.

Current evidence:

- Bunnia `examples/moontown_miniapp` generates a WeChat project at
  `pages/moontown/index` with a full-screen Moontown scene, visible building
  markers, selected-building drawer, search drawer, chat/review drawer, and
  create-building/create-agent forms backed by runtime patches.
- The example fixture has 2 users, 1 organization, 10 buildings across
  private/shared/published/system-like ownership, 3 agents, mock messages, user
  switching, private building creation, published building placement, building
  search, and mock ask/answer review flow.
- Tests cover generated WXML/JS/project files, backend endpoint wiring,
  visibility filtering, create/search/agent model operations, scene/render
  pressure, agent deltas, snapshot deltas, communication pressure, backend
  pressure, asset/quality plans, and WeChat project inspection.

## Phase 6: Agent And Chat Runtime

Classification: feature.

Goal: make agent interaction first-class without making agents the source of
truth.

Tasks:

- Add agent profile, capability, run, message, tool result, and review DTOs.
- Support send, stream/status, cancel, retry, and review decision flows.
- Add building-scoped and user-scoped agents.
- Add thread links to buildings, map markers, books, and runs.
- Keep large conversations windowed and paginated.

Rules:

- Agents do not own durable truth.
- Agent output becomes book memory only after policy/review acceptance.
- Every run records user, building, book, agent, status, timestamps, and audit
  entries.
- Risky actions require explicit review controls.

Acceptance:

- User creates an agent.
- User attaches agent to a building.
- User asks a building through an agent.
- Run status is visible as pending/running/waiting-review/done/failed/cancelled.
- Retry and cancel are represented in backend contract and mini-app UI.

## Phase 7: Publishing, Discovery, And Moderation

Classification: feature with safety hardening.

Goal: safely turn private buildings into searchable town assets.

Publishing flow:

```text
private_draft
  -> submitted_for_publish
  -> validation
  -> moderation/review
  -> published
  -> searchable/placeable
```

Validation should check:

- required metadata
- owner permissions
- safe public summary
- no private book paths or secrets
- allowed assets
- category and tag quality
- duplicate/spam signals

Discovery:

- search by name, tag, owner, category, capability, popularity, freshness, and
  public book summary
- official/system buildings ranked separately from user-published buildings
- public building detail shows summary, owner/publisher, capabilities, safe
  preview, and placement action

Acceptance:

- User can submit building for publication.
- Reviewer/admin can approve or reject.
- Approved building appears in public search.
- Other users can place it on their map.
- Rejected building remains private with review reason.

Current evidence:

- Moontown `src/miniapp_publishing` owns publication policy, validation,
  moderation decisions, safe public previews, and ranked public discovery
  without mixing storage, HTTP, or Bunnia framework concerns into product logic.
- Validation checks metadata, owner/publisher permission, category/kind match,
  summary length and private/secret material, primary book public projection,
  allowed asset refs, tag quality, and duplicate public title signals.
- Tests cover valid and invalid publication requests, submit/approve/reject
  flows with review reasons, official/system discovery ranking over
  user-published buildings, category/capability/owner/freshness filters, public
  preview hiding for private drafts, placement eligibility, and moderator
  hiding of already-published buildings.

## Phase 8: Local Backend On This Mac

Classification: feature.

Goal: make the whole slice testable locally before production backend work.

Recommended path:

1. Add Moontown CLI commands that emit and mutate mini-app JSON.
2. Add a tiny local HTTP wrapper around those commands or package APIs.
3. Use dev login and local storage.
4. Point WeChat DevTools at the local backend.

Example local commands:

```text
moon run src/cmd/main -- miniapp snapshot --user user-a
moon run src/cmd/main -- miniapp buildings search --query policy
moon run src/cmd/main -- miniapp buildings create ...
moon run src/cmd/main -- miniapp buildings publish ...
moon run src/cmd/main -- miniapp chat send ...
```

Acceptance:

- Local backend starts on this Mac.
- DevTools can call it.
- Two users have isolated private data.
- Public buildings are shared through search.
- Bunnia generated UI can exercise the complete loop.

## Phase 9: Real Backend And Deployment

Classification: hardening and production readiness.

Goal: support real WeChat users.

Tasks:

- Real WeChat login.
- HTTPS domain or WeChat cloud deployment.
- Database storage.
- Object storage for published assets.
- Session and token rotation.
- Rate limits and abuse controls.
- Audit logs.
- Backups.
- Monitoring and error reporting.

Acceptance:

- Phone can login and load the town.
- No frontend bundle contains secrets.
- All network domains are approved.
- User data is scoped by permissions.
- Published data is explicitly reviewed.

This phase overlaps with production readiness and should remain deferred until
the local vertical slice proves product and rendering quality.

## Helpful Things Not To Forget

These are not optional once real users are involved:

- **Audit trail**: every login, publish, share, permission change, run, review,
  and delete/archive action should be recorded.
- **Deletion and export**: users need a way to archive/delete private buildings
  and export their data later.
- **Versioning**: buildings, books, API responses, and projections need version
  fields so stale mini-app updates are detectable.
- **Conflict policy**: two editors changing a shared building need predictable
  merge or last-write behavior.
- **Moderation**: public buildings need review, report, hide, and takedown
  states.
- **Invite model**: shared private buildings need invite links or explicit
  membership grants.
- **Quota/rate limits**: building creation, agent creation, chat runs, publish
  submissions, and search need limits.
- **Asset policy**: published building images/assets need size, format, origin,
  and license checks.
- **Privacy boundary**: public building summaries must be generated from safe
  projection fields, not raw private books.
- **Offline/cache behavior**: mini-app should show stale town snapshots clearly
  when backend calls fail.
- **Notifications**: publication review, shared invite, run completion, and
  review-needed events eventually need notification hooks.
- **Admin tools**: reviewers need a simple queue for publish approvals and
  reported buildings.
- **Search quality**: tags alone are not enough; include capability, owner,
  freshness, and book-summary indexes.
- **Observability**: backend should expose route latency, failure count, run
  lifecycle count, and rejected permission checks.
- **Seed town**: ship official system buildings so new users have a useful town
  before creating anything.

## First Concrete Milestone

```text
M0: Local fake-backed Moontown mini-app slice
```

Done when:

- Moontown has mini-app DTOs for users, buildings, placements, books, agents,
  threads, and runs.
- Bunnia has `examples/moontown_miniapp`.
- The example generates a WeChat project.
- WeChat DevTools opens the project.
- User A and User B see different private buildings.
- Both users can search and place the same public building.
- Building chat/create-agent flows are represented in UI and backend contract.
- Bunnia diagnostics show acceptable first-screen, update, scene, and agentic
  pressure for the slice.
