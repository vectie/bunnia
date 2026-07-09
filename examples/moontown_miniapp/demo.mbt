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
  for tab_id in ["realm", "home", "discover", "messages", "my", "reviewer"] {
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
    root=moontown_project_tab_root(tab_id),
    runtime=demo_runtime_for_tab(tab_id),
    render_budget~,
  )
  scoped_project_page_runtime(
    @bunnia.wechat_project_page_with_wxss(page, moontown_wxss_for_tab(tab_id)),
  )
}

///|
fn moontown_project_tab_root(tab_id : String) -> @bunnia.Node {
  if tab_id == "reviewer" {
    reviewer_route_view(
      open_reviewer_tools(switch_tab(demo_projection(), "my")),
    )
  } else {
    mini_town_route_view(switch_tab(demo_projection(), tab_id))
  }
}

///|
fn reviewer_route_view(projection : MiniTownProjection) -> @bunnia.Node {
  @bunnia.page([
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("moontown-miniapp"),
        @bunnia.data("reviewer-route", "true"),
      ],
      [
        @bunnia.view_with_attrs(
          [
            @bunnia.class_name("moontown-page-surface"),
            @bunnia.data("active-tab", "reviewer"),
          ],
          [operations_desk_panel(projection), reviewer_tools_back_button()],
        ),
      ],
    ),
  ])
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
  } else if tab_id == "reviewer" {
    "Moontown Reviewer"
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
  } else if tab_id == "reviewer" {
    "pages/moontown/reviewer"
  } else {
    "pages/moontown/index"
  }
}

///|
pub fn demo_runtime() -> @bunnia.WechatRuntime {
  demo_runtime_for_tab("realm")
}

///|
fn demo_runtime_for_tab(tab_id : String) -> @bunnia.WechatRuntime {
  if tab_id == "reviewer" {
    return reviewer_runtime()
  }
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
    patches.push(open_place_patch(building))
    patches.push(open_building_thread_patch(building))
  }
  patches.push(
    @bunnia.wechat_event_patch("discover-search", [
      @bunnia.set_string("discover.query", "agent"),
      @bunnia.set_json("discoverSearch", "{\"query\":\"agent\",\"cursor\":0}"),
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
      @bunnia.select_scene_marker("moontown-map", "published-agent-lab"),
    ]),
  )
  patches.push(@bunnia.wechat_event_patch("update-private-building", []))
  patches.push(
    @bunnia.wechat_event_patch("open-reviewer-tools", [
      @bunnia.set_string("reviewer.mode", "open"),
    ]),
  )
  patches.push(@bunnia.wechat_event_patch("publish-private-building", []))
  patches.push(@bunnia.wechat_event_patch("share-private-building", []))
  patches.push(@bunnia.wechat_event_patch("archive-private-building", []))
  patches.push(
    @bunnia.wechat_event_patch("create-agent", [
      @bunnia.append_json(
        "agents.items", "{\"id\":\"agent-created\",\"buildingId\":\"private-agent-lab\",\"status\":\"idle\"}",
      ),
    ]),
  )
  patches.push(@bunnia.wechat_event_patch("report-public-building", []))
  patches.push(@bunnia.wechat_event_patch("hide-public-building", []))
  patches.push(@bunnia.wechat_event_patch("takedown-public-building", []))
  @bunnia.wechat_runtime(
    initial_data_json=demo_initial_data_json_for_tab(tab_id),
    event_patches=patches,
    page_methods_js=moontown_map_page_methods_js(),
  )
}

///|
fn reviewer_runtime() -> @bunnia.WechatRuntime {
  @bunnia.wechat_runtime(initial_data_json=reviewer_initial_data_json(), event_patches=[
    @bunnia.wechat_event_patch("load-admin-ops", []),
    @bunnia.wechat_event_patch("load-admin-readiness", []),
    @bunnia.wechat_event_patch("tab-my", [
      @bunnia.set_string("shell.activeTab", "my"),
    ]),
  ])
}

///|
fn reviewer_initial_data_json() -> String {
  "{\"backendBaseUrl\":\"\{local_backend_base_url()}\",\"bunniaSessionId\":\"\",\"backendStatus\":{},\"adminOpsQuery\":{},\"adminReadinessQuery\":{},\"reviewer\":{\"mode\":\"open\"},\"shell\":{\"activeTab\":\"reviewer\"}}"
}

