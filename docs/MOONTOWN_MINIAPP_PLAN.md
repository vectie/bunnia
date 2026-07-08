# Moontown Mini-App Port Plan

This document plans the Moontown-to-WeChat mini-app product slice that should
dogfood Bunnia without mixing Moontown product semantics into the framework.

The goal is a multi-user Moontown client:

- a full-screen town map as the primary surface
- buildings that users can inspect, query, create, share, publish, archive,
  search, and place
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

## Reference Design Migration Scope

The reference design in `/Users/kq/Desktop/ref_design` is useful for product
maturity, but its "realm" page should not become a second map concept. In
Moontown, Realm is simply the existing full-screen town map: the user's spatial
home, building launcher, agent surface, and discovery context.

Migration rule:

```text
reference Realm page -> existing Moontown map
all other reference pages -> surrounding product maturity around the map
```

This means the remaining migration work is not "build a realm". The realm is
already the Moontown map. The work is to make the app around that map feel like
a complete mini-app: first-run guidance, login/profile, public discovery,
messages, ownership, publishing, search, and agent communication.

The mini-app should keep Moontown's current tile-gamified style:

- map-first interaction instead of generic social-app page stacks
- buildings, districts, signposts, docks, halls, and kiosks as feature entries
- lightweight panels and drawers over the map, not large unrelated card pages
- bottom tabs as navigation shortcuts, with Realm opening the same map surface
- bright, readable tile colors and crisp pixel/2.5D assets over blurred hero art
- small motion, stable hit targets, and fast touch feedback for WeChat devices

Bunnia should only absorb generic framework primitives from this work:

- onboarding stepper
- identity/setup forms
- tab shell
- floating action controls
- search and feed lists
- profile/message surfaces
- scene overlays and drawers

Moontown owns the product semantics:

- AI Walker wording
- town/circle/building labels
- product market, demand hall, event calendar, city guide, and OPC hub
- role names, onboarding copy, map art, ranking rules, and business policy

## Product Maturity Migration Rule

Keep one mental model:

```text
Realm = the existing Moontown map
Home = town pulse and shortcuts around the map
Discover = search and public placement
Messages = human and agent communication
My = profile, ownership, drafts, and publishing state
Buildings = the visible product units on the map
Books = durable memory behind buildings
Agents = workers attached to users, buildings, books, or runs
```

Do not migrate the reference screenshots literally as unrelated pages. Translate
each function into a Moontown place, drawer, overlay, or tab surface. If a
feature has a spatial meaning, prefer a building or district. If it is account
or workflow state, prefer a tile-styled panel attached to `Home`, `Messages`, or
`My`.

Visual direction:

- use the current tile map as the strongest brand signal
- use compact plaques, signposts, badges, banners, drawers, and kiosk panels
- keep edges crisp and colors readable on WeChat phones
- avoid heavy hero sections, blurred map backdrops, generic social cards, and
  large decorative gradients
- keep every list windowed or scoped so the map-heavy app stays fast
- make agent status visible as map badges, message rows, and run plaques rather
  than separate chat-only screens

## Reference Page Interpretation

| Reference page | What it does | Moontown migration |
| --- | --- | --- |
| AI Walker welcome | First-run entry into an AI city fantasy. | Onboarding step 1; introduce the town map and agent-guided city. |
| Inspiration square | Explains public sharing and community discoveries. | Public activity stream around buildings, agents, books, and runs. |
| Community center | Introduces feature zones such as product market, demands, events, and guide. | Convert each zone into a tile building or district entrance on the map. |
| Navigation intro | Teaches bottom tabs and primary app areas. | Keep as onboarding step; map tab opens existing full-screen Realm/map. |
| Identity selection | Collects nickname, role, and agreement consent. | Register/profile setup after dev or WeChat login. |
| Community home | Shows a visual camp, stats, member avatars, search, publish, and feature entries. | Map landing state plus building stats, nearby agents, and search/publish actions. |
| Circle engine/feed | Combines feature launchers with dynamic content. | District drawer from the map; cards become building categories and activity feeds. |
| Discover | Searches people, circles, products, needs, and posts. | Unified search for buildings, users, agents, books, events, demands, and posts. |
| Realm | Visual graph/map of domains. | Already covered by Moontown map; do not create a second graph page. |
| Messages | Follows, interactions, system notices, and WeChat subscription prompt. | Agent/human notification center with run, review, publish, share, and system events. |
| Profile | User identity, stats, wallet/actions, and owned content tabs. | Account page for owned buildings, books, agents, drafts, published items, and activity. |

