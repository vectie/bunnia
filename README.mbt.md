# vectie/bunnia

Bunnia is a MoonBit mini-app UI framework experiment with Rabbita-style
authoring and modular platform adapters.

The main goal is fast, high-quality rendering for large mini-apps. Translation
from Rabbita/Moontown should be easier, but rendering speed, visual quality, and
predictable generated output size are the priorities.

Bunnia is also intended for agentic mini-apps. Agent chat, action traces,
streaming status, and reviewable tool results should be first-class UI patterns,
not bolted-on product widgets.

Agent interaction and communication should also be first-class: agent-to-human,
agent-to-agent, handoff, review, and broadcast patterns should have reusable
framework support inspired by Moontown, without importing Moontown concepts into
core APIs.

Bunnia should also support stylised map-style surfaces for large stateful apps:
scene layers, positioned actors, status overlays, and asset-budgeted rendering
should be framework patterns rather than one-off product code.

Bunnia should keep a few MoonSuite lessons in mind without becoming a heavy
suite platform: stable ids, small deltas, visible loading/error status,
reviewable risky actions, artifact links, and generated-output diagnostics.

The first target is WeChat Mini Program, but the core tree model is platform
neutral so Alipay and TikTok adapters can be added without rewriting product
views.

Bunnia is a dedicated framework. Moontown/Wenyu can be used as a reference app
and stress test, but Moontown product concepts must not be mixed into Bunnia's
core framework APIs.

See [docs/ROADMAP.md](/Users/kq/Workspace/moonmini/docs/ROADMAP.md) for the
phase-by-phase implementation plan.

See [docs/MOONTOWN_MINIAPP_PLAN.md](/Users/kq/Workspace/moonmini/docs/MOONTOWN_MINIAPP_PLAN.md)
for the Moontown product/backend dogfood plan, including user login,
building ownership, publication, search, books, and agent interaction.

## Package Shape

- `core`: platform-neutral tree, events, adapters, render planning, and generic
  surface-status badges/overlays for loading, stale, error, retry, cancelled,
  and degraded states.
- `program`: pure `Program[Model, Msg]` update/view boundary with pending
  effects and patch plans.
- `agent`: lightweight message, review, artifact-link, run-status, and
  communication planning primitives, plus generic communication threads and
  traces.
- `scene`: static stylised map model with layers, selectable regions, markers,
  asset manifests, hit targets, thread-link plans, and bounded updates.
- `effects`: typed frontend effect descriptions, platform support planning,
  snapshot-delta planning, cancel/retry helpers, and backend contract paths.
- `adapters/wechat`: WeChat Mini Program output generation.
- `tooling`: build-profile diagnostics that aggregate render, WeChat, patch,
  backend, snapshot-delta, agent-delta, asset, and scene budget signals.
- `examples/agent_map`: small downstream example combining agentic UI, review
  controls, patches, and a static map surface.
- `examples/wenyu_overview`: product-shaped proof slice that keeps Wenyu
  projection/view code outside the framework core.
- `examples/moontown_miniapp`: product-shaped Moontown mini-app vertical slice
  with full-screen map, building search/place flows, agent chat, mock local
  backend contracts, and create-building/create-agent controls outside core.
- root package: small `@bunnia` facade for app authors.

## Generate The Demo

Print the CLI command map without writing generated output:

```bash
moon run cmd/main -- help
```

Unknown positional commands fail before the generator writes files, so command
typos do not accidentally produce stale output.

```bash
moon run cmd/main
```

This writes a WeChat Mini Program file set to
`_build/bunnia/wechat/agent_map`. The default demo includes initial page data plus
event-to-patch dispatch for review buttons, map regions, and map markers. The command also
prints render, file-size, initial-data, event-patch byte/operation, patch,
agent-delta, and build-profile budget summaries. Use `--out` to choose another
directory:

```bash
moon run cmd/main -- --out /tmp/bunnia-agent-map
```

The Moontown mini-app slice uses the same build path:

```bash
moon run cmd/main -- build --target wechat --example moontown_miniapp --strict --budget large --render-budget large
moon run cmd/main -- inspect --target wechat --example moontown_miniapp --budget large --render-budget large
```

