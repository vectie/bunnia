///|
fn tile_primitives_wxss() -> String {
  ".mt-panel { padding: 14rpx; border: 1rpx solid rgba(255,255,255,0.46); border-radius: 8rpx; background: rgba(248, 250, 252, 0.9); }\n" +
  ".mt-panel-title { display: block; color: #203222; font-size: 24rpx; line-height: 32rpx; font-weight: 800; }\n" +
  ".mt-panel-note { display: block; margin-top: 4rpx; color: #53624e; font-size: 18rpx; line-height: 26rpx; }\n" +
  "\{tile_row_selectors()} { min-width: 0; margin-top: 8rpx; padding: 10rpx; border: 1rpx solid rgba(51,65,55,0.16); border-radius: 6rpx; background: rgba(239,246,255,0.78); box-shadow: 0 2rpx 0 rgba(31,49,36,0.08); overflow: hidden; }\n" +
  ".moontown-profile-card, .moontown-credential-plaque { margin-top: 8rpx; padding: 12rpx; border: 1rpx solid rgba(51,65,55,0.16); border-radius: 6rpx; background: rgba(255,255,255,0.66); }\n" +
  ".moontown-page-surface text, .moontown-right-hud text { display: block; color: #405244; font-size: 18rpx; line-height: 1.28; }\n" +
  ".mt-title, .mt-title text { color: #1f3327 !important; font-size: 20rpx !important; line-height: 28rpx; font-weight: 800; white-space: normal; overflow: visible; text-overflow: clip; }\n" +
  ".mt-meta, .mt-meta text { margin-top: 2rpx; color: #6b745f !important; font-size: 16rpx !important; }\n" +
  ".moontown-profile-status { margin: 8rpx 0; padding: 8rpx 10rpx; border-radius: 6rpx; background: rgba(225,29,72,0.12); color: #334538; font-size: 18rpx; }\n" +
  ".moontown-profile-actions, .moontown-profile-metrics { display: flex; flex-direction: row; gap: 8rpx; overflow: hidden; margin-top: 8rpx; }\n" +
  ".moontown-profile-metric { flex: 1 1 0; min-width: 0; padding: 8rpx; border-radius: 6rpx; background: rgba(37,99,235,0.1); color: #334538; font-size: 18rpx; }\n" +
  "\{tile_action_row_selectors()} { display: flex; flex-direction: row; gap: 8rpx; flex-wrap: wrap; margin-top: 8rpx; }\n" +
  "\{tile_action_button_selectors()} { flex: 1 1 0; min-width: 112rpx; }\n" +
  ".moontown-run-action, .bunnia-tool-result-action { flex: 0 0 auto; }\n" +
  ".moontown-discovery-badges, .moontown-object-badges { display: flex; gap: 6rpx; flex-wrap: wrap; margin-top: 6rpx; }\n" +
  ".moontown-discovery-badge, .moontown-object-badge { min-height: 32rpx; padding: 4rpx 8rpx; border-radius: 6rpx; background: rgba(37,99,235,0.1); font-size: 16rpx; line-height: 24rpx; white-space: normal; }\n"
}
