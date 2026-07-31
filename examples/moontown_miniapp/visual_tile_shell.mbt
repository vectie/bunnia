///|
fn tile_shell_wxss() -> String {
  ".moontown-topbar { position: absolute; right: 22rpx; top: 0; top: constant(safe-area-inset-top); top: env(safe-area-inset-top); margin-top: 18rpx; z-index: 8; display: flex; justify-content: flex-end; padding: 0; background: transparent; }\n" +
  ".moontown-passport-entry, .moontown-entry-button { flex: 0 0 auto; min-width: 148rpx; min-height: 76rpx; padding: 8rpx 14rpx; border-color: rgba(255,251,235,0.5); border-radius: 999rpx; background: rgba(69,44,16,0.7); color: #fffbeb; text-align: left; box-shadow: 0 8rpx 24rpx rgba(15,23,42,0.2); backdrop-filter: blur(12rpx); }\n" +
  ".moontown-passport-switch { flex: 0 0 auto; display: flex; }\n" +
  ".moontown-passport-name { max-width: 190rpx; color: #fffbeb; font-size: 22rpx; font-weight: 800; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }\n" +
  ".moontown-passport-state { margin-top: 2rpx; color: #fde68a; font-size: 20rpx; }\n" +
  ".moontown-page-surface { position: absolute; z-index: 7; left: 0; right: 0; top: 0; bottom: 0; margin: 0; padding: 0 24rpx 184rpx; overflow-x: hidden; overflow-y: auto; -webkit-overflow-scrolling: touch; display: grid; grid-template-columns: minmax(0, 1fr); gap: 10rpx; background: #fbf7ee; }\n" +
  ".moontown-page-surface.tab-my { margin: 0; padding-top: 0; }\n" +
  ".moontown-page-header { padding: calc(24rpx + env(safe-area-inset-top)) 0 12rpx; }\n" +
  ".moontown-page-title { color: #292524; font-size: 38rpx; line-height: 48rpx; font-weight: 900; }\n" +
  ".moontown-page-subtitle { margin-top: 2rpx; color: #78716c; font-size: 22rpx; line-height: 30rpx; }\n" +
  ".moontown-page-grid { min-height: 0; display: grid; grid-template-columns: minmax(0, 1fr); gap: 18rpx; align-content: start; overflow: visible; padding-bottom: 12rpx; }\n" +
  ".moontown-page-grid.single { grid-template-columns: minmax(0, 1fr); }\n" +
  ".moontown-page-grid.three { grid-template-columns: minmax(0, 1fr); }\n" +
  ".moontown-tabbar { position: absolute; z-index: 9; left: 0; right: 0; bottom: 0; margin: 0; display: block; padding: 10rpx 8rpx calc(10rpx + env(safe-area-inset-bottom)); border: 0; border-top: 1rpx solid rgba(120,53,15,0.12); border-radius: 0; background: rgba(251,247,238,0.97); box-shadow: 0 -10rpx 28rpx rgba(69,44,16,0.08); }\n" +
  ".moontown-tabbar > .bunnia-list { display: flex; flex-direction: row; align-items: flex-end; gap: 4rpx; width: 100%; }\n" +
  ".moontown-tab-button { position: relative; flex: 1 1 0; display: flex; align-items: center; justify-content: center; min-width: 0; min-height: 96rpx; padding: 8rpx 4rpx; border: 0; border-radius: 18rpx; background: transparent; color: #78716c; font-size: 20rpx; line-height: 26rpx; overflow: visible; }\n" +
  ".moontown-tab-button.map-surface { top: -26rpx; min-width: 112rpx; min-height: 112rpx; border: 8rpx solid #fbf7ee; border-radius: 999rpx; background: #b45309; color: #fffbeb; box-shadow: 0 10rpx 22rpx rgba(120,53,15,0.3); font-weight: 800; }\n" +
  ".moontown-tab-button.active { background: transparent; color: #b45309; font-weight: 800; }\n" +
  ".moontown-tab-button.map-surface.active { background: #d97706; color: #fffbeb; transform: translateY(-4rpx); }\n" +
  ".moontown-tab-button.active::before { position: absolute; inset: 4rpx; border: 2rpx solid rgba(180,83,9,0.7); border-radius: 16rpx; content: ''; pointer-events: none; }\n" +
  ".moontown-tab-button.map-surface.active::before { display: none; }\n"
}
