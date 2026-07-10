///|
fn tile_my_wxss() -> String {
  ".moontown-my-layout { grid-template-columns: repeat(12, minmax(0, 1fr)); align-items: start; }\n" +
  ".moontown-my-overview { grid-column: span 4; background: rgba(255,241,242,0.96); border-color: rgba(225,29,72,0.24); }\n" +
  ".moontown-my-inventory { grid-column: span 8; grid-row: span 4; background: rgba(248,250,252,0.96); }\n" +
  ".moontown-my-setup, .moontown-my-public, .moontown-my-lifecycle, .moontown-my-reviewer, .moontown-my-layout > .moontown-credential-plaque, .moontown-my-layout > .moontown-create-drawer { grid-column: span 4; }\n" +
  ".moontown-my-heading { padding-bottom: 10rpx; border-bottom: 1rpx solid rgba(51,65,55,0.14); }\n" +
  ".moontown-my-overview .mt-panel-title { font-size: 30rpx; }\n" +
  ".moontown-my-attention { margin-top: 12rpx; }\n" +
  ".moontown-my-attention > .bunnia-list-windowed { display: flex; flex-direction: column; gap: 8rpx; margin-top: 8rpx; }\n" +
  ".moontown-my-attention .moontown-workbench-alert { margin-top: 0; }\n" +
  ".moontown-my-inventory > .bunnia-list-windowed { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 8rpx; }\n"
}
