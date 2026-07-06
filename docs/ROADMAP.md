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
- Root facade helpers expose program updates without leaking internal package
  structure.
- Tests cover a counter-style program update, pending effects, form/input event
  lowering, agent feed primitives, structured communication traces, bounded
  patches, and a static scene marker update path.
- Generic communication records now cover threads, handoffs, broadcasts, review
  requests, approvals, tool results, and recovery notices without importing a
  product-specific agent runtime.
- Scene assets now have explicit manifests, budget diagnostics, sprite-aware
  static rendering, and scene-specific marker status/selection patch helpers.

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
- Backend loading, ready, stale, failed, timeout, malformed, and cancelled
  states can be represented as small `setData` patches.
- The WeChat request adapter generator emits `wx.request` helper code from a
  contract and expects the base URL from page data, avoiding generated secrets.

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
- Marker status and selection updates can be represented as small `setData`
  patches without regenerating the whole scene.

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
- CI can fail on budget regressions once budgets are agreed.
- Diagnostics make it possible to spot size and update-payload regressions
  before opening the target mini-app IDE.

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
