# Moontown Mature Mini-App Migration Plan

This plan uses one hard boundary:

```text
Realm = the existing Moontown map
Migration = the mature mini-app functionality around that map
```

Realm is not a new page, graph, or spatial metaphor to rebuild. It is just the
current full-screen tile map: draggable, pinchable, bounded, projection-aware,
and visually Moontown. The remaining work is to make the app around that map
mature: entry, login, Home, Discover, Messages, My, building lifecycle, books,
agents, local backend, and production readiness.

The product should stay tile-gamified. Every new screen should feel like it
belongs to the same town: kiosks, signposts, plaques, ledgers, drawers, mail
boards, inventory shelves, stamps, and building panels. Do not copy reference
designs as generic mobile social pages.

This is therefore a rest-functionality migration plan. The map remains the
product's game board; the phases below add the mature app systems that make the
board useful without changing the board into another product.

## Current Product Decision

Realm is just our map.

The migration should no longer spend product energy inventing a new Realm page,
domain graph, or abstract visual system. The existing Moontown tile map is the
Realm: it is the place where buildings live, agents are visible, placements
matter, and users return after acting elsewhere in the app.

The missing work is the rest of the mini-app maturity:

- entry, registration, login, profile, role, and consent
- Home as a town pulse, not a marketing landing page
- Discover as public search, result actions, and place-on-map flow
- Messages as agent/human communication, runs, reviews, notices, and retries
- My as ownership, drafts, published work, archived work, and account readiness
- building lifecycle, book memory, agent creation, sharing, publishing, and
  review
- local backend and later production backend flows that make those interactions
  durable

Every one of these should keep the current tile-gamified style. The UI should
feel like a mature tile town: signposts, plaques, market boards, ledgers,
shelves, badges, stamps, drawers, and workbenches. Reference pages are useful
for understanding product jobs, but they should be translated into this visual
language instead of copied as generic social or SaaS pages.

## Phase-By-Phase Migration Snapshot

Use this as the concise migration order. R0 is the map guardrail. R1 through R8
are feature phases around the map. R9 and R10 are hardening phases.

| Phase | Type | Migration focus | Tile-gamified output |
| --- | --- | --- | --- |
| R0 Realm Map Guardrail | hardening | Keep the existing full-screen map crisp, bounded, draggable, pinchable, projection-aware, and marker-ready. | The current Moontown tile map remains the only Realm. |
| R1 Tile Mini-App Shell | feature | Provide `Home`, `Discover`, `Realm`, `Messages`, and `My` without creating another map. | Compact tabs, route plaques, and shared tile tokens. |
| R2 Entry, Login, And Profile | feature | Let users enter town with session, role, consent, profile, and permission state. | Town passport, setup stamps, and readiness plaques. |
| R3 Home Town Pulse | feature | Migrate home/community overview into town activity, stats, and district shortcuts. | Notice board, activity ledger, district doors, and stale/retry plaques. |
| R4 Discover And Placement | feature | Migrate public search, people/products/demands/events/posts, and placeable buildings. | Market board, filter plaques, placeable rows, watch/open/join/request/read stamps. |
| R5 Building Lifecycle And Books | feature | Make buildings durable places with owner, visibility, lifecycle, permissions, books, memory, and audit. | Anchored building drawer, lifecycle stamps, book shelf, safe memory ledger. |
| R6 Messages And Agent Communication | feature | Migrate chat, follows, interactions, agent runs, tool results, handoffs, and review requests. | Mail board, run plaques, review notices, agent badges, retry rows. |
| R7 My Ownership Workbench | feature | Migrate profile/owned-content pages into private work management. | Inventory shelf, draft/submitted/published/archive filters, ownership stamps. |
| R8 Local Backend Loop | feature | Make the above flows durable and testable on this Mac through WeChat DevTools. | Sync plaques, backend loop panels, two-user fixtures, local smoke coverage. |
| R9 Style And Performance Hardening | hardening | Keep the mature app fast and visually coherent as pages grow. | Tile-system audit, windowed lists, asset checks, `setData` and render budgets. |
| R10 Production Backend Readiness | hardening | Move from local proof to real WeChat users, storage, moderation, and operations. | WeChat login contract, HTTPS/cloud backend, moderation/recovery/ops workbench. |

The practical migration rule is:

1. protect the map first;
2. add identity and backend-owned permissions before deep workflows;
3. deepen buildings, books, agents, messages, Discover, and My around the same
   product model;
4. harden style and performance after every feature slice.

## Working Interpretation

For migration purposes, "Realm" means only the map layer we already have. It is
the spatial canvas, visual identity, and placement surface. It is not the main
remaining feature backlog.

The remaining backlog is app maturity around that map:

- identity: who entered town, what setup is complete, and what they can do
- orientation: what changed in town and where the next useful action lives
- discovery: which public buildings, books, agents, people, demands, products,
  events, and posts can be found or placed
- ownership: what the user owns, drafts, shares, submits, publishes, archives,
  or restores
- agent work: what agents are saying, doing, handing off, retrying, or asking a
  human to review
- durable memory: which books and accepted memories support each building
- backend reality: what state is synced, stale, failed, rate-limited, held,
  recoverable, or production-ready

Every one of those jobs should appear in the current tile-gamified language.
The migration should not introduce polished but foreign mobile pages. It should
make the existing town feel more complete: signposts for entry, plaques for
status, ledgers for activity, market boards for search, shelves for books,
mail boards for communication, stamps for lifecycle, and workbenches for owned
objects.

## Scope Decision

The map already carries the Realm concept.

Map work is now guardrail work only:

