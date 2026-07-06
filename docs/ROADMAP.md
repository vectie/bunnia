# Bunnia Roadmap

Bunnia should make MoonBit-authored mini-apps practical without locking product
code to one vendor. The core rule is simple:

```text
product model + Bunnia view/update code
  -> platform-neutral Bunnia tree and effects
  -> platform adapter
  -> WeChat, Alipay, TikTok, or another mini-app output
```

The first product migration target is Moontown/Wenyu. The first platform target
is WeChat Mini Program.

## Product Goal

Bunnia exists to make huge MoonBit-authored mini-apps render fast and look good.
Translation convenience matters, but it is secondary to rendering speed,
interaction responsiveness, visual quality, and predictable output size.

For Moontown/Wenyu, assume the app will be large:

- many pages and civic modules
- large state projections
- repeated lists, cards, feeds, and dashboards
- image-heavy town surfaces
- frequent status updates from backend snapshots

The framework should therefore optimize for:

- small generated page data
- stable component boundaries
- minimal `setData` payloads
- predictable list rendering
- image and asset budgets
- fast first screen
- smooth tap/scroll interactions
- clean visual output on common WeChat devices

Every active phase should preserve this goal. A feature that works only for a
tiny demo is not enough unless it also shows how it scales.

## Agentic Mini-App Goal

Bunnia is intended for agentic mini-apps. This does affect the design.
Agent chat, agent status, action traces, tool calls, review queues, and
streaming results should be first-class framework patterns.

This does not mean the framework should hardcode one agent product. It means
Bunnia should provide generic primitives that make agentic interfaces fast and
clear:

- append-friendly message lists
- keyed chat rows and event rows
- compact streaming updates
- agent presence and run-status indicators
- tool-call/result cards
- human review and approval controls
- resumable conversation state
- backend contracts for send, stream, cancel, retry, and acknowledge

Design implications:

- Chat/event feeds must avoid whole-page rerenders.
- Message lists need stable keys and update paths.
- Streaming output should batch or patch chunks instead of resetting text
  repeatedly.
- Tool results should be structured data, not opaque HTML blobs.
- Permission and review controls should be explicit in the UI model.
- Long conversations need pagination, truncation, or windowing.

The first implementation should keep these as generic framework capabilities.
Moontown can supply reference scenarios, but Bunnia's agentic primitives should
work for any large mini-app with agents.

## Agent Interaction Goal

Bunnia should support agent interaction and communication patterns inspired by
Moontown, while keeping the framework generic. This is broader than chat. Large
agentic mini-apps need to show who is talking, who owns the next action, how
work moves between agents, and what a human must approve.

Reusable communication patterns:

- agent-to-human chat
- agent-to-agent exchange
- handoff from one agent or role to another
- broadcast/status announcement
- review request and approval
- tool-result discussion
- escalation and recovery notice
- threaded conversation around a task, scene object, or artifact

Design implications:

- Communication records need stable ids, actor ids, role labels, timestamps,
  status, and optional artifact references.
- Threads should be addressable independently from pages, so a map marker,
  dashboard card, or tool result can open the same conversation.
- Agent-to-agent messages should be visible and reviewable when product policy
  allows it, not hidden in logs only.
- Handoffs and approvals should be typed events, not just text messages.
- Communication feeds need filtering and summarization so large apps do not
  drown the user in agent chatter.
- The same primitives should render as compact badges, feed rows, chat bubbles,
  trace timelines, or review cards depending on context.

Moontown can inspire fixtures and examples, but Bunnia should expose generic
communication primitives such as actor, thread, message, handoff, review,
approval, broadcast, and artifact reference.

## Stylised Map Goal

Bunnia should support stylised map-style mini-app surfaces. This also affects
the design. A large app may need to show state as a visual place: regions,
buildings, actors, flows, alerts, and overlays, not only lists and cards.

This should remain generic. Moontown can be the reference, but the framework
should model reusable scene concepts:

- scene dimensions and viewport rules
- layer ordering
- tiles, sprites, static images, and overlays
- positioned nodes and hit targets
- actor/status markers
- camera/pan/zoom or simplified viewport modes
- asset manifests and package-size budgets
- fallback rendering for low-end devices

Design implications:

- Map rendering should be a separate scene model, not ordinary nested `view`
  trees with absolute positioning hidden everywhere.
- Static map mode should come before animated canvas mode.
- Assets need explicit manifests so package size and remote loading decisions
  are visible.
- Hit targets should be represented in data, so event routing is deterministic.
- Scene updates should patch changed actors/status overlays, not rebuild the
  whole map.
- The framework should support graceful fallback when canvas, images, or motion
  are constrained.

The first map implementation should prove one static scene with selectable
regions and status overlays before adding animation or complex tilemaps.

## MoonSuite Lessons To Keep Light

