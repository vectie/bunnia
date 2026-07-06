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
test "scene surface plan uses canvas when preferred and supported" {
  let plan = plan_scene_surface_for_platform(
    fixture_scene(12),
    @core.Wechat,
    preference=PreferCanvasSurface,
  )
  assert_true(plan.requested_mode is CanvasSurface)
  assert_true(plan.mode is CanvasSurface)
  assert_eq(plan.fallback, false)
  assert_eq(plan.diagnostics.length(), 0)
  assert_true(plan.summary.contains("preference=canvas"))
}

///|
test "scene surface plan falls back when canvas is unsupported" {
  let no_canvas = @core.platform_adapter(
    platform=@core.Wechat,
    id="wechat-lite",
    page_component="page",
    tap_event="bindtap",
    supports_canvas=false,
  )
  let plan = plan_scene_surface(
    fixture_scene(12),
    no_canvas,
    preference=PreferCanvasSurface,
  )
  assert_true(plan.requested_mode is CanvasSurface)
  assert_true(plan.mode is StaticMarkup)
  assert_eq(plan.fallback, true)
  assert_true(plan.diagnostics.contains("scene-canvas-unsupported:wechat-lite"))
}

///|
test "scene surface plan keeps marker-budget fallback explicit" {
  let plan = plan_scene_surface_for_platform(
    fixture_scene(12),
    @core.Wechat,
    preference=PreferCanvasSurface,
    budget=scene_render_budget(max_layers=4, max_markers=4, max_static_assets=4),
  )
  assert_true(plan.requested_mode is CanvasSurface)
  assert_true(plan.mode is LightweightMarkup)
  assert_eq(plan.fallback, true)
  assert_true(
    plan.diagnostics.contains("render:scene-marker-count-over-budget:12/4"),
  )
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

///|
test "scene visual quality plan keeps complete maps clean" {
  let input = fixture_scene(4)
  let plan = plan_scene_visual_quality(input)
  assert_eq(plan.marker_count, 4)
  assert_eq(plan.markers_without_status_count, 0)
  assert_eq(plan.markers_without_tap_count, 0)
  assert_eq(plan.markers_without_asset_ref_count, 0)
  assert_eq(plan.unresolved_asset_ref_count, 0)
  assert_eq(plan.diagnostics.length(), 0)
  assert_eq(plan.degraded, false)
  assert_true(plan.summary.contains("missing_status=0"))
}

///|
test "scene visual quality plan reports weak map surfaces" {
  let input = scene("weak-map", scene_size(120, 80), [
    layer("markers", 1, [
      marker(id="a", label="A", x=10, y=20),
      marker(
        id="b",
        label="B",
        x=40,
        y=30,
        status="review",
        tap_message="select-b",
        asset_ref="missing",
      ),
    ]),
  ])
  let plan = plan_scene_visual_quality_with_budget(
    input,
    scene_render_budget(max_layers=1, max_markers=1, max_static_assets=0),
    scene_asset_budget(max_assets=0, max_package_bytes=1, max_remote_assets=0),
    default_scene_visual_quality_budget(),
  )
  assert_eq(plan.markers_without_status_count, 1)
  assert_eq(plan.markers_without_tap_count, 1)
  assert_eq(plan.markers_without_asset_ref_count, 1)
  assert_eq(plan.unresolved_asset_ref_count, 1)
  assert_eq(plan.degraded, true)
  assert_true(plan.diagnostics.contains("scene-width-under-min:120/320"))
  assert_true(plan.diagnostics.contains("scene-height-under-min:80/240"))
  assert_true(plan.diagnostics.contains("scene-markers-without-status:1/0"))
  assert_true(plan.diagnostics.contains("scene-markers-without-tap:1/0"))
  assert_true(plan.diagnostics.contains("scene-markers-without-asset-ref:1/0"))
  assert_true(plan.diagnostics.contains("scene-unresolved-asset-refs:1/0"))
  assert_true(
    plan.diagnostics.contains("render:scene-marker-count-over-budget:2/1"),
  )
}
