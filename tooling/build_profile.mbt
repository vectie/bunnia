///|
pub struct BuildProfile {
  name : String
  route : String
  page_count : Int
  node_count : Int
  component_count : Int
  event_count : Int
  windowed_list_count : Int
  list_total_count : Int
  list_visible_count : Int
  unwindowed_list_child_count : Int
  unkeyed_list_child_count : Int
  duplicate_list_key_count : Int
  file_count : Int
  total_bytes : Int
  initial_data_bytes : Int
  event_patch_bytes : Int
  event_patch_operation_count : Int
  max_page_first_screen_bytes : Int
  max_page_update_payload_bytes : Int
  max_page_update_operation_count : Int
  patch_bytes : Int
  effect_count : Int
  cloud_function_count : Int
  stream_effect_count : Int
  communication_count : Int
  communication_visible_count : Int
  communication_unresolved_review_count : Int
  communication_artifact_ref_count : Int
  tool_result_count : Int
  tool_result_visible_count : Int
  tool_result_pending_ack_count : Int
  tool_result_missing_ack_count : Int
  tool_result_artifact_ref_count : Int
  agent_delta_count : Int
  agent_duplicate_stream_chunk_count : Int
  backend_endpoint_count : Int
  backend_streaming_count : Int
  backend_review_required_count : Int
  backend_cancel_count : Int
  backend_retry_count : Int
  snapshot_delta_count : Int
  snapshot_section_update_count : Int
  snapshot_append_item_count : Int
  snapshot_full_replace_count : Int
  scene_marker_count : Int
  scene_visible_marker_count : Int
  scene_region_count : Int
  scene_visible_region_count : Int
  scene_asset_count : Int
  scene_package_bytes : Int
  scene_remote_asset_count : Int
  generated_scene_asset_count : Int
  generated_scene_remote_asset_count : Int
  scene_insecure_remote_asset_count : Int
  scene_unapproved_remote_asset_count : Int
  scene_deferred_asset_count : Int
  scene_thread_link_count : Int
  scene_thread_visible_link_count : Int
  scene_thread_unread_total : Int
  scene_thread_orphan_link_count : Int
  scene_camera_count : Int
  scene_camera_clamped_count : Int
  scene_static_surface_count : Int
  scene_canvas_surface_count : Int
  scene_lightweight_surface_count : Int
  scene_surface_fallback_count : Int
  scene_quality_issue_count : Int
  degraded_scene_count : Int
  route_diagnostic_route_count : Int
  route_diagnostic_count : Int
  diagnostics : Array[String]
  summary : String
} derive(Debug, Eq)

///|
pub struct BuildProfileBudget {
  max_route_diagnostic_routes : Int
  max_route_diagnostics : Int
  max_communication_unresolved_reviews : Int
  max_tool_result_missing_acks : Int
  max_agent_duplicate_stream_chunks : Int
  max_snapshot_full_replaces : Int
  max_scene_thread_orphans : Int
  max_scene_camera_clamped : Int
  max_scene_surface_fallbacks : Int
  max_scene_insecure_remote_assets : Int
  max_scene_unapproved_remote_assets : Int
  max_scene_deferred_assets : Int
  max_scene_quality_issues : Int
  max_degraded_scenes : Int
} derive(Debug, Eq)

///|
pub struct BuildProfileGate {
  budget_profile : String
  max_route_diagnostic_routes : Int
  max_route_diagnostics : Int
  max_communication_unresolved_reviews : Int
  max_tool_result_missing_acks : Int
  max_agent_duplicate_stream_chunks : Int
  max_snapshot_full_replaces : Int
  max_scene_thread_orphans : Int
  max_scene_camera_clamped : Int
  max_scene_surface_fallbacks : Int
  max_scene_insecure_remote_assets : Int
  max_scene_unapproved_remote_assets : Int
  max_scene_deferred_assets : Int
  max_scene_quality_issues : Int
  max_degraded_scenes : Int
  diagnostics : Array[String]
  summary : String
} derive(Debug, Eq)