- keep the real Moontown tile raster crisp
- keep projected edges filled with meaningful terrain
- keep drag and pinch constrained to real map content
- keep building markers tappable
- keep map data/render budgets green
- keep the first viewport unmistakably Moontown

Feature work should happen around the map:

- first-run entry, registration, login, profile, role, and consent
- Home as the town pulse
- Discover as public search and placement
- building drawers, lifecycle, ownership, review, and publishing
- books as durable memory behind buildings
- agents as workers attached to buildings, books, runs, and threads
- Messages as human/agent communication, run status, reviews, and notices
- My as ownership, drafts, published work, archives, and account readiness
- local backend loop for WeChat DevTools on this Mac
- production backend readiness after local flows are coherent

If a proposed feature requires a second Realm page, a second map, or an
unrelated graph, it is out of scope. Attach the feature to the current map, a
building, a district, a drawer, a message row, a workbench, or a backend status
plaque.

## Rest-Functionality Focus

The main migration target is now the mature product around Realm, not Realm
itself. Treat the existing map as a stable game board and migrate the remaining
reference/product functions into small, useful systems around it.

In other words, Realm is the board. The rest of the mini-app is the product:
who the user is, what buildings they own, what can be searched, what agents are
doing, what needs review, what can be published, and what should be recovered
when local or production backend state is stale.

From this point forward, a migration phase should not ask "how do we rebuild
Realm?" It should ask:

- what mature app function is missing around the existing map?
- what durable product object owns that function?
- what tile-town surface should display it?
- what backend state, empty state, stale state, and retry state does it need?
- how does the user return from that function to the same map?

Do migrate:

- entry, registration, login, consent, and profile readiness
- Home as a town pulse, not a landing page
- Discover as public search, filters, and placement
- Messages as agent/human communication, reviews, and system notices
- My as ownership, drafts, submissions, published work, archives, and profile
  state
- building drawers, lifecycle actions, book shelves, and permissions
- local backend contracts for realistic WeChat DevTools testing

Do not migrate:

- a separate Realm graph
- a second map mode
- generic social-feed pages disconnected from the town
- large decorative marketing screens
- chat surfaces that hide building/book/run context

Every migrated function needs a tile-town home:

| Product function | Tile-town home |
| --- | --- |
| Onboarding | gate, signpost, setup stamps |
| Login/profile | town passport, profile plaque, readiness checklist |
| Home updates | notice board, activity ledger, district shortcuts |
| Search | market board, filter plaques, placeable result rows |
| Building details | anchored drawer, lifecycle stamps, book shelf |
| Book memory | ledger shelf, safe summary, review badge |
| Agent chat | mail board, run plaque, building thread |
| Agent work | worker badge, run status, review notice |
| Ownership | inventory workbench, draft/published/archive tabs |
| Backend state | sync plaque, stale badge, retry row |

## Maturity Definition

The app is mature when the map is no longer a demo scene but the stable board
for a complete user workflow.

That means a user can:

- enter with a known account, profile, role, consent, and session state
- understand what changed in town from Home without losing the map context
- search public buildings, agents, books, products, demands, events, users, and
  posts from Discover
- open a building from the map, read its safe book summary, talk to its agents,
  and understand its lifecycle state
- create private work, share it, submit it, publish it, archive it, restore it,
  or place public work onto their own map layer
- follow agent messages, handoffs, tool results, review requests, failures, and
  notifications from Messages
- manage owned buildings, books, agents, placements, drafts, submissions,
  published work, archives, and account readiness from My
- recover from stale backend/cache/mutation state through visible retry rows
  instead of silent failures

Anything that does not help one of those jobs should wait. The mini-app should
grow by deepening these workflows, not by adding more map modes or disconnected
pages.

## Style Contract

Every phase must preserve the current tile-gamified visual language.

- Keep Realm as the strongest brand signal.
- Prefer town objects over generic UI: building, district, signpost, badge,
  stamp, ledger, kiosk, drawer, shelf, workbench, and mail board.
- Use crisp raster/tile assets and stable 2.5D positioning.
- Keep panels compact and layered around the town language.
- Use readable state colors for private, shared, submitted, published,
  archived, running, review, failed, stale, synced, and unread states.
- Keep lists small, keyed, and windowed.
- Avoid blurred hero art, marketing sections, decorative gradients, and
  generic social-feed layouts.
- Show agent state in map badges, building drawers, message rows, run plaques,
  and review notices.

Style alignment rules for migrated pages:

1. A page copied from reference design becomes a town function, not a visual
   clone.
2. A generic card becomes a plaque, ledger row, workbench item, district gate,
   market row, shelf item, mail row, run plaque, or building drawer section.
3. A generic action button becomes a stamp, route sign, place action, retry row,
   publish badge, review decision, or workbench command.
4. A generic list becomes a windowed town board with stable item keys and clear
   lifecycle badges.
5. A chat view stays attached to a building, agent, book, run, or review, so it
   does not become detached social UI.
6. A search result should explain whether it can be opened, placed, followed,
   requested, reviewed, or only previewed.

The result should feel like a mature tile game interface, not a normal mobile
SaaS shell with map wallpaper.

## Functional Migration Map

Translate reference functionality by job, not by page shape.

| Reference function | Moontown destination | Tile-gamified treatment |
| --- | --- | --- |
| Welcome / first entry | Entry and setup | Signpost intro, enter-town gate, setup stamps. |
| Register / login / consent | Entry, My | Town passport, profile plaque, readiness checklist. |
| Community home | Home | Town notice board, recent activity ledger, stats plaques. |
| Feature zones | Home, Discover, map districts | District doors, building shortcuts, compact kiosks. |
| Public square / search | Discover | Market board for buildings, agents, books, users, events, demands. |
| Realm graph | Realm map guardrail | Use the existing full-screen Moontown map only. |
| Chat / follows / interactions | Messages | Town mail, run plaques, review notices, subscription prompts. |
| Profile / owned content | My | Inventory ledger, ownership stamps, draft/published/archive tabs. |
| Backend/account state | Backend phases | Sync plaques, retry rows, cache state, production safety gates. |

