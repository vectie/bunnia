///|
fn tile_messages_wxss() -> String {
  ".moontown-message-notices { padding: 0 !important; border: 0 !important; background: transparent !important; box-shadow: none !important; }\n" +
  ".moontown-chat-list-header { display: flex; align-items: center; justify-content: space-between; gap: 10rpx; }\n" +
  ".moontown-chat-list-header .moontown-message-channels { display: flex; flex: 1 1 auto; flex-direction: row; gap: 16rpx; min-width: 0; overflow-x: auto; padding-bottom: 2rpx; }\n" +
  ".moontown-message-channel { flex: 0 0 auto; min-height: 88rpx; }\n" +
  ".moontown-chat-refresh { flex: 0 0 76rpx; width: 76rpx; min-width: 76rpx; min-height: 72rpx; padding: 0; border-radius: 18rpx; font-size: 28rpx; }\n" +
  ".moontown-notice-list { margin-top: 12rpx; border: 1rpx solid rgba(30,86,70,0.1); border-radius: 24rpx; background: rgba(255,255,255,0.9); overflow: hidden; }\n" +
  ".moontown-notice-list > .bunnia-list-windowed { display: flex; flex-direction: column; gap: 0; }\n" +
  ".moontown-chat-row { min-width: 0; min-height: 104rpx; margin: 0; display: grid; grid-template-columns: 56rpx minmax(0, 1fr); gap: 12rpx; padding: 18rpx 16rpx; border: 0; border-bottom: 1rpx solid rgba(30,86,70,0.1); border-radius: 0; background: transparent; overflow: visible; }\n" +
  ".moontown-chat-row:last-child { border-bottom: 0; }\n" +
  ".moontown-chat-row:active { background: #edf6f1; }\n" +
  ".moontown-chat-row.unread { background: rgba(226,241,235,0.72); }\n" +
  ".moontown-chat-avatar { display: flex; align-items: center; justify-content: center; width: 56rpx; height: 56rpx; border-radius: 999rpx; background: #e2f1eb; color: #1f5a48; font-size: 20rpx; font-weight: 800; }\n" +
  ".moontown-chat-avatar.kind-agent-run { background: #e2f1eb; color: #1f5a48; }\n" +
  ".moontown-chat-avatar.kind-review { background: #fee2e2; color: #991b1b; }\n" +
  ".moontown-chat-avatar.kind-interaction { background: #dcfce7; color: #166534; }\n" +
  ".moontown-chat-avatar.kind-follow { background: #fce7f3; color: #9d174d; }\n" +
  ".moontown-chat-copy { min-width: 0; }\n" +
  ".moontown-chat-title-row { display: flex; align-items: center; justify-content: space-between; gap: 8rpx; min-width: 0; }\n" +
  ".moontown-chat-title-row .mt-title { min-width: 0; flex: 1 1 auto; }\n" +
  ".moontown-chat-unread-dot { flex: 0 0 12rpx; width: 12rpx; height: 12rpx; border-radius: 6rpx; background: #1f6a54; }\n" +
  ".moontown-chat-preview, .moontown-chat-preview text { min-width: 0; margin-top: 2rpx; color: #66766e; font-size: 22rpx; line-height: 30rpx; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }\n" +
  ".moontown-message-review, .moontown-message-work { margin-top: 6rpx; }\n"
}
