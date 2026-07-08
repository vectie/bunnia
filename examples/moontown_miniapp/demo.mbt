///|
pub fn demo_view() -> @bunnia.Node {
  mini_town_view(demo_projection())
}

///|
pub fn mini_town_view(projection : MiniTownProjection) -> @bunnia.Node {
  mini_town_view_with_map_mode(projection, full_map=true)
}

///|
fn mini_town_route_view(projection : MiniTownProjection) -> @bunnia.Node {
  mini_town_view_with_map_mode(
    projection,
    full_map=projection.active_tab_id == "realm",
  )
}

///|
fn mini_town_view_with_map_mode(
  projection : MiniTownProjection,
  full_map~ : Bool,
) -> @bunnia.Node {
  @bunnia.page([
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("moontown-miniapp"),
        @bunnia.data("active-user", projection.active_user_id),
      ],
      [
        if full_map {
          town_map_surface(projection)
        } else {
          town_map_backdrop(projection)
        },
        town_top_bar(projection),
        town_active_surface(projection),
        town_tabbar(projection),
      ],
    ),
  ])
}

///|
pub fn demo_wechat_page() -> @bunnia.WechatPage {
  let page = @bunnia.generate_wechat_page_with_runtime(
    "Moontown Miniapp",
    demo_view(),
    demo_runtime(),
  )
  @bunnia.wechat_page_with_wxss(page, page.wxss + "\n" + moontown_wxss())
}

///|
pub fn demo_wechat_project() -> @bunnia.WechatProject {
  demo_wechat_project_with_render_budget(@bunnia.default_render_budget())
}

///|
pub fn demo_wechat_project_with_render_budget(
  render_budget : @bunnia.RenderBudget,
) -> @bunnia.WechatProject {
  @bunnia.generate_wechat_project_from_pages_with_backend(
    name="Moontown Miniapp",
    pages=demo_wechat_project_pages(render_budget),
    backend_contract=demo_backend_contract(),
  )
}

///|
fn demo_wechat_project_pages(
  render_budget : @bunnia.RenderBudget,
) -> Array[@bunnia.WechatProjectPage] {
  let pages : Array[@bunnia.WechatProjectPage] = []
  for tab_id in ["realm", "home", "discover", "messages", "my"] {
    pages.push(demo_wechat_project_page_for_tab(tab_id, render_budget))
  }
  pages
}

///|
fn demo_wechat_project_page_for_tab(
  tab_id : String,
  render_budget : @bunnia.RenderBudget,
) -> @bunnia.WechatProjectPage {
  let page = @bunnia.wechat_project_page(
    name=moontown_tab_page_name(tab_id),
    route=moontown_tab_route(tab_id),
    root=mini_town_route_view(switch_tab(demo_projection(), tab_id)),
    runtime=demo_runtime_for_tab(tab_id),
    render_budget~,
  )
  scoped_project_page_runtime(
    @bunnia.wechat_project_page_with_wxss(page, moontown_wxss()),
  )
}

///|
fn scoped_project_page_runtime(
  page : @bunnia.WechatProjectPage,
) -> @bunnia.WechatProjectPage {
  let runtime = @bunnia.wechat_runtime(
    initial_data_json=page.runtime.initial_data_json,
    event_patches=scoped_event_patches(
      page.runtime.event_patches,
      page.page.plan.event_messages,
    ),
    page_methods_js=page.runtime.page_methods_js,
  )
  @bunnia.wechat_project_page_with_runtime(page, runtime)
}

///|
fn scoped_event_patches(
  patches : Array[@bunnia.WechatEventPatch],
  messages : Array[String],
) -> Array[@bunnia.WechatEventPatch] {
  let output : Array[@bunnia.WechatEventPatch] = []
  for message in messages {
    output.push(scoped_event_patch(patches, message))
  }
  output
}

///|
fn scoped_event_patch(
  patches : Array[@bunnia.WechatEventPatch],
  message : String,
) -> @bunnia.WechatEventPatch {
  for patch in patches {
    if patch.message == message {
      return patch
    }
  }
  @bunnia.wechat_event_patch(message, [])
}

///|
fn moontown_tab_page_name(tab_id : String) -> String {
  if tab_id == "home" {
    "Moontown Home"
  } else if tab_id == "discover" {
    "Moontown Discover"
  } else if tab_id == "messages" {
    "Moontown Messages"
  } else if tab_id == "my" {
    "Moontown My"
  } else {
    "Moontown Realm"
  }
}

///|
fn moontown_tab_route(tab_id : String) -> String {
  if tab_id == "home" {
    "pages/moontown/home"
  } else if tab_id == "discover" {
    "pages/moontown/discover"
  } else if tab_id == "messages" {
    "pages/moontown/messages"
  } else if tab_id == "my" {
    "pages/moontown/my"
  } else {
    "pages/moontown/index"
  }
}

///|
fn moontown_wxss() -> String {
  minify_moontown_wxss(moontown_wxss_source())
}

///|
fn moontown_wxss_source() -> String {
  ".moontown-miniapp { position: relative; min-height: 100vh; overflow: hidden; background: #10150f; color: #16221a; font-size: 24rpx; line-height: 1.35; }\n" +
  ".moontown-map-fullscreen { position: absolute; left: 0; top: 0; right: 0; bottom: 0; overflow: hidden; background: #10150f; }\n" +
  ".moontown-map-touch-area { position: absolute; left: 0; top: 0; right: 0; bottom: 0; z-index: 1; width: 100vw; height: 100vh; overflow: hidden; background: #10150f; }\n" +
  ".moontown-map-drag-content { position: absolute; left: 0; top: 0; width: \{moontown_map_display_width()}rpx; height: \{moontown_map_display_height()}rpx; overflow: hidden; transform-origin: 0 0; will-change: transform; }\n" +
  ".moontown-wenyu-map-image { position: absolute; left: 0; top: 0; width: \{moontown_map_display_width()}rpx; height: \{moontown_map_display_height()}rpx; display: block; }\n" +
  ".moontown-map-marker { position: absolute; z-index: 3; min-width: 112rpx; max-width: 180rpx; min-height: 54rpx; padding: 8rpx 10rpx; border: 2rpx solid rgba(255,255,255,0.68); border-radius: 8rpx; background: rgba(255, 248, 220, 0.88); color: #1e2c21; box-shadow: 0 8rpx 18rpx rgba(0,0,0,0.26); box-sizing: border-box; }\n" +
  ".moontown-map-marker-title { display: block; color: #1f2d22; font-size: 18rpx; font-weight: 800; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }\n" +
  ".moontown-map-marker-kind { display: block; margin-top: 2rpx; color: #56604f; font-size: 15rpx; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }\n" +
  ".moontown-thread-pin { position: absolute; right: -10rpx; top: -10rpx; min-width: 26rpx; height: 26rpx; border-radius: 999rpx; background: #203729; color: #fff8dc; font-size: 16rpx; line-height: 26rpx; text-align: center; border: 1rpx solid rgba(255,255,255,0.68); }\n" +
  ".moontown-map-marker.bunnia-status-review { border-color: #d69e2e; background: rgba(255,244,207,0.92); }\n" +
  ".moontown-map-marker.bunnia-status-running { border-color: #3182ce; background: rgba(217,237,247,0.92); }\n" +
  ".moontown-map-marker.bunnia-status-stable { border-color: #48bb78; background: rgba(228,243,216,0.92); }\n" +
  ".moontown-map-marker.bunnia-status-draft { border-color: #9f7aea; background: rgba(239,227,244,0.92); }\n" +
  ".moontown-map-marker.bunnia-status-shared { border-color: #b7791f; background: rgba(245,229,188,0.92); }\n" +
  ".moontown-semantic-scene { position: absolute; left: 0; top: 0; width: 1rpx; height: 1rpx; opacity: 0; overflow: hidden; pointer-events: none; }\n" +
  ".moontown-semantic-scene .bunnia-scene { pointer-events: none; }\n" +
  ".moontown-topbar { position: absolute; left: 24rpx; right: 24rpx; top: 24rpx; z-index: 8; display: flex; align-items: center; justify-content: space-between; gap: 16rpx; padding: 14rpx 16rpx; border: 1rpx solid rgba(255,255,255,0.52); border-radius: 8rpx; background: rgba(252, 249, 226, 0.86); box-shadow: 0 10rpx 28rpx rgba(35, 47, 38, 0.18); }\n" +
  ".moontown-title { font-size: 34rpx; font-weight: 800; color: #203222; }\n" +
  ".moontown-subtitle { margin-top: 2rpx; font-size: 20rpx; font-weight: 500; color: #66705a; }\n" +
  ".moontown-user-switcher { display: flex; align-items: center; justify-content: flex-end; gap: 8rpx; flex-wrap: wrap; max-width: 440rpx; }\n" +
  ".moontown-user-switcher text { color: #334538; font-size: 20rpx; }\n" +
  ".moontown-user-switcher button, .moontown-building-drawer button, .moontown-search-drawer button, .moontown-create-drawer button, .moontown-chat-drawer button, .moontown-shell-panel button { min-height: 46rpx; margin: 0; padding: 0 14rpx; border: 1rpx solid rgba(51, 65, 55, 0.28); border-radius: 6rpx; background: #fff8dc; color: #243629; font-size: 20rpx; line-height: 46rpx; }\n" +
  ".moontown-left-hud { position: absolute; z-index: 7; left: 22rpx; top: 126rpx; width: 338rpx; max-height: calc(100vh - 252rpx); display: flex; flex-direction: column; gap: 12rpx; overflow: hidden; }\n" +
  ".moontown-page-surface { position: absolute; z-index: 7; left: 22rpx; right: 22rpx; top: 126rpx; bottom: 104rpx; overflow: hidden; display: grid; grid-template-columns: minmax(0, 1fr); gap: 12rpx; }\n" +
  ".moontown-page-grid { min-height: 0; display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 12rpx; align-content: start; overflow: hidden; }\n" +
  ".moontown-page-grid.three { grid-template-columns: repeat(3, minmax(0, 1fr)); }\n" +
  ".moontown-shell-panel { padding: 14rpx; border: 1rpx solid rgba(255,255,255,0.46); border-radius: 8rpx; background: rgba(252, 249, 226, 0.86); box-shadow: 0 10rpx 28rpx rgba(35, 47, 38, 0.16); box-sizing: border-box; }\n" +
  ".moontown-shell-panel-title { display: block; color: #203222; font-size: 24rpx; font-weight: 800; }\n" +
  ".moontown-shell-panel-note { display: block; margin-top: 4rpx; color: #53624e; font-size: 18rpx; }\n" +
  ".moontown-guide-step, .moontown-onboarding-step, .moontown-setup-gate, .moontown-publication-step, .moontown-role-entry, .moontown-district-entry, .moontown-presence-chip, .moontown-discover-entry, .moontown-notice-entry, .moontown-owned-entry, .moontown-workbench-alert, .moontown-book-entry, .moontown-run-entry, .moontown-review-entry, .moontown-audit-entry, .bunnia-tool-result-card { margin-top: 8rpx; padding: 10rpx; border: 1rpx solid rgba(51,65,55,0.16); border-radius: 6rpx; background: rgba(255,255,255,0.62); }\n" +
  ".moontown-discover-entry.bunnia-status-review { border-color: rgba(214,158,46,0.58); background: rgba(255,244,207,0.78); }\n" +
  ".moontown-discover-entry.bunnia-status-stable { border-color: rgba(72,187,120,0.48); }\n" +
  ".moontown-workbench-alert.bunnia-status-blocked, .moontown-workbench-alert.bunnia-status-failed { border-color: rgba(198,68,56,0.58); background: rgba(255,232,224,0.78); }\n" +
  ".moontown-workbench-alert.bunnia-status-review, .moontown-workbench-alert.bunnia-status-stale { border-color: rgba(214,158,46,0.58); background: rgba(255,244,207,0.78); }\n" +
  ".moontown-guide-step text, .moontown-onboarding-step text, .moontown-setup-gate text, .moontown-publication-step text, .moontown-role-entry text, .moontown-district-entry text, .moontown-presence-chip text, .moontown-discover-entry text, .moontown-notice-entry text, .moontown-owned-entry text, .moontown-workbench-alert text, .moontown-book-entry text, .moontown-run-entry text, .moontown-review-entry text, .moontown-audit-entry text, .bunnia-tool-result-card text { display: block; color: #405244; font-size: 18rpx; }\n" +
  ".moontown-profile-status { margin: 8rpx 0; padding: 8rpx 10rpx; border-radius: 6rpx; background: rgba(37,55,43,0.12); color: #334538; font-size: 18rpx; }\n" +
  ".moontown-profile-card, .moontown-credential-plaque { margin-top: 8rpx; padding: 12rpx; border: 1rpx solid rgba(51,65,55,0.16); border-radius: 6rpx; background: rgba(255,255,255,0.66); box-sizing: border-box; }\n" +
  ".moontown-profile-actions, .moontown-profile-metrics { display: flex; flex-direction: row; gap: 8rpx; overflow: hidden; margin-top: 8rpx; }\n" +
  ".moontown-profile-metric { flex: 1 1 0; min-width: 0; padding: 8rpx; border-radius: 6rpx; background: rgba(37,55,43,0.1); color: #334538; font-size: 18rpx; }\n" +
  ".moontown-entry-title { color: #1f3327 !important; font-size: 20rpx !important; font-weight: 800; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }\n" +
  ".moontown-entry-meta { margin-top: 2rpx; color: #6b745f !important; font-size: 16rpx !important; }\n" +
  ".moontown-community-actions { display: flex; gap: 8rpx; margin-top: 8rpx; flex-wrap: wrap; }\n" +
  ".moontown-presence-row .bunnia-list-windowed { display: flex; flex-direction: row; gap: 8rpx; overflow: hidden; }\n" +
  ".moontown-presence-chip { flex: 0 0 136rpx; min-width: 0; }\n" +
  ".moontown-guide-strip .bunnia-list-windowed, .moontown-discovery-strip .bunnia-list-windowed, .moontown-message-buckets { display: flex; flex-direction: row; gap: 8rpx; overflow: hidden; margin-top: 8rpx; }\n" +
  ".moontown-guide-step { flex: 0 0 184rpx; min-width: 0; }\n" +
  ".moontown-discovery-chip, .moontown-message-bucket { flex: 0 0 152rpx; min-width: 0; padding: 10rpx; border: 1rpx solid rgba(51,65,55,0.16); border-radius: 6rpx; background: rgba(255,255,255,0.68); box-sizing: border-box; }\n" +
  ".moontown-discovery-filters .bunnia-list-windowed, .moontown-message-channels .bunnia-list-windowed, .moontown-ownership-filters .bunnia-list-windowed, .moontown-lifecycle-actions, .moontown-run-actions { display: flex; flex-direction: row; gap: 8rpx; overflow: hidden; margin-top: 8rpx; }\n" +
  ".moontown-discovery-filter, .moontown-message-channel, .moontown-ownership-filter { flex: 0 0 auto; padding: 8rpx 10rpx; border: 1rpx solid rgba(51,65,55,0.18); border-radius: 6rpx; background: rgba(255,255,255,0.58); color: #334538; font-size: 18rpx; }\n" +
  ".moontown-discovery-filter.active, .moontown-message-channel.active, .moontown-ownership-filter.active { background: #203729; color: #fff8dc; }\n" +
  ".moontown-run-action, .bunnia-tool-result-action { flex: 0 0 auto; }\n" +
  ".moontown-tool-results .bunnia-tool-result-list-windowed { margin-top: 8rpx; max-height: 296rpx; overflow: hidden; }\n" +
  ".moontown-discovery-action { margin-top: 8rpx; }\n" +
  ".moontown-right-hud { position: absolute; z-index: 7; right: 22rpx; top: 126rpx; width: 300rpx; display: flex; flex-direction: column; gap: 12rpx; }\n" +
  ".moontown-building-drawer, .moontown-chat-drawer, .moontown-search-drawer, .moontown-create-drawer { padding: 14rpx; border: 1rpx solid rgba(255,255,255,0.52); border-radius: 8rpx; background: rgba(252, 249, 226, 0.88); box-shadow: 0 10rpx 28rpx rgba(35, 47, 38, 0.16); box-sizing: border-box; }\n" +
  ".moontown-building-drawer text:first-child, .moontown-chat-drawer > text:first-child { display: block; margin-bottom: 6rpx; color: #1f3327; font-size: 26rpx; font-weight: 800; }\n" +
  ".moontown-building-drawer text, .moontown-chat-drawer text, .moontown-search-drawer text, .moontown-create-drawer text { display: block; color: #405244; font-size: 20rpx; }\n" +
  ".moontown-building-drawer button { margin-top: 8rpx; margin-right: 6rpx; }\n" +
  ".moontown-chat-drawer .bunnia-message-feed-windowed { max-height: 170rpx; overflow: hidden; }\n" +
  ".moontown-chat-drawer .bunnia-message { padding: 10rpx 12rpx; margin-bottom: 8rpx; background: rgba(255,255,255,0.78); font-size: 20rpx; }\n" +
  ".moontown-chat-drawer .bunnia-review { margin-top: 8rpx; padding: 10rpx; gap: 8rpx; background: rgba(255,255,255,0.68); }\n" +
  ".moontown-bottom-hud { position: absolute; z-index: 7; left: 22rpx; right: 22rpx; bottom: 104rpx; display: grid; grid-template-columns: 1fr 220rpx 220rpx; gap: 12rpx; align-items: end; }\n" +
  ".moontown-visibility-strip { min-width: 0; padding: 12rpx; border: 1rpx solid rgba(255,255,255,0.42); border-radius: 8rpx; background: rgba(37, 55, 43, 0.72); box-shadow: 0 10rpx 24rpx rgba(26, 39, 31, 0.18); }\n" +
  ".moontown-visibility-strip .bunnia-list-windowed { display: flex; flex-direction: row; gap: 8rpx; overflow: hidden; }\n" +
  ".moontown-visibility-chip { flex: 0 0 auto; max-width: 180rpx; padding: 8rpx 10rpx; border: 1rpx solid rgba(255,255,255,0.32); border-radius: 6rpx; background: rgba(255, 248, 220, 0.92); color: #27372b; font-size: 18rpx; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }\n" +
  ".moontown-search-drawer input, .moontown-create-drawer input { min-height: 46rpx; margin-bottom: 8rpx; padding: 0 10rpx; border: 1rpx solid rgba(51, 65, 55, 0.22); border-radius: 6rpx; background: rgba(255,255,255,0.82); color: #26362b; font-size: 20rpx; box-sizing: border-box; }\n" +
  ".moontown-search-result { padding: 8rpx 0; border-top: 1rpx solid rgba(52, 65, 55, 0.16); }\n" +
  ".moontown-create-drawer form { display: block; margin-bottom: 8rpx; }\n" +
  ".moontown-create-drawer form:last-child { margin-bottom: 0; }\n" +
  ".moontown-tabbar { position: absolute; z-index: 9; left: 22rpx; right: 22rpx; bottom: 18rpx; display: grid; grid-template-columns: repeat(5, 1fr); gap: 8rpx; padding: 10rpx; border: 1rpx solid rgba(255,255,255,0.5); border-radius: 8rpx; background: rgba(31, 49, 36, 0.86); box-shadow: 0 12rpx 30rpx rgba(16, 28, 20, 0.28); }\n" +
  ".moontown-tab-button { min-height: 56rpx; padding: 0 6rpx; border: 1rpx solid rgba(255,248,220,0.3); border-radius: 6rpx; background: rgba(255,248,220,0.16); color: #fff8dc; font-size: 18rpx; line-height: 56rpx; }\n" +
  ".moontown-tab-button.active { background: #fff8dc; color: #243629; font-weight: 800; }\n" +
  "@media (max-width: 520px) { .moontown-left-hud { left: 16rpx; top: 128rpx; width: 260rpx; max-height: 302rpx; } .moontown-page-surface { left: 16rpx; right: 16rpx; top: 128rpx; bottom: 102rpx; } .moontown-page-grid, .moontown-page-grid.three { grid-template-columns: 1fr; } .moontown-right-hud { top: 128rpx; right: 16rpx; width: 276rpx; } .moontown-bottom-hud { grid-template-columns: 1fr; bottom: 102rpx; } .moontown-search-drawer, .moontown-create-drawer { display: none; } }"
}