## Migration Execution Order

The migration should advance from the biggest user-facing gaps first. Realm/map
work is the baseline, not a separate app phase, unless map clarity or touch
constraints regress.

| Order | Phase | Type | Purpose | Primary output |
| --- | --- | --- | --- | --- |
| 0 | Realm Baseline | hardening | Keep the existing full-screen tile map crisp, bounded, draggable, pinchable, and recognizably Moontown. | Stable map route, asset pipeline, edge handling, building hit targets. |
| 1 | Tile App Shell | feature | Turn the map demo into a real mini-app shell. | `Home`, `Discover`, `Realm`, `Messages`, `My` tabs with Realm returning to the same map. |
| 2 | Onboarding And Identity | feature | Let first-time users enter the town, choose profile/role, and satisfy consent gates. | First-run guide, login/profile setup, profile readiness checks. |
| 3 | Home Town Pulse | feature | Replace generic home/reference pages with a tile-styled town pulse around the map. | Activity stream, recent runs, building shortcuts, town stats, district entries. |
| 4 | Discover And Placement | feature | Make published town content searchable and reusable. | Unified search, filters, public building results, "place on my map" flow. |
| 5 | Messages And Agent Communication | feature | Treat agent events and human interactions as first-class communication. | Notifications, agent run updates, review requests, share/publish events, deep links. |
| 6 | My Ownership Center | feature | Give users control over private work and published work. | Owned buildings/books/agents, drafts, submitted items, published items, archive state. |
| 7 | Building Lifecycle And Books | feature | Connect visible buildings to durable Moontown memory and workflow state. | Create/share/publish/archive, book binding, permissions, audit trail. |
| 8 | Tile Style And Performance Pass | hardening | Keep the mature app fast and visually coherent. | Visual audit, list windowing, asset budgets, setData/delta checks, DevTools validation. |

Near-term build order:

1. Keep Phase 0 stable while changing other screens.
2. Finish Phase 3 next because Home is currently the largest maturity gap after
   shell, identity, discovery, messages, and ownership slices.
3. Expand Phases 4-7 with real backend contracts once the local product shape is
   coherent.
4. Run Phase 8 after each feature slice, not only at the end, because the app is
   map-heavy and can become slow quickly.

## Phase-By-Phase Reference Migration

These phases sit on top of the existing backend and map phases below. They
should be implemented in Moontown product/example code first, while Bunnia only
keeps reusable primitives.

### Reference Phase A: Tile-Gamified App Shell

Classification: feature.

Goal: wrap the current full-screen map with mature mini-app navigation while
keeping the map as the main surface.

Tasks:

- Add bottom tabs: `Home`, `Discover`, `Realm`, `Messages`, `My`.
- Route `Realm` to the existing full-screen Moontown map.
- Keep search and publish as floating map actions.
- Use tile-styled icons, building plaques, signpost labels, and drawer panels.
- Avoid generic rounded social cards when a tile/building entry can represent
  the same action.

Acceptance:

- Tapping Realm always returns to the same map state, not a separate mock graph.
- Home can summarize map activity without replacing the map as the product core.
- Navigation chrome does not reduce touch performance or map clarity.

### Reference Phase B: First-Time Onboarding

Classification: feature.

Goal: explain the product fantasy and main actions before the user enters the
map.

Tasks:

- Add four onboarding steps: welcome, inspiration/activity, community/building
  zones, navigation.
- Use Moontown tile art or cropped map scenes instead of unrelated hero art.
- Store `onboarding_completed` per user/session.
- Keep copy product-specific and data-driven, not hardcoded into Bunnia core.

Acceptance:

- New users see onboarding once.
- Returning users go directly to the map.
- Onboarding assets stay within mini-app package budget or use remote-safe
  loading later.

### Reference Phase C: Identity And Consent Setup

Classification: feature.

Goal: let different users establish profile, role, and consent before creating
or publishing buildings.

Tasks:

- Add nickname/avatar/profile setup.
- Add role selection as Moontown config.
- Add service agreement and privacy consent state.
- Connect profile setup to dev login now and WeChat login later.

Acceptance:

