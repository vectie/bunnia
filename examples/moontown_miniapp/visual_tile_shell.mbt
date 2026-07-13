///|
fn tile_shell_wxss() -> String {
  ".moontown-topbar { position: absolute; right: 22rpx; top: 0; top: constant(safe-area-inset-top); top: env(safe-area-inset-top); margin-top: 18rpx; z-index: 8; display: flex; justify-content: flex-end; padding: 0; background: transparent; }\n" +
  ".moontown-passport-entry, .moontown-entry-button { flex: 0 0 auto; min-width: 148rpx; min-height: 88rpx; padding: 10rpx 14rpx; border-color: rgba(255,255,255,0.68); background: #1f3125; color: #ffffff; text-align: left; box-shadow: 0 4rpx 14rpx rgba(15,23,42,0.18); }\n" +
  ".moontown-passport-switch { flex: 0 0 auto; display: flex; }\n" +
  ".moontown-passport-name { max-width: 190rpx; color: #ffffff; font-size: 22rpx; font-weight: 800; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }\n" +
  ".moontown-passport-state { margin-top: 2rpx; color: #dbeafe; font-size: 22rpx; }\n" +
  ".moontown-page-surface { position: absolute; z-index: 7; left: 0; right: 0; top: 0; top: constant(safe-area-inset-top); top: env(safe-area-inset-top); bottom: 0; margin-top: 112rpx; padding: 18rpx 18rpx 154rpx; overflow-x: hidden; overflow-y: auto; -webkit-overflow-scrolling: touch; display: grid; grid-template-columns: minmax(0, 1fr); gap: 16rpx; background: #f1f5f4; }\n" +
  ".moontown-page-surface.tab-my { margin-top: 0; padding-top: 20rpx; }\n" +
  ".moontown-page-grid { min-height: 0; display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 12rpx; align-content: start; overflow: visible; padding-bottom: 12rpx; }\n" +
  ".moontown-page-grid.single { grid-template-columns: minmax(0, 1fr); }\n" +
  ".moontown-page-grid.three { grid-template-columns: repeat(3, minmax(0, 1fr)); }\n" +
  ".moontown-tabbar { position: absolute; z-index: 9; left: 22rpx; right: 22rpx; bottom: 0; bottom: constant(safe-area-inset-bottom); bottom: env(safe-area-inset-bottom); margin-bottom: 16rpx; display: block; padding: 8rpx; border: 1rpx solid rgba(255,255,255,0.42); border-radius: 8rpx; background: rgba(26,39,31,0.96); }\n" +
  ".moontown-tabbar > .bunnia-list { display: flex; flex-direction: row; gap: 8rpx; width: 100%; }\n" +
  ".moontown-tab-button { position: relative; flex: 1 1 0; min-width: 0; min-height: 88rpx; padding: 8rpx 6rpx; border: 1rpx solid transparent; border-radius: 6rpx; background: transparent; color: #e2e8f0; font-size: 22rpx; line-height: 30rpx; overflow: visible; }\n" +
  ".moontown-tab-button.map-surface { top: -8rpx; min-height: 96rpx; border-color: rgba(255,255,255,0.62); background: #2563eb; box-shadow: 0 6rpx 12rpx rgba(15,23,42,0.28); font-weight: 800; }\n" +
  ".moontown-tab-button.active { background: #2563eb; color: #ffffff; font-weight: 800; }\n" +
  ".moontown-tab-button.active::before { position: absolute; left: 50%; bottom: 6rpx; width: 22rpx; height: 4rpx; border-radius: 4rpx; background: #ffffff; content: ''; transform: translateX(-50%); }\n"
}
