///|
test "moontown generated project keeps seeded page data contract" {
  let project = demo_wechat_project()
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
}