///|
fn add_setup_event_patches(
  patches : Array[@bunnia.WechatEventPatch],
  projection : MiniTownProjection,
) -> Unit {
  patches.push(
    @bunnia.wechat_event_patch("enter-town", [
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
    let patch : Array[@bunnia.Patch] = []
    if discover_filter_updates_backend(filter.id) {
      patch.push(
        @bunnia.set_json(
          "discoverSearch",
          discover_search_filter_json(filter, projection.search_query),
        ),
      )
    }
    patches.push(
      @bunnia.wechat_event_patch("discover-filter-\{filter.id}", patch),
    )
  }
}

///|
fn add_notification_channel_event_patches(
  patches : Array[@bunnia.WechatEventPatch],
  projection : MiniTownProjection,
) -> Unit {
  for channel in projection.notification_channels {
    let patch : Array[@bunnia.Patch] = []
    if notification_channel_updates_backend(channel.id) {
      patch.push(
        @bunnia.set_json(
          "messageCenterQuery",
          message_center_query_json(channel),
        ),
      )
    }
    patches.push(
      @bunnia.wechat_event_patch("notification-channel-\{channel.id}", patch),
    )
  }
}

///|
fn add_ownership_filter_event_patches(
  patches : Array[@bunnia.WechatEventPatch],
  projection : MiniTownProjection,
) -> Unit {
  for filter in projection.ownership_filters {
    let patch : Array[@bunnia.Patch] = []
    if ownership_filter_updates_backend(filter.id) {
      patch.push(
        @bunnia.set_json("ownershipQuery", ownership_query_json(filter)),
      )
    }
    patches.push(
      @bunnia.wechat_event_patch("ownership-filter-\{filter.id}", patch),
    )
  }
}

///|
fn discover_filter_updates_backend(id : String) -> Bool {
  id == "product" || id == "placeable"
}

///|
fn notification_channel_updates_backend(id : String) -> Bool {
  id == "unread" || id == "agent" || id == "review"
}

///|
fn ownership_filter_updates_backend(id : String) -> Bool {
  id == "drafts" || id == "placements" || id == "books"
}

///|
fn bool_json(value : Bool) -> String {
  if value {
    "true"
  } else {
    "false"
  }
}

///|
fn discover_search_filter_json(
  filter : MiniTownDiscoveryFilter,
  query : String,
) -> String {
  "{\"query\":\"\{query}\",\"filter\":\"\{filter.id}\",\"kind\":\"\{filter.kind}\",\"placeableOnly\":\{bool_json(filter.placeable_only)},\"cursor\":0}"
}

///|
fn ownership_query_json(filter : MiniTownOwnershipFilter) -> String {
  "{\"includeAlerts\":true,\"kind\":\"\{filter.kind}\",\"visibility\":\"\{filter.visibility}\",\"cursor\":0}"
}

///|
fn message_center_query_json(channel : MiniTownNotificationChannel) -> String {
  "{\"channel\":\"\{message_center_channel_for(channel)}\",\"limit\":30,\"cursor\":0}"
}

///|
fn message_center_channel_for(channel : MiniTownNotificationChannel) -> String {
  if channel.unread_only {
    "unread"
  } else {
    channel.kind
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
fn open_place_patch(building : MiniTownBuilding) -> @bunnia.WechatEventPatch {
  @bunnia.wechat_event_patch("open-place-\{building.id}", [
    @bunnia.set_string("shell.activeTab", "realm"),
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
        "load-message-center",
        "/miniapp/messages/center",
        @bunnia.http_get(),
        payload_key="messageCenterQuery",
        response_key="messageCenterSnapshot",
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
      @bunnia.generic_endpoint(
        "discover-action",
        "/miniapp/discover/action",
        @bunnia.http_post(),
        payload_key="discoverAction",
        response_key="discoveryActionResult",
      ),
      @bunnia.operator_submit_endpoint(
        "create-private-building", "/miniapp/buildings", "buildingDraft", "buildingResult",
      ),
      @bunnia.generic_endpoint(
        "update-private-building",
        "/miniapp/buildings/update",
        @bunnia.http_post(),
        payload_key="buildingEditDraft",
        response_key="buildingEditResult",
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
      @bunnia.generic_endpoint(
        "appeal-moderation-case",
        "/miniapp/moderation/appeal",
        @bunnia.http_post(),
        payload_key="moderationAppeal",
        response_key="moderationAppealResult",
      ),
      @bunnia.generic_endpoint(
        "load-admin-ops",
        "/miniapp/admin/ops",
        @bunnia.http_get(),
        payload_key="adminOpsQuery",
        response_key="adminOpsResult",
      ),
      @bunnia.generic_endpoint(
        "load-admin-readiness",
        "/miniapp/admin/readiness",
        @bunnia.http_get(),
        payload_key="adminReadinessQuery",
        response_key="adminReadinessResult",
      ),
    ],
  )
}

///|
pub fn demo_backend_budget() -> @bunnia.BackendBudget {
  @bunnia.backend_budget(
    max_endpoints=32,
    max_streaming=4,
    max_review_required=18,
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
  let project = demo_wechat_project_with_render_budget(
    @bunnia.render_budget_for_profile("large"),
  )
  let report = @bunnia.report_wechat_project_with_budget(
    project,
    @bunnia.default_wechat_runtime(),
    @bunnia.wechat_build_budget_for_profile("large"),
  )
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
    @bunnia.list(visible_buildings(projection), fn(building) {
      map_marker(projection, building)
    }),
  ])
}

///|
fn map_marker(
  projection : MiniTownProjection,
  building : MiniTownBuilding,
) -> @bunnia.Node {
  @bunnia.keyed(
    "map-marker-\{building.id}",
    @bunnia.node(
      kind="view",
      attrs=[
        @bunnia.class_name(
          "moontown-map-marker bunnia-status-\{building.status}\{if building.id == projection.selected_building_id { " selected" } else { "" }}",
        ),
        @bunnia.attr(
          "style",
          "left: \{map_display_position(building.x)}rpx; top: \{map_display_position(building.y)}rpx;",
        ),
        @bunnia.data("building-id", building.id),
      ],
      events=[@bunnia.event("tap", "select-\{building.id}")],
      children=[
        @bunnia.node(
          kind="view",
          attrs=[@bunnia.class_name("moontown-thread-pin")],
          events=[@bunnia.event("tap", "open-thread-\{building.id}")],
          children=[@bunnia.text(map_marker_badge_label(building))],
        ),
        @bunnia.view_with_attrs(
          [@bunnia.class_name("moontown-map-marker-title")],
          [@bunnia.text(building.title)],
        ),
        @bunnia.view_with_attrs(
          [@bunnia.class_name("moontown-map-marker-kind")],
          [@bunnia.text(town_kind_label(building.kind))],
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
fn map_marker_badge_label(building : MiniTownBuilding) -> String {
  if building.status == "review" {
    "Review"
  } else if building.status == "running" {
    "Active"
  } else if building.visibility == "shared_private" {
    "Shared"
  } else if building.visibility == "private_draft" {
    "Draft"
  } else {
    "Open"
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
      home_pulse_panel(projection),
      community_hub_panel(projection),
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
  @bunnia.view_with_attrs([@bunnia.class_name("mt-panel")], [
    @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-title")], [
      @bunnia.text("First Visit"),
    ]),
    @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-note")], [
      @bunnia.text(
        "Realm is the map. Home and My hold setup, pulse, and inventory.",
      ),
    ]),
    @bunnia.view_with_attrs([@bunnia.class_name("moontown-profile-status")], [
      @bunnia.text(
        "\{projection.profile.display_name}: \{ready_word(profile_ready_to_publish(projection))}",
      ),
    ]),
    guide_strip(projection),
    @bunnia.button("Enter Realm", "complete-onboarding"),
  ])
}

///|
fn onboarding_panel(projection : MiniTownProjection) -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("mt-panel")], [
    @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-title")], [
      @bunnia.text("First Visit"),
    ]),
    @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-note")], [
      @bunnia.text("Choose what to do first, then enter the tile town."),
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
        @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
          @bunnia.text(step.title),
        ]),
        @bunnia.text(step.summary),
        @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
          @bunnia.text(
            "\{step.action_label} - \{town_status_label(step.status)}",
          ),
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
        @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
          @bunnia.text(step.title),
        ]),
        @bunnia.text(step.body),
      ],
    ),
  )
}

