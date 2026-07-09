///|
fn reviewer_wxss_source() -> String {
  ".moontown-miniapp { min-height: 100vh; background: #10150f; color: #16221a; font-size: 24rpx; line-height: 1.35; overflow-wrap: anywhere; word-break: break-word; }\n" +
  ".moontown-page-surface { min-height: 100vh; padding: 24rpx; box-sizing: border-box; background: #f8f3df; }\n" +
  ".moontown-credential-plaque { padding: 18rpx; border: 2rpx solid #8a6d3b; border-radius: 8rpx; background: #fffaf0; }\n" +
  ".mt-title { margin-bottom: 8rpx; color: #243629; font-size: 30rpx; font-weight: 800; }\n" +
  ".mt-meta { margin-top: 8rpx; color: #5f6d5f; font-size: 22rpx; }\n" +
  ".moontown-diagnostic-section { margin-top: 16rpx; padding: 14rpx; border: 1rpx solid rgba(36,54,41,0.18); border-radius: 6rpx; background: rgba(255,255,255,0.7); }\n" +
  ".moontown-diagnostic-list { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 8rpx; margin-top: 10rpx; }\n" +
  ".moontown-diagnostic-row { min-width: 0; padding: 10rpx; border-radius: 6rpx; background: rgba(36,54,41,0.08); color: #243629; font-size: 20rpx; box-sizing: border-box; overflow: hidden; }\n" +
  ".moontown-diagnostic-row text { display: block; overflow: hidden; text-overflow: ellipsis; }\n" +
  ".moontown-community-actions { display: flex; gap: 10rpx; margin-top: 14rpx; flex-wrap: wrap; }\n" +
  "button { min-width: 88rpx; min-height: 72rpx; padding: 8rpx 18rpx; border: 1rpx solid #243629; border-radius: 6rpx; background: #243629; color: #fff8dc; font-size: 22rpx; touch-action: manipulation; }"
}

///|
fn moontown_wxss_source() -> String {
  tile_base_wxss() +
  tile_map_wxss() +
  tile_shell_wxss() +
  tile_primitives_wxss() +
  tile_state_wxss() +
  tile_content_wxss() +
  tile_drawer_wxss() +
  tile_responsive_wxss()
}

///|
fn tile_base_wxss() -> String {
  ".moontown-miniapp { position: relative; min-height: 100vh; overflow: hidden; background: #10150f; color: #16221a; font-size: 24rpx; line-height: 1.35; overflow-wrap: anywhere; word-break: break-word; overscroll-behavior: contain; }\n" +
  "view, button, input { box-sizing: border-box; }\n" +
  "button { min-width: 88rpx; min-height: 72rpx; max-width: 100%; margin: 0; padding: 8rpx 16rpx; border: 1rpx solid rgba(51,65,55,0.28); border-radius: 6rpx; background: #fff8dc; color: #243629; font-size: 20rpx; line-height: 28rpx; overflow: hidden; touch-action: manipulation; }\n" +
  "button::after { border: 0; }\n" +
  "button:active { opacity: 0.82; }\n" +
  "button[disabled], .bunnia-status-disabled { opacity: 0.52; pointer-events: none; }\n" +
  "button text { white-space: normal; text-align: center; overflow-wrap: anywhere; word-break: break-word; }\n" +
  ".mt-panel input { width: 100%; min-height: 72rpx; margin-top: 8rpx; padding: 0 14rpx; border: 1rpx solid rgba(51,65,55,0.22); border-radius: 6rpx; background: rgba(255,255,255,0.86); color: #26362b; font-size: 20rpx; }\n"
}

