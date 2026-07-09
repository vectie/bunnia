# Moontown UI/UX Implementation Plan

This plan turns the UI/UX doctrine into an implementation sequence for the
Moontown mini-app.

It does not replace the product migration plan. It is the visible-product track
that runs across the existing R phases:

```text
Realm stays the map.
The UI work makes every surrounding surface understandable to ordinary users.
Diagnostics stay available, but behind an explicit boundary.
```

The highest-leverage issue is not another feature surface. It is that some
ordinary screens still expose backend language. The next implementation passes
should move from system-first UI to town-first UI before adding more visible
complexity.

## Success Criteria

The UI/UX track is successful when an ordinary user can:

- enter town and understand what changed without reading backend terms
- use Home, Discover, Realm, Messages, and My as distinct town surfaces
- search, open, place, watch, review, retry, publish, and manage work through
  plain actions
- understand agent work as messages, review needs, results, and town changes
- recover from stale or failed backend state through retry rows and warnings
- avoid endpoint ids, HTTP paths, payload keys, runtime labels, cursor values,
  and DevTools targets unless developer/reviewer mode is open

The implementation should stay concise. Prefer renaming, hiding, gating,
reusing existing data, and making compact drawers over adding new pages.

## Non-Goals

Do not use this track to:

- build a second Realm
- redesign the map projection
- copy the reference app's visual style directly
- add a generic social feed disconnected from buildings, books, agents, or the
  map
- expose local backend controls as the main product
- create compatibility layers for stale framework experiments

The goal is a dedicated, tile-gamified Moontown mini-app UI that can later sit
on the Bunnia framework cleanly.

## Phase Overview

Use UX phases to execute visible-product cleanup. These are not new product
roadmap phases; they are implementation slices that map onto R1 through R10.

| Phase | Type | Main output | Maps to |
| --- | --- | --- | --- |
| UX0 UI Inventory And Boundary | hardening | Visible technical labels have a fate: rename, hide, gate, or keep. | R9 |
| UX1 User-Language Shell Cleanup | feature polish | Tabs and shared shell no longer expose backend wording to ordinary users. | R1, R9 |
| UX2 Home Town Pulse Reframe | feature polish | Home answers "what changed?" instead of "what endpoints run?" | R3, R8 |
| UX3 Discover Market Board Reframe | feature polish | Search and paging become market-board actions, not query controls. | R4, R8 |
| UX4 Realm Map Interaction Polish | feature polish | The map stays dominant, with only user-meaningful badges and drawers. | R0, R5, R6 |
| UX5 Messages Attention Center | feature polish | Agent and human communication becomes attention-based mail, not sync state. | R6, R8 |
| UX6 My Inventory Workbench | feature polish | Ownership, readiness, and profile become inventory/passport work, not ops data. | R2, R7, R10 |
| UX7 Building And Agent Drawers | feature | Buildings, books, agents, and runs share one compact object-detail pattern. | R5, R6 |
| UX8 Diagnostics And Reviewer Mode | hardening | Developer/reviewer details move behind a deliberate diagnostics boundary. | R8, R10 |
| UX9 Tile Visual System Hardening | hardening | Tokens, spacing, touch targets, states, and labels are consistent. | R9 |
| UX10 Validation Guardrails | hardening | Tests and inspections prevent system labels from leaking back. | R9, R10 |

Feature-heavy UI phases: UX1 through UX7.

Hardening phases: UX0, UX8, UX9, and UX10.

UX0 should happen first. UX8 through UX10 should run continuously once the
ordinary surfaces have been cleaned up.

## Shared Implementation Rules

### Ordinary Mode

Ordinary user mode may show:

- Town Updates
- Latest Messages
- My Inventory
- More
- Refresh
- Try again
- Needs refresh
- Waiting for review
- Agent needs your decision
- Saved
- Published
- Hidden from town

Ordinary user mode must not show:

- endpoint ids
- HTTP method/path strings
- payload keys
- response keys
- runtime filter/channel labels
- DevTools targets
- cache source internals
- cursor or offset values
- raw run ids
- readiness secret checks
- route diagnostics

### Reviewer And Developer Mode

Reviewer/developer mode may show:

