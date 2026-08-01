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
      "moontown-wenyu-energy-valley-20260727",
      moontown_map_asset_src(),
      moontown_map_asset_bytes(),
    ),
    @bunnia.image_asset(
      "moontown-supervisor-avatar",
      supervisor_avatar_asset_src(),
      supervisor_avatar_asset_bytes(),
    ),
  ]
}

///|
fn demo_initial_data_json_for_tab(tab_id : String) -> String {
  let data = "{\"backendBaseUrl\":\"\{local_backend_base_url()}\",\"bunniaSessionId\":\"\",\"backendStatus\":{},\"login\":{\"userId\":\"user-a\"},\"profileDraft\":{\"displayName\":\"Ada Builder\",\"roleId\":\"builder\",\"consentAccepted\":false},\"ownershipQuery\":{\"includeAlerts\":true},\"messageCenterQuery\":{\"channel\":\"all\",\"limit\":30},\"adminOpsQuery\":{},\"adminReadinessQuery\":{},\"discoverSearch\":{\"query\":\"agent\"},\"discoverAction\":{\"discoveryId\":\"product-agent-publishing-kit\",\"discoveryKind\":\"product\",\"discoveryAction\":\"open\",\"targetRef\":\"product:agent-publishing-kit\"},\"discover\":{\"filter\":\"all\",\"moreOpen\":false},\"messages\":{\"channel\":\"all\"},\"ownership\":{\"filter\":\"all\"},\"reviewer\":{\"mode\":\"closed\"},\"buildingDraft\":{\"id\":\"created-agent-lab\",\"title\":\"Created Agent Lab\",\"tags\":[\"agent\",\"local\"]},\"buildingEditDraft\":{\"buildingId\":\"created-agent-lab\",\"title\":\"Edited Lab\",\"summary\":\"Edited.\",\"bookTitle\":\"Edited Book\",\"bookSummary\":\"Edited memory.\",\"tags\":[\"edited\"]},\"placementDraft\":{\"buildingId\":\"published-agent-lab\",\"x\":401,\"y\":388},\"shareDraft\":{\"buildingId\":\"created-agent-lab\",\"targetUserId\":\"user-b\"},\"submitDraft\":{\"buildingId\":\"created-agent-lab\"},\"publishDraft\":{\"buildingId\":\"created-agent-lab\"},\"archiveDraft\":{\"buildingId\":\"created-agent-lab\"},\"restoreDraft\":{\"buildingId\":\"created-agent-lab\"},\"buildingQuestion\":{\"buildingId\":\"policy-hall\",\"body\":\"What can it do?\"},\"chatDraft\":{\"buildingId\":\"policy-hall\",\"body\":\"Can it publish an agent?\"},\"handoffDraft\":{\"buildingId\":\"policy-hall\",\"fromAgentId\":\"agent-policy-guide\",\"toAgentId\":\"agent-builder\",\"summary\":\"Move.\"},\"toolResultAck\":{\"toolResultId\":\"tool-policy-summary\",\"buildingId\":\"policy-hall\"},\"reviewDecision\":{\"reviewId\":\"review-policy-memory\",\"runId\":\"run-policy-review\",\"decision\":\"accept\"},\"notificationAck\":{\"noticeId\":\"notice-review\",\"noticeKind\":\"review\",\"targetRef\":\"thread-policy-hall\"},\"subscriptionRequest\":{\"noticeId\":\"notice-subscribe\",\"noticeKind\":\"subscription\",\"targetRef\":\"subscription:wechat\"},\"reportDraft\":{\"buildingId\":\"policy-hall\",\"reason\":\"Safety review request\"},\"moderationHide\":{\"caseId\":\"mod-policy-hall\",\"buildingId\":\"policy-hall\"},\"moderationTakedown\":{\"caseId\":\"mod-policy-hall\",\"buildingId\":\"policy-hall\"},\"moderationAppeal\":{\"caseId\":\"mod-policy-hall\",\"buildingId\":\"policy-hall\"},\"agentDraft\":{\"id\":\"agent-created\",\"displayName\":\"Created Agent\",\"buildingId\":\"private-agent-lab\"},\"mapViewport\":{\"x\":-460,\"y\":0,\"scale\":1,\"style\":\"transform:translate(-460px,0px) scale(1)\"},\"shell\":{\"activeTab\":\"\{tab_id}\",\"onboardingCompleted\":\"false\"},\"profile\":{\"roleId\":\"builder\",\"consentAccepted\":\"false\",\"setupCompleted\":\"false\"},\"session\":{\"activeUserId\":\"user-a\"},\"town\":{\"selectedBuildingId\":\"policy-hall\",\"detailsOpen\":false,\"mapFullscreen\":false,\"buildings\":[{\"id\":\"policy-hall\",\"visibility\":\"published\"},{\"id\":\"private-agent-lab\",\"visibility\":\"private_draft\"},{\"id\":\"team-studio\",\"visibility\":\"shared_private\"}],\"placements\":[{\"id\":\"placement-user-a-policy-hall\",\"buildingId\":\"policy-hall\",\"layer\":\"personal\",\"status\":\"pinned\"}]},\"chat\":{\"messages\":[]},\"agents\":{\"items\":[]},\"runs\":{\"activeRunStatus\":\"idle\"},\"reviews\":{\"memoryReview\":\"pending\"},\"books\":{\"policyHall\":{\"status\":\"review\"}}}"
  let data = data
    .replace(
      old="\"bunniaSessionId\":\"\"",
      new="\"bunniaSessionId\":\"\",\"marketplaceSessionId\":\"\"",
    )
    .replace(
      old="\"discover\":{\"filter\":\"all\",\"moreOpen\":false}",
      new="\"marketplaceSearch\":{\"q\":\"\"},\"marketplaceRecommendationQuery\":{},\"marketplaceFeedQuery\":{\"q\":\"\"},\"marketplace\":{\"remote\":false,\"organic\":[],\"recommendations\":[],\"sponsored\":[],\"detailsOpen\":false,\"publisherOpen\":false,\"selected\":{\"id\":\"\",\"kind\":\"\",\"title\":\"\",\"summary\":\"\",\"publisher\":\"\",\"buildingId\":\"\",\"priceLabel\":\"\",\"trustLabel\":\"\"}},\"agentListingDraft\":{\"title\":\"Policy Guide\",\"summary\":\"Public capability card with bounded permissions and human review.\",\"publisher_display_name\":\"Ada Builder\",\"capability_labels\":[\"evidence review\"],\"required_permission_labels\":[\"public evidence\"],\"price_label\":\"Request terms\"},\"buildingListingDraft\":{\"title\":\"Robotics Workshop\",\"summary\":\"Public storefront with safe book summaries and accepted outcomes.\",\"publisher_display_name\":\"Ada Builder\",\"domain_labels\":[\"robotics\",\"AI\"],\"rights_label\":\"Rights checked\",\"price_label\":\"Request access\"},\"listingTransition\":{\"listingId\":\"\",\"listingKind\":\"\",\"targetState\":\"submitted\"},\"marketplaceAction\":{\"listingId\":\"\",\"actionId\":\"\",\"message\":\"\"},\"marketplaceSharePreview\":{\"listingId\":\"\",\"listingKind\":\"\"},\"marketplaceShareGrant\":{\"listingId\":\"\",\"targetPrincipalId\":\"\",\"expiresAt\":\"\"},\"discover\":{\"filter\":\"all\",\"moreOpen\":false,\"suggestionsOpen\":false}",
    )
    .replace(
      old="\"messages\":{\"channel\":\"all\"}",
      new="\"messages\":{\"mode\":\"chats\",\"channel\":\"all\",\"channelKind\":\"all\",\"channelOpen\":false},\"channelDirectoryQuery\":{},\"channelDraft\":{\"channelId\":\"\",\"title\":\"\",\"visibility\":\"private\",\"sensitivity\":\"internal\",\"workspaceId\":\"\",\"buildingListingId\":\"\",\"agentListingId\":\"\",\"memberPrincipalIds\":[]},\"channels\":{\"remote\":false,\"items\":[],\"messages\":[{\"id\":\"welcome\",\"sender\":\"Town\",\"role\":\"system\",\"body\":\"This channel is visible only to its named participants.\"}],\"selected\":{\"id\":\"\",\"title\":\"\",\"kind\":\"\",\"contextLabel\":\"\"}},\"channelMessagesQuery\":{\"channelId\":\"\"},\"channelMessageDraft\":{\"body\":\"\"},\"marketplaceNotificationQuery\":{},\"marketplaceNotificationRead\":{\"notificationId\":\"\"},\"marketplaceSubscription\":{\"subscriptionId\":\"town-important-signals\",\"topicKind\":\"town\",\"topicId\":\"important-signals\",\"enabled\":true}",
    )
    .replace(
      old="\"publisherOpen\":false,\"selected\"",
      new="\"publisherOpen\":false,\"sharePreviewOpen\":false,\"sharePreview\":{\"title\":\"\",\"safeSummary\":\"\",\"includedFields\":[],\"withheldFields\":[]},\"selected\"",
    )
    .replace(
      old="\"sponsored\":[],\"detailsOpen\"",
      new="\"sponsored\":[],\"shared\":[],\"sharedLoaded\":false,\"lastShareGrantId\":\"\",\"detailsOpen\"",
    )
    .replace(
      old="\"marketplaceSharePreview\":{\"listingId\":\"\",\"listingKind\":\"\"}",
      new="\"marketplaceSharePreview\":{\"listingId\":\"\",\"listingKind\":\"\"},\"marketplaceSharedQuery\":{},\"marketplaceShareRevoke\":{\"grantId\":\"\"}",
    )
    .replace(
      old="\"trustLabel\":\"\"}},\"agentListingDraft\"",
      new="\"trustLabel\":\"\",\"actions\":[],\"canFollow\":false,\"canMessage\":false,\"canInstall\":false,\"canInvite\":false,\"canTry\":false,\"canVisit\":false,\"canRequestAccess\":false,\"canShare\":false}},\"agentListingDraft\"",
    )
    .replace(
      old="\"marketplaceSubscription\":{",
      new="\"marketplaceActionRequestQuery\":{},\"marketplaceActionRequests\":{\"remote\":false,\"items\":[]},\"marketplaceActionDecision\":{\"requestId\":\"\",\"expectedVersion\":1,\"decision\":\"accept\",\"instruction\":\"\",\"decisionSummary\":\"\"},\"marketplaceActionRetry\":{\"requestId\":\"\",\"expectedVersion\":1},\"notifications\":{\"remote\":false,\"items\":[],\"unreadCount\":0},\"marketplaceSubscription\":{",
    )
    .replace(
      old="\"placementDraft\":{\"buildingId\":\"published-agent-lab\",\"x\":401,\"y\":388}",
      new="\"placementDraft\":{\"buildingId\":\"published-agent-lab\",\"x\":740,\"y\":363}",
    )
    .replace(
      old="\"mapViewport\":{\"x\":-460,\"y\":0,\"scale\":1,\"style\":\"transform:translate(-460px,0px) scale(1)\"}",
      new="\"mapViewport\":{\"x\":-180,\"y\":-40,\"scale\":0.65,\"style\":\"transform:translate(-180px,-40px) scale(0.65)\"}",
    )
    .to_string()
  let data = if tab_id == "home" {
    data.replace(
      old="\"backendStatus\":{},",
      new="\"backendStatus\":{},\"bookCatalogQuery\":{},\"installedBookCatalog\":{\"state\":\"loading\",\"books\":[]},\"onboardingSnapshot\":{\"profile\":{},\"activation\":{},\"executionLineage\":[],\"conversationHistory\":[]},\"supervisorRuntime\":{\"activeWorkerCount\":0,\"workerHistoryCount\":0,\"maxActiveWorkers\":3},\"supervisorSetupQuery\":{},\"supervisorSetup\":{\"state\":\"empty\",\"currentStep\":\"identity\",\"activated\":false,\"runtimeStatus\":\"not_started\",\"bookkeeperStatus\":\"not_requested\"},\"supervisorDraft\":{\"profileId\":\"\",\"version\":0,\"expectedVersion\":0,\"expectedCursor\":0,\"name\":\"\",\"avatarRef\":\"\",\"archetypeId\":\"\",\"mission\":\"\",\"toneId\":\"\",\"capabilityIds\":[],\"workspaceId\":\"\",\"buildingId\":\"\",\"bookId\":\"\",\"maxActiveWorkers\":3,\"model\":\"gpt-5.6-sol\",\"consentAgentControl\":false,\"consentBookkeeperReview\":false,\"consentTermsAccepted\":false,\"termsVersion\":\"2026-08\",\"authorityCeiling\":\"request_bookkeeper_review\",\"commandId\":\"draft-supervisor-new-001\"},\"supervisorActivation\":{\"command_id\":\"\",\"profile_id\":\"\",\"profile_version\":0,\"profile_digest\":\"\",\"expected_cursor\":0},",
    )
  } else if tab_id == "messages" {
    data.replace(
      old="\"backendStatus\":{},",
      new="\"backendStatus\":{},\"onboardingSnapshot\":{\"profile\":{},\"activation\":{},\"executionLineage\":[],\"conversationHistory\":[]},\"supervisorRuntime\":{\"activeWorkerCount\":0,\"workerHistoryCount\":0,\"maxActiveWorkers\":3},\"supervisorSetup\":{\"state\":\"empty\",\"currentStep\":\"identity\",\"activated\":false,\"runtimeStatus\":\"not_started\",\"bookkeeperStatus\":\"not_requested\"},\"supervisorDraft\":{},\"supervisorActivation\":{\"profile\":{},\"activation\":{}},\"activationResult\":{\"profile\":{},\"activation\":{}},\"supervisorMessage\":{\"body\":\"\"},\"workerDelegate\":{},\"runSteer\":{\"guidance\":\"\"},\"supervisorWake\":{},\"supervisorStop\":{},\"supervisorResume\":{},\"childRunSteer\":{},\"runCancel\":{},\"runRetry\":{},\"bookkeeperReview\":{},\"supervisorMessageResult\":{},\"delegateResult\":{},\"steerResult\":{},\"supervisorWakeResult\":{},\"supervisorStopResult\":{},\"supervisorResumeResult\":{},\"childSteerResult\":{},\"cancelResult\":{},\"retryResult\":{},\"bookkeeperReviewResult\":{},",
    )
  } else if tab_id == "realm" {
    data.replace(
      old="\"backendStatus\":{},",
      new="\"backendStatus\":{},\"onboardingSnapshot\":{\"profile\":{},\"activation\":{},\"executionLineage\":[]},\"supervisorRuntime\":{\"activeWorkerCount\":0,\"workerHistoryCount\":0,\"maxActiveWorkers\":3},\"supervisorSetup\":{\"state\":\"empty\",\"currentStep\":\"identity\",\"activated\":false,\"runtimeStatus\":\"not_started\",\"bookkeeperStatus\":\"not_requested\"},\"supervisorActivation\":{\"command_id\":\"\",\"profile_id\":\"\",\"profile_version\":0,\"profile_digest\":\"\",\"expected_cursor\":0},",
    )
  } else {
    data
  }
  let data = if tab_id == "realm" {
    data
    .replace(
      old="\"selectedBuildingId\":\"policy-hall\"",
      new="\"selectedBuildingId\":\"policy-hall\",\"names\":{\"policy-hall\":\"Policy Hall\",\"private-agent-lab\":\"Private Agent Lab\",\"team-studio\":\"Team Studio\",\"market-square\":\"Market Square\",\"review-council\":\"Review Council\",\"knowledge-house\":\"Knowledge House\",\"gateway\":\"Town Gate\",\"book-workshop\":\"Book Workshop\",\"draft-observatory\":\"Draft Observatory\",\"published-agent-lab\":\"Published Agent Lab\"}",
    )
    .to_string()
  } else {
    data
  }
  if tab_id == "reviewer" {
    data.replace_all(
      old="\"reviewer\":{\"mode\":\"closed\"}",
      new="\"reviewer\":{\"mode\":\"open\"}",
    )
  } else {
    data
  }
}
