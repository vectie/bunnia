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
  and empty results use ordinary copy instead of search payload details.

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
- Current implementation note: Realm map code is isolated in `realm_map.mbt`,
  ordinary Realm no longer renders the onboarding/setup HUD, the floating action
  rail is gone, and selected-place actions live inside the building drawer.

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
  modules instead of one monolithic surface file.

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
  books, agents, and watched places before the detailed ownership list.

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
  object modules for memory, workers, lifecycle, and communication. Ordinary
  communication shows message/work/review context cards instead of audit-ledger
  rows.

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
- Current implementation note: Reviewer tools are isolated in
  `reviewer_diagnostics.mbt`; ordinary `Home`, `Discover`, `Realm`,
  `Messages`, and `My` generated WXML is scanned for diagnostic classes,
  diagnostic data attributes, backend paths, payload/response keys, and
  reviewer-only copy while `pages/moontown/reviewer` remains the allowlisted
  technical surface.

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
- Current implementation note: the ordinary mini-app WXSS is split into named
  tile chunks in `visual_tiles.mbt`, with shared row, action, state, drawer,
  shell, and responsive primitives. Generated stylesheet tests now guard
  touch-action, safe-area offsets, scroll-safe page surfaces, palette breadth,
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
  `scripts/moontown_guardrails/*.txt`.

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