///|
fn tile_map_wxss() -> String {
  ".moontown-map-fullscreen { position: absolute; left: 0; top: 0; right: 0; bottom: 0; overflow: hidden; background: #10150f; }\n" +
  ".moontown-map-touch-area { position: absolute; left: 0; top: 0; right: 0; bottom: 0; z-index: 1; width: 100vw; height: 100vh; overflow: hidden; background: #10150f; touch-action: none; }\n" +
  ".moontown-map-drag-content { position: absolute; left: 0; top: 0; width: \{moontown_map_display_width()}rpx; height: \{moontown_map_display_height()}rpx; overflow: hidden; transform-origin: 0 0; will-change: transform; }\n" +
  ".moontown-wenyu-map-image { position: absolute; left: 0; top: 0; width: \{moontown_map_display_width()}rpx; height: \{moontown_map_display_height()}rpx; display: block; }\n" +
  ".moontown-map-marker { position: absolute; z-index: 3; min-width: 112rpx; max-width: 180rpx; min-height: 54rpx; padding: 8rpx 10rpx; border: 2rpx solid rgba(255,255,255,0.68); border-radius: 8rpx; background: rgba(255, 248, 220, 0.88); color: #1e2c21; }\n" +
  ".moontown-map-marker.selected { border-width: 3rpx; box-shadow: 0 0 0 4rpx rgba(255,248,220,0.36); }\n" +
  ".moontown-map-marker-title { display: block; color: #1f2d22; font-size: 18rpx; font-weight: 800; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }\n" +
  ".moontown-map-marker-kind { display: block; margin-top: 2rpx; color: #56604f; font-size: 15rpx; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }\n" +
  ".moontown-thread-pin { position: absolute; right: -10rpx; top: -10rpx; min-width: 48rpx; height: 28rpx; padding: 0 8rpx; border-radius: 999rpx; background: #203729; color: #fff8dc; font-size: 15rpx; line-height: 28rpx; text-align: center; border: 1rpx solid rgba(255,255,255,0.68); }\n" +
  ".moontown-semantic-scene { position: absolute; left: 0; top: 0; width: 1rpx; height: 1rpx; opacity: 0; overflow: hidden; pointer-events: none; }\n" +
  ".moontown-semantic-scene .bunnia-scene { pointer-events: none; }\n"
}

///|
fn tile_shell_wxss() -> String {
  ".moontown-topbar { position: absolute; left: 24rpx; right: 24rpx; top: calc(24rpx + env(safe-area-inset-top)); z-index: 8; display: flex; align-items: center; justify-content: space-between; gap: 16rpx; padding: 14rpx 16rpx; border: 1rpx solid rgba(255,255,255,0.52); border-radius: 8rpx; background: rgba(252, 249, 226, 0.9); }\n" +
  ".moontown-title { font-size: 34rpx; font-weight: 800; color: #203222; }\n" +
  ".moontown-subtitle { margin-top: 2rpx; font-size: 20rpx; font-weight: 500; color: #66705a; }\n" +
  ".moontown-user-switcher { display: flex; align-items: center; justify-content: flex-end; gap: 8rpx; flex-wrap: wrap; max-width: 440rpx; }\n" +
  ".moontown-user-switcher text { color: #334538; font-size: 20rpx; }\n" +
  ".moontown-page-surface { position: absolute; z-index: 7; left: 22rpx; right: 22rpx; top: calc(126rpx + env(safe-area-inset-top)); bottom: calc(104rpx + env(safe-area-inset-bottom)); overflow: hidden; display: grid; grid-template-columns: minmax(0, 1fr); gap: 12rpx; }\n" +
  ".moontown-page-grid { min-height: 0; display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 12rpx; align-content: start; overflow: hidden; }\n" +
  ".moontown-page-grid.three { grid-template-columns: repeat(3, minmax(0, 1fr)); }\n" +
  ".moontown-tabbar { position: absolute; z-index: 9; left: 22rpx; right: 22rpx; bottom: calc(18rpx + env(safe-area-inset-bottom)); display: grid; grid-template-columns: repeat(5, 1fr); gap: 8rpx; padding: 10rpx; border: 1rpx solid rgba(255,255,255,0.5); border-radius: 8rpx; background: rgba(31, 49, 36, 0.88); }\n" +
  ".moontown-tab-button { min-height: 64rpx; padding: 8rpx 6rpx; border: 1rpx solid rgba(255,248,220,0.3); border-radius: 6rpx; background: rgba(255,248,220,0.16); color: #fff8dc; font-size: 18rpx; line-height: 24rpx; overflow: hidden; }\n" +
  ".moontown-tab-button.active { background: #fff8dc; color: #243629; font-weight: 800; }\n"
}

