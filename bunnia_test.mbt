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