## Migration Tracks

The reference screenshots should be split into maturity tracks around the map.
Do not migrate them as a one-to-one page clone.

| Track | Migrates from reference | Moontown surface | Product state | Tile style rule |
| --- | --- | --- | --- | --- |
| Entry | welcome, first-run intro | setup gate before Realm | session, consent, profile readiness | signposts, stamps, town passport |
| Home | community home, feature zones | `Home` tab plus district shortcuts | town pulse, stats, recent activity | notice board, ledger, district doors |
| Discover | public square, search, marketplace | `Discover` tab and place-on-map actions | public buildings, agents, books, users, posts | market board, filter plaques, placeable rows |
| Realm | reference realm/graph | existing full-screen Moontown map | map layer, placements, selected building | no new graph; only map guardrails |
| Messages | chat, follows, interactions | `Messages` tab and building threads | messages, runs, reviews, notifications | mail board, run plaque, review notice |
| My | profile, owned content | `My` tab and ownership workbench | drafts, published work, archives, profile | inventory shelf, lifecycle stamps |
| Backend | account state and real data | local backend, then production backend | users, permissions, books, audit, search | sync plaque, stale badge, retry row |

This gives every migrated function a durable home while keeping Realm as the map
instead of expanding it into a catch-all screen.

## Rest-Functionality Migration Matrix

The migration backlog should be tracked by product function, not by screenshot
page. This keeps the app concise and prevents the map from becoming a dumping
ground.

| Function | Start surface | Main data | Tile-gamified UI | Return path |
| --- | --- | --- | --- | --- |
| Entry and setup | signpost gate, My | session, profile, consent, role | town passport, setup stamps | enter Realm |
| Home pulse | Home | activity, stats, notices, stale state | notice board, ledger, district doors | open linked building/message/search |
| Public discovery | Discover | public buildings, users, agents, books, events, demands, posts | market board, filter plaques, placeable rows | place/open on Realm |
| Building detail | map marker, Home, Discover, My | building, lifecycle, placement, permissions | anchored drawer, lifecycle stamps | close drawer to map |
| Books and memory | building drawer, My | primary book, shelves, summaries, reviews | ledger shelf, review badge | return to building |
| Agent communication | Messages, building drawer | threads, messages, runs, tool results | mail board, run plaques, tool-result cards | return to building/run |
| Publication review | Messages, My | submission, review, audit, moderation | review notice, accept/reject stamps | publish to Discover/Realm |
| Ownership | My | owned buildings, books, agents, placements, archives | inventory shelf, workbench filters | open relevant object |
| Backend recovery | Home, My, Messages | cache, mutation queue, sync result | sync plaque, stale badge, retry row | route to source surface |
| Production readiness | hidden/admin/backend | login, storage, audit, moderation, monitoring | reviewer/workbench tools where needed | keep user app stable |

Highest leverage order:

1. Identity and backend state first, because every other mature feature depends
   on knowing who can see or change an object.
2. Building lifecycle and ownership next, because buildings are the durable
   places on the map.
3. Books, agents, messages, and review together, because agent work only becomes
   useful when it can be discussed, accepted, retried, and stored.
4. Public discovery and placement should stay connected to the same building
   model, not become separate content feeds.
5. Production hardening starts only after the local loop proves these flows in
   WeChat DevTools.

## Phase Summary

Feature phases: R1 through R8. R1 creates the mini-app shell; R2 through R8 are
the rest-functionality maturity phases around the existing map.

Hardening phases: R0, R9, and R10.

R0 is continuous. It blocks any slice that regresses the map: blur, empty-space
leaks, broken edge constraints, broken pinch/drag, wrong projection, bad
markers, or render pressure.

| Phase | Type | Goal |
| --- | --- | --- |
| R0 Realm Map Guardrail | hardening | Preserve the existing full-screen map as Realm. |
| R1 Tile Mini-App Shell | feature | Make the app navigable without creating another Realm. |
| R2 Entry, Login, And Profile | feature | Give every user/session a clear setup and permission state. |
| R3 Home Town Pulse | feature | Turn home/community concepts into town activity and district shortcuts. |
| R4 Discover And Placement | feature | Let users find public objects and place allowed buildings. |
| R5 Building Lifecycle And Books | feature | Make buildings durable, permissioned, book-backed places. |
| R6 Messages And Agent Communication | feature | Make agent and human interaction first-class. |
| R7 My Ownership Workbench | feature | Let users manage private, shared, published, and archived work. |
| R8 Local Backend Loop | feature | Exercise the mature product locally from WeChat DevTools. |
| R9 Style And Performance Hardening | hardening | Keep the mature app fast, bounded, and visually coherent. |
| R10 Production Backend Readiness | hardening | Prepare real WeChat users, storage, moderation, and operations. |

## Phase Ownership

Use this table to decide where new migration work belongs. If work does not fit
one row, clarify the product object before implementing it.

