///|
// Semantic color and depth live here so route styles stay structural.
fn tile_identity_wxss() -> String {
  ".moontown-home-pulse { border-top: 3rpx solid #e11d48; }\n" +
  ".moontown-discover-board { border-top: 3rpx solid #2563eb; }\n" +
  ".moontown-message-inbox, .moontown-message-review { border-top: 3rpx solid #d69e2e; }\n" +
  ".moontown-message-work, .moontown-my-inventory { border-top: 3rpx solid #2f855a; }\n" +
  ".moontown-discovery-badge.kind-kind, .moontown-object-badge.kind-category { border: 1rpx solid rgba(37,99,235,0.24); background: rgba(37,99,235,0.12); color: #1d4ed8; }\n" +
  ".moontown-object-badge.kind-owner { border: 1rpx solid rgba(47,133,90,0.24); background: rgba(47,133,90,0.12); color: #166534; }\n" +
  ".moontown-discovery-badge.kind-eligibility, .moontown-object-badge.kind-status { border: 1rpx solid rgba(214,158,46,0.3); background: rgba(255,244,207,0.82); color: #59450f; }\n" +
  ".moontown-discover-entry { border-left: 4rpx solid #2563eb; }\n" +
  ".moontown-review-entry, .moontown-workbench-alert { border-left: 4rpx solid #d69e2e; }\n" +
  ".moontown-run-entry, .moontown-agent-result { border-left: 4rpx solid #2f855a; }\n" +
  ".moontown-notice-entry { border-left: 4rpx solid #e11d48; }\n" +
  ".moontown-owned-entry { border-left: 4rpx solid #2f855a; }\n" +
  ".moontown-tabbar { box-shadow: 0 8rpx 24rpx rgba(15,23,42,0.3); }\n" +
  ".moontown-tab-button.active, .moontown-discovery-filter.active, .moontown-message-channel.active, .moontown-ownership-filter.active { box-shadow: inset 0 -4rpx 0 rgba(255,255,255,0.46); }\n"
}