///|
fn community_hub_panel(projection : MiniTownProjection) -> @bunnia.Node {
  let presence = community_presence(projection)
  @bunnia.view_with_attrs([@bunnia.class_name("mt-panel")], [
    @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-title")], [
      @bunnia.text("Community Hub"),
    ]),
    @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-note")], [
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
  @bunnia.view_with_attrs([@bunnia.class_name("mt-panel")], [
    @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-title")], [
      @bunnia.text("Map Districts"),
    ]),
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
          "moontown-district-entry feature-\{district.feature_kind} tone-\{district.accent} bunnia-status-\{district.status}",
        ),
        @bunnia.data("district-id", district.id),
        @bunnia.data("feature-kind", district.feature_kind),
        @bunnia.data("building-id", district.building_id),
        @bunnia.data("district-filter", district.discovery_filter_id),
        @bunnia.data("district-query", district.search_query),
        @bunnia.data("district-accent", district.accent),
        @bunnia.data("action-message", district_action_message(district)),
        @bunnia.data("target-tab", district_target_tab(district)),
      ],
      events=[@bunnia.event("tap", district_action_message(district))],
      children=[
        @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
          @bunnia.text(district.title),
        ]),
        @bunnia.text(district.summary),
        @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
          @bunnia.text(
            "\{district.stat_value} \{district.stat_label} - \{district.action_label} \{town_tab_label(district_target_tab(district))}",
          ),
        ]),
        @bunnia.view_with_attrs(
          [@bunnia.class_name("moontown-district-actions")],
          [
            @bunnia.node(
              kind="button",
              attrs=[
                @bunnia.data("district-id", district.id),
                @bunnia.data("filter-id", district.discovery_filter_id),
                @bunnia.data("query", district.search_query),
              ],
              events=[
                @bunnia.tap("discover-filter-\{district.discovery_filter_id}"),
              ],
              children=[@bunnia.text("Filter")],
            ),
          ],
        ),
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
        @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
          @bunnia.text(item.title),
        ]),
        @bunnia.text(item.subtitle),
      ],
    ),
  )
}

