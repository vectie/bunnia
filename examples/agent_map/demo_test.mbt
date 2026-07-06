///|
test "agent map demo generates wechat output" {
  let page = demo_wechat_page()
  assert_true(page.wxml.contains("Agent Map"))
  assert_true(page.wxml.contains("select-zone-b"))
  assert_true(page.wxml.contains("bunnia-scene-region"))
  assert_true(page.wxml.contains("bunnia-scene-marker"))
  assert_true(page.wxml.contains("bunnia-scene-sprite"))
  assert_true(page.wxml.contains("bunnia-status-review"))
  assert_true(page.wxml.contains("bunnia-tool-result-card"))
  assert_true(page.wxml.contains("data-tool-result-id=\"route-tool-result\""))
  assert_true(page.wxml.contains("data-tool-name=\"route-inspector\""))
  assert_true(page.wxml.contains("data-bunnia-message=\"ack-route-tool\""))
  assert_true(page.wxml.contains("pan-map-east"))
  assert_true(page.wxml.contains("zoom-map-in"))
  assert_true(page.wxml.contains("data-camera-width=\"520\""))
  assert_true(page.wxml.contains("data-camera-zoom-percent=\"100\""))
  assert_true(page.wxml.contains("left: 360rpx; top: 210rpx;"))
  assert_true(page.wxml.contains("width: 240rpx; height: 180rpx;"))
  assert_true(page.wxml.contains("data-hit-width=\"44\""))
  assert_true(page.wxml.contains("data-hit-height=\"44\""))
  assert_true(page.wxml.contains("data-run-status=\"waiting-review\""))
  assert_true(page.wxml.contains("style=\"width: 720rpx; height: 520rpx;\""))
  assert_true(page.wxss.contains(".demo-shell"))
  assert_true(page.wxss.contains(".bunnia-status-running"))
  assert_true(page.wxss.contains(".bunnia-review-pending"))
  assert_true(page.js.contains("__bunnia.lastMessage"))
  assert_true(page.js.contains("__bunniaEventPatches"))
  assert_true(page.js.contains("\"select-zone-b\""))
  assert_true(page.js.contains("\"ack-route-tool\""))
  assert_true(page.js.contains("\"pan-map-east\""))
  assert_true(page.js.contains("\"zoom-map-in\""))
  assert_true(
    page.js.contains(
      "{kind:\"set\",path:\"scenes.ops-map.selectedRegion\",value:\"zone-b\"}",
    ),
  )
  assert_true(
    page.js.contains(
      "{kind:\"set\",path:\"scenes.ops-map.regions.zone-b.status\",value:\"running\"}",
    ),
  )
  assert_true(
    page.js.contains(
      "{kind:\"set\",path:\"review.routeReview\",value:\"approved\"}",
    ),
  )
  assert_true(
    page.js.contains(
      "{kind:\"set\",path:\"tool.routeToolResult\",value:\"acknowledged\"}",
    ),
  )
  assert_true(
    page.js.contains(
      "{kind:\"set\",path:\"scenes.ops-map.camera.position\",value:{\"x\":128,\"y\":96}}",
    ),
  )
  assert_true(
    page.js.contains(
      "{kind:\"set\",path:\"scenes.ops-map.camera.zoomPercent\",value:150}",
    ),
  )
  assert_true(page.plan.node_count > 12)
  assert_eq(page.plan.scene_count, 1)
  assert_eq(page.plan.scene_marker_count, 2)
  assert_eq(page.plan.scene_visible_marker_count, 2)
  assert_eq(page.plan.scene_region_count, 2)
  assert_eq(page.plan.scene_visible_region_count, 2)
  assert_eq(page.plan.scene_asset_count, 1)
  assert_eq(page.plan.degraded_scene_count, 0)
}