///|
fn tile_primitives_wxss() -> String {
  ".mt-panel { padding: 14rpx; border: 1rpx solid rgba(255,255,255,0.46); border-radius: 8rpx; background: rgba(252, 249, 226, 0.86); }\n" +
  ".mt-panel-title { display: block; color: #203222; font-size: 24rpx; font-weight: 800; }\n" +
  ".mt-panel-note { display: block; margin-top: 4rpx; color: #53624e; font-size: 18rpx; }\n" +
  "\{tile_row_selectors()} { min-width: 0; margin-top: 8rpx; padding: 10rpx; border: 1rpx solid rgba(51,65,55,0.16); border-radius: 6rpx; background: rgba(255,250,240,0.76); box-shadow: 0 2rpx 0 rgba(31,49,36,0.08); overflow: hidden; }\n" +
  ".moontown-profile-card, .moontown-credential-plaque { margin-top: 8rpx; padding: 12rpx; border: 1rpx solid rgba(51,65,55,0.16); border-radius: 6rpx; background: rgba(255,255,255,0.66); }\n" +
  ".moontown-page-surface text, .moontown-right-hud text, .moontown-bottom-hud text { display: block; color: #405244; font-size: 18rpx; line-height: 1.28; }\n" +
  ".mt-title, .mt-title text { color: #1f3327 !important; font-size: 20rpx !important; font-weight: 800; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }\n" +
  ".mt-meta, .mt-meta text { margin-top: 2rpx; color: #6b745f !important; font-size: 16rpx !important; }\n" +
  ".moontown-profile-status { margin: 8rpx 0; padding: 8rpx 10rpx; border-radius: 6rpx; background: rgba(37,55,43,0.12); color: #334538; font-size: 18rpx; }\n" +
  ".moontown-profile-actions, .moontown-profile-metrics { display: flex; flex-direction: row; gap: 8rpx; overflow: hidden; margin-top: 8rpx; }\n" +
  ".moontown-profile-metric { flex: 1 1 0; min-width: 0; padding: 8rpx; border-radius: 6rpx; background: rgba(37,55,43,0.1); color: #334538; font-size: 18rpx; }\n" +
  "\{tile_action_row_selectors()} { display: flex; flex-direction: row; gap: 8rpx; flex-wrap: wrap; margin-top: 8rpx; }\n" +
  "\{tile_action_button_selectors()} { flex: 1 1 0; min-width: 112rpx; }\n" +
  ".moontown-run-action, .bunnia-tool-result-action { flex: 0 0 auto; }\n" +
  ".moontown-discovery-badges, .moontown-object-badges { display: flex; gap: 6rpx; flex-wrap: wrap; margin-top: 6rpx; }\n" +
  ".moontown-discovery-badge, .moontown-object-badge { min-height: 32rpx; padding: 4rpx 8rpx; border-radius: 6rpx; background: rgba(37,55,43,0.1); font-size: 16rpx; line-height: 24rpx; }\n"
}

///|
fn tile_state_wxss() -> String {
  ".bunnia-status-review, .bunnia-status-pending, .bunnia-status-stale, .bunnia-status-waiting { border-color: rgba(214,158,46,0.58); background: rgba(255,244,207,0.78); }\n" +
  ".bunnia-status-stable, .bunnia-status-ready, .bunnia-status-published { border-color: rgba(72,187,120,0.48); background: rgba(228,243,216,0.76); }\n" +
  ".bunnia-status-current { border-color: rgba(32,55,41,0.5); background: rgba(255,248,220,0.9); }\n" +
  ".bunnia-status-running { border-color: rgba(49,130,206,0.44); background: rgba(217,237,247,0.78); }\n" +
  ".bunnia-status-blocked, .bunnia-status-failed { border-color: rgba(198,68,56,0.58); background: rgba(255,232,224,0.78); }\n" +
  ".bunnia-status-draft { border-color: rgba(128,90,213,0.38); background: rgba(241,234,255,0.72); }\n" +
  ".bunnia-status-shared { border-color: rgba(183,121,31,0.42); background: rgba(245,229,188,0.76); }\n"
}