| Phase | Owns | Does not own |
| --- | --- | --- |
| R0 | map crispness, projected terrain, edge constraints, marker hit targets | new account, chat, search, or ownership features |
| R1 | routes, navigation, shared tile shell, cross-page visual tokens | heavy product data or backend behavior |
| R2 | user identity, setup, consent, session, role, permission gates | public discovery and long ownership lists |
| R3 | Home pulse, activity, stats, district shortcuts, stale summaries | detailed object management |
| R4 | public search, filters, reusable results, placement entry points | private drafts and account workbench |
| R5 | building drawer, lifecycle, permissions, books, memory, audits | global chat timeline or generic social feed |
| R6 | threads, messages, runs, tool results, handoff, review decisions, notices | becoming a second Realm or hiding building context |
| R7 | owned objects, drafts, submissions, published work, archives, profile readiness | public marketplace ranking |
| R8 | local backend persistence, two-user scenarios, DevTools loop, cache/retry states | production secrets or cloud operations |
| R9 | visual coherence, render budgets, list windowing, setData pressure, asset checks | net-new feature scope |
| R10 | production login, storage, moderation operations, audit retention, rate limits, monitoring | large UX redesigns before local flows are proven |

Implementation priority:

1. Protect Realm quality before every feature slice.
2. Build user identity and navigation before deeper object workflows.
3. Make buildings, books, agents, and messages durable before polishing optional
   community surfaces.
4. Keep each phase small enough to validate in WeChat DevTools, but do the
   largest architectural step in that phase first.
5. End every phase with a style check: the result must still look like the same
   tile-gamified town.

Current direction:

- Do not spend a feature phase on a new Realm.
- Keep R0 as a continuous map-quality gate.
- Spend feature slices on the app systems that make the map useful: identity,
  Home, Discover, buildings, books, agents, messages, My, and backend recovery.
- In each slice, migrate the largest product boundary first, then the compact
  tile UI needed to exercise it.

Rest-functionality phase intent:

| Phase | Maturity question |
| --- | --- |
| R1 | Can users move through the mini-app without leaving the tile-town system? |
| R2 | Does every action know who the user is and what they are allowed to do? |
| R3 | Does Home explain what changed in town without becoming a feed clone? |
| R4 | Can users find public objects and place allowed buildings on the map? |
| R5 | Are buildings durable places with lifecycle, books, and permissions? |
| R6 | Are agent and human interactions visible, retryable, and tied to context? |
| R7 | Can users manage all private, shared, submitted, published, and archived work? |
| R8 | Can the full loop run locally in WeChat DevTools with realistic state? |

Phase migration outputs:

| Phase | Migrates into Moontown | Main tile surface | Backend/data output |
| --- | --- | --- | --- |
| R0 | current Realm map only | full-screen tile map | projection-aware asset, markers, bounds, budgets |
| R1 | navigation and reference page shell | tabs, signposts, route plaques | route metadata and generated page contracts |
| R2 | entry/login/profile flows | town passport, setup stamps | session, profile, role, consent, permissions |
| R3 | home/community overview | notice board, district doors, activity ledger | activity, stats, stale/retry summaries |
| R4 | public square/search pages | market board, filters, placeable rows | search index, visibility, placement eligibility |
| R5 | building/detail/memory flows | building drawer, book shelf, lifecycle stamps | buildings, books, memories, shares, audit |
| R6 | chat/interaction/review flows | mail board, run plaques, review notices | threads, messages, runs, tool results, reviews |
| R7 | profile/owned-content pages | inventory shelf, ownership workbench | owned objects, drafts, published work, archives |
| R8 | local app/backend proof | sync plaques, retry rows, backend loop panels | local persistence, two-user state, smoke coverage |
| R9 | visual/render hardening | tile-system audit across all pages | render, list, `setData`, asset, and snapshot budgets |
| R10 | production backend readiness | admin/reviewer workbench where needed | WeChat login, storage, moderation, monitoring, recovery |

## Phase-By-Phase Migration Plan

Build the highest-leverage product surfaces first. Do not spend feature phases
recreating the map.

### R0: Realm Map Guardrail

Type: hardening.

Purpose: protect the current Moontown map as the only Realm.

Build:

- real Moontown raster in the generated mini-app
- meaningful terrain expansion at projected edges
- constrained drag and pinch against real map content
- reliable marker hit targets and building drawer anchors
- crisp map assets for common WeChat phone viewports

Done when:

- Realm opens directly to the real map
- dragging/pinching never exposes large empty space
- map edges, projection, and terrain stay correct
- Bunnia inspect stays green for map, scene, render, and asset pressure
- every later phase can deep-link into a building or map placement without
  changing the map concept

Current status: active guardrail.

### R1: Tile Mini-App Shell

Type: feature.

Purpose: make the app navigable while keeping Realm equal to the map.

Build:

- `Home`, `Discover`, `Realm`, `Messages`, and `My` routes
- Realm route pointing to the same full-screen map state
- compact tab controls and route metadata
- lightweight tile backdrops on non-Realm pages
- shared tile tokens for plaques, ledgers, stamps, and action rows so later
  phases do not drift into generic mobile cards

Done when:

- tapping Realm always returns to the same map
- non-Realm pages feel attached to the town
- navigation does not reduce map clarity or touch quality

Current status: implemented as generated tile-styled routes.

### R2: Entry, Login, And Profile

Type: feature.

Purpose: make user identity and setup explicit before public actions.

Build:

- short first-run onboarding using signposts and town scenes
- dev login for local testing
- WeChat login contract for production
- profile, nickname/avatar reference, role, consent, session, and workspace
- permission gates for create, publish, share, place, and review
- town passport state visible from My and checked by public actions

Done when:

- a new user can register/login and enter town with known setup state
- returning users reach Realm quickly
- blocked public actions explain the missing setup step
- frontend output contains no secrets

