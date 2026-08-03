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
  assert_true(page.wxml.contains("data-request-id=\"{{item.requestId}}\""))
  assert_true(page.wxml.contains("data-expected-version=\"{{item.version}}\""))
  assert_true(
    backend_contract_contains(
      demo_backend_contract(),
      "decide-marketplace-action-request",
      "/miniapp/marketplace/action-requests/decision",
    ),
  )
  assert_true(messages_js.contains("__moontownSafeActionRequest"))
  assert_true(messages_js.contains("marketplaceActionRequests.items"))
  assert_true(messages_js.contains("max_cost_micro_usd:String("))
  assert_true(messages_js.contains("max_runtime_ms:String("))
  assert_true(messages_js.contains("max_tokens:String("))
  for
    route in [
      "/miniapp/marketplace/action-requests", "/miniapp/marketplace/action-requests/decision",
      "/miniapp/marketplace/action-requests/retry-handoff",
    ] {
    assert_true(backend_js.contains(route))
  }
}

///|
test "discover exposes an independent publication review queue" {
  let project = demo_wechat_project()
  let discover = file_content(project.files, "pages/moontown/discover.wxml")
  let discover_js = file_content(project.files, "pages/moontown/discover.js")
  let backend_js = file_content(project.files, "bunnia.backend.js")
  assert_true(discover.contains("Independent review"))
  assert_true(discover.contains("load-marketplace-review-queue"))
  assert_true(discover.contains("Approve &amp; publish"))
  assert_true(discover.contains("name=\"targetState\" value=\"published\""))
  assert_true(discover_js.contains("__moontownSafeReviewListing"))
  assert_true(discover_js.contains("marketplaceReviewQueue.items"))
  assert_true(
    backend_contract_contains(
      demo_backend_contract(),
      "load-marketplace-review-queue",
      "/miniapp/marketplace/review-queue",
    ),
  )
  assert_true(backend_js.contains("/miniapp/marketplace/review-queue"))
}
