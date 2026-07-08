# Moontown Mature Mini-App Migration Plan

This plan uses one hard boundary:

```text
Realm = the existing Moontown map
Migration = the mature mini-app functionality around that map
```

Realm is not a new page, graph, or spatial metaphor to rebuild. It is the
current full-screen tile map: draggable, pinchable, bounded, projection-aware,
and visually Moontown. The remaining work is to make the app around it mature:
entry, login, Home, Discover, Messages, My, building lifecycle, books, agents,
local backend, and production readiness.

The product should stay tile-gamified. Every new screen should feel like it
belongs to the same town: kiosks, signposts, plaques, ledgers, drawers, mail
boards, inventory shelves, stamps, and building panels. Do not copy reference
designs as generic mobile social pages.

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
and returns the saved profile through snapshot and ownership APIs. Snapshot and
ownership responses now also carry explicit viewer permissions for profile
readiness, creation, submission, publishing, placement, report, moderation, and
review state, so mini-app surfaces do not need to infer capability from raw role
strings. The local backend enforces profile readiness for building creation,
sharing, submission, publication, and placement.

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
work routes to Discover.

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

Current status: Discover has tile-style filters plus non-generic people,
circle, and market spotlights. The local backend search now returns public
buildings, users, agents, books, products, review demands, run events, and
public posts while keeping private and shared-private work out of public
results. This keeps the realm as the map and moves the remaining maturity work
into the market-board/search surface. Placeable discovery rows now carry the
target layer, source, and map coordinates, and already pinned buildings drop out
of the placeable filter so placement remains a real map-layer action rather
than a generic button.

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
to a building they can see.

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
archived work to restore, and placed map items back to Realm.

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
locally. Dev login and profile save now update durable local user/profile state
instead of returning a throwaway profile object. Snapshot and ownership payloads
now include explicit viewer permissions, keeping account readiness, review
eligibility, and moderator trust backend-owned. Profile readiness is enforced
for create, share, submit, publish, and place actions. Snapshot and ownership
payloads also include derived object relationships for buildings, placements,
books, and agents, so surfaces can distinguish owner, shared, team, system,
public, and visible objects without copying backend visibility rules.
Draft building updates now persist through `/miniapp/buildings/update`, keeping
building profile text and primary book safe summary together under owner-only,
pre-publication rules.
Shared-private local buildings now use explicit share grants, so invited users
can see them while uninvited users and public search cannot. Message send is
also persisted locally through `/miniapp/messages/send`, and snapshots now
return durable visible threads plus messages attached to those threads. Discover
search now exercises multi-kind public results instead of a building-only route. Local
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
and private cross-user run mutations.

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

### R10: Production Backend Readiness

Type: hardening.

Purpose: move from local proof to real WeChat users safely.

Build:

- real WeChat login through backend-only secrets
- approved HTTPS domain or WeChat cloud deployment
- production database and object storage
- session rotation, rate limits, abuse controls, moderation, audit retention,
  backups, health checks, monitoring, and error reporting
- admin/reviewer tools for publication, reports, hide, and takedown

Done when:

- phone login works
- approved network domains are configured
- no frontend bundle leaks secrets or private raw books
- published town content has review, report, hide, and takedown paths

Current status: first local report, hide, and takedown paths are implemented
through the selected building Safety Desk, Messages Moderation Desk, and
`/miniapp/moderation/*` routes. Local hide/takedown decisions now require
backend-owned moderator trust before mutating building or book visibility.
Production still needs real reviewer/admin identity, appeals, retention, rate
limits, and abuse controls after local flows are coherent.

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