Current status: profile readiness, setup gates, consent, role, and blocked
lifecycle actions are represented in tile UI. The local backend now persists
dev login profiles, creates missing local users on login, saves profile edits,
and returns the saved profile through snapshot and ownership APIs. Local
sessions are now opaque records with issue/expiry/revocation state instead of
predictable user-id tokens, and revoked or expired sessions are rejected before
scoped data is returned. Snapshot and ownership responses now also carry
explicit viewer permissions for profile readiness, creation, submission,
publishing, placement, report, moderation, and review state, so mini-app
surfaces do not need to infer capability from raw role strings. The local
backend enforces profile readiness for building creation, sharing, submission,
publication, and placement. My now also exposes a compact Public Passport shelf
for the visitor-facing profile summary: profile readiness, published places,
watched town links, and review signals are visible as tile ledger rows without
copying the reference profile page into a detached social surface.

### R3: Home Town Pulse

Type: feature.

Purpose: make Home the overview of what changed around the town.

Build:

- recent building activity
- agent runs and review needs
- published/shared updates
- failed or stale action notices
- town stats for buildings, agents, runs, reviews, and placements
- district shortcuts for product market, demand hall, event calendar, city
  guide, and OPC/credential hub
- compact "what changed" rows that link back to Realm, Discover, Messages, or My

Done when:

- Home explains the current town state without becoming a generic feed
- every row deep-links to a building, agent, run, book, district, or message
- larger activity lists remain windowed and cheap to update

Current status: Home has tile-styled pulse panels, backend cache visibility,
district shortcuts, and recent activity rows. Districts now carry explicit tab
destinations for market, demand, event, guide, and credential surfaces, and
activity rows route review/run work back to Messages while book/publish/place
work routes to Discover. District cards now also carry Discover filter, query,
and tone metadata, so product, demand, event, city-guide, and credential tiles
can behave like the reference community-center cards without becoming separate
mini-app roots.

### R4: Discover And Placement

Type: feature.

Purpose: make published objects findable and reusable.

Build:

- unified search for buildings, users, agents, books, events, demands, products,
  and posts
- filters by type, owner, visibility, capability, freshness, and placeable
  state
- placement flow for allowed public buildings
- clear separation between building identity and map placement
- privacy guardrails so private/shared objects never leak into public search
- result rows that explain whether an object can be opened, followed, placed,
  requested, or only previewed

Done when:

- published buildings can appear on many users' map layers through placements
- private drafts and shared-private content stay hidden
- search stays responsive with large fixtures

Current status: the realm remains just the full-screen map. Discover carries
the surrounding maturity work with tile-style filters plus non-generic people,
circle, and market spotlights that match the current gamified visual language.
The local backend search now returns public buildings, users, agents, books,
circles, products, review demands, run events, and public posts while keeping
private and shared-private work out of public results. Placeable discovery rows
now carry the target layer, source, and map coordinates, and already pinned
buildings drop out of the placeable filter so placement remains a real map-layer
action rather than a generic button. Discover filters now include the market
object kinds used by the district cards: products, demands, events, and posts.
The backend search contract now mirrors those filters: kind-scoped queries,
placeable-only search, pinned-building exclusion, filter echo metadata, and
result counts are returned from `/miniapp/discover/search`. Search responses are
also windowed with limit, cursor, total, returned, `hasMore`, and `nextCursor`
metadata so large public result sets do not force the mini-app to render or
patch unbounded lists.
Public discovery targets can now also be
watched through the existing subscription route: the backend validates that
watched buildings, books, agents, users, and listings including circles are
public/visible, persists viewer-scoped watch state, and returns those watches
through My ownership stats and rows. Discover now exposes this as a compact
Watch stamp on public result rows, reusing the same backend route and carrying
each row's target reference instead of creating a separate social-follow page.
Non-building public results now also expose typed tile actions: products and
agents open, demands can be answered, events/circles can be joined, and
posts/books can be read. These actions keep target references in row datasets,
submit through one backend-backed Discover action contract, and persist
viewer-scoped audit state in the local backend without reshaping the compact
tile UI. Snapshot and ownership responses now also expose recent Discover
actions, so DevTools reloads and My ownership sync can inspect what public
objects the viewer opened, answered, joined, or read. Discover action responses
now include route and target context; answering a demand records a building
thread message, while joining an event creates a viewer-visible interaction
notice.

### R5: Building Lifecycle And Books

Type: feature.

Purpose: make each building a durable place backed by memory and permissions.

Build:

- building drawer with visibility, lifecycle, owner, placement, and capability
- primary book plus support book shelf
- safe book summaries, memory counts, review counts, and run state
- create, edit, share, submit, publish, place, archive, and restore actions
- audit events for lifecycle operations
- backend-only raw private book content
- drawer actions that stay spatial: opening a place, reading its shelf, stamping
  lifecycle state, and sending work to agents

Done when:

- users can tell whether a building is private, shared, submitted, published,
  or archived
- querying a building records a run against the right book
- accepted agent output can become book memory after review
- public surfaces expose summaries, not private ledgers

Current status: lifecycle pipeline and data-derived book shelf are implemented
in the Moontown mini-app slice. Draft building edit is now a first-class
building/book operation exposed as a compact tile lifecycle stamp: owners can
update the building profile and primary book safe summary before submission,
while submitted and published buildings stay locked behind review/publication
state. Archive and restore are both wired as explicit lifecycle operations, so
owned archived work can return to the private draft workbench. Submit is now a
separate publication-review state before publish, leaving room for moderation
and reviewer decisions before public discovery. Submitted buildings now create
publication review items, so accept moves the building and book into public
discovery while reject returns them to private drafts. Accepted book-memory
reviews now create durable safe memory records in the local backend instead of
only incrementing book counters.

### R6: Messages And Agent Communication

Type: feature.

Purpose: make agentic interaction first-class without turning Realm into chat.

Build:

