///|
pub fn is_named_budget_profile(name : String) -> Bool {
  name == "default" || name == "tight" || name == "tiny"
}

///|
pub fn render_budget_for_profile(name : String) -> @core.RenderBudget {
  match name {
    "default" => @core.default_render_budget()
    "tight" =>
      @core.render_budget(
        max_nodes=128,
        max_depth=12,
        max_events=32,
        max_initial_data_bytes=4096,
        max_unwindowed_list_children=16,
        max_scene_markers=64,
        max_scene_regions=32,
        max_scene_assets=16,
        max_degraded_scenes=0,
      )
    "tiny" =>
      @core.render_budget(
        max_nodes=8,
        max_depth=2,
        max_events=1,
        max_initial_data_bytes=64,
        max_unwindowed_list_children=0,
        max_scene_markers=1,
        max_scene_regions=1,
        max_scene_assets=0,
        max_degraded_scenes=0,
      )
    _ => panic()
  }
}

///|
pub fn wechat_build_budget_for_profile(
  name : String,
) -> @wechat.WechatBuildBudget {
  match name {
    "default" => @wechat.default_build_budget()
    "tight" =>
      @wechat.build_budget(
        max_pages=4,
        max_files=16,
        max_total_bytes=32768,
        max_wxml_bytes=16384,
        max_wxss_bytes=8192,
        max_js_bytes=8192,
        max_initial_data_bytes=1024,
        max_event_patch_bytes=1024,
        max_event_patch_operations=32,
        max_page_first_screen_bytes=24576,
        max_page_update_payload_bytes=1024,
        max_page_update_operations=16,
      )
    "tiny" =>
      @wechat.build_budget(
        max_pages=1,
        max_files=1,
        max_total_bytes=128,
        max_wxml_bytes=128,
        max_wxss_bytes=128,
        max_js_bytes=128,
        max_initial_data_bytes=4,
        max_event_patch_bytes=4,
        max_event_patch_operations=1,
        max_page_first_screen_bytes=4,
        max_page_update_payload_bytes=4,
        max_page_update_operations=1,
      )
    _ => panic()
  }
}

///|
pub fn inspection_budget_for_profile(name : String) -> ProjectInspectionBudget {
  match name {
    "default" =>
      inspection_budget(
        max_route_risk_score=250000,
        max_update_operations=64,
        max_backend_events=64,
        max_backend_streams=16,
        max_backend_reviews=16,
        max_backend_cancels=16,
        max_backend_retries=16,
        max_scene_assets=64,
        max_scene_remote_assets=16,
        max_scene_package_bytes=1024 * 1024,
      )
    "tight" =>
      inspection_budget(
        max_route_risk_score=50000,
        max_update_operations=16,
        max_backend_events=16,
        max_backend_streams=4,
        max_backend_reviews=8,
        max_backend_cancels=8,
        max_backend_retries=8,
        max_scene_assets=16,
        max_scene_remote_assets=4,
        max_scene_package_bytes=256 * 1024,
      )
    "tiny" =>
      inspection_budget(
        max_route_risk_score=1000,
        max_update_operations=0,
        max_backend_events=0,
        max_backend_streams=0,
        max_backend_reviews=0,
        max_backend_cancels=0,
        max_backend_retries=0,
        max_scene_assets=0,
        max_scene_remote_assets=0,
        max_scene_package_bytes=0,
      )
    _ => panic()
  }
}

///|
pub fn build_profile_budget_for_profile(name : String) -> BuildProfileBudget {
  match name {
    "default" =>
      build_profile_budget(
        max_agent_duplicate_stream_chunks=0,
        max_snapshot_full_replaces=1,
        max_scene_thread_orphans=0,
        max_scene_camera_clamped=0,
        max_scene_surface_fallbacks=4,
        max_scene_quality_issues=0,
        max_degraded_scenes=0,
      )
    "tight" =>
      build_profile_budget(
        max_agent_duplicate_stream_chunks=0,
        max_snapshot_full_replaces=0,
        max_scene_thread_orphans=0,
        max_scene_camera_clamped=0,
        max_scene_surface_fallbacks=0,
        max_scene_quality_issues=0,
        max_degraded_scenes=0,
      )
    "tiny" =>
      build_profile_budget(
        max_agent_duplicate_stream_chunks=0,
        max_snapshot_full_replaces=0,
        max_scene_thread_orphans=0,
        max_scene_camera_clamped=0,
        max_scene_surface_fallbacks=0,
        max_scene_quality_issues=0,
        max_degraded_scenes=0,
      )
    _ => panic()
  }
}