- endpoint id
- method and path
- payload and response keys
- backend status
- rate-limit bucket
- audit retention
- readiness checks
- package and render diagnostics
- generated asset and scene diagnostics

That mode must be explicit. A normal user should not enter it accidentally by
opening Home, Messages, My, or a building drawer.

### Copy Dictionary

Use this mapping during implementation.

| Current/system copy | Ordinary user copy |
| --- | --- |
| Backend Loop | Town Updates, or hidden developer tools |
| DevTools target | hidden |
| Sync Ownership | Refresh My Stuff |
| Own Sync | My Inventory |
| Center Sync | Latest Messages |
| load-message-center | Latest Messages |
| Ack Sync | Mark Read |
| Tool Ack | Review Result |
| Ops Desk | Reviewer Tools |
| Ops Check | Check Town Safety |
| Readiness | Launch Checks |
| endpoint ready | hidden |
| backendStatus idle | hidden |
| runtime filter | hidden |
| runtime channel | hidden |
| cursor/window/offset | More |
| payload | hidden |
| cache stale | Needs refresh |
| request failed | Could not update. Try again. |
| run waiting-review | Agent needs your decision |

Do not rename internal constants just for copy. Prefer a display-label layer so
tests and backend contracts stay stable.

## UX0: UI Inventory And Boundary

Type: hardening.

Purpose: identify every ordinary-user leak before changing code.

Big change first:

- Build a visible-copy inventory from generated Moontown output and source
  definitions.
- Mark each label as `ordinary`, `reviewer`, `developer`, or `internal`.
- Give every technical label one fate: rename, hide, gate, or keep.

Implementation tasks:

1. Search source and generated examples for backend-facing copy:
   `Backend Loop`, `DevTools`, `runtime`, `endpoint`, `payload`, `cursor`,
   `cache`, `Ack Sync`, `Tool Ack`, `Ops Desk`, `readiness`, and HTTP paths.
2. Split findings by surface: Home, Discover, Realm, Messages, My, building
   drawer, review drawer, and diagnostics.
3. Record the user job for each visible technical label.
4. If no user job exists, move it to reviewer/developer mode.
5. If the user job exists, translate it with the copy dictionary.
6. Decide which labels need tests or lints to prevent regression.

Deliverables:

- A short implementation checklist in the relevant issue/commit notes.
- A list of labels to change in UX1 through UX8.
- A small "forbidden ordinary copy" list used by UX10.

Acceptance checks:

- No visible technical string remains unclassified.
- Every diagnostics string has an owning gated surface.
- The next coding pass can start with large, known edits rather than small
  label guessing.

Validation:

- `rg` inventory before and after the phase.
- No generated output changes are required unless the inventory is implemented
  as code or tests.

## UX1: User-Language Shell Cleanup

Type: feature polish.

Purpose: make the shared mini-app shell read like a town product.

Big change first:

- Add or use a display-label boundary between backend contracts and visible
  labels.

Implementation tasks:

1. Keep route ids, endpoint ids, payload keys, and test selectors stable.
2. Add ordinary display labels for shared route and backend action metadata.
3. Rename visible tab/subtitle/helper labels into town language.
4. Hide runtime status from normal tab headers and route plaques.
5. Replace generic "Next" labels with "More" where the user is paging content.
6. Ensure bottom navigation and fixed controls respect safe areas.
7. Keep touch targets at least 44 px equivalent in mini-app layout.

Surface targets:

- `Home`: town pulse / notice board.
- `Discover`: market board.
- `Realm`: map.
- `Messages`: mail board / attention.
- `My`: town passport / inventory.

Acceptance checks:

- A first-time user can read the tab shell without backend knowledge.
- No route title depends on endpoint, runtime, or data-contract naming.
- Existing backend requests still work because internal ids are unchanged.

Validation:

- `moon test`.
- Strict Moontown build/inspect if generated UI changes.
- Quick generated WXML search for forbidden ordinary copy.

Current implementation note:

- The ordinary shell exposes Enter, Realm, and Passport actions without platform
  wording. Legacy two-user switch controls and patches are removed from generated
  ordinary output.
- The display-label layer is split by counts/passport readiness,
  status/visibility copy, kind labels, and navigation/placement copy, keeping
  backend ids stable while ordinary labels evolve by product concern.