///|
fn tile_content_wxss() -> String {
  ".moontown-district-actions { display: flex; gap: 8rpx; margin-top: 8rpx; }\n" +
  ".moontown-district-entry.tone-blue { border-color: rgba(49,130,206,0.44); background: rgba(231,243,255,0.72); }\n" +
  ".moontown-district-entry.tone-orange { border-color: rgba(221,107,32,0.42); background: rgba(255,238,214,0.72); }\n" +
  ".moontown-district-entry.tone-purple { border-color: rgba(128,90,213,0.38); background: rgba(241,234,255,0.72); }\n" +
  ".moontown-district-entry.tone-pink { border-color: rgba(213,63,140,0.34); background: rgba(255,232,242,0.72); }\n" +
  ".moontown-district-entry.tone-green { border-color: rgba(56,161,105,0.42); background: rgba(226,246,231,0.72); }\n" +
  ".moontown-presence-row .bunnia-list-windowed { display: flex; flex-direction: row; gap: 8rpx; overflow: hidden; }\n" +
  ".moontown-presence-chip { flex: 0 0 136rpx; min-width: 0; }\n" +
  ".moontown-guide-strip .bunnia-list-windowed, .moontown-discovery-strip .bunnia-list-windowed, .moontown-message-buckets { display: flex; flex-direction: row; gap: 8rpx; overflow: hidden; margin-top: 8rpx; }\n" +
  ".moontown-attention-rows .bunnia-list-windowed { display: flex; flex-direction: column; gap: 8rpx; margin-top: 8rpx; overflow: hidden; }\n" +
  ".moontown-inventory-shelves { margin-top: 8rpx; }\n" +
  ".moontown-inventory-shelves .bunnia-list-windowed { display: flex; flex-direction: row; gap: 8rpx; margin-top: 8rpx; overflow: hidden; }\n" +
  ".moontown-inventory-shelf { flex: 0 0 168rpx; min-width: 0; }\n" +
  ".moontown-guide-step { flex: 0 0 184rpx; min-width: 0; }\n" +
  ".moontown-discovery-chip, .moontown-message-bucket { flex: 0 0 152rpx; min-width: 0; padding: 10rpx; border: 1rpx solid rgba(51,65,55,0.16); border-radius: 6rpx; background: rgba(255,250,240,0.78); overflow: hidden; }\n" +
  ".moontown-discovery-filters .bunnia-list-windowed, .moontown-message-channels .bunnia-list-windowed, .moontown-ownership-filters .bunnia-list-windowed, .moontown-lifecycle-actions, .moontown-lifecycle-stages { display: flex; flex-direction: row; gap: 8rpx; overflow: hidden; margin-top: 8rpx; }\n" +
  ".moontown-lifecycle-stage { flex: 0 0 auto; min-height: 36rpx; padding: 6rpx 8rpx; font-size: 16rpx; line-height: 24rpx; }\n" +
  ".moontown-discovery-filter, .moontown-message-channel, .moontown-ownership-filter { flex: 0 0 auto; min-height: 56rpx; padding: 10rpx 12rpx; border: 1rpx solid rgba(51,65,55,0.18); border-radius: 6rpx; background: rgba(255,250,240,0.7); color: #334538; font-size: 18rpx; line-height: 28rpx; overflow: hidden; }\n" +
  ".moontown-discovery-filter.active, .moontown-message-channel.active, .moontown-ownership-filter.active { background: #203729; color: #fff8dc; }\n"
}

