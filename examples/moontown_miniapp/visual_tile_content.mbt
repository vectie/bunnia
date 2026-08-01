///|
fn tile_content_wxss() -> String {
  ".moontown-section-label { position: relative; margin-top: 18rpx; padding-left: 18rpx; color: #44403c; font-size: 24rpx; font-weight: 800; }\n" +
  ".moontown-section-label::before { position: absolute; left: 0; top: 5rpx; width: 6rpx; height: 24rpx; border-radius: 999rpx; background: #1f6a54; content: ''; }\n" +
  ".moontown-primary-action { border-color: #1f6a54; background: #1f6a54; color: #f7fbf8; font-weight: 800; }\n" +
  ".moontown-secondary-action { background: rgba(231,229,228,0.72); color: #57534e; }\n" +
  ".moontown-danger-action { color: #9f1239; font-weight: 700; }\n" +
  ".moontown-home-pulse { padding: 20rpx; border: 1rpx solid rgba(30,86,70,0.12); border-radius: 24rpx; background: linear-gradient(135deg,#f7fbf8,#edf6f1); box-shadow: 0 4rpx 14rpx rgba(20,63,50,0.06); }\n" +
  ".moontown-home-lead { margin-top: 0; padding: 16rpx; border: 1rpx solid rgba(31,106,84,0.16); border-radius: 18rpx; background: rgba(255,255,255,0.7); }\n" +
  ".moontown-home-lead .mt-title, .moontown-home-lead .mt-title text { font-size: 30rpx !important; line-height: 40rpx; white-space: normal; overflow: visible; text-overflow: clip; }\n" +
  ".moontown-home-lead button { width: 100%; margin-top: 12rpx; }\n" +
  ".moontown-home-stats { display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 10rpx; margin-top: 12rpx; }\n" +
  ".moontown-home-stat { min-width: 0; padding-top: 10rpx; border-top: 3rpx solid #2f7f68; color: #66766e; font-size: 20rpx; }\n" +
  ".moontown-home-stat-value { color: #292524; font-size: 30rpx; font-weight: 800; }\n" +
  ".moontown-district-grid .bunnia-list-windowed { display: grid; grid-template-columns: repeat(2,minmax(0,1fr)); gap: 10rpx; margin-top: 10rpx; }\n" +
  ".moontown-district-entry { display: flex; flex-direction: column; align-items: stretch; min-height: 210rpx; margin-top: 0; border: 1rpx solid rgba(30,86,70,0.12); border-radius: 20rpx; background: rgba(255,255,255,0.84) !important; }\n" +
  ".moontown-district-entry > .moontown-district-actions { margin-top: auto; padding-top: 10rpx; }\n" +
  ".moontown-district-entry > .moontown-district-actions button { width: 100%; min-width: 0; min-height: 68rpx; }\n" +
  ".moontown-district-actions { display: flex; gap: 8rpx; margin-top: 8rpx; }\n" +
  ".moontown-presence-row .bunnia-list-windowed { display: flex; flex-direction: row; gap: 8rpx; overflow-x: auto; overflow-y: hidden; }\n" +
  ".moontown-presence-chip { flex: 0 0 176rpx; min-width: 0; border-radius: 20rpx; background: rgba(255,255,255,0.8); }\n" +
  ".moontown-attention-rows .bunnia-list-windowed { display: flex; flex-direction: column; gap: 8rpx; margin-top: 8rpx; overflow: hidden; }\n" +
  ".moontown-onboarding-compact .moontown-primary-action { width: 100%; margin-top: 10rpx; }\n" +
  ".moontown-discovery-search { display: grid; grid-template-columns: minmax(0, 1fr) auto; gap: 8rpx; align-items: stretch; margin-top: 10rpx; }\n" +
  ".mt-panel .moontown-discovery-search input { margin-top: 0; }\n" +
  ".moontown-discovery-primary-filters { display: grid; grid-template-columns: repeat(4, minmax(0, 1fr)); gap: 8rpx; margin-top: 12rpx; }\n" +
  ".moontown-discovery-primary-filters button { min-width: 0; padding-left: 6rpx; padding-right: 6rpx; }\n" +
  ".moontown-discovery-more-panel { margin-top: 10rpx; padding: 12rpx; border: 1rpx solid rgba(30,86,70,0.12); border-radius: 18rpx; background: rgba(255,255,255,0.74); }\n" +
  ".moontown-discovery-more-header { display: flex; align-items: center; justify-content: space-between; gap: 10rpx; }\n" +
  ".moontown-discovery-more-header button { min-height: 64rpx; height: 64rpx; }\n" +
  ".moontown-discovery-secondary-filters .bunnia-list-windowed { display: flex; flex-direction: row; gap: 8rpx; overflow-x: auto; overflow-y: hidden; margin-top: 8rpx; }\n" +
  ".moontown-results-heading { margin-top: 14rpx; padding-top: 12rpx; border-top: 1rpx solid rgba(30,86,70,0.12); }\n" +
  ".moontown-discovery-results .bunnia-list-windowed { display: grid; grid-template-columns: minmax(0, 1fr); gap: 0; }\n" +
  ".moontown-discover-entry { display: grid; grid-template-columns: minmax(0, 1fr) auto; gap: 4rpx 12rpx; align-items: center; min-height: 124rpx; margin-top: 10rpx; border: 1rpx solid rgba(30,86,70,0.12); border-radius: 20rpx; background: rgba(255,255,255,0.84); }\n" +
  ".moontown-discover-entry > .moontown-discovery-badges { grid-column: 1; }\n" +
  ".moontown-discover-entry > .moontown-discovery-action { grid-column: 2; grid-row: 1 / 3; margin-top: 0; padding-top: 0; }\n" +
  ".moontown-discovery-action .moontown-primary-action { flex: 0 0 auto; min-width: 132rpx; }\n" +
  ".moontown-message-inbox, .moontown-message-notices { grid-column: 1 / -1; }\n" +
  ".moontown-message-channels .bunnia-list-windowed, .moontown-ownership-filters .bunnia-list-windowed, .moontown-lifecycle-actions, .moontown-lifecycle-stages { display: flex; flex-direction: row; gap: 8rpx; overflow-x: auto; overflow-y: hidden; margin-top: 8rpx; }\n" +
  ".moontown-lifecycle-stage { flex: 0 0 auto; min-height: 44rpx; padding: 6rpx 8rpx; font-size: 22rpx; line-height: 30rpx; }\n" +
  ".moontown-discovery-filter, .moontown-discovery-more, .moontown-message-channel, .moontown-ownership-filter { flex: 0 0 auto; min-height: 72rpx; padding: 8rpx 16rpx; border: 1rpx solid rgba(30,86,70,0.12); border-radius: 999rpx; background: rgba(255,255,255,0.86); color: #4f6259; font-size: 21rpx; line-height: 28rpx; overflow: hidden; }\n" +
  ".moontown-discovery-filter.active, .moontown-discovery-more.active, .moontown-message-channel.active, .moontown-ownership-filter.active { border-color: #1f6a54; background: #1f6a54; color: #f7fbf8; }\n"
}