///|
priv struct HomePulseRow {
  id : String
  title : String
  summary : String
  status : String
  action_label : String
  action_message : String
  target_tab : String
}

///|
fn home_pulse_row(
  id~ : String,
  title~ : String,
  summary~ : String,
  status~ : String,
  action_label~ : String,
  action_message~ : String,
  target_tab~ : String,
) -> HomePulseRow {
  { id, title, summary, status, action_label, action_message, target_tab }
}

///|
fn home_pulse_panel(projection : MiniTownProjection) -> @bunnia.Node {
  let activity = town_activity_items(projection)
  let attention = visible_reviews(projection).length() +
    unread_notifications(projection).length()
  let rows = home_pulse_rows(projection, activity)
  @bunnia.view_with_attrs([@bunnia.class_name("mt-panel")], [
    @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-title")], [
      @bunnia.text("Town Pulse"),
    ]),
    @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-note")], [
      @bunnia.text(
        "\{home_changed_places_count(activity)} places changed. \{attention} items need attention.",
      ),
    ]),
    @bunnia.view_with_attrs(
      [@bunnia.class_name("moontown-community-actions")],
      [
        @bunnia.button("Open", "tab-realm"),
        @bunnia.button("Review", "tab-messages"),
        @bunnia.button("More", "tab-discover"),
      ],
    ),
    @bunnia.windowed_list(
      rows,
      total_count=rows.length(),
      render=home_pulse_entry,
    ),
  ])
}