///|
fn minify_moontown_wxss(css : String) -> String {
  css
  .replace_all(old="\n", new="")
  .replace_all(old=" {", new="{")
  .replace_all(old="{ ", new="{")
  .replace_all(old="; ", new=";")
  .replace_all(old=": ", new=":")
  .replace_all(old=", ", new=",")
  .replace_all(old=" }", new="}")
  .replace_all(old=";}", new="}")
  .replace_all(old=" > ", new=">")
}

///|
pub fn demo_runtime() -> @bunnia.WechatRuntime {
  demo_runtime_for_tab("realm")
}

///|
fn demo_runtime_for_tab(tab_id : String) -> @bunnia.WechatRuntime {
  let projection = demo_projection()
  let patches : Array[@bunnia.WechatEventPatch] = []
  patches.push(@bunnia.wechat_event_patch("load-town-snapshot", []))
  patches.push(
    @bunnia.wechat_event_patch("complete-onboarding", [
      @bunnia.set_string("shell.onboardingCompleted", "true"),
    ]),
  )
  for tab in projection.tabs {
    patches.push(
      @bunnia.wechat_event_patch("tab-\{tab.id}", [
        @bunnia.set_string("shell.activeTab", tab.id),
      ]),
    )
  }
  add_setup_event_patches(patches, projection)
  add_discovery_filter_event_patches(patches, projection)
  add_notification_channel_event_patches(patches, projection)
  add_ownership_filter_event_patches(patches, projection)
  for building in visible_buildings(projection) {
    patches.push(select_building_patch(building))
    patches.push(open_building_thread_patch(building))
  }
  patches.push(
    @bunnia.wechat_event_patch("discover-search", [
      @bunnia.set_string("discover.query", "agent"),
    ]),
  )
  patches.push(
    @bunnia.wechat_event_patch("switch-user-a", [
      @bunnia.set_string("session.activeUserId", "user-a"),
      @bunnia.set_string("town.selectedBuildingId", "policy-hall"),
    ]),
  )
  patches.push(
    @bunnia.wechat_event_patch("switch-user-b", [
      @bunnia.set_string("session.activeUserId", "user-b"),
      @bunnia.set_string("town.selectedBuildingId", "published-agent-lab"),
    ]),
  )
  patches.push(
    @bunnia.wechat_event_patch("ask-selected-building", [
      @bunnia.append_json(
        "chat.messages", "{\"id\":\"msg-mock-answer\",\"actorId\":\"agent-policy-guide\",\"text\":\"Mock answer recorded as a run waiting for review.\"}",
      ),
      @bunnia.set_string("runs.activeRunStatus", "waiting-review"),
    ]),
  )
  patches.push(
    @bunnia.wechat_event_patch("accept-memory-review", [
      @bunnia.set_string("reviews.memoryReview", "approved"),
      @bunnia.set_string("runs.activeRunStatus", "done"),
      @bunnia.set_string("books.policyHall.status", "stable"),
    ]),
  )
  patches.push(
    @bunnia.wechat_event_patch("reject-memory-review", [
      @bunnia.set_string("reviews.memoryReview", "rejected"),
      @bunnia.set_string("runs.activeRunStatus", "rejected"),
    ]),
  )
  patches.push(
    @bunnia.wechat_event_patch("create-private-building", [
      @bunnia.append_json(
        "town.buildings", "{\"id\":\"created-agent-lab\",\"visibility\":\"private_draft\",\"ownerId\":\"user-a\"}",
      ),
      @bunnia.set_string("town.selectedBuildingId", "created-agent-lab"),
      @bunnia.set_string("lifecycle.lastAction", "create"),
      @bunnia.set_scene_marker_status(
        "moontown-map", "private-agent-lab", "draft",
      ),
    ]),
  )
  patches.push(
    @bunnia.wechat_event_patch("place-published-building", [
      @bunnia.append_json(
        "town.placements", "{\"id\":\"placement-user-a-published-agent-lab\",\"buildingId\":\"published-agent-lab\",\"ownerId\":\"user-a\",\"layer\":\"personal\",\"x\":538,\"y\":528,\"status\":\"pinned\",\"source\":\"discover\"}",
      ),
      @bunnia.set_string("lifecycle.lastAction", "place"),
      @bunnia.select_scene_marker("moontown-map", "published-agent-lab"),
    ]),
  )
  patches.push(
    @bunnia.wechat_event_patch("publish-private-building", [
      @bunnia.set_string("town.lastPublishedBuildingId", "created-agent-lab"),
      @bunnia.set_string("lifecycle.lastAction", "publish"),
    ]),
  )
  patches.push(
    @bunnia.wechat_event_patch("share-private-building", [
      @bunnia.set_string("town.lastSharedBuildingId", "created-agent-lab"),
      @bunnia.set_string("lifecycle.lastAction", "share"),
    ]),
  )
  patches.push(
    @bunnia.wechat_event_patch("archive-private-building", [
      @bunnia.set_string("town.lastArchivedBuildingId", "created-agent-lab"),
      @bunnia.set_string("lifecycle.lastAction", "archive"),
    ]),
  )
  patches.push(
    @bunnia.wechat_event_patch("create-agent", [
      @bunnia.append_json(
        "agents.items", "{\"id\":\"agent-created\",\"buildingId\":\"private-agent-lab\",\"status\":\"idle\"}",
      ),
    ]),
  )
  patches.push(
    @bunnia.wechat_event_patch("report-public-building", [
      @bunnia.set_string("moderation.lastReport", "policy-hall"),
    ]),
  )
  patches.push(
    @bunnia.wechat_event_patch("hide-public-building", [
      @bunnia.set_string("moderation.lastAction", "hide"),
    ]),
  )
  patches.push(
    @bunnia.wechat_event_patch("takedown-public-building", [
      @bunnia.set_string("moderation.lastAction", "takedown"),
    ]),
  )
  @bunnia.wechat_runtime(
    initial_data_json=demo_initial_data_json_for_tab(tab_id),
    event_patches=patches,
    page_methods_js=moontown_map_page_methods_js(),
  )
}

///|
fn add_setup_event_patches(
  patches : Array[@bunnia.WechatEventPatch],
  projection : MiniTownProjection,
) -> Unit {
  patches.push(
    @bunnia.wechat_event_patch("dev-login", [
      @bunnia.set_string("session.activeUserId", "user-a"),
    ]),
  )
  patches.push(
    @bunnia.wechat_event_patch("accept-profile-consent", [
      @bunnia.set_string("profile.consentAccepted", "true"),
      @bunnia.set_json("profileDraft.consentAccepted", "true"),
    ]),
  )
  patches.push(
    @bunnia.wechat_event_patch("save-profile", [
      @bunnia.set_string("profile.setupCompleted", "true"),
    ]),
  )
  for role in projection.roles {
    patches.push(
      @bunnia.wechat_event_patch("select-role-\{role.id}", [
        @bunnia.set_string("profile.roleId", role.id),
        @bunnia.set_string("profileDraft.roleId", role.id),
      ]),
    )
  }
}

///|
fn add_discovery_filter_event_patches(
  patches : Array[@bunnia.WechatEventPatch],
  projection : MiniTownProjection,
) -> Unit {
  for filter in projection.discovery_filters {
    patches.push(
      @bunnia.wechat_event_patch("discover-filter-\{filter.id}", [
        @bunnia.set_string("discover.filter", filter.id),
      ]),
    )
  }
}

///|
fn add_notification_channel_event_patches(
  patches : Array[@bunnia.WechatEventPatch],
  projection : MiniTownProjection,
) -> Unit {
  for channel in projection.notification_channels {
    patches.push(
      @bunnia.wechat_event_patch("notification-channel-\{channel.id}", [
        @bunnia.set_string("messages.channel", channel.id),
      ]),
    )
  }
}

///|
fn add_ownership_filter_event_patches(
  patches : Array[@bunnia.WechatEventPatch],
  projection : MiniTownProjection,
) -> Unit {
  for filter in projection.ownership_filters {
    if filter.id != "placements" {
      patches.push(
        @bunnia.wechat_event_patch("ownership-filter-\{filter.id}", [
          @bunnia.set_string("ownership.filter", filter.id),
        ]),
      )
    }
  }
}

