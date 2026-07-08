# Moontown Realm-Centered Migration Plan

This plan treats Realm as the existing Moontown map. We do not need to build a
second realm, graph, or spatial metaphor. The map is the product anchor; the
remaining work is the mini-app maturity around it.

```text
Realm = current Moontown full-screen tile map
Rest of app = onboarding, login, home pulse, search, messages, ownership,
              building lifecycle, books, agents, backend, and production safety
```

The goal is a mature WeChat mini-app that still feels like Moontown: tile-based,
map-first, agentic, fast, and readable on phones.

This is the key product boundary:

- Realm is not a new feature to migrate. Realm is the current Moontown map.
- Map work is only guardrail work: clarity, edge constraints, pinch/drag, asset
  generation, marker quality, and performance.
- Product maturity comes from the rest of the app: first-run setup, login,
  profile, Home, Discover, Messages, My, building lifecycle, books, agents,
  search, local backend, and production readiness.
- Every non-map surface should still look like it belongs to the same tile
  town, not like a generic social/community app placed beside the map.

## Product Direction

The user should understand the app as a town:

- buildings are the main product objects
- books are the durable memory behind buildings
- agents work inside or around buildings
- messages are town mail, run updates, review notices, and system notices
- Home is the town pulse around the map
- Discover is the public market/search board
- My is the user's inventory and workbench
- Realm is always the same map

Do not migrate reference pages literally. Translate each useful function into a
town-shaped surface: a district, building, drawer, notice board, workbench,
badge, or compact panel.

## Style Contract

Every migrated screen must align with the current tile-gamified style.

- Keep the map as the strongest first-viewport signal.
- Prefer buildings, districts, signposts, badges, stamps, plaques, ledgers, and
  drawers over generic app cards.
- Use crisp raster/tile assets and stable 2.5D positioning.
- Keep panels compact and layered around the map instead of hiding the town
  behind full-page social feeds.
- Use bright readable state colors for private, shared, published, archived,
  running, review, failed, and unread states.
- Keep list rows small, keyed, and windowed.
- Avoid blurred hero art, decorative gradients, large marketing sections, and
  social-app visual language.
- Agent status should appear in map badges, building drawers, message rows, and
  run plaques, not only in a chat page.

## Migration Boundary

The reference design should be translated by function, not copied page by page.
The existing map already covers the Realm concept. The remaining migration is a
set of mature product surfaces around the map.

| Reference function | Moontown destination | Tile-gamified treatment |
| --- | --- | --- |
| Welcome / first entry | R2 Entry and setup | Signpost intro, short guide, enter-town gate. |
| Login / identity / consent | R2 Entry and setup, R7 My | Town passport, profile plaque, readiness stamps. |
| Community home | R3 Home Town Pulse | Town notice board, stats plaques, recent activity ledger. |
| Feature zones | R3 Home, R4 Discover, map districts | District doors, building shortcuts, kiosks. |
| Public search / square | R4 Discover | Market board for buildings, people, agents, books, events. |
| Realm graph | R0 Realm Map Guardrail | Use the existing full-screen Moontown map only. |
| Messages / follows / interactions | R6 Messages | Town mail, run plaques, review notices, subscription prompts. |
| Profile / owned content | R7 My Ownership Workbench | Inventory ledger, ownership stamps, private/shared/published tabs. |
| Backend and account state | R8/R10 backend phases | Backend loop panel, sync badges, production safety gates. |

Do not introduce a second map, a second spatial metaphor, or a separate graph
page. If a feature needs spatial identity, attach it to an existing building,
district, marker, drawer, or placement on the current map.

## Phase Summary

