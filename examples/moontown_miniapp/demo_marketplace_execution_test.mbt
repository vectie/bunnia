///|
test "messages exposes the marketplace request decision to MoonClaw receipt loop" {
  let page = tab_page(demo_projection(), "messages")
  let project = demo_wechat_project()
  let messages_js = file_content(project.files, "pages/moontown/messages.js")
  let backend_js = file_content(project.files, "bunnia.backend.js")
  assert_true(page.wxml.contains("Marketplace work requests"))
  assert_true(page.wxml.contains("Approve &amp; queue"))
  assert_true(page.wxml.contains("Retry handoff"))
  assert_true(page.wxml.contains("gpt-5.6-sol"))
  assert_true(page.wxml.contains("load-marketplace-action-requests"))
  assert_true(page.wxml.contains("decide-marketplace-action-request"))
  assert_true(page.wxml.contains("retry-marketplace-action-handoff"))
  assert_true(
    backend_contract_contains(
      demo_backend_contract(),
      "decide-marketplace-action-request",
      "/miniapp/marketplace/action-requests/decision",
    ),
  )
  assert_true(messages_js.contains("__moontownSafeActionRequest"))
  assert_true(messages_js.contains("marketplaceActionRequests.items"))
  for route in [
    "/miniapp/marketplace/action-requests",
    "/miniapp/marketplace/action-requests/decision",
    "/miniapp/marketplace/action-requests/retry-handoff",
  ] {
    assert_true(backend_js.contains(route))
  }
}
