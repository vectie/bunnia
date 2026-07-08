///|
test "moontown miniapp generates full vertical slice page" {
  let page = demo_wechat_page()
  assert_true(page.wxml.contains("Moontown"))
  assert_true(page.wxml.contains("moontown-map-fullscreen"))
  assert_true(!page.wxml.contains("movable-area"))
  assert_true(!page.wxml.contains("movable-view"))
  assert_true(page.wxml.contains("moontown-map-touch-area"))
  assert_true(page.wxml.contains("moontown-map-drag-content"))
  assert_true(page.wxml.contains("style=\"{{mapViewport.style}}\""))
  assert_true(page.wxml.contains("bindtouchstart=\"onMoontownMapTouchStart\""))
  assert_true(page.wxml.contains("catchtouchmove=\"onMoontownMapTouchMove\""))
  assert_true(page.wxml.contains("bindtouchend=\"onMoontownMapTouchEnd\""))
  assert_true(!page.wxml.contains("moontown-map-backfill"))
  assert_true(page.wxml.contains("moontown-wenyu-map-image"))
  assert_true(page.wxml.contains("data-asset-id=\"moontown-wenyu-map\""))
  assert_true(page.wxml.contains("left: 958rpx; top: 776rpx;"))
  assert_true(page.wxml.contains("moontown-map-marker"))
  assert_true(page.wxml.contains("moontown-thread-pin"))
  assert_true(page.wxml.contains("moontown-topbar"))
  assert_true(page.wxml.contains("moontown-left-hud"))
  assert_true(page.wxml.contains("moontown-right-hud"))
  assert_true(page.wxml.contains("moontown-bottom-hud"))
  assert_true(page.wxml.contains("moontown-tabbar"))
  assert_true(page.wxml.contains("data-map-surface=\"true\""))
  assert_true(page.wxml.contains("First Visit"))
  assert_true(page.wxml.contains("Realm is the map"))
  assert_true(page.wxml.contains("Map Districts"))
  assert_true(page.wxml.contains("Product Market"))
  assert_true(page.wxml.contains("Discover"))
  assert_true(page.wxml.contains("Messages"))
  assert_true(!page.wxml.contains("My Town"))
  assert_true(page.wxml.contains("moontown-building-drawer"))
  assert_true(page.wxml.contains("moontown-chat-drawer"))
  assert_true(page.wxml.contains("moontown-search-drawer"))
  assert_true(page.wxml.contains("moontown-create-drawer"))
  assert_true(page.wxml.contains("data-visibility=\"private_draft\""))
  assert_true(page.wxml.contains("data-visibility=\"published\""))
  assert_true(page.wxml.contains("select-policy-hall"))
  assert_true(page.wxml.contains("ask-selected-building"))
  assert_true(page.wxml.contains("create-private-building"))
  assert_true(page.wxml.contains("create-agent"))
  assert_true(page.wxml.contains("place-published-building"))
  assert_true(page.wxml.contains("bunnia-scene-marker"))
  assert_true(page.wxml.contains("bunnia-scene-region"))
  assert_true(page.wxml.contains("bunnia-scene-thread-overlay"))
  assert_true(page.wxss.contains(".bunnia-scene"))
  assert_true(page.wxss.contains(".moontown-map-touch-area"))
  assert_true(page.wxss.contains(".moontown-map-drag-content"))
  assert_true(page.wxss.contains("transform-origin: 0 0"))
  assert_true(!page.wxss.contains(".moontown-map-backfill"))
  assert_true(page.wxss.contains(".moontown-wenyu-map-image"))
  assert_true(page.wxss.contains("width: 2800rpx; height: 1760rpx;"))
  assert_true(page.wxss.contains(".moontown-left-hud"))
  assert_true(page.wxss.contains(".moontown-right-hud"))
  assert_true(page.wxss.contains(".moontown-bottom-hud"))
  assert_true(page.wxss.contains(".moontown-tabbar"))
  assert_true(page.wxss.contains(".moontown-tab-button.active"))
  assert_true(page.js.contains("__bunniaEventPatches"))
  assert_true(page.js.contains("\"tab-realm\""))
  assert_true(page.js.contains("\"complete-onboarding\""))
  assert_true(page.js.contains("\"switch-user-a\""))
  assert_true(page.js.contains("\"switch-user-b\""))
  assert_true(page.js.contains("\"dev-login\""))
  assert_true(page.js.contains("\"load-town-snapshot\""))
  assert_true(page.js.contains("onMoontownMapTouchStart"))
  assert_true(page.js.contains("onMoontownMapTouchMove"))
  assert_true(page.js.contains("onMoontownMapTouchEnd"))
  assert_true(page.js.contains("__mc"))
  assert_true(page.js.contains("__mk"))
  assert_true(!page.js.contains("__er"))
  assert_true(page.js.contains("Math.max(0,1400-vw)"))
  assert_true(page.js.contains("Math.max(0,880-vh)"))
  assert_true(!page.js.contains("this.__cl(278-y*2,0,278)"))
  assert_true(!page.js.contains("this.__cl(2474-y*2,793,1354)"))
  assert_true(!page.js.contains("const end=840-vh"))
  assert_true(!page.js.contains("setTimeout"))
  assert_true(!page.js.contains("__moontownMapBounceTimer"))
  assert_true(!page.js.contains("padPx"))
  assert_true(!page.js.contains("const safe = { left: 155"))
  assert_true(page.js.contains("\"ask-selected-building\""))
  assert_true(page.js.contains("\"create-private-building\""))
  assert_true(page.js.contains("\"place-published-building\""))
  assert_true(page.js.contains("\"share-private-building\""))
  assert_true(page.js.contains("\"publish-private-building\""))
  assert_true(page.js.contains("\"archive-private-building\""))
  assert_true(page.plan.scene_count == 1)
  assert_true(page.plan.scene_marker_count >= 8)
  assert_true(page.plan.scene_region_count == 2)
  assert_true(page.plan.scene_asset_count == 2)
  assert_true(page.plan.windowed_list_count >= 4)
}

