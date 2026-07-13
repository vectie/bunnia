///|
fn tile_primitives_wxss() -> String {
  ".mt-panel { padding: 20rpx; border: 0; border-bottom: 1rpx solid #dbe3df; border-radius: 0; background: #ffffff; }\n" +
  ".mt-panel-title { display: block; color: #17221b; font-size: 30rpx; line-height: 40rpx; font-weight: 800; }\n" +
  ".mt-panel-note { display: block; margin-top: 4rpx; color: #526158; font-size: 24rpx; line-height: 34rpx; }\n" +
  "\{tile_row_selectors()} { min-width: 0; margin-top: 10rpx; padding: 14rpx; border: 1rpx solid #dbe3df; border-radius: 6rpx; background: #ffffff; overflow: hidden; }\n" +
  ".moontown-profile-card, .moontown-credential-plaque { margin-top: 8rpx; padding: 18rpx; border: 1rpx solid #dbe3df; border-radius: 8rpx; background: #ffffff; }\n" +
  ".moontown-page-surface text, .moontown-right-hud text { display: block; color: #405047; font-size: 26rpx; line-height: 1.4; }\n" +
  ".moontown-page-surface button text, .moontown-right-hud button text, .moontown-topbar button text, .moontown-tabbar button text { color: inherit; }\n" +
  ".mt-title, .mt-title text { color: #17221b !important; font-size: 28rpx !important; line-height: 38rpx; font-weight: 800; white-space: normal; overflow: visible; text-overflow: clip; }\n" +
  ".mt-meta, .mt-meta text { margin-top: 2rpx; color: #647168 !important; font-size: 22rpx !important; line-height: 32rpx; }\n" +
  ".moontown-profile-status { margin: 10rpx 0; padding: 10rpx 12rpx; border-radius: 6rpx; background: #eef4ff; color: #334538; font-size: 24rpx; }\n" +
  ".moontown-profile-actions, .moontown-profile-metrics { display: flex; flex-direction: row; gap: 8rpx; overflow: hidden; margin-top: 8rpx; }\n" +
  ".moontown-profile-metric { flex: 1 1 0; min-width: 0; padding: 10rpx; border-radius: 6rpx; background: #eef2f4; color: #334538; font-size: 22rpx; }\n" +
  "\{tile_action_row_selectors()} { display: flex; flex-direction: row; gap: 8rpx; flex-wrap: wrap; margin-top: 8rpx; }\n" +
  ".moontown-community-actions > .bunnia-list, .moontown-discovery-action > .bunnia-list, .moontown-profile-actions > .bunnia-list, .moontown-run-actions > .bunnia-list, .moontown-object-primary-actions > .bunnia-list { display: flex; flex: 1 1 100%; flex-direction: row; gap: 8rpx; flex-wrap: wrap; min-width: 0; width: 100%; }\n" +
  "\{tile_action_button_selectors()} { flex: 1 1 0; min-width: 112rpx; }\n" +
  ".moontown-run-action, .bunnia-tool-result-action { flex: 0 0 auto; }\n" +
  ".moontown-discovery-badges, .moontown-object-badges { display: flex; gap: 6rpx; flex-wrap: wrap; margin-top: 6rpx; }\n" +
  ".moontown-discovery-badge, .moontown-object-badge { min-height: 38rpx; padding: 4rpx 8rpx; border-radius: 6rpx; background: #eef2f4; font-size: 22rpx; line-height: 30rpx; white-space: normal; }\n"
}
