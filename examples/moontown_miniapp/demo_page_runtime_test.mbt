///|
test "moontown miniapp generated page keeps runtime and plan budgets stable" {
  let page = demo_wechat_page()
  assert_true(page.wxml.contains("moontown-chat-drawer"))
  assert_true(
    !page.wxml.contains("data-backend-endpoint=\"send-building-message\""),
  )
  assert_true(
    !page.wxml.contains("data-backend-path=\"/miniapp/messages/send\""),
  )
  assert_true(page.wxml.contains("3 updates from this place"))
  assert_true(
    !page.wxml.contains(
      "runtime: {{backendStatus.send_building_message.state || 'idle'}}",
    ),
  )
  assert_true(
    page.wxml.contains("data-bunnia-message=\"send-building-message\""),
  )
  assert_true(!page.wxml.contains("moontown-search-drawer"))
  assert_true(!page.wxml.contains("moontown-create-drawer"))
  assert_true(!page.wxml.contains("moontown-map-state-strip"))
  assert_true(page.wxml.contains("moontown-place-facts"))
  assert_true(page.wxml.contains("data-place-fact=\"work\""))
  assert_true(!page.wxml.contains("moontown-map-action-rail"))
  assert_true(page.wxml.contains("moontown-object-primary-actions"))
  assert_true(page.wxml.contains("Find Similar"))
  assert_true(!page.wxml.contains("data-visibility=\"private_draft\""))
  assert_true(!page.wxml.contains("data-visibility=\"published\""))
  assert_true(page.wxml.contains("select-policy-hall"))
  assert_true(page.wxml.contains("ask-selected-building"))
  assert_true(!page.wxml.contains("create-private-building"))
  assert_true(!page.wxml.contains("create-agent"))
  assert_true(page.wxml.contains("place-published-building"))
  assert_true(page.wxml.contains("bunnia-scene-marker"))
  assert_true(page.wxml.contains("bunnia-scene-region"))
  assert_true(page.wxml.contains("bunnia-scene-thread-overlay"))
  assert_true(page.js.contains("__bunniaEventPatches"))
  assert_true(page.js.contains("\"tab-realm\""))
  assert_true(!page.js.contains("\"complete-onboarding\""))
  assert_true(!page.js.contains("\"switch-user-a\""))
  assert_true(!page.js.contains("\"switch-user-b\""))
  assert_true(page.js.contains("\"dev-login\""))
  assert_true(!page.js.contains("\"enter-town\""))
  assert_true(page.js.contains("onMoontownMapTouchStart"))
  assert_true(page.js.contains("onMoontownMapTouchMove"))
  assert_true(page.js.contains("onMoontownMapTouchEnd"))
  assert_true(page.js.contains("__mc"))
  assert_true(page.js.contains("__mk"))
  assert_true(!page.js.contains("__er"))
  assert_true(page.js.contains("Math.max(0,1400-vw)"))
  assert_true(page.js.contains("Math.max(0,880-vh)"))
  assert_true(!page.js.contains("this.__cl(278-y*2,0,278)"))
  assert_true(!page.js.contains("this.__cl(2474-y*2,793,1354)"))
  assert_true(!page.js.contains("const end=840-vh"))
  assert_true(!page.js.contains("setTimeout"))
  assert_true(!page.js.contains("__moontownMapBounceTimer"))
  assert_true(!page.js.contains("padPx"))
  assert_true(!page.js.contains("const safe = { left: 155"))
  assert_true(page.js.contains("\"ask-selected-building\""))
  assert_true(page.js.contains("\"place-published-building\""))
  assert_true(!page.js.contains("\"share-private-building\""))
  assert_true(!page.js.contains("\"publish-private-building\""))
  assert_true(!page.js.contains("\"archive-private-building\""))
  assert_true(
    !page.wxml.contains("data-bunnia-message=\"restore-archived-building\""),
  )
  assert_true(!page.js.contains("\"restore-archived-building\""))
  assert_true(page.plan.scene_count == 1)
  assert_true(page.plan.scene_marker_count >= 8)
  assert_true(page.plan.scene_region_count == 2)
  assert_true(page.plan.scene_asset_count == 2)
  assert_true(page.plan.windowed_list_count >= 5)
}
