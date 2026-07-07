///|
pub struct MiniappInspection {
  target : String
  example : String
  page_count : Int
  file_count : Int
  total_bytes : Int
  diagnostic_route_count : Int
  diagnostic_count : Int
  max_node_count : Int
  max_depth : Int
  max_event_count : Int
  max_scene_marker_count : Int
  max_scene_region_count : Int
  max_scene_asset_count : Int
  status : String
  summary : String
} derive(Debug, Eq)

///|
pub struct MiniappInspectionBudget {
  max_pages : Int
  max_files : Int
  max_total_bytes : Int
  max_route_diagnostic_routes : Int
  max_route_diagnostics : Int
  max_nodes : Int
  max_depth : Int
  max_events : Int
  max_scene_markers : Int
  max_scene_regions : Int
  max_scene_assets : Int
} derive(Debug, Eq)

///|
pub struct MiniappInspectionGate {
  budget_profile : String
  max_pages : Int
  max_files : Int
  max_total_bytes : Int
  max_route_diagnostic_routes : Int
  max_route_diagnostics : Int
  max_nodes : Int
  max_depth : Int
  max_events : Int
  max_scene_markers : Int
  max_scene_regions : Int
  max_scene_assets : Int
  diagnostics : Array[String]
  summary : String
} derive(Debug, Eq)

///|
pub fn miniapp_inspection_budget(
  max_pages~ : Int,
  max_files~ : Int,
  max_total_bytes~ : Int,
  max_route_diagnostic_routes~ : Int,
  max_route_diagnostics~ : Int,
  max_nodes~ : Int,
  max_depth~ : Int,
  max_events~ : Int,
  max_scene_markers~ : Int,
  max_scene_regions~ : Int,
  max_scene_assets~ : Int,
) -> MiniappInspectionBudget {
  {
    max_pages,
    max_files,
    max_total_bytes,
    max_route_diagnostic_routes,
    max_route_diagnostics,
    max_nodes,
    max_depth,
    max_events,
    max_scene_markers,
    max_scene_regions,
    max_scene_assets,
  }
}

///|
pub fn inspect_miniapp_project(
  target~ : String,
  example~ : String,
  project : @miniapp.MiniappProject,
) -> MiniappInspection {
  let manifest = project.manifest
  let max_node_count = max_miniapp_page_value(manifest.pages, page => {
    page.node_count
  })
  let max_depth = max_miniapp_page_value(manifest.pages, page => page.depth)
  let max_event_count = max_miniapp_page_value(manifest.pages, page => {
    page.event_count
  })
  let max_scene_marker_count = max_miniapp_page_value(manifest.pages, page => {
    page.scene_marker_count
  })
  let max_scene_region_count = max_miniapp_page_value(manifest.pages, page => {
    page.scene_region_count
  })
  let max_scene_asset_count = max_miniapp_page_value(manifest.pages, page => {
    page.scene_asset_count
  })
  let status = if manifest.diagnostic_count == 0 { "ok" } else { "diagnostic" }
  {
    target,
    example,
    page_count: manifest.page_count,
    file_count: project.files.length(),
    total_bytes: project.total_bytes,
    diagnostic_route_count: manifest.diagnostic_route_count,
    diagnostic_count: manifest.diagnostic_count,
    max_node_count,
    max_depth,
    max_event_count,
    max_scene_marker_count,
    max_scene_region_count,
    max_scene_asset_count,
    status,
    summary: "Bunnia generic miniapp inspection: target=\{target} example=\{example} status=\{status} pages=\{manifest.page_count} files=\{project.files.length()} bytes=\{project.total_bytes} route_diagnostic_routes=\{manifest.diagnostic_route_count} diagnostics=\{manifest.diagnostic_count} max_nodes=\{max_node_count} max_depth=\{max_depth} max_events=\{max_event_count} max_scene_markers=\{max_scene_marker_count} max_scene_regions=\{max_scene_region_count} max_scene_assets=\{max_scene_asset_count}",
  }
}

