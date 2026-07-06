///|
test "wenyu proof slice generates wechat output from projection" {
  let page = demo_wechat_page()
  assert_true(page.wxml.contains("Wenyu Overview"))
  assert_true(page.wxml.contains("data-projection-id=\"wenyu-overview\""))
  assert_true(page.wxml.contains("data-building-id=\"building-dock\""))
  assert_true(page.wxml.contains("bunnia-list-windowed"))
  assert_true(page.wxml.contains("data-total-count=\"4\""))
  assert_true(page.wxml.contains("data-viewport-width=\"640\""))
  assert_true(page.wxml.contains("data-markers-total=\"4\""))
  assert_true(page.wxml.contains("data-markers-visible=\"4\""))
  assert_true(page.wxml.contains("select-building-dock"))
  assert_true(page.wxml.contains("bunnia-scene-marker"))
  assert_true(page.wxml.contains("bunnia-scene-sprite"))
  assert_true(page.wxml.contains("bunnia-communication-review-request"))
  assert_true(page.js.contains("\"submit-operator-request\""))
  assert_true(
    page.js.contains(
      "{kind:\"set\",path:\"backend.submit-operator.state\",value:\"loading\"}",
    ),
  )
  assert_true(page.plan.node_count > 35)
}

///|
test "wenyu proof slice generates a separate mini-program route" {
  let project = demo_wechat_project()
  assert_eq(project.files.length(), 8)
  assert_eq(project.route, "pages/wenyu/index")
  assert_eq(project.page_count, 1)
  assert_eq(project.manifest.entry_route, "pages/wenyu/index")
  assert_eq(project.manifest.pages[0].windowed_list_count, 1)
  assert_eq(project.manifest.pages[0].list_total_count, 4)
  assert_eq(project.manifest.pages[0].list_visible_count, 4)
  assert_true(project.report.total_bytes == project.total_bytes)
  assert_eq(project.report.diagnostics.length(), 0)
  assert_true(project.page.json.contains("Wenyu Overview"))
}

///|
test "wenyu proof slice keeps updates and assets bounded" {
  let patches = demo_patch_plan()
  let asset_plan = demo_asset_plan()
  let backend = @bunnia.plan_backend_contract(demo_backend_contract())
  let scene = demo_scene_render_plan()
  assert_eq(patches.patches.length(), 2)
  assert_true(patches.total_estimated_bytes < 128)
  assert_eq(asset_plan.assets.length(), 1)
  assert_eq(asset_plan.package_bytes, 4096)
  assert_eq(asset_plan.diagnostics.length(), 0)
  assert_eq(backend.endpoint_count, 4)
  assert_eq(backend.review_required_count, 2)
  assert_eq(scene.marker_count, 4)
  assert_eq(scene.visible_marker_count, 4)
  assert_eq(scene.asset_count, 1)
  assert_eq(scene.diagnostics.length(), 0)
}

///|
test "wenyu proof slice documents migration and large fixture shape" {
  let projection = large_projection(32)
  let root = overview_view(projection)
  let render = @bunnia.plan(root, @bunnia.wechat())
  assert_eq(projection.buildings.length(), 32)
  assert_eq(render.windowed_list_count, 1)
  assert_eq(render.list_total_count, 32)
  assert_eq(render.list_visible_count, 12)
  assert_true(render.event_messages.contains("select-building-0"))
  assert_true(demo_projection_json().contains("\"building-dock\""))
  assert_true(migration_notes().length() >= 5)
  assert_true(migration_notes()[4].contains("building card"))
}

///|
test "wenyu proof slice exposes large scene pressure" {
  let scene = large_scene_render_plan(320)
  assert_eq(scene.marker_count, 320)
  assert_eq(scene.visible_marker_count, 48)
  assert_eq(@bunnia.scene_quality_id(scene.quality), "full")
  assert_eq(scene.diagnostics.length(), 0)
  assert_true(scene.summary.contains("markers=48/320"))
}