///|
fn moontown_map_page_methods_js() -> String {
  "  onLoad(){\n" +
  "    this.__mc(this.data.mapViewport.x,this.data.mapViewport.y,this.data.mapViewport.scale)\n" +
  "  },\n" +
  "  onMoontownMapTouchStart(e){\n" +
  "    const t=e.touches||[]\n" +
  "    if(!t.length)return\n" +
  "    const v=this.data.mapViewport\n" +
  "    if(t.length>1){\n" +
  "      const c=this.__tc(t)\n" +
  "      const k=this.__mk(v.scale)\n" +
  "      this.__mt={n:2,d:this.__td(t),s:v.scale,ax:(c.x-v.x)/k,ay:(c.y-v.y)/k}\n" +
  "    }else{\n" +
  "      this.__mt={n:1,x:t[0].clientX,y:t[0].clientY,vx:v.x,vy:v.y,s:v.scale}\n" +
  "    }\n" +
  "  },\n" +
  "  onMoontownMapTouchMove(e){\n" +
  "    const t=e.touches||[]\n" +
  "    const m=this.__mt\n" +
  "    if(!m||!t.length)return\n" +
  "    if(t.length>1&&m.n===2){\n" +
  "      const c=this.__tc(t)\n" +
  "      const s=this.__cl(m.s*this.__td(t)/(m.d||1),2.6,3.4)\n" +
  "      const k=this.__mk(s)\n" +
  "      this.__mc(c.x-m.ax*k,c.y-m.ay*k,s)\n" +
  "    }else{\n" +
  "      this.__mc(m.vx+t[0].clientX-m.x,m.vy+t[0].clientY-m.y,m.s)\n" +
  "    }\n" +
  "  },\n" +
  "  onMoontownMapTouchEnd(){\n" +
  "    this.__mt=null\n" +
  "  },\n" +
  "  __mc(x,y,scale){\n" +
  "    const s=this.__cl(scale,2.6,3.4)\n" +
  "    const fit=(rawX,rawY)=>{\n" +
  "      const win=this.__wi()\n" +
  "      const k=this.__mk(s)\n" +
  "      const vw=win.windowWidth/k\n" +
  "      const vh=win.windowHeight/k\n" +
  "      const sx=this.__cl(-Number(rawX||0)/k,0,Math.max(0,1400-vw))\n" +
  "      const sy=this.__cl(-Number(rawY||0)/k,0,Math.max(0,880-vh))\n" +
  "      return {x:-sx*k,y:-sy*k}\n" +
  "    }\n" +
  "    const next=fit(x,y)\n" +
  "    this.setData({'mapViewport.x':next.x,'mapViewport.y':next.y,'mapViewport.scale':s,'mapViewport.style':'transform:translate('+next.x+'px,'+next.y+'px) scale('+s+')'})\n" +
  "  },\n" +
  "  __wi(){\n" +
  "    return this.__mw||(this.__mw=(wx.getWindowInfo?wx.getWindowInfo():wx.getSystemInfoSync()))\n" +
  "  },\n" +
  "  __mk(scale){\n" +
  "    return 2*scale*this.__wi().windowWidth/750\n" +
  "  },\n" +
  "  __tc(t){\n" +
  "    return {x:(t[0].clientX+t[1].clientX)/2,y:(t[0].clientY+t[1].clientY)/2}\n" +
  "  },\n" +
  "  __td(t){\n" +
  "    const dx=t[0].clientX-t[1].clientX\n" +
  "    const dy=t[0].clientY-t[1].clientY\n" +
  "    return Math.sqrt(dx*dx+dy*dy)\n" +
  "  },\n" +
  "  __cl(value,min,max){\n" +
  "    return Math.max(min,Math.min(max,Number(value||0)))\n" +
  "  },\n"
}

///|
fn select_building_patch(
  building : MiniTownBuilding,
) -> @bunnia.WechatEventPatch {
  @bunnia.wechat_event_patch("select-\{building.id}", [
    @bunnia.set_string("town.selectedBuildingId", building.id),
  ])
}

///|
fn open_building_thread_patch(
  building : MiniTownBuilding,
) -> @bunnia.WechatEventPatch {
  @bunnia.wechat_event_patch("open-thread-\{building.id}", [
    @bunnia.select_scene_marker_thread(
      "moontown-map",
      building.id,
      "thread-\{building.id}",
    ),
  ])
}

///|
pub fn demo_patch_plan() -> @bunnia.PatchPlan {
  @bunnia.plan_patches([
    @bunnia.set_string("town.selectedBuildingId", "published-agent-lab"),
    @bunnia.select_scene_marker("moontown-map", "published-agent-lab"),
    @bunnia.append_json(
      "chat.messages", "{\"id\":\"msg-mock-answer\",\"text\":\"Mock answer.\"}",
    ),
  ])
}

///|
pub fn demo_snapshot_delta_plan() -> @bunnia.SnapshotDeltaPlan {
  @bunnia.plan_snapshot_deltas([
    @bunnia.set_snapshot_section_delta(
      "moontown-miniapp", "selectedBuildingId", "\"policy-hall\"",
    ),
    @bunnia.append_snapshot_item_delta(
      "moontown-miniapp", "buildings", "created-agent-lab", "{\"id\":\"created-agent-lab\",\"visibility\":\"private_draft\"}",
    ),
    @bunnia.append_snapshot_item_delta(
      "moontown-miniapp", "messages", "msg-mock-answer", "{\"id\":\"msg-mock-answer\",\"status\":\"waiting-review\"}",
    ),
  ])
}

///|
pub fn demo_agent_delta_plan() -> @bunnia.AgentDeltaPlan {
  @bunnia.plan_agent_deltas([
    @bunnia.append_message_delta(
      "chat.messages",
      @bunnia.message(
        id="msg-mock-answer",
        actor_id="agent-policy-guide",
        thread_id="thread-policy-hall",
        text="Mock answer recorded as a run waiting for review.",
        status=@bunnia.run_waiting_review(),
      ),
    ),
    @bunnia.set_run_status_delta(
      "runs.activeRunStatus",
      @bunnia.run_waiting_review(),
    ),
  ])
}

///|
pub fn demo_communication_plan() -> @bunnia.CommunicationPlan {
  @bunnia.plan_communications_with_budget(
    demo_communications(demo_projection()),
    @bunnia.communication_budget(max_visible_count=8),
  )
}

///|
pub fn demo_backend_contract() -> @bunnia.BackendContract {
  @bunnia.backend_contract(
    id="moontown-miniapp-backend",
    session_token_key="bunniaSessionId",
    session_header_key="x-miniapp-session",
    endpoints=[
      @bunnia.snapshot_load_endpoint(
        "load-town-snapshot", "/miniapp/town/snapshot", "townSnapshot",
      ),
      @bunnia.generic_endpoint(
        "load-ownership-snapshot",
        "/miniapp/me/ownership",
        @bunnia.http_get(),
        payload_key="ownershipQuery",
        response_key="ownershipSnapshot",
      ),
      @bunnia.generic_endpoint(
        "dev-login",
        "/miniapp/auth/dev-login",
        @bunnia.http_post(),
        payload_key="login",
        response_key="loginResult",
      ),
      @bunnia.operator_submit_endpoint(
        "save-profile", "/miniapp/me/profile", "profileDraft", "profileResult",
      ),
      @bunnia.generic_endpoint(
        "discover-search",
        "/miniapp/discover/search",
        @bunnia.http_get(),
        payload_key="discoverSearch",
        response_key="discoverSearchResult",
      ),
      @bunnia.operator_submit_endpoint(
        "create-private-building", "/miniapp/buildings", "buildingDraft", "buildingResult",
      ),
      @bunnia.operator_submit_endpoint(
        "place-published-building", "/miniapp/buildings/place", "placementDraft",
        "placementResult",
      ),
      @bunnia.operator_submit_endpoint(
        "share-private-building", "/miniapp/buildings/share", "shareDraft", "shareResult",
      ),
      @bunnia.operator_submit_endpoint(
        "submit-private-building", "/miniapp/buildings/submit", "submitDraft", "submitResult",
      ),
      @bunnia.operator_submit_endpoint(
        "publish-private-building", "/miniapp/buildings/publish", "publishDraft",
        "publishResult",
      ),
      @bunnia.operator_submit_endpoint(
        "archive-private-building", "/miniapp/buildings/archive", "archiveDraft",
        "archiveResult",
      ),
      @bunnia.operator_submit_endpoint(
        "restore-archived-building", "/miniapp/buildings/restore", "restoreDraft",
        "restoreResult",
      ),
      @bunnia.agent_message_endpoint(
        "ask-selected-building", "/miniapp/buildings/query", "buildingQuestion",
        "queryResult",
      ),
      @bunnia.agent_message_endpoint(
        "send-building-message", "/miniapp/messages/send", "chatDraft", "chatResult",
      ),
      @bunnia.handoff_submit_endpoint(
        "handoff-agent-work", "/miniapp/agents/handoff", "handoffDraft", "handoffResult",
      ),
      @bunnia.agent_cancel_endpoint(
        "cancel-run", "/miniapp/runs/cancel", "runCancel", "cancelResult",
      ),
      @bunnia.agent_retry_endpoint(
        "retry-run", "/miniapp/runs/retry", "runRetry", "retryResult",
      ),
      @bunnia.review_decision_endpoint(
        "accept-memory-review", "/miniapp/reviews/accept", "reviewDecision", "reviewResult",
      ),
      @bunnia.review_decision_endpoint(
        "reject-memory-review", "/miniapp/reviews/reject", "reviewDecision", "reviewResult",
      ),
      @bunnia.operator_submit_endpoint(
        "ack-notification", "/miniapp/messages/ack", "notificationAck", "notificationAckResult",
      ),
      @bunnia.operator_submit_endpoint(
        "ack-tool-result", "/miniapp/tool-results/ack", "toolResultAck", "toolResultAckResult",
      ),
      @bunnia.operator_submit_endpoint(
        "request-subscription", "/miniapp/messages/subscribe", "subscriptionRequest",
        "subscriptionResult",
      ),
      @bunnia.operator_submit_endpoint(
        "create-agent", "/miniapp/agents", "agentDraft", "agentResult",
      ),
      @bunnia.generic_endpoint(
        "report-public-building",
        "/miniapp/moderation/report",
        @bunnia.http_post(),
        payload_key="reportDraft",
        response_key="reportResult",
      ),
      @bunnia.generic_endpoint(
        "hide-public-building",
        "/miniapp/moderation/hide",
        @bunnia.http_post(),
        payload_key="moderationHide",
        response_key="moderationHideResult",
      ),
      @bunnia.generic_endpoint(
        "takedown-public-building",
        "/miniapp/moderation/takedown",
        @bunnia.http_post(),
        payload_key="moderationTakedown",
        response_key="moderationTakedownResult",
      ),
    ],
  )
}

///|
pub fn demo_backend_budget() -> @bunnia.BackendBudget {
  @bunnia.backend_budget(
    max_endpoints=32,
    max_streaming=4,
    max_review_required=15,
  )
}

///|
pub fn demo_backend_plan() -> @bunnia.BackendPlan {
  @bunnia.plan_backend_contract_with_budget(
    demo_backend_contract(),
    demo_backend_budget(),
  )
}

///|
pub fn demo_effect_plan() -> @bunnia.EffectPlan {
  @bunnia.plan_backend_effects_for_platform(
    demo_backend_contract(),
    @bunnia.wechat(),
  )
}

///|
pub fn demo_tool_result_plan() -> @bunnia.ToolResultPlan {
  @bunnia.plan_tool_result_cards_with_budget(
    tool_result_cards(demo_projection()),
    @bunnia.tool_result_budget(max_visible_count=8),
  )
}

///|
fn moontown_map_width() -> Int {
  1400
}

///|
fn moontown_map_height() -> Int {
  880
}

///|
fn moontown_map_display_scale() -> Int {
  2
}

///|
fn moontown_map_display_width() -> Int {
  moontown_map_width() * moontown_map_display_scale()
}

///|
fn moontown_map_display_height() -> Int {
  moontown_map_height() * moontown_map_display_scale()
}

///|
fn moontown_map_asset_src() -> String {
  "/assets/wenyu_reference_tilemap_iso_mobile.png"
}

///|
fn moontown_map_asset_source() -> String {
  "examples/moontown_miniapp/assets/wenyu_reference_tilemap_iso_mobile.png"
}

///|
fn moontown_map_asset_bytes() -> Int {
  2077418
}

///|
fn moontown_scene_asset_budget() -> @bunnia.SceneAssetBudget {
  @bunnia.scene_asset_budget(
    max_assets=64,
    max_package_bytes=2 * 1024 * 1024,
    max_remote_assets=16,
  )
}

///|
pub fn demo_scene() -> @bunnia.Scene {
  let projection = demo_projection()
  @bunnia.scene(
    "moontown-map",
    @bunnia.scene_size(moontown_map_width(), moontown_map_height()),
    [
      @bunnia.layer("districts", 1, [], regions=[
        @bunnia.region(
          id="central",
          label="Central",
          x=430,
          y=250,
          width=420,
          height=270,
          status="stable",
          tap_message="select-policy-hall",
        ),
        @bunnia.region(
          id="east-market",
          label="East Market",
          x=820,
          y=420,
          width=360,
          height=260,
          status="running",
          tap_message="select-market-square",
        ),
      ]),
      @bunnia.layer(
        "buildings",
        2,
        markers_from_buildings(visible_buildings(projection)),
      ),
    ],
    assets=demo_scene_assets(),
  )
}

///|
pub fn demo_camera() -> @bunnia.SceneCamera {
  @bunnia.scene_camera(
    scene_id="moontown-map",
    x=360,
    y=160,
    width=720,
    height=720,
  )
}

///|
pub fn demo_scene_render_plan() -> @bunnia.SceneRenderPlan {
  @bunnia.plan_scene_render_viewport(
    demo_scene(),
    @bunnia.scene_viewport(x=360, y=160, width=640, height=480),
    @bunnia.default_scene_render_budget(),
  )
}

///|
pub fn demo_scene_surface_plan() -> @bunnia.SceneSurfacePlan {
  @bunnia.plan_scene_surface_for_platform(
    demo_scene(),
    @bunnia.wechat(),
    preference=@bunnia.prefer_static_surface(),
  )
}

///|
pub fn demo_scene_thread_plan() -> @bunnia.SceneThreadPlan {
  let scene = demo_scene()
  let camera = demo_camera()
  let camera_plan = @bunnia.plan_scene_camera(scene, camera)
  @bunnia.plan_scene_threads_viewport_with_budget(
    scene,
    camera_plan.viewport,
    demo_scene_thread_links(demo_projection()),
    @bunnia.scene_thread_budget(max_visible_links=9, max_unread_total=12),
  )
}

///|
pub fn demo_asset_plan() -> @bunnia.SceneAssetPlan {
  @bunnia.plan_scene_assets_with_budget(
    demo_scene_assets(),
    moontown_scene_asset_budget(),
  )
}

///|
pub fn demo_scene_visual_quality_plan() -> @bunnia.SceneVisualQualityPlan {
  @bunnia.plan_scene_visual_quality_viewport(
    demo_scene(),
    @bunnia.scene_viewport(x=360, y=160, width=640, height=480),
    @bunnia.default_scene_render_budget(),
    moontown_scene_asset_budget(),
    @bunnia.default_scene_visual_quality_budget(),
  )
}

///|
pub fn demo_project_inspection() -> @bunnia.ProjectInspection {
  let project = demo_wechat_project()
  let report = @bunnia.report_wechat_project(project, demo_runtime())
  @bunnia.inspect_wechat_project(
    target="wechat",
    example="moontown_miniapp",
    project,
    report,
  )
}