The same generator also accepts explicit build-style arguments:

```bash
moon run cmd/main -- build --target wechat --strict
```

`--strict` fails the command when render, generated-file, patch, effect,
build-profile, or inspection-gate diagnostics are present.
Use `--budget tight` for a stricter generated-output gate, or `--budget tiny`
when testing that CI fails on size and route-pressure regressions:

```bash
moon run cmd/main -- build --target wechat --strict --budget tight
```

The render planner uses the same named profile by default. Use
`--render-budget tiny` to exercise render-budget failures without shrinking
generated-output byte budgets. Named budget profiles are exposed through
`@bunnia.render_budget_for_profile(...)` and
`@bunnia.wechat_build_budget_for_profile(...)`; route-risk and update-payload
gates are exposed through `@bunnia.inspection_budget_for_profile(...)`, and
aggregate large-app profile gates are exposed through
`@bunnia.build_profile_budget_for_profile(...)`, including generated-route
diagnostic, repeated-list identity, unresolved-review, tool-result
acknowledgment, and scene asset deployability limits, so contributors can use
the same gates outside the CLI.

For local iteration, watch generated output with:

```bash
moon run cmd/main -- watch --target wechat --example agent_map --strict
```

Use `--once` with `watch` to run the same generation path once in CI or smoke
tests without starting a long-running file watcher.

For deterministic generator review in CI, write a compact generated-output
snapshot without writing the full generated mini-program directory:

```bash
moon run cmd/main -- snapshot --target wechat --example agent_map --strict
```

Snapshot output records the selected `--budget` profile, so CI diffs include
the same generated-output report and diagnostic lines that strict builds
evaluate. If `--render-budget` is set separately, snapshots record that profile
too. Snapshots also include route-scoped manifest diagnostics, so a CI diff can
point directly at the generated page that owns a render, payload, or interaction
issue. The same snapshot records route diagnostic counts, making route pressure
visible even before reading the diagnostic lines. Snapshots also record the
profile-gate and inspection-gate summaries and diagnostics, highest-risk route,
and per-route inspection lines, so CI diffs can show which page should be
optimized first and which strict route/profile-pressure gate fired.

The snapshot records route, budget profile, size budgets, profile summary,
profile-gate summary, per-route risk, route-scoped scene asset references,
estimated scene asset bytes, and per-file byte/checksum lines without
committing the full generated mini-program.

To inspect route and file pressure without writing generated files:

```bash
moon run cmd/main -- inspect --target wechat --example agent_map --budget tight --render-budget tight
```

`inspect` prints the same render, manifest, report, patch, profile, and
snapshot summaries as the build path, then adds a project inspection summary,
the highest-risk route, max scene marker/asset/package pressure, one
route-inspection line per generated page, one `route=...` manifest line per
generated page, route-scoped `scene_asset=...` lines, and one `file=...` line
per generated artifact. This is intended for quick checks of first-screen
bytes, update payloads, update operation fanout, scene marker and asset
pressure, packaged scene bytes, diagnostic counts, file kinds, file bytes, and
checksums before opening WeChat DevTools.

To inspect component mapping and platform capability limits:

```bash
moon run cmd/main -- limits --target wechat
```

`limits` prints the active platform adapter's component mappings, tap-event
mapping, canvas/cloud/stream capabilities, and explicit generator status. The
status is `available` for WeChat plus the generic Alipay/TikTok generators, and
`unknown` for unsupported target ids.
The same target-support model is reused by `ci-plan` and build-style commands,
so unknown targets fail before artifacts are generated. Alipay and TikTok can
write generic mini-app projects through `build`, including a deterministic
`bunnia.manifest.json` route/file inventory plus named budget gates for
cross-platform diagnostics; inspect, snapshot, and watch remain WeChat-only
until their reporting diagnostics match the WeChat path.

To print the canonical local/CI workflow for the tight proof examples:

```bash
moon run cmd/main -- ci-plan
moon run cmd/main -- ci-plan --script
sh scripts/scaffold_smoke.sh
sh scripts/ci.sh
```

For the product-shaped Moontown route, use the explicit large-app lane:

