///|
test "moontown miniapp generated page keeps tile visual system stable" {
  let page = demo_wechat_page()
  assert_true(page.wxss.contains(".bunnia-scene"))
  assert_true(page.wxss.contains(".moontown-map-touch-area"))
  assert_true(page.wxss.contains(".moontown-map-drag-content"))
  assert_true(page.wxss.contains("transform-origin:0 0"))
  assert_true(!page.wxss.contains(".moontown-map-backfill"))
  assert_true(page.wxss.contains(".moontown-wenyu-map-image"))
  assert_true(page.wxss.contains("width:2800rpx;height:1760rpx"))
  assert_true(!page.wxss.contains(".moontown-left-hud"))
  assert_true(page.wxss.contains(".moontown-right-hud"))
  assert_true(!page.wxss.contains(".moontown-bottom-hud"))
  assert_true(page.wxss.contains(".moontown-map-marker.selected"))
  assert_true(page.wxss.contains(".moontown-object-title"))
  assert_true(page.wxss.contains(".moontown-place-facts"))
  assert_true(page.wxss.contains(".moontown-chat-avatar"))
  assert_true(page.wxss.contains(".moontown-chat-unread-dot"))
  assert_true(
    page.wxss.contains(".moontown-home-pulse{border-top:3rpx solid #2563eb"),
  )
  assert_true(
    page.wxss.contains(
      ".moontown-discovery-badge.kind-kind,.moontown-object-badge.kind-category",
    ),
  )
  assert_true(
    page.wxss.contains(
      ".moontown-review-entry,.moontown-workbench-alert{border-left:4rpx solid #d69e2e",
    ),
  )
  assert_true(
    page.wxss.contains("white-space:normal;overflow:visible;text-overflow:clip"),
  )
  assert_true(page.wxss.contains("max-height:36vh"))
  assert_true(page.wxss.contains("max-height:72vh"))
  assert_true(page.wxss.contains("overscroll-behavior:contain"))
  assert_true(page.wxss.contains(".moontown-tabbar"))
  assert_true(page.wxss.contains(".moontown-tab-button.active"))
  assert_true(page.wxss.contains(".moontown-passport-entry"))
  assert_true(page.wxss.contains(".moontown-entry-button"))
  assert_true(page.wxss.contains(".moontown-tab-button.map-surface"))
  assert_true(page.wxss.contains("font-size:26rpx"))
  assert_true(page.wxss.contains("font-size:22rpx"))
  assert_true(page.wxss.contains("background:#f1f5f4"))
  assert_true(!page.wxss.contains(".moontown-user-switcher"))
  assert_true(!page.wxml.contains("Passport: Ada Builder"))
  assert_true(page.wxml.contains("Enter Town"))
  assert_true(page.wxml.contains("data-bunnia-message=\"tab-my\""))
  assert_true(!page.wxml.contains("data-bunnia-message=\"switch-user-a\""))
  assert_true(!page.wxml.contains("data-bunnia-message=\"switch-user-b\""))
  assert_true(!page.wxml.contains("<text>Ada</text>"))
  assert_true(!page.wxml.contains("<text>Bo</text>"))
  assert_true(!page.wxss.contains(".moontown-guide-step"))
  assert_true(page.wxss.contains("env(safe-area-inset-top)"))
  assert_true(page.wxss.contains("env(safe-area-inset-bottom)"))
  assert_true(page.wxss.contains("button:active{opacity:0.82"))
  assert_true(!page.wxss.contains("button:active{transform"))
  assert_true(
    page.wxss.contains("button[disabled],.bunnia-status-disabled{opacity:0.52"),
  )
  assert_true(page.wxss.contains("min-height:88rpx"))
  assert_true(page.wxss.contains("overflow-wrap:anywhere"))
  assert_true(!page.wxss.contains("box-shadow:0 2rpx 0"))
  assert_true(
    page.wxss.contains(
      ".bunnia-status-review,.bunnia-status-pending,.bunnia-status-stale,.bunnia-status-waiting",
    ),
  )
}