///|
pub fn build_profile_budget(
  max_route_diagnostic_routes~ : Int,
  max_route_diagnostics~ : Int,
  max_communication_unresolved_reviews~ : Int,
  max_tool_result_missing_acks~ : Int,
  max_agent_duplicate_stream_chunks~ : Int,
  max_snapshot_full_replaces~ : Int,
  max_scene_thread_orphans~ : Int,
  max_scene_camera_clamped~ : Int,
  max_scene_surface_fallbacks~ : Int,
  max_scene_insecure_remote_assets~ : Int,
  max_scene_unapproved_remote_assets~ : Int,
  max_scene_deferred_assets~ : Int,
  max_scene_quality_issues~ : Int,
  max_degraded_scenes~ : Int,
) -> BuildProfileBudget {
  {
    max_route_diagnostic_routes,
    max_route_diagnostics,
    max_communication_unresolved_reviews,
    max_tool_result_missing_acks,
    max_agent_duplicate_stream_chunks,
    max_snapshot_full_replaces,
    max_scene_thread_orphans,
    max_scene_camera_clamped,
    max_scene_surface_fallbacks,
    max_scene_insecure_remote_assets,
    max_scene_unapproved_remote_assets,
    max_scene_deferred_assets,
    max_scene_quality_issues,
    max_degraded_scenes,
  }
}

///|
pub fn gate_build_profile(
  profile : BuildProfile,
  budget : BuildProfileBudget,
  budget_profile? : String = "custom",
) -> BuildProfileGate {
  let diagnostics : Array[String] = []
  if profile.route_diagnostic_route_count > budget.max_route_diagnostic_routes {
    diagnostics.push(
      "profile-route-diagnostic-routes-over-budget:\{profile.route_diagnostic_route_count}/\{budget.max_route_diagnostic_routes}",
    )
  }
  if profile.route_diagnostic_count > budget.max_route_diagnostics {
    diagnostics.push(
      "profile-route-diagnostics-over-budget:\{profile.route_diagnostic_count}/\{budget.max_route_diagnostics}",
    )
  }
  if profile.communication_unresolved_review_count >
    budget.max_communication_unresolved_reviews {
    diagnostics.push(
      "profile-communication-unresolved-reviews-over-budget:\{profile.communication_unresolved_review_count}/\{budget.max_communication_unresolved_reviews}",
    )
  }
  if profile.tool_result_missing_ack_count > budget.max_tool_result_missing_acks {
    diagnostics.push(
      "profile-tool-result-missing-acks-over-budget:\{profile.tool_result_missing_ack_count}/\{budget.max_tool_result_missing_acks}",
    )
  }
  if profile.agent_duplicate_stream_chunk_count >
    budget.max_agent_duplicate_stream_chunks {
    diagnostics.push(
      "profile-agent-duplicate-stream-chunks-over-budget:\{profile.agent_duplicate_stream_chunk_count}/\{budget.max_agent_duplicate_stream_chunks}",
    )
  }
  if profile.snapshot_full_replace_count > budget.max_snapshot_full_replaces {
    diagnostics.push(
      "profile-snapshot-full-replaces-over-budget:\{profile.snapshot_full_replace_count}/\{budget.max_snapshot_full_replaces}",
    )
  }
  if profile.scene_thread_orphan_link_count > budget.max_scene_thread_orphans {
    diagnostics.push(
      "profile-scene-thread-orphans-over-budget:\{profile.scene_thread_orphan_link_count}/\{budget.max_scene_thread_orphans}",
    )
  }
  if profile.scene_camera_clamped_count > budget.max_scene_camera_clamped {
    diagnostics.push(
      "profile-scene-camera-clamped-over-budget:\{profile.scene_camera_clamped_count}/\{budget.max_scene_camera_clamped}",
    )
  }
  if profile.scene_surface_fallback_count > budget.max_scene_surface_fallbacks {
    diagnostics.push(
      "profile-scene-surface-fallbacks-over-budget:\{profile.scene_surface_fallback_count}/\{budget.max_scene_surface_fallbacks}",
    )
  }
  if profile.scene_insecure_remote_asset_count >
    budget.max_scene_insecure_remote_assets {
    diagnostics.push(
      "profile-scene-insecure-remote-assets-over-budget:\{profile.scene_insecure_remote_asset_count}/\{budget.max_scene_insecure_remote_assets}",
    )
  }
  if profile.scene_unapproved_remote_asset_count >
    budget.max_scene_unapproved_remote_assets {
    diagnostics.push(
      "profile-scene-unapproved-remote-assets-over-budget:\{profile.scene_unapproved_remote_asset_count}/\{budget.max_scene_unapproved_remote_assets}",
    )
  }
  if profile.scene_deferred_asset_count > budget.max_scene_deferred_assets {
    diagnostics.push(
      "profile-scene-deferred-assets-over-budget:\{profile.scene_deferred_asset_count}/\{budget.max_scene_deferred_assets}",
    )
  }
  if profile.scene_quality_issue_count > budget.max_scene_quality_issues {
    diagnostics.push(
      "profile-scene-quality-issues-over-budget:\{profile.scene_quality_issue_count}/\{budget.max_scene_quality_issues}",
    )
  }
  if profile.degraded_scene_count > budget.max_degraded_scenes {
    diagnostics.push(
      "profile-degraded-scenes-over-budget:\{profile.degraded_scene_count}/\{budget.max_degraded_scenes}",
    )
  }
  {
    budget_profile,
    max_route_diagnostic_routes: budget.max_route_diagnostic_routes,
    max_route_diagnostics: budget.max_route_diagnostics,
    max_communication_unresolved_reviews: budget.max_communication_unresolved_reviews,
    max_tool_result_missing_acks: budget.max_tool_result_missing_acks,
    max_agent_duplicate_stream_chunks: budget.max_agent_duplicate_stream_chunks,
    max_snapshot_full_replaces: budget.max_snapshot_full_replaces,
    max_scene_thread_orphans: budget.max_scene_thread_orphans,
    max_scene_camera_clamped: budget.max_scene_camera_clamped,
    max_scene_surface_fallbacks: budget.max_scene_surface_fallbacks,
    max_scene_insecure_remote_assets: budget.max_scene_insecure_remote_assets,
    max_scene_unapproved_remote_assets: budget.max_scene_unapproved_remote_assets,
    max_scene_deferred_assets: budget.max_scene_deferred_assets,
    max_scene_quality_issues: budget.max_scene_quality_issues,
    max_degraded_scenes: budget.max_degraded_scenes,
    diagnostics,
    summary: "Bunnia build profile gate: budget=\{budget_profile} max_route_diagnostic_routes=\{budget.max_route_diagnostic_routes} max_route_diagnostics=\{budget.max_route_diagnostics} max_communication_unresolved_reviews=\{budget.max_communication_unresolved_reviews} max_tool_result_missing_acks=\{budget.max_tool_result_missing_acks} max_agent_duplicate_stream_chunks=\{budget.max_agent_duplicate_stream_chunks} max_snapshot_full_replaces=\{budget.max_snapshot_full_replaces} max_scene_thread_orphans=\{budget.max_scene_thread_orphans} max_scene_camera_clamped=\{budget.max_scene_camera_clamped} max_scene_surface_fallbacks=\{budget.max_scene_surface_fallbacks} max_scene_insecure_remote_assets=\{budget.max_scene_insecure_remote_assets} max_scene_unapproved_remote_assets=\{budget.max_scene_unapproved_remote_assets} max_scene_deferred_assets=\{budget.max_scene_deferred_assets} max_scene_quality_issues=\{budget.max_scene_quality_issues} max_degraded_scenes=\{budget.max_degraded_scenes} diagnostics=\{diagnostics.length()}",
  }
}

