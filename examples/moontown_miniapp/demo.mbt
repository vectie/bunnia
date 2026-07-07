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
        town_right_hud(projection),
        town_bottom_hud(projection),
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
  ".moontown-user-switcher button, .moontown-building-drawer button, .moontown-search-drawer button, .moontown-create-drawer button, .moontown-chat-drawer button { min-height: 46rpx; margin: 0; padding: 0 14rpx; border: 1rpx solid rgba(51, 65, 55, 0.28); border-radius: 6rpx; background: #fff8dc; color: #243629; font-size: 20rpx; line-height: 46rpx; }\n" +
  ".moontown-right-hud { position: absolute; z-index: 7; right: 22rpx; top: 126rpx; width: 300rpx; display: flex; flex-direction: column; gap: 12rpx; }\n" +
  ".moontown-building-drawer, .moontown-chat-drawer, .moontown-search-drawer, .moontown-create-drawer { padding: 14rpx; border: 1rpx solid rgba(255,255,255,0.52); border-radius: 8rpx; background: rgba(252, 249, 226, 0.88); box-shadow: 0 10rpx 28rpx rgba(35, 47, 38, 0.16); box-sizing: border-box; }\n" +
  ".moontown-building-drawer text:first-child, .moontown-chat-drawer > text:first-child { display: block; margin-bottom: 6rpx; color: #1f3327; font-size: 26rpx; font-weight: 800; }\n" +
  ".moontown-building-drawer text, .moontown-chat-drawer text, .moontown-search-drawer text, .moontown-create-drawer text { display: block; color: #405244; font-size: 20rpx; }\n" +
  ".moontown-building-drawer button { margin-top: 8rpx; margin-right: 6rpx; }\n" +
  ".moontown-chat-drawer .bunnia-message-feed-windowed { max-height: 170rpx; overflow: hidden; }\n" +
  ".moontown-chat-drawer .bunnia-message { padding: 10rpx 12rpx; margin-bottom: 8rpx; background: rgba(255,255,255,0.78); font-size: 20rpx; }\n" +
  ".moontown-chat-drawer .bunnia-review { margin-top: 8rpx; padding: 10rpx; gap: 8rpx; background: rgba(255,255,255,0.68); }\n" +
  ".moontown-bottom-hud { position: absolute; z-index: 7; left: 22rpx; right: 22rpx; bottom: 22rpx; display: grid; grid-template-columns: 1fr 220rpx 220rpx; gap: 12rpx; align-items: end; }\n" +
  ".moontown-visibility-strip { min-width: 0; padding: 12rpx; border: 1rpx solid rgba(255,255,255,0.42); border-radius: 8rpx; background: rgba(37, 55, 43, 0.72); box-shadow: 0 10rpx 24rpx rgba(26, 39, 31, 0.18); }\n" +
  ".moontown-visibility-strip .bunnia-list-windowed { display: flex; flex-direction: row; gap: 8rpx; overflow: hidden; }\n" +
  ".moontown-visibility-chip { flex: 0 0 auto; max-width: 180rpx; padding: 8rpx 10rpx; border: 1rpx solid rgba(255,255,255,0.32); border-radius: 6rpx; background: rgba(255, 248, 220, 0.92); color: #27372b; font-size: 18rpx; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }\n" +
  ".moontown-search-drawer input, .moontown-create-drawer input { min-height: 46rpx; margin-bottom: 8rpx; padding: 0 10rpx; border: 1rpx solid rgba(51, 65, 55, 0.22); border-radius: 6rpx; background: rgba(255,255,255,0.82); color: #26362b; font-size: 20rpx; box-sizing: border-box; }\n" +
  ".moontown-search-result { padding: 8rpx 0; border-top: 1rpx solid rgba(52, 65, 55, 0.16); }\n" +
  ".moontown-create-drawer form { display: block; margin-bottom: 8rpx; }\n" +
  ".moontown-create-drawer form:last-child { margin-bottom: 0; }\n" +
  "@media (max-width: 520px) { .moontown-right-hud { top: 128rpx; right: 16rpx; width: 276rpx; } .moontown-bottom-hud { grid-template-columns: 1fr; } .moontown-search-drawer, .moontown-create-drawer { display: none; } }"
}

