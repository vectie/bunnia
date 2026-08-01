///|
fn tile_marketplace_wxss() -> String {
  ".moontown-line-icon { position: relative; flex: 0 0 36rpx; width: 36rpx; height: 36rpx; color: currentColor; }\n" +
  ".moontown-line-icon::before, .moontown-line-icon::after { position: absolute; box-sizing: border-box; content: ''; }\n" +
  ".moontown-line-icon::before { left: 6rpx; top: 6rpx; width: 24rpx; height: 24rpx; border: 3rpx solid currentColor; border-radius: 8rpx; }\n" +
  ".moontown-line-icon.icon-search::before { left: 4rpx; top: 3rpx; width: 22rpx; height: 22rpx; border-radius: 999rpx; }\n" +
  ".moontown-line-icon.icon-search::after { right: 3rpx; bottom: 4rpx; width: 13rpx; height: 3rpx; border-radius: 3rpx; background: currentColor; transform: rotate(45deg); transform-origin: right center; }\n" +
  ".moontown-line-icon.icon-messages::before, .moontown-line-icon.icon-direct::before { left: 3rpx; top: 5rpx; width: 30rpx; height: 23rpx; border-radius: 9rpx; }\n" +
  ".moontown-line-icon.icon-messages::after, .moontown-line-icon.icon-direct::after { left: 9rpx; bottom: 2rpx; width: 10rpx; height: 10rpx; border-left: 3rpx solid currentColor; transform: skew(-28deg); }\n" +
  ".moontown-line-icon.icon-building::before, .moontown-line-icon.icon-realm::before, .moontown-line-icon.icon-market::before { left: 4rpx; top: 9rpx; width: 28rpx; height: 24rpx; border-radius: 3rpx; }\n" +
  ".moontown-line-icon.icon-building::after { left: 10rpx; top: 3rpx; width: 17rpx; height: 17rpx; border-top: 3rpx solid currentColor; border-left: 3rpx solid currentColor; transform: rotate(45deg); }\n" +
  ".moontown-line-icon.icon-agent::before { left: 4rpx; top: 8rpx; width: 28rpx; height: 24rpx; border-radius: 10rpx; }\n" +
  ".moontown-line-icon.icon-agent::after { left: 16rpx; top: 1rpx; width: 4rpx; height: 9rpx; border-radius: 4rpx; background: currentColor; box-shadow: -6rpx 17rpx 0 -1rpx currentColor, 6rpx 17rpx 0 -1rpx currentColor; }\n" +
  ".moontown-line-icon.icon-home::before { left: 8rpx; top: 10rpx; width: 21rpx; height: 21rpx; border-radius: 3rpx; transform: rotate(45deg); }\n" +
  ".moontown-line-icon.icon-my::before { left: 11rpx; top: 2rpx; width: 14rpx; height: 14rpx; border-radius: 999rpx; }\n" +
  ".moontown-line-icon.icon-my::after { left: 5rpx; bottom: 2rpx; width: 26rpx; height: 15rpx; border: 3rpx solid currentColor; border-bottom: 0; border-radius: 16rpx 16rpx 0 0; }\n" +
  ".moontown-line-icon.icon-notification::before { left: 7rpx; top: 4rpx; width: 22rpx; height: 25rpx; border-radius: 14rpx 14rpx 6rpx 6rpx; }\n" +
  ".moontown-line-icon.icon-close::before { border: 0; background: linear-gradient(45deg,transparent 44%,currentColor 45%,currentColor 55%,transparent 56%),linear-gradient(-45deg,transparent 44%,currentColor 45%,currentColor 55%,transparent 56%); }\n" +
  ".moontown-line-icon.icon-refresh::before, .moontown-line-icon.icon-retry::before, .moontown-line-icon.icon-progress::before { border-right-color: transparent; border-radius: 999rpx; }\n" +
  ".moontown-line-icon.icon-open::before, .moontown-line-icon.icon-back::before, .moontown-line-icon.icon-send::before, .moontown-line-icon.icon-visit::before { border: 0; border-top: 3rpx solid currentColor; border-right: 3rpx solid currentColor; border-radius: 0; transform: rotate(45deg); }\n" +
  ".moontown-line-icon.icon-back::before { transform: rotate(-135deg); }\n" +
  ".moontown-line-icon.icon-share::before, .moontown-line-icon.icon-publish::before, .moontown-line-icon.icon-save::before { border-radius: 999rpx; }\n" +
  ".moontown-line-icon.icon-team::before { border-radius: 999rpx; box-shadow: -10rpx 8rpx 0 -7rpx currentColor, 10rpx 8rpx 0 -7rpx currentColor; }\n" +
  ".moontown-tab-button { flex-direction: column; gap: 3rpx; }\n" +
  ".moontown-tab-button .moontown-line-icon { width: 34rpx; height: 34rpx; }\n" +
  ".moontown-market-action, .moontown-market-publish-button, .moontown-market-open, .moontown-message-mode, .moontown-channel-kind, .moontown-market-suggestion { display: flex; align-items: center; justify-content: center; gap: 8rpx; min-height: 88rpx; }\n" +
  ".moontown-market-action.action-primary { border-color: #1f6a54; background: #1f6a54; color: #fff; }\n" +
  ".moontown-marketplace-toolbar { display: grid; grid-template-columns: minmax(0,1fr) auto auto; gap: 10rpx; align-items: stretch; }\n" +
  ".moontown-marketplace-toolbar form:first-child { display: grid; grid-template-columns: minmax(0,1fr) auto; gap: 8rpx; }\n" +
  ".moontown-marketplace-toolbar input { margin: 0; }\n" +
  ".moontown-market-suggestions, .moontown-discovery-primary-filters.marketplace, .moontown-channel-kind-filters, .moontown-notification-toolbar, .moontown-work-channel-bar { display: flex; gap: 10rpx; margin-top: 12rpx; overflow-x: auto; }\n" +
  ".moontown-market-suggestion, .moontown-channel-kind, .moontown-message-mode { flex: 0 0 auto; }\n" +
  ".moontown-discovery-primary-filters.marketplace { display: grid; grid-template-columns: repeat(3,minmax(0,1fr)); }\n" +
  ".moontown-request-board-head,.moontown-request-board-title,.moontown-policy-ceiling { display:flex; align-items:center; gap:12rpx; }\n" +
  ".moontown-request-board-head { justify-content:space-between; }\n" +
  ".moontown-marketplace-request-list { display:grid; gap:14rpx; margin-top:16rpx; }\n" +
  ".moontown-marketplace-request { padding:18rpx; border:2rpx solid var(--mt-line,#d7ccb8); border-radius:18rpx; background:var(--mt-paper,#fffaf0); }\n" +
  ".moontown-request-message,.moontown-request-result { margin-top:10rpx; line-height:1.55; }\n" +
  ".moontown-request-decision { display:grid; grid-template-columns:minmax(0,1fr) auto; gap:10rpx; margin-top:14rpx; }\n" +
  ".moontown-request-decision .moontown-policy-ceiling { grid-column:1 / -1; font-size:24rpx; color:var(--mt-muted,#645d52); }\n" +
  ".moontown-request-decision form:first-of-type { display:grid; grid-template-columns:minmax(0,1fr) auto; gap:10rpx; }\n" +
  ".moontown-request-decision input { min-height:88rpx; margin:0; }\n" +
  ".moontown-marketplace-runtime-receipt { display:grid; gap:10rpx; margin-top:14rpx; padding-top:12rpx; border-top:2rpx dashed var(--mt-line,#d7ccb8); }\n" +
  ".moontown-discovery-filter { display: flex; align-items: center; justify-content: center; gap: 6rpx; min-height: 88rpx; }\n" +
  ".moontown-market-section { margin-top: 24rpx; }\n" +
  ".moontown-market-section-heading { display: grid; grid-template-columns: 44rpx minmax(0,1fr); gap: 10rpx; align-items: start; padding-bottom: 10rpx; border-bottom: 1rpx solid rgba(30,86,70,.12); }\n" +
  ".moontown-market-section.sponsored { margin-top: 32rpx; padding-top: 20rpx; border-top: 2rpx solid #c58d2b; }\n" +
  ".moontown-market-list > .bunnia-list-windowed { display: flex; flex-direction: column; gap: 0; }\n" +
  ".moontown-market-listing { display: grid; grid-template-columns: 58rpx minmax(0,1fr) auto; gap: 14rpx; align-items: center; min-height: 148rpx; padding: 20rpx 6rpx; border-bottom: 1rpx solid rgba(30,86,70,.12); }\n" +
  ".moontown-market-listing.is-sponsored { border-left: 4rpx solid #c58d2b; padding-left: 16rpx; background: rgba(255,248,229,.58); }\n" +
  ".moontown-market-listing-icon, .moontown-channel-icon { display: flex; align-items: center; justify-content: center; width: 58rpx; height: 58rpx; border-radius: 16rpx; background: #e2f1eb; color: #1f6a54; }\n" +
  ".moontown-market-summary { margin-top: 4rpx; color: #4f6259; font-size: 23rpx; line-height: 32rpx; }\n" +
  ".moontown-market-meta { margin-top: 6rpx; color: #78716c; font-size: 20rpx; line-height: 28rpx; }\n" +
  ".moontown-market-reason, .moontown-sponsored-label, .moontown-market-fact, .moontown-channel-scope, .moontown-preview-fields-title { display: flex; align-items: center; gap: 6rpx; margin-top: 8rpx; color: #1f6a54; font-size: 20rpx; line-height: 28rpx; }\n" +
  ".moontown-sponsored-label { margin-top: 0; color: #8a5b10; font-weight: 800; }\n" +
  ".moontown-market-open { min-width: 118rpx; }\n" +
  ".moontown-market-state { display: grid; grid-template-columns: 44rpx minmax(0,1fr) auto; gap: 12rpx; align-items: center; margin-top: 14rpx; padding: 16rpx; border-radius: 18rpx; background: #edf6f1; }\n" +
  ".moontown-market-state.error { background: #fff1f2; color: #9f1239; }\n" +
  ".moontown-market-details, .moontown-market-publisher { position: fixed; z-index: 18; left: 16rpx; right: 16rpx; bottom: calc(124rpx + env(safe-area-inset-bottom)); max-height: 70vh; padding: 22rpx; overflow-y: auto; border: 1rpx solid rgba(30,86,70,.16); border-radius: 30rpx; background: #fbfdfb; box-shadow: 0 20rpx 60rpx rgba(20,63,50,.24); }\n" +
  ".moontown-market-details-head, .moontown-open-conversation-head { display: flex; align-items: flex-start; justify-content: space-between; gap: 12rpx; }\n" +
  ".moontown-icon-button { flex: 0 0 88rpx; width: 88rpx; min-width: 88rpx; padding: 0; display: flex; align-items: center; justify-content: center; }\n" +
  ".moontown-market-details-summary { margin-top: 12rpx; font-size: 24rpx; line-height: 36rpx; }\n" +
  ".moontown-market-details-facts, .moontown-market-detail-actions { display: flex; gap: 10rpx; flex-wrap: wrap; margin-top: 14rpx; }\n" +
  ".moontown-market-detail-actions form, .moontown-market-detail-actions > view { flex: 1 1 210rpx; }\n" +
  ".moontown-market-detail-actions button { width: 100%; }\n" +
  ".moontown-publish-preview-row { padding: 20rpx 0; border-bottom: 1rpx solid rgba(30,86,70,.12); }\n" +
  ".moontown-publish-preview-title { display: flex; align-items: center; gap: 10rpx; }\n" +
  ".moontown-public-stamp { margin-left: auto; padding: 5rpx 10rpx; border: 1rpx solid #1f6a54; border-radius: 999rpx; color: #1f6a54; font-size: 18rpx; font-weight: 800; }\n" +
  ".moontown-preview-fields { margin-top: 12rpx; padding-left: 12rpx; border-left: 4rpx solid #2f855a; }\n" +
  ".moontown-preview-fields.kind-withheld { border-left-color: #9f1239; }\n" +
  ".moontown-preview-field { margin-top: 5rpx; color: #66766e; font-size: 21rpx; }\n" +
  ".moontown-share-revoke { margin-top: 14rpx; padding: 14rpx; border: 1rpx solid rgba(159,18,57,.18); border-radius: 16rpx; background: #fff7f8; }\n" +
  ".moontown-share-revoke form { margin-top: 10rpx; }\n" +
  ".moontown-publish-preview-row form { margin-top: 12rpx; }\n" +
  ".moontown-message-mode-bar { display: grid; grid-template-columns: repeat(3,minmax(0,1fr)) 88rpx; gap: 8rpx; }\n" +
  ".moontown-message-mode.active, .moontown-channel-kind.active { border-color: #1f6a54; background: #1f6a54; color: #fff; }\n" +
  ".moontown-create-channel { margin-top: 14rpx; padding: 16rpx; border: 1rpx solid rgba(30,86,70,.14); border-radius: 20rpx; background: #f7fbf8; }\n" +
  ".moontown-create-channel-heading { display: grid; grid-template-columns: 44rpx minmax(0,1fr); gap: 10rpx; align-items: start; }\n" +
  ".moontown-create-channel form { display: grid; grid-template-columns: minmax(0,1fr) minmax(0,1fr) auto; gap: 8rpx; margin-top: 12rpx; }\n" +
  ".moontown-create-channel input { min-width: 0; margin: 0; }\n" +
  ".moontown-conversation-list { margin-top: 12rpx; border-top: 1rpx solid rgba(30,86,70,.1); }\n" +
  ".moontown-conversation-row { width: 100%; display: grid; grid-template-columns: 58rpx minmax(0,1fr) 36rpx; gap: 12rpx; align-items: center; min-height: 124rpx; padding: 18rpx 8rpx; border: 0; border-bottom: 1rpx solid rgba(30,86,70,.1); border-radius: 0; background: transparent; text-align: left; }\n" +
  ".moontown-conversation-row.unread { background: rgba(226,241,235,.72); }\n" +
  ".moontown-channel-unread-count { min-width: 36rpx; height: 36rpx; padding: 3rpx 8rpx; border-radius: 999rpx; background: #1f6a54; color: #fff; font-size: 18rpx; text-align: center; }\n" +
  ".moontown-open-conversation { margin-top: 14rpx; padding: 16rpx; border-top: 3rpx solid #1f6a54; background: #fff; }\n" +
  ".moontown-channel-message-list { max-height: 360rpx; margin-top: 14rpx; overflow-y: auto; }\n" +
  ".moontown-channel-message { max-width: 86%; margin-top: 10rpx; padding: 12rpx 14rpx; border-radius: 16rpx; background: #edf6f1; }\n" +
  ".moontown-open-conversation form { display: grid; grid-template-columns: minmax(0,1fr) auto; gap: 8rpx; margin-top: 14rpx; }\n" +
  ".moontown-notification-explainer { display: grid; grid-template-columns: 44rpx minmax(0,1fr); gap: 10rpx; margin-top: 12rpx; padding: 14rpx; border-radius: 18rpx; background: #edf6f1; }\n" +
  ".moontown-notice-entry { grid-template-columns: 56rpx minmax(0,1fr) auto; }\n" +
  ".moontown-notice-open { width: 100%; padding: 0; border: 0; border-radius: 0; background: transparent; text-align: left; }\n" +
  "@media (max-width:520px) { .moontown-marketplace-toolbar { grid-template-columns:minmax(0,1fr) 110rpx; } .moontown-marketplace-toolbar > form:last-child { grid-column:1 / -1; } .moontown-market-listing { grid-template-columns:52rpx minmax(0,1fr); } .moontown-market-open { grid-column:2; width:100%; } .moontown-message-mode-bar { grid-template-columns:repeat(3,minmax(0,1fr)); } .moontown-message-mode-bar .moontown-chat-refresh { grid-column:3; } .moontown-create-channel form,.moontown-request-decision,.moontown-request-decision form:first-of-type { grid-template-columns:1fr; } .moontown-request-decision .moontown-policy-ceiling { grid-column:1; } }\n"
}