///|
pub fn profile_wechat_project(
  project : @wechat.WechatProject,
  patches : @core.PatchPlan,
  effect_plans? : Array[@effects.EffectPlan] = [],
  communication_plans? : Array[@agent.CommunicationPlan] = [],
  tool_result_plans? : Array[@agent.ToolResultPlan] = [],
  agent_delta_plans? : Array[@agent.AgentDeltaPlan] = [],
  backend_plans? : Array[@effects.BackendPlan] = [],
  snapshot_plans? : Array[@effects.SnapshotDeltaPlan] = [],
  asset_plans? : Array[@scene.SceneAssetPlan] = [],
  thread_plans? : Array[@scene.SceneThreadPlan] = [],
  camera_plans? : Array[@scene.SceneCameraPlan] = [],
  scene_plans? : Array[@scene.SceneRenderPlan] = [],
  surface_plans? : Array[@scene.SceneSurfacePlan] = [],
  quality_plans? : Array[@scene.SceneVisualQualityPlan] = [],
) -> BuildProfile {
  let diagnostics : Array[String] = []
  push_manifest_route_diagnostics(diagnostics, project.manifest.pages)
  push_wechat_report_diagnostics(
    diagnostics,
    project.report.diagnostics,
    project.manifest.pages,
  )
  push_prefixed(diagnostics, "patch", patches.diagnostics)
  let (effect_count, cloud_function_count, stream_effect_count) = collect_effect_diagnostics(
    diagnostics, effect_plans,
  )
  let (
    communication_count,
    communication_visible_count,
    communication_unresolved_review_count,
    communication_artifact_ref_count,
  ) = collect_communication_diagnostics(diagnostics, communication_plans)
  let (
    tool_result_count,
    tool_result_visible_count,
    tool_result_pending_ack_count,
    tool_result_missing_ack_count,
    tool_result_artifact_ref_count,
  ) = collect_tool_result_diagnostics(diagnostics, tool_result_plans)
  let (agent_delta_count, agent_duplicate_stream_chunk_count) = collect_agent_delta_diagnostics(
    diagnostics, agent_delta_plans,
  )
  let (
    backend_endpoint_count,
    backend_streaming_count,
    backend_review_required_count,
    backend_cancel_count,
    backend_retry_count,
  ) = collect_backend_diagnostics(diagnostics, backend_plans)
  let (
    snapshot_delta_count,
    snapshot_section_update_count,
    snapshot_append_item_count,
    snapshot_full_replace_count,
  ) = collect_snapshot_diagnostics(diagnostics, snapshot_plans)
  let (
    scene_asset_count,
    scene_package_bytes,
    scene_remote_asset_count,
    scene_insecure_remote_asset_count,
    scene_unapproved_remote_asset_count,
    scene_deferred_asset_count,
  ) = collect_asset_diagnostics(diagnostics, asset_plans)
  let generated_scene_asset_count = project.manifest.scene_asset_count
  let generated_scene_remote_asset_count = project.manifest.scene_remote_asset_count
  let (
    scene_thread_link_count,
    scene_thread_visible_link_count,
    scene_thread_unread_total,
    scene_thread_orphan_link_count,
  ) = collect_thread_diagnostics(diagnostics, thread_plans)
  let (scene_camera_count, scene_camera_clamped_count) = collect_camera_diagnostics(
    diagnostics, camera_plans,
  )
  let (
    scene_marker_count,
    scene_visible_marker_count,
    scene_region_count,
    scene_visible_region_count,
  ) = collect_scene_diagnostics(diagnostics, scene_plans)
  let (
    scene_static_surface_count,
    scene_canvas_surface_count,
    scene_lightweight_surface_count,
    scene_surface_fallback_count,
  ) = collect_surface_diagnostics(diagnostics, surface_plans)
  let (scene_quality_issue_count, degraded_scene_count) = collect_quality_diagnostics(
    diagnostics, quality_plans,
  )
  {
    name: project.name,
    route: project.route,
    page_count: project.page_count,
    node_count: page_node_count(project.pages),
    component_count: page_component_count(project.pages),
    event_count: page_event_count(project.pages),
    windowed_list_count: page_windowed_list_count(project.pages),
    list_total_count: page_list_total_count(project.pages),
    list_visible_count: page_list_visible_count(project.pages),
    unwindowed_list_child_count: page_unwindowed_list_child_count(project.pages),
    unkeyed_list_child_count: page_unkeyed_list_child_count(project.pages),
    duplicate_list_key_count: page_duplicate_list_key_count(project.pages),
    file_count: project.report.file_count,
    total_bytes: project.report.total_bytes,
    initial_data_bytes: project.report.initial_data_bytes,
    event_patch_bytes: project.report.event_patch_bytes,
    event_patch_operation_count: project.report.event_patch_operation_count,
    max_page_first_screen_bytes: project.report.max_page_first_screen_bytes,
    max_page_update_payload_bytes: project.report.max_page_update_payload_bytes,
    max_page_update_operation_count: project.report.max_page_update_operation_count,
    patch_bytes: patches.total_estimated_bytes,
    effect_count,
    cloud_function_count,
    stream_effect_count,
    communication_count,
    communication_visible_count,
    communication_unresolved_review_count,
    communication_artifact_ref_count,
    tool_result_count,
    tool_result_visible_count,
    tool_result_pending_ack_count,
    tool_result_missing_ack_count,
    tool_result_artifact_ref_count,
    agent_delta_count,
    agent_duplicate_stream_chunk_count,
    backend_endpoint_count,
    backend_streaming_count,
    backend_review_required_count,
    backend_cancel_count,
    backend_retry_count,
    snapshot_delta_count,
    snapshot_section_update_count,
    snapshot_append_item_count,
    snapshot_full_replace_count,
    scene_marker_count,
    scene_visible_marker_count,
    scene_region_count,
    scene_visible_region_count,
    scene_asset_count,
    scene_package_bytes,
    scene_remote_asset_count,
    generated_scene_asset_count,
    generated_scene_remote_asset_count,
    scene_insecure_remote_asset_count,
    scene_unapproved_remote_asset_count,
    scene_deferred_asset_count,
    scene_thread_link_count,
    scene_thread_visible_link_count,
    scene_thread_unread_total,
    scene_thread_orphan_link_count,
    scene_camera_count,
    scene_camera_clamped_count,
    scene_static_surface_count,
    scene_canvas_surface_count,
    scene_lightweight_surface_count,
    scene_surface_fallback_count,
    scene_quality_issue_count,
    degraded_scene_count,
    route_diagnostic_route_count: project.manifest.diagnostic_route_count,
    route_diagnostic_count: project.manifest.diagnostic_count,
    diagnostics,
    summary: profile_summary(
      project,
      patches,
      effect_count,
      cloud_function_count,
      stream_effect_count,
      communication_count,
      communication_visible_count,
      communication_unresolved_review_count,
      communication_artifact_ref_count,
      tool_result_count,
      tool_result_visible_count,
      tool_result_pending_ack_count,
      tool_result_missing_ack_count,
      tool_result_artifact_ref_count,
      agent_delta_count,
      agent_duplicate_stream_chunk_count,
      backend_endpoint_count,
      backend_streaming_count,
      backend_review_required_count,
      backend_cancel_count,
      backend_retry_count,
      snapshot_delta_count,
      snapshot_section_update_count,
      snapshot_append_item_count,
      snapshot_full_replace_count,
      scene_marker_count,
      scene_visible_marker_count,
      scene_region_count,
      scene_visible_region_count,
      scene_asset_count,
      scene_package_bytes,
      scene_remote_asset_count,
      generated_scene_asset_count,
      generated_scene_remote_asset_count,
      scene_insecure_remote_asset_count,
      scene_unapproved_remote_asset_count,
      scene_deferred_asset_count,
      scene_thread_link_count,
      scene_thread_visible_link_count,
      scene_thread_unread_total,
      scene_thread_orphan_link_count,
      scene_camera_count,
      scene_camera_clamped_count,
      scene_static_surface_count,
      scene_canvas_surface_count,
      scene_lightweight_surface_count,
      scene_surface_fallback_count,
      scene_quality_issue_count,
      degraded_scene_count,
      project.manifest.diagnostic_route_count,
      project.manifest.diagnostic_count,
      diagnostics.length(),
    ),
  }
}