///|
pub fn demo_runtime() -> @bunnia.WechatRuntime {
  let projection = demo_projection()
  let patches : Array[@bunnia.WechatEventPatch] = []
  patches.push(@bunnia.wechat_event_patch("dev-login", []))
  patches.push(@bunnia.wechat_event_patch("load-town-snapshot", []))
  for building in visible_buildings(projection) {
    patches.push(select_building_patch(building))
    patches.push(open_building_thread_patch(building))
  }
  patches.push(
    @bunnia.wechat_event_patch("search-buildings", [
      @bunnia.set_string("town.searchQuery", "policy"),
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
    @bunnia.wechat_event_patch("create-private-building", [
      @bunnia.append_json(
        "town.buildings", "{\"id\":\"created-agent-lab\",\"visibility\":\"private_draft\",\"ownerId\":\"user-a\"}",
      ),
      @bunnia.set_string("town.selectedBuildingId", "created-agent-lab"),
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
      @bunnia.select_scene_marker("moontown-map", "published-agent-lab"),
    ]),
  )
  patches.push(
    @bunnia.wechat_event_patch("publish-private-building", [
      @bunnia.set_string("town.lastPublishedBuildingId", "created-agent-lab"),
    ]),
  )
  patches.push(
    @bunnia.wechat_event_patch("share-private-building", [
      @bunnia.set_string("town.lastSharedBuildingId", "created-agent-lab"),
    ]),
  )
  patches.push(
    @bunnia.wechat_event_patch("archive-private-building", [
      @bunnia.set_string("town.lastArchivedBuildingId", "created-agent-lab"),
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
  "      const rows=this.__er||(this.__er=[[0,276,279],[40,208,350],[80,128,430],[120,48,510],[160,0,590],[200,0,670],[240,0,750],[280,0,830],[320,0,910],[360,0,990],[400,0,1070],[440,0,1150],[480,0,1230],[520,78,1310],[560,158,1354],[600,238,1274],[640,319,1194],[680,398,1114],[720,478,1034],[760,559,954],[800,639,874],[840,720,794],[858,756,758]])\n" +
  "      const edge=(yy,i)=>{\n" +
  "        if(yy<=rows[0][0])return rows[0][i]\n" +
  "        for(let n=1;n<rows.length;n+=1){\n" +
  "          const a=rows[n-1]\n" +
  "          const b=rows[n]\n" +
  "          if(yy<=b[0])return a[i]+(b[i]-a[i])*(yy-a[0])/(b[0]-a[0])\n" +
  "        }\n" +
  "        return rows[rows.length-1][i]\n" +
  "      }\n" +
  "      const xRange=(sy)=>{\n" +
  "        const top=sy\n" +
  "        const bottom=sy+vh\n" +
  "        let left=Math.max(edge(top,1),edge(bottom,1))\n" +
  "        let right=Math.min(edge(top,2),edge(bottom,2))\n" +
  "        for(const row of rows)if(row[0]>top&&row[0]<bottom){left=Math.max(left,row[1]);right=Math.min(right,row[2])}\n" +
  "        return [left,right-vw]\n" +
  "      }\n" +
  "      const key=[Math.round(vw),Math.round(vh)].join(':')\n" +
  "      const cache=this.__myc||(this.__myc={})\n" +
  "      let yRange=cache[key]\n" +
  "      if(!yRange){\n" +
  "        const end=rows[rows.length-1][0]-vh\n" +
  "        let first=null\n" +
  "        let last=null\n" +
  "        for(let sy=0;sy<=end;sy+=4){\n" +
  "          const xr=xRange(sy)\n" +
  "          if(xr[1]>=xr[0]){first=first==null?sy:first;last=sy}\n" +
  "        }\n" +
  "        const fallback=Math.max(0,end/2)\n" +
  "        yRange=cache[key]=[first==null?fallback:first,last==null?fallback:last]\n" +
  "      }\n" +
  "      const sy=this.__cl(-Number(rawY||0)/k,yRange[0],yRange[1])\n" +
  "      const xr=xRange(sy)\n" +
  "      const sx=this.__cl(-Number(rawX||0)/k,xr[0],xr[1])\n" +
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
      @bunnia.generic_endpoint(
        "search-buildings",
        "/miniapp/buildings/search",
        @bunnia.http_get(),
        payload_key="buildingSearch",
        response_key="buildingSearchResult",
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
  856 * 1024
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
    chat_drawer(projection),
  ])
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
      @bunnia.button("Ask", "ask-selected-building"),
      @bunnia.button("Place", "place-published-building"),
      @bunnia.button("Share", "share-private-building"),
      @bunnia.button("Publish", "publish-private-building"),
      @bunnia.button("Archive", "archive-private-building"),
    ],
  )
}

///|
fn search_drawer(projection : MiniTownProjection) -> @bunnia.Node {
  let results = search_results(projection)
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-search-drawer")], [
    @bunnia.input(
      name="buildingSearch",
      value=projection.search_query,
      input_message="search-buildings",
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
    @bunnia.review_controls(
      @bunnia.review_action(
        id="accept-book-memory",
        label="Accept memory",
        approve_message="ask-selected-building",
        reject_message="create-agent",
      ),
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
  "{\"backendBaseUrl\":\"\",\"bunniaSessionId\":\"\",\"login\":{\"userId\":\"user-a\"},\"buildingSearch\":{\"query\":\"policy\"},\"buildingDraft\":{\"id\":\"created-agent-lab\",\"title\":\"Created Agent Lab\",\"tags\":[\"agent\",\"local\"]},\"placementDraft\":{\"buildingId\":\"policy-hall\",\"x\":42,\"y\":24},\"shareDraft\":{\"buildingId\":\"created-agent-lab\",\"targetUserId\":\"user-b\"},\"publishDraft\":{\"buildingId\":\"created-agent-lab\"},\"archiveDraft\":{\"buildingId\":\"created-agent-lab\"},\"buildingQuestion\":{\"buildingId\":\"policy-hall\",\"body\":\"What can this building do?\"},\"agentDraft\":{\"id\":\"agent-created\",\"displayName\":\"Created Agent\",\"buildingId\":\"private-lab\"},\"mapViewport\":{\"x\":-520,\"y\":-260,\"scale\":2.6,\"style\":\"transform:translate(-520px,-260px) scale(2.6)\"},\"session\":{\"activeUserId\":\"user-a\"},\"town\":{\"selectedBuildingId\":\"policy-hall\",\"lastSharedBuildingId\":\"\",\"lastPublishedBuildingId\":\"\",\"lastArchivedBuildingId\":\"\",\"buildings\":[{\"id\":\"policy-hall\",\"visibility\":\"published\"},{\"id\":\"private-agent-lab\",\"visibility\":\"private_draft\"},{\"id\":\"team-studio\",\"visibility\":\"shared_private\"}],\"placements\":[]},\"chat\":{\"messages\":[]},\"agents\":{\"items\":[]},\"runs\":{\"activeRunStatus\":\"idle\"}}"
}