```bash
moon run cmd/main -- ci-plan --example moontown_miniapp --budget large --render-budget large
```

The repository GitHub Actions workflow in `.github/workflows/ci.yml` generates
the same CI plan through `scripts/ci.sh`, so local and hosted CI use the same
command list. To run that same gate before each commit, configure the included
hook once with `git config core.hooksPath .githooks`.

`ci-plan` defaults to the `tight` generated-output and render budgets and lists
the check, test, interface, format, framework-boundary, platform-limits, route
inspection, strict build, one-shot watch generation, snapshot, and
scaffold-smoke commands that
contributors should run before review. The public `@bunnia.ci_plan()` default
stays product-neutral; the root CLI explicitly includes the Wenyu proof slice
as an example stress test. Pass `--render-budget` to make render pressure
stricter or looser than generated file-size gates. Unknown budget profile names
and unsupported targets are printed as CI-plan diagnostics before contributors
copy the generated commands. The CI plan also prints the inspection-gate and
profile-gate thresholds derived from the selected budget profile, including
route-risk, update-operation ceilings, backend pressure, scene-asset ceilings,
packaged scene-byte ceilings, duplicate stream chunks, full snapshot
replacements, scene thread orphans, clamped cameras, surface fallbacks,
visual-quality issues, and degraded scenes. That makes strict map-heavy and
agent-heavy checks reviewable before the commands run. Build, inspect, and
snapshot output also include a release-readiness line that aggregates manifest
coverage, frontend secret checks, backend audit hooks, remote scene-asset policy,
and the profile/inspection gates into a pilot preflight status. Add `--script` to emit a
deterministic `sh` script from the same plan; invalid plans print diagnostics
and exit before running generated commands.

The WeChat generator also supports multi-page projects through
`@bunnia.wechat_project_page(...)` and
`@bunnia.generate_wechat_project_from_pages(...)`. Build reports include page
count, generated file sizes, initial data bytes, event patch bytes, event patch
operation count, and route-level first-screen/update payload and update
operation budgets so large apps can catch growth early.

Generated WeChat projects include `bunnia.manifest.json`, a deterministic route
and file manifest with per-page node/event counts, runtime data bytes, patch
bytes, update operation counts, generated file sizes, first-screen/update byte
estimates, and route-scoped render diagnostics. Generic Alipay/TikTok projects
also include `bunnia.manifest.json` with platform id, route/file inventory, page
node/event counts, scene counts, diagnostics, and generated byte totals.
Generated manifests also include route-scoped scene asset references, estimated
packaged scene bytes, remote scene asset counts, and an app-level `sceneAssets`
list derived from neutral `data-asset-*` attributes, so map-heavy pages can
review packaged and remote asset usage without importing scene-specific code in
the WeChat adapter.
Generated projects also include shared `bunnia.runtime.js` and `app.wxss`
files plus route-local `*.data.js` payload modules, so page files keep only
route structure and runtime glue instead of duplicating helpers, default
styles, initial data, and event-patch tables per route.
Generated event-patch tables include only messages reachable from that route's
rendered events; orphan handlers stay visible as diagnostics instead of being
serialized into page payloads.
The manifest records missing and orphan event-patch counts per route, so large
apps can locate broken interaction wiring without scanning aggregate logs.
Route manifests also include a `diagnostics` array for render, payload, and
interaction issues attributable to that page, plus per-route and app-level
diagnostic counts/status fields so large apps can rank problematic routes
without parsing every diagnostic string.
`@bunnia.inspect_wechat_project(...)` and the `inspect` command use those
signals to identify the top route by diagnostic and payload/render pressure.
Backend-aware manifests also record reachable backend, stream, and review
endpoint counts per route, making agentic request pressure attributable before
opening the mini-app IDE.
Projects generated with a backend contract also include `bunnia.backend.js`, a
contract-derived `wx.request` adapter that keeps base URLs in page data and
does not generate app secrets. Backend-aware pages call that adapter when a
handled event message matches a backend endpoint id, and each page only carries
the endpoint ids reachable from its own rendered events. Pages with no matching
endpoint events keep the normal lightweight page runtime even inside a
backend-aware project.