///|
fn profile_summary(
  project : @wechat.WechatProject,
  patches : @core.PatchPlan,
  effect_count : Int,
  cloud_function_count : Int,
  stream_effect_count : Int,
  communication_count : Int,
  communication_visible_count : Int,
  communication_unresolved_review_count : Int,
  communication_artifact_ref_count : Int,
  tool_result_count : Int,
  tool_result_visible_count : Int,
  tool_result_pending_ack_count : Int,
  tool_result_missing_ack_count : Int,
  tool_result_artifact_ref_count : Int,
  agent_delta_count : Int,
  agent_duplicate_stream_chunk_count : Int,
  backend_endpoint_count : Int,
  backend_streaming_count : Int,
  backend_review_required_count : Int,
  backend_cancel_count : Int,
  backend_retry_count : Int,
  snapshot_delta_count : Int,
  snapshot_section_update_count : Int,
  snapshot_append_item_count : Int,
  snapshot_full_replace_count : Int,
  scene_marker_count : Int,
  scene_visible_marker_count : Int,
  scene_region_count : Int,
  scene_visible_region_count : Int,
  scene_asset_count : Int,
  scene_package_bytes : Int,
  scene_remote_asset_count : Int,
  generated_scene_asset_count : Int,
  generated_scene_remote_asset_count : Int,
  scene_insecure_remote_asset_count : Int,
  scene_unapproved_remote_asset_count : Int,
  scene_deferred_asset_count : Int,
  scene_thread_link_count : Int,
  scene_thread_visible_link_count : Int,
  scene_thread_unread_total : Int,
  scene_thread_orphan_link_count : Int,
  scene_camera_count : Int,
  scene_camera_clamped_count : Int,
  scene_static_surface_count : Int,
  scene_canvas_surface_count : Int,
  scene_lightweight_surface_count : Int,
  scene_surface_fallback_count : Int,
  scene_quality_issue_count : Int,
  degraded_scene_count : Int,
  route_diagnostic_route_count : Int,
  route_diagnostic_count : Int,
  diagnostic_count : Int,
) -> String {
  "Bunnia build profile: name=\{project.name} route=\{project.route} pages=\{project.page_count} nodes=\{page_node_count(project.pages)} components=\{page_component_count(project.pages)} events=\{page_event_count(project.pages)} windowed_lists=\{page_windowed_list_count(project.pages)} list_items=\{page_list_visible_count(project.pages)}/\{page_list_total_count(project.pages)} unwindowed_list_children=\{page_unwindowed_list_child_count(project.pages)} unkeyed_list_children=\{page_unkeyed_list_child_count(project.pages)} duplicate_list_keys=\{page_duplicate_list_key_count(project.pages)} files=\{project.report.file_count} bytes=\{project.report.total_bytes} initial_data=\{project.report.initial_data_bytes} event_patches=\{project.report.event_patch_bytes} event_patch_ops=\{project.report.event_patch_operation_count} max_first_screen=\{project.report.max_page_first_screen_bytes} max_update_payload=\{project.report.max_page_update_payload_bytes} max_update_ops=\{project.report.max_page_update_operation_count} patch_bytes=\{patches.total_estimated_bytes} effects=\{effect_count} cloud_functions=\{cloud_function_count} streams=\{stream_effect_count} communications=\{communication_visible_count}/\{communication_count} communication_unresolved_reviews=\{communication_unresolved_review_count} communication_artifacts=\{communication_artifact_ref_count} tool_results=\{tool_result_visible_count}/\{tool_result_count} tool_result_pending_acks=\{tool_result_pending_ack_count} tool_result_missing_acks=\{tool_result_missing_ack_count} tool_result_artifacts=\{tool_result_artifact_ref_count} agent_deltas=\{agent_delta_count} agent_duplicate_stream_chunks=\{agent_duplicate_stream_chunk_count} backend_endpoints=\{backend_endpoint_count} backend_streams=\{backend_streaming_count} backend_reviews=\{backend_review_required_count} backend_cancels=\{backend_cancel_count} backend_retries=\{backend_retry_count} snapshot_deltas=\{snapshot_delta_count} snapshot_sections=\{snapshot_section_update_count} snapshot_appends=\{snapshot_append_item_count} snapshot_full_replaces=\{snapshot_full_replace_count} scene_markers=\{scene_visible_marker_count}/\{scene_marker_count} scene_regions=\{scene_visible_region_count}/\{scene_region_count} scene_assets=\{scene_asset_count} scene_package_bytes=\{scene_package_bytes} scene_remote_assets=\{scene_remote_asset_count} generated_scene_assets=\{generated_scene_asset_count} generated_scene_remote_assets=\{generated_scene_remote_asset_count} scene_insecure_remote_assets=\{scene_insecure_remote_asset_count} scene_unapproved_remote_assets=\{scene_unapproved_remote_asset_count} scene_deferred_assets=\{scene_deferred_asset_count} scene_threads=\{scene_thread_visible_link_count}/\{scene_thread_link_count} scene_thread_unread=\{scene_thread_unread_total} scene_thread_orphans=\{scene_thread_orphan_link_count} scene_cameras=\{scene_camera_count} scene_camera_clamped=\{scene_camera_clamped_count} scene_surfaces=static:\{scene_static_surface_count},canvas:\{scene_canvas_surface_count},lightweight:\{scene_lightweight_surface_count} scene_surface_fallbacks=\{scene_surface_fallback_count} scene_quality_issues=\{scene_quality_issue_count} degraded_scenes=\{degraded_scene_count} route_diagnostic_routes=\{route_diagnostic_route_count} route_diagnostics=\{route_diagnostic_count} diagnostics=\{diagnostic_count}"
}

