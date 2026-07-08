# Moontown Mini-App Port Plan

This document plans the Moontown-to-WeChat mini-app product slice that should
dogfood Bunnia without mixing Moontown product semantics into the framework.

For the clean Realm-centered migration order, see
[`MOONTOWN_REALM_MIGRATION_PLAN.md`](MOONTOWN_REALM_MIGRATION_PLAN.md). That
plan treats Realm as the existing Moontown map and focuses the remaining phases
on mini-app maturity around the map.

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

## Rest-Of-App Maturity Focus

Realm is not a separate migration stream. Realm is the current map. The
remaining work should be planned as product maturity around that map:

```text
current map stays as Realm
  + entry/login/profile gates
  + Home town pulse
  + Discover/search/placement
  + Messages and agent communication
  + My ownership workbench
  + building lifecycle and books
  + local backend loop
  + style/performance hardening
```

The app should not grow by adding a second graph, a second map, or unrelated
page stacks. It should grow by making the existing tile town more useful. New
functionality should either attach to a building/district on the map, appear as
a compact panel/drawer around the map, or live in a bottom-tab page that still
uses the same tile-town language.

Highest-leverage migration rule:

1. Keep the map stable and crisp.
2. Add only the surrounding functionality that makes the map a mature product.
3. Translate reference pages into tile-style interactions instead of copying
   their generic layouts.
4. Validate every phase against mini-app constraints: small initial data,
   bounded lists, stable tap targets, and limited `setData` churn.

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

Style alignment contract:

- Every migrated function should look like it belongs to the same tile town.
- Main actions should be represented as buildings, district doors, signposts,
  stamps, badges, or compact panels before generic app cards.
- Lists should feel like town ledgers, notice boards, inventories, or message
  plaques, with small stable rows and clear state colors.
- The app should not introduce a second visual language for profile, messages,
  or discovery; those screens are UI layers over the same town world.
- The map stays full-screen and spatial. Surrounding pages mature the product,
  but they should still read as part of the map's gamified town interface.

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

The migration should advance from the biggest user-facing gaps first. Realm is
already the map, so it is not a feature phase unless map clarity, asset quality,
edge constraints, dragging, or pinch zoom regress. Product maturity comes from
the rest of the app: onboarding, identity, Home, Discover, Messages, My,
building lifecycle, books, and backend wiring.

| Order | Maturity phase | Type | Current status | Purpose | Primary output |
| --- | --- | --- | --- | --- | --- |
| M0 | Realm Map Baseline | hardening | keep green | Preserve the existing full-screen tile map as the Realm; do not build a second map. | Crisp map asset, bounded drag/pinch, edge-safe viewport, building hit targets. |
| M1 | Tile App Shell | feature | done in slice | Make the mini-app navigable without replacing the map. | `Home`, `Discover`, `Realm`, `Messages`, `My` tabs with Realm returning to the same map. |
| M2 | Onboarding And Identity | feature | started | Let first-time users enter the town, choose profile/role, and satisfy consent gates. | First-run guide, login/profile setup, profile readiness checks. |
| M3 | Home Town Pulse | feature | started | Turn reference home/community pages into tile-town activity around the map. | Activity stream, recent runs, building shortcuts, town stats, district entries. |
| M4 | Discover And Placement | feature | started | Make published town content searchable and reusable. | Unified search, filters, public building results, "place on my map" flow. |
| M5 | Messages And Agent Communication | feature | current | Treat agent events and human interactions as first-class communication. | Notification channels, agent run updates, review requests, share/publish events, deep links. |
| M6 | My Ownership Center | feature | started | Give users control over private work and published work. | Owned buildings/books/agents, drafts, submitted items, published items, archive state. |
| M7 | Building Lifecycle And Books | feature | started | Connect visible buildings to durable Moontown memory and workflow state. | Create/share/publish/archive, book binding, permissions, audit trail. |
| M8 | Local Backend Loop | feature | started | Make the same flows usable from WeChat DevTools against this Mac. | Dev login, snapshot/search/create/share/publish/archive/chat/review endpoints. |
| M9 | Tile Style And Performance Pass | hardening | continuous | Keep the mature app fast and visually coherent. | Visual audit, list windowing, asset budgets, setData/delta checks, DevTools validation. |
| M10 | Production Backend Readiness | hardening | later | Move from local proof to real users. | WeChat login, HTTPS/cloud backend, storage, rate limits, monitoring, backups. |

