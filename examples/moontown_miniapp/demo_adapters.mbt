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