| Phase | Name | Type | Goal |
| --- | --- | --- | --- |
| R0 | Realm Map Guardrail | hardening | Keep the current map crisp, bounded, draggable, pinchable, and projection-correct. |
| R1 | Tile Mini-App Shell | feature | Wrap the map with mature navigation without creating a second Realm. |
| R2 | Entry, Login, And Profile | feature | Let real users register/login, finish setup, and safely enter the town. |
| R3 | Home Town Pulse | feature | Convert home/community concepts into activity, stats, and district shortcuts around the map. |
| R4 | Discover And Placement | feature | Search public objects and place allowed buildings onto the user's map layer. |
| R5 | Building Lifecycle And Books | feature | Make each building a durable place with memory, permissions, review, and publishing state. |
| R6 | Messages And Agent Communication | feature | Make agent runs, human events, reviews, shares, and system notices first-class. |
| R7 | My Ownership Workbench | feature | Give users one tile-styled place to manage private, shared, published, and archived work. |
| R8 | Local Backend Loop | feature | Exercise the full product locally from WeChat DevTools against this Mac. |
| R9 | Style And Performance Hardening | hardening | Keep the mature app fast and visually coherent as features grow. |
| R10 | Production Backend Readiness | hardening | Move from local proof to real WeChat users safely. |

Feature phases: R1 through R8.

Hardening phases: R0, R9, and R10.

R0 is always active as a guardrail. Any map blur, black space, broken edge
constraint, broken drag/pinch, wrong projection, or sluggish marker interaction
blocks the current slice.

For planning, count R1-R8 as feature phases and R0/R9/R10 as hardening phases.
R0 is continuous and defensive; it should not absorb product maturity work.
R9 runs after each feature slice to keep the growing non-map UI fast and
visually coherent. R10 waits until local flows are coherent enough to expose to
real users.

## Phase-By-Phase Migration Plan

The migration should advance by product leverage. The map gives the app its
identity already, so the highest leverage work is to make everything around the
map usable, durable, searchable, and safe.

| Order | Phase | Build first | Then mature | Done when |
| --- | --- | --- | --- | --- |
| 0 | R0 Realm Map Guardrail | Keep current tile map crisp, bounded, and pinchable. | Keep asset pipeline and edge fill natural as data grows. | Realm remains a full-screen map with no empty-space leaks or blur regressions. |
| 1 | R1 Tile Mini-App Shell | Home, Discover, Realm, Messages, My tabs. | Preserve map context and route budget as tabs gain real content. | Users can move around the app and always return to the same map. |
| 2 | R2 Entry, Login, Profile | Dev login, onboarding, profile, role, consent gates. | WeChat login contract and account safety. | Public actions know who the user is and whether setup is complete. |
| 3 | R3 Home Town Pulse | Activity, town stats, district shortcuts, recent runs. | Personalized pulse, stale/backend states, larger windowed lists. | Home explains what changed without becoming a generic feed. |
| 4 | R4 Discover And Placement | Unified search, filters, public building results. | Placeable public buildings, people/circle/book/event results. | Users can find public content and place allowed buildings on their layer. |
| 5 | R5 Building Lifecycle And Books | Building drawer, book summary, lifecycle actions. | Audit trail, review policy, private/raw book safety. | Buildings feel like durable places backed by memory and permissions. |
| 6 | R6 Messages And Agent Communication | Agent run rows, review notices, notification channels. | Cancel/retry/ack/subscription, deep links, windowing. | Agentic interaction is first-class without turning Realm into chat. |
| 7 | R7 My Ownership Workbench | Owned buildings/books/agents, drafts, published, archived. | Profile trust, lifecycle controls, failed/stale warnings. | Users can manage everything they own from one tile-styled workbench. |
| 8 | R8 Local Backend Loop | Local login, snapshot, query, publish, run/review endpoints. | Persistence, multi-user isolation, failed/stale/retry states. | WeChat DevTools can exercise the full product against this Mac. |
| 9 | R9 Style And Performance Hardening | Visual audit and budget checks after every feature slice. | List windowing, setData/delta pressure, device smoke tests. | The mature app still feels like Moontown and stays fast. |
| 10 | R10 Production Backend Readiness | WeChat login, HTTPS/cloud backend, storage. | Rate limits, moderation, audit retention, monitoring, backups. | Real users can use the app without leaking secrets or private data. |

Near-term priority:

