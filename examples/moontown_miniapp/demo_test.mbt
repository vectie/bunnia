///|
test "moontown miniapp generates full vertical slice page" {
  let page = demo_wechat_page()
  assert_true(page.wxml.contains("Moontown"))
  assert_true(page.wxml.contains("moontown-map-fullscreen"))
  assert_true(page.wxml.contains("movable-area"))
  assert_true(page.wxml.contains("moontown-map-drag-area"))
  assert_true(page.wxml.contains("movable-view"))
  assert_true(page.wxml.contains("moontown-map-drag-content"))
  assert_true(page.wxml.contains("moontown-map-backfill"))
  assert_true(page.wxml.contains("direction=\"all\""))
  assert_true(page.wxml.contains("inertia=\"true\""))
  assert_true(page.wxml.contains("x=\"-360\""))
  assert_true(page.wxml.contains("y=\"-160\""))
  assert_true(page.wxml.contains("moontown-wenyu-map-image"))
  assert_true(page.wxml.contains("data-asset-id=\"moontown-wenyu-map\""))
  assert_true(page.wxml.contains("left: 958rpx; top: 776rpx;"))
  assert_true(page.wxml.contains("moontown-map-marker"))
  assert_true(page.wxml.contains("moontown-thread-pin"))
  assert_true(page.wxml.contains("moontown-topbar"))
  assert_true(page.wxml.contains("moontown-right-hud"))
  assert_true(page.wxml.contains("moontown-bottom-hud"))
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
  assert_true(page.wxss.contains(".moontown-map-drag-area"))
  assert_true(page.wxss.contains(".moontown-map-drag-content"))
  assert_true(page.wxss.contains(".moontown-map-backfill"))
  assert_true(page.wxss.contains("background: #6f9278"))
  assert_true(page.wxss.contains(".moontown-wenyu-map-image"))
  assert_true(page.wxss.contains("width: 2800rpx; height: 1760rpx;"))
  assert_true(page.wxss.contains(".moontown-right-hud"))
  assert_true(page.wxss.contains(".moontown-bottom-hud"))
  assert_true(page.js.contains("__bunniaEventPatches"))
  assert_true(page.js.contains("\"switch-user-a\""))
  assert_true(page.js.contains("\"switch-user-b\""))
  assert_true(page.js.contains("\"dev-login\""))
  assert_true(page.js.contains("\"load-town-snapshot\""))
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
  assert_true(page.plan.windowed_list_count >= 2)
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
      "\"login\":{\"userId\":\"user-a\"}",
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
  assert_eq(projection.buildings.length(), 10)
  assert_eq(visible_buildings(projection).length(), 9)
  assert_eq(search_results(projection).length(), 1)
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
