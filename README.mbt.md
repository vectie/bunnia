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

## Package Shape

- `core`: platform-neutral tree, events, adapters, and render planning.
- `program`: pure `Program[Model, Msg]` update/view boundary with pending
  effects and patch plans.
- `agent`: lightweight message, review, artifact-link, and run-status UI
  primitives, plus generic communication threads and traces.
- `scene`: static stylised map model with layers, markers, asset manifests,
  hit targets, and bounded updates.
- `effects`: typed frontend effect descriptions for request, navigation,
  cancel, and retry paths.
- `adapters/wechat`: WeChat Mini Program output generation.
- `examples/agent_map`: small downstream example combining agentic UI, review
  controls, patches, and a static map surface.
- root package: small `@bunnia` facade for app authors.

## Generate The Demo

```bash
moon run cmd/main
```

This writes a WeChat Mini Program file set to
`_build/bunnia/wechat/agent_map`. The demo includes initial page data plus
event-to-patch dispatch for review buttons and map markers. Use `--out` to
choose another directory:

```bash
moon run cmd/main -- --out /tmp/bunnia-agent-map
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
  let assets = [@bunnia.sprite_asset("agent", "/assets/agent.png", 2048)]
  let map = @bunnia.static_scene_view(
    @bunnia.scene(
      "overview",
      @bunnia.scene_size(640, 480),
      [
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
    @bunnia.set_scene_marker_status("overview", "actor-a", "selected"),
  ])
  let output = @bunnia.generate_wechat_page("Map", @bunnia.page([map]))
  assert_true(output.wxml.contains("bunnia-scene-sprite"))
  assert_true(patches.total_estimated_bytes < 96)
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
