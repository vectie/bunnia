///|
test "agent map demo generates wechat output" {
  let page = demo_wechat_page()
  assert_true(page.wxml.contains("Agent Map"))
  assert_true(page.wxml.contains("select-zone-b"))
  assert_true(page.wxml.contains("bunnia-scene-marker"))
  assert_true(page.wxml.contains("bunnia-scene-sprite"))
  assert_true(page.wxml.contains("bunnia-status-review"))
  assert_true(page.wxml.contains("left: 420rpx; top: 260rpx;"))
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
  assert_true(
    page.js.contains(
      "{kind:\"set\",path:\"scene.zones.zone-b.status\",value:\"running\"}",
    ),
  )
  assert_true(
    page.js.contains(
      "{kind:\"set\",path:\"review.routeReview\",value:\"approved\"}",
    ),
  )
  assert_true(page.plan.node_count > 12)
}

///|
test "agent map demo generates a mini-program file set" {
  let project = demo_wechat_project()
  assert_eq(project.files.length(), 8)
  assert_eq(project.route, "pages/index/index")
  assert_eq(project.page_count, 1)
  assert_true(project.manifest.summary.contains("app_files=7"))
  assert_true(project.summary.contains("Bunnia WeChat project"))
  assert_true(project.total_bytes > 1800)
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
  let assets = demo_asset_plan()
  let threads = demo_scene_thread_plan()
  let quality = demo_scene_visual_quality_plan()
  assert_eq(scene.layer_count, 1)
  assert_eq(scene.marker_count, 2)
  assert_eq(scene.asset_count, 1)
  assert_eq(scene.diagnostics.length(), 0)
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