A scan of sibling MoonSuite projects is useful, but Bunnia is still a mini-app
framework. The active plan should keep only the lessons that directly improve
large mini-app rendering, UX clarity, and generated-output debugging.

Keep these lightweight:

- Stable ids and small deltas for large lists, chats, scenes, and dashboards.
- Visible loading, stale, error, retry, and cancelled states.
- Reviewable risky actions, represented as ordinary UI state and typed events.
- Artifact links by id or URL, not embedded artifact payloads.
- Basic run/task status for agentic UI, not a full job runtime.
- Generated-output diagnostics for file size, initial data size, component
  count, and update payload size.
- Product-specific packs and examples outside Bunnia core.

Do not import the broader suite agenda into Bunnia core:

- no filesystem workspace model
- no agent runtime or job scheduler
- no audit-log subsystem
- no provider/model routing
- no physical-device safety system
- no product-home discovery requirement

Those concerns can appear later as downstream integrations if a real mini-app
needs them. For now, Bunnia should stay small, fast, inspectable, and easy to
generate.

## Framework Boundary

Bunnia is a dedicated mini-app framework, not a Moontown feature package.
Moontown/Wenyu is allowed as a reference product, benchmark, and proof slice,
but framework code must stay product-neutral.

Rules:

- Core Bunnia packages must not import `vectie/moontown`.
- Public Bunnia APIs must not expose Moontown-specific nouns such as mayor,
  civic building, MoonBook, MoonClaw, standing watch, Wenyu, or town module.
- Product-specific view helpers belong in examples, fixtures, or downstream
  app packages, not in framework core.
- Performance tests may use Moontown-shaped synthetic data, but the data shape
  must be generic enough to represent other large mini-apps.
- WeChat backend code may know WeChat platform details; it must not know
  Moontown business rules.

Allowed uses of Moontown:

- reference screenshots and source reading
- migration notes
- generated-output stress fixtures
- a proof app under examples or downstream workspace

Not allowed:

- framework APIs named after Moontown features
- hardcoded Wenyu layouts in core rendering
- direct Moontown runtime, daemon, filesystem, MoonBook, or MoonClaw execution
  inside Bunnia
- making Bunnia release quality depend on Moontown-only behavior

## Active Scope

Active phases:

- Phase 0: Framework Shape
- Phase 1: Core DSL And Program Model
- Phase 2: WeChat MVP Backend
- Phase 3: Moontown/Wenyu Proof Slice
- Phase 4: Runtime Effects And Backend Contract
- Phase 5: Visual Surface
- Phase 7: Tooling And Developer Workflow

Deferred phases:

- Phase 6: Alipay And TikTok Adapters
- Phase 8: Production Readiness

Deferred phases are not scheduled now. The active work should preserve the
interfaces that make them possible later.

## Phase 0: Framework Shape

Goal: define the stable boundaries before adding generators.

Deliverables:

- `Node`, `Attr`, and `EventBinding` as the shared view tree.
- `Platform` and `PlatformAdapter` as the platform capability boundary.
- `RenderPlan` as the first inspectable lowering result.
- Public API generated with `moon info`.
- A documented framework boundary that keeps Moontown reference work outside
  core APIs.

Acceptance checks:

- `moon check`
- `moon test`
- `moon info`
- A sample page can report node count, component kinds, and event messages.
- Render plans expose enough size signals to discuss page complexity early.
- `moon.mod` has no dependency on `vectie/moontown`.

Status: started.

Current evidence:

- Core tree, adapter metadata, render planning, and public facade are in place.
- `moon check`, `moon test`, and `moon info` are part of the regular validation
  loop.
- The framework boundary is documented and core packages do not import
  Moontown-specific modules.

Do not build yet:

- WXML/WXSS/JS file emission.
- Real platform API calls.
- Moontown-specific widgets.

## Phase 1: Core DSL And Program Model

Goal: make authoring feel close to Rabbita while staying mini-app native.

Deliverables:

- `Program[Model, Msg]` shape with `init`, `update`, and `view`.
- Pure command/effect model for request, navigation, storage, login, share, and
  cloud-function calls.
- Common controls: page, view, text, image, button, scroll-view, input, form,
  list, conditional, and canvas placeholders.
- Stable event message routing independent of platform event names.
- Explicit keyed list and conditional primitives so large pages can update
  without rebuilding unnecessary structure.
- Agentic UI primitives for message feeds, tool-result cards, run-status
  indicators, review controls, and append-only event traces.
- Communication primitives for actors, threads, messages, handoffs, review
  requests, approvals, broadcasts, and artifact references.
- Scene primitives for stylised maps: scene, layer, positioned node, marker,
  hit target, and asset reference.
- Lightweight records for stable ids, small deltas, artifact links, and
  agent/run status.
- Capability metadata for actions that may require review or confirmation.

Acceptance checks:

