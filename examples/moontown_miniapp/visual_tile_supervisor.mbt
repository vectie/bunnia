///|
fn tile_supervisor_wxss() -> String {
  ".moontown-registration-kiosk { padding: 22rpx; border: 2rpx solid rgba(31,106,84,0.22); border-radius: 28rpx; background: rgba(250,253,251,0.96); box-shadow: 0 12rpx 30rpx rgba(20,63,50,0.09); }\n" +
  ".moontown-kiosk-header { display: flex; flex-direction: column; gap: 6rpx; }\n" +
  ".moontown-kiosk-sign { align-self: flex-start; padding: 6rpx 12rpx; border: 2rpx solid #1f6a54; border-radius: 8rpx; background: #e2f1eb; color: #1f5a48; font-size: 18rpx; line-height: 26rpx; font-weight: 900; letter-spacing: 1rpx; }\n" +
  ".moontown-kiosk-progress { display: grid; grid-template-columns: repeat(5,minmax(0,1fr)); gap: 12rpx; margin-top: 16rpx; }\n" +
  ".moontown-kiosk-progress-stop { min-width: 0; color: #78847e; font-size: 17rpx; line-height: 24rpx; text-align: center; }\n" +
  ".moontown-kiosk-step-number { display: flex; align-items: center; justify-content: center; width: 38rpx; height: 38rpx; margin: 0 auto 4rpx; border: 2rpx solid #b7c9c0; border-radius: 999rpx; background: #f7fbf8; color: #617169; font-weight: 900; }\n" +
  ".moontown-kiosk-progress-stop.active { color: #1f5a48; font-weight: 800; }\n" +
  ".moontown-kiosk-progress-stop.active .moontown-kiosk-step-number { border-color: #1f6a54; background: #1f6a54; color: #fff; }\n" +
  ".moontown-kiosk-step { margin-top: 20rpx; padding-top: 18rpx; border-top: 1rpx dashed rgba(31,106,84,0.25); }\n" +
  ".moontown-kiosk-step-heading { margin-bottom: 12rpx; }\n" +
  ".moontown-kiosk-choice-section { margin-top: 14rpx; }\n" +
  ".moontown-kiosk-choice-grid, .moontown-avatar-choices { display: grid; grid-template-columns: repeat(2,minmax(0,1fr)); gap: 16rpx; margin-top: 8rpx; }\n" +
  ".moontown-kiosk-choice { min-height: 108rpx; padding: 12rpx; border-radius: 18rpx; text-align: left; }\n" +
  ".moontown-kiosk-choice.selected { border: 2rpx solid #1f6a54; background: #e2f1eb; box-shadow: inset 0 0 0 2rpx rgba(255,255,255,0.7); }\n" +
  ".moontown-kiosk-actions { display: flex; gap: 16rpx; flex-wrap: wrap; margin-top: 18rpx; }\n" +
  ".moontown-kiosk-actions > button { flex: 1 1 150rpx; min-height: 88rpx; }\n" +
  ".moontown-setup-state-stack { margin-top: 10rpx; }\n" +
  ".moontown-setup-state { margin-top: 8rpx; padding: 12rpx 14rpx; border: 1rpx solid #b7c9c0; border-radius: 14rpx; background: #f7fbf8; color: #52645b; font-size: 21rpx; }\n" +
  ".moontown-setup-state.loading { border-color: #5b6fc7; background: #eef2ff; color: #38458a; }\n" +
  ".moontown-setup-state.error, .moontown-setup-state.conflict { border-color: #dc6b6b; background: #fff1f1; color: #8e3030; }\n" +
  ".moontown-setup-state.saved { border-color: #2f855a; background: #edf8f2; color: #166534; }\n" +
  ".moontown-binding-row { display: grid; grid-template-columns: 64rpx minmax(0,1fr) auto; align-items: center; gap: 12rpx; min-height: 92rpx; margin-top: 10rpx; padding: 12rpx 14rpx; border: 1rpx solid rgba(31,106,84,0.16); border-radius: 18rpx; background: #fff; }\n" +
  ".moontown-binding-icon, .moontown-supervisor-avatar { display: flex; align-items: center; justify-content: center; width: 58rpx; height: 58rpx; border-radius: 14rpx; background: #dceee6; color: #1f5a48; font-size: 22rpx; font-weight: 900; }\n" +
  ".moontown-supervisor-avatar { position: relative; overflow: hidden; }\n" +
  ".moontown-supervisor-avatar-image, .moontown-avatar-choice-preview { display: block; width: 100%; height: 100%; object-fit: cover; }\n" +
  ".moontown-supervisor-avatar-image.lantern { filter: hue-rotate(26deg) saturate(0.86); }\n" +
  ".moontown-avatar-choice-preview { width: 76rpx; height: 76rpx; margin-bottom: 8rpx; border-radius: 16rpx; background: #dceee6; }\n" +
  ".moontown-binding-copy { min-width: 0; }\n" +
  ".moontown-binding-status, .moontown-agent-live-status { padding: 5rpx 9rpx; border-radius: 8rpx; background: #edf8f2; color: #166534; font-size: 18rpx; font-weight: 800; }\n" +
  ".moontown-kiosk-callout { margin-top: 12rpx; padding: 14rpx; border-left: 6rpx solid #d49b36; border-radius: 10rpx; background: #fff8e8; }\n" +
  ".moontown-setup-review-row { margin-top: 8rpx; padding: 12rpx 14rpx; border-bottom: 1rpx solid rgba(31,106,84,0.12); }\n" +
  ".moontown-consent-row { width: 100%; min-height: 88rpx; margin-top: 10rpx; padding-left: 54rpx; position: relative; text-align: left; }\n" +
  ".moontown-consent-row::before { position: absolute; left: 16rpx; top: 26rpx; width: 28rpx; height: 28rpx; border: 2rpx solid #7b9186; border-radius: 7rpx; content: ''; }\n" +
  ".moontown-consent-row.selected::before { border-color: #1f6a54; background: #1f6a54; box-shadow: inset 0 0 0 6rpx #e2f1eb; }\n" +
  ".moontown-activation-seal { margin: 18rpx auto; padding: 20rpx; border: 4rpx double #1f6a54; border-radius: 999rpx; background: #edf8f2; color: #1f5a48; font-weight: 900; text-align: center; }\n" +
  ".moontown-supervisor-lodge { padding: 18rpx; border: 1rpx solid rgba(31,106,84,0.16); border-radius: 24rpx; background: rgba(255,255,255,0.9); }\n" +
  ".moontown-realm-supervisor-signal { position: absolute; z-index: 8; left: 22rpx; top: calc(18rpx + env(safe-area-inset-top)); display: grid; grid-template-columns: 58rpx minmax(0,1fr); align-items: center; gap: 10rpx; width: min(390rpx,calc(100vw - 220rpx)); min-height: 88rpx; padding: 10rpx 14rpx; border: 2rpx solid rgba(233,247,240,0.55); border-radius: 20rpx; background: rgba(20,63,50,0.88); box-shadow: 0 8rpx 24rpx rgba(15,23,42,0.2); text-align: left; }\n" +
  ".moontown-realm-supervisor-signal .mt-title, .moontown-realm-supervisor-signal .mt-title text { color: #f7fbf8 !important; }\n" +
  ".moontown-realm-supervisor-signal .mt-meta, .moontown-realm-supervisor-signal .mt-meta text { color: #c8e6d9 !important; }\n" +
  ".moontown-supervisor-lodge-header, .moontown-supervisor-phone-head { display: grid; grid-template-columns: 64rpx minmax(0,1fr) auto; align-items: center; gap: 12rpx; }\n" +
  ".moontown-supervisor-metrics { display: flex; gap: 8rpx; margin-top: 12rpx; }\n" +
  ".moontown-supervisor-phone { padding: 18rpx; border: 1rpx solid rgba(31,106,84,0.14); border-radius: 24rpx; background: rgba(255,255,255,0.92); }\n" +
  ".moontown-supervisor-registration-cta { display: flex; flex-direction: column; gap: 12rpx; padding: 18rpx; border: 2rpx dashed rgba(31,106,84,0.3); border-radius: 24rpx; background: rgba(247,251,248,0.94); }\n" +
  ".moontown-supervisor-thread { margin-top: 14rpx; padding: 12rpx; border-radius: 18rpx; background: #edf6f1; }\n" +
  ".moontown-supervisor-bubble { max-width: 86%; padding: 12rpx 14rpx; border-radius: 16rpx; background: #fff; color: #44544c; }\n" +
  ".moontown-supervisor-bubble.user { margin: 10rpx 0 0 auto; background: #dceee6; }\n" +
  ".moontown-supervisor-compose { display: grid; grid-template-columns: minmax(0,1fr) 120rpx; gap: 16rpx; align-items: end; margin-top: 12rpx; }\n" +
  ".moontown-supervisor-compose .moontown-section-label { grid-column: 1 / -1; }\n" +
  ".moontown-supervisor-compose input { margin-top: 0; }\n" +
  ".moontown-worker-policy-card { margin-top: 14rpx; padding: 14rpx; border: 1rpx solid rgba(31,106,84,0.18); border-radius: 16rpx; background: #f7fbf8; }\n" +
  ".moontown-worker-policy-card .mt-meta + .mt-meta { margin-top: 5rpx; }\n" +
  ".moontown-assign-worker-action { display: inline-flex; align-items: center; justify-content: center; gap: 10rpx; width: 100%; min-height: 88rpx; margin-top: 12rpx; }\n" +
  ".moontown-assign-worker-icon { display: inline-flex; align-items: center; justify-content: center; width: 44rpx; height: 44rpx; border: 2rpx solid currentColor; border-radius: 12rpx; font-size: 18rpx; line-height: 1; font-weight: 900; }\n" +
  ".moontown-phone-command-state { margin-top: 8rpx; color: #617169; font-size: 20rpx; }\n" +
  ".moontown-child-task-board, .moontown-acceptance-ledger { padding: 18rpx; border: 1rpx solid rgba(31,106,84,0.14); border-radius: 24rpx; background: rgba(255,255,255,0.92); }\n" +
  ".moontown-child-task, .moontown-acceptance-receipt { margin-top: 10rpx; padding: 16rpx; border-left: 5rpx solid #5b6fc7; border-radius: 18rpx; background: #f8faf9; }\n" +
  ".moontown-child-task-head { display: flex; align-items: flex-start; justify-content: space-between; gap: 10rpx; }\n" +
  ".moontown-receipt-stamp { flex: 0 0 auto; padding: 5rpx 8rpx; border: 1rpx solid currentColor; border-radius: 8rpx; color: #7c6a37; font-size: 16rpx; line-height: 24rpx; font-weight: 900; }\n" +
  ".moontown-receipt-stamp.accepted { color: #166534; }\n" +
  ".moontown-receipt-stamp.rejected, .moontown-receipt-stamp.failed { color: #991b1b; }\n" +
  ".moontown-child-task-controls { display: grid; grid-template-columns: minmax(0,1fr) auto auto; gap: 16rpx; align-items: end; margin-top: 10rpx; }\n" +
  ".moontown-child-task-controls .moontown-section-label { grid-column: 1 / -1; }\n" +
  ".moontown-child-task-controls input { margin: 0; }\n" +
  ".moontown-acceptance-receipt.pending { border-left-color: #d49b36; }\n" +
  ".moontown-acceptance-receipt.accepted { border-left-color: #2f855a; }\n" +
  ".moontown-acceptance-receipt.rejected { border-left-color: #dc6b6b; }\n" +
  "@media (max-width: 390px) { .moontown-kiosk-progress-stop { font-size: 15rpx; } .moontown-kiosk-choice-grid, .moontown-avatar-choices { grid-template-columns: 1fr; } .moontown-child-task-controls { grid-template-columns: 1fr 1fr; } .moontown-child-task-controls input { grid-column: 1 / -1; } }\n"
}
