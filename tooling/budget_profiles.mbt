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
        max_page_first_screen_bytes=24576,
        max_page_update_payload_bytes=1024,
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
        max_page_first_screen_bytes=4,
        max_page_update_payload_bytes=4,
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
        max_scene_assets=64,
        max_scene_remote_assets=16,
      )
    "tight" =>
      inspection_budget(
        max_route_risk_score=50000,
        max_scene_assets=16,
        max_scene_remote_assets=4,
      )
    "tiny" =>
      inspection_budget(
        max_route_risk_score=1000,
        max_scene_assets=0,
        max_scene_remote_assets=0,
      )
    _ => panic()
  }
}
