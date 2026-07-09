///|
fn tile_map_wxss() -> String {
  ".moontown-map-fullscreen { position: absolute; left: 0; top: 0; right: 0; bottom: 0; overflow: hidden; background: #0f172a; }\n" +
  ".moontown-map-touch-area { position: absolute; left: 0; top: 0; right: 0; bottom: 0; z-index: 1; width: 100vw; height: 100vh; overflow: hidden; background: #0f172a; touch-action: none; }\n" +
  ".moontown-map-drag-content { position: absolute; left: 0; top: 0; width: \{moontown_map_display_width()}rpx; height: \{moontown_map_display_height()}rpx; overflow: hidden; transform-origin: 0 0; will-change: transform; }\n" +
  ".moontown-wenyu-map-image { position: absolute; left: 0; top: 0; width: \{moontown_map_display_width()}rpx; height: \{moontown_map_display_height()}rpx; display: block; }\n" +
  ".moontown-map-marker { position: absolute; z-index: 3; min-width: 112rpx; max-width: 180rpx; min-height: 88rpx; padding: 8rpx 10rpx; border: 2rpx solid rgba(255,255,255,0.68); border-radius: 8rpx; background: rgba(255, 241, 242, 0.9); color: #1e2c21; }\n" +
  ".moontown-map-marker.selected { border-width: 3rpx; box-shadow: 0 0 0 4rpx rgba(225,29,72,0.24); }\n" +
  ".moontown-map-marker-title { display: block; color: #1f2d22; font-size: 18rpx; font-weight: 800; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }\n" +
  ".moontown-map-marker-kind { display: block; margin-top: 2rpx; color: #56604f; font-size: 15rpx; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }\n" +
  ".moontown-thread-pin { position: absolute; right: -10rpx; top: -10rpx; min-width: 48rpx; height: 28rpx; padding: 0 8rpx; border-radius: 999rpx; background: #2563eb; color: #ffffff; font-size: 15rpx; line-height: 28rpx; text-align: center; border: 1rpx solid rgba(255,255,255,0.68); }\n" +
  ".moontown-semantic-scene { position: absolute; left: 0; top: 0; width: 1rpx; height: 1rpx; opacity: 0; overflow: hidden; pointer-events: none; }\n" +
  ".moontown-semantic-scene .bunnia-scene { pointer-events: none; }\n"
}
