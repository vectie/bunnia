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