- A user cannot publish or create public-facing content before required profile
  and consent fields are complete.
- Role choice affects labels/recommendations only; it must not bypass
  permissions.

### Reference Phase D: Map Home And Building Districts

Classification: feature.

Goal: migrate community-center and home-page functions into the tile map.

Tasks:

- Represent product market, demand hall, event calendar, city guide, and OPC
  hub as buildings or districts.
- Add building/district detail drawers with stats, summary, actions, and active
  agents.
- Show town stats such as building count, demand count, member count, and recent
  activity without covering the map.
- Keep map markers and hit targets data-driven.

Acceptance:

- Every major feature page has a visible place on the map.
- Tapping a feature building opens the correct drawer or route.
- New buildings can be placed without changing durable building identity.

### Reference Phase E: Discover And Search

Classification: feature.

Goal: mature the "find existing things" workflow.

Tasks:

- Add unified search across buildings, users, agents, books, events, demands,
  products, and posts.
- Add filters for visibility, category, capability, owner, freshness, and
  publish state.
- Use virtualized/windowed list rendering for large results.
- Provide "place on my map" for allowed published buildings.

Acceptance:

- Private content is not leaked through search.
- Published buildings can be discovered and placed by other users.
- Search results remain responsive with large fixture data.

### Reference Phase F: Messages And Agent Notifications

Classification: feature.

Goal: make communication mature while keeping agent chat first-class.

Tasks:

- Add message categories: new follows/shares, interactions, system notices,
  agent runs, review requests, publish decisions, and failed actions.
- Let each notification deep-link to a building, thread, run, review, or profile.
- Model WeChat subscription prompts through a platform adapter, not core
  product code.
- Keep long message streams append-friendly and windowed.

Acceptance:

- Agent events appear in the same notification model as human interactions.
- Review-needed and run-complete events are visible from Messages.
- WeChat subscription capability is isolated behind platform reporting.

### Reference Phase G: Profile And Ownership Center

Classification: feature.

Goal: give users a clear place for identity, private work, published work, and
owned objects.

Tasks:

- Add profile summary, stats, edit-profile entry, and content tabs.
- Tabs should cover buildings, books, agents, drafts, published items, activity,
  and optionally products/demands/events when those modules are enabled.
- Show private, shared, submitted, published, and archived states clearly.
- Keep account operations separate from public discovery.

Acceptance:

- User can find their private drafts and published buildings.
- User can understand what is private, shared, submitted, published, or
  archived.
- Profile page does not expose private book content to other users.

### Reference Phase H: Style And Performance Hardening

Classification: hardening.

Goal: keep the mature app feeling like Moontown and fast enough for a mini-app.

Tasks:

- Audit every migrated page against the tile-gamified visual system.
- Replace generic community cards with tile/building/signpost components where
  appropriate.
- Compress and budget onboarding/profile/search assets.
- Measure first-screen data, setData deltas, component count, repeated-list
  pressure, and scene pressure.
- Validate on WeChat DevTools with map pan/zoom, drawer interactions, and large
  search/message fixtures.

Acceptance:

- Realm/map remains crisp and full-screen.
- No migrated page introduces heavy hero art, blurred map assets, or slow
  whole-page rerenders.
- Bunnia diagnostics stay inside the agreed mini-app budgets.

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

## Current Mini-App Target

Realm is not a separate product module. Realm is the current Moontown map:
full-screen, tile-styled, draggable/pinchable, bounded to meaningful terrain,
and used as the spatial entry point for buildings and agents.

The maturity work is everything around that map:

- first-run guidance that explains why the town exists
- login, profile, role, and consent setup
- home/town pulse panels that summarize activity without replacing the map
- discovery and search for public buildings, users, agents, books, and events
- messages for human interactions, agent runs, reviews, shares, and publishes
- ownership pages for private drafts, shared work, published work, and archives
- building detail drawers that connect visible places to books, agents, and
  workflow state

Do not build:

- a second "Realm" graph unrelated to the Moontown map
- a generic social feed app with the map as decoration
- card-heavy marketing pages or blurred hero surfaces
- product semantics inside Bunnia framework core

The target experience should feel like a mature tile game UI:

