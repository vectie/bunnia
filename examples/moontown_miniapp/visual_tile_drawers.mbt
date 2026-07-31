///|
fn tile_drawer_wxss() -> String {
  ".moontown-right-hud { position: absolute; z-index: 7; right: 22rpx; top: 112rpx; bottom: 0; bottom: constant(safe-area-inset-bottom); bottom: env(safe-area-inset-bottom); margin-bottom: 124rpx; width: 380rpx; overflow: hidden; }\n" +
  ".moontown-building-drawer, .moontown-create-drawer { position: relative; min-width: 0; padding: 30rpx 22rpx 22rpx; border: 1rpx solid rgba(120,53,15,0.12); border-radius: 28rpx; background: #fbf7ee; box-shadow: 0 16rpx 44rpx rgba(15,23,42,0.28); overflow: hidden; }\n" +
  ".moontown-building-drawer::before, .moontown-create-drawer::before { position: absolute; left: 50%; top: 12rpx; width: 64rpx; height: 6rpx; border-radius: 999rpx; background: #d6d3d1; content: ''; transform: translateX(-50%); }\n" +
  ".moontown-building-drawer { height: 100%; overflow-y: auto; -webkit-overflow-scrolling: touch; overscroll-behavior: contain; }\n" +
  ".moontown-building-drawer text, .moontown-chat-drawer text, .moontown-create-drawer text { display: block; color: #405244; font-size: 24rpx; }\n" +
  ".moontown-object-kicker { display: flex; align-items: center; justify-content: space-between; gap: 8rpx; color: #b45309; font-size: 20rpx; font-weight: 800; }\n" +
  ".moontown-object-title, .moontown-object-title text { margin-top: 6rpx; font-size: 28rpx !important; line-height: 36rpx; white-space: normal; overflow: visible; text-overflow: clip; }\n" +
  ".moontown-place-facts { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 8rpx; margin-top: 10rpx; }\n" +
  ".moontown-place-fact { min-width: 0; padding: 10rpx; border-radius: 14rpx; background: rgba(254,243,199,0.56); }\n" +
  ".moontown-place-fact-label { color: #6b745f; font-size: 22rpx; }\n" +
  ".moontown-place-fact-value { color: #203222; font-size: 24rpx; font-weight: 800; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }\n" +
  ".moontown-object-detail-actions { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 8rpx; margin-top: 12rpx; padding-top: 12rpx; border-top: 1rpx solid rgba(120,53,15,0.12); }\n" +
  ".moontown-object-detail-actions button:last-child { grid-column: 1 / -1; }\n" +
  ".moontown-object-section { min-width: 0; margin-top: 14rpx; padding: 14rpx 0 0; border-top: 1rpx solid rgba(120,53,15,0.12); }\n" +
  ".moontown-worker-entry { min-width: 0; margin-top: 8rpx; padding: 10rpx; border: 1rpx solid rgba(120,53,15,0.12); border-radius: 14rpx; background: rgba(255,255,255,0.8); }\n" +
  ".moontown-building-drawer button { margin-top: 8rpx; margin-right: 6rpx; }\n" +
  ".moontown-object-primary-actions button text { white-space: nowrap; word-break: normal; }\n" +
  ".moontown-object-primary-actions .moontown-primary-action { flex: 2 1 140rpx; }\n" +
  ".moontown-drawer-report { width: 100%; margin-top: 16rpx; }\n" +
  ".moontown-chat-drawer .bunnia-message-feed-windowed { max-height: 170rpx; overflow: hidden; }\n" +
  ".moontown-chat-drawer .bunnia-message { padding: 10rpx 12rpx; margin-bottom: 8rpx; background: #ffffff; font-size: 24rpx; }\n" +
  ".moontown-chat-drawer .bunnia-review { margin-top: 8rpx; padding: 10rpx; gap: 8rpx; background: #ffffff; }\n" +
  ".moontown-create-drawer input { min-height: 88rpx; margin-bottom: 8rpx; padding: 0 10rpx; border: 1rpx solid #cbd5e1; border-radius: 6rpx; background: #ffffff; color: #26362b; font-size: 24rpx; }\n" +
  ".moontown-create-drawer form { display: block; margin-bottom: 8rpx; }\n" +
  ".moontown-create-drawer form:last-child { margin-bottom: 0; }\n"
}