For large repeated surfaces, use `@bunnia.windowed_list(...)` with the visible
rows and the full `total_count`. Render plans and generated manifests report
`windowed_lists` plus visible/total item counts, which keeps first output
bounded while preserving scale diagnostics.
Render plans also report `unwindowed_list_children` and can diagnose
`unwindowed-list-children-over-budget` when a keyed list, feed, or trace grows
too large without windowing.

For large agentic traces, use `@bunnia.plan_communications(...)` or
`@bunnia.plan_filtered_communications(...)` before rendering. Communication
plans report visible/total rows, unresolved review pressure, artifact-bearing
rows, and budget diagnostics; build profiles aggregate those signals in the
normal CLI summary. Build profiles also carry route diagnostic route/count
fields from the generated manifest so large apps can rank problematic routes
from tooling output.

For long agent conversations, use `@bunnia.windowed_message_feed(...)` and
`@bunnia.windowed_communication_trace(...)` so chat rows and action traces keep
the same visible/total diagnostics as other large surfaces.
For tool outputs, use `@bunnia.tool_result_card(...)` with
`@bunnia.tool_result_card_view(...)` or
`@bunnia.windowed_tool_result_card_list(...)` so artifact references,
run-status, open actions, and acknowledgments remain typed UI state.
Use `@bunnia.plan_tool_result_cards(...)` before profiling large agentic
surfaces so visible result cards, pending acknowledgments, missing
acknowledgments, and artifact references show up in build-profile diagnostics.
For streaming output, append completed chunks with
`@bunnia.append_stream_chunk_delta(...)` and update the current in-flight chunk
with `@bunnia.set_stream_chunk_delta(...)`; agent delta plans flag duplicate
appended stream chunks.

Render plans also report `unkeyed_list_children` and
`duplicate_list_keys`. Keep repeated rows uniquely keyed so large lists, feeds,
and traces can update predictably.
Render plans also count canvas nodes and can be planned against a custom
`PlatformAdapter`, so unsupported canvas capability is visible before choosing a
generator.
Effect plans can also be checked against a custom `PlatformAdapter`, so
streaming agent operations fail as explicit diagnostics when a target runtime
cannot support them.
Generic mini-app pages can be lowered for Alipay and TikTok from the same
platform-neutral view while the CLI target gate remains conservative:

```bash
moon run cmd/main -- build --target alipay --example agent_map --strict
moon run cmd/main -- build --target tiktok --example agent_map --strict
```

```mbt check
///|
test {
  let root = @bunnia.page([@bunnia.button("Open", "open-detail")])
  let alipay = @bunnia.generate_alipay_project(name="Adapter", root~)
  let tiktok = @bunnia.generate_tiktok_project(name="Adapter", root~)
  assert_true(alipay.files[2].path.has_suffix(".axml"))
  assert_true(tiktok.files[2].path.has_suffix(".ttml"))
  assert_eq(alipay.page.plan.node_count, tiktok.page.plan.node_count)
}
```
Use `@bunnia.platform_limits(...)` or
`@bunnia.platform_limits_for_adapter(...)` to inspect component mapping,
tap-event mapping, and target capabilities from the same adapter boundary before
choosing a generator.

```mbt check
///|
test {
  let limits = @bunnia.platform_limits(target="wechat")
  assert_eq(limits.generator_status_id, "available")
  assert_eq(limits.generator_available, true)
  assert_eq(limits.event_mappings[0].platform_event, "bindtap")
  assert_true(limits.summary.contains("components=9"))
  let alipay = @bunnia.platform_limits(target="alipay")
  assert_eq(alipay.generator_status_id, "available")
  assert_eq(alipay.event_mappings[0].platform_event, "onTap")
}
```

