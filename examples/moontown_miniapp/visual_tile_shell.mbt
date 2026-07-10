///|
fn tile_shell_wxss() -> String {
  ".moontown-topbar { position: absolute; left: 24rpx; right: 24rpx; top: 0; top: constant(safe-area-inset-top); top: env(safe-area-inset-top); margin-top: 24rpx; z-index: 8; display: flex; align-items: center; justify-content: space-between; gap: 16rpx; padding: 12rpx 14rpx; border: 1rpx solid rgba(255,255,255,0.58); border-radius: 8rpx; background: rgba(255, 241, 242, 0.94); box-shadow: 0 4rpx 14rpx rgba(15,23,42,0.12); }\n" +
  ".moontown-title-block { min-width: 0; flex: 1 1 auto; }\n" +
  ".moontown-eyebrow { color: #e11d48; font-size: 16rpx; font-weight: 800; }\n" +
  ".moontown-title { color: #203222; font-size: 30rpx; font-weight: 800; }\n" +
  ".moontown-subtitle { margin-top: 2rpx; color: #53624e; font-size: 18rpx; font-weight: 500; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }\n" +
  ".moontown-passport-entry, .moontown-entry-button { flex: 0 0 auto; min-width: 160rpx; min-height: 88rpx; padding: 8rpx 12rpx; background: #203124; color: #ffffff; text-align: left; }\n" +
  ".moontown-passport-switch { flex: 0 0 auto; display: flex; }\n" +
  ".moontown-passport-name { max-width: 190rpx; color: #ffffff; font-size: 18rpx; font-weight: 800; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }\n" +
  ".moontown-passport-state { margin-top: 2rpx; color: #ffd7df; font-size: 15rpx; }\n" +
  ".moontown-page-surface { position: absolute; z-index: 7; left: 22rpx; right: 22rpx; top: 0; top: constant(safe-area-inset-top); top: env(safe-area-inset-top); bottom: 0; bottom: constant(safe-area-inset-bottom); bottom: env(safe-area-inset-bottom); margin-top: 160rpx; margin-bottom: 132rpx; overflow-x: hidden; overflow-y: auto; -webkit-overflow-scrolling: touch; display: grid; grid-template-columns: minmax(0, 1fr); gap: 12rpx; padding-bottom: 12rpx; }\n" +
  ".moontown-page-grid { min-height: 0; display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 12rpx; align-content: start; overflow: visible; padding-bottom: 12rpx; }\n" +
  ".moontown-page-grid.single { grid-template-columns: minmax(0, 1fr); }\n" +
  ".moontown-page-grid.three { grid-template-columns: repeat(3, minmax(0, 1fr)); }\n" +
  ".moontown-tabbar { position: absolute; z-index: 9; left: 22rpx; right: 22rpx; bottom: 0; bottom: constant(safe-area-inset-bottom); bottom: env(safe-area-inset-bottom); margin-bottom: 18rpx; display: block; padding: 10rpx; border: 1rpx solid rgba(255,255,255,0.5); border-radius: 8rpx; background: rgba(31, 49, 36, 0.88); }\n" +
  ".moontown-tabbar > .bunnia-list { display: flex; flex-direction: row; gap: 8rpx; width: 100%; }\n" +
  ".moontown-tab-button { position: relative; flex: 1 1 0; min-width: 0; min-height: 88rpx; padding: 8rpx 6rpx; border: 1rpx solid rgba(255,241,242,0.24); border-radius: 6rpx; background: transparent; color: #fff1f2; font-size: 18rpx; line-height: 24rpx; overflow: visible; }\n" +
  ".moontown-tab-button.map-surface { top: -10rpx; min-height: 98rpx; border-color: rgba(255,255,255,0.62); background: #2563eb; box-shadow: 0 6rpx 12rpx rgba(15,23,42,0.28); font-weight: 800; }\n" +
  ".moontown-tab-button.active { background: #e11d48; color: #ffffff; font-weight: 800; }\n" +
  ".moontown-tab-button.active::before { position: absolute; left: 50%; bottom: 6rpx; width: 22rpx; height: 4rpx; border-radius: 4rpx; background: #ffffff; content: ''; transform: translateX(-50%); }\n"
}
