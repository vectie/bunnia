///|
pub struct GeneratedSnapshotFile {
  path : String
  kind : String
  bytes : Int
  checksum : Int
} derive(Debug, Eq)

///|
pub struct GeneratedSnapshot {
  target : String
  example : String
  budget_profile : String
  render_budget_profile : String
  project_name : String
  route : String
  page_count : Int
  file_count : Int
  total_bytes : Int
  max_first_screen_bytes : Int
  max_update_payload_bytes : Int
  max_update_operation_count : Int
  route_diagnostic_route_count : Int
  route_diagnostic_count : Int
  unwindowed_list_child_count : Int
  unkeyed_list_child_count : Int
  duplicate_list_key_count : Int
  communication_unresolved_review_count : Int
  tool_result_missing_ack_count : Int
  agent_duplicate_stream_chunk_count : Int
  snapshot_full_replace_count : Int
  scene_asset_count : Int
  scene_remote_asset_count : Int
  scene_thread_orphan_link_count : Int
  scene_camera_clamped_count : Int
  scene_surface_fallback_count : Int
  scene_quality_issue_count : Int
  degraded_scene_count : Int
  top_route : String
  route_risk_score : Int
  profile_gate_diagnostic_count : Int
  inspection_gate_diagnostic_count : Int
  diagnostic_count : Int
  files : Array[GeneratedSnapshotFile]
  summary : String
  content : String
} derive(Debug, Eq)

///|
pub fn snapshot_wechat_project(
  target~ : String,
  example~ : String,
  project : @wechat.WechatProject,
  profile : BuildProfile,
) -> GeneratedSnapshot {
  snapshot_wechat_project_with_report(
    target~,
    example~,
    project,
    project.report,
    profile,
    budget_profile="default",
    render_budget_profile="default",
  )
}