For map-heavy surfaces, use `@bunnia.static_scene_view_with_viewport(...)` and
`@bunnia.plan_scene_render_viewport(...)`. Scene plans and build profiles report
visible/total marker and region counts so large maps can stay spatially bounded.
Viewported scene views keep full scene dimensions as data while rendering a
viewport-sized surface with viewport-local marker, region, and overlay
coordinates, so first-screen layout does not inherit the whole map size.
Generic render plans and generated route manifests also report scene count,
visible/total marker count, visible/total region count, scene asset count, and
degraded scene count, so map
pressure is visible even before product-specific profiling is wired in. Route
manifests include the render-budget limits used for generation, which keeps
budget failures explainable from generated output alone.
`@bunnia.render_budget(...)` can gate visible scene marker count, visible scene
region count, scene asset reference count, and degraded scene count directly,
which lets strict builds catch oversized first-screen map routes without
penalizing offscreen world size. WeChat generation APIs also accept explicit
render budgets, so route manifests and build reports carry those render
diagnostics into normal build output. For agentic pages, route initial-data
bytes are also checked against the page render budget.
Use `@bunnia.scene_camera(...)` with
`@bunnia.static_scene_view_with_camera(...)` when pan/zoom state should be
explicit, clamped to scene bounds, and updated through small camera patches.

For agentic map surfaces, use `@bunnia.scene_marker_thread_link(...)`,
`@bunnia.scene_region_thread_link(...)`, or the generic
`@bunnia.scene_thread_link(...)` plus `@bunnia.plan_scene_threads(...)` to keep
scene-subject badges measurable. Scene thread plans report visible/total links,
unread pressure, orphan marker/region links, and missing open actions before
the mini-app output grows. Scene-aware overlays derive badge anchors from
marker centers or region centers, so agent communication stays attached to the
map without product-specific positioning code. Use the viewport-aware anchored
overlay and planner helpers when a large map is cameraed or clipped; they keep
total thread counts visible while budgeting and rendering only badges inside
the active viewport.
Use `@bunnia.plan_scene_surface_for_platform(...)` to make the intended
static/canvas/lightweight surface mode and any fallback explicit in build
profiles before adding platform-specific rendering.
Use `@bunnia.plan_scene_visual_quality(...)` for a checklist covering scene
size, marker status, tap targets, asset references, unresolved assets, and
degraded output. Use `@bunnia.plan_scene_visual_quality_viewport(...)` for
cameraed or clipped maps; it checks the viewport-sized rendered surface and
visible objects while the embedded render plan still reports total/visible
world geometry.
Use `@bunnia.plan_scene_assets_with_budget(...)` to identify bundled scene
assets that should be deferred or moved remote when package-byte budgets are
tight. Use `@bunnia.plan_scene_assets_with_budget_and_policy(...)` when remote
assets must stay on approved domains; build profiles report remote,
unapproved-remote, insecure-remote, and deferred asset counts.
Build profiles also report generated scene asset counts derived from the
WeChat manifest, so strict builds can compare planned package pressure with
the actual route asset references emitted by the mini-app generator.
Markers carry stable `data-hit-width` and `data-hit-height` attributes, and
visual quality plans flag tappable markers with hit targets below the configured
minimum so map interactions stay usable on mobile.

Use `@bunnia.surface_status_badge(...)` and
`@bunnia.surface_status_overlay(...)` for loading, stale, error, retry,
cancelled, or degraded state that should be visible without replacing the
underlying list, dashboard, feed, or scene model.

For backend refreshes, use `@bunnia.plan_snapshot_deltas(...)` to turn section
updates, append-only items, and removals into bounded patches. Full snapshot
replacement is still representable for bootstrap paths, but plans flag it.
Build profiles report snapshot delta counts, section updates, append pressure,
and full replacements so large mini-apps do not accidentally refresh whole
pages.
WeChat build reports, manifests, inspections, and snapshots also report update
operation counts separately from update payload bytes, so many small `setData`
keys stay visible as a speed risk even when the JSON payload is compact.
Project inspections also rank and gate route-level repeated-list pressure from
generated manifests, including unwindowed rows, unkeyed rows, and duplicate
keys.
Snapshots include first-class list, agent workflow, snapshot replacement, and
map-quality pressure counters, so CI diffs can track huge-app render and
interaction risk without parsing the long profile summary.

Generate a standalone starter project with:

```bash
moon run cmd/main -- init --name my_miniapp --module local/my_miniapp --out /tmp/my-miniapp
```

