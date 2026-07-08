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

Implementation priority:

1. Protect Realm quality before every feature slice.
2. Build user identity and navigation before deeper object workflows.
3. Make buildings, books, agents, and messages durable before polishing optional
   community surfaces.
4. Keep each phase small enough to validate in WeChat DevTools, but do the
   largest architectural step in that phase first.
5. End every phase with a style check: the result must still look like the same
   tile-gamified town.

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
and returns the saved profile through snapshot and ownership APIs.

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

Current status: started through tile-styled pulse panels and backend cache
visibility.

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

Current status: Discover has tile-style filters and non-generic people/circle
spotlights. The local backend search now returns public buildings, users,
agents, books, review demands, and run events while keeping private and
shared-private work out of public results.

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
in the Moontown mini-app slice. Archive and restore are both wired as explicit
lifecycle operations, so owned archived work can return to the private draft
workbench. Submit is now a separate publication-review state before publish,
leaving room for moderation and reviewer decisions before public discovery.
Submitted buildings now create publication review items, so accept moves the
building and book into public discovery while reject returns them to private
drafts.

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
flow so user messages can be persisted against the selected map building. The
review queue now covers both book-memory reviews and publication reviews, so
agent output and building publication share one decision surface. Creating an
agent now attaches it to a building thread with an audit event, so agents are
durable town workers rather than standalone form output. Agent handoff is now a
first-class communication path: one agent can pass work to another through a
building thread, producing a run, message, notification, and audit event. Tool
results are now visible as tile-styled cards in Messages, budgeted in the
Bunnia build profile, and tied to acknowledgements instead of disappearing into
raw run text.

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
pipeline, and workbench alerts are implemented.

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
instead of returning a throwaway profile object. Shared-private local buildings
now use explicit share grants, so invited users can see them while uninvited
users and public search cannot. Message send is also persisted locally through
`/miniapp/messages/send`, and snapshots only return messages attached to
buildings the viewer can see. Discover search now exercises multi-kind public
results instead of a building-only route. Local building publication now goes
through `/miniapp/buildings/submit` before `/miniapp/buildings/publish`, so the
backend loop has a review state instead of direct draft-to-public publishing.
The local review endpoints now accept or reject publication reviews as well as
book-memory reviews, matching the mini-app queue. Local agent creation now
validates building ownership, rejects duplicates, persists the agent, writes a
thread message, and returns it through snapshot and ownership APIs. Local agent
handoff now persists a building-thread message, reviewable run, notification,
audit event, and updated target-agent status, so WeChat DevTools can exercise
agent-to-agent work transfer on this Mac. Tool-result acknowledgement is also
local-backend backed, so tool artifacts can move from pending to acknowledged
state and survive DevTools reloads.

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

Current status: planned after the local backend loop is coherent.

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