///|
fn town_map_surface(projection : MiniTownProjection) -> @bunnia.Node {
  let scene = demo_scene()
  let camera = demo_camera()
  let camera_plan = @bunnia.plan_scene_camera(scene, camera)
  let thread_links = demo_scene_thread_links(projection)
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-map-fullscreen")], [
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("moontown-map-touch-area"),
        @bunnia.attr("bindtouchstart", "onMoontownMapTouchStart"),
        @bunnia.attr("catchtouchmove", "onMoontownMapTouchMove"),
        @bunnia.attr("bindtouchend", "onMoontownMapTouchEnd"),
        @bunnia.attr("bindtouchcancel", "onMoontownMapTouchEnd"),
      ],
      [
        @bunnia.view_with_attrs(
          [
            @bunnia.class_name("moontown-map-drag-content"),
            @bunnia.attr("style", "{{mapViewport.style}}"),
          ],
          [moontown_map_image(), map_markers(projection)],
        ),
      ],
    ),
    @bunnia.view_with_attrs([@bunnia.class_name("moontown-semantic-scene")], [
      @bunnia.static_scene_view_with_camera(scene, camera),
      @bunnia.windowed_anchored_scene_thread_overlay_with_viewport(
        scene,
        camera_plan.viewport,
        thread_links,
        total_count=thread_links.length(),
      ),
    ]),
  ])
}

///|
fn town_map_backdrop(projection : MiniTownProjection) -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-map-fullscreen moontown-map-backdrop"),
      @bunnia.data("map-backdrop", projection.active_tab_id),
    ],
    [
      @bunnia.view_with_attrs([@bunnia.class_name("moontown-map-touch-area")], [
        @bunnia.view_with_attrs(
          [@bunnia.class_name("moontown-map-drag-content")],
          [moontown_map_backdrop_image()],
        ),
      ]),
    ],
  )
}

///|
fn moontown_map_backdrop_image() -> @bunnia.Node {
  @bunnia.node(kind="image", attrs=[
    @bunnia.class_name("moontown-wenyu-map-image"),
    @bunnia.attr("src", moontown_map_asset_src()),
    @bunnia.attr("alt", "Moontown Wenyu Valley map backdrop"),
    @bunnia.attr("mode", "scaleToFill"),
  ])
}

///|
fn moontown_map_image() -> @bunnia.Node {
  @bunnia.node(kind="image", attrs=[
    @bunnia.class_name("moontown-wenyu-map-image"),
    @bunnia.attr("src", moontown_map_asset_src()),
    @bunnia.attr("alt", "Moontown Wenyu Valley map"),
    @bunnia.attr("mode", "scaleToFill"),
    @bunnia.data("asset-id", "moontown-wenyu-map"),
    @bunnia.data("asset-kind", "image"),
    @bunnia.data("asset-source", moontown_map_asset_source()),
    @bunnia.data("asset-remote", "false"),
    @bunnia.data("asset-bytes", moontown_map_asset_bytes().to_string()),
  ])
}

///|
fn map_markers(projection : MiniTownProjection) -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-map-markers")], [
    @bunnia.list(visible_buildings(projection), map_marker),
  ])
}

///|
fn map_marker(building : MiniTownBuilding) -> @bunnia.Node {
  @bunnia.keyed(
    "map-marker-\{building.id}",
    @bunnia.node(
      kind="view",
      attrs=[
        @bunnia.class_name(
          "moontown-map-marker bunnia-status-\{building.status}",
        ),
        @bunnia.attr(
          "style",
          "left: \{map_display_position(building.x)}rpx; top: \{map_display_position(building.y)}rpx;",
        ),
        @bunnia.data("building-id", building.id),
        @bunnia.data("visibility", building.visibility),
      ],
      events=[@bunnia.event("tap", "select-\{building.id}")],
      children=[
        @bunnia.node(
          kind="view",
          attrs=[@bunnia.class_name("moontown-thread-pin")],
          events=[@bunnia.event("tap", "open-thread-\{building.id}")],
          children=[@bunnia.text(thread_pin_label(building))],
        ),
        @bunnia.view_with_attrs(
          [@bunnia.class_name("moontown-map-marker-title")],
          [@bunnia.text(building.title)],
        ),
        @bunnia.view_with_attrs(
          [@bunnia.class_name("moontown-map-marker-kind")],
          [@bunnia.text(building.kind)],
        ),
      ],
    ),
  )
}

///|
fn map_display_position(position : Int) -> Int {
  position * moontown_map_display_scale()
}

///|
fn thread_pin_label(building : MiniTownBuilding) -> String {
  if building.status == "review" {
    "1"
  } else {
    "i"
  }
}

///|
fn town_top_bar(projection : MiniTownProjection) -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-topbar")], [
    @bunnia.view_with_attrs([@bunnia.class_name("moontown-title")], [
      @bunnia.text("Moontown"),
      @bunnia.view_with_attrs([@bunnia.class_name("moontown-subtitle")], [
        @bunnia.text("agent town mini-app"),
      ]),
    ]),
    user_switcher(projection),
  ])
}

///|
fn town_right_hud(projection : MiniTownProjection) -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-right-hud")], [
    selected_building_drawer(projection),
    lifecycle_panel(projection),
    chat_drawer(projection),
  ])
}

///|
fn town_active_surface(projection : MiniTownProjection) -> @bunnia.Node {
  if projection.active_tab_id == "discover" {
    town_page_surface(projection, [
      discover_panel(projection),
      district_panel(projection),
    ])
  } else if projection.active_tab_id == "messages" {
    town_page_surface(projection, [
      messages_panel(projection),
      run_queue_panel(projection),
      tool_result_panel(projection),
      review_queue_panel(projection),
      moderation_desk_panel(projection),
      chat_drawer(projection),
    ])
  } else if projection.active_tab_id == "my" {
    town_page_surface(projection, [
      identity_setup_panel(projection),
      profile_panel(projection),
      ownership_lifecycle_panel(projection),
      create_drawer(projection),
    ])
  } else if projection.active_tab_id == "home" {
    town_page_surface(projection, [
      onboarding_panel(projection),
      backend_loop_panel(projection),
      home_overview_panel(projection),
      community_hub_panel(projection),
      town_activity_panel(projection),
    ])
  } else {
    @bunnia.view([
      town_left_hud(projection),
      town_right_hud(projection),
      town_bottom_hud(projection),
    ])
  }
}

///|
fn town_page_surface(
  projection : MiniTownProjection,
  panels : Array[@bunnia.Node],
) -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-page-surface"),
      @bunnia.data("active-tab", projection.active_tab_id),
    ],
    [
      @bunnia.view_with_attrs(
        [
          @bunnia.class_name(
            if panels.length() > 2 {
              "moontown-page-grid three"
            } else {
              "moontown-page-grid"
            },
          ),
        ],
        panels,
      ),
    ],
  )
}

///|
fn town_left_hud(projection : MiniTownProjection) -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-left-hud"),
      @bunnia.data("active-tab", projection.active_tab_id),
      @bunnia.data(
        "onboarding-completed",
        if projection.onboarding_completed {
          "true"
        } else {
          "false"
        },
      ),
    ],
    [realm_entry_panel(projection)],
  )
}

///|
fn realm_entry_panel(projection : MiniTownProjection) -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-shell-panel")], [
    @bunnia.view_with_attrs(
      [@bunnia.class_name("moontown-shell-panel-title")],
      [@bunnia.text("First Visit")],
    ),
    @bunnia.view_with_attrs([@bunnia.class_name("moontown-shell-panel-note")], [
      @bunnia.text(
        "Realm is the map. Home and My hold setup, pulse, and inventory.",
      ),
    ]),
    @bunnia.view_with_attrs([@bunnia.class_name("moontown-profile-status")], [
      @bunnia.text(
        "\{projection.profile.role_id} / ready: \{if profile_ready_to_publish(projection) { "yes" } else { "no" }}",
      ),
    ]),
    guide_strip(projection),
    @bunnia.button("Enter Realm", "complete-onboarding"),
  ])
}

///|
fn onboarding_panel(projection : MiniTownProjection) -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-shell-panel")], [
    @bunnia.view_with_attrs(
      [@bunnia.class_name("moontown-shell-panel-title")],
      [@bunnia.text("First Visit")],
    ),
    @bunnia.view_with_attrs([@bunnia.class_name("moontown-shell-panel-note")], [
      @bunnia.text("Tile-town onboarding before entering Realm."),
    ]),
    @bunnia.windowed_list(
      projection.onboarding_steps,
      total_count=projection.onboarding_steps.length(),
      render=onboarding_step_entry,
    ),
    guide_strip(projection),
    @bunnia.button("Enter Realm", "complete-onboarding"),
  ])
}

///|
fn guide_strip(projection : MiniTownProjection) -> @bunnia.Node {
  let steps = guide_steps(projection)
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-guide-strip")], [
    @bunnia.windowed_list(
      steps,
      total_count=steps.length(),
      render=guide_step_entry,
    ),
  ])
}

///|
fn guide_step_entry(step : MiniTownGuideStep) -> @bunnia.Node {
  @bunnia.keyed(
    "guide-\{step.id}",
    @bunnia.node(
      kind="view",
      attrs=[
        @bunnia.class_name("moontown-guide-step bunnia-status-\{step.status}"),
        @bunnia.data("guide-step", step.id),
        @bunnia.data("tab-id", step.tab_id),
        @bunnia.data("building-id", step.building_id),
        @bunnia.data("complete", if step.complete { "true" } else { "false" }),
        @bunnia.data("bunnia-route", moontown_tab_route(step.tab_id)),
      ],
      events=[@bunnia.event("tap", step.action_message)],
      children=[
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-title")], [
          @bunnia.text(step.title),
        ]),
        @bunnia.text(step.summary),
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-meta")], [
          @bunnia.text("\{step.action_label} / \{step.status}"),
        ]),
      ],
    ),
  )
}

///|
fn onboarding_step_entry(step : MiniTownOnboardingStep) -> @bunnia.Node {
  @bunnia.keyed(
    "onboarding-\{step.id}",
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("moontown-onboarding-step"),
        @bunnia.data("building-id", step.building_id),
      ],
      [
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-title")], [
          @bunnia.text(step.title),
        ]),
        @bunnia.text(step.body),
      ],
    ),
  )
}

///|
fn identity_setup_panel(projection : MiniTownProjection) -> @bunnia.Node {
  let gates = setup_gates(projection)
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-shell-panel")], [
    @bunnia.view_with_attrs(
      [@bunnia.class_name("moontown-shell-panel-title")],
      [@bunnia.text("Identity Setup")],
    ),
    @bunnia.view_with_attrs([@bunnia.class_name("moontown-shell-panel-note")], [
      @bunnia.text("Choose a role and accept consent before publishing."),
    ]),
    @bunnia.view_with_attrs([@bunnia.class_name("moontown-profile-status")], [
      @bunnia.text(
        "\{projection.profile.display_name} / \{projection.profile.role_id} / ready: \{if profile_ready_to_publish(projection) { "yes" } else { "no" }}",
      ),
    ]),
    @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-meta")], [
      @bunnia.text(
        "runtime role: {{profile.roleId || 'builder'}} / consent: {{profile.consentAccepted || 'false'}} / saved: {{profile.setupCompleted || 'false'}}",
      ),
    ]),
    @bunnia.windowed_list(
      gates,
      total_count=gates.length(),
      render=setup_gate_entry,
    ),
    @bunnia.windowed_list(
      projection.roles,
      total_count=projection.roles.length(),
      render=role_entry,
    ),
    @bunnia.button("Accept Consent", "accept-profile-consent"),
    @bunnia.button("Save Profile", "save-profile"),
  ])
}

///|
fn setup_gate_entry(item : MiniTownSetupGate) -> @bunnia.Node {
  @bunnia.keyed(
    "setup-gate-\{item.id}",
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("moontown-setup-gate bunnia-status-\{item.status}"),
        @bunnia.data("setup-gate", item.id),
        @bunnia.data("complete", if item.complete { "true" } else { "false" }),
      ],
      [
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-title")], [
          @bunnia.text(item.label),
        ]),
        @bunnia.text(item.summary),
        @bunnia.button(item.action_label, item.action_message),
      ],
    ),
  )
}

///|
fn role_entry(role : MiniTownRole) -> @bunnia.Node {
  @bunnia.keyed(
    "role-\{role.id}",
    @bunnia.node(
      kind="view",
      attrs=[
        @bunnia.class_name("moontown-role-entry"),
        @bunnia.data("role-id", role.id),
        @bunnia.data("building-id", role.building_id),
      ],
      events=[@bunnia.event("tap", "select-role-\{role.id}")],
      children=[
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-title")], [
          @bunnia.text(role.title),
        ]),
        @bunnia.text(role.summary),
      ],
    ),
  )
}

///|
fn community_hub_panel(projection : MiniTownProjection) -> @bunnia.Node {
  let presence = community_presence(projection)
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-shell-panel")], [
    @bunnia.view_with_attrs(
      [@bunnia.class_name("moontown-shell-panel-title")],
      [@bunnia.text("Community Hub")],
    ),
    @bunnia.view_with_attrs([@bunnia.class_name("moontown-shell-panel-note")], [
      @bunnia.text("Reference feature pages become tile districts on the map."),
    ]),
    @bunnia.windowed_list(
      projection.districts,
      total_count=projection.districts.length(),
      render=district_entry,
    ),
    @bunnia.view_with_attrs([@bunnia.class_name("moontown-presence-row")], [
      @bunnia.windowed_list(
        presence,
        total_count=presence.length(),
        render=presence_chip,
      ),
    ]),
    @bunnia.view_with_attrs(
      [@bunnia.class_name("moontown-community-actions")],
      [
        @bunnia.button("Search Town", "tab-discover"),
        @bunnia.button("Publish Draft", "publish-private-building"),
      ],
    ),
  ])
}

///|
fn district_panel(projection : MiniTownProjection) -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-shell-panel")], [
    @bunnia.view_with_attrs(
      [@bunnia.class_name("moontown-shell-panel-title")],
      [@bunnia.text("Map Districts")],
    ),
    @bunnia.windowed_list(
      projection.districts,
      total_count=projection.districts.length(),
      render=district_entry,
    ),
  ])
}

///|
fn district_entry(district : MiniTownDistrict) -> @bunnia.Node {
  @bunnia.keyed(
    "district-\{district.id}",
    @bunnia.node(
      kind="view",
      attrs=[
        @bunnia.class_name(
          "moontown-district-entry bunnia-status-\{district.status}",
        ),
        @bunnia.data("district-id", district.id),
        @bunnia.data("feature-kind", district.feature_kind),
        @bunnia.data("building-id", district.building_id),
        @bunnia.data("action-message", district_action_message(district)),
        @bunnia.data("target-tab", district_target_tab(district)),
      ],
      events=[@bunnia.event("tap", district_action_message(district))],
      children=[
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-title")], [
          @bunnia.text(district.title),
        ]),
        @bunnia.text(district.summary),
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-meta")], [
          @bunnia.text(
            "\{district.stat_value} \{district.stat_label} / \{district.action_label} / \{district_target_tab(district)}",
          ),
        ]),
      ],
    ),
  )
}

