///|
fn tile_base_wxss() -> String {
  ".moontown-miniapp { position: relative; min-height: 100vh; overflow: hidden; background: #f3f7f4; color: #26342e; font-size: 26rpx; line-height: 1.45; overflow-wrap: anywhere; word-break: break-word; overscroll-behavior: contain; }\n" +
  "view, button, input { box-sizing: border-box; }\n" +
  "button { min-width: 88rpx; min-height: 88rpx; max-width: 100%; margin: 0; padding: 10rpx 18rpx; border: 1rpx solid rgba(30,86,70,0.14); border-radius: 20rpx; background: rgba(255,255,255,0.86); color: #344b41; font-size: 24rpx; line-height: 32rpx; overflow: hidden; touch-action: manipulation; transition: transform 120ms ease, opacity 120ms ease, background 120ms ease; }\n" +
  "button::after { border: 0; }\n" +
  "button:active { opacity: 0.88; transform: scale(0.98); }\n" +
  "button[disabled], .bunnia-status-disabled { opacity: 0.52; pointer-events: none; }\n" +
  "@media (prefers-reduced-motion: reduce) { button { transition: none; } }\n" +
  "button text { white-space: normal; text-align: center; overflow-wrap: anywhere; word-break: break-word; }\n" +
  ".mt-panel input { width: 100%; min-height: 88rpx; margin-top: 8rpx; padding: 0 18rpx; border: 1rpx solid rgba(30,86,70,0.14); border-radius: 22rpx; background: rgba(255,255,255,0.86); color: #26342e; font-size: 26rpx; }\n"
}
