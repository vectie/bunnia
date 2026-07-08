///|
pub fn demo_view() -> @bunnia.Node {
  mini_town_view(demo_projection())
}

///|
pub fn mini_town_view(projection : MiniTownProjection) -> @bunnia.Node {
  @bunnia.page([
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("moontown-miniapp"),
        @bunnia.data("active-user", projection.active_user_id),
      ],
      [
        town_map_surface(projection),
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
  let page = @bunnia.wechat_project_page(
    name="Moontown Miniapp",
    route="pages/moontown/index",
    root=demo_view(),
    runtime=demo_runtime(),
    render_budget~,
  )
  let styled_page = @bunnia.wechat_project_page_with_wxss(page, moontown_wxss())
  @bunnia.generate_wechat_project_from_pages_with_backend(
    name="Moontown Miniapp",
    pages=[styled_page],
    backend_contract=demo_backend_contract(),
  )
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
  ".moontown-onboarding-step, .moontown-role-entry, .moontown-district-entry, .moontown-presence-chip, .moontown-discover-entry, .moontown-notice-entry, .moontown-owned-entry, .moontown-book-entry, .moontown-run-entry, .moontown-review-entry, .moontown-audit-entry { margin-top: 8rpx; padding: 10rpx; border: 1rpx solid rgba(51,65,55,0.16); border-radius: 6rpx; background: rgba(255,255,255,0.62); }\n" +
  ".moontown-discover-entry.bunnia-status-review { border-color: rgba(214,158,46,0.58); background: rgba(255,244,207,0.78); }\n" +
  ".moontown-discover-entry.bunnia-status-stable { border-color: rgba(72,187,120,0.48); }\n" +
  ".moontown-onboarding-step text, .moontown-role-entry text, .moontown-district-entry text, .moontown-presence-chip text, .moontown-discover-entry text, .moontown-notice-entry text, .moontown-owned-entry text, .moontown-book-entry text, .moontown-run-entry text, .moontown-review-entry text, .moontown-audit-entry text { display: block; color: #405244; font-size: 18rpx; }\n" +
  ".moontown-profile-status { margin: 8rpx 0; padding: 8rpx 10rpx; border-radius: 6rpx; background: rgba(37,55,43,0.12); color: #334538; font-size: 18rpx; }\n" +
  ".moontown-entry-title { color: #1f3327 !important; font-size: 20rpx !important; font-weight: 800; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }\n" +
  ".moontown-entry-meta { margin-top: 2rpx; color: #6b745f !important; font-size: 16rpx !important; }\n" +
  ".moontown-community-actions { display: flex; gap: 8rpx; margin-top: 8rpx; flex-wrap: wrap; }\n" +
  ".moontown-presence-row .bunnia-list-windowed { display: flex; flex-direction: row; gap: 8rpx; overflow: hidden; }\n" +
  ".moontown-presence-chip { flex: 0 0 136rpx; min-width: 0; }\n" +
  ".moontown-discovery-filters .bunnia-list-windowed, .moontown-message-channels .bunnia-list-windowed, .moontown-ownership-filters .bunnia-list-windowed, .moontown-lifecycle-actions { display: flex; flex-direction: row; gap: 8rpx; overflow: hidden; margin-top: 8rpx; }\n" +
  ".moontown-discovery-filter, .moontown-message-channel, .moontown-ownership-filter { flex: 0 0 auto; padding: 8rpx 10rpx; border: 1rpx solid rgba(51,65,55,0.18); border-radius: 6rpx; background: rgba(255,255,255,0.58); color: #334538; font-size: 18rpx; }\n" +
  ".moontown-discovery-filter.active, .moontown-message-channel.active, .moontown-ownership-filter.active { background: #203729; color: #fff8dc; }\n" +
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
  let projection = demo_projection()
  let patches : Array[@bunnia.WechatEventPatch] = []
  patches.push(@bunnia.wechat_event_patch("dev-login", []))
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
        "town.placements", "{\"id\":\"placement-published-agent-lab\",\"buildingId\":\"published-agent-lab\"}",
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
  @bunnia.wechat_runtime(
    initial_data_json=demo_initial_data_json(),
    event_patches=patches,
    page_methods_js=moontown_map_page_methods_js(),
  )
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
        "publish-private-building", "/miniapp/buildings/publish", "publishDraft",
        "publishResult",
      ),
      @bunnia.operator_submit_endpoint(
        "archive-private-building", "/miniapp/buildings/archive", "archiveDraft",
        "archiveResult",
      ),
      @bunnia.agent_message_endpoint(
        "ask-selected-building", "/miniapp/buildings/query", "buildingQuestion",
        "queryResult",
      ),
      @bunnia.review_decision_endpoint(
        "accept-memory-review", "/miniapp/reviews/accept", "reviewDecision", "reviewResult",
      ),
      @bunnia.review_decision_endpoint(
        "reject-memory-review", "/miniapp/reviews/reject", "reviewDecision", "reviewResult",
      ),
      @bunnia.operator_submit_endpoint(
        "create-agent", "/miniapp/agents", "agentDraft", "agentResult",
      ),
    ],
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
    review_queue_panel(projection),
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
      review_queue_panel(projection),
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
    @bunnia.button("Enter Realm", "complete-onboarding"),
  ])
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
      ],
      events=[@bunnia.event("tap", "select-\{district.building_id}")],
      children=[
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-title")], [
          @bunnia.text(district.title),
        ]),
        @bunnia.text(district.summary),
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-meta")], [
          @bunnia.text(
            "\{district.stat_value} \{district.stat_label} / \{district.action_label}",
          ),
        ]),
      ],
    ),
  )
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
      ],
      events=[@bunnia.event("tap", "select-\{item.building_id}")],
      children=[
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-title")], [
          @bunnia.text(item.title),
        ]),
        @bunnia.text(item.summary),
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-meta")], [
          @bunnia.text("\{item.kind} / \{item.status}"),
        ]),
      ],
    ),
  )
}