///|
fn district_action_message(district : MiniTownDistrict) -> String {
  if district.action_message == "" {
    "select-\{district.building_id}"
  } else {
    district.action_message
  }
}

///|
fn district_target_tab(district : MiniTownDistrict) -> String {
  if district.action_message.has_prefix("tab-") {
    district.action_message
    .sub(start=4, end=district.action_message.length())
    .to_owned()
  } else {
    "realm"
  }
}

///|
fn presence_chip(item : MiniTownPresence) -> @bunnia.Node {
  @bunnia.keyed(
    "presence-\{item.id}",
    @bunnia.node(
      kind="view",
      attrs=[
        @bunnia.class_name(
          "moontown-presence-chip bunnia-status-\{item.status}",
        ),
        @bunnia.data("presence-id", item.id),
        @bunnia.data("actor-kind", item.actor_kind),
        @bunnia.data("building-id", item.building_id),
      ],
      events=[@bunnia.event("tap", "select-\{item.building_id}")],
      children=[
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-title")], [
          @bunnia.text(item.title),
        ]),
        @bunnia.text(item.subtitle),
      ],
    ),
  )
}

///|
fn home_overview_panel(projection : MiniTownProjection) -> @bunnia.Node {
  let stats = home_town_stats(projection)
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-shell-panel")], [
    @bunnia.view_with_attrs(
      [@bunnia.class_name("moontown-shell-panel-title")],
      [@bunnia.text("Town Pulse")],
    ),
    @bunnia.view_with_attrs([@bunnia.class_name("moontown-shell-panel-note")], [
      @bunnia.text(
        "Realm is the map; Home shows recent work around the same tile town.",
      ),
    ]),
    @bunnia.windowed_list(
      stats,
      total_count=stats.length(),
      render=home_stat_entry,
    ),
  ])
}

///|
fn backend_loop_panel(projection : MiniTownProjection) -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-shell-panel")], [
    @bunnia.view_with_attrs(
      [@bunnia.class_name("moontown-shell-panel-title")],
      [@bunnia.text("Backend Loop")],
    ),
    @bunnia.view_with_attrs([@bunnia.class_name("moontown-shell-panel-note")], [
      @bunnia.text("DevTools target: \{local_backend_base_url()}"),
    ]),
    @bunnia.view_with_attrs(
      [@bunnia.class_name("moontown-community-actions")],
      [
        @bunnia.button("Login", "dev-login"),
        @bunnia.button("Load", "load-town-snapshot"),
      ],
    ),
    @bunnia.windowed_list(
      projection.backend_steps,
      total_count=projection.backend_steps.length(),
      render=backend_step_entry,
    ),
    @bunnia.windowed_list(
      projection.backend_cache_states,
      total_count=projection.backend_cache_states.length(),
      render=backend_cache_entry,
    ),
  ])
}

///|
fn backend_step_entry(item : MiniTownBackendStep) -> @bunnia.Node {
  @bunnia.keyed(
    "backend-step-\{item.id}",
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("moontown-notice-entry bunnia-status-\{item.status}"),
        @bunnia.data("backend-step", item.id),
        @bunnia.data("backend-endpoint", item.endpoint_id),
        @bunnia.data("backend-method", item.http_method),
        @bunnia.data("backend-path", item.path),
      ],
      [
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-title")], [
          @bunnia.text(item.label),
        ]),
        @bunnia.text(item.summary),
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-meta")], [
          @bunnia.text("\{item.http_method} \{item.path} / \{item.status}"),
        ]),
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-meta")], [
          @bunnia.text(
            "runtime: {{backendStatus.\{backend_status_key(item.endpoint_id)}.state || 'idle'}}",
          ),
        ]),
        @bunnia.button("Run", item.endpoint_id),
      ],
    ),
  )
}

///|
fn backend_status_key(endpoint_id : String) -> String {
  endpoint_id.replace_all(old="-", new="_")
}

///|
fn backend_cache_entry(item : MiniTownBackendCacheState) -> @bunnia.Node {
  @bunnia.keyed(
    "backend-cache-\{item.id}",
    @bunnia.node(
      kind="view",
      attrs=[
        @bunnia.class_name("moontown-notice-entry bunnia-status-\{item.state}"),
        @bunnia.data("backend-cache", item.id),
        @bunnia.data("cache-state", item.state),
        @bunnia.data("action-message", item.action_message),
      ],
      events=[@bunnia.event("tap", item.action_message)],
      children=[
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-title")], [
          @bunnia.text(item.label),
        ]),
        @bunnia.text(item.summary),
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-meta")], [
          @bunnia.text(
            "\{item.action_label} / \{backend_cache_target_tab(item)}",
          ),
        ]),
      ],
    ),
  )
}

///|
fn backend_cache_target_tab(item : MiniTownBackendCacheState) -> String {
  if item.action_message.has_prefix("tab-") {
    item.action_message
    .sub(start=4, end=item.action_message.length())
    .to_owned()
  } else if item.action_message == "load-ownership-snapshot" ||
    item.action_message == "dev-login" {
    "my"
  } else if item.action_message == "load-town-snapshot" {
    "realm"
  } else {
    "home"
  }
}

///|
fn home_stat_entry(stat : MiniTownOwnershipStat) -> @bunnia.Node {
  @bunnia.keyed(
    "home-stat-\{stat.id}",
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("moontown-home-stat"),
        @bunnia.data("home-stat", stat.id),
      ],
      [
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-title")], [
          @bunnia.text(stat.value.to_string()),
        ]),
        @bunnia.text(stat.label),
      ],
    ),
  )
}

///|
fn town_activity_panel(projection : MiniTownProjection) -> @bunnia.Node {
  let activity = town_activity_items(projection)
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-shell-panel")], [
    @bunnia.view_with_attrs(
      [@bunnia.class_name("moontown-shell-panel-title")],
      [@bunnia.text("Recent Activity")],
    ),
    @bunnia.view_with_attrs([@bunnia.class_name("moontown-shell-panel-note")], [
      @bunnia.text(
        "Agent runs, book memory, sharing, and publishing stay attached to map buildings.",
      ),
    ]),
    @bunnia.windowed_list(
      activity,
      total_count=activity.length(),
      render=activity_entry,
    ),
  ])
}

///|
fn activity_entry(item : MiniTownActivityItem) -> @bunnia.Node {
  @bunnia.keyed(
    "activity-\{item.id}",
    @bunnia.node(
      kind="view",
      attrs=[
        @bunnia.class_name(
          "moontown-activity-entry bunnia-status-\{item.status}",
        ),
        @bunnia.data("activity-kind", item.kind),
        @bunnia.data("target-ref", item.target_ref),
        @bunnia.data("building-id", item.building_id),
        @bunnia.data("actor-id", item.actor_id),
        @bunnia.data("action-message", activity_action_message(item)),
        @bunnia.data("target-tab", activity_target_tab(item)),
      ],
      events=[@bunnia.event("tap", activity_action_message(item))],
      children=[
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-title")], [
          @bunnia.text(item.title),
        ]),
        @bunnia.text(item.summary),
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-meta")], [
          @bunnia.text(
            "\{item.kind} / \{item.status} / \{activity_target_tab(item)}",
          ),
        ]),
      ],
    ),
  )
}

///|
fn activity_action_message(item : MiniTownActivityItem) -> String {
  if item.target_ref.has_prefix("thread:") ||
    item.target_ref.has_prefix("run:") ||
    item.target_ref.has_prefix("review:") ||
    item.kind == "run" ||
    item.kind == "review" {
    "tab-messages"
  } else if item.target_ref.has_prefix("book:") ||
    item.kind == "book" ||
    item.kind == "publish" ||
    item.kind == "place" {
    "tab-discover"
  } else {
    "select-\{item.building_id}"
  }
}

///|
fn activity_target_tab(item : MiniTownActivityItem) -> String {
  let message = activity_action_message(item)
  if message.has_prefix("tab-") {
    message.sub(start=4, end=message.length()).to_owned()
  } else {
    "realm"
  }
}

///|
fn discover_panel(projection : MiniTownProjection) -> @bunnia.Node {
  let results = filtered_discovery_results(projection)
  let people = discovery_results_by_kind(projection, "user")
  let circles = discovery_results_by_kind(projection, "circle")
  let market = market_discovery_results(projection)
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-shell-panel")], [
    @bunnia.view_with_attrs(
      [@bunnia.class_name("moontown-shell-panel-title")],
      [@bunnia.text("Discover")],
    ),
    @bunnia.view_with_attrs([@bunnia.class_name("moontown-shell-panel-note")], [
      @bunnia.text(
        "Search buildings, users, agents, books, products, events, demands, and posts.",
      ),
    ]),
    @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-meta")], [
      @bunnia.text("runtime filter: {{discover.filter || 'all'}}"),
    ]),
    @bunnia.input(
      name="discoverSearch",
      value=projection.search_query,
      input_message="discover-search",
    ),
    discover_spotlight_section("Town People", people),
    discover_spotlight_section("Town Circles", circles),
    discover_spotlight_section("Town Market", market),
    @bunnia.view_with_attrs(
      [@bunnia.class_name("moontown-discovery-filters")],
      [
        @bunnia.windowed_list(
          projection.discovery_filters,
          total_count=projection.discovery_filters.length(),
          render=filter => {
            discovery_filter_chip(filter, projection.active_discovery_filter_id)
          },
        ),
      ],
    ),
    @bunnia.windowed_list(results, total_count=results.length(), render=item => {
      discover_entry(projection, item)
    }),
  ])
}

///|
fn discover_spotlight_section(
  title : String,
  items : Array[MiniTownDiscoveryItem],
) -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-discovery-strip")], [
    @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-title")], [
      @bunnia.text(title),
    ]),
    @bunnia.windowed_list(
      items,
      total_count=items.length(),
      render=discover_spotlight_chip,
    ),
  ])
}

///|
fn discover_spotlight_chip(item : MiniTownDiscoveryItem) -> @bunnia.Node {
  @bunnia.keyed(
    "discover-chip-\{item.id}",
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("moontown-discovery-chip"),
        @bunnia.data("discovery-kind", item.kind),
        @bunnia.data("target-ref", item.target_ref),
      ],
      [
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-title")], [
          @bunnia.text(item.title),
        ]),
        @bunnia.text(item.status),
      ],
    ),
  )
}

///|
fn discovery_filter_chip(
  filter : MiniTownDiscoveryFilter,
  active_filter_id : String,
) -> @bunnia.Node {
  @bunnia.keyed(
    "discover-filter-\{filter.id}",
    @bunnia.node(
      kind="view",
      attrs=[
        @bunnia.class_name(
          if filter.id == active_filter_id {
            "moontown-discovery-filter active"
          } else {
            "moontown-discovery-filter"
          },
        ),
        @bunnia.data("filter-id", filter.id),
        @bunnia.data("filter-kind", filter.kind),
      ],
      events=[@bunnia.event("tap", "discover-filter-\{filter.id}")],
      children=[@bunnia.text(filter.label)],
    ),
  )
}

///|
fn discover_entry(
  projection : MiniTownProjection,
  item : MiniTownDiscoveryItem,
) -> @bunnia.Node {
  @bunnia.keyed(
    "discover-\{item.id}",
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name(
          "moontown-discover-entry bunnia-status-\{item.status}",
        ),
        @bunnia.data("discovery-id", item.id),
        @bunnia.data("discovery-kind", item.kind),
        @bunnia.data("target-ref", item.target_ref),
        @bunnia.data("visibility", item.visibility),
      ],
      [
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-title")], [
          @bunnia.text(item.title),
        ]),
        @bunnia.text(item.summary),
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-meta")], [
          @bunnia.text("\{item.kind} / \{item.visibility}"),
        ]),
        discover_entry_action(projection, item),
      ],
    ),
  )
}

///|
fn discover_entry_action(
  projection : MiniTownProjection,
  item : MiniTownDiscoveryItem,
) -> @bunnia.Node {
  if item.kind == "building" && item.visibility == "published" {
    let placement_state = discovery_item_placement_state(projection, item)
    let place_events = if placement_state == "pinned" {
      []
    } else {
      [@bunnia.tap("place-published-building")]
    }
    @bunnia.view_with_attrs([@bunnia.class_name("moontown-discovery-action")], [
      @bunnia.node(
        kind="button",
        attrs=[
          @bunnia.data("discovery-id", item.id),
          @bunnia.data("building-id", discovery_item_building_id(item)),
          @bunnia.data("target-ref", item.target_ref),
          @bunnia.data("placement-state", placement_state),
          @bunnia.data("placement-layer", "personal"),
          @bunnia.data("placement-source", "discover"),
          @bunnia.data(
            "placement-x",
            discovery_item_building_x(projection, item),
          ),
          @bunnia.data(
            "placement-y",
            discovery_item_building_y(projection, item),
          ),
        ],
        events=place_events,
        children=[
          @bunnia.text(
            if placement_state == "pinned" {
              "Pinned On Map"
            } else {
              "Place On Map"
            },
          ),
        ],
      ),
    ])
  } else {
    @bunnia.view([])
  }
}

///|
fn discovery_item_placement_state(
  projection : MiniTownProjection,
  item : MiniTownDiscoveryItem,
) -> String {
  match placement_for_building(projection, discovery_item_building_id(item)) {
    Some(placement) => placement.status
    None => "not-placed"
  }
}

///|
fn discovery_item_building_id(item : MiniTownDiscoveryItem) -> String {
  if item.target_ref.has_prefix("building:") {
    item.target_ref.sub(start=9, end=item.target_ref.length()).to_owned()
  } else {
    item.id
  }
}

///|
fn discovery_item_building_x(
  projection : MiniTownProjection,
  item : MiniTownDiscoveryItem,
) -> String {
  let building_id = discovery_item_building_id(item)
  for building in projection.buildings {
    if building.id == building_id {
      return "\{building.x}"
    }
  }
  "0"
}

///|
fn discovery_item_building_y(
  projection : MiniTownProjection,
  item : MiniTownDiscoveryItem,
) -> String {
  let building_id = discovery_item_building_id(item)
  for building in projection.buildings {
    if building.id == building_id {
      return "\{building.y}"
    }
  }
  "0"
}

