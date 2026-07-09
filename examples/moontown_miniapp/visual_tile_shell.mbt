///|
fn tile_shell_wxss() -> String {
  ".moontown-topbar { position: absolute; left: 24rpx; right: 24rpx; top: calc(24rpx + env(safe-area-inset-top)); z-index: 8; display: flex; align-items: center; justify-content: space-between; gap: 16rpx; padding: 14rpx 16rpx; border: 1rpx solid rgba(255,255,255,0.52); border-radius: 8rpx; background: rgba(255, 241, 242, 0.92); }\n" +
  ".moontown-title { font-size: 34rpx; font-weight: 800; color: #203222; }\n" +
  ".moontown-subtitle { margin-top: 2rpx; font-size: 20rpx; font-weight: 500; color: #66705a; }\n" +
  ".moontown-shell-actions { display: flex; align-items: center; justify-content: flex-end; gap: 8rpx; flex-wrap: wrap; max-width: 440rpx; }\n" +
  ".moontown-shell-actions text { color: #334538; font-size: 20rpx; }\n" +
  ".moontown-page-surface { position: absolute; z-index: 7; left: 22rpx; right: 22rpx; top: calc(160rpx + env(safe-area-inset-top)); bottom: calc(132rpx + env(safe-area-inset-bottom)); overflow-x: hidden; overflow-y: auto; -webkit-overflow-scrolling: touch; display: grid; grid-template-columns: minmax(0, 1fr); gap: 12rpx; padding-bottom: 12rpx; }\n" +
  ".moontown-page-grid { min-height: 0; display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 12rpx; align-content: start; overflow: visible; padding-bottom: 12rpx; }\n" +
  ".moontown-page-grid.three { grid-template-columns: repeat(3, minmax(0, 1fr)); }\n" +
  ".moontown-tabbar { position: absolute; z-index: 9; left: 22rpx; right: 22rpx; bottom: calc(18rpx + env(safe-area-inset-bottom)); display: grid; grid-template-columns: repeat(5, 1fr); gap: 8rpx; padding: 10rpx; border: 1rpx solid rgba(255,255,255,0.5); border-radius: 8rpx; background: rgba(31, 49, 36, 0.88); }\n" +
  ".moontown-tab-button { min-height: 88rpx; padding: 8rpx 6rpx; border: 1rpx solid rgba(255,241,242,0.38); border-radius: 6rpx; background: rgba(37,99,235,0.18); color: #fff1f2; font-size: 18rpx; line-height: 24rpx; overflow: hidden; }\n" +
  ".moontown-tab-button.active { background: #e11d48; color: #ffffff; font-weight: 800; }\n"
}