- Counter example updates through `Msg`.
- Form example produces stable state transitions without platform runtime.
- Render plan records required effects and unsupported capabilities.
- Public API reviewed through `pkg.generated.mbti`.
- A large synthetic tree can be planned without quadratic traversal behavior.
- The update model can describe small patches instead of whole-page resets.
- A chat/feed example appends a message without rerendering the whole page.
- A communication example can show a handoff or review request as structured
  data instead of plain text.
- A static scene example can update one marker/status overlay without
  regenerating the whole scene.
- Artifact links render without loading artifact contents into page data.
- Reviewable actions have visible disabled, pending, confirmed, cancelled, and
  failed states in the view model.

Current evidence:

- `Program[Model, Msg]` and `Step[Model]` provide the first pure app
  update/view boundary.
- Common controls now include `input`, `form`, `list`, and `when` in addition
  to page/view/text/image/button/scroll-view/canvas.
- Repeated surfaces can use `windowed_list` to render visible rows while
  preserving total item counts in render plans and generated manifests.
- Agent feeds and communication traces can use dedicated windowed helpers, so
  long conversations expose visible/total counts without expanding every row.
- Render plans diagnose missing and duplicate repeated-row keys, making
  list/feed/trace identity problems visible before they become large-app update
  regressions.
- Render plans and generated manifests report non-windowed repeated-row counts
  and can diagnose keyed lists, feeds, or traces that grow beyond the
  non-windowed row budget.
- Root facade helpers expose program updates without leaking internal package
  structure.
- Tests cover a counter-style program update, pending effects, form/input event
  lowering, agent feed primitives, structured communication traces, bounded
  patches, and a static scene marker update path.
- Generic communication records now cover threads, handoffs, broadcasts, review
  requests, approvals, tool results, and recovery notices without importing a
  product-specific agent runtime.
- Tool-result cards now expose tool name, run status, artifact reference, open
  actions, and acknowledgment actions as typed generic UI, including a windowed
  list helper for large agentic result feeds.
- Tool-result plans budget visible cards, pending acknowledgments, missing
  acknowledgments, and artifact references before agentic result feeds grow.
- Communication plans can filter traces by thread, actor, or communication
  kind while reporting visible/hidden rows, unresolved review pressure,
  artifact-bearing rows, and budget diagnostics.
- Agent deltas now represent append-only message, communication, streaming
  chunk, run-status, and review-state updates as bounded patch plans.
- Scene thread links connect map markers to communication threads with compact
  badges and bounded patches for selected thread, unread count, status, and new
  thread links.
- Scene thread plans report visible/total marker-thread links, unread pressure,
  orphan marker links, and missing open actions so agentic map overlays remain
  measurable before rendering.
- Scene assets now have explicit manifests, budget diagnostics, sprite-aware
  static rendering, and scene-specific marker status/selection patch helpers.
- Generic render plans now report scene count, visible/total marker count,
  scene asset count, and degraded scene count, making map pressure visible
  before adapter-specific generation.
- Render budgets can now diagnose scene marker count and degraded scene count
  directly, so strict builds can fail oversized map routes before adapter
  generation or mini-app preview.
- WeChat page/project generation can accept explicit render budgets, carrying
  route render diagnostics and the active budget limits into manifests, build
  reports, snapshots, and strict CLI gates without product-specific plumbing.
- Route initial-data bytes are checked against the page render budget, so
  agentic pages with oversized first payloads fail before mini-app preview.
- Effect plans diagnose platform capability mismatches, such as cloud-function
  effects on a target that does not advertise cloud support.
- Render plans can be produced directly from a `PlatformAdapter` and now report
  canvas usage plus unsupported canvas diagnostics for constrained targets.
- Generic surface-status badges and overlays cover loading, ready, stale,
  error, retry, cancelled, and degraded states without hardcoding a product
  widget.
- Review controls now render pending actions as active controls and resolved,
  cancelled, or failed actions as disabled controls while keeping review-state
  updates as bounded patches.

Do not build yet:

- Real WeChat `Page({...})` runtime.
- Asset packaging.
- Cross-platform compatibility promises beyond adapter metadata.

## Phase 2: WeChat MVP Backend

Goal: generate a minimal WeChat mini-program project from Bunnia output.

Deliverables:

- WeChat adapter lowering:
  - `.wxml` for structure.
  - `.wxss` for styles.
  - `.js` for page lifecycle, `setData`, and event dispatch.
  - `.json` for page configuration.
- Escaping and attribute mapping rules.
- A tiny generated project with one page and no backend dependency.
- Snapshot tests for generated WXML/JS snippets.
- A first performance budget for generated file size, initial `data`, and event
  payload shape.

Acceptance checks:

- Generated files open in WeChat DevTools.
- Tap event dispatch updates page state.
- `moon test` covers the generator output.
- No secret, app id, or backend credential is generated into frontend code.
- Generated JS uses targeted `setData` paths for simple updates.
- Generated WXML avoids avoidable wrapper depth for common controls.

