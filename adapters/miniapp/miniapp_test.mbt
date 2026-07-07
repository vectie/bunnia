///|
test "generic miniapp generator lowers alipay component and event names" {
  let page = generate_alipay_page(
    "Adapter Smoke",
    @core.page([
      @core.view([
        @core.button("Open", "open"),
        @core.input(name="query", input_message="search"),
      ]),
    ]),
  )
  assert_eq(page.markup_extension, "axml")
  assert_eq(page.style_extension, "acss")
  assert_true(page.markup.contains("<a:view"))
  assert_true(page.markup.contains("onTap=\"__bunniaEvent\""))
  assert_true(page.markup.contains("onInput=\"__bunniaEvent\""))
  assert_true(page.js.contains("__bunnia.lastMessage"))
  assert_eq(page.plan.event_messages.length(), 2)
}

///|
test "generic miniapp generator lowers tiktok component and event names" {
  let page = generate_tiktok_page(
    "Adapter Smoke",
    @core.page([
      @core.view([
        @core.button("Open", "open"),
        @core.form("submit", [@core.text("Submit")]),
      ]),
    ]),
  )
  assert_eq(page.markup_extension, "ttml")
  assert_eq(page.style_extension, "ttss")
  assert_true(page.markup.contains("<tt:view"))
  assert_true(page.markup.contains("bindtap=\"__bunniaEvent\""))
  assert_true(page.markup.contains("bindsubmit=\"__bunniaEvent\""))
  assert_eq(page.plan.event_messages.length(), 2)
}

///|
test "generic miniapp project packages platform file extensions" {
  let project = generate_alipay_project(
    name="Adapter Smoke",
    root=@core.page([@core.button("Open", "open")]),
  )
  assert_eq(project.platform, @core.Alipay)
  assert_eq(project.route, "pages/index/index")
  assert_eq(project.files.length(), 6)
  assert_true(miniapp_test_has_file(project.files, "app.json"))
  assert_true(miniapp_test_has_file(project.files, "app.acss"))
  assert_true(miniapp_test_has_file(project.files, "pages/index/index.axml"))
  assert_true(miniapp_test_has_file(project.files, "pages/index/index.acss"))
  assert_true(project.summary.contains("Bunnia alipay project"))
}

///|
fn miniapp_test_has_file(files : Array[MiniappFile], path : String) -> Bool {
  for item in files {
    if item.path == path {
      return true
    }
  }
  false
}
