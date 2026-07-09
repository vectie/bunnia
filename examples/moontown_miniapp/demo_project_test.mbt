///|
test "moontown miniapp generates wechat project with backend hooks" {
  let project = demo_wechat_project()
  assert_true(has_no_forbidden_generated_ordinary_wxml(project.files))
  assert_true(has_reviewer_diagnostics_allowlist(project.files))
  assert_true(generated_contract_data_stays_out_of_ordinary_wxml(project.files))
  assert_true(generated_wxss_has_tile_visual_system(project.files))
  assert_true(
    backend_contract_contains(
      demo_backend_contract(),
      "update-private-building",
      "/miniapp/buildings/update",
    ),
  )
  assert_eq(project.route, "pages/moontown/index")
  assert_eq(project.page_count, 6)
  assert_true(project.report.event_patch_operation_count <= 160)
  assert_true(has_file(project.files, "bunnia.runtime.js"))
  assert_true(has_file(project.files, "bunnia.backend.js"))
  assert_true(has_file(project.files, "pages/moontown/home.wxml"))
  assert_true(has_file(project.files, "pages/moontown/discover.wxml"))
  assert_true(has_file(project.files, "pages/moontown/messages.wxml"))
  assert_true(has_file(project.files, "pages/moontown/my.wxml"))
  assert_true(has_file(project.files, "pages/moontown/reviewer.wxml"))
  assert_true(
    has_file(project.files, "assets/wenyu_reference_tilemap_iso_mobile.png"),
  )
  assert_true(
    file_content(project.files, "assets/wenyu_reference_tilemap_iso_mobile.png").contains(
      "copy-file:examples/moontown_miniapp/assets/wenyu_reference_tilemap_iso_mobile.png",
    ),
  )
  assert_true(project.page.js.contains("require('../../bunnia.runtime.js')"))
  assert_true(project.page.js.contains("require('../../bunnia.backend.js')"))
  assert_true(project.page.js.contains("wx.redirectTo"))
  assert_true(
    file_content(project.files, "app.json").contains(
      "\"pages/moontown/index\", \"pages/moontown/home\", \"pages/moontown/discover\", \"pages/moontown/messages\", \"pages/moontown/my\"",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/home.data.js").contains(
      "\"shell\":{\"activeTab\":\"home\"",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/home.data.js").contains(
      "\"enter-town\":[{k:\"set\",p:\"session.activeUserId\",v:\"user-a\"}]",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/discover.data.js").contains(
      "\"discover-filter-building\":[]",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/discover.data.js").contains(
      "p:\"discoverSearch\",v:{\"query\":\"agent\",\"filter\":\"placeable\",\"kind\":\"building\",\"placeableOnly\":true,\"cursor\":0}",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/discover.data.js").contains(
      "p:\"discoverSearch\",v:{\"query\":\"agent\",\"filter\":\"product\",\"kind\":\"product\",\"placeableOnly\":false,\"cursor\":0}",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/discover.data.js").contains(
      "\"discover-filter-product\":[{k:\"set\",p:\"discoverSearch\",v:{\"query\":\"agent\",\"filter\":\"product\",\"kind\":\"product\",\"placeableOnly\":false,\"cursor\":0}}]",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/discover.data.js").contains(
      "\"discoverAction\":{\"discoveryId\":\"product-agent-publishing-kit\",\"discoveryKind\":\"product\",\"discoveryAction\":\"open\",\"targetRef\":\"product:agent-publishing-kit\"}",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.backend.js").contains("discover-action"),
  )
  assert_true(
    file_content(project.files, "bunnia.backend.js").contains(
      "/miniapp/discover/action",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.backend.js").contains(
      "discoveryActionResult",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/messages.data.js").contains(
      "\"notification-channel-agent\":[{k:\"set\",p:\"messageCenterQuery\",v:{\"channel\":\"agent-run\",\"limit\":30,\"cursor\":0}}]",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/messages.data.js").contains(
      "p:\"messageCenterQuery\",v:{\"channel\":\"agent-run\",\"limit\":30,\"cursor\":0}",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/messages.data.js").contains(
      "\"notification-channel-unread\":[{k:\"set\",p:\"messageCenterQuery\",v:{\"channel\":\"unread\",\"limit\":30,\"cursor\":0}}]",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/messages.data.js").contains(
      "p:\"messageCenterQuery\",v:{\"channel\":\"unread\",\"limit\":30,\"cursor\":0}",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/my.data.js").contains(
      "\"select-role-explorer\":[{k:\"set\",p:\"profile.roleId\",v:\"explorer\"},{k:\"set\",p:\"profileDraft.roleId\",v:\"explorer\"}]",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/my.data.js").contains(
      "\"accept-profile-consent\":[{k:\"set\",p:\"profile.consentAccepted\",v:\"true\"},{k:\"set\",p:\"profileDraft.consentAccepted\",v:true}]",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/my.data.js").contains(
      "\"open-reviewer-tools\":[{k:\"set\",p:\"reviewer.mode\",v:\"open\"}]",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/discover.data.js").contains(
      "\"open-place-published-agent-lab\":[{k:\"set\",p:\"shell.activeTab\",v:\"realm\"},{k:\"set\",p:\"town.selectedBuildingId\",v:\"published-agent-lab\"}]",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/messages.data.js").contains(
      "\"open-place-policy-hall\":[{k:\"set\",p:\"shell.activeTab\",v:\"realm\"},{k:\"set\",p:\"town.selectedBuildingId\",v:\"policy-hall\"}]",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/my.data.js").contains(
      "\"open-place-private-agent-lab\":[{k:\"set\",p:\"shell.activeTab\",v:\"realm\"},{k:\"set\",p:\"town.selectedBuildingId\",v:\"private-agent-lab\"}]",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/my.data.js").contains(
      "\"ownership-filter-books\":[{k:\"set\",p:\"ownershipQuery\",v:{\"includeAlerts\":true,\"kind\":\"book\",\"visibility\":\"all\",\"cursor\":0}}]",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/my.data.js").contains(
      "p:\"ownershipQuery\",v:{\"includeAlerts\":true,\"kind\":\"book\",\"visibility\":\"all\",\"cursor\":0}",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/my.data.js").contains(
      "\"ownership-filter-placements\":[{k:\"set\",p:\"ownershipQuery\",v:{\"includeAlerts\":true,\"kind\":\"placement\",\"visibility\":\"all\",\"cursor\":0}}]",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/my.data.js").contains(
      "p:\"ownershipQuery\",v:{\"includeAlerts\":true,\"kind\":\"placement\",\"visibility\":\"all\",\"cursor\":0}",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/my.data.js").contains(
      "p:\"ownershipQuery\",v:{\"includeAlerts\":true,\"kind\":\"all\",\"visibility\":\"private_draft\",\"cursor\":0}",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/messages.wxml").contains(
      "data-active-tab=\"messages\"",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/messages.wxml").contains(
      "data-bunnia-route=\"pages/moontown/index\"",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/my.data.js").contains(
      "\"create-private-building\"",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/index.data.js").contains(
      "\"publish-private-building\":[]",
    ),
  )
  assert_true(
    !file_content(project.files, "pages/moontown/index.data.js").contains(
      "lastPublishedBuildingId",
    ),
  )
  assert_true(
    !file_content(project.files, "pages/moontown/index.data.js").contains(
      "\"lifecycle\"",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.backend.js").contains(
      "/miniapp/buildings/query",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.backend.js").contains(
      "/miniapp/me/profile",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.backend.js").contains(
      "/miniapp/me/ownership",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.backend.js").contains(
      "/miniapp/discover/search",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.backend.js").contains(
      "/miniapp/messages/center",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.backend.js").contains(
      "/miniapp/messages/subscribe",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.backend.js").contains(
      "/miniapp/messages/send",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.backend.js").contains(
      "/miniapp/moderation/report",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.backend.js").contains(
      "/miniapp/moderation/hide",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.backend.js").contains(
      "/miniapp/moderation/takedown",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.backend.js").contains(
      "/miniapp/moderation/appeal",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.backend.js").contains(
      "/miniapp/admin/ops",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.backend.js").contains(
      "/miniapp/admin/readiness",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.backend.js").contains(
      "/miniapp/buildings/publish",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.backend.js").contains(
      "/miniapp/buildings/share",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.backend.js").contains(
      "/miniapp/buildings/update",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.backend.js").contains(
      "/miniapp/buildings/submit",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.backend.js").contains(
      "/miniapp/buildings/archive",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.backend.js").contains(
      "/miniapp/buildings/restore",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.backend.js").contains(
      "/miniapp/reviews/accept",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.backend.js").contains(
      "/miniapp/reviews/reject",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.backend.js").contains(
      "x-miniapp-session",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.backend.js").contains("bunniaSessionId"),
  )
  assert_true(
    file_content(project.files, "pages/moontown/index.data.js").contains(
      "\"shell\":{\"activeTab\":\"realm\"",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/index.data.js").contains(
      "\"backendBaseUrl\":\"http://127.0.0.1:18191\"",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/index.data.js").contains(
      "\"backendStatus\":{}",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.backend.js").contains(
      "backendStatus.' + String(endpointId).replace",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.backend.js").contains(
      "__bs(loading, endpointId, 'loading', '')",
    ),
  )
  assert_true(
    project.page.js.contains(
      "__bunniaMaybeRequest(this,message,event.currentTarget.dataset||{})",
    ),
  )
  assert_true(
    project.page.js.contains(
      "const { __bunniaBackend, __bunniaRequest, __bunniaRetryRequest, __bk }",
    ),
  )
  assert_true(project.page.js.contains("Object.assign({},p.data[e.p]||{})"))
  assert_true(project.page.js.contains("__bk.map(k=>"))
  assert_true(
    project.page.js.contains("d[k]!==undefined&&d[k]!==''&&(b[k]=d[k],h=1)"),
  )
  assert_true(
    !file_content(project.files, "pages/moontown/discover.wxml").contains(
      "data-cursor=",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/discover.wxml").contains(
      "data-bunnia-message=\"discover-search\"",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/messages.wxml").contains(
      "data-bunnia-message=\"load-message-center\"",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/my.wxml").contains(
      "data-bunnia-message=\"load-ownership-snapshot\"",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/index.data.js").contains(
      "\"mapViewport\":{\"x\":-520,\"y\":-260,\"scale\":2.6,\"style\":\"transform:translate(-520px,-260px) scale(2.6)\"",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/index.data.js").contains(
      "\"login\":{\"userId\":\"user-a\"}",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/index.data.js").contains(
      "\"profileDraft\":{\"displayName\":\"Ada Builder\",\"roleId\":\"builder\",\"consentAccepted\":false}",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/index.data.js").contains(
      "\"ownershipQuery\":{\"includeAlerts\":true}",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/index.data.js").contains(
      "\"reviewer\":{\"mode\":\"closed\"}",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/index.data.js").contains(
      "\"messageCenterQuery\":{\"channel\":\"all\",\"limit\":30}",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/index.data.js").contains(
      "\"adminOpsQuery\":{}",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/index.data.js").contains(
      "\"adminReadinessQuery\":{}",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/index.data.js").contains(
      "\"notificationAck\":{\"noticeId\":\"notice-review\",\"noticeKind\":\"review\",\"targetRef\":\"thread-policy-hall\"}",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/index.data.js").contains(
      "\"subscriptionRequest\":{\"noticeId\":\"notice-subscribe\",\"noticeKind\":\"subscription\",\"targetRef\":\"subscription:wechat\"}",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/index.data.js").contains(
      "\"reportDraft\":{\"buildingId\":\"policy-hall\",\"reason\":\"Safety review request\"}",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/index.data.js").contains(
      "\"moderationHide\":{\"caseId\":\"mod-policy-hall\",\"buildingId\":\"policy-hall\"}",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/index.data.js").contains(
      "\"moderationTakedown\":{\"caseId\":\"mod-policy-hall\",\"buildingId\":\"policy-hall\"}",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/index.data.js").contains(
      "\"moderationAppeal\":{\"caseId\":\"mod-policy-hall\",\"buildingId\":\"policy-hall\"}",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/index.data.js").contains(
      "\"discoverSearch\":{\"query\":\"agent\"}",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/index.data.js").contains(
      "\"discover\":{\"filter\":\"all\"}",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/index.data.js").contains(
      "\"messages\":{\"channel\":\"all\"}",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/index.data.js").contains(
      "\"ownership\":{\"filter\":\"all\"}",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/index.data.js").contains(
      "\"shell\":{\"activeTab\":\"realm\",\"onboardingCompleted\":\"false\"}",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/index.data.js").contains(
      "\"buildingEditDraft\":{\"buildingId\":\"created-agent-lab\",\"title\":\"Edited Lab\"",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/index.data.js").contains(
      "\"publishDraft\":{\"buildingId\":\"created-agent-lab\"}",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/index.data.js").contains(
      "\"shareDraft\":{\"buildingId\":\"created-agent-lab\",\"targetUserId\":\"user-b\"}",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/index.data.js").contains(
      "\"submitDraft\":{\"buildingId\":\"created-agent-lab\"}",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/index.data.js").contains(
      "\"archiveDraft\":{\"buildingId\":\"created-agent-lab\"}",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/index.data.js").contains(
      "\"restoreDraft\":{\"buildingId\":\"created-agent-lab\"}",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/index.data.js").contains(
      "\"agentDraft\":{\"id\":\"agent-created\",\"displayName\":\"Created Agent\",\"buildingId\":\"private-agent-lab\"}",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/index.data.js").contains(
      "\"handoffDraft\":{\"buildingId\":\"policy-hall\",\"fromAgentId\":\"agent-policy-guide\",\"toAgentId\":\"agent-builder\",\"summary\":\"Move.\"}",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/index.data.js").contains(
      "\"toolResultAck\":{\"toolResultId\":\"tool-policy-summary\",\"buildingId\":\"policy-hall\"}",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/index.data.js").contains(
      "\"chatDraft\":{\"buildingId\":\"policy-hall\",\"body\":\"Can it publish an agent?\"}",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/index.data.js").contains(
      "\"placementDraft\":{\"buildingId\":\"published-agent-lab\",\"x\":538,\"y\":528}",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/index.data.js").contains(
      "\"reviewDecision\":{\"reviewId\":\"review-policy-memory\",\"runId\":\"run-policy-review\",\"decision\":\"accept\"}",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/index.data.js").contains(
      "\"placements\":[{\"id\":\"placement-user-a-policy-hall\",\"buildingId\":\"policy-hall\",\"layer\":\"personal\",\"status\":\"pinned\"}]",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/index.wxml").contains(
      "data-bunnia-message=\"enter-town\"",
    ),
  )
  assert_true(
    !file_content(project.files, "pages/moontown/index.wxml").contains(
      "data-bunnia-message=\"dev-login\"",
    ),
  )
  assert_true(
    !file_content(project.files, "pages/moontown/index.wxml").contains(
      "data-guide-step=\"agent-mail\"",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/home.wxml").contains(
      "data-guide-step=\"agent-mail\"",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/index.wxml").contains(
      "data-bunnia-route=\"pages/moontown/messages\"",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/home.wxml").contains(
      "data-guide-step=\"passport\"",
    ),
  )
  assert_eq(project.manifest.pages[0].route, "pages/moontown/index")
  assert_eq(project.manifest.pages[1].route, "pages/moontown/home")
  assert_eq(project.manifest.pages[2].route, "pages/moontown/discover")
  assert_eq(project.manifest.pages[3].route, "pages/moontown/messages")
  assert_eq(project.manifest.pages[4].route, "pages/moontown/my")
  assert_eq(project.manifest.pages[5].route, "pages/moontown/reviewer")
  assert_true(project.manifest.pages[0].backend_event_count >= 3)
  assert_true(project.manifest.pages[3].backend_event_count >= 2)
  assert_true(project.manifest.pages[0].scene_marker_count >= 8)
  assert_true(project.manifest.pages[0].scene_region_count == 2)
  assert_eq(project.manifest.diagnostic_count, 0)
  assert_true(project.manifest.summary.contains("app_files="))
}

///|