///|
test "agent map demo generates a mini-program file set" {
  let project = demo_wechat_project()
  assert_eq(project.files.length(), 11)
  assert_eq(project.route, "pages/index/index")
  assert_eq(project.page_count, 1)
  assert_true(project.manifest.summary.contains("app_files=10"))
  assert_true(project.page.js.contains("require('../../bunnia.runtime.js')"))
  assert_true(project.page.js.contains("require('./index.data.js')"))
  assert_true(project.page.js.contains("require('../../bunnia.backend.js')"))
  assert_true(project.page.js.contains("\"ack-route-tool\":\"ack-route-tool\""))
  assert_true(!project.page.js.contains("\"send-agent-message\""))
  assert_true(!project.page.js.contains("\"stream-route-status\""))
  assert_true(!project.page.js.contains("\"review-route\""))
  assert_true(project.page.js.contains("__bunniaMaybeRequest(this, message)"))
  assert_true(project.page.js.contains("__bunniaEventPatches"))
  assert_true(has_file(project.files, "bunnia.runtime.js"))
  assert_true(has_file(project.files, "bunnia.backend.js"))
  assert_true(has_file(project.files, "pages/index/index.data.js"))
  assert_eq(project.manifest.pages[0].scene_count, 1)
  assert_eq(project.manifest.pages[0].scene_marker_count, 2)
  assert_eq(project.manifest.pages[0].scene_visible_marker_count, 2)
  assert_eq(project.manifest.pages[0].scene_region_count, 2)
  assert_eq(project.manifest.pages[0].scene_visible_region_count, 2)
  assert_eq(project.manifest.pages[0].scene_asset_count, 1)
  assert_eq(project.manifest.pages[0].degraded_scene_count, 0)
  assert_true(
    file_content(project.files, "bunnia.manifest.json").contains(
      "\"scenes\":1,\"sceneMarkers\":2,\"sceneVisibleMarkers\":2,\"sceneRegions\":2,\"sceneVisibleRegions\":2,\"sceneAssets\":1,\"sceneAssetRefs\":[{\"route\":\"pages/index/index\",\"id\":\"zone-pin\",\"kind\":\"sprite\",\"src\":\"/assets/zone-pin.png\",\"remote\":false}]",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.manifest.json").contains(
      "\"sceneAssets\": [{\"route\":\"pages/index/index\",\"id\":\"zone-pin\",\"kind\":\"sprite\",\"src\":\"/assets/zone-pin.png\",\"remote\":false}]",
    ),
  )
  assert_true(project.summary.contains("Bunnia WeChat project"))
  assert_true(project.total_bytes > 1800)
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

///|
test "agent map demo keeps updates as patches" {
  let patches = demo_patch_plan()
  assert_eq(patches.patches.length(), 2)
  assert_eq(patches.diagnostics.length(), 0)
  assert_true(patches.total_estimated_bytes < 128)
}

///|
test "agent map demo exposes snapshot deltas" {
  let plan = demo_snapshot_delta_plan()
  assert_eq(plan.deltas.length(), 2)
  assert_eq(plan.section_update_count, 1)
  assert_eq(plan.append_item_count, 1)
  assert_eq(plan.full_snapshot_count, 0)
  assert_eq(plan.diagnostics.length(), 0)
  assert_true(plan.summary.contains("appends=1"))
}

///|
test "agent map demo exposes bounded agent deltas" {
  let plan = demo_agent_delta_plan()
  assert_eq(plan.deltas.length(), 4)
  assert_eq(plan.patch_plan.patches.length(), 4)
  assert_eq(plan.duplicate_stream_chunk_count, 0)
  assert_eq(plan.diagnostics.length(), 0)
  assert_true(plan.summary.contains("duplicate_stream_chunks=0"))
}

///|
test "agent map demo exposes communication pressure" {
  let plan = demo_communication_plan()
  assert_eq(plan.total_count, 3)
  assert_eq(plan.filtered_count, 3)
  assert_eq(plan.visible_count, 3)
  assert_eq(plan.unresolved_review_count, 1)
  assert_eq(plan.artifact_ref_count, 2)
  assert_eq(plan.diagnostics.length(), 0)
  assert_true(plan.summary.contains("unresolved_reviews=1"))
}

///|
test "agent map demo exposes tool result pressure" {
  let plan = demo_tool_result_plan()
  assert_eq(plan.total_count, 1)
  assert_eq(plan.visible_count, 1)
  assert_eq(plan.artifact_ref_count, 1)
  assert_eq(plan.pending_ack_count, 1)
  assert_eq(plan.missing_ack_count, 0)
  assert_eq(plan.diagnostics.length(), 0)
  assert_true(plan.summary.contains("pending_acks=1"))
}

///|
test "agent map demo exposes backend-derived effect pressure" {
  let backend = @bunnia.plan_backend_contract(demo_backend_contract())
  let effects = demo_effect_plan()
  assert_eq(backend.endpoint_count, 4)
  assert_eq(backend.streaming_count, 1)
  assert_eq(backend.review_required_count, 1)
  assert_eq(backend.diagnostics.length(), 0)
  assert_eq(effects.effect_count, 4)
  assert_eq(effects.stream_effect_count, 1)
  assert_eq(effects.cloud_function_count, 0)
  assert_eq(effects.diagnostics.length(), 0)
  assert_true(effects.summary.contains("effects=4"))
}

///|
test "agent map demo exposes scene profile signals" {
  let scene = demo_scene_render_plan()
  let camera = demo_scene_camera_plan()
  let assets = demo_asset_plan()
  let threads = demo_scene_thread_plan()
  let quality = demo_scene_visual_quality_plan()
  assert_eq(scene.layer_count, 2)
  assert_eq(scene.marker_count, 2)
  assert_eq(scene.region_count, 2)
  assert_eq(scene.visible_region_count, 2)
  assert_eq(scene.asset_count, 1)
  assert_eq(scene.diagnostics.length(), 0)
  assert_eq(camera.viewport.width, 520)
  assert_eq(camera.viewport.height, 360)
  assert_eq(camera.clamped, false)
  assert_eq(camera.diagnostics.length(), 0)
  assert_eq(assets.assets.length(), 1)
  assert_eq(assets.package_bytes, 2048)
  assert_eq(assets.diagnostics.length(), 0)
  assert_eq(threads.total_link_count, 2)
  assert_eq(threads.visible_link_count, 2)
  assert_eq(threads.unread_total, 2)
  assert_eq(threads.orphan_link_count, 0)
  assert_eq(threads.diagnostics.length(), 0)
  assert_eq(quality.diagnostics.length(), 0)
  assert_eq(quality.degraded, false)
}