///|
pub fn gate_miniapp_inspection(
  inspection : MiniappInspection,
  budget : MiniappInspectionBudget,
  budget_profile? : String = "custom",
) -> MiniappInspectionGate {
  let diagnostics : Array[String] = []
  if inspection.page_count > budget.max_pages {
    diagnostics.push(
      "miniapp-pages-over-budget:\{inspection.page_count}/\{budget.max_pages}",
    )
  }
  if inspection.file_count > budget.max_files {
    diagnostics.push(
      "miniapp-files-over-budget:\{inspection.file_count}/\{budget.max_files}",
    )
  }
  if inspection.total_bytes > budget.max_total_bytes {
    diagnostics.push(
      "miniapp-total-bytes-over-budget:\{inspection.total_bytes}/\{budget.max_total_bytes}",
    )
  }
  if inspection.diagnostic_route_count > budget.max_route_diagnostic_routes {
    diagnostics.push(
      "miniapp-route-diagnostic-routes-over-budget:\{inspection.diagnostic_route_count}/\{budget.max_route_diagnostic_routes}",
    )
  }
  if inspection.diagnostic_count > budget.max_route_diagnostics {
    diagnostics.push(
      "miniapp-route-diagnostics-over-budget:\{inspection.diagnostic_count}/\{budget.max_route_diagnostics}",
    )
  }
  if inspection.max_node_count > budget.max_nodes {
    diagnostics.push(
      "miniapp-nodes-over-budget:\{inspection.max_node_count}/\{budget.max_nodes}",
    )
  }
  if inspection.max_depth > budget.max_depth {
    diagnostics.push(
      "miniapp-depth-over-budget:\{inspection.max_depth}/\{budget.max_depth}",
    )
  }
  if inspection.max_event_count > budget.max_events {
    diagnostics.push(
      "miniapp-events-over-budget:\{inspection.max_event_count}/\{budget.max_events}",
    )
  }
  if inspection.max_scene_marker_count > budget.max_scene_markers {
    diagnostics.push(
      "miniapp-scene-markers-over-budget:\{inspection.max_scene_marker_count}/\{budget.max_scene_markers}",
    )
  }
  if inspection.max_scene_region_count > budget.max_scene_regions {
    diagnostics.push(
      "miniapp-scene-regions-over-budget:\{inspection.max_scene_region_count}/\{budget.max_scene_regions}",
    )
  }
  if inspection.max_scene_asset_count > budget.max_scene_assets {
    diagnostics.push(
      "miniapp-scene-assets-over-budget:\{inspection.max_scene_asset_count}/\{budget.max_scene_assets}",
    )
  }
  {
    budget_profile,
    max_pages: budget.max_pages,
    max_files: budget.max_files,
    max_total_bytes: budget.max_total_bytes,
    max_route_diagnostic_routes: budget.max_route_diagnostic_routes,
    max_route_diagnostics: budget.max_route_diagnostics,
    max_nodes: budget.max_nodes,
    max_depth: budget.max_depth,
    max_events: budget.max_events,
    max_scene_markers: budget.max_scene_markers,
    max_scene_regions: budget.max_scene_regions,
    max_scene_assets: budget.max_scene_assets,
    diagnostics,
    summary: "Bunnia generic miniapp inspection gate: budget=\{budget_profile} max_pages=\{budget.max_pages} max_files=\{budget.max_files} max_total_bytes=\{budget.max_total_bytes} max_route_diagnostic_routes=\{budget.max_route_diagnostic_routes} max_route_diagnostics=\{budget.max_route_diagnostics} max_nodes=\{budget.max_nodes} max_depth=\{budget.max_depth} max_events=\{budget.max_events} max_scene_markers=\{budget.max_scene_markers} max_scene_regions=\{budget.max_scene_regions} max_scene_assets=\{budget.max_scene_assets} diagnostics=\{diagnostics.length()}",
  }
}

///|
fn max_miniapp_page_value(
  pages : Array[@miniapp.MiniappManifestPage],
  value : (@miniapp.MiniappManifestPage) -> Int,
) -> Int {
  let mut max = 0
  for page in pages {
    let current = value(page)
    if current > max {
      max = current
    }
  }
  max
}
