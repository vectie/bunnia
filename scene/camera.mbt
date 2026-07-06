///|
pub struct SceneCamera {
  scene_id : String
  x : Int
  y : Int
  width : Int
  height : Int
  zoom_percent : Int
} derive(Debug, Eq)

///|
pub struct SceneCameraBudget {
  min_zoom_percent : Int
  max_zoom_percent : Int
  min_viewport_width : Int
  min_viewport_height : Int
} derive(Debug, Eq)

///|
pub struct SceneCameraPlan {
  scene_id : String
  requested : SceneCamera
  camera : SceneCamera
  viewport : SceneViewport
  clamped : Bool
  diagnostics : Array[String]
  summary : String
} derive(Debug, Eq)

///|
pub fn scene_camera(
  scene_id~ : String,
  x~ : Int,
  y~ : Int,
  width~ : Int,
  height~ : Int,
  zoom_percent? : Int = 100,
) -> SceneCamera {
  { scene_id, x, y, width, height, zoom_percent }
}

///|
pub fn scene_camera_from_viewport(
  scene_id : String,
  viewport : SceneViewport,
  zoom_percent? : Int = 100,
) -> SceneCamera {
  scene_camera(
    scene_id~,
    x=viewport.x,
    y=viewport.y,
    width=viewport.width,
    height=viewport.height,
    zoom_percent~,
  )
}

///|
pub fn scene_camera_budget(
  min_zoom_percent? : Int = 50,
  max_zoom_percent? : Int = 300,
  min_viewport_width? : Int = 64,
  min_viewport_height? : Int = 64,
) -> SceneCameraBudget {
  {
    min_zoom_percent,
    max_zoom_percent,
    min_viewport_width,
    min_viewport_height,
  }
}

///|
pub fn default_scene_camera_budget() -> SceneCameraBudget {
  scene_camera_budget()
}

///|
pub fn plan_scene_camera(
  input : Scene,
  camera : SceneCamera,
) -> SceneCameraPlan {
  plan_scene_camera_with_budget(input, camera, default_scene_camera_budget())
}

///|
pub fn plan_scene_camera_with_budget(
  input : Scene,
  camera : SceneCamera,
  budget : SceneCameraBudget,
) -> SceneCameraPlan {
  let zoom_percent = clamp_int(
    camera.zoom_percent,
    budget.min_zoom_percent,
    budget.max_zoom_percent,
  )
  let visible_width = scaled_visible_size(camera.width, zoom_percent)
  let visible_height = scaled_visible_size(camera.height, zoom_percent)
  let width = if visible_width < budget.min_viewport_width {
    budget.min_viewport_width
  } else {
    visible_width
  }
  let height = if visible_height < budget.min_viewport_height {
    budget.min_viewport_height
  } else {
    visible_height
  }
  let max_x = max_int(0, input.size.width - width)
  let max_y = max_int(0, input.size.height - height)
  let x = clamp_int(camera.x, 0, max_x)
  let y = clamp_int(camera.y, 0, max_y)
  let planned = scene_camera(
    scene_id=input.id,
    x~,
    y~,
    width=camera.width,
    height=camera.height,
    zoom_percent~,
  )
  let viewport = scene_viewport(x~, y~, width~, height~)
  let clamped = camera.scene_id != input.id ||
    camera.x != x ||
    camera.y != y ||
    camera.zoom_percent != zoom_percent ||
    visible_width != width ||
    visible_height != height
  let diagnostics = scene_camera_diagnostics(
    input~,
    camera,
    planned,
    viewport,
    visible_width,
    visible_height,
    clamped,
    budget,
  )
  {
    scene_id: input.id,
    requested: camera,
    camera: planned,
    viewport,
    clamped,
    diagnostics,
    summary: "Bunnia scene camera plan: scene=\{input.id} viewport=\{viewport.x},\{viewport.y},\{viewport.width},\{viewport.height} zoom=\{zoom_percent} clamped=\{clamped} diagnostics=\{diagnostics.length()}",
  }
}

///|
pub fn static_scene_view_with_camera(
  input : Scene,
  camera : SceneCamera,
  budget? : SceneRenderBudget = default_scene_render_budget(),
  camera_budget? : SceneCameraBudget = default_scene_camera_budget(),
) -> @core.Node {
  let camera_plan = plan_scene_camera_with_budget(input, camera, camera_budget)
  let node = static_scene_view_with_viewport(
    input,
    camera_plan.viewport,
    budget~,
  )
  let attrs = node.attrs
  attrs.push(@core.data("camera-x", camera_plan.camera.x.to_string()))
  attrs.push(@core.data("camera-y", camera_plan.camera.y.to_string()))
  attrs.push(@core.data("camera-width", camera_plan.camera.width.to_string()))
  attrs.push(@core.data("camera-height", camera_plan.camera.height.to_string()))
  attrs.push(
    @core.data(
      "camera-zoom-percent",
      camera_plan.camera.zoom_percent.to_string(),
    ),
  )
  attrs.push(@core.data("camera-clamped", camera_plan.clamped.to_string()))
  @core.node(
    kind=node.kind,
    attrs~,
    events=node.events,
    children=node.children,
    text=node.text,
    key=node.key,
    list_total_count=node.list_total_count,
    list_visible_count=node.list_visible_count,
  )
}