///|
fn home_pulse_rows(
  projection : MiniTownProjection,
  activity : Array[MiniTownActivityItem],
) -> Array[HomePulseRow] {
  let reviews = visible_reviews(projection)
  let unread = unread_notifications(projection)
  let market = market_discovery_results(projection)
  let refresh_count = home_refresh_count(projection)
  [
    home_pulse_row(
      id="changes",
      title="\{home_changed_places_count(activity)} places changed",
      summary=home_activity_summary(activity),
      status="stable",
      action_label="Open",
      action_message="tab-realm",
      target_tab="realm",
    ),
    home_pulse_row(
      id="attention",
      title=if reviews.length() + unread.length() > 0 {
        "Agent needs your decision"
      } else {
        "Messages are quiet"
      },
      summary=home_attention_summary(reviews, unread),
      status=if reviews.length() + unread.length() > 0 {
        "review"
      } else {
        "stable"
      },
      action_label="Review",
      action_message="tab-messages",
      target_tab="messages",
    ),
    home_pulse_row(
      id="market",
      title="Market has new public places",
      summary="\{market.length()} public results are ready to open or place.",
      status="stable",
      action_label="More",
      action_message="tab-discover",
      target_tab="discover",
    ),
    home_pulse_row(
      id="refresh",
      title=if refresh_count > 0 {
        "Some updates need refresh"
      } else {
        "Town is ready"
      },
      summary=if refresh_count > 0 {
        "Needs refresh before the town can show the latest changes."
      } else {
        "Latest map, messages, and inventory are ready."
      },
      status=if refresh_count > 0 { "stale" } else { "stable" },
      action_label=if refresh_count > 0 { "Try again" } else { "Open" },
      action_message=if refresh_count > 0 { "tab-realm" } else { "tab-realm" },
      target_tab="realm",
    ),
  ]
}

///|
fn home_pulse_entry(item : HomePulseRow) -> @bunnia.Node {
  @bunnia.keyed(
    "home-pulse-\{item.id}",
    @bunnia.node(
      kind="view",
      attrs=[
        @bunnia.class_name("moontown-notice-entry bunnia-status-\{item.status}"),
        @bunnia.data("home-pulse", item.id),
        @bunnia.data("action-message", item.action_message),
        @bunnia.data("target-tab", item.target_tab),
      ],
      events=[@bunnia.event("tap", item.action_message)],
      children=[
        @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
          @bunnia.text(item.title),
        ]),
        @bunnia.text(item.summary),
        @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
          @bunnia.text(
            "\{item.action_label} - \{town_tab_label(item.target_tab)}",
          ),
        ]),
      ],
    ),
  )
}

///|
fn home_changed_places_count(activity : Array[MiniTownActivityItem]) -> Int {
  let ids : Array[String] = []
  for item in activity {
    if !home_contains_id(ids, item.building_id) {
      ids.push(item.building_id)
      if ids.length() == 3 {
        return 3
      }
    }
  }
  ids.length()
}

///|
fn home_contains_id(ids : Array[String], id : String) -> Bool {
  for item in ids {
    if item == id {
      return true
    }
  }
  false
}

///|
fn home_activity_summary(activity : Array[MiniTownActivityItem]) -> String {
  if activity.length() > 0 {
    activity[0].title
  } else {
    "Open Realm to see what changed around the map."
  }
}

///|
fn home_attention_summary(
  reviews : Array[MiniTownReviewItem],
  unread : Array[MiniTownNotification],
) -> String {
  if reviews.length() > 0 {
    reviews[0].title
  } else if unread.length() > 0 {
    unread[0].title
  } else {
    "No agent handoff is waiting right now."
  }
}

///|
fn home_refresh_count(projection : MiniTownProjection) -> Int {
  let mut count = 0
  for item in projection.backend_cache_states {
    if item.state.has_prefix("stale") || item.state == "failed" {
      count += 1
    }
  }
  count
}

///|
fn moderation_desk_panel(projection : MiniTownProjection) -> @bunnia.Node {
  let cases = projection.moderation_cases
  @bunnia.view_with_attrs([@bunnia.class_name("mt-panel")], [
    @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-title")], [
      @bunnia.text("Moderation Desk"),
    ]),
    @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-note")], [
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
        @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
          @bunnia.text(item.title),
        ]),
        @bunnia.text(item.summary),
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-run-actions")], [
          moderation_case_action_button(item),
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
fn moderation_case_action_button(item : MiniTownModerationCase) -> @bunnia.Node {
  moderation_button(
    item,
    item.action_label,
    moderation_case_action_id(item),
    item.action_message,
  )
}