- channels for unread, agent runs, reviews, shares, publishes, system notices,
  failed actions, and subscriptions
- typed links to buildings, books, agents, threads, runs, reviews, and profiles
- send, status, cancel, retry, acknowledge, and review decision flows
- pagination/windowing for long chats and notification streams
- agent-to-human, agent-to-agent, handoff, broadcast, review, and tool-result
  events
- map badges and building drawer summaries for important communication state, so
  Realm remains useful without becoming the chat UI

Done when:

- human and agent events share one communication model
- run-complete and review-needed notices are obvious
- failed backend/agent actions can be retried or inspected
- chat updates do not force whole-page rerenders

Current status: Messages has run plaques, review controls, notification sync,
ack/subscription actions, scoped backend metadata, and a building-thread send
flow so user messages can be persisted against the selected map building.
Building communication threads are now durable local backend objects exposed
through snapshot and ownership payloads, and message, run, tool-result, agent,
and handoff actions create or update those thread records instead of relying on
implicit `thread-*` ids. Notification acknowledgement and subscription requests
are now viewer-scoped backend state, so one user handling a notice does not
clear it for everyone else. The
review queue now covers both book-memory reviews and publication reviews, so
agent output and building publication share one decision surface. Creating an
agent now attaches it to a building thread with an audit event, so agents are
durable town workers rather than standalone form output. Agent handoff is now a
first-class communication path: one agent can pass work to another through a
building thread, producing a run, message, notification, and audit event. Tool
results are now visible as tile-styled cards in Messages, budgeted in the
Bunnia build profile, and tied to acknowledgements instead of disappearing into
raw run text. Run cancel/retry is now explicit and viewer-scoped: the backend no
longer falls back to the newest run, and a user can only mutate a run attached
to a building they can see. The local backend now also exposes a bounded
`/miniapp/messages/center` read contract for long-lived communication surfaces:
the endpoint normalizes notifications, reviews, runs, tool results, threads,
and messages into one tile mail stream with channel, status, building, thread,
text query, limit, and cursor filters. It returns filter echo, all-counts,
filtered counts, and page metadata, so Messages can grow around agent work
without pushing every visible thread and notice through one snapshot update. The
generated Messages tab now exposes that route as a compact Center Sync tile with
its own backend status, payload key, response key, and tap action, keeping the
mail-board UI aligned with the same bounded sync model as Discover and My.

### R7: My Ownership Workbench

Type: feature.

Purpose: let users manage everything they own.

Build:

- owned buildings, books, agents, drafts, shared items, submitted items,
  published items, archived items, and activity
- filters by object type and visibility
- profile readiness and account trust
- warnings for incomplete setup, blocked publication, failed runs, stale backend
  data, and risky lifecycle actions
- private workbench separate from public discovery
- ownership actions that return users to the relevant building, book, agent,
  review, or map placement

Done when:

- users can find every private draft and public object they own
- visibility and lifecycle state are obvious
- private book content is not exposed through profile surfaces
- ownership warnings are actionable from My

Current status: identity card, credential plaque, ownership filters, lifecycle
pipeline, and workbench alerts are implemented. Owned buildings, placements,
books, and agents now carry explicit action messages, so My can route drafts to
submission, published work to Discover, reviews and agent chat to Messages,
archived work to restore, and placed map items back to Realm. The seed
projection now also treats watches as first-class ownership objects: a watched
public building is counted in the profile plaque, filterable from My, and routed
back to Realm without becoming a detached social feed. The same watch model is
ready for public people, books, agents, and listings as the mini-app gets a
larger dynamic-result event payload. The Public Passport shelf gives My a
reference-profile migration target while staying tile-native: public summary
rows expose what visitors can understand about the identity, and all actions
return to setup, Discover, Realm, or Messages. The local ownership sync contract
now mirrors the UI workbench shape: `/miniapp/me/ownership` accepts kind,
visibility, status, text query, limit, and cursor inputs, returns filter echo,
filtered counts, all-counts, and page metadata, and only sends a bounded window
of ownership rows by default. This keeps My scalable for large accounts without
turning ownership filtering into fragile frontend-only state.

### R8: Local Backend Loop

Type: feature.

Purpose: test the mature product locally before production.

Build:

- local dev login, snapshot, search, create, place, share, publish, archive,
  restore, chat, agent, run, review, and ownership APIs
- local persistence for users, profiles, buildings, placements, books, agents,
  threads, messages, runs, reviews, and audit events
- WeChat DevTools target at `http://127.0.0.1:18191`
- tile UI for loading, stale, failed, retrying, synced, and degraded backend
  states
- seeded two-user scenarios for private drafts, shared-private work, public
  publishing, placed buildings, building chat, and agent handoff

Done when:

- two local users have isolated private data
- shared-private buildings appear only for invited users
- published buildings can be searched and placed by other users
- backend failures show stale/cache state instead of silently breaking the app
- WeChat DevTools can exercise the full product loop on this Mac