///|
fn push_manifest_route_diagnostics(
  diagnostics : Array[String],
  pages : Array[@wechat.WechatManifestPage],
) -> Unit {
  for page in pages {
    for item in page.diagnostics {
      push_manifest_route_diagnostic(diagnostics, item)
    }
  }
}

///|
fn push_manifest_route_diagnostic(
  diagnostics : Array[String],
  item : String,
) -> Unit {
  let render_prefix = "wechat-render:"
  if item.has_prefix(render_prefix) {
    diagnostics.push(
      "render:\{item.sub(start=render_prefix.length(), end=item.length()).to_owned()}",
    )
  } else {
    diagnostics.push("wechat:\{item}")
  }
}

///|
fn manifest_route_diagnostic_exists(
  pages : Array[@wechat.WechatManifestPage],
  diagnostic : String,
) -> Bool {
  for page in pages {
    if page.diagnostics.contains(diagnostic) {
      return true
    }
  }
  false
}

///|
fn page_node_count(pages : Array[@wechat.WechatProjectPage]) -> Int {
  let mut total = 0
  for item in pages {
    total += item.page.plan.node_count
  }
  total
}

///|
fn page_component_count(pages : Array[@wechat.WechatProjectPage]) -> Int {
  let mut total = 0
  for item in pages {
    total += item.page.plan.component_kinds.length()
  }
  total
}

