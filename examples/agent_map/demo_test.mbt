///|
test "agent map demo generates wechat output" {
  let page = demo_wechat_page()
  assert_true(page.wxml.contains("Agent Map"))
  assert_true(page.wxml.contains("select-zone-b"))
  assert_true(page.wxml.contains("bunnia-scene-marker"))
  assert_true(page.js.contains("__bunnia.lastMessage"))
  assert_true(page.plan.node_count > 12)
}

///|
test "agent map demo keeps updates as patches" {
  let patches = demo_patch_plan()
  assert_eq(patches.patches.length(), 2)
  assert_eq(patches.diagnostics.length(), 0)
  assert_true(patches.total_estimated_bytes < 128)
}