Current status: Home exposes a tile-style Backend Loop panel for dev login,
snapshot load, publish, building query, and cache state visibility. My also
exposes an Ownership Sync plaque backed by `/miniapp/me/ownership`, so owned
buildings, books, agents, placements, and workbench alerts can be exercised
locally through filtered, cursor-windowed sync results. Dev login and profile
save now update durable local user/profile state
instead of returning a throwaway profile object. Dev sessions are now opaque,
expiring, and revocable through `/miniapp/auth/logout`, so local two-user
testing exercises session failure instead of relying on predictable tokens.
Snapshot and ownership payloads now include explicit viewer permissions, keeping
account readiness, review eligibility, and moderator trust backend-owned.
Profile readiness is enforced for create, share, submit, publish, and place
actions. Snapshot and ownership payloads also include derived object
relationships for buildings, placements, books, and agents, so surfaces can
distinguish owner, shared, team, system, public, and visible objects without
copying backend visibility rules.
Draft building updates now persist through `/miniapp/buildings/update`, keeping
building profile text and primary book safe summary together under owner-only,
pre-publication rules.
Shared-private local buildings now use explicit share grants, so invited users
can see them while uninvited users and public search cannot. Message send is
also persisted locally through `/miniapp/messages/send`, and snapshots now
return durable visible threads plus messages attached to those threads. The
local backend also exposes `/miniapp/messages/center` for filtered,
cursor-windowed message, notice, review, run, tool-result, and thread sync, and
the generated mini-app now carries a `messageCenterQuery` payload plus a
`load-message-center` backend endpoint to exercise it from WeChat DevTools.
Discover search now exercises multi-kind public results instead of a building-only route. Local
building publication now goes through `/miniapp/buildings/submit` before
`/miniapp/buildings/publish`, so the backend loop has a review state instead of
direct draft-to-public publishing.
The local review endpoints now accept or reject publication reviews as well as
book-memory reviews, matching the mini-app queue. Accepted book-memory reviews
now persist safe memory records and expose them through snapshot and ownership
payloads according to visible book boundaries. Local agent creation now validates
building ownership, rejects duplicates, persists the agent, writes a thread
message, and returns it through snapshot and ownership APIs. Local agent
handoff now persists a building-thread message, reviewable run, notification,
audit event, and updated target-agent status, so WeChat DevTools can exercise
agent-to-agent work transfer on this Mac. Tool-result acknowledgement is also
local-backend backed, so tool artifacts can move from pending to acknowledged
state and survive DevTools reloads. Notification acknowledgement and WeChat
subscription requests are now persisted per viewer and returned through snapshot
and ownership payloads. The local backend also seeds durable market
listings for products, demands, events, and posts, so existing DevTools state can
exercise non-building discovery without resetting the local database. Backend
cache states now expose explicit recovery actions, so session, snapshot,
ownership, mutation, and review state can route users to login, reload, sync,
My, or Messages instead of sitting as passive stale badges. Public building
reports now have a compact Safety Desk action in the map drawer plus a local
`/miniapp/moderation/report` route, persisted moderation cases, notifications,
and audit events so DevTools can exercise the first report path before
production admin tools exist. The local backend also exposes hide and takedown
decisions for moderation cases, so reported public buildings can leave public
search while the case, notification, and audit trail remain inspectable. Those
decisions are now backend-gated by local moderator trust, so normal logged-in
users can report but cannot hide or takedown public buildings. Run cancel/retry
now requires an explicit visible run id, and local smoke coverage checks missing
and private cross-user run mutations. The local backend now also exposes a
`/miniapp/health` readiness route, backend-owned rate-limit buckets for
sensitive routes, and moderator-only audit/backup routes, so DevTools can
exercise health, abuse-control, and recovery behavior without adding frontend
weight.
Generated backend request dispatch now clones endpoint payload templates before
overlaying row dataset fields such as `targetRef`, so Discover watch actions and
retryable requests cannot mutate shared page data while building a request.

### R9: Style And Performance Hardening

Type: hardening.

Purpose: keep the app mini-app friendly as mature features accumulate.

Build:

- visual audit against the tile-gamified system
- replacement of generic cards with town ledgers, panels, badges, stamps,
  drawers, signposts, shelves, or workbenches
- first-screen, render, scene, backend, repeated-list, agent-delta, setData, and
  asset budget checks
- WeChat DevTools smoke for map pan/zoom, tabs, drawers, search, messages,
  ownership, and backend calls
- package-size and asset crispness checks

Done when:

- no major surface looks disconnected from the map
- no feature introduces slow whole-page rerenders
- inspect and tests stay green after every feature slice

Current status: continuous after each slice.
The WeChat adapter now keeps repeated-row keys inside the render plan for
unkeyed/duplicate diagnostics, but omits `data-bunnia-key` from production WXML.
That reclaims markup budget for Moontown's mature app surfaces without weakening
list identity checks. The Moontown runtime also no longer patches unused local
`lifecycle.lastAction`, `town.last*BuildingId`, or `moderation.last*` state for
backend-owned actions. Those events still submit to the local backend and keep
empty patches for event coverage, but WeChat patch pressure dropped from the
budget edge to 144/160 operations, leaving room for the next feature slice.
The Moontown example also now uses short internal layout classes for repeated
panel, title, and metadata wrappers while keeping product-facing `data-*`
contracts and event messages stable. This is a markup-budget hardening step:
future reference-backed surfaces can be added without immediately crossing the
WeChat WXML ceiling. Repeated backend-step rows now also drop redundant
endpoint, method, and path data attributes because the method/path are already
visible text and the Run button already carries the endpoint message. This keeps
the local backend panel inspectable while reclaiming WXML headroom for the next
feature slice.

### R10: Production Backend Readiness

Type: hardening.

Purpose: move from local proof to real WeChat users safely.

Build:

- real WeChat login through backend-only secrets
- approved HTTPS domain or WeChat cloud deployment
- production database and object storage
- session rotation, rate limits, abuse controls, moderation, audit retention,
  backups, health checks, monitoring, and error reporting
- admin/reviewer tools for publication, reports, hide, takedown, and appeal
  review

Done when:

- phone login works
- approved network domains are configured
- no frontend bundle leaks secrets or private raw books
- published town content has review, report, hide, takedown, and owner appeal
  paths

