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