## UX2: Home Town Pulse Reframe

Type: feature polish.

Purpose: make Home answer "what changed and where should I go?"

Big change first:

- Move backend-loop detail out of the ordinary Home hierarchy.

Implementation tasks:

1. Convert the top Home content into a compact town-pulse summary:
   recent town activity, attention count, important building/agent changes,
   and stale/retry warnings.
2. Keep district shortcuts as the main way to move into product areas.
3. Rename backend actions:
   - snapshot load -> Refresh Town
   - ownership load -> Refresh My Stuff
   - message center load -> Latest Messages
   - backend cache stale -> Needs refresh
4. Replace endpoint/path/method rows with user consequence rows.
5. Gate DevTools target, raw backend cache source, endpoint ids, method/path
   text, and payload labels behind diagnostics.
6. Link every Home row to one real destination: Realm, Discover, Messages, My,
   building drawer, or review drawer.
7. Keep large activity lists windowed and keyed.

Ordinary Home should show:

- "3 places changed"
- "Agent needs your decision"
- "Market has new public places"
- "Some updates need refresh"
- "Open", "Review", "More", "Try again"

Ordinary Home should not show:

- `GET /miniapp/...`
- `load-town-snapshot`
- `backendStatus`
- `payload_key`
- `DevTools target`

Acceptance checks:

- Home can be understood as a product screen with diagnostics hidden.
- Home exposes only immediate town choices.
- The backend can still be exercised through reviewer/developer mode.

Validation:

- `moon test`.
- Inspect first-screen bytes and event patch operations.
- Manual DevTools smoke: Home refresh, stale state, route links.

Current implementation note:

- Home renders a compact Town Pulse plus District Gates. Rows route to Realm,
  Messages, Discover, or My with ordinary labels, while migration/reference copy
  and backend-loop details are guarded out of ordinary generated WXML. District
  shortcut buttons use typed destination actions instead of generic filter copy.
  Town Pulse is now split into row data, row derivation, panel rendering, and
  summary/count helpers. District Gates are split by panel assembly,
  destination/action derivation, district row rendering, and presence chips, with
  `home_districts.mbt` kept as the UX2 marker so Home navigation changes can
  evolve without reopening one broad Home surface file.

## UX3: Discover Market Board Reframe

Type: feature polish.

Purpose: make Discover a public market board rather than a query debugger.

Big change first:

- Keep backend search windowing, but remove query-window internals from visible
  copy.

Implementation tasks:

1. Present search as a market-board search field plus filter plaques.
2. Keep result actions typed:
   open, place, watch, join, answer, read, request, preview.
3. Replace cursor/window labels with "More".
4. Hide filter payload echo, endpoint ids, response keys, and raw query object
   labels from ordinary rows.
5. Show result eligibility in user terms:
   "Can place", "Already placed", "Public", "Owner only", "Needs setup".
6. Keep public/private boundaries visible through badges, not raw visibility
   constants.
7. Ensure empty and failure states tell the user what to do next.

Acceptance checks:

- Discover users can find and act on public objects without seeing query
  machinery.
- Placeable results clearly return to Realm.
- Private/shared-private objects remain absent from public search.
- Paging does not make visible labels technical.
- Current implementation note: the market board surface is isolated in
  `discover_market.mbt`, reusable Realm open actions live in `place_actions.mbt`,
  and empty results use ordinary copy instead of search payload details. District
  entries keep filter metadata internal while visible buttons say where they go.
  Discover projection is now grouped by result filtering, activity/audit rows,
  agent work/reviews, and town-pulse stats; Market Board rendering is grouped by
  assembly, lists/filters, row labels, and typed actions.

Validation:

- Backend search smoke for kind/filter/placeable/paging.
- Inspect list windowing, duplicate keys, update payloads, and package size.
- Manual DevTools smoke: search, filter, more, place, watch, typed actions.

## UX4: Realm Map Interaction Polish

Type: feature polish.

Purpose: keep the map dominant while making it more useful.

Big change first:

- Remove non-map diagnostics from the ordinary Realm layer.

Implementation tasks:

1. Keep Realm full-screen and map-first.
2. Show only user-meaningful overlays:
   selected building, unread badge, review badge, active agent badge,
   private/shared/public state, and placement hints.
