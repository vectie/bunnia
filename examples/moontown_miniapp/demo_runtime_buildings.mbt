///|
fn add_building_navigation_event_patches(
  patches : Array[@bunnia.WechatEventPatch],
  projection : MiniTownProjection,
) -> Unit {
  for building in visible_buildings(projection) {
    patches.push(select_building_patch(building))
    patches.push(open_place_patch(building))
    patches.push(open_building_thread_patch(building))
  }
}

///|
fn add_building_workflow_event_patches(
  patches : Array[@bunnia.WechatEventPatch],
) -> Unit {
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