///|
pub fn snapshot_wechat_project_with_report(
  target~ : String,
  example~ : String,
  project : @wechat.WechatProject,
  report : @wechat.WechatBuildReport,
  profile : BuildProfile,
  budget_profile? : String = "default",
  render_budget_profile? : String = "default",
) -> GeneratedSnapshot {
  let files : Array[GeneratedSnapshotFile] = []
  for item in project.files {
    files.push(snapshot_file(item))
  }
  let route_diagnostic_route_count = project.manifest.diagnostic_route_count
  let route_diagnostic_count = project.manifest.diagnostic_count
  let scene_asset_count = project.manifest.scene_asset_count
  let scene_remote_asset_count = project.manifest.scene_remote_asset_count
  let inspection = inspect_wechat_project(target~, example~, project, report)
  let profile_gate = snapshot_profile_gate(profile, budget_profile)
  let inspection_gate = snapshot_inspection_gate(inspection, budget_profile)
  let diagnostic_count = report.diagnostics.length() +
    profile.diagnostics.length() +
    profile_gate.diagnostics.length() +
    inspection_gate.diagnostics.length()
  let summary = "Bunnia generated snapshot: target=\{target} example=\{example} budget=\{budget_profile} render_budget=\{render_budget_profile} route=\{project.route} files=\{project.files.length()} bytes=\{project.total_bytes} risk_route=\{inspection.top_route} risk_score=\{inspection.risk_score} route_diagnostic_routes=\{route_diagnostic_route_count} route_diagnostics=\{route_diagnostic_count} unwindowed_list_children=\{profile.unwindowed_list_child_count} unkeyed_list_children=\{profile.unkeyed_list_child_count} duplicate_list_keys=\{profile.duplicate_list_key_count} communication_unresolved_reviews=\{profile.communication_unresolved_review_count} tool_result_missing_acks=\{profile.tool_result_missing_ack_count} agent_duplicate_stream_chunks=\{profile.agent_duplicate_stream_chunk_count} snapshot_full_replaces=\{profile.snapshot_full_replace_count} scene_assets=\{scene_asset_count} scene_remote_assets=\{scene_remote_asset_count} scene_thread_orphans=\{profile.scene_thread_orphan_link_count} scene_camera_clamped=\{profile.scene_camera_clamped_count} scene_surface_fallbacks=\{profile.scene_surface_fallback_count} scene_quality_issues=\{profile.scene_quality_issue_count} degraded_scenes=\{profile.degraded_scene_count} profile_gate_diagnostics=\{profile_gate.diagnostics.length()} inspection_gate_diagnostics=\{inspection_gate.diagnostics.length()} diagnostics=\{diagnostic_count}"
  let content = snapshot_content(
    target, example, budget_profile, render_budget_profile, project, report, profile,
    inspection, profile_gate, inspection_gate, files, summary,
  )
  {
    target,
    example,
    budget_profile,
    render_budget_profile,
    project_name: project.name,
    route: project.route,
    page_count: project.page_count,
    file_count: project.files.length(),
    total_bytes: project.total_bytes,
    max_first_screen_bytes: report.max_page_first_screen_bytes,
    max_update_payload_bytes: report.max_page_update_payload_bytes,
    max_update_operation_count: report.max_page_update_operation_count,
    route_diagnostic_route_count,
    route_diagnostic_count,
    unwindowed_list_child_count: profile.unwindowed_list_child_count,
    unkeyed_list_child_count: profile.unkeyed_list_child_count,
    duplicate_list_key_count: profile.duplicate_list_key_count,
    communication_unresolved_review_count: profile.communication_unresolved_review_count,
    tool_result_missing_ack_count: profile.tool_result_missing_ack_count,
    agent_duplicate_stream_chunk_count: profile.agent_duplicate_stream_chunk_count,
    snapshot_full_replace_count: profile.snapshot_full_replace_count,
    scene_asset_count,
    scene_remote_asset_count,
    scene_thread_orphan_link_count: profile.scene_thread_orphan_link_count,
    scene_camera_clamped_count: profile.scene_camera_clamped_count,
    scene_surface_fallback_count: profile.scene_surface_fallback_count,
    scene_quality_issue_count: profile.scene_quality_issue_count,
    degraded_scene_count: profile.degraded_scene_count,
    top_route: inspection.top_route,
    route_risk_score: inspection.risk_score,
    profile_gate_diagnostic_count: profile_gate.diagnostics.length(),
    inspection_gate_diagnostic_count: inspection_gate.diagnostics.length(),
    diagnostic_count,
    files,
    summary,
    content,
  }
}

///|
fn snapshot_profile_gate(
  profile : BuildProfile,
  budget_profile : String,
) -> BuildProfileGate {
  let budget = if is_named_budget_profile(budget_profile) {
    build_profile_budget_for_profile(budget_profile)
  } else {
    build_profile_budget_for_profile("default")
  }
  gate_build_profile(profile, budget, budget_profile~)
}

///|
fn snapshot_inspection_gate(
  inspection : ProjectInspection,
  budget_profile : String,
) -> ProjectInspectionGate {
  let budget = if is_named_budget_profile(budget_profile) {
    inspection_budget_for_profile(budget_profile)
  } else {
    inspection_budget_for_profile("default")
  }
  gate_project_inspection(inspection, budget, budget_profile~)
}

///|
fn snapshot_file(input : @wechat.WechatFile) -> GeneratedSnapshotFile {
  {
    path: input.path,
    kind: file_kind(input.path),
    bytes: input.content.length(),
    checksum: checksum_string(input.content),
  }
}