The generated starter keeps agent chat and map-heavy surfaces first-class while
splitting app view, agent feed, scene model, bounded updates, budget checks,
backend contract, inspection/profile gates, release readiness, and WeChat
generation into separate files, plus a local `cmd/main` build command that
writes the starter's WeChat files and supports `--strict` diagnostic gating.
The same command has an `inspect` mode for no-write route, backend, map, file
pressure, and release-readiness checks and a `snapshot` mode for deterministic
generated-output artifacts, plus a no-write `limits` mode for platform
capabilities and generator status. WeChat build, inspect, snapshot, and CI-plan
paths reuse Bunnia's target-support gate; Alipay/TikTok currently use a generic
build-only path, while unknown targets report diagnostics before artifacts are
generated. It also prints a local `ci-plan` with check, test, interface, format,
product-neutral boundary, platform-limits, inspect, snapshot, strict build,
one-shot watch commands, and the active inspection/profile/release thresholds.
Its summary reports the current generated-output and gate diagnostic count.
Starter tests check render budgets, scene output, bounded patches, backend
visibility, release readiness, profile gates, and clean WeChat event wiring. The command also writes a local
`moon.work` that includes the starter app and the current Bunnia checkout for
pre-registry development.

Generate the Wenyu proof slice with:

```bash
moon run cmd/main -- --example wenyu_overview
```

```mbt check
///|
test {
  let page = @bunnia.page([
    @bunnia.view([
      @bunnia.text("Demo Dashboard"),
      @bunnia.button("Open Detail", "open-detail"),
    ]),
  ])
  let plan = @bunnia.plan(page, @bunnia.wechat())
  assert_eq(plan.node_count, 5)
}
```

```mbt check
///|
test {
  let plan = @bunnia.plan_scene_assets_with_budget_and_policy(
    [
      @bunnia.remote_image_asset(
        "remote-ok", "https://cdn.example.test/tile.png",
      ),
      @bunnia.remote_image_asset(
        "remote-bad", "https://assets.example.test/tile.png",
      ),
    ],
    @bunnia.default_scene_asset_budget(),
    @bunnia.scene_asset_policy(approved_remote_domains=["cdn.example.test"]),
  )
  assert_eq(plan.remote_assets, 2)
  assert_eq(plan.unapproved_remote_asset_count, 1)
}
```

```mbt check
///|
test {
  let app = @bunnia.program(
    id="counter",
    model=0,
    view=fn(count) {
      @bunnia.page([
        @bunnia.text("Count \{count}"),
        @bunnia.button("Increment", "inc"),
      ])
    },
    update=fn(count, msg) {
      if msg == "inc" {
        @bunnia.step(model=count + 1)
      } else {
        @bunnia.step(model=count)
      }
    },
  )
  let next = @bunnia.apply(app, "inc")
  let output = @bunnia.generate_wechat_page(
    "Counter",
    @bunnia.current_view(next),
  )
  assert_true(output.wxml.contains("Count 1"))
}
```

```mbt check
///|
test {
  let trace = @bunnia.communication_trace([
    @bunnia.handoff(
      id="handoff-1",
      thread_id="thread-a",
      from_actor_id="agent-a",
      to_actor_id="operator",
      text="Please review this result.",
      open_message="open-review",
    ),
  ])
  let output = @bunnia.generate_wechat_page("Trace", @bunnia.page([trace]))
  assert_true(output.wxml.contains("bunnia-communication-handoff"))
  assert_true(output.wxml.contains("open-review"))
}
```

```mbt check
///|
test {
  let runtime = @bunnia.wechat_runtime(initial_data_json="{\"counter\":0}", event_patches=[
    @bunnia.wechat_event_patch("open-detail", [@bunnia.set_json("counter", "1")]),
  ])
  let project = @bunnia.generate_wechat_project_with_runtime(
    name="Budgeted",
    root=@bunnia.page([@bunnia.button("Open", "open-detail")]),
    runtime~,
  )
  let report = @bunnia.report_wechat_project(project, runtime)
  assert_eq(report.file_count, 10)
  assert_true(project.manifest.summary.contains("app_files=9"))
  assert_true(report.initial_data_bytes > 0)
  assert_true(report.event_patch_bytes > 0)
}
```