Current evidence:

- WeChat projects include a build report with file count, total bytes, WXML,
  WXSS, JS, page count, initial-data, event-patch bytes, route-level
  first-screen/update payload maxima, diagnostics, and summary text.
- The WeChat generator supports multi-page projects through route-scoped page
  descriptors while preserving the one-page API for small examples.
- Generated WeChat projects include a deterministic `bunnia.manifest.json`
  with route-level node/event counts, runtime data bytes, event-patch bytes,
  first-screen/update byte estimates, windowed-list item counts, route render
  diagnostics, and generated file sizes.
- WeChat projects now emit shared `bunnia.runtime.js` and `app.wxss` files, so
  route files do not duplicate common patch helpers or default styles per page.
- WeChat projects now emit route-local `*.data.js` payload modules, so page
  runtime glue stays small while initial data and event-patch tables remain
  route-scoped and manifest-visible.
- Generated event-patch tables include only handlers reachable from a route's
  rendered events; orphan handlers remain diagnostics without being shipped in
  page payload modules.
- Generated manifests record route-level missing and orphan event-patch counts
  so large multi-page apps can locate broken wiring without scanning aggregate
  diagnostics.
- WeChat projects can optionally emit `bunnia.backend.js` from a backend
  contract, keeping agent/request integration packaged but still
  product-neutral and secret-free.
- Backend-aware WeChat page JS dispatches a contract request when the handled
  event message matches an endpoint id, so request behavior stays data-driven
  instead of product-specific.
- Backend-aware pages only embed endpoint ids reachable from that route's
  rendered events, avoiding full-contract duplication in every page JS file.
- Backend-aware projects leave routes with no matching endpoint events on the
  lightweight non-backend page JS path, even while packaging the shared backend
  adapter for other routes.
- Generated manifests record reachable backend, stream, and review endpoint
  counts per route, so agentic request pressure is attributable in large
  multi-page apps before manual preview.
- The CLI prints the render plan, project summary, build report, patch plan, and
  generated output directory.
- Tests force budget regressions for generated files, initial data, aggregate
  event patches, and route-level first-screen/update payloads.

Do not build yet:

- Full app packaging/upload automation.
- WeChat payment, login, or cloud deployment.
- Complex canvas rendering.

## Phase 3: Moontown/Wenyu Proof Slice

Goal: prove that Bunnia reduces translation work from the existing Rabbita town
surface.

Deliverables:

- A small Moontown projection DTO owned by Bunnia examples or fixtures.
- Wenyu overview page:
  - title/status header
  - three to five civic buildings
  - status badges
  - one building selection interaction
  - one operator request button
- Static JSON fixture matching the shape that Moontown can export.
- Notes on what Rabbita view patterns map cleanly and what needs redesign.
- A larger synthetic Wenyu fixture that stresses repeated building cards,
  status badges, feed rows, and dashboard metrics.
- Boundary notes that separate reusable framework gaps from Moontown-only app
  needs.

Acceptance checks:

- The proof slice is generated as a WeChat mini-program page.
- All visible data comes from a fixture/projection, not hardcoded view logic.
- The same product view still has no direct WeChat API dependency.
- The migration notes identify the next ten Moontown components to port.
- The page remains readable with large fixture data by using stable layout,
  list boundaries, and compact render payloads.
- The proof slice records rough first-screen, file-size, and update-payload
  observations from WeChat DevTools or generated-output inspection.
- Any Moontown-shaped helper is kept out of the core package namespace.

Current evidence:

- `examples/wenyu_overview` owns a Wenyu-shaped projection DTO, fixture JSON,
  view mapping, backend contract, migration notes, and large synthetic fixture.
- The proof slice generates a separate WeChat route, `pages/wenyu/index`, with
  header status, metrics, four building cards, review controls, scene markers,
  operator request patches, and communication trace rows.
- Large Wenyu fixtures use bounded building-list rendering, reporting visible
  and total building counts instead of expanding every building row into WXML.
- Wenyu map rendering uses an explicit scene viewport so large synthetic maps
  report visible/total marker counts instead of forcing all markers into first
  output.
- Tests verify the proof slice is generated from projection data, keeps updates
  and assets bounded, and leaves framework core packages product-neutral.
- `moon run cmd/main -- --example wenyu_overview` generates the proof app
  without changing source code.

Do not build yet:

- Live daemon connection.
- MoonClaw/MoonBook execution inside the mini-program.
- Full Wenyu tilemap.

## Phase 4: Runtime Effects And Backend Contract

Goal: connect mini-app UI to safe backend boundaries.

Deliverables:

- Typed request effect model.
- Backend endpoint contract for:
  - town snapshot
  - building status
  - standing-watch list
  - operator request submission
  - agent message send
  - agent run status
  - communication thread load
  - handoff submit
  - review approve/reject
  - tool result acknowledgment