///|
fn page_event_count(pages : Array[@wechat.WechatProjectPage]) -> Int {
  let mut total = 0
  for item in pages {
    total += item.page.plan.event_messages.length()
  }
  total
}

///|
fn page_windowed_list_count(pages : Array[@wechat.WechatProjectPage]) -> Int {
  let mut total = 0
  for item in pages {
    total += item.page.plan.windowed_list_count
  }
  total
}

///|
fn page_list_total_count(pages : Array[@wechat.WechatProjectPage]) -> Int {
  let mut total = 0
  for item in pages {
    total += item.page.plan.list_total_count
  }
  total
}

///|
fn page_list_visible_count(pages : Array[@wechat.WechatProjectPage]) -> Int {
  let mut total = 0
  for item in pages {
    total += item.page.plan.list_visible_count
  }
  total
}

///|
fn page_unwindowed_list_child_count(
  pages : Array[@wechat.WechatProjectPage],
) -> Int {
  let mut total = 0
  for item in pages {
    total += item.page.plan.unwindowed_list_child_count
  }
  total
}

///|
fn page_unkeyed_list_child_count(
  pages : Array[@wechat.WechatProjectPage],
) -> Int {
  let mut total = 0
  for item in pages {
    total += item.page.plan.unkeyed_list_child_count
  }
  total
}

