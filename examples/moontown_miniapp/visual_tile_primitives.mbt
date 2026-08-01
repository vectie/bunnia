///|
fn tile_primitives_wxss() -> String {
  ".mt-panel { padding: 0; border: 0; border-radius: 0; background: transparent; }\n" +
  ".mt-panel-title { position: relative; display: block; padding-left: 18rpx; color: #44403c; font-size: 26rpx; line-height: 38rpx; font-weight: 800; letter-spacing: 1rpx; }\n" +
  ".mt-panel-title::before { position: absolute; left: 0; top: 7rpx; width: 6rpx; height: 24rpx; border-radius: 999rpx; background: #1f6a54; content: ''; }\n" +
  ".mt-panel-note { display: block; margin-top: 4rpx; color: #78716c; font-size: 22rpx; line-height: 32rpx; }\n" +
  "\{tile_row_selectors()} { min-width: 0; margin-top: 10rpx; padding: 16rpx; border: 1rpx solid rgba(30,86,70,0.12); border-radius: 20rpx; background: rgba(255,255,255,0.84); box-shadow: 0 3rpx 10rpx rgba(20,63,50,0.05); overflow: hidden; }\n" +
  ".moontown-profile-card, .moontown-credential-plaque { margin-top: 8rpx; padding: 20rpx; border: 1rpx solid rgba(30,86,70,0.12); border-radius: 24rpx; background: rgba(255,255,255,0.86); box-shadow: 0 4rpx 14rpx rgba(20,63,50,0.06); }\n" +
  ".moontown-page-surface text, .moontown-right-hud text { display: block; color: #57534e; font-size: 24rpx; line-height: 1.4; }\n" +
  ".moontown-page-surface button text, .moontown-right-hud button text, .moontown-topbar button text, .moontown-tabbar button text { color: inherit; }\n" +
  ".mt-title, .mt-title text { color: #292524 !important; font-size: 26rpx !important; line-height: 36rpx; font-weight: 800; white-space: normal; overflow: visible; text-overflow: clip; }\n" +
  ".mt-meta, .mt-meta text { margin-top: 2rpx; color: #78716c !important; font-size: 21rpx !important; line-height: 30rpx; }\n" +
  ".moontown-profile-status { margin: 10rpx 0; padding: 10rpx 12rpx; border-radius: 14rpx; background: #edf6f1; color: #4f6259; font-size: 22rpx; }\n" +
  ".moontown-profile-actions, .moontown-profile-metrics { display: flex; flex-direction: row; gap: 8rpx; overflow: hidden; margin-top: 8rpx; }\n" +
  ".moontown-profile-metric { flex: 1 1 0; min-width: 0; padding: 10rpx; border-radius: 14rpx; background: rgba(226,241,235,0.72); color: #4f6259; font-size: 20rpx; text-align: center; }\n" +
  "\{tile_action_row_selectors()} { display: flex; flex-direction: row; gap: 8rpx; flex-wrap: wrap; margin-top: 8rpx; }\n" +
  ".moontown-community-actions > .bunnia-list, .moontown-discovery-action > .bunnia-list, .moontown-profile-actions > .bunnia-list, .moontown-run-actions > .bunnia-list, .moontown-object-primary-actions > .bunnia-list { display: flex; flex: 1 1 100%; flex-direction: row; gap: 8rpx; flex-wrap: wrap; min-width: 0; width: 100%; }\n" +
  "\{tile_action_button_selectors()} { flex: 1 1 0; min-width: 112rpx; }\n" +
  ".moontown-run-action, .bunnia-tool-result-action { flex: 0 0 auto; }\n" +
  ".moontown-discovery-badges, .moontown-object-badges { display: flex; gap: 6rpx; flex-wrap: wrap; margin-top: 6rpx; }\n" +
  ".moontown-discovery-badge, .moontown-object-badge { min-height: 34rpx; padding: 3rpx 9rpx; border: 1rpx solid currentColor; border-radius: 8rpx; background: transparent; font-size: 18rpx; line-height: 28rpx; font-weight: 800; letter-spacing: 1rpx; white-space: normal; }\n"
}