///|
fn discover_panel(projection : MiniTownProjection) -> @bunnia.Node {
  let results = filtered_discovery_results(projection)
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-shell-panel")], [
    @bunnia.view_with_attrs(
      [@bunnia.class_name("moontown-shell-panel-title")],
      [@bunnia.text("Discover")],
    ),
    @bunnia.view_with_attrs([@bunnia.class_name("moontown-shell-panel-note")], [
      @bunnia.text(
        "Search buildings, users, agents, books, events, demands, and posts.",
      ),
    ]),
    @bunnia.input(
      name="discoverSearch",
      value=projection.search_query,
      input_message="discover-search",
    ),
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
    @bunnia.windowed_list(
      results,
      total_count=results.length(),
      render=discover_entry,
    ),
  ])
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
fn discover_entry(item : MiniTownDiscoveryItem) -> @bunnia.Node {
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
        discover_entry_action(item),
      ],
    ),
  )
}

///|
fn discover_entry_action(item : MiniTownDiscoveryItem) -> @bunnia.Node {
  if item.kind == "building" && item.visibility == "published" {
    @bunnia.view_with_attrs([@bunnia.class_name("moontown-discovery-action")], [
      @bunnia.button("Place On Map", "place-published-building"),
    ])
  } else {
    @bunnia.view([])
  }
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
    @bunnia.windowed_list(runs, total_count=runs.length(), render=run_entry),
  ])
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
fn review_queue_panel(projection : MiniTownProjection) -> @bunnia.Node {
  let reviews = pending_reviews(projection)
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-shell-panel")], [
    @bunnia.view_with_attrs(
      [@bunnia.class_name("moontown-shell-panel-title")],
      [@bunnia.text("Review Queue")],
    ),
    @bunnia.view_with_attrs([@bunnia.class_name("moontown-shell-panel-note")], [
      @bunnia.text(
        "Accepted agent output becomes book memory; rejected output returns to the run.",
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
          @bunnia.text("\{item.status} / +\{item.accepted_memory_delta} memory"),
        ]),
        @bunnia.review_controls(
          @bunnia.review_action(
            id=item.id,
            label="Memory review",
            approve_message=item.accept_message,
            reject_message=item.reject_message,
          ),
        ),
      ],
    ),
  )
}

///|
fn lifecycle_panel(projection : MiniTownProjection) -> @bunnia.Node {
  lifecycle_panel_with_events(
    "Lifecycle",
    "Building actions stay auditable.",
    selected_building_audit_events(projection),
  )
}

///|
fn ownership_lifecycle_panel(projection : MiniTownProjection) -> @bunnia.Node {
  lifecycle_panel_with_events(
    "My Lifecycle",
    "Owned drafts, shares, publishing, placements, and archives stay visible here.",
    owned_audit_events(projection),
  )
}

///|
fn lifecycle_panel_with_events(
  title : String,
  note : String,
  events : Array[MiniTownAuditEvent],
) -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-shell-panel")], [
    @bunnia.view_with_attrs(
      [@bunnia.class_name("moontown-shell-panel-title")],
      [@bunnia.text(title)],
    ),
    @bunnia.view_with_attrs([@bunnia.class_name("moontown-shell-panel-note")], [
      @bunnia.text(note),
    ]),
    @bunnia.windowed_list(
      events,
      total_count=events.length(),
      render=audit_entry,
    ),
  ])
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
        @bunnia.button(notice.action_label, notice.action_message),
      ],
    ),
  )
}