- WeChat request adapter.
- Failure and loading state conventions.
- Security rule: frontend never stores app secrets or privileged service keys.
- Snapshot delta conventions so backend refreshes can update only affected
  sections of a large page.
- Streaming/delta contract for chat messages and agent status updates.
- Progress, cancellation, retry, and malformed-payload conventions for
  long-running agent operations.

Acceptance checks:

- Mock backend tests cover success, failure, timeout, and malformed payloads.
- Operator request submission is represented as data and can be replayed.
- Moontown remains the owner of daemon and worker execution.
- Refresh handling distinguishes full snapshot load from small status updates.
- Failure/loading states do not force large page rerenders.
- Chat streaming and tool-result updates can be represented as small deltas.
- Handoff and approval actions are represented as typed backend effects.
- Cancel and retry paths are represented as explicit effects rather than ad hoc
  event strings.

Current evidence:

- Backend endpoints and contracts are typed, planned, and budgeted by endpoint
  count, streaming count, and review-required count.
- Endpoint helpers cover snapshot/status loads, operator submit, agent message
  send, agent status stream, thread load, handoff submit, review decision, and
  tool-result acknowledgment.
- Backend contracts can derive request/stream effect plans, so examples avoid
  duplicating endpoint intent when profiling runtime pressure.
- Build profiles aggregate backend endpoint, streaming, and review-required
  counts so backend pressure is visible beside frontend payload budgets.
- Backend loading, ready, stale, failed, timeout, malformed, and cancelled
  states can be represented as small `setData` patches.
- Replayable backend requests and backend results are typed as data, with
  helpers that lower success, failure, timeout, malformed, and cancelled
  results to bounded patch arrays.
- Chat, communication trace, streaming chunk, review, and run-status updates can
  be represented as typed agent deltas that reuse patch budgets.
- In-flight streaming chunks can be updated through `SetStreamChunk` deltas, and
  agent delta plans flag duplicate appended stream chunks before feeds grow
  accidentally.
- Build profiles now report agent-delta count and duplicate streaming chunk
  pressure so agentic update costs are visible in the same CLI summary as
  render, backend, and scene budgets.
- Generic snapshot deltas can set sections, append stable-id items, remove
  sections, or explicitly flag full-snapshot replacement while reusing patch
  budgets.
- Build profiles now report snapshot delta count, section update count, append
  count, and full-snapshot replacements so backend refresh pressure is visible
  beside render, agent, and scene budgets.
- Long chat and communication surfaces can render bounded visible windows while
  keeping append-friendly patch targets for additional messages or trace rows.
- The WeChat request adapter generator emits `wx.request` helper code from a
  contract and expects the base URL from page data, avoiding generated secrets.
- The generated WeChat request helper stores request payloads and replay keys,
  distinguishes timeout and malformed responses, and exposes retry/cancel
  helpers without forcing a full page rerender.
- Backend-aware generated projects package that request helper as
  `bunnia.backend.js`, so agentic examples carry their contract-derived
  request boundary without embedding Moontown-specific execution logic.
- Matching endpoint events now call the generated request helper after bounded
  local patches, preserving replay/loading state without full-page rerenders.
- Per-page request dispatch maps are filtered by reachable event messages, so
  multi-page agentic apps do not copy unrelated endpoint ids into each route.
- First-screen byte estimates include the backend adapter only for routes whose
  generated page JS actually requires it.
- Generated WeChat event patches preserve `set`, `append`, and `remove`
  operation kinds, so agent deltas can append feed rows or stream chunks
  without replacing the whole collection.
- WeChat build reports diagnose view events without runtime patch handlers and
  runtime patch handlers without reachable view events, so strict builds catch
  broken tap/update wiring before opening the mini-app IDE.
- Effect plans can be checked against platform adapter capabilities before a
  generator is selected, preserving the future Alipay/TikTok boundary without
  implementing those adapters now.
- Stream effects can be checked against custom adapter capability, so agentic
  runtimes fail with explicit diagnostics on request-only targets.

Do not build yet:

- Direct local filesystem access from mini-app code.
- Long-running worker execution in the client.
- Vendor-specific backend lock-in unless hidden behind Bunnia effects.

## Phase 5: Visual Surface

Goal: bring enough Wenyu visual richness without overloading the mini-app.

Deliverables:

- Asset manifest model.
- Image and sprite conventions for mini-app packaging.
- Canvas adapter design for interactive map surfaces.
- Lightweight map mode for older phones.
- Performance budget for startup, package size, and render updates.
- Visual quality checklist for typography, spacing, card density, status colors,
  image sharpness, and scroll behavior.
- Scene model for map layers, positioned objects, status overlays, and hit
  targets.
- Static scene renderer before canvas animation.

Current evidence:

- Static scenes support layers, positioned markers, sprite/image asset
  references, and generated WeChat sprite markup.