3. Keep pinch/drag constraints and projection-aware terrain from R0 untouched.
4. Use the selected building drawer for actions instead of floating backend
   panels.
5. Keep hit targets stable for markers and drawer actions.
6. Avoid turning Realm into search, chat, admin, or diagnostics.
7. Route long tasks to Discover, Messages, or My while preserving building
   context.

Acceptance checks:

- Realm still opens as the current Moontown map.
- No large empty space appears during pan/pinch.
- Markers remain tappable and visually tied to map positions.
- Visible overlays explain town state, not render/projection internals.
- Current implementation note: Realm map code is isolated in focused
  `realm_map*` files, ordinary Realm no longer renders the onboarding/setup HUD,
  the floating action rail is gone, and selected-place actions live inside the
  building drawer. Map assembly, backdrop assets, marker hit targets, and
  selected-building HUD chips now have separate files so UX4 work stays
  map-first without reopening a Realm monolith.

Validation:

- Manual DevTools pan, pinch, marker tap, drawer open/close.
- Inspect scene assets, marker counts, map quality issues, and package size.
- Screenshot comparison against current accepted map rendering.

## UX5: Messages Attention Center

Type: feature polish.

Purpose: make agent and human communication first-class without exposing sync
machinery.

Big change first:

- Reframe the message center as attention buckets and action rows.

Implementation tasks:

1. Rename message channels into user buckets:
   Needs Review, Agent Replies, Interactions, Town Notices, Failed Actions.
2. Rename backend actions:
   - Center Sync -> Latest Messages
   - Ack Sync -> Mark Read
   - Tool Ack -> Review Result
   - retry-run -> Try Again
   - cancel-run -> Stop Work
3. Hide raw run ids, endpoint ids, thread ids, payload keys, and channel filter
   internals.
4. Keep building, book, agent, run, or review context on every message row.
5. Show agent output as result cards with accept/reject/retry/reply actions.
6. Keep long streams cursor-windowed but visible as "More".
7. Ensure failure rows are recoverable and scoped to the object that failed.

Acceptance checks:

- Users can tell who needs them and what action is available.
- Agent communication never feels like raw infrastructure.
- Messages link back to building drawers or Realm when location matters.
- Current implementation note: Messages now starts with explicit attention rows
  for pending reviews, active agent work, recovery, and town signals; work,
  result, review, notice, and shared context helpers live in focused message
  modules instead of one monolithic surface file. Attention rows are now split
  by row model, derivation, panel assembly, and row rendering, with bucket
  summaries and notification channel chips also kept in separate UX5 modules so
  agent replies, reviews, failed actions, and town notices can evolve without
  reopening the page assembly.

Validation:

- Local backend smoke for send, center, ack, subscription, retry, cancel, and
  review decision.
- Inspect update payload and event patch operations.
- Manual DevTools smoke for unread/review/agent channels and "More".

## UX6: My Inventory Workbench

Type: feature polish.

Purpose: make profile, readiness, ownership, and reviewer controls legible.

Big change first:

- Separate ordinary inventory from reviewer/ops tooling.

Implementation tasks:

1. Present top My as town passport:
   identity, role, profile readiness, and setup stamps.
2. Present owned work as inventory shelves:
   buildings, books, agents, placements, drafts, submitted, published,
   archived, watched.
3. Translate account blockers into user tasks:
   "Finish profile", "Choose role", "Accept consent", "Submit for review".
4. Keep reviewer-only tools behind a Reviewer Tools entry.
5. Hide production secret checks, raw permission fields, readiness route names,
   and ops endpoint labels from ordinary My.
6. Keep ownership filters as plain categories, not backend query fields.
7. Link every ownership row to a concrete action or destination.

Acceptance checks:

