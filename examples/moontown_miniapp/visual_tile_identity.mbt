///|
// Semantic color and depth live here so route styles stay structural.
fn tile_identity_wxss() -> String {
  ".moontown-home-pulse { border-top: 3rpx solid #d97706; }\n" +
  ".moontown-discover-board { border-top: 0; }\n" +
  ".moontown-message-inbox, .moontown-message-review, .moontown-message-work, .moontown-my-inventory { border-top: 0; }\n" +
  ".moontown-discovery-badge.kind-kind, .moontown-object-badge.kind-category { border-color: rgba(180,83,9,0.5); background: transparent; color: #b45309; }\n" +
  ".moontown-object-badge.kind-owner { border: 1rpx solid rgba(47,133,90,0.24); background: rgba(47,133,90,0.12); color: #166534; }\n" +
  ".moontown-discovery-badge.kind-eligibility, .moontown-object-badge.kind-status { border: 1rpx solid rgba(214,158,46,0.3); background: rgba(255,244,207,0.82); color: #59450f; }\n" +
  ".moontown-discover-entry { border-left: 4rpx solid #d97706; }\n" +
  ".moontown-review-entry, .moontown-workbench-alert { border-left: 4rpx solid #d69e2e; }\n" +
  ".moontown-run-entry, .moontown-agent-result { border-left: 4rpx solid #2f855a; }\n" +
  ".moontown-owned-entry { border-left: 4rpx solid #2f855a; }\n" +
  ".moontown-tabbar { box-shadow: 0 -10rpx 28rpx rgba(69,44,16,0.08); }\n" +
  ".moontown-tab-button.active, .moontown-discovery-filter.active, .moontown-discovery-more.active, .moontown-message-channel.active, .moontown-ownership-filter.active { box-shadow: none; }\n"
}