///|
fn moderation_case_action_id(item : MiniTownModerationCase) -> String {
  if item.action_message == "appeal-moderation-case" {
    "appeal"
  } else {
    "review"
  }
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
fn reviewer_tools_back_button() -> @bunnia.Node {
  @bunnia.node(
    kind="button",
    attrs=[@bunnia.data("bunnia-route", "pages/moontown/my")],
    events=[@bunnia.tap("tab-my")],
    children=[@bunnia.text("Back to My")],
  )
}

///|
fn operations_desk_panel(projection : MiniTownProjection) -> @bunnia.Node {
  let ops = backend_step_by_id(projection, "admin-ops")
  let readiness = backend_step_by_id(projection, "admin-readiness")
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-credential-plaque"),
      @bunnia.data("ops-desk", "admin"),
      @bunnia.data("diagnostics-mode", "reviewer"),
      @bunnia.data("diagnostics-source", "reviewer-route"),
      @bunnia.data("backend-step", ops.id),
      @bunnia.data("backend-endpoint", ops.endpoint_id),
      @bunnia.data("backend-readiness-endpoint", readiness.endpoint_id),
      @bunnia.data("backend-path", ops.path),
      @bunnia.data("backend-readiness-path", readiness.path),
    ],
    [
      @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
        @bunnia.text("Reviewer Tools"),
      ]),
      @bunnia.text(
        "Reviewer Mode keeps safety, launch, and developer diagnostics behind this deliberate entry.",
      ),
      @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
        @bunnia.text(
          "Source: reviewer route - ordinary town pages stay product-only",
        ),
      ]),
      reviewer_diagnostics_section("Town Safety", ops, [
        "health", "incidents", "holds", "audit retention", "backup", "recovery",
        "rate-limit bucket",
      ]),
      reviewer_diagnostics_section("Launch Checks", readiness, [
        "WeChat login", "domain", "storage", "monitoring", "reviewers", "secrets",
      ]),
      reviewer_action_section(),
      moderation_desk_panel(projection),
      developer_diagnostics_section(ops, readiness),
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-community-actions")],
        [
          @bunnia.button("Check Town Safety", ops.endpoint_id),
          @bunnia.button("Launch Checks", readiness.endpoint_id),
        ],
      ),
    ],
  )
}

///|
fn reviewer_diagnostics_section(
  title : String,
  step : MiniTownBackendStep,
  checks : Array[String],
) -> @bunnia.Node {
  let items = []
  for check in checks {
    items.push(
      @bunnia.view_with_attrs(
        [
          @bunnia.class_name("moontown-diagnostic-row"),
          @bunnia.data("diagnostic-check", check),
        ],
        [
          @bunnia.text(check),
          @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
            @bunnia.text(town_status_label(step.status)),
          ]),
        ],
      ),
    )
  }
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-diagnostic-section"),
      @bunnia.data("diagnostic-section", title),
      @bunnia.data("backend-step", step.id),
    ],
    [
      @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
        @bunnia.text(title),
      ]),
      @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
        @bunnia.text(step.summary),
      ]),
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-diagnostic-list")],
        items,
      ),
    ],
  )
}

///|
fn reviewer_action_section() -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-diagnostic-section"),
      @bunnia.data("diagnostic-section", "reviewer-actions"),
    ],
    [
      @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
        @bunnia.text("Reviewer Actions"),
      ]),
      @bunnia.text(
        "Review, hide, takedown, release hold, resolve incident, and check readiness.",
      ),
    ],
  )
}

///|
fn developer_diagnostics_section(
  ops : MiniTownBackendStep,
  readiness : MiniTownBackendStep,
) -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-diagnostic-section"),
      @bunnia.data("diagnostic-section", "developer"),
      @bunnia.data("developer-diagnostics", "local-explicit"),
      @bunnia.data("ops-endpoint", ops.endpoint_id),
      @bunnia.data("readiness-endpoint", readiness.endpoint_id),
    ],
    [
      @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
        @bunnia.text("Developer Diagnostics"),
      ]),
      @bunnia.text(
        "Endpoint id, HTTP path, payload key, response key, package diagnostics, and render diagnostics stay visible only here.",
      ),
      diagnostic_contract_row(
        "Town Safety", ops, "adminOpsQuery", "adminOpsResult",
      ),
      diagnostic_contract_row(
        "Launch Checks", readiness, "adminReadinessQuery", "adminReadinessResult",
      ),
    ],
  )
}

