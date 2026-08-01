///|
// Semantic color and depth live here so route styles stay structural.
fn tile_identity_wxss() -> String {
  ".moontown-home-pulse { border-top: 3rpx solid #2f7f68; }\n" +
  ".moontown-discover-board { border-top: 0; }\n" +
  ".moontown-message-inbox, .moontown-message-review, .moontown-message-work, .moontown-my-inventory { border-top: 0; }\n" +
  ".moontown-discovery-badge.kind-kind, .moontown-object-badge.kind-category { border-color: rgba(31,106,84,0.5); background: transparent; color: #1f6a54; }\n" +
  ".moontown-object-badge.kind-owner { border: 1rpx solid rgba(47,133,90,0.24); background: rgba(47,133,90,0.12); color: #166534; }\n" +
  ".moontown-discovery-badge.kind-eligibility, .moontown-object-badge.kind-status { border: 1rpx solid rgba(91,111,199,0.3); background: rgba(238,242,255,0.86); color: #38458a; }\n" +
  ".moontown-discover-entry { border-left: 4rpx solid #2f7f68; }\n" +
  ".moontown-review-entry, .moontown-workbench-alert { border-left: 4rpx solid #5b6fc7; }\n" +
  ".moontown-run-entry, .moontown-agent-result { border-left: 4rpx solid #2f855a; }\n" +
  ".moontown-owned-entry { border-left: 4rpx solid #2f855a; }\n" +
  ".moontown-tabbar { box-shadow: 0 -10rpx 28rpx rgba(20,63,50,0.08); }\n" +
  ".moontown-tab-button.active, .moontown-discovery-filter.active, .moontown-discovery-more.active, .moontown-message-channel.active, .moontown-ownership-filter.active { box-shadow: none; }\n"
}
