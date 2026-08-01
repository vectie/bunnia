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
  add_supervisor_setup_event_patches(patches, projection)
  add_marketplace_event_patches(patches)
  add_discovery_filter_event_patches(patches, projection)
  add_notification_channel_event_patches(patches, projection)
  add_ownership_filter_event_patches(patches, projection)
  add_building_navigation_event_patches(patches, projection)
  add_building_workflow_event_patches(patches)
  let page_methods = if tab_id == "realm" {
    moontown_map_page_methods_js()
  } else {
    moontown_route_page_methods_js(tab_id)
  }
  @bunnia.wechat_runtime(
    initial_data_json=demo_initial_data_json_for_tab(tab_id),
    event_patches=patches,
    page_methods_js=moontown_request_mapper_js() +
      moontown_marketplace_page_methods_js() +
      page_methods,
  )
}