///|
test "moontown miniapp renders dedicated tab surfaces around the same map" {
  let projection = demo_projection()
  let realm = tab_page(projection, "realm")
  assert_true(realm.wxml.contains("moontown-map-fullscreen"))
  assert_true(realm.wxml.contains("moontown-left-hud"))
  assert_true(realm.wxml.contains("moontown-right-hud"))
  assert_true(!realm.wxml.contains("moontown-page-surface"))
  assert_true(realm.wxml.contains("data-map-surface=\"true\""))

  let discover = tab_page(projection, "discover")
  assert_true(discover.wxml.contains("moontown-map-fullscreen"))
  assert_true(discover.wxml.contains("moontown-page-surface"))
  assert_true(discover.wxml.contains("data-active-tab=\"discover\""))
  assert_true(
    discover.wxml.contains(
      "Search buildings, agents, books, events, and demands.",
    ),
  )
  assert_true(discover.wxml.contains("moontown-discover-entry"))
  assert_true(!discover.wxml.contains("moontown-right-hud"))

  let messages = tab_page(projection, "messages")
  assert_true(messages.wxml.contains("data-active-tab=\"messages\""))
  assert_true(messages.wxml.contains("Memory review needed"))
  assert_true(messages.wxml.contains("moontown-chat-drawer"))
  assert_true(!messages.wxml.contains("moontown-bottom-hud"))

  let mine = tab_page(projection, "my")
  assert_true(mine.wxml.contains("data-active-tab=\"my\""))
  assert_true(mine.wxml.contains("My Town"))
  assert_true(mine.wxml.contains("moontown-owned-entry"))
  assert_true(mine.wxml.contains("moontown-create-drawer"))
}

