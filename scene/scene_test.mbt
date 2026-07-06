///|
fn fixture_scene(marker_count : Int) -> Scene {
  let markers : Array[SceneMarker] = []
  for i in 0..<marker_count {
    markers.push(
      marker(
        id="marker-\{i}",
        label="Marker \{i}",
        x=32 + i * 8,
        y=48 + i * 6,
        status="running",
        tap_message="select-marker-\{i}",
        asset_ref="pin",
      ),
    )
  }
  scene("fixture-map", scene_size(640, 420), [layer("markers", 1, markers)], assets=[
    sprite_asset("pin", "/assets/pin.png", 2048),
  ])
}

///|
fn attr_value(attrs : Array[@core.Attr], name : String) -> String {
  for item in attrs {
    if item.name == name {
      return item.value
    }
  }
  ""
}

///|
test "scene render plan keeps small maps full quality" {
  let plan = plan_scene_render(fixture_scene(12))
  assert_true(plan.mode is StaticMarkup)
  assert_true(plan.quality is FullQuality)
  assert_eq(plan.marker_count, 12)
  assert_eq(plan.layer_count, 1)
  assert_eq(plan.asset_count, 1)
  assert_eq(plan.diagnostics.length(), 0)
}

///|
test "scene render plan degrades large marker sets" {
  let plan = plan_scene_render_with_budget(
    fixture_scene(12),
    scene_render_budget(max_layers=4, max_markers=4, max_static_assets=4),
  )
  assert_true(plan.mode is LightweightMarkup)
  assert_true(plan.quality is LightweightQuality)
  assert_eq(plan.marker_count, 12)
  assert_eq(plan.diagnostics.length(), 1)
  assert_true(plan.diagnostics[0].contains("scene-marker-count-over-budget"))
}

///|
test "budgeted scene view caps visible markers and preserves stable events" {
  let root = static_scene_view_with_budget(
    fixture_scene(12),
    scene_render_budget(max_layers=4, max_markers=4, max_static_assets=4),
  )
  let render = @core.plan(root, @core.Wechat)
  assert_eq(attr_value(root.attrs, "data-scene-mode"), "lightweight-markup")
  assert_eq(attr_value(root.attrs, "data-scene-quality"), "lightweight")
  assert_eq(attr_value(root.attrs, "data-markers-total"), "12")
  assert_eq(attr_value(root.attrs, "data-markers-visible"), "4")
  assert_eq(attr_value(root.attrs, "data-scene-degraded"), "true")
  assert_eq(render.event_messages.length(), 4)
  assert_true(render.event_messages.contains("select-marker-0"))
}

///|
test "viewport scene view renders only spatially visible markers" {
  let viewport = scene_viewport(x=32, y=48, width=32, height=40)
  let root = static_scene_view_with_viewport(fixture_scene(12), viewport)
  let plan = plan_scene_render_viewport(
    fixture_scene(12),
    viewport,
    default_scene_render_budget(),
  )
  let render = @core.plan(root, @core.Wechat)
  assert_eq(plan.marker_count, 12)
  assert_eq(plan.visible_marker_count, 4)
  assert_eq(attr_value(root.attrs, "data-viewport-x"), "32")
  assert_eq(attr_value(root.attrs, "data-viewport-width"), "32")
  assert_eq(attr_value(root.attrs, "data-markers-total"), "12")
  assert_eq(attr_value(root.attrs, "data-markers-visible"), "4")
  assert_eq(render.event_messages.length(), 4)
  assert_true(render.event_messages.contains("select-marker-0"))
  assert_true(!render.event_messages.contains("select-marker-8"))
}