- Ordinary users see what is theirs and what needs action.
- Reviewers can still reach ops checks deliberately.
- Profile readiness is helpful, not a dump of permission state.
- Current implementation note: My now has an explicit inventory shelf strip for
  buildings, placements, drafts, submitted work, published work, archived work,
  books, agents, and watched places before the detailed ownership list. Setup
  stamps stay in Town Passport instead of repeating inside My Inventory, and
  the inventory refresh plaque exposes one clear Refresh My Stuff action instead
  of a duplicate generic More backend trigger. Placement rows translate raw source
  ids into ordinary map-state copy. Town Passport is now split by panel
  assembly, setup/role stamps, identity card, and profile metric chips, with
  `my_passport.mbt` kept as the UX6 marker. My workbench assembly is split into
  focused passport/setup, lifecycle, reviewer/refresh, public passport, alert,
  inventory shelf, and inventory row modules so UX6 additions do not reopen a
  page monolith. Inventory shelves are now further split into shelf data,
  shelf-row derivation, and shelf rendering files so ownership counts and
  actions can evolve without reopening a shelf monolith. Workbench alerts are
  further split by alert model, alert derivation, recovery filters, and row
  rendering so My recovery tasks can evolve without reopening the workbench
  alert boundary. Public Passport is split by panel assembly, public-summary
  derivation, passport row rendering, and credential plaque lookup so reference
  profile work can evolve without reopening the My public identity boundary.

Validation:

- Local backend smoke for ownership filters and profile readiness.
- Inspect list windowing and generated bytes.
- Manual DevTools smoke: profile, filters, owned row route, reviewer gate.

## UX7: Building And Agent Drawers

Type: feature.

Purpose: make the core Moontown object model visible in one compact pattern.

Big change first:

- Standardize object drawers before adding more object-specific panels.

Implementation tasks:

1. Use one drawer pattern for building, book shelf, agents, communication, and
   lifecycle actions.
2. Make the building header explain:
   name, category, owner relationship, visibility, lifecycle, and current
   capability.
3. Show book memory as a shelf:
   safe summary, accepted memory count, review needs, and read action.
4. Show agents as workers:
   role, status, latest work, and message/review action.
5. Show lifecycle as stamps:
   private draft, shared, submitted, published, hidden, archived.
6. Show communication context:
   latest message, agent reply, run status, review need.
7. Keep raw book content, private ledgers, run ids, and audit payloads out of
   ordinary drawers.

Acceptance checks:

- A user can open a building and know what it is, who owns it, what agents do,
  and what action comes next.
- Agent work is tied to a building/book/thread context.
- Public drawers expose safe summaries only.
- Current implementation note: the selected-building drawer now uses focused
  object modules for shell assembly, header, drawer primitives, labels, actions,
  memory, workers, lifecycle, and communication. Ordinary communication shows
  message/work/review context cards instead of audit-ledger rows. Communication
  context is further split by card model, section assembly, card
  derivation/rendering, and shared helpers so agent/thread/review context can
  evolve without reopening the object-context boundary. Lifecycle stamps are
  split by row model, section assembly, stage rendering, and action/reason
  rendering so building publication states can evolve without reopening the
  drawer boundary. Book memory shelf data is split by public shelf entry points,
  shelf item model, building-book derivation, primary-book lookup, and safe copy
  policy so memory counters and review needs can evolve without reopening the
  drawer boundary. Memory shelf rendering is split by section assembly, safe row
  rendering, memory/review meta copy, and row actions so shelf presentation can
  evolve without reopening the drawer boundary. Agent workers are split by
  section assembly, worker row rendering, latest-run lookup, and role/meta copy
  so worker status and next actions can evolve without reopening the drawer
  boundary. Building action
  workflows are split by draft/profile editing, publication lifecycle, building
  messages, and public placement so drawer work can evolve one object concern at
  a time.

Validation:

- Local backend smoke for building update, submit, publish, archive, restore,
  agent create, handoff, and review.
- Inspect scene marker links and drawer event patch pressure.
- Manual DevTools smoke from map marker, Discover result, Messages row, and My
  row into the same drawer pattern.

## UX8: Diagnostics And Reviewer Mode

Type: hardening.

Purpose: keep powerful technical information without leaking it to ordinary
users.

Big change first:

- Add a clear diagnostics/reviewer entry point and move technical panels there.

Implementation tasks:

1. Define mode/source:
   ordinary user, reviewer, developer.
2. Put endpoint rows, HTTP paths, payload keys, response keys, readiness
   checks, audit/backup/recovery, rate limits, and package diagnostics in the
   gated mode.
3. Keep reviewer actions user-safe:
   review, hide, takedown, release hold, resolve incident, check readiness.