Near-term build order:

1. Keep M0 stable while changing other screens.
2. Finish M2 enough that every public action has a real user/session/profile
   boundary.
3. Mature M3 and M4 so users can understand what changed in town and find or
   place public objects.
4. Finish M5's actionable run/review loop because agentic communication is a
   core product behavior, but keep it in tile-styled Messages and run plaques
   rather than turning Realm into a chat page.
5. Continue M6 and M7 together so owned inventory, building lifecycle, books,
   memory, review, publish, archive, and permission state stay consistent.
6. Keep M8 green in WeChat DevTools as each product flow becomes coherent.
7. Run M9 after each feature slice, not only at the end, because the app is
   map-heavy and can become slow quickly.

## Mature Mini-App Migration Plan

This plan assumes Realm is complete enough to be the map. Each following phase
adds product maturity around it while preserving the tile-gamified style.

### M0: Protect The Realm Map

Classification: hardening.

Purpose: keep the map stable while the rest of the app grows.

Tasks:

- Keep the current Moontown map as the only Realm surface.
- Preserve crisp raster assets, meaningful tile expansion, and edge-safe
  viewport constraints.
- Keep building markers and selected-building drawers data-driven.
- Treat any map blur, black space, broken drag, broken pinch, or wrong
  projection as a regression.

Output:

- A stable full-screen map route that other tabs can layer around.

### M1: Tile App Shell

Classification: feature.

Purpose: make the map feel like a complete mini-app without replacing it.

Tasks:

- Keep bottom tabs for `Home`, `Discover`, `Realm`, `Messages`, and `My`.
- Route `Realm` to the existing full-screen Moontown map.
- Keep search, publish, selected building, chat, and create actions close to the
  map.
- Keep navigation chrome small enough that map touch quality remains primary.

Tile style:

- Tabs and action buttons should feel like town shortcuts and tool controls, not
  a generic app frame.

Output:

- Users can move around the app while always understanding that Realm is the
  map.

### M2: Mature Entry And Identity

Classification: feature.

Purpose: make the app usable by real people instead of only demo users.

Tasks:

- Keep onboarding short and visual, using town/map scenes rather than generic
  welcome pages.
- Add register/login flow through dev login now and WeChat login later.
- Store profile, role, consent, active workspace, and session state.
- Gate public actions behind profile and consent readiness.

Tile style:

- Onboarding screens should feel like town signs or tutorial plaques.
- Role/profile setup should feel like a registration kiosk, not a marketing
  form.

Output:

- A user can enter the town, finish setup, and safely reach the map.

Current implementation:

- Realm and Home now render data-driven tile guide plaques derived from the
  current projection. The guide translates the reference onboarding/navigation
  screenshots into compact town steps: enter Realm, read Home, discover public
  places, review agent mail, and finish the user's passport.
- Each guide plaque carries tab id, route metadata, building context, action
  message, completion state, and status color, so first-run education can become
  backend-driven later without copying generic onboarding pages.
- The guide keeps Realm as the existing map. It sends users into the mature
  surrounding surfaces instead of introducing a second realm or graph.

### M3: Home As Town Pulse

Classification: feature.

Purpose: turn Home into the live town dashboard around the map.

Tasks:

- Show recent building activity, agent runs, review needs, published updates,
  and shared work.
- Keep product-market, demand-hall, event-calendar, guide, and OPC concepts as
  districts or building entrances.
- Add small stats for buildings, agents, runs, reviews, and public placements.
- Keep all lists scoped/windowed.

Tile style:

- Home entries should look like notice boards, district signs, inventory rows,
  and map plaques.
- Avoid feed-card layouts that could belong to any generic social app.

Output:

- A user can understand what changed in town without leaving the tile-world
  mental model.