///|
fn page_duplicate_list_key_count(
  pages : Array[@wechat.WechatProjectPage],
) -> Int {
  let mut total = 0
  for item in pages {
    total += item.page.plan.duplicate_list_key_count
  }
  total
}

///|
fn collect_effect_diagnostics(
  diagnostics : Array[String],
  plans : Array[@effects.EffectPlan],
) -> (Int, Int, Int) {
  let mut effect_count = 0
  let mut cloud_function_count = 0
  let mut stream_effect_count = 0
  for plan in plans {
    effect_count += plan.effect_count
    cloud_function_count += plan.cloud_function_count
    stream_effect_count += plan.stream_effect_count
    push_prefixed(diagnostics, "effect", plan.diagnostics)
  }
  (effect_count, cloud_function_count, stream_effect_count)
}

///|
fn collect_communication_diagnostics(
  diagnostics : Array[String],
  plans : Array[@agent.CommunicationPlan],
) -> (Int, Int, Int, Int) {
  let mut communication_count = 0
  let mut visible_count = 0
  let mut unresolved_review_count = 0
  let mut artifact_ref_count = 0
  for plan in plans {
    communication_count += plan.filtered_count
    visible_count += plan.visible_count
    unresolved_review_count += plan.unresolved_review_count
    artifact_ref_count += plan.artifact_ref_count
    push_prefixed(diagnostics, "communication", plan.diagnostics)
  }
  (
    communication_count, visible_count, unresolved_review_count, artifact_ref_count,
  )
}

///|
fn collect_tool_result_diagnostics(
  diagnostics : Array[String],
  plans : Array[@agent.ToolResultPlan],
) -> (Int, Int, Int, Int, Int) {
  let mut total_count = 0
  let mut visible_count = 0
  let mut pending_ack_count = 0
  let mut missing_ack_count = 0
  let mut artifact_ref_count = 0
  for plan in plans {
    total_count += plan.total_count
    visible_count += plan.visible_count
    pending_ack_count += plan.pending_ack_count
    missing_ack_count += plan.missing_ack_count
    artifact_ref_count += plan.artifact_ref_count
    push_prefixed(diagnostics, "tool-result", plan.diagnostics)
  }
  (
    total_count, visible_count, pending_ack_count, missing_ack_count, artifact_ref_count,
  )
}

///|
fn collect_agent_delta_diagnostics(
  diagnostics : Array[String],
  plans : Array[@agent.AgentDeltaPlan],
) -> (Int, Int) {
  let mut delta_count = 0
  let mut duplicate_stream_chunk_count = 0
  for plan in plans {
    delta_count += plan.deltas.length()
    duplicate_stream_chunk_count += plan.duplicate_stream_chunk_count
    push_prefixed(diagnostics, "agent-delta", plan.diagnostics)
  }
  (delta_count, duplicate_stream_chunk_count)
}

///|
fn collect_backend_diagnostics(
  diagnostics : Array[String],
  plans : Array[@effects.BackendPlan],
) -> (Int, Int, Int, Int, Int) {
  let mut endpoint_count = 0
  let mut streaming_count = 0
  let mut review_required_count = 0
  let mut cancel_count = 0
  let mut retry_count = 0
  for plan in plans {
    endpoint_count += plan.endpoint_count
    streaming_count += plan.streaming_count
    review_required_count += plan.review_required_count
    cancel_count += plan.cancel_count
    retry_count += plan.retry_count
    push_prefixed(diagnostics, "backend", plan.diagnostics)
  }
  (
    endpoint_count, streaming_count, review_required_count, cancel_count, retry_count,
  )
}