///|
fn tile_drawer_wxss() -> String {
  ".moontown-right-hud { position: absolute; z-index: 7; right: 22rpx; top: 126rpx; width: 300rpx; display: flex; flex-direction: column; gap: 12rpx; }\n" +
  ".moontown-building-drawer, .moontown-chat-drawer, .moontown-create-drawer { min-width: 0; padding: 14rpx; border: 1rpx solid rgba(255,255,255,0.52); border-radius: 8rpx; background: rgba(252, 249, 226, 0.9); overflow: hidden; }\n" +
  ".moontown-building-drawer text, .moontown-chat-drawer text, .moontown-create-drawer text { display: block; color: #405244; font-size: 20rpx; }\n" +
  ".moontown-object-section, .moontown-worker-entry { min-width: 0; margin-top: 8rpx; padding: 10rpx; border: 1rpx solid rgba(51,65,55,0.16); border-radius: 6rpx; background: rgba(255,250,240,0.7); }\n" +
  ".moontown-building-drawer button { margin-top: 8rpx; margin-right: 6rpx; }\n" +
  ".moontown-chat-drawer .bunnia-message-feed-windowed { max-height: 170rpx; overflow: hidden; }\n" +
  ".moontown-chat-drawer .bunnia-message { padding: 10rpx 12rpx; margin-bottom: 8rpx; background: rgba(255,255,255,0.78); font-size: 20rpx; }\n" +
  ".moontown-chat-drawer .bunnia-review { margin-top: 8rpx; padding: 10rpx; gap: 8rpx; background: rgba(255,255,255,0.68); }\n" +
  ".moontown-bottom-hud { position: absolute; z-index: 7; left: 22rpx; right: 344rpx; bottom: calc(104rpx + env(safe-area-inset-bottom)); display: block; }\n" +
  ".moontown-map-state-strip { min-width: 0; padding: 12rpx; border: 1rpx solid rgba(255,255,255,0.42); border-radius: 8rpx; background: rgba(37, 55, 43, 0.72); display: flex; flex-direction: row; gap: 8rpx; overflow: hidden; }\n" +
  ".moontown-map-state-chip { flex: 0 0 auto; max-width: 196rpx; padding: 8rpx 10rpx; border: 1rpx solid rgba(255,255,255,0.32); border-radius: 6rpx; background: rgba(255, 248, 220, 0.92); color: #27372b; font-size: 18rpx; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }\n" +
  ".moontown-create-drawer input { min-height: 46rpx; margin-bottom: 8rpx; padding: 0 10rpx; border: 1rpx solid rgba(51, 65, 55, 0.22); border-radius: 6rpx; background: rgba(255,255,255,0.82); color: #26362b; font-size: 20rpx; }\n" +
  ".moontown-create-drawer form { display: block; margin-bottom: 8rpx; }\n" +
  ".moontown-create-drawer form:last-child { margin-bottom: 0; }\n"
}

///|
fn tile_responsive_wxss() -> String {
  "@media (max-width: 520px) { .moontown-page-surface { left: 16rpx; right: 16rpx; } .moontown-page-grid, .moontown-page-grid.three { grid-template-columns: 1fr; } .moontown-create-drawer { display: none; } .moontown-right-hud { left: 16rpx; right: 16rpx; top: 126rpx; width: auto; } .moontown-bottom-hud { left: 16rpx; right: 16rpx; } }"
}

///|
fn tile_row_selectors() -> String {
  ".moontown-guide-step, .moontown-onboarding-step, .moontown-setup-gate, .moontown-publication-step, .moontown-role-entry, .moontown-district-entry, .moontown-presence-chip, .moontown-discover-entry, .moontown-discover-empty, .moontown-attention-row, .moontown-inventory-shelf, .moontown-notice-entry, .moontown-owned-entry, .moontown-workbench-alert, .moontown-book-entry, .moontown-run-entry, .moontown-object-message, .moontown-object-context-card, .moontown-lifecycle-stage, .moontown-lifecycle-stamp, .moontown-review-entry, .moontown-agent-result, .moontown-audit-entry, .bunnia-tool-result-card"
}

///|
fn tile_action_row_selectors() -> String {
  ".moontown-community-actions, .moontown-discovery-action, .moontown-profile-actions, .moontown-run-actions, .moontown-object-primary-actions"
}

///|
fn tile_action_button_selectors() -> String {
  ".moontown-community-actions button, .moontown-discovery-action button, .moontown-profile-actions button, .moontown-run-actions button, .moontown-object-primary-actions button"
}
