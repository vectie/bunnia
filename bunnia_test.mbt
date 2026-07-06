///|
test "bunnia builds platform-neutral node trees" {
  let root = @bunnia.page([
    @bunnia.view_with_attrs([@bunnia.class_name("dashboard-shell")], [
      @bunnia.text("Demo Dashboard"),
      @bunnia.button("Open Detail", "open-detail"),
    ]),
  ])
  assert_eq(@bunnia.node_count(root), 5)
  let plan = @bunnia.plan(root, @bunnia.wechat())
  assert_eq(plan.root_kind, "page")
  assert_eq(plan.node_count, 5)
  assert_true(plan.component_kinds.contains("button"))
  assert_true(plan.event_messages.contains("open-detail"))
}

///|
test "bunnia keeps mini-app platform adapters separate" {
  let wechat = @bunnia.adapter(@bunnia.wechat())
  let alipay = @bunnia.adapter(@bunnia.alipay())
  let tiktok = @bunnia.adapter(@bunnia.tiktok())
  assert_eq(wechat.tap_event, "bindtap")
  assert_eq(alipay.tap_event, "onTap")
  assert_eq(tiktok.component_prefix, "tt:")
}

///|
test "bunnia exposes shared budget profiles" {
  assert_eq(@bunnia.is_named_budget_profile("tight"), true)
  assert_eq(@bunnia.is_named_budget_profile("unknown"), false)
  let render = @bunnia.render_budget_for_profile("tight")
  assert_eq(render.max_nodes, 128)
  assert_eq(render.max_scene_markers, 64)
  let wechat = @bunnia.wechat_build_budget_for_profile("tight")
  assert_eq(wechat.max_files, 16)
  assert_eq(wechat.max_page_first_screen_bytes, 24576)
}