///|
fn collect_snapshot_diagnostics(
  diagnostics : Array[String],
  plans : Array[@effects.SnapshotDeltaPlan],
) -> (Int, Int, Int, Int) {
  let mut delta_count = 0
  let mut section_update_count = 0
  let mut append_item_count = 0
  let mut full_replace_count = 0
  for plan in plans {
    delta_count += plan.deltas.length()
    section_update_count += plan.section_update_count
    append_item_count += plan.append_item_count
    full_replace_count += plan.full_snapshot_count
    push_prefixed(diagnostics, "snapshot", plan.diagnostics)
  }
  (delta_count, section_update_count, append_item_count, full_replace_count)
}

///|
fn collect_asset_diagnostics(
  diagnostics : Array[String],
  plans : Array[@scene.SceneAssetPlan],
) -> (Int, Int, Int, Int, Int, Int) {
  let mut count = 0
  let mut package_bytes = 0
  let mut remote_count = 0
  let mut insecure_remote_count = 0
  let mut unapproved_remote_count = 0
  let mut deferred_count = 0
  for plan in plans {
    count += plan.assets.length()
    package_bytes += plan.package_bytes
    remote_count += plan.remote_assets
    insecure_remote_count += plan.insecure_remote_asset_count
    unapproved_remote_count += plan.unapproved_remote_asset_count
    deferred_count += plan.deferred_asset_count
    push_prefixed(diagnostics, "scene-assets", plan.diagnostics)
  }
  (
    count, package_bytes, remote_count, insecure_remote_count, unapproved_remote_count,
    deferred_count,
  )
}

///|
fn collect_thread_diagnostics(
  diagnostics : Array[String],
  plans : Array[@scene.SceneThreadPlan],
) -> (Int, Int, Int, Int) {
  let mut link_count = 0
  let mut visible_link_count = 0
  let mut unread_total = 0
  let mut orphan_link_count = 0
  for plan in plans {
    link_count += plan.total_link_count
    visible_link_count += plan.visible_link_count
    unread_total += plan.unread_total
    orphan_link_count += plan.orphan_link_count
    push_prefixed(diagnostics, "scene-threads", plan.diagnostics)
  }
  (link_count, visible_link_count, unread_total, orphan_link_count)
}

///|
fn collect_camera_diagnostics(
  diagnostics : Array[String],
  plans : Array[@scene.SceneCameraPlan],
) -> (Int, Int) {
  let mut count = 0
  let mut clamped_count = 0
  for plan in plans {
    count += 1
    if plan.clamped {
      clamped_count += 1
    }
    push_prefixed(diagnostics, "scene-camera", plan.diagnostics)
  }
  (count, clamped_count)
}

///|
fn collect_scene_diagnostics(
  diagnostics : Array[String],
  plans : Array[@scene.SceneRenderPlan],
) -> (Int, Int, Int, Int) {
  let mut markers = 0
  let mut visible_markers = 0
  let mut regions = 0
  let mut visible_regions = 0
  for plan in plans {
    markers += plan.marker_count
    visible_markers += plan.visible_marker_count
    regions += plan.region_count
    visible_regions += plan.visible_region_count
    push_prefixed(diagnostics, "scene-render", plan.diagnostics)
  }
  (markers, visible_markers, regions, visible_regions)
}

///|
fn collect_surface_diagnostics(
  diagnostics : Array[String],
  plans : Array[@scene.SceneSurfacePlan],
) -> (Int, Int, Int, Int) {
  let mut static_count = 0
  let mut canvas_count = 0
  let mut lightweight_count = 0
  let mut fallback_count = 0
  for plan in plans {
    match @scene.scene_render_mode_id(plan.mode) {
      "canvas-surface" => canvas_count += 1
      "lightweight-markup" => lightweight_count += 1
      _ => static_count += 1
    }
    if plan.fallback {
      fallback_count += 1
    }
    push_prefixed(diagnostics, "scene-surface", plan.diagnostics)
  }
  (static_count, canvas_count, lightweight_count, fallback_count)
}

///|
fn collect_quality_diagnostics(
  diagnostics : Array[String],
  plans : Array[@scene.SceneVisualQualityPlan],
) -> (Int, Int) {
  let mut issue_count = 0
  let mut degraded_count = 0
  for plan in plans {
    issue_count += plan.diagnostics.length()
    if plan.degraded {
      degraded_count += 1
    }
    push_prefixed(diagnostics, "scene-quality", plan.diagnostics)
  }
  (issue_count, degraded_count)
}

///|
fn push_wechat_report_diagnostics(
  output : Array[String],
  diagnostics : Array[String],
  route_pages : Array[@wechat.WechatManifestPage],
) -> Unit {
  for item in diagnostics {
    if !manifest_route_diagnostic_exists(route_pages, item) {
      output.push("wechat:\{item}")
    }
  }
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