- Scene asset plans report asset count, package bytes, remote asset count, and
  budget diagnostics.
- Scene asset plans identify bundled assets that should be deferred when
  package-byte budgets are exceeded, keeping asset pressure visible before
  generator packaging grows.
- Scene asset policies can flag remote map assets that are insecure or outside
  approved domains, so package-splitting decisions remain deployable on
  mini-app platforms.
- Generated WeChat manifests expose route-scoped scene asset references and an
  app-level scene asset list, so asset/package pressure is reviewable from
  generated output without coupling the adapter to scene internals.
- Marker status and selection updates can be represented as small `setData`
  patches without regenerating the whole scene.
- Scene render plans report mode, quality level, layer count, marker count,
  visible/total marker count, asset count, and diagnostics for large map-like
  surfaces.
- Budgeted static scene rendering can cap visible markers and mark degraded
  output with stable data attributes, leaving room for a later canvas surface
  without forcing product code to change shape.
- Viewported static scene rendering filters markers spatially and emits
  viewport plus visible/total marker data attributes for map-heavy pages.
- Scene camera plans make pan/zoom state explicit, clamp camera viewports to
  scene bounds, and expose small camera-position/zoom patch helpers.
- Scene visual quality plans check scene size, marker status, tap targets,
  marker asset references, unresolved assets, degraded output, and underlying
  render/asset diagnostics.
- Scene markers expose explicit hit-target dimensions in generated markup, and
  visual quality plans flag tappable markers whose hit area is too small for
  reliable mobile interaction.
- Generic status overlays can wrap scene, list, dashboard, or feed surfaces so
  stale, error, retry, cancelled, and degraded states remain visible without
  rebuilding the underlying surface model.
- Static scenes can render windowed communication-thread badges beside map
  markers, preserving visible/total counts and cheap patches for map-heavy
  agentic UIs.
- Scene thread plans make agentic map overlays budgeted, including unread
  pressure and orphan-link diagnostics when a thread points at a missing marker.
- Scene surface plans make static, canvas, and lightweight rendering intent
  explicit and report fallback when a platform cannot honor the requested mode.

Acceptance checks:

- Static building map works before canvas animation.
- Canvas prototype is measured on real WeChat preview devices.
- Large assets can be split or remotely loaded through approved domains.
- UI remains usable if animation is disabled.
- First-screen rendering has a documented budget and measured result.
- The visual surface degrades cleanly when assets are delayed or omitted.
- Selecting a scene region dispatches a stable event.
- Updating one actor or overlay has a bounded patch payload.
- Stale, error, or degraded data can be shown as generic overlays/badges on
  list, dashboard, and scene surfaces.

Do not build yet:

- Full desktop-equivalent Rabbita viewport.
- Heavy runtime simulation in the mini-program.

## Phase 6: Alipay And TikTok Adapters

Status: deferred.

Goal: validate that Bunnia's modular split is real when there is a reason to
target a second mini-app ecosystem.

Deliverables:

- Adapter capability matrix for WeChat, Alipay, and TikTok.
- Alipay lowering for the Phase 2 sample.
- TikTok lowering for the Phase 2 sample.
- Platform-specific event, component, lifecycle, and request mappings.
- Tests that compare render plans across platforms.

Acceptance checks:

- The same MoonBit view can generate at least two platform outputs.
- Unsupported platform features fail as explicit diagnostics.
- Product code does not import vendor-specific APIs directly.

Leave room now:

- Keep platform facts in `PlatformAdapter`.
- Keep product views platform-neutral.
- Keep WeChat-specific lowering behind a backend module.

Do not build now:

- Alipay or TikTok generated output.
- Deep vendor features before the common adapter model is stable.
- Automatic parity claims for every component.

## Phase 7: Tooling And Developer Workflow

Goal: make Bunnia usable by normal project contributors.

Deliverables:

- `bunnia init` project scaffold.
- `bunnia build --target wechat`.
- Watch mode for generated output.
- Example app directory.
- Documentation for component mapping and platform limits.
- CI commands for check, test, format, info, and generator snapshots.
- Size and render-budget reporting in build output.
- Developer diagnostics for generated data size, update payload size,
  unsupported capabilities, and deferred assets.

Acceptance checks:

- A new contributor can generate the sample app from a clean checkout.
- Generated output is deterministic.
- Roadmap examples stay tested.
- Build output reports page count, component count, generated file sizes, and
  initial data size.
- Build output reports missing/orphan event patch counts so interaction wiring
  regressions are visible before manual preview.
- CI can fail on budget regressions once budgets are agreed.
- Diagnostics make it possible to spot size and update-payload regressions
  before opening the target mini-app IDE.

Current evidence:

- `moon run cmd/main` writes the sample WeChat project and reports render,
  page-count, file-size, initial-data, event-patch, and patch-plan summaries.
