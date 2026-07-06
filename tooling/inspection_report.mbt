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
  scene_region_count : Int
  scene_visible_region_count : Int
  scene_asset_count : Int
  scene_remote_asset_count : Int
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
  max_scene_region_count : Int
  max_scene_asset_count : Int
  max_scene_remote_asset_count : Int
  risk_score : Int
  summary : String
} derive(Debug, Eq)

///|
pub struct ProjectInspectionBudget {
  max_route_risk_score : Int
  max_scene_assets : Int
  max_scene_remote_assets : Int
} derive(Debug, Eq)

///|
pub struct ProjectInspectionGate {
  budget_profile : String
  max_route_risk_score : Int
  max_scene_assets : Int
  max_scene_remote_assets : Int
  diagnostics : Array[String]
  summary : String
} derive(Debug, Eq)

///|
pub fn inspection_budget(
  max_route_risk_score~ : Int,
  max_scene_assets~ : Int,
  max_scene_remote_assets~ : Int,
) -> ProjectInspectionBudget {
  { max_route_risk_score, max_scene_assets, max_scene_remote_assets }
}

///|
pub fn gate_project_inspection(
  inspection : ProjectInspection,
  budget : ProjectInspectionBudget,
  budget_profile? : String = "custom",
) -> ProjectInspectionGate {
  let diagnostics : Array[String] = []
  if inspection.risk_score > budget.max_route_risk_score {
    diagnostics.push(
      "inspection-route-risk-over-budget:\{inspection.top_route}:\{inspection.risk_score}/\{budget.max_route_risk_score}",
    )
  }
  if inspection.max_scene_asset_count > budget.max_scene_assets {
    diagnostics.push(
      "inspection-scene-assets-over-budget:\{inspection.max_scene_asset_count}/\{budget.max_scene_assets}",
    )
  }
  if inspection.max_scene_remote_asset_count > budget.max_scene_remote_assets {
    diagnostics.push(
      "inspection-remote-scene-assets-over-budget:\{inspection.max_scene_remote_asset_count}/\{budget.max_scene_remote_assets}",
    )
  }
  {
    budget_profile,
    max_route_risk_score: budget.max_route_risk_score,
    max_scene_assets: budget.max_scene_assets,
    max_scene_remote_assets: budget.max_scene_remote_assets,
    diagnostics,
    summary: "Bunnia inspection gate: budget=\{budget_profile} max_route_risk=\{budget.max_route_risk_score} max_scene_assets=\{budget.max_scene_assets} max_scene_remote_assets=\{budget.max_scene_remote_assets} diagnostics=\{diagnostics.length()}",
  }
}

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
  let mut max_scene_regions = 0
  let mut max_scene_assets = 0
  let mut max_scene_remote_assets = 0
  let total_diagnostics = project.manifest.diagnostic_count +
    report_only_diagnostic_count(project, report)
  for page in project.manifest.pages {
    let inspection = inspect_route(page)
    if inspection.risk_score > top_score {
      top_route = inspection.route
      top_score = inspection.risk_score
    }
    if inspection.scene_visible_marker_count > max_scene_markers {
      max_scene_markers = inspection.scene_visible_marker_count
    }
    if inspection.scene_visible_region_count > max_scene_regions {
      max_scene_regions = inspection.scene_visible_region_count
    }
    if inspection.scene_asset_count > max_scene_assets {
      max_scene_assets = inspection.scene_asset_count
    }
    if inspection.scene_remote_asset_count > max_scene_remote_assets {
      max_scene_remote_assets = inspection.scene_remote_asset_count
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
    max_scene_region_count: max_scene_regions,
    max_scene_asset_count: max_scene_assets,
    max_scene_remote_asset_count: max_scene_remote_assets,
    risk_score: top_score,
    summary: "Bunnia project inspection: target=\{target} example=\{example} routes=\{routes.length()} top_route=\{top_route} risk_score=\{top_score} diagnostics=\{total_diagnostics} max_first_screen=\{report.max_page_first_screen_bytes} max_update_payload=\{report.max_page_update_payload_bytes} max_scene_markers=\{max_scene_markers} max_scene_regions=\{max_scene_regions} max_scene_assets=\{max_scene_assets} max_scene_remote_assets=\{max_scene_remote_assets}",
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
  let scene_assets = route_scene_asset_count(page)
  let remote_assets = route_scene_remote_asset_count(page)
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
    scene_region_count: page.scene_region_count,
    scene_visible_region_count: page.scene_visible_region_count,
    scene_asset_count: scene_assets,
    scene_remote_asset_count: remote_assets,
    risk_score: score,
    summary: "Bunnia route inspection: route=\{page.route} status=\{page.status} risk_score=\{score} diagnostics=\{page.diagnostic_count} first_screen=\{page.first_screen_bytes} update_payload=\{page.update_payload_bytes} nodes=\{page.node_count} events=\{page.event_count} scene_markers=\{page.scene_visible_marker_count}/\{page.scene_marker_count} scene_regions=\{page.scene_visible_region_count}/\{page.scene_region_count} scene_assets=\{scene_assets} scene_remote_assets=\{remote_assets}",
  }
}

///|
fn route_risk_score(page : @wechat.WechatManifestPage) -> Int {
  page.diagnostic_count * 1000000 +
  page.first_screen_bytes +
  page.update_payload_bytes * 4 +
  page.node_count * 16 +
  page.event_count * 64 +
  page.scene_visible_marker_count * 32 +
  page.scene_visible_region_count * 48 +
  route_scene_asset_count(page) * 128 +
  route_scene_remote_asset_count(page) * 256
}

///|
fn route_scene_asset_count(page : @wechat.WechatManifestPage) -> Int {
  page.scene_assets.length()
}

///|
fn route_scene_remote_asset_count(page : @wechat.WechatManifestPage) -> Int {
  let mut total = 0
  for asset in page.scene_assets {
    if asset.remote {
      total += 1
    }
  }
  total
}
