///|
test "moontown generated project keeps route patch contracts for tabs and actions" {
  let project = demo_wechat_project()
  assert_true(
    file_content(project.files, "pages/moontown/home.data.js").contains(
      "\"shell\":{\"activeTab\":\"home\"",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/index.data.js").contains(
      "\"dev-login\":[{k:\"set\",p:\"session.activeUserId\",v:\"user-a\"},{k:\"set\",p:\"shell.onboardingCompleted\",v:\"true\"}]",
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
    !file_content(project.files, "pages/moontown/my.data.js").contains(
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
    file_content(project.files, "pages/moontown/home.data.js").contains(
      "\"publish-private-building\":[]",
    ),
  )
  assert_true(
    !file_content(project.files, "pages/moontown/index.data.js").contains(
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
}
