///|
pub struct RouteInspection {
  route : String
  status : String
  diagnostics : Int
  first_screen_bytes : Int
  update_payload_bytes : Int
  node_count : Int
  event_count : Int
  scene_marker_count : Int
  scene_visible_marker_count : Int
  scene_asset_count : Int
  risk_score : Int
  summary : String
} derive(Debug, Eq)

///|
pub struct ProjectInspection {
  target : String
  example : String
  route_count : Int
  routes : Array[RouteInspection]
  top_route : String
  total_diagnostics : Int
  max_first_screen_bytes : Int
  max_update_payload_bytes : Int
  max_scene_marker_count : Int
  risk_score : Int
  summary : String
} derive(Debug, Eq)

///|
pub fn inspect_wechat_project(
  target~ : String,
  example~ : String,
  project : @wechat.WechatProject,
  report : @wechat.WechatBuildReport,
) -> ProjectInspection {
  let routes : Array[RouteInspection] = []
  let mut top_route = ""
  let mut top_score = -1
  let mut max_scene_markers = 0
  let total_diagnostics = project.manifest.diagnostic_count +
    report_only_diagnostic_count(project, report)
  for page in project.manifest.pages {
    let inspection = inspect_route(page)
    if inspection.risk_score > top_score {
      top_route = inspection.route
      top_score = inspection.risk_score
    }
    if inspection.scene_marker_count > max_scene_markers {
      max_scene_markers = inspection.scene_marker_count
    }
    routes.push(inspection)
  }
  if top_score < 0 {
    top_score = 0
  }
  {
    target,
    example,
    route_count: routes.length(),
    routes,
    top_route,
    total_diagnostics,
    max_first_screen_bytes: report.max_page_first_screen_bytes,
    max_update_payload_bytes: report.max_page_update_payload_bytes,
    max_scene_marker_count: max_scene_markers,
    risk_score: top_score,
    summary: "Bunnia project inspection: target=\{target} example=\{example} routes=\{routes.length()} top_route=\{top_route} risk_score=\{top_score} diagnostics=\{total_diagnostics} max_first_screen=\{report.max_page_first_screen_bytes} max_update_payload=\{report.max_page_update_payload_bytes} max_scene_markers=\{max_scene_markers}",
  }
}

///|
fn report_only_diagnostic_count(
  project : @wechat.WechatProject,
  report : @wechat.WechatBuildReport,
) -> Int {
  let count = report.diagnostics.length() - project.manifest.diagnostic_count
  if count < 0 {
    0
  } else {
    count
  }
}

///|
fn inspect_route(page : @wechat.WechatManifestPage) -> RouteInspection {
  let score = route_risk_score(page)
  {
    route: page.route,
    status: page.status,
    diagnostics: page.diagnostic_count,
    first_screen_bytes: page.first_screen_bytes,
    update_payload_bytes: page.update_payload_bytes,
    node_count: page.node_count,
    event_count: page.event_count,
    scene_marker_count: page.scene_marker_count,
    scene_visible_marker_count: page.scene_visible_marker_count,
    scene_asset_count: page.scene_asset_count,
    risk_score: score,
    summary: "Bunnia route inspection: route=\{page.route} status=\{page.status} risk_score=\{score} diagnostics=\{page.diagnostic_count} first_screen=\{page.first_screen_bytes} update_payload=\{page.update_payload_bytes} nodes=\{page.node_count} events=\{page.event_count} scene_markers=\{page.scene_visible_marker_count}/\{page.scene_marker_count} scene_assets=\{page.scene_asset_count}",
  }
}

///|
fn route_risk_score(page : @wechat.WechatManifestPage) -> Int {
  page.diagnostic_count * 1000000 +
  page.first_screen_bytes +
  page.update_payload_bytes * 4 +
  page.node_count * 16 +
  page.event_count * 64 +
  page.scene_marker_count * 32
}