///|
fn diagnostic_contract_row(
  label : String,
  step : MiniTownBackendStep,
  payload_key : String,
  response_key : String,
) -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-diagnostic-row"),
      @bunnia.data("diagnostic-contract", step.id),
      @bunnia.data("endpoint-id", step.endpoint_id),
      @bunnia.data("http-method", step.http_method),
      @bunnia.data("http-path", step.path),
      @bunnia.data("payload-key", payload_key),
      @bunnia.data("response-key", response_key),
    ],
    [
      @bunnia.text(label),
      @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
        @bunnia.text(
          "\{step.endpoint_id} - \{step.http_method} \{step.path} - payload \{payload_key} - response \{response_key}",
        ),
      ]),
    ],
  )
}

///|
fn backend_step_by_id(
  projection : MiniTownProjection,
  id : String,
) -> MiniTownBackendStep {
  for step in projection.backend_steps {
    if step.id == id {
      return step
    }
  }
  mini_town_backend_step(
    id~,
    label=id,
    endpoint_id=id,
    http_method="GET",
    path="/miniapp/admin/ops",
    summary="Missing backend step.",
    status="missing",
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
    realm_map_state_strip(projection),
    selected_place_action_rail(projection),
  ])
}

///|
fn realm_map_state_strip(projection : MiniTownProjection) -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-map-state-strip")], [
    @bunnia.windowed_list(
      visible_buildings(projection),
      total_count=visible_buildings(projection).length(),
      render=realm_map_state_chip,
    ),
  ])
}

///|
fn realm_map_state_chip(building : MiniTownBuilding) -> @bunnia.Node {
  @bunnia.keyed(
    "map-state-\{building.id}",
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name(
          "moontown-map-state-chip bunnia-status-\{building.status}",
        ),
        @bunnia.data("building-id", building.id),
      ],
      [@bunnia.text("\{building.title}: \{map_marker_badge_label(building)}")],
    ),
  )
}

///|
fn selected_place_action_rail(projection : MiniTownProjection) -> @bunnia.Node {
  let building = selected_building(projection)
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-map-action-rail"),
      @bunnia.data("selected-building-id", building.id),
    ],
    [
      @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
        @bunnia.text(building.title),
      ]),
      @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
        @bunnia.text(building_capability_label(projection, building)),
      ]),
      @bunnia.view_with_attrs([@bunnia.class_name("moontown-map-actions")], [
        @bunnia.button("Ask", "ask-selected-building"),
        @bunnia.button("Messages", "tab-messages"),
        @bunnia.button("Find", "tab-discover"),
      ]),
    ],
  )
}