///|
fn snapshot_content(
  target : String,
  example : String,
  budget_profile : String,
  render_budget_profile : String,
  project : @wechat.WechatProject,
  report : @wechat.WechatBuildReport,
  profile : BuildProfile,
  inspection : ProjectInspection,
  profile_gate : BuildProfileGate,
  inspection_gate : ProjectInspectionGate,
  files : Array[GeneratedSnapshotFile],
  summary : String,
) -> String {
  let out = StringBuilder()
  out.write_string("bunnia-generated-snapshot-v1\n")
  write_snapshot_field(out, "target", target)
  write_snapshot_field(out, "example", example)
  write_snapshot_field(out, "budget_profile", budget_profile)
  write_snapshot_field(out, "render_budget_profile", render_budget_profile)
  write_snapshot_field(out, "project", project.name)
  write_snapshot_field(out, "route", project.route)
  write_snapshot_field(out, "pages", project.page_count.to_string())
  write_snapshot_field(out, "files", project.files.length().to_string())
  write_snapshot_field(out, "total_bytes", project.total_bytes.to_string())
  write_snapshot_field(
    out,
    "max_first_screen",
    report.max_page_first_screen_bytes.to_string(),
  )
  write_snapshot_field(
    out,
    "max_update_payload",
    report.max_page_update_payload_bytes.to_string(),
  )
  write_snapshot_field(
    out,
    "max_update_ops",
    report.max_page_update_operation_count.to_string(),
  )
  write_snapshot_field(
    out,
    "diagnostics",
    (report.diagnostics.length() +
    profile.diagnostics.length() +
    profile_gate.diagnostics.length() +
    inspection_gate.diagnostics.length()).to_string(),
  )
  write_snapshot_field(
    out,
    "route_diagnostic_routes",
    project.manifest.diagnostic_route_count.to_string(),
  )
  write_snapshot_field(
    out,
    "route_diagnostics",
    project.manifest.diagnostic_count.to_string(),
  )
  write_snapshot_field(
    out,
    "unwindowed_list_children",
    profile.unwindowed_list_child_count.to_string(),
  )
  write_snapshot_field(
    out,
    "unkeyed_list_children",
    profile.unkeyed_list_child_count.to_string(),
  )
  write_snapshot_field(
    out,
    "duplicate_list_keys",
    profile.duplicate_list_key_count.to_string(),
  )
  write_snapshot_field(
    out,
    "communication_unresolved_reviews",
    profile.communication_unresolved_review_count.to_string(),
  )
  write_snapshot_field(
    out,
    "tool_result_missing_acks",
    profile.tool_result_missing_ack_count.to_string(),
  )
  write_snapshot_field(
    out,
    "agent_duplicate_stream_chunks",
    profile.agent_duplicate_stream_chunk_count.to_string(),
  )
  write_snapshot_field(
    out,
    "snapshot_full_replaces",
    profile.snapshot_full_replace_count.to_string(),
  )
  write_snapshot_field(
    out,
    "scene_assets",
    project.manifest.scene_asset_count.to_string(),
  )
  write_snapshot_field(
    out,
    "scene_remote_assets",
    project.manifest.scene_remote_asset_count.to_string(),
  )
  write_snapshot_field(
    out,
    "scene_thread_orphans",
    profile.scene_thread_orphan_link_count.to_string(),
  )
  write_snapshot_field(
    out,
    "scene_camera_clamped",
    profile.scene_camera_clamped_count.to_string(),
  )
  write_snapshot_field(
    out,
    "scene_surface_fallbacks",
    profile.scene_surface_fallback_count.to_string(),
  )
  write_snapshot_field(
    out,
    "scene_quality_issues",
    profile.scene_quality_issue_count.to_string(),
  )
  write_snapshot_field(
    out,
    "degraded_scenes",
    profile.degraded_scene_count.to_string(),
  )
  write_snapshot_field(out, "risk_route", inspection.top_route)
  write_snapshot_field(out, "risk_score", inspection.risk_score.to_string())
  write_snapshot_field(
    out,
    "profile_gate_diagnostics",
    profile_gate.diagnostics.length().to_string(),
  )
  write_snapshot_field(
    out,
    "inspection_gate_diagnostics",
    inspection_gate.diagnostics.length().to_string(),
  )
  write_snapshot_field(out, "report", report.summary)
  write_snapshot_field(out, "profile", profile.summary)
  write_snapshot_field(out, "profile_gate", profile_gate.summary)
  write_snapshot_field(out, "inspection", inspection.summary)
  write_snapshot_field(out, "inspection_gate", inspection_gate.summary)
  write_snapshot_field(out, "summary", summary)
  write_snapshot_route_inspections(out, inspection.routes)
  write_snapshot_scene_assets(out, project.manifest.scene_assets)
  write_snapshot_route_diagnostics(out, project.manifest.pages)
  write_snapshot_diagnostics(out, "report_diagnostics", report.diagnostics)
  write_snapshot_diagnostics(out, "profile_diagnostics", profile.diagnostics)
  write_snapshot_diagnostics(
    out,
    "profile_gate_diagnostics",
    profile_gate.diagnostics,
  )
  write_snapshot_diagnostics(
    out,
    "inspection_gate_diagnostics",
    inspection_gate.diagnostics,
  )
  out.write_string("files:\n")
  for item in files {
    out.write_string(
      "- \{item.path} kind=\{item.kind} bytes=\{item.bytes} checksum=\{item.checksum}\n",
    )
  }
  out.to_string()
}