4. Keep developer actions explicit and local/dev-only where needed.
5. Ensure ordinary routes do not render diagnostics just hidden by color or
   weak visual hierarchy.
6. Add regression checks for forbidden ordinary copy.

Acceptance checks:

- Ordinary screenshots contain no backend implementation labels.
- Reviewers and developers can still inspect the system deliberately.
- Production readiness remains testable without becoming the main UI.
- Current implementation note: Reviewer tools are isolated behind the reviewer
  route and split by operations assembly, reviewer check sections, moderation
  rows, developer contract diagnostics, and backend-step lookup. Ordinary
  `Home`, `Discover`, `Realm`, `Messages`, and `My` generated WXML is scanned
  for diagnostic classes, diagnostic data attributes, backend paths,
  payload/response keys, and reviewer-only copy while `pages/moontown/reviewer`
  remains the allowlisted technical surface.

Validation:

- Forbidden-copy search in generated ordinary surfaces.
- Reviewer-mode smoke for ops, readiness, moderation, audit, and health.
- Verify hidden/gated controls do not add excessive first-screen weight.

## UX9: Tile Visual System Hardening

Type: hardening.

Purpose: make the app feel coherent as it grows.

Big change first:

- Consolidate visible UI primitives around tile-town components.

Implementation tasks:

1. Define or enforce shared tokens for:
   surface, plaque, stamp, badge, drawer, shelf, mail row, market row,
   inventory row, warning, success, stale, review, and disabled.
2. Replace generic cards with town objects where needed:
   ledger, plaque, shelf, workbench item, district gate, run plaque, mail row.
3. Keep type sizes compact and stable for mini-app density.
4. Avoid card-inside-card layouts.
5. Keep icon usage consistent; avoid emoji as structural icons.
6. Preserve safe-area spacing for headers, tabs, drawers, and bottom actions.
7. Ensure pressed/disabled states do not shift layout.
8. Keep long labels wrapped or shortened so controls never overflow.

Acceptance checks:

- Home, Discover, Messages, My, and drawers look like the same town product.
- All touch targets are usable on small phone screens.
- Visual state is understandable without reading system text.
- Current implementation note: the ordinary mini-app WXSS is split into focused
  `visual_tile_*` files behind the `visual_tiles.mbt` marker, with source
  assembly, reviewer-only styling, base controls, map, shell, primitive rows,
  state tones, content strips, drawers, responsive rules, and selector helpers
  separated. Generated stylesheet tests now guard touch-action, 88rpx touch
  targets, safe-area offsets, scroll-safe page surfaces, palette breadth,
  wrapped action rows, and no negative letter spacing.

Validation:

- Manual screenshot review on small phone and large phone sizes.
- Inspect package/render/list budgets.
- Reduced-motion and large-text spot checks where the platform supports them.

## UX10: Validation Guardrails

Type: hardening.

Purpose: prevent UI regressions while the mini-app grows.

Big change first:

- Add checks that protect ordinary user space.

Implementation tasks:

1. Add a forbidden ordinary-copy check for generated visible surfaces.
2. Keep a small allowlist for diagnostics/reviewer surfaces.
3. Check that backend endpoint ids and payload keys can exist in generated JS
   contracts but not ordinary WXML labels.
4. Extend existing inspection gates for:
   package size, first-screen size, update payloads, event patch operations,
   repeated-list keys, scene assets, map quality, and diagnostics count.
5. Add focused tests for display-label translation where labels are generated
   from backend metadata.
6. Document the manual WeChat DevTools smoke path.

Suggested forbidden ordinary strings:

- `GET /miniapp`
- `POST /miniapp`
- `endpoint`
- `payload`
- `response_key`
- `backendStatus`
- `DevTools`
- `runtime filter`
- `runtime channel`
- `cursor`
- `offset`
- `load-message-center`
- `Ack Sync`
- `Tool Ack`
- `Ops Desk`

Acceptance checks:

