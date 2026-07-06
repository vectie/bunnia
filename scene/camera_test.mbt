///|
fn camera_fixture_scene() -> Scene {
  scene("camera-map", scene_size(720, 520), [
    layer("markers", 1, [
      marker(
        id="near",
        label="Near",
        x=80,
        y=120,
        status="ready",
        tap_message="select-near",
      ),
      marker(
        id="far",
        label="Far",
        x=620,
        y=420,
        status="review",
        tap_message="select-far",
      ),
    ]),
  ])
}

///|
fn camera_attr_value(attrs : Array[@core.Attr], name : String) -> String {
  for item in attrs {
    if item.name == name {
      return item.value
    }
  }
  ""
}

///|
test "scene camera plan clamps pan and derives zoomed viewport" {
  let plan = plan_scene_camera_with_budget(
    camera_fixture_scene(),
    scene_camera(
      scene_id="camera-map",
      x=700,
      y=480,
      width=360,
      height=260,
      zoom_percent=200,
    ),
    default_scene_camera_budget(),
  )
  assert_eq(plan.viewport.width, 180)
  assert_eq(plan.viewport.height, 130)
  assert_eq(plan.viewport.x, 540)
  assert_eq(plan.viewport.y, 390)
  assert_eq(plan.camera.zoom_percent, 200)
  assert_eq(plan.clamped, true)
  assert_true(plan.diagnostics.contains("scene-camera-clamped:700,480/540,390"))
  assert_true(plan.summary.contains("zoom=200"))
}

///|
test "scene camera plan diagnoses invalid scene and zoom budget" {
  let plan = plan_scene_camera_with_budget(
    camera_fixture_scene(),
    scene_camera(
      scene_id="wrong-map",
      x=-20,
      y=-10,
      width=80,
      height=80,
      zoom_percent=600,
    ),
    scene_camera_budget(
      min_zoom_percent=50,
      max_zoom_percent=300,
      min_viewport_width=64,
      min_viewport_height=64,
    ),
  )
  assert_eq(plan.viewport.x, 0)
  assert_eq(plan.viewport.y, 0)
  assert_eq(plan.camera.zoom_percent, 300)
  assert_true(
    plan.diagnostics.contains(
      "scene-camera-scene-mismatch:wrong-map/camera-map",
    ),
  )
  assert_true(plan.diagnostics.contains("scene-camera-zoom-over-max:600/300"))
}

///|
test "scene camera view filters markers and exposes camera data" {
  let root = static_scene_view_with_camera(
    camera_fixture_scene(),
    scene_camera(
      scene_id="camera-map",
      x=0,
      y=0,
      width=360,
      height=260,
      zoom_percent=100,
    ),
  )
  let render = @core.plan(root, @core.Wechat)
  assert_eq(camera_attr_value(root.attrs, "data-camera-x"), "0")
  assert_eq(camera_attr_value(root.attrs, "data-camera-zoom-percent"), "100")
  assert_eq(camera_attr_value(root.attrs, "data-markers-total"), "2")
  assert_eq(camera_attr_value(root.attrs, "data-markers-visible"), "1")
  assert_true(render.event_messages.contains("select-near"))
  assert_true(!render.event_messages.contains("select-far"))
}

///|
test "scene camera patches stay targeted" {
  let camera = scene_camera(
    scene_id="camera-map",
    x=16,
    y=32,
    width=360,
    height=260,
    zoom_percent=125,
  )
  let full = set_scene_camera("camera-map", camera)
  let position = set_scene_camera_position("camera-map", 24, 48)
  let zoom = set_scene_camera_zoom("camera-map", 150)
  let viewport = set_scene_camera_viewport(
    "camera-map",
    scene_viewport(x=24, y=48, width=320, height=240),
  )
  assert_eq(full.path, "scenes.camera-map.camera")
  assert_true(full.value_json.contains("\"zoomPercent\":125"))
  assert_eq(position.path, "scenes.camera-map.camera.position")
  assert_eq(position.value_json, "{\"x\":24,\"y\":48}")
  assert_eq(zoom.path, "scenes.camera-map.camera.zoomPercent")
  assert_eq(zoom.value_json, "150")
  assert_eq(viewport.path, "scenes.camera-map.camera.viewport")
  assert_true(viewport.value_json.contains("\"width\":320"))
}