///|
fn user_switcher(projection : MiniTownProjection) -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-user-switcher")], [
    @bunnia.text("Town member: \{projection.profile.display_name}"),
    @bunnia.button("Enter", "enter-town"),
    @bunnia.button("Realm", "tab-realm"),
    @bunnia.button("Ada", "switch-user-a"),
    @bunnia.button("Bo", "switch-user-b"),
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
  let data = "{\"backendBaseUrl\":\"\{local_backend_base_url()}\",\"bunniaSessionId\":\"\",\"backendStatus\":{},\"login\":{\"userId\":\"user-a\"},\"profileDraft\":{\"displayName\":\"Ada Builder\",\"roleId\":\"builder\",\"consentAccepted\":false},\"ownershipQuery\":{\"includeAlerts\":true},\"messageCenterQuery\":{\"channel\":\"all\",\"limit\":30},\"adminOpsQuery\":{},\"adminReadinessQuery\":{},\"discoverSearch\":{\"query\":\"agent\"},\"discoverAction\":{\"discoveryId\":\"product-agent-publishing-kit\",\"discoveryKind\":\"product\",\"discoveryAction\":\"open\",\"targetRef\":\"product:agent-publishing-kit\"},\"discover\":{\"filter\":\"all\"},\"messages\":{\"channel\":\"all\"},\"ownership\":{\"filter\":\"all\"},\"reviewer\":{\"mode\":\"closed\"},\"buildingDraft\":{\"id\":\"created-agent-lab\",\"title\":\"Created Agent Lab\",\"tags\":[\"agent\",\"local\"]},\"buildingEditDraft\":{\"buildingId\":\"created-agent-lab\",\"title\":\"Edited Lab\",\"summary\":\"Edited.\",\"bookTitle\":\"Edited Book\",\"bookSummary\":\"Edited memory.\",\"tags\":[\"edited\"]},\"placementDraft\":{\"buildingId\":\"published-agent-lab\",\"x\":538,\"y\":528},\"shareDraft\":{\"buildingId\":\"created-agent-lab\",\"targetUserId\":\"user-b\"},\"submitDraft\":{\"buildingId\":\"created-agent-lab\"},\"publishDraft\":{\"buildingId\":\"created-agent-lab\"},\"archiveDraft\":{\"buildingId\":\"created-agent-lab\"},\"restoreDraft\":{\"buildingId\":\"created-agent-lab\"},\"buildingQuestion\":{\"buildingId\":\"policy-hall\",\"body\":\"What can it do?\"},\"chatDraft\":{\"buildingId\":\"policy-hall\",\"body\":\"Can it publish an agent?\"},\"handoffDraft\":{\"buildingId\":\"policy-hall\",\"fromAgentId\":\"agent-policy-guide\",\"toAgentId\":\"agent-builder\",\"summary\":\"Move.\"},\"toolResultAck\":{\"toolResultId\":\"tool-policy-summary\",\"buildingId\":\"policy-hall\"},\"reviewDecision\":{\"reviewId\":\"review-policy-memory\",\"runId\":\"run-policy-review\",\"decision\":\"accept\"},\"notificationAck\":{\"noticeId\":\"notice-review\",\"noticeKind\":\"review\",\"targetRef\":\"thread-policy-hall\"},\"subscriptionRequest\":{\"noticeId\":\"notice-subscribe\",\"noticeKind\":\"subscription\",\"targetRef\":\"subscription:wechat\"},\"reportDraft\":{\"buildingId\":\"policy-hall\",\"reason\":\"Safety review request\"},\"moderationHide\":{\"caseId\":\"mod-policy-hall\",\"buildingId\":\"policy-hall\"},\"moderationTakedown\":{\"caseId\":\"mod-policy-hall\",\"buildingId\":\"policy-hall\"},\"moderationAppeal\":{\"caseId\":\"mod-policy-hall\",\"buildingId\":\"policy-hall\"},\"agentDraft\":{\"id\":\"agent-created\",\"displayName\":\"Created Agent\",\"buildingId\":\"private-agent-lab\"},\"mapViewport\":{\"x\":-520,\"y\":-260,\"scale\":2.6,\"style\":\"transform:translate(-520px,-260px) scale(2.6)\"},\"shell\":{\"activeTab\":\"\{tab_id}\",\"onboardingCompleted\":\"false\"},\"profile\":{\"roleId\":\"builder\",\"consentAccepted\":\"false\",\"setupCompleted\":\"false\"},\"session\":{\"activeUserId\":\"user-a\"},\"town\":{\"selectedBuildingId\":\"policy-hall\",\"buildings\":[{\"id\":\"policy-hall\",\"visibility\":\"published\"},{\"id\":\"private-agent-lab\",\"visibility\":\"private_draft\"},{\"id\":\"team-studio\",\"visibility\":\"shared_private\"}],\"placements\":[{\"id\":\"placement-user-a-policy-hall\",\"buildingId\":\"policy-hall\",\"layer\":\"personal\",\"status\":\"pinned\"}]},\"chat\":{\"messages\":[]},\"agents\":{\"items\":[]},\"runs\":{\"activeRunStatus\":\"idle\"},\"reviews\":{\"memoryReview\":\"pending\"},\"books\":{\"policyHall\":{\"status\":\"review\"}}}"
  if tab_id == "reviewer" {
    data.replace_all(
      old="\"reviewer\":{\"mode\":\"closed\"}",
      new="\"reviewer\":{\"mode\":\"open\"}",
    )
  } else {
    data
  }
}