///|
fn write_snapshot_route_inspections(
  out : StringBuilder,
  routes : Array[RouteInspection],
) -> Unit {
  out.write_string("route_inspections:\n")
  for route in routes {
    out.write_string(
      "- \{route.route} status=\{route.status} risk_score=\{route.risk_score} diagnostics=\{route.diagnostics} first_screen=\{route.first_screen_bytes} update_payload=\{route.update_payload_bytes} update_ops=\{route.update_operation_count} nodes=\{route.node_count} events=\{route.event_count} backend_events=\{route.backend_event_count} backend_streams=\{route.backend_stream_count} backend_reviews=\{route.backend_review_count} backend_cancels=\{route.backend_cancel_count} backend_retries=\{route.backend_retry_count} scene_markers=\{route.scene_visible_marker_count}/\{route.scene_marker_count} scene_regions=\{route.scene_visible_region_count}/\{route.scene_region_count} scene_assets=\{route.scene_asset_count} scene_remote_assets=\{route.scene_remote_asset_count} scene_package_bytes=\{route.scene_package_bytes}\n",
    )
  }
}

///|
fn write_snapshot_scene_assets(
  out : StringBuilder,
  assets : Array[@wechat.WechatManifestSceneAsset],
) -> Unit {
  out.write_string("scene_assets:\n")
  for item in assets {
    out.write_string(
      "- \{item.route}:\{item.id} kind=\{item.kind} src=\{item.src} remote=\{item.remote} estimated_bytes=\{item.estimated_bytes}\n",
    )
  }
}

///|
fn write_snapshot_route_diagnostics(
  out : StringBuilder,
  pages : Array[@wechat.WechatManifestPage],
) -> Unit {
  out.write_string("route_diagnostics:\n")
  for page in pages {
    if page.diagnostics.length() > 0 {
      out.write_string("- \{page.route}\n")
      for item in page.diagnostics {
        out.write_string("  - \{item}\n")
      }
    }
  }
}

///|
fn write_snapshot_diagnostics(
  out : StringBuilder,
  name : String,
  items : Array[String],
) -> Unit {
  out.write_string("\{name}:\n")
  for item in items {
    out.write_string("- \{item}\n")
  }
}

///|
fn write_snapshot_field(
  out : StringBuilder,
  name : String,
  value : String,
) -> Unit {
  out.write_string("\{name}=\{value}\n")
}

///|
fn file_kind(path : String) -> String {
  if path == "bunnia.backend.js" {
    "backend-js"
  } else if path.has_suffix(".wxml") {
    "wxml"
  } else if path.has_suffix(".wxss") {
    "wxss"
  } else if path.has_suffix(".data.js") {
    "page-data"
  } else if path.has_suffix(".js") {
    "js"
  } else if path.has_suffix(".json") {
    "json"
  } else {
    "asset"
  }
}

///|
fn checksum_string(value : String) -> Int {
  let mut checksum = 5381
  for i in 0..<value.length() {
    let weighted = value[i].to_int() % 4096 * (i % 251 + 1)
    checksum = (checksum + weighted) % 1000000007
  }
  checksum
}