- Build output includes a deterministic generated-file manifest, so route and
  first-screen/update pressure can be inspected before opening the target
  mini-app IDE.
- Generated project output splits shared patch-runtime helpers and default
  styles into app-level files, while first-screen reports still include those
  shared startup bytes.
- Generated project output splits route payload modules from page JS, making
  payload growth and route-level checksums visible in manifests and snapshots.
- Generated event-patch byte budgets now reflect reachable route handlers, so
  dead/orphan patch entries do not inflate update-payload estimates.
- Generated manifests expose missing/orphan event-patch counts per route, so
  interaction wiring regressions are attributable before manual preview.
- Generated manifests expose route-level diagnostics for render, initial-data
  payload, and event-patch wiring issues, so generated projects remain
  debuggable without scanning aggregate CLI output.
- Generated manifests expose app-level diagnostic counts plus per-route
  diagnostic counts and route status, so large multi-route apps can rank risky
  routes before opening the target mini-app IDE.
- Project inspection reports identify the highest-risk route from manifest
  diagnostics, first-screen bytes, update payloads, node/event counts, and
  scene marker pressure, so huge apps can choose the next page to optimize
  without opening every generated file.
- Project inspection reports also expose max scene asset and remote scene asset
  pressure across routes, so map-heavy generated output can be triaged before
  opening every route manifest.
- Named inspection gates fail strict builds when route risk, scene asset
  pressure, or remote scene asset pressure exceed the selected budget profile.
- Build profiles derive route diagnostics from generated manifests, keeping
  strict-build output aligned with the inspected mini-program artifact instead
  of rebuilding route checks in a separate tooling path.
- Build profiles and generator snapshots carry manifest-derived route
  diagnostic route/count fields, so CI artifacts can identify route pressure
  without re-parsing every diagnostic line.
- Generator snapshots carry the same highest-risk route and per-route
  inspection lines as the `inspect` command, so route-risk changes become
  reviewable CI artifacts without committing full generated output.
- Generator snapshots also carry inspection gate summaries and diagnostics, so
  strict route-pressure failures are reviewable from the deterministic snapshot
  artifact.
- Backend-aware example builds include a manifest-visible backend adapter file,
  so contract integration is inspectable in normal generated output.
- Generated manifests expose route-level backend event, stream, and review
  counts so agentic request pressure is visible beside route payload budgets.
- Generated manifests expose route-level scene count, visible/total marker
  count, scene asset count, degraded scene count, and render-budget limits so
  map-heavy routes are attributable beside payload and backend budgets.
- Render budgets gate route scene asset references directly, keeping map-heavy
  package pressure visible in strict builds even before separate scene asset
  planning is wired into an example.
- Generated manifests include route-scoped scene asset ids, kinds, sources, and
  remote flags, and `inspect` prints those refs beside the owning route.
- Generator snapshots carry manifest-derived scene asset counts plus
  route-scoped scene asset ids, kinds, sources, and remote flags, so map-heavy
  package and CDN pressure is reviewable in CI artifacts.
- Build reports and profiles surface route initial-data render-budget
  diagnostics, keeping large agent/chat payloads visible beside generated-size
  budgets.
- WeChat build reports are deterministic and tested through the public
  `@bunnia` facade.
- Build profiles aggregate render, WeChat, patch, effect, backend, scene asset,
  scene render, and scene visual-quality diagnostics into one CLI-visible
  summary for generated examples.
- Example build profiles feed backend-derived effect plans into that summary,
  so request and stream pressure is visible in normal CLI output.
- Backend stream/review counts are included in profile summaries, keeping
  agent-operation review pressure visible during strict builds.
- Effect capability diagnostics include custom stream support, so strict builds
  can catch unsupported agent streaming before target-specific generation.
- Build profiles and generated manifests expose unkeyed/duplicate repeated-row
  counts alongside page, list, route first-screen, update-payload, and
  generated-size signals.
- Build profiles and generated manifests expose non-windowed repeated-row
  counts, so large keyed lists can still be flagged when they should become
  windowed surfaces.
- Build profiles expose scene surface mode counts and fallback counts so
  canvas/static/lightweight map decisions are visible in normal CLI output.
- Build profiles expose remote, insecure-remote, unapproved-remote, and
  deferred scene asset counts so package-splitting or remote-loading work is
  driven by measured deployability pressure.
- Build profiles also expose generated scene asset and generated remote scene
  asset counts from the WeChat manifest, so strict builds can compare planned
  package pressure with the route assets emitted by the generator.
- Build profiles expose agent-delta counts and duplicate streaming chunk
  diagnostics so large agentic feeds are measured during normal builds.
- Build profiles expose communication visible/total counts, unresolved review
  pressure, artifact references, and communication diagnostics so agent-heavy
  pages are measurable from the CLI.
- Build profiles expose tool-result visible/total counts, pending/missing
  acknowledgment pressure, artifact references, and tool-result diagnostics.
