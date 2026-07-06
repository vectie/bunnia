///|
pub struct BuildProfile {
  name : String
  route : String
  node_count : Int
  component_count : Int
  event_count : Int
  file_count : Int
  total_bytes : Int
  initial_data_bytes : Int
  event_patch_bytes : Int
  patch_bytes : Int
  backend_endpoint_count : Int
  scene_marker_count : Int
  scene_asset_count : Int
  scene_package_bytes : Int
  diagnostics : Array[String]
  summary : String
} derive(Debug, Eq)

///|
pub fn profile_wechat_project(
  project : @wechat.WechatProject,
  patches : @core.PatchPlan,
  backend_plans? : Array[@effects.BackendPlan] = [],
  asset_plans? : Array[@scene.SceneAssetPlan] = [],
  scene_plans? : Array[@scene.SceneRenderPlan] = [],
) -> BuildProfile {
  let diagnostics : Array[String] = []
  push_prefixed(diagnostics, "render", project.page.plan.diagnostics)
  push_prefixed(diagnostics, "wechat", project.report.diagnostics)
  push_prefixed(diagnostics, "patch", patches.diagnostics)
  let backend_endpoint_count = collect_backend_diagnostics(
    diagnostics, backend_plans,
  )
  let (scene_asset_count, scene_package_bytes) = collect_asset_diagnostics(
    diagnostics, asset_plans,
  )
  let scene_marker_count = collect_scene_diagnostics(diagnostics, scene_plans)
  {
    name: project.name,
    route: project.route,
    node_count: project.page.plan.node_count,
    component_count: project.page.plan.component_kinds.length(),
    event_count: project.page.plan.event_messages.length(),
    file_count: project.report.file_count,
    total_bytes: project.report.total_bytes,
    initial_data_bytes: project.report.initial_data_bytes,
    event_patch_bytes: project.report.event_patch_bytes,
    patch_bytes: patches.total_estimated_bytes,
    backend_endpoint_count,
    scene_marker_count,
    scene_asset_count,
    scene_package_bytes,
    diagnostics,
    summary: profile_summary(
      project,
      patches,
      backend_endpoint_count,
      scene_marker_count,
      scene_asset_count,
      scene_package_bytes,
      diagnostics.length(),
    ),
  }
}

///|
fn profile_summary(
  project : @wechat.WechatProject,
  patches : @core.PatchPlan,
  backend_endpoint_count : Int,
  scene_marker_count : Int,
  scene_asset_count : Int,
  scene_package_bytes : Int,
  diagnostic_count : Int,
) -> String {
  "Bunnia build profile: name=\{project.name} route=\{project.route} nodes=\{project.page.plan.node_count} components=\{project.page.plan.component_kinds.length()} events=\{project.page.plan.event_messages.length()} files=\{project.report.file_count} bytes=\{project.report.total_bytes} initial_data=\{project.report.initial_data_bytes} event_patches=\{project.report.event_patch_bytes} patch_bytes=\{patches.total_estimated_bytes} backend_endpoints=\{backend_endpoint_count} scene_markers=\{scene_marker_count} scene_assets=\{scene_asset_count} scene_package_bytes=\{scene_package_bytes} diagnostics=\{diagnostic_count}"
}

///|
fn collect_backend_diagnostics(
  diagnostics : Array[String],
  plans : Array[@effects.BackendPlan],
) -> Int {
  let mut total = 0
  for plan in plans {
    total += plan.endpoint_count
    push_prefixed(diagnostics, "backend", plan.diagnostics)
  }
  total
}

///|
fn collect_asset_diagnostics(
  diagnostics : Array[String],
  plans : Array[@scene.SceneAssetPlan],
) -> (Int, Int) {
  let mut count = 0
  let mut package_bytes = 0
  for plan in plans {
    count += plan.assets.length()
    package_bytes += plan.package_bytes
    push_prefixed(diagnostics, "scene-assets", plan.diagnostics)
  }
  (count, package_bytes)
}

///|
fn collect_scene_diagnostics(
  diagnostics : Array[String],
  plans : Array[@scene.SceneRenderPlan],
) -> Int {
  let mut markers = 0
  for plan in plans {
    markers += plan.marker_count
    push_prefixed(diagnostics, "scene-render", plan.diagnostics)
  }
  markers
}

///|
fn push_prefixed(
  output : Array[String],
  prefix : String,
  diagnostics : Array[String],
) -> Unit {
  for item in diagnostics {
    output.push("\{prefix}:\{item}")
  }
}
