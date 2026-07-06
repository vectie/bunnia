///|
test "push unique keeps render plan component lists compact" {
  let root = page([view([text("A"), text("B")]), view([text("C")])])
  let render = plan(root, wechat())
  assert_eq(render.component_kinds.length(), 3)
  assert_true(render.component_kinds.contains("page"))
  assert_true(render.component_kinds.contains("view"))
  assert_true(render.component_kinds.contains("text"))
}