///|
fn messages_panel(projection : MiniTownProjection) -> @bunnia.Node {
  let unread = unread_notifications(projection)
  let subscription = subscription_notifications(projection)
  let reviews = review_runs(projection)
  let notices = filtered_notifications(projection)
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-shell-panel")], [
    @bunnia.view_with_attrs(
      [@bunnia.class_name("moontown-shell-panel-title")],
      [@bunnia.text("Messages")],
    ),
    @bunnia.view_with_attrs([@bunnia.class_name("moontown-shell-panel-note")], [
      @bunnia.text(
        "\{unread.length()} unread agent and town events; \{reviews.length()} review run; \{subscription.length()} subscription prompt.",
      ),
    ]),
    @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-meta")], [
      @bunnia.text("runtime channel: {{messages.channel || 'all'}}"),
    ]),
    message_backend_state_row(),
    message_bucket_row(projection),
    @bunnia.view_with_attrs([@bunnia.class_name("moontown-message-channels")], [
      @bunnia.windowed_list(
        projection.notification_channels,
        total_count=projection.notification_channels.length(),
        render=channel => {
          notification_channel_chip(
            channel,
            projection.active_notification_channel_id,
          )
        },
      ),
    ]),
    @bunnia.windowed_list(
      notices,
      total_count=notices.length(),
      render=notification_entry,
    ),
  ])
}

///|
fn message_backend_state_row() -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-message-buckets moontown-message-sync"),
      @bunnia.data("backend-sync", "notifications"),
    ],
    [
      message_backend_state_chip(
        label="Ack Sync",
        endpoint_id="ack-notification",
        path="/miniapp/messages/ack",
        target_ref="notificationAckResult",
      ),
      message_backend_state_chip(
        label="Subscribe Sync",
        endpoint_id="request-subscription",
        path="/miniapp/messages/subscribe",
        target_ref="subscriptionResult",
      ),
      message_backend_state_chip(
        label="Handoff Sync",
        endpoint_id="handoff-agent-work",
        path="/miniapp/agents/handoff",
        target_ref="handoffResult",
      ),
      message_backend_state_chip(
        label="Tool Ack",
        endpoint_id="ack-tool-result",
        path="/miniapp/tool-results/ack",
        target_ref="toolResultAckResult",
      ),
    ],
  )
}

///|
fn message_backend_state_chip(
  label~ : String,
  endpoint_id~ : String,
  path~ : String,
  target_ref~ : String,
) -> @bunnia.Node {
  @bunnia.keyed(
    "message-backend-\{endpoint_id}",
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("moontown-message-bucket"),
        @bunnia.data("backend-endpoint", endpoint_id),
        @bunnia.data("backend-path", path),
        @bunnia.data("backend-target", target_ref),
      ],
      [
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-title")], [
          @bunnia.text(label),
        ]),
        @bunnia.text(
          "{{backendStatus.\{backend_status_key(endpoint_id)}.state || 'idle'}}",
        ),
      ],
    ),
  )
}

///|
fn message_bucket_row(projection : MiniTownProjection) -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-message-buckets")], [
    message_bucket_chip(
      label="New Follows",
      count=notification_kind_count(projection, "follow"),
      channel_id="follow",
      kind="follow",
    ),
    message_bucket_chip(
      label="Interactions",
      count=notification_kind_count(projection, "interaction"),
      channel_id="interaction",
      kind="interaction",
    ),
    message_bucket_chip(
      label="System",
      count=notification_kind_count(projection, "subscription"),
      channel_id="system",
      kind="subscription",
    ),
  ])
}

///|
fn message_bucket_chip(
  label~ : String,
  count~ : Int,
  channel_id~ : String,
  kind~ : String,
) -> @bunnia.Node {
  @bunnia.node(
    kind="view",
    attrs=[
      @bunnia.class_name("moontown-message-bucket"),
      @bunnia.data("channel-id", channel_id),
      @bunnia.data("channel-kind", kind),
    ],
    events=[@bunnia.event("tap", "notification-channel-\{channel_id}")],
    children=[
      @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-title")], [
        @bunnia.text(label),
      ]),
      @bunnia.text("\{count} notices"),
    ],
  )
}

///|
fn notification_kind_count(
  projection : MiniTownProjection,
  kind : String,
) -> Int {
  let mut count = 0
  for notice in visible_notifications(projection) {
    if notice.kind == kind {
      count += 1
    }
  }
  count
}

///|
fn notification_channel_chip(
  channel : MiniTownNotificationChannel,
  active_channel_id : String,
) -> @bunnia.Node {
  @bunnia.keyed(
    "notice-channel-\{channel.id}",
    @bunnia.node(
      kind="view",
      attrs=[
        @bunnia.class_name(
          if channel.id == active_channel_id {
            "moontown-message-channel active"
          } else {
            "moontown-message-channel"
          },
        ),
        @bunnia.data("channel-id", channel.id),
        @bunnia.data("channel-kind", channel.kind),
      ],
      events=[@bunnia.event("tap", "notification-channel-\{channel.id}")],
      children=[@bunnia.text(channel.label)],
    ),
  )
}

///|
fn run_queue_panel(projection : MiniTownProjection) -> @bunnia.Node {
  let runs = active_runs(projection)
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-shell-panel")], [
    @bunnia.view_with_attrs(
      [@bunnia.class_name("moontown-shell-panel-title")],
      [@bunnia.text("Agent Runs")],
    ),
    @bunnia.view_with_attrs([@bunnia.class_name("moontown-shell-panel-note")], [
      @bunnia.text(
        "Runs stay linked to buildings, books, threads, and review artifacts.",
      ),
    ]),
    @bunnia.windowed_list(
      runs,
      total_count=runs.length(),
      render=run_queue_entry,
    ),
  ])
}

///|
fn run_queue_entry(run : MiniTownRun) -> @bunnia.Node {
  @bunnia.keyed(
    "run-queue-\{run.id}",
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("moontown-run-entry bunnia-status-\{run.status}"),
        @bunnia.data("run-id", run.id),
        @bunnia.data("agent-id", run.agent_id),
        @bunnia.data("building-id", run.building_id),
        @bunnia.data("book-id", run.book_id),
        @bunnia.data("thread-id", run.thread_id),
        @bunnia.data("artifact-ref", run.artifact_ref),
        @bunnia.data(
          "review-required",
          if run.review_required {
            "true"
          } else {
            "false"
          },
        ),
      ],
      [
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-title")], [
          @bunnia.text(run.title),
        ]),
        @bunnia.text(run.summary),
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-meta")], [
          @bunnia.text("\{run.status} / \{run.thread_id}"),
        ]),
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-run-actions")], [
          @bunnia.list(run_actions(run), fn(action) {
            run_action_button(run.id, action)
          }),
        ]),
      ],
    ),
  )
}

///|
fn run_action_button(
  run_id : String,
  action : MiniTownRunAction,
) -> @bunnia.Node {
  let attrs = [
    @bunnia.class_name("moontown-run-action \{action.status}"),
    @bunnia.data("run-action", action.id),
    @bunnia.data("run-id", run_id),
    @bunnia.data("target-ref", action.target_ref),
    @bunnia.data("allowed", if action.allowed { "true" } else { "false" }),
    @bunnia.data("blocked-reason", action.reason),
  ]
  if !action.allowed {
    attrs.push(@bunnia.attr("disabled", "true"))
  }
  @bunnia.keyed(
    "run-action-\{run_id}-\{action.id}",
    @bunnia.node(
      kind="button",
      attrs~,
      events=[@bunnia.event("tap", action.message)],
      children=[@bunnia.text(action.label)],
    ),
  )
}

///|
fn run_entry(run : MiniTownRun) -> @bunnia.Node {
  @bunnia.keyed(
    "run-\{run.id}",
    @bunnia.node(
      kind="view",
      attrs=[
        @bunnia.class_name("moontown-run-entry bunnia-status-\{run.status}"),
        @bunnia.data("run-id", run.id),
        @bunnia.data("agent-id", run.agent_id),
        @bunnia.data("building-id", run.building_id),
        @bunnia.data("book-id", run.book_id),
        @bunnia.data("thread-id", run.thread_id),
        @bunnia.data("artifact-ref", run.artifact_ref),
        @bunnia.data(
          "review-required",
          if run.review_required {
            "true"
          } else {
            "false"
          },
        ),
      ],
      events=[@bunnia.event("tap", "select-\{run.building_id}")],
      children=[
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-title")], [
          @bunnia.text(run.title),
        ]),
        @bunnia.text(run.summary),
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-meta")], [
          @bunnia.text("\{run.status} / \{run.thread_id}"),
        ]),
      ],
    ),
  )
}

///|
fn tool_result_panel(projection : MiniTownProjection) -> @bunnia.Node {
  let cards = tool_result_cards(projection)
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-shell-panel moontown-tool-results"),
      @bunnia.data("tool-result-count", cards.length().to_string()),
    ],
    [
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-shell-panel-title")],
        [@bunnia.text("Tool Results")],
      ),
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-shell-panel-note")],
        [
          @bunnia.text(
            "Tool artifacts stay attached to buildings, threads, and acknowledgements.",
          ),
        ],
      ),
      @bunnia.windowed_tool_result_card_list(cards, total_count=cards.length()),
    ],
  )
}

///|
fn review_queue_panel(projection : MiniTownProjection) -> @bunnia.Node {
  let reviews = pending_reviews(projection)
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-shell-panel")], [
    @bunnia.view_with_attrs(
      [@bunnia.class_name("moontown-shell-panel-title")],
      [@bunnia.text("Review Queue")],
    ),
    @bunnia.view_with_attrs([@bunnia.class_name("moontown-shell-panel-note")], [
      @bunnia.text(
        "Accepted memory enters books; accepted publication enters town discovery.",
      ),
    ]),
    @bunnia.windowed_list(
      reviews,
      total_count=reviews.length(),
      render=review_entry,
    ),
  ])
}

///|
fn review_entry(item : MiniTownReviewItem) -> @bunnia.Node {
  @bunnia.keyed(
    "review-\{item.id}",
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("moontown-review-entry bunnia-status-\{item.status}"),
        @bunnia.data("review-id", item.id),
        @bunnia.data("run-id", item.run_id),
        @bunnia.data("building-id", item.building_id),
        @bunnia.data("book-id", item.book_id),
        @bunnia.data("artifact-ref", item.artifact_ref),
        @bunnia.data("reviewer-id", item.reviewer_id),
      ],
      [
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-title")], [
          @bunnia.text(item.title),
        ]),
        @bunnia.text(item.summary),
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-meta")], [
          @bunnia.text(review_meta_text(item)),
        ]),
        review_controls_entry(item),
      ],
    ),
  )
}

///|
fn review_controls_entry(item : MiniTownReviewItem) -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("bunnia-review bunnia-review-pending"),
      @bunnia.data("review-id", item.id),
      @bunnia.data("run-id", item.run_id),
      @bunnia.data("review-enabled", "true"),
    ],
    [
      @bunnia.text(review_kind_label(item)),
      review_decision_button(item, "Approve", "accept", item.accept_message),
      review_decision_button(item, "Reject", "reject", item.reject_message),
    ],
  )
}

///|
fn review_kind_label(item : MiniTownReviewItem) -> String {
  if item.artifact_ref.has_prefix("building://") {
    "Publication review"
  } else {
    "Memory review"
  }
}

///|
fn review_meta_text(item : MiniTownReviewItem) -> String {
  if item.artifact_ref.has_prefix("building://") {
    "\{item.status} / publication gate"
  } else {
    "\{item.status} / +\{item.accepted_memory_delta} memory"
  }
}

///|
fn review_decision_button(
  item : MiniTownReviewItem,
  label : String,
  decision : String,
  message : String,
) -> @bunnia.Node {
  @bunnia.node(
    kind="button",
    attrs=[
      @bunnia.class_name("bunnia-review-button bunnia-review-button-enabled"),
      @bunnia.data("review-id", item.id),
      @bunnia.data("run-id", item.run_id),
      @bunnia.data("decision", decision),
    ],
    events=[@bunnia.tap(message)],
    children=[@bunnia.text(label)],
  )
}

///|
fn moderation_desk_panel(projection : MiniTownProjection) -> @bunnia.Node {
  let cases = projection.moderation_cases
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-shell-panel")], [
    @bunnia.view_with_attrs(
      [@bunnia.class_name("moontown-shell-panel-title")],
      [@bunnia.text("Moderation Desk")],
    ),
    @bunnia.view_with_attrs([@bunnia.class_name("moontown-shell-panel-note")], [
      @bunnia.text(
        "\{cases.length()} report case; hide or takedown stays audited.",
      ),
    ]),
    @bunnia.windowed_list(
      cases,
      total_count=cases.length(),
      render=moderation_case_entry,
    ),
  ])
}

///|
fn moderation_case_entry(item : MiniTownModerationCase) -> @bunnia.Node {
  @bunnia.keyed(
    "moderation-\{item.id}",
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("moontown-review-entry bunnia-status-\{item.status}"),
        @bunnia.data("moderation-case", item.id),
        @bunnia.data("building-id", item.building_id),
        @bunnia.data("target-ref", item.target_ref),
        @bunnia.data("reporter-id", item.reporter_id),
      ],
      [
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-title")], [
          @bunnia.text(item.title),
        ]),
        @bunnia.text(item.summary),
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-run-actions")], [
          moderation_button(item, "Hide", "hide", "hide-public-building"),
          moderation_button(
            item, "Takedown", "takedown", "takedown-public-building",
          ),
        ]),
      ],
    ),
  )
}

///|
fn moderation_button(
  item : MiniTownModerationCase,
  label : String,
  action : String,
  message : String,
) -> @bunnia.Node {
  @bunnia.node(
    kind="button",
    attrs=[
      @bunnia.class_name("moontown-run-action stable"),
      @bunnia.data("moderation-action", action),
      @bunnia.data("moderation-case", item.id),
      @bunnia.data("building-id", item.building_id),
    ],
    events=[@bunnia.tap(message)],
    children=[@bunnia.text(label)],
  )
}

///|
fn lifecycle_panel(projection : MiniTownProjection) -> @bunnia.Node {
  lifecycle_panel_with_events(
    "Lifecycle",
    "Building actions stay auditable.",
    [],
    selected_building_audit_events(projection),
  )
}

///|
fn ownership_lifecycle_panel(projection : MiniTownProjection) -> @bunnia.Node {
  lifecycle_panel_with_events(
    "My Lifecycle",
    "Owned drafts, shares, publishing, placements, and archives stay visible here.",
    publication_steps(projection),
    owned_audit_events(projection),
  )
}