///|
fn profile_panel(projection : MiniTownProjection) -> @bunnia.Node {
  let stats = ownership_stats(projection)
  let items = filtered_ownership_items(projection)
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
    @bunnia.windowed_list(
      stats,
      total_count=stats.length(),
      render=ownership_stat_entry,
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
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("moontown-owned-entry"),
        @bunnia.data("ownership-kind", item.kind),
        @bunnia.data("target-ref", item.target_ref),
        @bunnia.data("visibility", item.visibility),
        @bunnia.data("status", item.status),
      ],
      [
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-title")], [
          @bunnia.text(item.title),
        ]),
        @bunnia.text(item.summary),
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-meta")], [
          @bunnia.text(
            "\{item.kind} / \{item.visibility} / \{item.action_label}",
          ),
        ]),
      ],
    ),
  )
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
      building_book_entry(book),
      @bunnia.windowed_list(runs, total_count=runs.length(), render=run_entry),
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-lifecycle-actions")],
        [@bunnia.list(actions, lifecycle_action_button)],
      ),
    ],
  )
}

///|
fn lifecycle_action_button(action : MiniTownLifecycleAction) -> @bunnia.Node {
  @bunnia.keyed(
    "lifecycle-action-\{action.id}",
    @bunnia.node(
      kind="button",
      attrs=[
        @bunnia.class_name("moontown-lifecycle-action \{action.status}"),
        @bunnia.data("lifecycle-action", action.id),
      ],
      events=[@bunnia.event("tap", action.message)],
      children=[@bunnia.text(action.label)],
    ),
  )
}

///|
fn building_book_entry(book : MiniTownBook) -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-book-entry bunnia-status-\{book.status}"),
      @bunnia.data("book-id", book.id),
      @bunnia.data("building-id", book.building_id),
      @bunnia.data("target-ref", "book:\{book.id}"),
      @bunnia.data("visibility", book.visibility),
    ],
    [
      @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-title")], [
        @bunnia.text(book.title),
      ]),
      @bunnia.text(book.summary),
      @bunnia.view_with_attrs([@bunnia.class_name("moontown-entry-meta")], [
        @bunnia.text(
          "\{book.accepted_memory_count} memories / \{book.pending_review_count} reviews / \{book.status}",
        ),
      ]),
    ],
  )
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
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-chat-drawer")], [
    @bunnia.text("Agent: \{agent.name}"),
    @bunnia.windowed_message_feed(
      bunnia_messages(projection.messages),
      total_count=projection.messages.length(),
    ),
  ])
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
fn demo_initial_data_json() -> String {
  "{\"backendBaseUrl\":\"\",\"bunniaSessionId\":\"\",\"login\":{\"userId\":\"user-a\"},\"profileDraft\":{\"displayName\":\"Ada Builder\",\"roleId\":\"builder\",\"consentAccepted\":false},\"discoverSearch\":{\"query\":\"agent\"},\"discover\":{\"filter\":\"all\"},\"messages\":{\"channel\":\"all\"},\"ownership\":{\"filter\":\"all\"},\"buildingDraft\":{\"id\":\"created-agent-lab\",\"title\":\"Created Agent Lab\",\"tags\":[\"agent\",\"local\"]},\"placementDraft\":{\"buildingId\":\"policy-hall\",\"x\":42,\"y\":24},\"shareDraft\":{\"buildingId\":\"created-agent-lab\",\"targetUserId\":\"user-b\"},\"publishDraft\":{\"buildingId\":\"created-agent-lab\"},\"archiveDraft\":{\"buildingId\":\"created-agent-lab\"},\"buildingQuestion\":{\"buildingId\":\"policy-hall\",\"body\":\"What can this building do?\"},\"reviewDecision\":{\"reviewId\":\"review-policy-memory\",\"runId\":\"run-policy-review\",\"decision\":\"accept\"},\"agentDraft\":{\"id\":\"agent-created\",\"displayName\":\"Created Agent\",\"buildingId\":\"private-lab\"},\"mapViewport\":{\"x\":-520,\"y\":-260,\"scale\":2.6,\"style\":\"transform:translate(-520px,-260px) scale(2.6)\"},\"shell\":{\"activeTab\":\"realm\",\"onboardingCompleted\":\"false\"},\"profile\":{\"roleId\":\"builder\",\"consentAccepted\":\"false\",\"setupCompleted\":\"false\"},\"session\":{\"activeUserId\":\"user-a\"},\"town\":{\"selectedBuildingId\":\"policy-hall\",\"lastSharedBuildingId\":\"\",\"lastPublishedBuildingId\":\"\",\"lastArchivedBuildingId\":\"\",\"buildings\":[{\"id\":\"policy-hall\",\"visibility\":\"published\"},{\"id\":\"private-agent-lab\",\"visibility\":\"private_draft\"},{\"id\":\"team-studio\",\"visibility\":\"shared_private\"}],\"placements\":[]},\"chat\":{\"messages\":[]},\"agents\":{\"items\":[]},\"runs\":{\"activeRunStatus\":\"idle\"},\"reviews\":{\"memoryReview\":\"pending\"},\"books\":{\"policyHall\":{\"status\":\"review\"}},\"lifecycle\":{\"lastAction\":\"\"}}"
}
