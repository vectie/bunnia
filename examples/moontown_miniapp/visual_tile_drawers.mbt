///|
fn tile_drawer_wxss() -> String {
  ".moontown-right-hud { position: absolute; z-index: 7; right: 22rpx; top: 160rpx; bottom: calc(132rpx + env(safe-area-inset-bottom)); width: 360rpx; overflow: hidden; }\n" +
  ".moontown-building-drawer, .moontown-create-drawer { min-width: 0; padding: 16rpx; border: 1rpx solid rgba(255,255,255,0.62); border-radius: 8rpx; background: rgba(248,250,252,0.96); box-shadow: 0 10rpx 28rpx rgba(15,23,42,0.24); overflow: hidden; }\n" +
  ".moontown-building-drawer { height: 100%; overflow-y: auto; -webkit-overflow-scrolling: touch; overscroll-behavior: contain; }\n" +
  ".moontown-building-drawer text, .moontown-chat-drawer text, .moontown-create-drawer text { display: block; color: #405244; font-size: 20rpx; }\n" +
  ".moontown-object-kicker { display: flex; align-items: center; justify-content: space-between; gap: 8rpx; color: #e11d48; font-size: 16rpx; font-weight: 800; }\n" +
  ".moontown-object-title, .moontown-object-title text { margin-top: 6rpx; font-size: 28rpx !important; line-height: 36rpx; white-space: normal; overflow: visible; text-overflow: clip; }\n" +
  ".moontown-place-facts { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 8rpx; margin-top: 10rpx; }\n" +
  ".moontown-place-fact { min-width: 0; padding: 8rpx; border-radius: 6rpx; }\n" +
  ".moontown-place-fact-label { color: #6b745f; font-size: 15rpx; }\n" +
  ".moontown-place-fact-value { color: #203222; font-size: 18rpx; font-weight: 800; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }\n" +
  ".moontown-object-section { min-width: 0; margin-top: 14rpx; padding: 14rpx 0 0; border-top: 1rpx solid rgba(51,65,55,0.18); }\n" +
  ".moontown-worker-entry { min-width: 0; margin-top: 8rpx; padding: 10rpx; border: 1rpx solid rgba(51,65,55,0.16); border-radius: 6rpx; background: rgba(239,246,255,0.74); }\n" +
  ".moontown-building-drawer button { margin-top: 8rpx; margin-right: 6rpx; }\n" +
  ".moontown-object-primary-actions .moontown-primary-action { flex: 2 1 140rpx; }\n" +
  ".moontown-drawer-report { width: 100%; margin-top: 16rpx; }\n" +
  ".moontown-chat-drawer .bunnia-message-feed-windowed { max-height: 170rpx; overflow: hidden; }\n" +
  ".moontown-chat-drawer .bunnia-message { padding: 10rpx 12rpx; margin-bottom: 8rpx; background: rgba(255,255,255,0.78); font-size: 20rpx; }\n" +
  ".moontown-chat-drawer .bunnia-review { margin-top: 8rpx; padding: 10rpx; gap: 8rpx; background: rgba(255,255,255,0.68); }\n" +
  ".moontown-create-drawer input { min-height: 88rpx; margin-bottom: 8rpx; padding: 0 10rpx; border: 1rpx solid rgba(51, 65, 55, 0.22); border-radius: 6rpx; background: rgba(255,255,255,0.82); color: #26362b; font-size: 20rpx; }\n" +
  ".moontown-create-drawer form { display: block; margin-bottom: 8rpx; }\n" +
  ".moontown-create-drawer form:last-child { margin-bottom: 0; }\n"
}