- CI or local validation catches accidental backend-label leaks.
- The generated mini-app stays within the strict package budget.
- Map, search, messages, ownership, and backend calls remain smoke-testable.
- Current implementation note: UX10 guardrails now have test-local token helpers
  and focused display-label regression tests in
  `validation_guardrails_test.mbt`, plus a data-driven shell validator backed by
  `scripts/moontown_guardrails/*.txt`. The generator also resets safe build
  output directories before writing, and the shell validator rejects stale
  ordinary page WXSS plus missing 88rpx touch-target and safe-area tokens.
  Projection schema, seeded town data, visibility, lifecycle, discovery,
  actions, inventory, and notification behavior now live in focused package
  files so later UI phases can extend one concern without rebuilding a
  projection monolith. Runtime assembly is likewise split by shell/setup
  patches, filter-query patches, building/workflow patches, reviewer runtime,
  and map gesture methods so interaction work can evolve without reopening the
  runtime monolith. Demo pressure-plan assembly is split by patch/snapshot,
  agent/communication/tool-result, backend contract, and backend/effect plan
  files, with a boundary check keeping `demo_plans.mbt` as the plan marker.
  Schema declarations are grouped by people, content,
  work/reviews, actions, shell, attention, discovery, activity, ownership,
  backend diagnostics, and the projection aggregate. App assembly, generated
  project views/pages/routes/runtime scoping/tab metadata, runtime patches,
  backend plans, scene adapters, shell/navigation, and Home panels are also
  split out of `demo.mbt` and `demo_project.mbt`
  so page-level product work can evolve without reopening demo or project
  assembly monoliths. Home
  Pulse behavior is further split by row model, row derivation, panel rendering,
  and summary/count helpers with a boundary check on `home_pulse.mbt`. District
  Gates are split by panel assembly, destination/action derivation, district row
  rendering, and presence chips, with boundary checks keeping
  `home_districts.mbt` as the UX2 marker. The
  generated page coverage is split by map/shell, object drawer memory/workers,
  lifecycle/privacy, tile visual style, and runtime/plan-budget checks;
  pressure-plan and helper tests also live in focused files,
  generated-project coverage is split by shell/files, route patches, backend
  request contracts, seeded data, and manifest/diagnostic checks, generated tab
  coverage is split by Realm/Home, Discover, Messages, My, and Reviewer
  surfaces, and projection-flow coverage is split by shell/setup, attention
  work, discovery/inventory, review readiness, building lifecycle, and agent
  communication concerns so UX10 coverage can grow by concern. Seeded
  projection data is further grouped by core projection assembly, reviews/runs,
  content/discovery, shell/districts, attention/inventory filters, backend
  state, and places; seeded backend data is split again by core, workflow, and
  reviewer endpoint groups, cache/retry states, and local backend defaults;
  seeded content is split again by books, activity,
  discovery listings, and discovery filters with `projection_seed_content.mbt`
  kept as a marker, and seeded shell data is split again by roles, tabs,
  onboarding, district gates, and presence chips with
  `projection_seed_shell.mbt` kept as a marker. Projection actions are grouped
  by setup/shell, building
  lifecycle, lifecycle helpers, agent/tool-result work, and review decisions;
  shell action behavior is split again by navigation/filter actions,
  profile/setup readiness, reviewer-tool toggles, and setup-gate assembly;
  agent/tool-result action behavior is split again by agent creation,
  handoff/run work, package-local lookup helpers, and tool-result
  acknowledgements; review decision behavior is split again by accept paths,
  reject paths, review-run status updates, and book-memory counters;
  lifecycle helper behavior is split again by selected-building projection
  updates, building mutations, book review counters, and audit event assembly.
  Building actions are further split by draft/profile editing, publication
  lifecycle, communication, and placement so publish/manage/place flows can grow
  without rebuilding the building action monolith. Object drawer shell behavior
  is split by selected-building assembly, header, shared primitives, labels, and
  action/safety rows, with a marker-file guard on `object_drawer.mbt`. Object
  communication context is split by card model, section assembly, card
  derivation/rendering, and selected-context helpers so UX7 drawer communication
  stays compact. Book memory shelf behavior is split by shelf model, building
  derivation, primary-book lookup, and safe-summary copy, with a boundary check
  keeping `book_shelf.mbt` as the UX7 memory marker. Memory shelf rendering is
  split by section assembly, row rendering, meta copy, and row actions, with a
  boundary check keeping `object_memory.mbt` as the UX7 memory-rendering marker.
  Agent worker drawer behavior is split by section assembly, row rendering,
  latest-run lookup, and role/meta copy, with a boundary check keeping
  `object_workers.mbt` as the UX7 worker marker. Reviewer
  diagnostics are split by operations assembly, reviewer check sections,
  moderation rows, developer contract diagnostics, and backend-step lookup so
  UX8 can harden the diagnostics boundary without reopening a reviewer monolith.
  Object lifecycle drawer behavior is split by lifecycle row model, section
  assembly, stage rows, and action/reason rendering, with a marker-file guard on
  `object_lifecycle.mbt`.
  Display copy is split by counts/passport readiness, status/visibility copy,
  kind labels, and navigation/placement labels, with a boundary check keeping
  `display_copy.mbt` as the marker for the ordinary-label layer.
  Lifecycle projection behavior is split by drawer action rows, action builders,
  reason copy, publication stamps, and selected-agent lookup, with
  `projection_lifecycle_actions.mbt` kept as the action marker so UX7 drawer
  polish can change one object concern without reopening a lifecycle monolith.
  Visibility projection behavior
  is split by access policy, visible collections, and selected-object context so
  Realm, Discover, Messages, and My can share the same public/private boundary
  without growing another visibility monolith. Inventory projection behavior is
  split by owned collections, stats, ownership rows, and filter state so UX6 My
  workbench shelves and row actions can evolve without reopening an inventory
  monolith. My Inventory shelves are also split by shelf model, row derivation,
  and panel rendering, with boundary checks keeping `my_inventory_shelves.mbt`
  as a marker instead of a broad product file.
  Town Passport is split by panel assembly, setup/role stamps, identity card,
  and profile metric chips, with boundary checks keeping `my_passport.mbt` as a
  marker instead of a broad setup surface file.
  Workbench alerts are split by alert model, derivation, recovery filters, and
  row rendering, with boundary checks keeping `workbench_alerts.mbt` as a marker
  for My recovery behavior. Public Passport is split by panel assembly, item
  derivation, row rendering, and credential plaque lookup, with boundary checks
  keeping `my_public_passport.mbt` as a marker for My public identity behavior.
  Messages attention behavior is split by row model, derivation, panel assembly,
  and row rendering, with boundary checks keeping `message_attention.mbt` as the
  UX5 attention marker instead of a broad page file.
  Visual tile WXSS is split by source assembly,
  reviewer styling, base controls, map, shell, primitive rows, state tones,
  content strips, drawers, responsive rules, and selector helpers, with boundary
  checks keeping `visual_tiles.mbt` as a marker for the shared UX9 style layer.

