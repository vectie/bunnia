///|
test "agent map demo generates wechat output" {
  let page = demo_wechat_page()
  assert_true(page.wxml.contains("Agent Map"))
  assert_true(page.wxml.contains("select-zone-b"))
  assert_true(page.wxml.contains("bunnia-scene-marker"))
  assert_true(page.wxml.contains("bunnia-status-review"))
  assert_true(page.wxml.contains("style=\"left: 420rpx; top: 260rpx;\""))
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
  assert_eq(project.files.length(), 7)
  assert_eq(project.route, "pages/index/index")
  assert_eq(project.page_count, 1)
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
test "agent map demo exposes scene profile signals" {
  let scene = demo_scene_render_plan()
  assert_eq(scene.layer_count, 1)
  assert_eq(scene.marker_count, 2)
  assert_eq(scene.asset_count, 0)
  assert_eq(scene.diagnostics.length(), 0)
}
