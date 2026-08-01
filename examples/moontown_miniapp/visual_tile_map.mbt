///|
fn tile_map_wxss() -> String {
  ".moontown-map-fullscreen { position: absolute; left: 0; top: 0; right: 0; bottom: 0; overflow: hidden; background: #bfd8e3; }\n" +
  ".moontown-map-touch-area { position: absolute; left: 0; top: 0; right: 0; bottom: 0; z-index: 1; width: 100vw; height: 100vh; overflow: hidden; background: #a9cce2; touch-action: none; }\n" +
  ".moontown-map-drag-content { position: absolute; left: 0; top: 0; width: \{moontown_map_display_width()}rpx; height: \{moontown_map_display_height()}rpx; overflow: hidden; transform-origin: 0 0; will-change: transform; }\n" +
  ".moontown-wenyu-energy-valley-map-image { position: absolute; left: 0; top: 0; width: \{moontown_map_display_width()}rpx; height: \{moontown_map_display_height()}rpx; display: block; }\n" +
  ".moontown-map-focus-controls { position: absolute; z-index: 12; left: 22rpx; top: 22rpx; }\n" +
  ".moontown-map-focus-button { min-width: 132rpx; min-height: 76rpx; padding: 8rpx 16rpx; border-radius: 999rpx; background: #174a3c; color: #f7fbf8; font-weight: 800; }\n" +
  ".moontown-miniapp.map-focus .moontown-topbar, .moontown-miniapp.map-focus .moontown-right-hud, .moontown-miniapp.map-focus .moontown-tabbar, .moontown-miniapp.map-focus .moontown-request-feedback { display: none; }\n" +
  ".moontown-map-marker { position: absolute; z-index: 900; width: 32rpx; min-width: 32rpx; max-width: 32rpx; height: 32rpx; min-height: 32rpx; padding: 0; transform: translate(-50%,-50%); border: 2rpx solid rgba(255,255,255,0.92); border-radius: 999rpx; background: #287f72; box-shadow: 0 3rpx 10rpx rgba(15,23,42,0.26); }\n" +
  ".moontown-map-marker::after { position: absolute; left: 50%; top: 50%; width: 88rpx; height: 88rpx; content: ''; transform: translate(-50%,-50%); }\n" +
  ".moontown-map-marker.quiet { opacity: 0.88; }\n" +
  ".moontown-map-marker.selected { z-index: 901; display: block; width: auto; min-width: 178rpx; max-width: 236rpx; height: auto; min-height: 62rpx; padding: 10rpx 14rpx; transform: translate(-50%,-100%); border: 3rpx solid rgba(240,253,250,0.92); border-radius: 18rpx; background: #174a3c; box-shadow: 0 0 0 5rpx rgba(47,127,104,0.28), 0 8rpx 18rpx rgba(15,23,42,0.26); }\n" +
  ".moontown-map-marker-title { display: none; color: #1f2d22; font-size: 22rpx; font-weight: 800; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }\n" +
  ".moontown-map-marker-kind { display: block; margin-top: 2rpx; color: #56604f; font-size: 22rpx; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }\n" +
  ".moontown-map-marker.selected .moontown-map-marker-title { display: block; color: #ffffff; font-size: 24rpx; }\n" +
  ".moontown-map-marker.selected .moontown-map-marker-kind { color: #dbeafe; }\n" +
  ".moontown-thread-pin { position: absolute; right: -8rpx; top: -8rpx; min-width: 24rpx; width: 24rpx; height: 24rpx; padding: 0; border-radius: 999rpx; background: #dc2626; color: transparent; font-size: 0; line-height: 0; text-align: center; border: 2rpx solid rgba(255,255,255,0.78); }\n" +
  ".moontown-semantic-scene { position: absolute; left: 0; top: 0; width: 1rpx; height: 1rpx; opacity: 0; overflow: hidden; pointer-events: none; }\n" +
  ".moontown-semantic-scene .bunnia-scene { pointer-events: none; }\n"
}