Validation:

- `moon test`.
- Strict Moontown build/inspect.
- Local backend smoke.
- WeChat DevTools smoke on this Mac after visible UI changes.

## Recommended First Coding Iteration

Start with UX0, UX1, and the first half of UX8.

This is the highest-leverage slice because it removes the largest product
confusion without changing backend contracts:

1. Inventory visible system copy.
2. Add display labels for backend actions.
3. Rename ordinary Home/Messages/My controls.
4. Move endpoint/path/payload/DevTools/readiness details into a gated
   diagnostics/reviewer surface.
5. Add the first forbidden-copy validation.

Expected risk:

- Low backend risk if ids and payload keys remain stable.
- Medium generated-size risk because adding labels/gates can increase WXML/JS.
- Medium test risk if snapshots assert visible copy.

Mitigation:

- Reuse existing route/action structures.
- Prefer replacing text over adding new panels.
- Move diagnostics rather than duplicating diagnostics.
- Keep generated constants shared where possible.

## Per-Phase Done Checklist

Every UX phase is done only when:

- the screen serves one primary user job
- visible labels use ordinary language
- technical labels are hidden, translated, or gated
- large lists are windowed and keyed
- failed/stale states are recoverable
- the route links back to the relevant map, building, message, or workbench
- touch targets and safe areas are acceptable for WeChat mini-app use
- `moon test` passes
- relevant build/inspect/smoke checks pass

## How Far This Gets Us

After UX0 through UX3, the app should stop feeling like a backend demo on the
main surfaces.

After UX4 through UX7, the map, buildings, books, agents, and messages should
feel like one coherent tile-town product.

After UX8 through UX10, the app should be safer to grow: diagnostics remain
available, but ordinary user space stays clean, fast, and product-oriented.