- Build profiles expose scene-thread link counts, unread totals, and orphan-link
  diagnostics so map-heavy agentic overlays are measured during normal builds.
- Build profiles expose scene camera counts and clamped-camera diagnostics so
  map pan/zoom issues are visible during strict builds.
- Build profiles expose snapshot-delta counts and full-replacement diagnostics
  so backend refresh regressions can be caught without opening the mini-app IDE.
- The CLI prints build-profile summaries for both `agent_map` and
  `wenyu_overview`, including backend endpoint count, scene marker pressure,
  scene asset count, package-byte signals, visual-quality issue count, and
  degraded-scene count.
- The CLI accepts build-style usage, `build --target wechat`, keeps generated
  output target-scoped, and supports `--strict` / `--fail-on-diagnostics` for
  CI-style budget gates.
- The CLI accepts named generated-output budgets, including `--budget tight`
  for stricter CI size gates and `--budget tiny` for failure-path smoke tests.
- The CLI accepts named render budgets through `--render-budget`, defaulting to
  the selected generated-output budget profile so strict builds can gate route
  render pressure and generated bytes together.
- Named budget profiles are owned by the tooling API and consumed by the CLI,
  so scaffolds, CI helpers, and later adapters can share the same gates without
  copying command-line constants.
- Build and snapshot output record the selected output and render budget
  profiles, keeping strict CI artifacts traceable to the gates that produced
  them.
- `moon run cmd/main -- ci-plan` prints the active check, test, interface,
  format, platform-limits, route-inspect, strict-build, and generator-snapshot
  commands with the default tight generated-output and render budgets, so
  contributors can inspect the workflow without reading shell docs.
- CI plans diagnose unsupported targets and unknown generated-output or render
  budget profile names, so workflow mistakes are visible before a contributor
  copies a bad strict-build command.
- CI plans print the selected inspection-gate thresholds for route risk, scene
  assets, and remote scene assets, so strict map-heavy and agent-heavy route
  checks are visible before the commands run.
- `moon run cmd/main -- limits` prints platform component mapping, tap-event
  mapping, canvas/cloud/stream capabilities, and generator availability, keeping
  WeChat target limits visible while Alipay/TikTok generators stay deferred.
- `moon run cmd/main -- watch` writes the selected WeChat example once, then
  watches source/docs/package files and reruns the deterministic build command
  on changes; `--once` keeps the same path testable without a long-running
  process.
- `moon run cmd/main -- snapshot` writes a compact deterministic generator
  snapshot with route, budget, route risk, route diagnostics, scene asset
  references, profile, and per-file byte/checksum lines for CI diffing without
  committing full generated mini-program outputs.
- Snapshot artifacts record the active build report from the selected
  generated-output budget profile, including route, report, and profile
  diagnostic lines for CI diffs.
- `moon run cmd/main -- inspect` reuses the build/profile/snapshot pipeline to
  print project inspection, highest-risk route, route-level first-screen,
  update-payload, scene-marker, diagnostic, and per-file byte/checksum lines
  without writing generated output.
- `bunnia init`-style scaffolding is available through `moon run cmd/main --
  init`, generating a small standalone MoonBit package with Bunnia view,
  windowed agentic message feed, static scene map, surface status overlay,
  render-plan helper, scene render-plan helper, agent patch helper, and scene
  patch starter files, plus a local `moon.work` link for development before
  registry publication.

## Phase 8: Production Readiness

Status: deferred.

Goal: make the WeChat path suitable for a real China-market pilot after the
framework and product proof slice are useful.

Deliverables:

- App review checklist.
- Privacy and data-minimization checklist.
- Domain and backend deployment checklist.
- Logging and crash-report strategy.
- Localization and content policy pass.
- Release build profile.

Acceptance checks:

- No secrets in frontend bundles.
- All network domains are declared and approved.
- User data collection is documented and minimal.
- The Moontown backend has explicit audit logs for submitted requests.

Leave room now:

- Keep security-sensitive operations in backend contracts.
- Keep frontend output free of app secrets and privileged keys.
- Keep generated files deterministic so release review is auditable later.

Do not build now:

- App-store review workflow.
- Release packaging automation.
- Compliance documentation beyond notes needed to avoid bad architecture.

## Near-Term Milestone

The next concrete milestone is:

```text
M1: Generate a one-page WeChat mini-program from a Bunnia MoonBit view.
```

M1 is done when:

- `@bunnia.page([...])` can lower to WXML/WXSS/JS/JSON.
- The generated page opens in WeChat DevTools.
- One tap event updates a counter or selected-building state.
- `moon test` verifies the generated output.
- The generated output includes basic size metrics.
- The event update uses a targeted `setData` payload.

This milestone is intentionally small. It proves the core architecture before
we spend time on Wenyu visuals, backend effects, or multi-platform output, but
it must already point toward fast rendering for a large app.