```mbt check
///|
test {
  let contract = @bunnia.backend_contract(id="agent-backend", endpoints=[
    @bunnia.agent_message_endpoint(
      "send-agent-message", "/agent/message", "message", "messageResult",
    ),
    @bunnia.review_decision_endpoint(
      "review-decision", "/review/decision", "review", "reviewResult",
    ),
  ])
  let plan = @bunnia.plan_backend_contract(contract)
  let effects = @bunnia.plan_backend_effects_for_platform(
    contract,
    @bunnia.wechat(),
  )
  let js = @bunnia.generate_wechat_request_adapter(contract)
  assert_eq(plan.endpoint_count, 2)
  assert_eq(effects.effect_count, 2)
  assert_true(js.contains("wx.request"))
  assert_true(!js.contains("secret"))
}
```

```mbt check
///|
test {
  let plan = @bunnia.plan_snapshot_deltas([
    @bunnia.set_snapshot_section_delta(
      "home", "buildings", "[{\"id\":\"hall\"}]",
    ),
    @bunnia.append_snapshot_item_delta(
      "home", "messages", "msg-1", "{\"id\":\"msg-1\"}",
    ),
  ])
  assert_eq(plan.section_update_count, 1)
  assert_eq(plan.append_item_count, 1)
  assert_eq(plan.full_snapshot_count, 0)
  assert_true(plan.patch_plan.total_estimated_bytes < 128)
}
```

```mbt check
///|
test {
  let assets = [@bunnia.sprite_asset("agent", "/assets/agent.png", 2048)]
  let map = @bunnia.static_scene_view(
    @bunnia.scene(
      "overview",
      @bunnia.scene_size(640, 480),
      [
        @bunnia.layer("districts", 1, [], regions=[
          @bunnia.region(
            id="district-a",
            label="District A",
            x=48,
            y=64,
            width=240,
            height=160,
            status="review",
            tap_message="select-district-a",
          ),
        ]),
        @bunnia.layer("actors", 10, [
          @bunnia.marker(
            id="actor-a",
            label="Agent A",
            x=120,
            y=180,
            status="running",
            asset_ref="agent",
            tap_message="select-actor-a",
          ),
        ]),
      ],
      assets~,
    ),
  )
  let patches = @bunnia.plan_patches([
    @bunnia.select_scene_region("overview", "district-a"),
    @bunnia.set_scene_marker_status("overview", "actor-a", "selected"),
  ])
  let output = @bunnia.generate_wechat_page("Map", @bunnia.page([map]))
  assert_true(output.wxml.contains("data-region-id=\"district-a\""))
  assert_true(output.wxml.contains("bunnia-scene-sprite"))
  assert_true(patches.total_estimated_bytes < 96)
}
```

```mbt check
///|
test {
  let map = @bunnia.scene(
    "ops-map",
    @bunnia.scene_size(640, 420),
    [
      @bunnia.layer("markers", 1, [
        @bunnia.marker(
          id="agent",
          label="Agent",
          x=120,
          y=140,
          status="running",
          tap_message="select-agent",
          asset_ref="agent",
        ),
      ]),
    ],
    assets=[@bunnia.sprite_asset("agent", "/assets/agent.png", 2048)],
  )
  let quality = @bunnia.plan_scene_visual_quality(map)
  assert_eq(quality.degraded, false)
  assert_eq(quality.diagnostics.length(), 0)
}
```

```mbt check
///|
test {
  let feed = @bunnia.message_feed([
    @bunnia.message(
      id="msg-1",
      actor_id="agent-a",
      thread_id="thread-a",
      text="Working",
      artifact_ref="artifact://result-a",
    ),
  ])
  let map = @bunnia.static_scene_view(
    @bunnia.scene("overview", @bunnia.scene_size(640, 480), [
      @bunnia.layer("actors", 10, [
        @bunnia.marker(
          id="actor-a",
          label="Agent A",
          x=120,
          y=180,
          status="running",
          tap_message="select-actor-a",
        ),
      ]),
    ]),
  )
  let output = @bunnia.generate_wechat_page("Demo", @bunnia.page([feed, map]))
  assert_true(output.wxml.contains("select-actor-a"))
  assert_true(output.js.contains("__bunnia.lastMessage"))
}
```