### M4: Discover And Public Placement

Classification: feature.

Purpose: make published things findable and reusable.

Tasks:

- Search buildings, users, agents, books, events, demands, products, and posts.
- Filter by type, visibility, capability, owner, freshness, and placeable state.
- Let users place allowed published buildings onto their own map layer.
- Ensure private/shared content never leaks through public search.

Tile style:

- Search results should feel like a market board or catalog of places.
- "Place on map" should feel like pinning a building into the town, not copying
  unrelated content.

Output:

- Public buildings can spread across user maps while preserving one canonical
  building identity.

Current implementation:

- Placement is now a separate product record in the Moontown example. A
  published building can be pinned to a user's personal layer without copying or
  mutating the canonical building.
- Discover placement actions now carry building identity into the backend
  payload and expose placement state in the generated WXML, so a result can show
  whether it is already pinned.
- The generated local fixture includes a starter placement for Policy Hall,
  matching the pure MoonBit projection.

### M5: Messages And Agent Communication

Classification: feature.

Purpose: make humans, agents, runs, and reviews communicate through one model.

Tasks:

- Add channels for unread, agent runs, review requests, system notices, shares,
  publish decisions, and failed actions.
- Deep-link messages to buildings, agents, threads, runs, reviews, or profile
  surfaces.
- Keep long conversations paginated/windowed.
- Keep WeChat subscription prompts behind platform adapters.

Tile style:

- Messages should look like town mail, request boards, run plaques, and review
  seals.
- Agent activity should also appear as map badges and building drawer state, not
  only as chat bubbles.

Output:

- Agentic UI is first-class without making chat the entire app.

### M6: My Ownership Center

Classification: feature.

Purpose: give each user a clear inventory of their work.

Tasks:

- Add tabs/filters for buildings, books, agents, drafts, shared work,
  submitted items, published items, archived items, and activity.
- Show action state for create, edit, share, submit, publish, archive, and
  restore when available.
- Keep account operations separate from public discovery.
- Show ownership counts and warnings without exposing private book content.

Tile style:

- My should feel like an inventory/workbench, with stamps for private, shared,
  submitted, published, and archived states.

Output:

- A user can find and manage every private or public object they own.

Current implementation:

- My now includes a Placed ownership filter and placement stat. Placement rows
  use `placement:` target refs so the workbench can distinguish "my map pin"
  from "my building".

### M7: Building Lifecycle And Books

Classification: feature.

Purpose: connect every visible building to durable Moontown state.

Tasks:

- Bind each building to a primary book and safe book summary.
- Track request, review, accepted-memory, publication, and run ledgers.
- Make create/share/publish/archive visible from building drawers and My.
- Keep raw private book content server-side unless explicitly published.

Tile style:

- Building drawers should feel like opening a place in town: book shelf, agent
  desk, review stamp, and action controls.

Output:

- Buildings become durable places with memory, permissions, and lifecycle.

### M8: Local Backend Loop

Classification: feature.

Purpose: make the mature mini-app testable on this Mac through WeChat DevTools.

Tasks:

- Run dev login, snapshot, search, create, place, share, publish, archive, chat,
  agent, run, and review APIs locally.
- Persist local state for users, buildings, placements, agents, books, threads,
  messages, runs, and audit events.
- Keep sessions and secrets backend-only.
- Point generated Bunnia requests at `http://127.0.0.1` during local testing.

Tile style:

- Backend-driven state changes should immediately update the same map markers,
  plaques, badges, drawers, and inventories.

Output:

- The app can be exercised end-to-end locally before production deployment.

Current implementation:

- Bunnia now ships a standalone local backend runner at
  `examples/moontown_miniapp/backend/local_backend.mjs`.
- The runner serves the same endpoint paths used by `demo_backend_contract()` on
  `http://127.0.0.1:18191`: dev login, snapshot, discover search, profile save,
  building create/place/share/publish/archive, building query, run cancel/retry,
  review accept/reject, notification ack, subscription request, and agent
  creation.