1. Keep R0 green.
2. Finish R2 enough that every public action has identity and setup gates.
3. Deepen R3/R4 so users can understand the town and find public objects.
4. Deepen R5/R6 because buildings, books, agents, runs, and reviews are the
   core product loop.
5. Deepen R7 so private and published work is manageable.
6. Expand R8 only after the UI contracts are stable enough to test end to end.
7. Apply R9 continuously.

## R0: Realm Map Guardrail

Type: hardening.

Purpose: preserve the current full-screen Moontown map as the only Realm.

Tasks:

- Keep the generated mini-app using the real Moontown tile raster.
- Keep meaningful expanded terrain at projected edges.
- Keep drag/pinch constrained to real map content.
- Keep markers and building drawers data-driven.
- Keep map assets crisp on common WeChat phone viewports.
- Maintain first-screen and scene-render budgets.

Deliverable:

- A stable full-screen Realm route that all other phases can depend on.

Acceptance:

- Realm opens directly to the real map.
- No large empty space appears when dragging or pinching.
- Building hit targets remain usable.
- Bunnia inspect stays green for map/render pressure.

## R1: Tile Mini-App Shell

Type: feature.

Purpose: make the app navigable while keeping Realm equal to the map.

Tasks:

- Keep bottom tabs: `Home`, `Discover`, `Realm`, `Messages`, `My`.
- Route `Realm` to the same full-screen map state.
- Keep map actions close to the map: search, publish, selected building,
  create building, create agent, and ask building.
- Use tile controls and compact panels rather than generic page chrome.

Deliverable:

- A mature shell where all tabs feel attached to the town.

Acceptance:

- Tapping Realm never opens a mock graph or second map.
- Navigation does not reduce map clarity or touch quality.
- The user can return from any tab to the same spatial context.

## R2: Entry, Login, And Profile

Type: feature.

Purpose: support real user identity before public actions.

Tasks:

- Add short first-run onboarding using tile scenes and town signposts.
- Add dev login for local work and WeChat login contract for production.
- Store profile, nickname/avatar, role, consent, session, and active workspace.
- Gate create, publish, share, and public placement behind profile and
  permission readiness.

Deliverable:

- Users can enter the town with a known identity and safe setup state.

Current implementation:

- Profile readiness is projected as tile-style setup gates for session,
  onboarding, role, consent, profile save, and publish readiness.
- My/Identity Setup renders those gates as compact checklist rows with local
  action messages for login, onboarding, role choice, consent, and profile save.
- Building lifecycle controls carry allowed/blocked metadata, show the block
  reason, and render blocked actions as disabled buttons.

Acceptance:

- New users see onboarding/setup once.
- Returning users reach Realm quickly.
- Public actions are blocked until required setup is complete.
- No frontend bundle contains WeChat secrets.

## R3: Home Town Pulse

Type: feature.

Purpose: mature Home without turning it into a generic feed app.

Tasks:

- Show recent building activity, agent runs, review needs, published updates,
  shared work, and failed actions.
- Convert product market, demand hall, event calendar, city guide, and OPC hub
  into district shortcuts tied to map buildings.
- Show compact stats for buildings, agents, runs, reviews, and public
  placements.
- Keep all lists scoped and windowed.

Deliverable:

- Home becomes a tile-styled town dashboard.

Acceptance:

- Home explains what changed in town without replacing the map.
- Feature entries look like districts or notice boards.
- Activity rows deep-link to buildings, agents, runs, books, or messages.

## R4: Discover And Placement

Type: feature.

Purpose: make published objects findable and reusable.

Tasks:

- Search buildings, users, agents, books, events, demands, products, and posts.
- Filter by type, owner, visibility, capability, freshness, and placeable state.
- Let users place allowed published buildings onto personal/team map layers.
- Keep building identity separate from map placement.
- Prevent private/shared objects from leaking into public search.

Deliverable:

- Public discovery that can grow the town without copying durable knowledge.

Acceptance:

- A published building can appear on many maps through placements.
- Private draft and shared-private content never appears in public search.
- Search results stay responsive with large fixtures.

## R5: Building Lifecycle And Books

