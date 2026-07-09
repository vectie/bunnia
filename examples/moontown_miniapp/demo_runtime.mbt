///|
pub fn demo_runtime() -> @bunnia.WechatRuntime {
  demo_runtime_for_tab("realm")
}

///|
fn demo_runtime_for_tab(tab_id : String) -> @bunnia.WechatRuntime {
  if tab_id == "reviewer" {
    return reviewer_runtime()
  }
  let projection = demo_projection()
  let patches : Array[@bunnia.WechatEventPatch] = []
  add_shell_event_patches(patches, projection)
  add_setup_event_patches(patches, projection)
  add_discovery_filter_event_patches(patches, projection)
  add_notification_channel_event_patches(patches, projection)
  add_ownership_filter_event_patches(patches, projection)
  add_building_navigation_event_patches(patches, projection)
  add_building_workflow_event_patches(patches)
  @bunnia.wechat_runtime(
    initial_data_json=demo_initial_data_json_for_tab(tab_id),
    event_patches=patches,
    page_methods_js=moontown_map_page_methods_js(),
  )
}