///|
test "moontown miniapp generates wechat project with backend hooks" {
  let project = demo_wechat_project()
  assert_eq(project.route, "pages/moontown/index")
  assert_eq(project.page_count, 1)
  assert_true(has_file(project.files, "bunnia.runtime.js"))
  assert_true(has_file(project.files, "bunnia.backend.js"))
  assert_true(
    has_file(project.files, "assets/wenyu_reference_tilemap_iso_mobile.png"),
  )
  assert_true(
    file_content(project.files, "assets/wenyu_reference_tilemap_iso_mobile.png").contains(
      "copy-file:examples/moontown_miniapp/assets/wenyu_reference_tilemap_iso_mobile.png",
    ),
  )
  assert_true(project.page.js.contains("require('../../bunnia.runtime.js')"))
  assert_true(project.page.js.contains("require('../../bunnia.backend.js')"))
  assert_true(
    file_content(project.files, "pages/moontown/index.data.js").contains(
      "\"create-private-building\"",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.backend.js").contains(
      "/miniapp/buildings/query",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.backend.js").contains(
      "/miniapp/buildings/publish",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.backend.js").contains(
      "/miniapp/buildings/share",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.backend.js").contains(
      "/miniapp/buildings/archive",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.backend.js").contains(
      "x-miniapp-session",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.backend.js").contains("bunniaSessionId"),
  )
  assert_true(
    file_content(project.files, "pages/moontown/index.data.js").contains(
      "\"mapViewport\":{\"x\":-520,\"y\":-260,\"scale\":2.6,\"style\":\"transform:translate(-520px,-260px) scale(2.6)\"",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/index.data.js").contains(
      "\"login\":{\"userId\":\"user-a\"}",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/index.data.js").contains(
      "\"shell\":{\"activeTab\":\"realm\",\"onboardingCompleted\":\"false\"}",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/index.data.js").contains(
      "\"publishDraft\":{\"buildingId\":\"created-agent-lab\"}",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/index.data.js").contains(
      "\"shareDraft\":{\"buildingId\":\"created-agent-lab\",\"targetUserId\":\"user-b\"}",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/index.data.js").contains(
      "\"archiveDraft\":{\"buildingId\":\"created-agent-lab\"}",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/index.wxml").contains(
      "data-bunnia-message=\"dev-login\"",
    ),
  )
  assert_true(project.manifest.pages[0].backend_event_count >= 3)
  assert_true(project.manifest.pages[0].scene_marker_count >= 8)
  assert_true(project.manifest.pages[0].scene_region_count == 2)
  assert_true(project.manifest.summary.contains("app_files="))
}

///|
test "moontown miniapp projection supports mock user create search and agent flows" {
  let projection = demo_projection()
  assert_eq(projection.users.length(), 2)
  assert_eq(projection.tabs.length(), 5)
  assert_eq(projection.active_tab_id, "realm")
  assert_true(projection.tabs[2].map_surface)
  assert_eq(projection.onboarding_steps.length(), 4)
  assert_eq(projection.districts.length(), 4)
  assert_eq(projection.notifications.length(), 3)
  assert_eq(unread_notifications(projection).length(), 2)
  assert_eq(projection.buildings.length(), 10)
  assert_eq(visible_buildings(projection).length(), 9)
  assert_eq(search_results(projection).length(), 1)
  assert_eq(owned_buildings(projection).length(), 1)
  let tabbed = switch_tab(projection, "discover")
  assert_eq(tabbed.active_tab_id, "discover")
  let onboarded = complete_onboarding(projection)
  assert_true(onboarded.onboarding_completed)
  let switched = switch_mock_user(projection, "user-b")
  assert_eq(switched.active_user_id, "user-b")
  assert_true(visible_buildings(switched).length() >= 8)
  let created = create_private_building(
    projection, "created-agent-lab", "Created Agent Lab",
  )
  assert_eq(created.buildings.length(), 11)
  assert_eq(created.selected_building_id, "created-agent-lab")
  let agent_created = create_agent_for_selected(
    created, "agent-created", "Created Agent",
  )
  assert_eq(agent_created.agents.length(), 4)
}

///|
test "moontown miniapp exposes pressure plans for inspect gates" {
  let patch = demo_patch_plan()
  let snapshot = demo_snapshot_delta_plan()
  let agent = demo_agent_delta_plan()
  let communication = demo_communication_plan()
  let backend = @bunnia.plan_backend_contract(demo_backend_contract())
  let effects = demo_effect_plan()
  let scene = demo_scene_render_plan()
  let surface = demo_scene_surface_plan()
  let threads = demo_scene_thread_plan()
  let assets = demo_asset_plan()
  let quality = demo_scene_visual_quality_plan()
  let inspection = demo_project_inspection()
  assert_eq(patch.patches.length(), 3)
  assert_eq(snapshot.deltas.length(), 3)
  assert_eq(agent.deltas.length(), 2)
  assert_eq(communication.total_count, 3)
  assert_eq(communication.unresolved_review_count, 1)
  assert_eq(backend.endpoint_count, 10)
  assert_eq(effects.effect_count, 10)
  assert_true(scene.marker_count >= 8)
  assert_eq(scene.region_count, 2)
  assert_true(!surface.fallback)
  assert_true(threads.total_link_count >= 8)
  assert_eq(assets.assets.length(), 2)
  assert_eq(quality.diagnostics.length(), 0)
  assert_eq(inspection.route_count, 1)
  assert_true(inspection.max_update_payload_bytes > 0)
  assert_true(inspection.max_scene_marker_count >= 4)
}

///|
fn tab_page(
  projection : MiniTownProjection,
  tab_id : String,
) -> @bunnia.WechatPage {
  @bunnia.generate_wechat_page(
    "Moontown Miniapp",
    mini_town_view(switch_tab(projection, tab_id)),
  )
}

///|
fn has_file(files : Array[@bunnia.WechatFile], path : String) -> Bool {
  for item in files {
    if item.path == path {
      return true
    }
  }
  false
}

///|
fn file_content(files : Array[@bunnia.WechatFile], path : String) -> String {
  for item in files {
    if item.path == path {
      return item.content
    }
  }
  ""
}