- Runtime state is persisted under `_build/moontown_miniapp/` by default, so
  users, buildings, placements, books, agents, messages, runs, reviews, notices,
  and audit events survive local DevTools reloads without entering the git
  worktree.
- `--smoke` exercises the full local loop without leaving a server running, and
  `--reset-state` gives WeChat DevTools a clean local town.

### M9: Style And Performance Hardening

Classification: hardening.

Purpose: keep the mature app fast, clear, and visually aligned.

Tasks:

- Audit every migrated surface against the tile-gamified design language.
- Enforce first-screen data, render pressure, repeated-list, agent, scene, and
  backend budgets.
- Validate map pan/zoom and tab/panel interactions in WeChat DevTools.
- Replace any generic cards, blurred visuals, or oversized panels that weaken
  the town style.

Output:

- A mature mini-app that still feels like Moontown and stays within mini-app
  constraints.

### M10: Production Backend Readiness

Classification: hardening.

Purpose: make the local proof safe for real WeChat users.

Tasks:

- Replace dev login with real WeChat login on an approved backend.
- Move durable state to production storage with backups and monitoring.
- Keep app secrets, local filesystem access, daemon control, and privileged
  runtime calls out of the mini-app bundle.
- Add rate limits, abuse controls, audit retention, and operational alerts.

Tile style:

- Production data should continue to drive the same map markers, drawers,
  ledgers, notice boards, and ownership inventory.

Output:

- The same tile-gamified product can graduate from local DevTools testing to
  real users.

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
- Bunnia `examples/moontown_miniapp` projects setup readiness as tile-style
  gates for session, onboarding, role, consent, profile save, and publish
  readiness. The My/Identity Setup surface shows why public actions remain
  blocked and provides compact action messages that match the same lifecycle
  gates used by building publish/share controls.
- Building lifecycle buttons expose `data-allowed` and blocked-reason metadata,
  and blocked actions render as disabled WeChat buttons so profile/ownership
  gates are visible without allowing accidental backend dispatch.

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

1. Use the Bunnia Moontown example backend runner for local development.
2. Keep the route contract aligned with the generated mini-app backend actions.
3. Use dev login and local storage.
4. Point WeChat DevTools at the local backend.

Example local commands:

```text
node examples/moontown_miniapp/backend/local_backend.mjs --reset-state
node examples/moontown_miniapp/backend/local_backend.mjs --smoke
curl http://127.0.0.1:18191/miniapp/routes
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

- Bunnia `examples/moontown_miniapp/backend/local_backend.mjs` starts a
  localhost HTTP backend for WeChat DevTools, with a built-in `--smoke` check
  and `backendBaseUrl=http://127.0.0.1:18191`.
- The local backend owns a deterministic seed state and route catalog for dev
  login, snapshot, search, create/place/share/publish/archive building, create
  agent, chat send, cancel, retry, notification ack/subscription, and review
  accept/reject operations.
- The local HTTP wrapper persists users, buildings, placements, agents,
  threads, messages, runs, and audit events to
  `_build/moontown_miniapp/local_backend_state.json` by default, supports
  `--state` and `--reset-state`, and smoke-tests persistence through a temporary
  state file.
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
- The same example now gives Discover tile-style filters for all results,
  buildings, agents, books, and placeable buildings. Published building search
  results expose a "Place On Map" action while private and non-building results
  remain visible only through safe filtered discovery data.
- Discover also maps the reference people and circle pages into Moontown-style
  town spotlights and filters. People and circles are searchable discovery
  objects with stable target refs, not a separate social-feed surface.
- Messages now has tile-style channels for all, unread, agent-run, review, and
  system notifications. Notification projection uses the same visible-building
  boundary as the map, so private building notices do not leak across users.
- Messages also maps the reference follow, interaction, and subscription pages
  into compact tile buckets while preserving agent run/review notifications as
  first-class communication events.
- Notification actions now use stable ack/subscription endpoints with tapped
  notice ids, notice kinds, target refs, and building ids merged into payloads,
  so follow, interaction, review, run, and subscription prompts can be exercised
  from DevTools without creating one endpoint per notice.