///|
fn lifecycle_panel_with_events(
  title : String,
  note : String,
  steps : Array[MiniTownPublicationStep],
  events : Array[MiniTownAuditEvent],
) -> @bunnia.Node {
  let children = [
    @bunnia.view_with_attrs(
      [@bunnia.class_name("moontown-shell-panel-title")],
      [@bunnia.text(title)],
    ),
    @bunnia.view_with_attrs([@bunnia.class_name("moontown-shell-panel-note")], [
      @bunnia.text(note),
    ]),
  ]
  if steps.length() > 0 {
    children.push(
      @bunnia.windowed_list(
        steps,
        total_count=steps.length(),
        render=publication_step_entry,
      ),
    )
  }
  children.push(
    @bunnia.windowed_list(
      events,
      total_count=events.length(),
      render=audit_entry,
    ),
  )
  @bunnia.view_with_attrs(
    [@bunnia.class_name("moontown-shell-panel")],
    children,
  )
}

///|
fn publication_step_entry(item : MiniTownPublicationStep) -> @bunnia.Node {
  @bunnia.keyed(
    "publication-step-\{item.id}",
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name(
          "moontown-publication-step bunnia-status-\{item.status}",
        ),
        @bunnia.data("publication-step", item.id),
        @bunnia.data("current", if item.current { "true" } else { "false" }),
        @bunnia.data("complete", if item.complete { "true" } else { "false" }),
        @bunnia.data("blocked", if item.blocked { "true" } else { "false" }),
      ],
      [
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-title")], [
          @bunnia.text(item.label),
        ]),
        @bunnia.text(item.summary),
      ],
    ),
  )
}

///|
fn audit_entry(item : MiniTownAuditEvent) -> @bunnia.Node {
  @bunnia.keyed(
    "audit-\{item.id}",
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("moontown-audit-entry bunnia-status-\{item.status}"),
        @bunnia.data("audit-id", item.id),
        @bunnia.data("audit-kind", item.kind),
        @bunnia.data("target-ref", item.target_ref),
        @bunnia.data("building-id", item.building_id),
        @bunnia.data("actor-id", item.actor_id),
        @bunnia.data("visibility", item.visibility),
      ],
      [
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-title")], [
          @bunnia.text(item.title),
        ]),
        @bunnia.text(item.summary),
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-meta")], [
          @bunnia.text("\{item.kind} / \{item.visibility} / \{item.timestamp}"),
        ]),
      ],
    ),
  )
}

///|
fn notification_entry(notice : MiniTownNotification) -> @bunnia.Node {
  @bunnia.keyed(
    "notice-\{notice.id}",
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("moontown-notice-entry"),
        @bunnia.data("notice-kind", notice.kind),
        @bunnia.data("target-ref", notice.target_ref),
        @bunnia.data("building-id", notice.building_id),
        @bunnia.data("action-message", notice.action_message),
        @bunnia.data(
          "requires-subscription",
          if notice.requires_subscription {
            "true"
          } else {
            "false"
          },
        ),
      ],
      [
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-title")], [
          @bunnia.text(notice.title),
        ]),
        @bunnia.text(notice.body),
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-run-actions")], [
          notification_action_button(notice),
          notification_ack_button(notice),
        ]),
      ],
    ),
  )
}

///|
fn notification_action_button(notice : MiniTownNotification) -> @bunnia.Node {
  notification_button(
    notice,
    label=notice.action_label,
    message=notice.action_message,
    action="open",
  )
}

///|
fn notification_ack_button(notice : MiniTownNotification) -> @bunnia.Node {
  notification_button(
    notice,
    label="Ack",
    message="ack-notification",
    action="ack",
  )
}

///|
fn notification_button(
  notice : MiniTownNotification,
  label~ : String,
  message~ : String,
  action~ : String,
) -> @bunnia.Node {
  @bunnia.node(
    kind="button",
    attrs=[
      @bunnia.class_name("moontown-notice-action"),
      @bunnia.data("notice-action", action),
      @bunnia.data("notice-id", notice.id),
      @bunnia.data("notice-kind", notice.kind),
      @bunnia.data("target-ref", notice.target_ref),
      @bunnia.data("building-id", notice.building_id),
    ],
    events=[@bunnia.tap(message)],
    children=[@bunnia.text(label)],
  )
}

///|
fn profile_panel(projection : MiniTownProjection) -> @bunnia.Node {
  let stats = ownership_stats(projection)
  let items = filtered_ownership_items(projection)
  let gates = setup_gates(projection)
  let alerts = workbench_alerts(projection)
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-shell-panel")], [
    @bunnia.view_with_attrs(
      [@bunnia.class_name("moontown-shell-panel-title")],
      [@bunnia.text("My Town")],
    ),
    @bunnia.view_with_attrs([@bunnia.class_name("moontown-shell-panel-note")], [
      @bunnia.text(
        "role: \{projection.profile.role_id}; consent: \{if projection.profile.consent_accepted { "accepted" } else { "needed" }}; showing: \{selected_ownership_filter(projection).label}; owned items: \{items.length()}",
      ),
    ]),
    @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-meta")], [
      @bunnia.text("runtime ownership: {{ownership.filter || 'all'}}"),
    ]),
    profile_identity_card(projection),
    profile_credential_plaque(projection),
    ownership_sync_plaque(projection),
    @bunnia.windowed_list(
      alerts,
      total_count=alerts.length(),
      render=workbench_alert_entry,
    ),
    @bunnia.windowed_list(
      stats,
      total_count=stats.length(),
      render=ownership_stat_entry,
    ),
    @bunnia.windowed_list(
      gates,
      total_count=gates.length(),
      render=setup_gate_entry,
    ),
    @bunnia.view_with_attrs(
      [@bunnia.class_name("moontown-ownership-filters")],
      [
        @bunnia.windowed_list(
          projection.ownership_filters,
          total_count=projection.ownership_filters.length(),
          render=filter => {
            ownership_filter_chip(filter, projection.active_ownership_filter_id)
          },
        ),
      ],
    ),
    @bunnia.windowed_list(
      items,
      total_count=items.length(),
      render=ownership_item_entry,
    ),
  ])
}

///|
fn ownership_sync_plaque(projection : MiniTownProjection) -> @bunnia.Node {
  let step = ownership_backend_step(projection)
  let cache = ownership_cache_state(projection)
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-credential-plaque"),
      @bunnia.data("backend-step", step.id),
      @bunnia.data("backend-endpoint", step.endpoint_id),
      @bunnia.data("backend-method", step.http_method),
      @bunnia.data("backend-path", step.path),
      @bunnia.data("backend-cache", cache.id),
      @bunnia.data("target-ref", cache.target_ref),
    ],
    [
      @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-title")], [
        @bunnia.text("Ownership Sync"),
      ]),
      @bunnia.text(step.summary),
      @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-meta")], [
        @bunnia.text(
          "\{cache.label}: \{cache.state} / \{step.http_method} \{step.path}",
        ),
      ]),
      @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-meta")], [
        @bunnia.text(
          "runtime: {{backendStatus.\{backend_status_key(step.endpoint_id)}.state || 'idle'}}",
        ),
      ]),
      @bunnia.button("Sync Ownership", step.endpoint_id),
    ],
  )
}

///|
fn ownership_backend_step(
  projection : MiniTownProjection,
) -> MiniTownBackendStep {
  for step in projection.backend_steps {
    if step.id == "ownership" {
      return step
    }
  }
  mini_town_backend_step(
    id="ownership",
    label="Sync Ownership",
    endpoint_id="load-ownership-snapshot",
    http_method="GET",
    path="/miniapp/me/ownership",
    summary="Pull owned buildings, books, agents, placements, and alerts for My.",
    status="ready",
  )
}

///|
fn ownership_cache_state(
  projection : MiniTownProjection,
) -> MiniTownBackendCacheState {
  for cache in projection.backend_cache_states {
    if cache.id == "ownership" {
      return cache
    }
  }
  mini_town_backend_cache_state(
    id="ownership",
    label="Ownership Snapshot",
    source="cache",
    state="idle",
    summary="My can reload owned buildings, books, agents, placements, and alerts.",
    target_ref="backend:load-ownership-snapshot",
    action_label="Sync",
    action_message="load-ownership-snapshot",
  )
}

///|
fn workbench_alert_entry(alert : MiniTownWorkbenchAlert) -> @bunnia.Node {
  @bunnia.keyed(
    "workbench-alert-\{alert.id}",
    @bunnia.node(
      kind="view",
      attrs=[
        @bunnia.class_name(
          "moontown-workbench-alert bunnia-status-\{alert.status}",
        ),
        @bunnia.data("workbench-alert", alert.id),
        @bunnia.data("severity", alert.severity),
        @bunnia.data("target-ref", alert.target_ref),
        @bunnia.data("status", alert.status),
      ],
      events=[@bunnia.event("tap", alert.action_message)],
      children=[
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-title")], [
          @bunnia.text(alert.title),
        ]),
        @bunnia.text(alert.summary),
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-meta")], [
          @bunnia.text(
            "\{alert.severity} / \{alert.action_label} / \{alert.status}",
          ),
        ]),
      ],
    ),
  )
}

///|
fn profile_identity_card(projection : MiniTownProjection) -> @bunnia.Node {
  let stats = ownership_stats(projection)
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-profile-card"),
      @bunnia.data("profile-user-id", projection.profile.user_id),
      @bunnia.data("profile-role", projection.profile.role_id),
      @bunnia.data(
        "profile-ready",
        if profile_ready_to_publish(projection) {
          "true"
        } else {
          "false"
        },
      ),
    ],
    [
      @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-title")], [
        @bunnia.text(projection.profile.display_name),
      ]),
      @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-meta")], [
        @bunnia.text(
          "UID:\{projection.profile.user_id} / \{projection.profile.avatar_ref}",
        ),
      ]),
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-profile-metrics")],
        [
          profile_metric_chip(
            label="Follows",
            value=discovery_results_by_kind(projection, "user").length(),
          ),
          profile_metric_chip(
            label="Followers",
            value=notification_kind_count(projection, "follow"),
          ),
          profile_metric_chip(
            label="Reviews",
            value=pending_reviews(projection).length(),
          ),
          profile_metric_chip(
            label="Published",
            value=ownership_stat_value(stats, "published"),
          ),
        ],
      ),
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-profile-actions")],
        [
          @bunnia.button("Edit Profile", "save-profile"),
          @bunnia.button("Accept Consent", "accept-profile-consent"),
        ],
      ),
    ],
  )
}

///|
fn profile_metric_chip(label~ : String, value~ : Int) -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-profile-metric")], [
    @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-title")], [
      @bunnia.text(value.to_string()),
    ]),
    @bunnia.text(label),
  ])
}

///|
fn profile_credential_plaque(projection : MiniTownProjection) -> @bunnia.Node {
  let district = profile_credential_district(projection)
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-credential-plaque"),
      @bunnia.data("district-id", district.id),
      @bunnia.data("feature-kind", district.feature_kind),
      @bunnia.data("target-building-id", district.building_id),
      @bunnia.data("status", district.status),
    ],
    [
      @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-title")], [
        @bunnia.text("OPC Credential"),
      ]),
      @bunnia.text("\{district.title}: \{district.summary}"),
      @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-meta")], [
        @bunnia.text(
          "\{district.stat_value} \{district.stat_label} / \{district.status}",
        ),
      ]),
      @bunnia.button(district.action_label, "select-\{district.building_id}"),
    ],
  )
}

///|
fn profile_credential_district(
  projection : MiniTownProjection,
) -> MiniTownDistrict {
  for district in projection.districts {
    if district.feature_kind == "credential" {
      return district
    }
  }
  projection.districts[0]
}

///|
fn ownership_stat_value(
  stats : Array[MiniTownOwnershipStat],
  id : String,
) -> Int {
  for stat in stats {
    if stat.id == id {
      return stat.value
    }
  }
  0
}

///|
fn ownership_filter_chip(
  filter : MiniTownOwnershipFilter,
  active_filter_id : String,
) -> @bunnia.Node {
  @bunnia.keyed(
    "ownership-filter-\{filter.id}",
    @bunnia.node(
      kind="view",
      attrs=[
        @bunnia.class_name(
          if filter.id == active_filter_id {
            "moontown-ownership-filter active"
          } else {
            "moontown-ownership-filter"
          },
        ),
        @bunnia.data("ownership-filter-id", filter.id),
        @bunnia.data("ownership-filter-kind", filter.kind),
        @bunnia.data("ownership-filter-visibility", filter.visibility),
      ],
      events=[@bunnia.event("tap", "ownership-filter-\{filter.id}")],
      children=[@bunnia.text(filter.label)],
    ),
  )
}

///|
fn ownership_stat_entry(stat : MiniTownOwnershipStat) -> @bunnia.Node {
  @bunnia.keyed(
    "ownership-stat-\{stat.id}",
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("moontown-owned-entry"),
        @bunnia.data("ownership-stat", stat.id),
      ],
      [
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-title")], [
          @bunnia.text(stat.label),
        ]),
        @bunnia.text(stat.value.to_string()),
      ],
    ),
  )
}

///|
fn ownership_item_entry(item : MiniTownOwnershipItem) -> @bunnia.Node {
  @bunnia.keyed(
    "owned-\{item.id}",
    @bunnia.node(
      kind="view",
      attrs=[
        @bunnia.class_name("moontown-owned-entry"),
        @bunnia.data("ownership-kind", item.kind),
        @bunnia.data("target-ref", item.target_ref),
        @bunnia.data("visibility", item.visibility),
        @bunnia.data("status", item.status),
        @bunnia.data("action-message", item.action_message),
        @bunnia.data("target-tab", ownership_item_target_tab(item)),
      ],
      events=[@bunnia.event("tap", item.action_message)],
      children=[
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-title")], [
          @bunnia.text(item.title),
        ]),
        @bunnia.text(item.summary),
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-meta")], [
          @bunnia.text(
            "\{item.kind} / \{item.visibility} / \{item.action_label} / \{ownership_item_target_tab(item)}",
          ),
        ]),
      ],
    ),
  )
}

///|
fn ownership_item_target_tab(item : MiniTownOwnershipItem) -> String {
  if item.action_message.has_prefix("tab-") {
    item.action_message
    .sub(start=4, end=item.action_message.length())
    .to_owned()
  } else if item.action_message.has_prefix("select-") {
    "realm"
  } else if item.action_message.contains("building") ||
    item.action_message.contains("publish") ||
    item.action_message.contains("archive") ||
    item.action_message.contains("restore") {
    "my"
  } else {
    "my"
  }
}

///|
fn town_tabbar(projection : MiniTownProjection) -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-tabbar")], [
    @bunnia.list(projection.tabs, fn(tab) {
      tab_button(tab, projection.active_tab_id)
    }),
  ])
}

///|
fn tab_button(tab : MiniTownTab, active_tab_id : String) -> @bunnia.Node {
  @bunnia.keyed(
    "tab-\{tab.id}",
    @bunnia.node(
      kind="button",
      attrs=[
        @bunnia.class_name(
          if tab.id == active_tab_id {
            "moontown-tab-button active"
          } else {
            "moontown-tab-button"
          },
        ),
        @bunnia.data("tab-id", tab.id),
        @bunnia.data("bunnia-route", moontown_tab_route(tab.id)),
        @bunnia.data(
          "map-surface",
          if tab.map_surface {
            "true"
          } else {
            "false"
          },
        ),
      ],
      events=[@bunnia.tap("tab-\{tab.id}")],
      children=[@bunnia.text(tab.label)],
    ),
  )
}