Current status: first local report, hide, takedown, and owner appeal paths are
implemented through the selected building Safety Desk, Messages Moderation Desk,
and `/miniapp/moderation/*` routes. Local hide/takedown decisions now require
backend-owned moderator trust before mutating building or book visibility, while
appeals require the affected building owner and keep visibility restricted until
review. The local backend now uses opaque sessions with expiry and logout
revocation, and it has a backend-only `/miniapp/auth/wechat-login` contract that
requires server-side WeChat app configuration, binds users through a server-only
provider identity hash, and returns only opaque session/profile data. This gives
the production login path a safer contract to replace with the real WeChat code
exchange. It also exposes `/miniapp/health`, rate-limits sensitive local routes
such as dev login, WeChat login, public reports, and appeals, and provides
moderator-only audit/backup/recovery/ops/readiness endpoints, moderator
list/grant/revoke routes, retention prune route, a local startup/interval
retention scheduler, an external monitoring incident report route, moderator-only
incident review/resolve routes, and moderator-only abuse hold/release routes for
users and buildings. My now exposes these production-readiness hooks as a
compact Ops Desk plaque with separate Ops Check and Readiness actions, so
reviewers can exercise health, incidents, retention, recovery, deployment
readiness, and secret-safety checks from the tile workbench instead of a hidden
placeholder button.
The readiness route checks backend-only WeChat app credentials, approved HTTPS or
cloud deployment, production storage, monitoring sink, retention scheduler, and
reviewer identity configuration without returning secret values. Backend startup
can now apply `MINIAPP_ADMIN_REVIEWER_IDS` into trusted moderator identities and
ready reviewer profiles, while still leaving manual grant/revoke available for
local tests. Backups exclude live session and rate-limit buckets, and recovery
verification checks backup schema, table counts, forbidden ephemeral state, and
key relationships before any future restore mutation exists. Ops reports
identity binding counts, reviewer config source, recovery-drill status,
retention targets, scheduled-retention metadata, monitoring incidents,
monitoring checks, state counts, and status distributions. The mini-app example
now exposes those reviewer-only checks through a compact tile-style Operations
Desk in `My`, with a generated ops call that carries readiness and recovery
status instead of adding a separate admin app, another Realm page, or extra
frontend recovery mutation weight. Moderator
management keeps reviewer trust backend-owned, abuse holds can stop actor or
target mutations without frontend bundle growth, and manual or scheduled
pruning removes expired sessions, expired rate-limit buckets, and
out-of-retention audit events. That makes abuse-control, recovery, login
identity binding, reviewer identity, retention, monitoring, and
deployment-readiness behavior testable before production infrastructure exists.
Production still needs the real WeChat code-to-openid exchange,
platform-managed retention scheduling, a real external monitoring provider,
real managed storage, production-grade abuse signals, and a controlled restore
path after local flows are coherent.

## Migration Order

Use this order when choosing implementation slices:

1. Keep R0 green at all times.
2. Finish R1/R2 enough that navigation and identity are stable.
3. Build R3/R4 so users understand the town and can find public objects.
4. Deepen R5 because buildings and books are the product core.
5. Deepen R6 because agent communication is first-class.
6. Deepen R7 so private and published work is manageable.
7. Expand R8 after UI contracts are stable enough to test end to end.
8. Run R9 after every feature slice.
9. Start R10 only after local flows are coherent and measurable.

The highest-leverage next work is not another map experiment. It is completing
the mature product around the existing map: identity gates, Home pulse,
Discover, building lifecycle, books, messages, ownership, and the local backend
loop.

## Data Relationship

Use this product model:

```text
User
  owns sessions, profile, preferences, private work

Organization / Workspace
  groups users, team buildings, team books, and shared permissions

Town / Realm
  displays map layers and placements

Building
  canonical product object: owner, visibility, category, capability, lifecycle

BuildingPlacement
  map-specific location and pin state for a user/team/public layer

Book
  durable memory, safe summaries, ledgers, reviews, accepted knowledge

BookMemory
  accepted safe memory records linked to books, buildings, reviews, and runs

Agent
  worker/persona attached to user, building, book, thread, or run

Thread / Message
  communication around a building, agent, run, review, or system event

Run / Review
  auditable agent or tool execution with human approval where needed
```

Rule of thumb:

```text
users own intent and permissions
buildings are places
placements put places on maps
books are memory
agents are workers
threads are conversations
runs are auditable work
reviews decide what becomes durable
```

Backend snapshots should also expose the viewer relationship to visible objects:

```text
relationship = owner | shared | team | system | public | visible
```

This relationship is derived by the backend for buildings, placements, books,
and agents. Mini-app surfaces should consume it as product state instead of
re-implementing owner/share/visibility rules in WXML or page logic.

## Phase Checklist

Before starting any phase, answer:

- What real user job does this add around the existing map?
- Which tile-town form fits best: building, district, drawer, plaque, signpost,
  ledger, shelf, mail board, workbench, or badge?
- What data must be backend-owned rather than bundled in the mini-app?
- What list, scene, backend, agent, repeated-list, and `setData` budgets can
  this phase pressure?
- What stale/error/retry state does the user see when the backend or agent run
  fails?
- Which route, building, message, or drawer receives the deep link after the
  action completes?

## Validation Loop

Each phase should end with:

- MoonBit tests for touched model/view helpers
- Bunnia inspect for first-screen, render, scene, agent, repeated-list, backend,
  snapshot-delta, and asset budgets
- local backend smoke when API behavior changes
- WeChat DevTools smoke when UI or event behavior changes
- a visual check that the affected surface still reads as the same tile town

Do not accept a phase that only works as a small demo. The app is expected to be
large, so every feature must preserve bounded rendering, clear state updates,
and the current tile-gamified style.