- Messages now binds those notification actions back to tile-style sync plaques
  for ack and subscription state, so users can see local backend feedback near
  the communication flow instead of only in the Home Backend Loop panel.
- The WeChat adapter now emits backend endpoint metadata only for messages
  reachable from the rendered route. The full contract remains available for
  planning, but hidden tab endpoints no longer consume route JS budget.
- Messages now derives tile-style run actions from pure run state. Each run
  plaque can open its building, accept or reject reviewable output, and expose a
  retry affordance only when the run is failed, rejected, or cancelled.
- The Moontown mini-app backend contract now includes stable
  `cancel-run` and `retry-run` endpoints, and the Home Backend Loop
  exposes both as tile rows for WeChat DevTools. Messages buttons carry the run
  id as data while using those stable endpoint messages.
- The WeChat adapter forwards the tapped row dataset into agent run operations,
  merging `runId` into cancel/retry payloads while leaving ordinary backend
  buttons on their declared payload keys.
- Review controls now attach `reviewId`, `runId`, and `decision` to the tapped
  button, and the WeChat adapter merges those fields into review decision
  payloads before calling the backend.
- Building lifecycle buttons now attach `buildingId`, `bookId`, and target
  references to the tapped button, and the backend adapter can merge those
  scoped ids into place/share/publish/archive payloads.
- My now has tile-style ownership filters for all, drafts, published items,
  books, and agents. The filtered inventory keeps private buildings, books, and
  attached agents in one workbench while preserving the same owner-scoped
  projection boundary as the map.
- My also maps the reference profile page into a tile-styled identity card with
  display name, UID, avatar reference, readiness, social/activity stats, and
  edit/consent actions, plus an OPC credential plaque linked to the credential
  district/building.
- The selected building drawer now projects lifecycle actions from building,
  owner, profile, and book state. Ask, place, share, publish, and archive actions
  stay visibly tied to the selected building and its primary book, including
  blocked reasons such as owner-only or profile setup requirements.
- My Lifecycle now renders a tile-style publication pipeline for the active
  owned building: private draft, team share, publish review, town published, and
  archive. The pipeline reuses the same ownership, profile, visibility, and
  lifecycle rules as the action buttons, so publication state stays consistent
  across My, building drawers, and backend-bound actions.
- Moontown mini-app WXSS is now minified at generation time, and the default
  Realm first screen defers full onboarding/profile setup to Home/My. The
  map-heavy WeChat route keeps more budget headroom for the next backend loop
  slice without losing the first-visit entry point.
- The generated page now seeds `backendBaseUrl` to
  `http://127.0.0.1:18191`, and Home exposes a tile-style Backend Loop panel for
  dev login, snapshot loading, publishing, and agent query endpoints. This makes
  WeChat DevTools point at the local backend on this Mac without manual data
  editing.
- The generated project now exposes Realm, Home, Discover, Messages, and My as
  real WeChat routes under `pages/moontown/`, with Realm still first in
  `app.json`. Tab buttons carry Bunnia route metadata so navigation reaches the
  mature tile-styled product surfaces instead of relying on a single static
  route.
- Non-Realm routes render lightweight tile-map backdrops instead of the full
  interactive scene, and route runtimes are scoped to visible events. This keeps
  release readiness green while letting the app grow as a multi-page mini-app.
- Setup actions, discovery filters, message channels, and ownership filters now
  emit scoped runtime patches and visible state labels on their routes, so those
  tile controls are testable interaction contracts rather than no-op UI.
- The Backend Loop panel now also shows tile-style session, snapshot cache,
  mutation queue, and review-result states. The snapshot row explicitly marks
  stale-safe rendering, so backend failures do not silently disconnect the map
  from the last visible town state.
- The WeChat backend adapter mirrors every request state into
  `backendStatus.<safe_endpoint_id>` in addition to the replayable
  `backend.<endpoint_id>` store. Home binds Backend Loop rows to those safe
  keys and exposes compact Run controls, so DevTools request loading, ready,
  failed, timeout, malformed, and cancelled states can be shown in tile UI.

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