///|
pub fn set_scene_camera(scene_id : String, camera : SceneCamera) -> @core.Patch {
  @core.set_json("scenes.\{scene_id}.camera", scene_camera_json(camera))
}

///|
pub fn set_scene_camera_position(
  scene_id : String,
  x : Int,
  y : Int,
) -> @core.Patch {
  @core.set_json(
    "scenes.\{scene_id}.camera.position",
    "{\"x\":\{x},\"y\":\{y}}",
  )
}

///|
pub fn set_scene_camera_zoom(
  scene_id : String,
  zoom_percent : Int,
) -> @core.Patch {
  @core.set_json(
    "scenes.\{scene_id}.camera.zoomPercent",
    zoom_percent.to_string(),
  )
}

///|
pub fn set_scene_camera_viewport(
  scene_id : String,
  viewport : SceneViewport,
) -> @core.Patch {
  @core.set_json(
    "scenes.\{scene_id}.camera.viewport",
    "{\"x\":\{viewport.x},\"y\":\{viewport.y},\"width\":\{viewport.width},\"height\":\{viewport.height}}",
  )
}

///|
fn scene_camera_diagnostics(
  input~ : Scene,
  requested : SceneCamera,
  planned : SceneCamera,
  viewport : SceneViewport,
  visible_width : Int,
  visible_height : Int,
  clamped : Bool,
  budget : SceneCameraBudget,
) -> Array[String] {
  let diagnostics : Array[String] = []
  if requested.scene_id != input.id {
    diagnostics.push(
      "scene-camera-scene-mismatch:\{requested.scene_id}/\{input.id}",
    )
  }
  if requested.zoom_percent < budget.min_zoom_percent {
    diagnostics.push(
      "scene-camera-zoom-under-min:\{requested.zoom_percent}/\{budget.min_zoom_percent}",
    )
  }
  if requested.zoom_percent > budget.max_zoom_percent {
    diagnostics.push(
      "scene-camera-zoom-over-max:\{requested.zoom_percent}/\{budget.max_zoom_percent}",
    )
  }
  if visible_width < budget.min_viewport_width {
    diagnostics.push(
      "scene-camera-viewport-width-under-min:\{visible_width}/\{budget.min_viewport_width}",
    )
  }
  if visible_height < budget.min_viewport_height {
    diagnostics.push(
      "scene-camera-viewport-height-under-min:\{visible_height}/\{budget.min_viewport_height}",
    )
  }
  if clamped {
    diagnostics.push(
      "scene-camera-clamped:\{requested.x},\{requested.y}/\{planned.x},\{planned.y}",
    )
  }
  if viewport.width > input.size.width || viewport.height > input.size.height {
    diagnostics.push(
      "scene-camera-viewport-over-scene:\{viewport.width}x\{viewport.height}/\{input.size.width}x\{input.size.height}",
    )
  }
  diagnostics
}

///|
fn scaled_visible_size(size : Int, zoom_percent : Int) -> Int {
  let zoom = if zoom_percent <= 0 { 1 } else { zoom_percent }
  let scaled = size * 100 / zoom
  if scaled < 1 {
    1
  } else {
    scaled
  }
}

///|
fn clamp_int(value : Int, min : Int, max : Int) -> Int {
  if value < min {
    min
  } else if value > max {
    max
  } else {
    value
  }
}

///|
fn max_int(a : Int, b : Int) -> Int {
  if a > b {
    a
  } else {
    b
  }
}

///|
fn scene_camera_json(input : SceneCamera) -> String {
  "{" +
  "\"sceneId\":\"\{scene_camera_escape_json(input.scene_id)}\"," +
  "\"x\":\{input.x}," +
  "\"y\":\{input.y}," +
  "\"width\":\{input.width}," +
  "\"height\":\{input.height}," +
  "\"zoomPercent\":\{input.zoom_percent}" +
  "}"
}

///|
fn scene_camera_escape_json(value : String) -> String {
  value
  .replace(old="\\", new="\\\\")
  .replace(old="\"", new="\\\"")
  .replace(old="\n", new="\\n")
  .to_string()
}