Type: feature.

Purpose: make each visible building durable, permissioned, and book-backed.

Tasks:

- Bind each building to a primary book and optional support books.
- Show safe book summary, memory count, review count, and run state.
- Support create, edit, share, submit, publish, place, archive, and restore
  where allowed.
- Record audit events for lifecycle actions.
- Keep raw private book content backend-only.

Deliverable:

- Building drawers become the main object detail surface.

Current implementation:

- My Lifecycle renders a tile-style publication pipeline for the active owned
  building: private draft, team share, publish review, town published, and
  archive.
- The pipeline is derived from the same ownership, profile, visibility, and
  lifecycle rules used by the action buttons, so blocked states and explanations
  stay consistent.

Acceptance:

- The user can tell whether a building is private, shared, submitted,
  published, or archived.
- Querying a building records a run against its book.
- Accepted agent output can become book memory after review.
- Public summaries do not expose private ledgers.

## R6: Messages And Agent Communication

Type: feature.

Purpose: make communication first-class for an agentic mini-app.

Tasks:

- Add channels for unread, agent runs, reviews, shares, publishes, system
  notices, failed actions, and subscriptions.
- Deep-link messages to buildings, books, agents, threads, runs, reviews, and
  profiles.
- Support send, stream/status, cancel, retry, acknowledge, and review decision
  flows.
- Keep long chats and notification streams paginated/windowed.
- Represent agent-to-human, agent-to-agent, handoff, broadcast, review, and
  tool-result events with typed records.

Deliverable:

- A tile-styled message center plus map/building badges for agent work.

Acceptance:

- Agent events and human events share one communication model.
- Review-needed and run-complete notices are visible.
- Failed backend or agent actions can be retried or inspected.
- Chat does not force whole-page rerenders.

Current slice:

- Messages keeps agent communication outside the Realm map while still using
  the same tile-town language: run plaques, review controls, building links,
  and small state badges.
- Run actions are derived from run state. Open-building is always available,
  review accept/reject only enable for reviewable runs, and retry only enables
  for failed, rejected, or cancelled runs.
- Cancel and retry use stable mini-app backend endpoint messages
  (`cancel-run`, `retry-run`) while the run id stays attached as UI
  data. That keeps Messages portable across WeChat, Alipay, and TikTok-style
  adapters without generating one endpoint per run.
- The WeChat event bridge forwards tapped row data into agent run operations,
  so a visible run plaque can cancel or retry the intended run rather than only
  triggering a global endpoint.
- Review buttons carry `reviewId`, `runId`, and `decision` on the tap target,
  so accepting or rejecting memory is tied to the intended review item.
- Building lifecycle controls carry `buildingId`, `bookId`, and target refs on
  the tap target, so place, share, publish, and archive requests stay scoped to
  the building plaque that triggered them.
- Discover now translates the reference people and circle pages into compact
  town spotlights and filters instead of a generic social feed. People and
  circles remain searchable discovery objects with target refs for later
  deep-links.
- Messages now translates new follows, interactions, and system subscription
  prompts into tile buckets, while keeping agent runs and reviews in the same
  communication model.
- Notification buttons now carry notice id, kind, target refs, and building ids
  into stable ack/subscription backend actions, so follows, interactions, and
  subscription prompts can be exercised from WeChat DevTools without per-notice
  endpoints.
- Route generation keeps backend metadata filtered to endpoints reachable from
  the rendered tab/surface, preserving JS budget as Messages, My, and backend
  loop endpoints mature.

## R7: My Ownership Workbench

Type: feature.

Purpose: give users control over their private and public work.

Tasks:

- Show owned buildings, books, agents, drafts, shared items, submitted items,
  published items, archived items, and activity.
- Add filters for object type and visibility state.
- Show warnings for incomplete profile, blocked publication, failed runs, and
  stale backend data.
- Keep account/profile operations separate from public discovery.

Deliverable:

- My becomes the user's inventory and workbench.

Acceptance:

- Users can find every private draft and published object they own.
- Visibility state is obvious.
- Private book content is not exposed through profile surfaces.