- buildings are launchers
- districts are feature groups
- signposts and plaques are summaries
- drawers are detail and action surfaces
- badges show agent/run/review state
- tabs are shortcuts back into the same spatial model

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
- Bunnia's WeChat backend adapter now captures login response sessions into a
  configured `bunniaSessionId`, sends `x-miniapp-session` on later requests,
  writes endpoint `response_key` data back to page state, and keeps the tight
  backend JS budget green.

## Phase 6: Agent And Chat Runtime

Status: active for the current task.

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

Current evidence:

- Moontown `src/miniapp_agents` owns pure agent creation, building attachment,
  chat-send, cancel, retry, and review-accept transitions over
  `MiniappTownSnapshot`.
- `MiniappTownSnapshot` now carries message and audit-event collections, so
  threads, runs, and review actions can be projected and audited without
  treating agent output as durable truth.
- Agent runtime tests cover user-scoped agent creation, building attachment,
  hidden-building rejection, reviewable chat runs, cancel/retry/accept status
  transitions, and projection of messages/audit events.

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

Status: active for the current task.

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
moon run src/cmd/main -- miniapp buildings archive ...
moon run src/cmd/main -- miniapp chat send ...
```

Acceptance:

- Local backend starts on this Mac.
- DevTools can call it.
- Two users have isolated private data.
- Public buildings are shared through search.
- Archived buildings are hidden from normal snapshot/search surfaces while
  preserved for audit/history.
- Bunnia generated UI can exercise the complete loop.

Current evidence:

- Moontown `src/miniapp_local_backend` owns a deterministic local backend state
  and route catalog for dev login, snapshot, search, create/place building,
  create agent, chat send, cancel, retry, and review accept operations.
- The local backend remains pure and storage-free, so a tiny HTTP wrapper can
  later call the same APIs without changing product policy.
- `moon run src/cmd/main -- miniapp ...` exposes one-shot local commands for
  routes, login-backed snapshot/search, building create/place, agent create,
  chat send, and run/review actions.
- Moontown `scripts/miniapp-local-backend.mjs` starts a localhost HTTP wrapper
  around the same route set for WeChat DevTools, with a built-in `--smoke`
  check and `backendBaseUrl=http://127.0.0.1:18191`.
- The local HTTP wrapper persists users, buildings, placements, agents,
  threads, messages, runs, and audit events to
  `.moontown/miniapp-local-backend-state.json` by default, keeps sessions
  ephemeral, supports `--state` and `--reset-state`, and smoke-tests persistence
  through a temporary state file.
- The local backend route catalog and HTTP wrapper include
  `POST /miniapp/buildings/publish`, so a user can create a private draft,
  publish it to town, and another user can discover it through building search.
- The local backend route catalog and HTTP wrapper also include
  `POST /miniapp/buildings/share`, so a user can share a private draft into the
  team workspace and the target user can see it before public publication.
- The local backend route catalog and HTTP wrapper include
  `POST /miniapp/buildings/archive`, so a user can retire a private draft and
  remove it from visible map/search surfaces without losing audit history.
- Bunnia `examples/moontown_miniapp` now includes generated Login and Load
  controls plus seeded request payloads, including share, publish, and archive, so the
  generated project can call the local backend through dev login before
  snapshot/search/chat/create/share/publish/archive actions.
- Bunnia `examples/moontown_miniapp` also maps the reference community/home
  concepts into a compact Home `Community Hub`: product market, demand hall,
  event calendar, city guide, and OPC hub are tile districts attached to real
  map buildings, with user/agent/building presence chips filtered by the same
  visibility rules as the map.

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

Current evidence:

- Moontown `src/miniapp_deployment` owns pure production readiness checks for
  WeChat cloud or external HTTPS deployment targets, approved network domains,
  backend-only WeChat secrets, token/session rotation, encrypted database and
  object storage requirements, backups, rate limits, moderation, audit logs,
  monitoring, error reporting, and healthcheck configuration.
- Deployment tests cover a passing production config, blockers for missing app
  id, HTTP/unapproved domains, frontend secret exposure, disabled token/session
  controls, disabled database encryption/object storage/backups/audit logs/rate
  limits/moderation/monitoring/error reporting, frontend bundle secret audits,
  and permission-scope audits for phone-safe snapshots.
- The readiness layer remains policy-only: it does not introduce storage,
  network serving, deployment credentials, or local backend assumptions into the
  mini-app bundle or Bunnia framework.

This phase overlaps with production readiness and should follow the local
vertical slice evidence for product and rendering quality.

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
