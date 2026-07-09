///|
fn tile_drawer_wxss() -> String {
  ".moontown-right-hud { position: absolute; z-index: 7; right: 22rpx; top: 160rpx; width: 300rpx; display: flex; flex-direction: column; gap: 12rpx; }\n" +
  ".moontown-building-drawer, .moontown-chat-drawer, .moontown-create-drawer { min-width: 0; padding: 14rpx; border: 1rpx solid rgba(255,255,255,0.52); border-radius: 8rpx; background: rgba(255, 241, 242, 0.92); overflow: hidden; }\n" +
  ".moontown-building-drawer text, .moontown-chat-drawer text, .moontown-create-drawer text { display: block; color: #405244; font-size: 20rpx; }\n" +
  ".moontown-object-section, .moontown-worker-entry { min-width: 0; margin-top: 8rpx; padding: 10rpx; border: 1rpx solid rgba(51,65,55,0.16); border-radius: 6rpx; background: rgba(239,246,255,0.74); }\n" +
  ".moontown-building-drawer button { margin-top: 8rpx; margin-right: 6rpx; }\n" +
  ".moontown-chat-drawer .bunnia-message-feed-windowed { max-height: 170rpx; overflow: hidden; }\n" +
  ".moontown-chat-drawer .bunnia-message { padding: 10rpx 12rpx; margin-bottom: 8rpx; background: rgba(255,255,255,0.78); font-size: 20rpx; }\n" +
  ".moontown-chat-drawer .bunnia-review { margin-top: 8rpx; padding: 10rpx; gap: 8rpx; background: rgba(255,255,255,0.68); }\n" +
  ".moontown-bottom-hud { position: absolute; z-index: 7; left: 22rpx; right: 344rpx; bottom: calc(132rpx + env(safe-area-inset-bottom)); display: block; }\n" +
  ".moontown-map-state-strip { min-width: 0; padding: 12rpx; border: 1rpx solid rgba(255,255,255,0.42); border-radius: 8rpx; background: rgba(15, 23, 42, 0.78); display: flex; flex-direction: row; gap: 8rpx; overflow: hidden; }\n" +
  ".moontown-map-state-chip { flex: 0 0 auto; max-width: 196rpx; padding: 8rpx 10rpx; border: 1rpx solid rgba(255,255,255,0.32); border-radius: 6rpx; background: rgba(255, 241, 242, 0.94); color: #27372b; font-size: 18rpx; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }\n" +
  ".moontown-create-drawer input { min-height: 88rpx; margin-bottom: 8rpx; padding: 0 10rpx; border: 1rpx solid rgba(51, 65, 55, 0.22); border-radius: 6rpx; background: rgba(255,255,255,0.82); color: #26362b; font-size: 20rpx; }\n" +
  ".moontown-create-drawer form { display: block; margin-bottom: 8rpx; }\n" +
  ".moontown-create-drawer form:last-child { margin-bottom: 0; }\n"
}