Current slice:

- My now translates the reference profile page into a tile-styled identity card
  with display name, UID, avatar reference, profile readiness, social/activity
  stats, and edit/consent actions.
- My also exposes the OPC/credential concept as a compact town plaque linked to
  the credential district/building, so account trust remains part of the town
  system instead of a generic wallet page.

## R8: Local Backend Loop

Type: feature.

Purpose: make the mature app testable locally before production deployment.

Tasks:

- Run local dev login, snapshot, search, create, place, share, publish,
  archive, chat, agent, run, review, and ownership APIs.
- Persist local users, buildings, placements, agents, books, threads, messages,
  runs, and audit events.
- Point WeChat DevTools at `http://127.0.0.1:18191`.
- Show backend loading, stale, failed, retrying, and synced states in tile UI.

Deliverable:

- A local end-to-end Moontown mini-app loop on this computer.

Current implementation:

- Home exposes a tile-style Backend Loop panel for local dev login, snapshot
  load, publish, and building query endpoints.
- The same panel shows session, snapshot cache, mutation queue, and review
  result states, including a stale-safe snapshot row for backend failure
  visibility.

Acceptance:

- Two local users have isolated private data.
- Shared-private buildings appear only for invited users.
- Published buildings can be searched and placed by other users.
- Backend failures show stale/cache state instead of silently breaking the map.

## R9: Style And Performance Hardening

Type: hardening.

Purpose: keep the app mini-app friendly as features mature.

Tasks:

- Audit every page against the tile-gamified visual system.
- Replace generic cards with town ledgers, panels, badges, stamps, drawers, or
  signposts where appropriate.
- Enforce first-screen data, render pressure, scene pressure, backend pressure,
  repeated-list pressure, and agent-delta budgets.
- Validate map pan/zoom, tab switching, drawers, search, messages, ownership,
  and backend calls in WeChat DevTools.
- Keep package assets budgeted and crisp.

Deliverable:

- A mature mini-app that still feels like Moontown and stays fast.

Acceptance:

- No major surface looks visually disconnected from the map.
- No feature introduces slow whole-page rerenders.
- Inspect and tests stay green.

## R10: Production Backend Readiness

Type: hardening.

Purpose: prepare for real WeChat users.

Tasks:

- Replace dev login with real WeChat login through backend-only secrets.
- Deploy through approved HTTPS domain or WeChat cloud.
- Add production database and object storage.
- Add session rotation, rate limits, abuse controls, moderation, audit
  retention, backups, health checks, monitoring, and error reporting.
- Add admin/reviewer tools for publication and reports.

Deliverable:

- A production-safe path from local mini-app proof to real users.

Acceptance:

- Phone login works.
- Approved network domains are configured.
- No frontend bundle leaks secrets or private raw books.
- Published town content has review, report, hide, and takedown paths.

## Migration Order

Build in this order:

1. Keep R0 green at all times.
2. Finish R1/R2 so navigation and identity are stable.
3. Build R3/R4 so users can understand the town and find public content.
4. Build R5 because buildings and books are the product core.
5. Build R6 because agentic interaction is first-class.
6. Build R7 so users can manage everything they create.
7. Wire R8 for local end-to-end testing.
8. Run R9 after every feature slice, not only at the end.
9. Start R10 only after local flows are coherent and measurable.

The highest-leverage next work is not another map experiment. It is completing
the app maturity around the existing map: identity gates, Home pulse, Discover,
building lifecycle, messages, ownership, and the local backend loop.

## Data Relationship

Use this relationship as the product model:

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

## Validation Loop

Each phase should end with:

- MoonBit tests for the touched model/view helpers.
- Bunnia inspect for first-screen, render, scene, agent, repeated-list, backend,
  and asset budgets.
- WeChat DevTools smoke for the affected flow when UI or backend behavior
  changes.
- A visual check that the page still reads as the same tile town.

Do not accept a phase that works only as a small demo. The app is expected to be
large, so every feature must preserve bounded rendering and clear state updates.