///|
fn town_bottom_hud(projection : MiniTownProjection) -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-bottom-hud")], [
    visibility_strip(projection),
    search_drawer(projection),
    create_drawer(projection),
  ])
}

///|
fn visibility_strip(projection : MiniTownProjection) -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-visibility-strip")], [
    @bunnia.windowed_list(
      visible_buildings(projection),
      total_count=visible_buildings(projection).length(),
      render=visibility_chip,
    ),
  ])
}

///|
fn visibility_chip(building : MiniTownBuilding) -> @bunnia.Node {
  @bunnia.keyed(
    "visibility-\{building.id}",
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("moontown-visibility-chip"),
        @bunnia.data("building-id", building.id),
        @bunnia.data("visibility", building.visibility),
      ],
      [@bunnia.text("\{building.title}: \{building.visibility}")],
    ),
  )
}

///|
fn user_switcher(projection : MiniTownProjection) -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-user-switcher")], [
    @bunnia.text("User: \{projection.active_user_id}"),
    @bunnia.button("Login", "dev-login"),
    @bunnia.button("Load", "load-town-snapshot"),
    @bunnia.button("Ada", "switch-user-a"),
    @bunnia.button("Bo", "switch-user-b"),
  ])
}

///|
fn selected_building_drawer(projection : MiniTownProjection) -> @bunnia.Node {
  let building = selected_building(projection)
  let book = selected_building_book(projection)
  let shelf = selected_building_book_shelf(projection)
  let runs = selected_building_runs(projection)
  let actions = selected_building_lifecycle_actions(projection)
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name(
        "moontown-building-drawer bunnia-status-\{building.status}",
      ),
      @bunnia.data("building-id", building.id),
      @bunnia.data("visibility", building.visibility),
    ],
    [
      @bunnia.text(building.title),
      @bunnia.text(building.summary),
      @bunnia.text("visibility: \{building.visibility}"),
      moderation_safety_row(projection, building),
      @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-meta")], [
        @bunnia.text("primary book: \{book.title}; shelf: \{shelf.length()}"),
      ]),
      @bunnia.windowed_list(
        shelf,
        total_count=shelf.length(),
        render=book_shelf_entry,
      ),
      @bunnia.windowed_list(runs, total_count=runs.length(), render=run_entry),
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-lifecycle-actions")],
        [@bunnia.list(actions, lifecycle_action_button)],
      ),
    ],
  )
}

///|
fn moderation_safety_row(
  projection : MiniTownProjection,
  building : MiniTownBuilding,
) -> @bunnia.Node {
  let cases = selected_building_moderation_cases(projection)
  @bunnia.node(
    kind="button",
    attrs=[
      @bunnia.class_name("moontown-notice-action"),
      @bunnia.data("moderation-building", building.id),
      @bunnia.data("moderation-count", cases.length().to_string()),
    ],
    events=[@bunnia.tap("report-public-building")],
    children=[@bunnia.text("Safety Desk \{cases.length()} / Report")],
  )
}

///|
fn book_shelf_entry(item : MiniTownBookShelfItem) -> @bunnia.Node {
  @bunnia.keyed(
    "book-shelf-\{item.id}",
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("moontown-book-entry bunnia-status-\{item.status}"),
        @bunnia.data("book-shelf-role", item.role),
        @bunnia.data("book-id", item.book_id),
        @bunnia.data("building-id", item.building_id),
        @bunnia.data("target-ref", item.target_ref),
        @bunnia.data("visibility", item.visibility),
      ],
      [
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-title")], [
          @bunnia.text("\{item.title}"),
        ]),
        @bunnia.text(item.safe_summary),
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-meta")], [
          @bunnia.text(
            "\{item.role} / \{item.accepted_memory_count} memories / \{item.pending_review_count} reviews / \{item.status}",
          ),
        ]),
      ],
    ),
  )
}

///|
fn lifecycle_action_button(action : MiniTownLifecycleAction) -> @bunnia.Node {
  let attrs = [
    @bunnia.class_name("moontown-lifecycle-action \{action.status}"),
    @bunnia.data("lifecycle-action", action.id),
    @bunnia.data("target-ref", action.target_ref),
    @bunnia.data("building-id", lifecycle_action_building_id(action)),
    @bunnia.data("book-id", action.book_id),
    @bunnia.data("allowed", if action.allowed { "true" } else { "false" }),
    @bunnia.data("blocked-reason", action.reason),
  ]
  if !action.allowed {
    attrs.push(@bunnia.attr("disabled", "true"))
  }
  @bunnia.keyed(
    "lifecycle-action-\{action.id}",
    @bunnia.node(
      kind="button",
      attrs~,
      events=[@bunnia.event("tap", action.message)],
      children=[
        @bunnia.text(action.label),
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-meta")], [
          @bunnia.text(action.reason),
        ]),
      ],
    ),
  )
}

///|
fn lifecycle_action_building_id(action : MiniTownLifecycleAction) -> String {
  action.target_ref.replace_all(old="building:", new="")
}

///|
fn search_drawer(projection : MiniTownProjection) -> @bunnia.Node {
  let results = search_results(projection)
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-search-drawer")], [
    @bunnia.input(
      name="discoverSearch",
      value=projection.search_query,
      input_message="discover-search",
    ),
    @bunnia.windowed_list(
      results,
      total_count=results.length(),
      render=building_result,
    ),
  ])
}

///|
fn building_result(building : MiniTownBuilding) -> @bunnia.Node {
  @bunnia.keyed(
    building.id,
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name(
          "moontown-search-result bunnia-status-\{building.status}",
        ),
        @bunnia.data("building-id", building.id),
      ],
      [
        @bunnia.text(building.title),
        @bunnia.text(building.kind),
        @bunnia.button("Open", "select-\{building.id}"),
      ],
    ),
  )
}

///|
fn chat_drawer(projection : MiniTownProjection) -> @bunnia.Node {
  let agent = selected_agent(projection)
  let building = selected_building(projection)
  let messages = selected_building_messages(projection)
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-chat-drawer"),
      @bunnia.data("thread-id", "thread-\{building.id}"),
      @bunnia.data("building-id", building.id),
      @bunnia.data("backend-endpoint", "send-building-message"),
      @bunnia.data("backend-path", "/miniapp/messages/send"),
    ],
    [
      @bunnia.text("Agent: \{agent.name}"),
      @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-meta")], [
        @bunnia.text(
          "thread-\{building.id} / runtime: {{backendStatus.send_building_message.state || 'idle'}}",
        ),
      ]),
      @bunnia.windowed_message_feed(
        bunnia_messages(messages),
        total_count=messages.length(),
      ),
      @bunnia.form("send-building-message", [
        @bunnia.input(
          name="chatBody",
          value="Ask \{building.title} about publishing rules",
          input_message="draft-building-message",
        ),
        @bunnia.button("Send Message", "send-building-message"),
      ]),
    ],
  )
}

///|
fn create_drawer(_projection : MiniTownProjection) -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-create-drawer")], [
    @bunnia.form("create-private-building", [
      @bunnia.input(name="buildingTitle", value="New Agent Lab"),
      @bunnia.button("Create Building", "create-private-building"),
    ]),
    @bunnia.form("create-agent", [
      @bunnia.input(name="agentName", value="New Agent"),
      @bunnia.button("Create Agent", "create-agent"),
    ]),
  ])
}

///|
fn markers_from_buildings(
  buildings : Array[MiniTownBuilding],
) -> Array[@bunnia.SceneMarker] {
  let markers : Array[@bunnia.SceneMarker] = []
  for building in buildings {
    markers.push(
      @bunnia.marker(
        id=building.id,
        label=building.title,
        x=building.x,
        y=building.y,
        status=building.status,
        tap_message="select-\{building.id}",
        asset_ref=building.asset_ref,
        hit_width=52,
        hit_height=52,
      ),
    )
  }
  markers
}

///|
fn bunnia_messages(messages : Array[MiniTownMessage]) -> Array[@bunnia.Message] {
  let output : Array[@bunnia.Message] = []
  for item in messages {
    output.push(
      @bunnia.message(
        id=item.id,
        actor_id=item.actor_id,
        thread_id=item.thread_id,
        text=item.text,
        status=item.status,
      ),
    )
  }
  output
}

///|
fn demo_scene_thread_links(
  projection : MiniTownProjection,
) -> Array[@bunnia.SceneThreadLink] {
  let links : Array[@bunnia.SceneThreadLink] = []
  for building in visible_buildings(projection) {
    links.push(
      @bunnia.scene_marker_thread_link(
        id="thread-link-\{building.id}",
        scene_id="moontown-map",
        marker_id=building.id,
        thread_id="thread-\{building.id}",
        subject_ref="scene://moontown-map/\{building.id}",
        status=building.status,
        unread_count=if building.status == "review" { 1 } else { 0 },
        open_message="open-thread-\{building.id}",
      ),
    )
  }
  links
}

///|
fn demo_communications(
  projection : MiniTownProjection,
) -> Array[@bunnia.Communication] {
  [
    @bunnia.message_event(
      id="comm-town-loaded",
      thread_id="thread-policy-hall",
      from_actor_id="system",
      text="Mock town snapshot loaded for the active user.",
    ),
    @bunnia.message_event(
      id="comm-building-query",
      thread_id="thread-policy-hall",
      from_actor_id=selected_agent(projection).id,
      text="Building query produced a mock answer.",
      artifact_ref="artifact://book-policy-hall",
    ),
    @bunnia.review_request(
      id="comm-memory-review",
      thread_id="thread-policy-hall",
      from_actor_id=selected_agent(projection).id,
      to_actor_id=projection.active_user_id,
      text="Accept this answer into building book memory.",
      artifact_ref="artifact://book-policy-hall",
    ),
  ]
}

///|
fn demo_scene_assets() -> Array[@bunnia.SceneAsset] {
  [
    @bunnia.image_asset(
      "moontown-wenyu-map",
      moontown_map_asset_src(),
      moontown_map_asset_bytes(),
    ),
    @bunnia.sprite_asset(
      "moontown-building", "/assets/moontown-building.png", 4096,
    ),
  ]
}

///|
fn demo_initial_data_json_for_tab(tab_id : String) -> String {
  "{\"backendBaseUrl\":\"\{local_backend_base_url()}\",\"bunniaSessionId\":\"\",\"backendStatus\":{},\"login\":{\"userId\":\"user-a\"},\"profileDraft\":{\"displayName\":\"Ada Builder\",\"roleId\":\"builder\",\"consentAccepted\":false},\"ownershipQuery\":{\"includeAlerts\":true},\"discoverSearch\":{\"query\":\"agent\"},\"discover\":{\"filter\":\"all\"},\"messages\":{\"channel\":\"all\"},\"ownership\":{\"filter\":\"all\"},\"buildingDraft\":{\"id\":\"created-agent-lab\",\"title\":\"Created Agent Lab\",\"tags\":[\"agent\",\"local\"]},\"placementDraft\":{\"buildingId\":\"published-agent-lab\",\"x\":538,\"y\":528},\"shareDraft\":{\"buildingId\":\"created-agent-lab\",\"targetUserId\":\"user-b\"},\"submitDraft\":{\"buildingId\":\"created-agent-lab\"},\"publishDraft\":{\"buildingId\":\"created-agent-lab\"},\"archiveDraft\":{\"buildingId\":\"created-agent-lab\"},\"restoreDraft\":{\"buildingId\":\"created-agent-lab\"},\"buildingQuestion\":{\"buildingId\":\"policy-hall\",\"body\":\"What can this building do?\"},\"chatDraft\":{\"buildingId\":\"policy-hall\",\"body\":\"Can this building help publish an agent?\"},\"handoffDraft\":{\"buildingId\":\"policy-hall\",\"fromAgentId\":\"agent-policy-guide\",\"toAgentId\":\"agent-builder\",\"summary\":\"Move follow-up planning into the builder queue.\"},\"toolResultAck\":{\"toolResultId\":\"tool-policy-summary\",\"buildingId\":\"policy-hall\"},\"reviewDecision\":{\"reviewId\":\"review-policy-memory\",\"runId\":\"run-policy-review\",\"decision\":\"accept\"},\"notificationAck\":{\"noticeId\":\"notice-review\",\"noticeKind\":\"review\",\"targetRef\":\"thread-policy-hall\"},\"subscriptionRequest\":{\"noticeId\":\"notice-subscribe\",\"noticeKind\":\"subscription\",\"targetRef\":\"subscription:wechat\"},\"reportDraft\":{\"buildingId\":\"policy-hall\",\"reason\":\"Safety review request\"},\"moderationHide\":{\"caseId\":\"mod-policy-hall\",\"buildingId\":\"policy-hall\"},\"moderationTakedown\":{\"caseId\":\"mod-policy-hall\",\"buildingId\":\"policy-hall\"},\"agentDraft\":{\"id\":\"agent-created\",\"displayName\":\"Created Agent\",\"buildingId\":\"private-agent-lab\"},\"mapViewport\":{\"x\":-520,\"y\":-260,\"scale\":2.6,\"style\":\"transform:translate(-520px,-260px) scale(2.6)\"},\"shell\":{\"activeTab\":\"\{tab_id}\",\"onboardingCompleted\":\"false\"},\"profile\":{\"roleId\":\"builder\",\"consentAccepted\":\"false\",\"setupCompleted\":\"false\"},\"session\":{\"activeUserId\":\"user-a\"},\"town\":{\"selectedBuildingId\":\"policy-hall\",\"lastSharedBuildingId\":\"\",\"lastPublishedBuildingId\":\"\",\"lastArchivedBuildingId\":\"\",\"buildings\":[{\"id\":\"policy-hall\",\"visibility\":\"published\"},{\"id\":\"private-agent-lab\",\"visibility\":\"private_draft\"},{\"id\":\"team-studio\",\"visibility\":\"shared_private\"}],\"placements\":[{\"id\":\"placement-user-a-policy-hall\",\"buildingId\":\"policy-hall\",\"layer\":\"personal\",\"status\":\"pinned\"}]},\"chat\":{\"messages\":[]},\"agents\":{\"items\":[]},\"runs\":{\"activeRunStatus\":\"idle\"},\"reviews\":{\"memoryReview\":\"pending\"},\"books\":{\"policyHall\":{\"status\":\"review\"}},\"moderation\":{\"lastReport\":\"\",\"lastAction\":\"\"},\"lifecycle\":{\"lastAction\":\"\"}}"
}
