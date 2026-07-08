///|
test "moontown miniapp generates full vertical slice page" {
  let page = demo_wechat_page()
  assert_true(page.wxml.contains("Moontown"))
  assert_true(page.wxml.contains("moontown-map-fullscreen"))
  assert_true(!page.wxml.contains("movable-area"))
  assert_true(!page.wxml.contains("movable-view"))
  assert_true(page.wxml.contains("moontown-map-touch-area"))
  assert_true(page.wxml.contains("moontown-map-drag-content"))
  assert_true(page.wxml.contains("style=\"{{mapViewport.style}}\""))
  assert_true(page.wxml.contains("bindtouchstart=\"onMoontownMapTouchStart\""))
  assert_true(page.wxml.contains("catchtouchmove=\"onMoontownMapTouchMove\""))
  assert_true(page.wxml.contains("bindtouchend=\"onMoontownMapTouchEnd\""))
  assert_true(!page.wxml.contains("moontown-map-backfill"))
  assert_true(page.wxml.contains("moontown-wenyu-map-image"))
  assert_true(page.wxml.contains("data-asset-id=\"moontown-wenyu-map\""))
  assert_true(page.wxml.contains("left:958rpx;top:776rpx"))
  assert_true(page.wxml.contains("moontown-map-marker"))
  assert_true(page.wxml.contains("moontown-thread-pin"))
  assert_true(page.wxml.contains("moontown-topbar"))
  assert_true(page.wxml.contains("moontown-left-hud"))
  assert_true(page.wxml.contains("moontown-right-hud"))
  assert_true(page.wxml.contains("moontown-bottom-hud"))
  assert_true(page.wxml.contains("moontown-tabbar"))
  assert_true(page.wxml.contains("data-map-surface=\"true\""))
  assert_true(page.wxml.contains("First Visit"))
  assert_true(page.wxml.contains("moontown-guide-step"))
  assert_true(page.wxml.contains("data-guide-step=\"enter-town\""))
  assert_true(page.wxml.contains("data-guide-step=\"discover-public\""))
  assert_true(page.wxml.contains("data-tab-id=\"discover\""))
  assert_true(
    page.wxml.contains("data-bunnia-route=\"pages/moontown/discover\""),
  )
  assert_true(!page.wxml.contains("Identity Setup"))
  assert_true(!page.wxml.contains("Town Builder"))
  assert_true(!page.wxml.contains("Accept Consent"))
  assert_true(page.wxml.contains("Realm is the map"))
  assert_true(!page.wxml.contains("Product Market"))
  assert_true(page.wxml.contains("Discover"))
  assert_true(page.wxml.contains("Messages"))
  assert_true(!page.wxml.contains("My Town"))
  assert_true(page.wxml.contains("moontown-building-drawer"))
  assert_true(page.wxml.contains("moontown-book-entry"))
  assert_true(page.wxml.contains("Policy Hall Book"))
  assert_true(page.wxml.contains("data-book-id=\"book-policy-hall\""))
  assert_true(page.wxml.contains("12 memories / 1 reviews / review"))
  assert_true(page.wxml.contains("moontown-lifecycle-actions"))
  assert_true(page.wxml.contains("data-lifecycle-action=\"ask\""))
  assert_true(page.wxml.contains("data-lifecycle-action=\"publish\""))
  assert_true(page.wxml.contains("data-target-ref=\"building:policy-hall\""))
  assert_true(page.wxml.contains("data-book-id=\"book-policy-hall\""))
  assert_true(page.wxml.contains("moontown-lifecycle-action blocked"))
  assert_true(page.wxml.contains("data-allowed=\"false\""))
  assert_true(page.wxml.contains("data-blocked-reason=\"owner only\""))
  assert_true(page.wxml.contains("disabled=\"true\""))
  assert_true(page.wxml.contains("moontown-run-entry"))
  assert_true(page.wxml.contains("Policy answer review"))
  assert_true(page.wxml.contains("data-run-id=\"run-policy-review\""))
  assert_true(
    page.wxml.contains("data-artifact-ref=\"artifact://book-policy-hall\""),
  )
  assert_true(page.wxml.contains("moontown-review-entry"))
  assert_true(page.wxml.contains("Review policy answer"))
  assert_true(page.wxml.contains("data-review-id=\"review-policy-memory\""))
  assert_true(page.wxml.contains("data-decision=\"accept\""))
  assert_true(page.wxml.contains("data-decision=\"reject\""))
  assert_true(
    page.wxml.contains("data-bunnia-message=\"accept-memory-review\""),
  )
  assert_true(
    page.wxml.contains("data-bunnia-message=\"reject-memory-review\""),
  )
  assert_true(page.wxml.contains("Lifecycle"))
  assert_true(page.wxml.contains("moontown-audit-entry"))
  assert_true(page.wxml.contains("Policy answer entered review"))
  assert_true(page.wxml.contains("data-audit-id=\"audit-policy-review\""))
  assert_true(page.wxml.contains("moontown-chat-drawer"))
  assert_true(page.wxml.contains("moontown-search-drawer"))
  assert_true(page.wxml.contains("moontown-create-drawer"))
  assert_true(page.wxml.contains("data-visibility=\"private_draft\""))
  assert_true(page.wxml.contains("data-visibility=\"published\""))
  assert_true(page.wxml.contains("select-policy-hall"))
  assert_true(page.wxml.contains("ask-selected-building"))
  assert_true(page.wxml.contains("create-private-building"))
  assert_true(page.wxml.contains("create-agent"))
  assert_true(page.wxml.contains("place-published-building"))
  assert_true(page.wxml.contains("bunnia-scene-marker"))
  assert_true(page.wxml.contains("bunnia-scene-region"))
  assert_true(page.wxml.contains("bunnia-scene-thread-overlay"))
  assert_true(page.wxss.contains(".bunnia-scene"))
  assert_true(page.wxss.contains(".moontown-map-touch-area"))
  assert_true(page.wxss.contains(".moontown-map-drag-content"))
  assert_true(page.wxss.contains("transform-origin:0 0"))
  assert_true(!page.wxss.contains(".moontown-map-backfill"))
  assert_true(page.wxss.contains(".moontown-wenyu-map-image"))
  assert_true(page.wxss.contains("width:2800rpx;height:1760rpx"))
  assert_true(page.wxss.contains(".moontown-left-hud"))
  assert_true(page.wxss.contains(".moontown-right-hud"))
  assert_true(page.wxss.contains(".moontown-bottom-hud"))
  assert_true(page.wxss.contains(".moontown-tabbar"))
  assert_true(page.wxss.contains(".moontown-tab-button.active"))
  assert_true(page.wxss.contains(".moontown-guide-step"))
  assert_true(page.js.contains("__bunniaEventPatches"))
  assert_true(page.js.contains("\"tab-realm\""))
  assert_true(page.js.contains("\"complete-onboarding\""))
  assert_true(page.js.contains("\"switch-user-a\""))
  assert_true(page.js.contains("\"switch-user-b\""))
  assert_true(page.js.contains("\"dev-login\""))
  assert_true(page.js.contains("\"load-town-snapshot\""))
  assert_true(page.js.contains("onMoontownMapTouchStart"))
  assert_true(page.js.contains("onMoontownMapTouchMove"))
  assert_true(page.js.contains("onMoontownMapTouchEnd"))
  assert_true(page.js.contains("__mc"))
  assert_true(page.js.contains("__mk"))
  assert_true(!page.js.contains("__er"))
  assert_true(page.js.contains("Math.max(0,1400-vw)"))
  assert_true(page.js.contains("Math.max(0,880-vh)"))
  assert_true(!page.js.contains("this.__cl(278-y*2,0,278)"))
  assert_true(!page.js.contains("this.__cl(2474-y*2,793,1354)"))
  assert_true(!page.js.contains("const end=840-vh"))
  assert_true(!page.js.contains("setTimeout"))
  assert_true(!page.js.contains("__moontownMapBounceTimer"))
  assert_true(!page.js.contains("padPx"))
  assert_true(!page.js.contains("const safe = { left: 155"))
  assert_true(page.js.contains("\"ask-selected-building\""))
  assert_true(page.js.contains("\"create-private-building\""))
  assert_true(page.js.contains("\"place-published-building\""))
  assert_true(page.js.contains("\"share-private-building\""))
  assert_true(page.js.contains("\"publish-private-building\""))
  assert_true(page.js.contains("\"archive-private-building\""))
  assert_true(page.plan.scene_count == 1)
  assert_true(page.plan.scene_marker_count >= 8)
  assert_true(page.plan.scene_region_count == 2)
  assert_true(page.plan.scene_asset_count == 2)
  assert_true(page.plan.windowed_list_count >= 5)
}

///|
test "moontown miniapp renders dedicated tab surfaces around the same map" {
  let projection = demo_projection()
  let realm = tab_page(projection, "realm")
  assert_true(realm.wxml.contains("moontown-map-fullscreen"))
  assert_true(realm.wxml.contains("moontown-left-hud"))
  assert_true(realm.wxml.contains("moontown-right-hud"))
  assert_true(realm.wxml.contains("data-bunnia-route=\"pages/moontown/home\""))
  assert_true(
    realm.wxml.contains("data-bunnia-route=\"pages/moontown/messages\""),
  )
  assert_true(!realm.wxml.contains("moontown-page-surface"))
  assert_true(realm.wxml.contains("data-map-surface=\"true\""))
  assert_true(!realm.wxml.contains("Map Districts"))
  assert_true(!realm.wxml.contains("Community Hub"))

  let home = tab_page(projection, "home")
  assert_true(home.wxml.contains("moontown-map-fullscreen"))
  assert_true(home.wxml.contains("moontown-page-surface"))
  assert_true(home.wxml.contains("data-active-tab=\"home\""))
  assert_true(home.wxml.contains("Town Pulse"))
  assert_true(home.wxml.contains("Backend Loop"))
  assert_true(home.wxml.contains("DevTools target: http://127.0.0.1:18191"))
  assert_true(home.wxml.contains("data-backend-endpoint=\"dev-login\""))
  assert_true(
    home.wxml.contains("data-backend-endpoint=\"load-town-snapshot\""),
  )
  assert_true(home.wxml.contains("data-backend-endpoint=\"cancel-run\""))
  assert_true(home.wxml.contains("data-backend-endpoint=\"retry-run\""))
  assert_true(home.wxml.contains("data-backend-endpoint=\"ack-notification\""))
  assert_true(
    home.wxml.contains("data-backend-endpoint=\"request-subscription\""),
  )
  assert_true(home.wxml.contains("data-backend-path=\"/miniapp/runs/cancel\""))
  assert_true(home.wxml.contains("data-backend-path=\"/miniapp/runs/retry\""))
  assert_true(home.wxml.contains("data-backend-path=\"/miniapp/messages/ack\""))
  assert_true(
    home.wxml.contains("data-backend-path=\"/miniapp/messages/subscribe\""),
  )
  assert_true(
    home.wxml.contains("data-backend-path=\"/miniapp/town/snapshot\""),
  )
  assert_true(home.wxml.contains("data-backend-cache=\"snapshot\""))
  assert_true(home.wxml.contains("data-cache-state=\"stale-safe\""))
  assert_true(
    home.wxml.contains(
      "runtime: {{backendStatus.load_town_snapshot.state || 'idle'}}",
    ),
  )
  assert_true(
    home.wxml.contains("data-bunnia-message=\"publish-private-building\""),
  )
  assert_true(
    home.wxml.contains(
      "Last visible town stays rendered when snapshot loading fails.",
    ),
  )
  assert_true(
    home.wxml.contains(
      "Realm is the map; Home shows recent work around the same tile town.",
    ),
  )
  assert_true(home.wxml.contains("data-home-stat=\"visible-buildings\""))
  assert_true(home.wxml.contains("Community Hub"))
  assert_true(
    home.wxml.contains(
      "Reference feature pages become tile districts on the map.",
    ),
  )
  assert_true(home.wxml.contains("data-feature-kind=\"market\""))
  assert_true(home.wxml.contains("data-feature-kind=\"credential\""))
  assert_true(home.wxml.contains("OPC Hub"))
  assert_true(home.wxml.contains("8 checks / Verify"))
  assert_true(home.wxml.contains("moontown-presence-chip"))
  assert_true(home.wxml.contains("data-presence-id=\"presence-policy-guide\""))
  assert_true(home.wxml.contains("data-actor-kind=\"agent\""))
  assert_true(home.wxml.contains("Search Town"))
  assert_true(home.wxml.contains("Publish Draft"))
  assert_true(home.wxml.contains("Recent Activity"))
  assert_true(home.wxml.contains("Policy answer waiting for review"))
  assert_true(home.wxml.contains("data-activity-kind=\"run\""))
  assert_true(home.wxml.contains("data-target-ref=\"thread-policy-hall\""))
  assert_true(home.wxml.contains("data-building-id=\"policy-hall\""))
  assert_true(!home.wxml.contains("Map Districts"))
  assert_true(!home.wxml.contains("moontown-right-hud"))

  let discover = tab_page(projection, "discover")
  assert_true(discover.wxml.contains("moontown-map-fullscreen"))
  assert_true(discover.wxml.contains("moontown-page-surface"))
  assert_true(discover.wxml.contains("data-active-tab=\"discover\""))
  assert_true(
    discover.wxml.contains(
      "Search buildings, users, agents, books, events, demands, and posts.",
    ),
  )
  assert_true(
    discover.wxml.contains("runtime filter: {{discover.filter || 'all'}}"),
  )
  assert_true(discover.wxml.contains("moontown-discover-entry"))
  assert_true(discover.wxml.contains("Town People"))
  assert_true(discover.wxml.contains("Town Circles"))
  assert_true(discover.wxml.contains("moontown-discovery-chip"))
  assert_true(discover.wxml.contains("Deep Cultivator"))
  assert_true(discover.wxml.contains("AI Exploration Camp"))
  assert_true(discover.wxml.contains("discover-search"))
  assert_true(discover.wxml.contains("moontown-discovery-filter active"))
  assert_true(discover.wxml.contains("data-filter-id=\"user\""))
  assert_true(discover.wxml.contains("data-filter-id=\"circle\""))
  assert_true(discover.wxml.contains("data-filter-id=\"placeable\""))
  assert_true(discover.wxml.contains("data-filter-kind=\"building\""))
  assert_true(discover.wxml.contains("Published Agent Lab"))
  assert_true(discover.wxml.contains("data-discovery-kind=\"building\""))
  assert_true(discover.wxml.contains("Place On Map"))
  assert_true(
    discover.wxml.contains("data-building-id=\"published-agent-lab\""),
  )
  assert_true(
    discover.wxml.contains("data-target-ref=\"building:published-agent-lab\""),
  )
  assert_true(discover.wxml.contains("data-placement-state=\"not-placed\""))
  assert_true(discover.wxml.contains("data-discovery-kind=\"agent\""))
  assert_true(discover.wxml.contains("data-discovery-kind=\"book\""))
  assert_true(
    discover.wxml.contains("data-target-ref=\"agent:agent-policy-guide\""),
  )
  assert_true(
    discover.wxml.contains("data-target-ref=\"book:book-published-agent-lab\""),
  )
  assert_true(discover.wxml.contains("Agent Lab Field Note"))
  assert_true(!discover.wxml.contains("moontown-right-hud"))

  let messages = tab_page(projection, "messages")
  assert_true(messages.wxml.contains("data-active-tab=\"messages\""))
  assert_true(
    messages.wxml.contains("runtime channel: {{messages.channel || 'all'}}"),
  )
  assert_true(messages.wxml.contains("moontown-message-bucket"))
  assert_true(messages.wxml.contains("moontown-message-sync"))
  assert_true(messages.wxml.contains("data-backend-sync=\"notifications\""))
  assert_true(messages.wxml.contains("Ack Sync"))
  assert_true(messages.wxml.contains("Subscribe Sync"))
  assert_true(
    messages.wxml.contains("data-backend-endpoint=\"ack-notification\""),
  )
  assert_true(
    messages.wxml.contains("{{backendStatus.ack_notification.state || 'idle'}}"),
  )
  assert_true(
    messages.wxml.contains("data-backend-endpoint=\"request-subscription\""),
  )
  assert_true(
    messages.wxml.contains(
      "{{backendStatus.request_subscription.state || 'idle'}}",
    ),
  )
  assert_true(messages.wxml.contains("New Follows"))
  assert_true(messages.wxml.contains("Interactions"))
  assert_true(messages.wxml.contains("data-channel-id=\"follow\""))
  assert_true(messages.wxml.contains("data-channel-id=\"interaction\""))
  assert_true(messages.wxml.contains("moontown-message-channel active"))
  assert_true(messages.wxml.contains("data-channel-id=\"agent\""))
  assert_true(messages.wxml.contains("data-channel-kind=\"agent-run\""))
  assert_true(messages.wxml.contains("Deep Cultivator followed your town"))
  assert_true(messages.wxml.contains("Enterprise Club replied"))
  assert_true(messages.wxml.contains("Memory review needed"))
  assert_true(messages.wxml.contains("Agent run completed"))
  assert_true(messages.wxml.contains("data-notice-kind=\"agent-run\""))
  assert_true(messages.wxml.contains("Agent Runs"))
  assert_true(
    messages.wxml.contains(
      "Runs stay linked to buildings, books, threads, and review artifacts.",
    ),
  )
  assert_true(messages.wxml.contains("Market placement scan"))
  assert_true(messages.wxml.contains("data-run-id=\"run-market-scan\""))
  assert_true(messages.wxml.contains("data-review-required=\"true\""))
  assert_true(messages.wxml.contains("moontown-run-actions"))
  assert_true(messages.wxml.contains("data-run-action=\"open-building\""))
  assert_true(messages.wxml.contains("data-run-action=\"review-accept\""))
  assert_true(messages.wxml.contains("data-run-action=\"review-reject\""))
  assert_true(messages.wxml.contains("data-run-action=\"cancel\""))
  assert_true(messages.wxml.contains("data-run-action=\"retry\""))
  assert_true(
    messages.wxml.contains("data-target-ref=\"building:policy-hall\""),
  )
  assert_true(
    messages.wxml.contains("data-bunnia-message=\"select-policy-hall\""),
  )
  assert_true(
    messages.wxml.contains("data-bunnia-message=\"accept-memory-review\""),
  )
  assert_true(
    messages.wxml.contains("data-bunnia-message=\"reject-memory-review\""),
  )
  assert_true(messages.wxml.contains("data-bunnia-message=\"cancel-run\""))
  assert_true(messages.wxml.contains("data-bunnia-message=\"retry-run\""))
  assert_true(messages.wxml.contains("data-blocked-reason=\"wait for status\""))
  assert_true(messages.wxml.contains("Review Queue"))
  assert_true(
    messages.wxml.contains(
      "Accepted agent output becomes book memory; rejected output returns to the run.",
    ),
  )
  assert_true(messages.wxml.contains("data-review-id=\"review-policy-memory\""))
  assert_true(messages.wxml.contains("data-decision=\"accept\""))
  assert_true(messages.wxml.contains("data-decision=\"reject\""))
  assert_true(messages.wxml.contains("Subscribe to town signals"))
  assert_true(messages.wxml.contains("data-notice-action=\"open\""))
  assert_true(messages.wxml.contains("data-notice-action=\"ack\""))
  assert_true(messages.wxml.contains("data-notice-id=\"notice-follow\""))
  assert_true(messages.wxml.contains("data-notice-kind=\"follow\""))
  assert_true(messages.wxml.contains("data-target-ref=\"subscription:wechat\""))
  assert_true(
    messages.wxml.contains("data-action-message=\"open-notice-review\""),
  )
  assert_true(
    messages.wxml.contains("data-action-message=\"request-subscription\""),
  )
  assert_true(
    messages.wxml.contains("data-bunnia-message=\"ack-notification\""),
  )
  assert_true(
    messages.wxml.contains("data-bunnia-message=\"request-subscription\""),
  )
  assert_true(messages.wxml.contains("data-requires-subscription=\"true\""))
  assert_true(messages.wxml.contains("data-building-id=\"policy-hall\""))
  assert_true(messages.wxml.contains("moontown-chat-drawer"))
  assert_true(!messages.wxml.contains("moontown-bottom-hud"))

  let mine = tab_page(projection, "my")
  assert_true(mine.wxml.contains("data-active-tab=\"my\""))
  assert_true(mine.wxml.contains("Identity Setup"))
  assert_true(
    mine.wxml.contains("runtime role: {{profile.roleId || 'builder'}}"),
  )
  assert_true(
    mine.wxml.contains("runtime ownership: {{ownership.filter || 'all'}}"),
  )
  assert_true(mine.wxml.contains("data-setup-gate=\"session\""))
  assert_true(mine.wxml.contains("data-setup-gate=\"publish-ready\""))
  assert_true(
    mine.wxml.contains(
      "Publishing stays blocked until role, consent, and profile are ready.",
    ),
  )
  assert_true(mine.wxml.contains("data-complete=\"false\""))
  assert_true(
    mine.wxml.contains("data-bunnia-message=\"accept-profile-consent\""),
  )
  assert_true(mine.wxml.contains("My Town"))
  assert_true(mine.wxml.contains("moontown-profile-card"))
  assert_true(mine.wxml.contains("data-profile-user-id=\"user-a\""))
  assert_true(mine.wxml.contains("data-profile-role=\"builder\""))
  assert_true(mine.wxml.contains("data-profile-ready=\"false\""))
  assert_true(mine.wxml.contains("UID:user-a / avatar://ada"))
  assert_true(mine.wxml.contains("moontown-profile-metric"))
  assert_true(mine.wxml.contains("Followers"))
  assert_true(mine.wxml.contains("Published"))
  assert_true(mine.wxml.contains("data-bunnia-message=\"save-profile\""))
  assert_true(mine.wxml.contains("moontown-credential-plaque"))
  assert_true(mine.wxml.contains("OPC Credential"))
  assert_true(mine.wxml.contains("data-feature-kind=\"credential\""))
  assert_true(mine.wxml.contains("data-target-building-id=\"policy-hall\""))
  assert_true(mine.wxml.contains("data-bunnia-message=\"select-policy-hall\""))
  assert_true(mine.wxml.contains("My Lifecycle"))
  assert_true(mine.wxml.contains("data-publication-step=\"draft\""))
  assert_true(mine.wxml.contains("data-publication-step=\"review\""))
  assert_true(mine.wxml.contains("Private Draft"))
  assert_true(mine.wxml.contains("Town Published"))
  assert_true(mine.wxml.contains("Private Agent Lab drafted"))
  assert_true(mine.wxml.contains("data-audit-kind=\"create\""))
  assert_true(mine.wxml.contains("ready: no"))
  assert_true(mine.wxml.contains("data-ownership-stat=\"drafts\""))
  assert_true(mine.wxml.contains("data-ownership-stat=\"placements\""))
  assert_true(mine.wxml.contains("data-ownership-stat=\"books\""))
  assert_true(mine.wxml.contains("moontown-ownership-filter active"))
  assert_true(mine.wxml.contains("data-ownership-filter-id=\"placements\""))
  assert_true(mine.wxml.contains("data-ownership-filter-kind=\"placement\""))
  assert_true(mine.wxml.contains("data-ownership-filter-id=\"drafts\""))
  assert_true(
    mine.wxml.contains("data-ownership-filter-visibility=\"private_draft\""),
  )
  assert_true(mine.wxml.contains("data-ownership-filter-id=\"books\""))
  assert_true(mine.wxml.contains("data-ownership-filter-kind=\"agent\""))
  assert_true(mine.wxml.contains("data-ownership-kind=\"building\""))
  assert_true(mine.wxml.contains("data-ownership-kind=\"placement\""))
  assert_true(
    mine.wxml.contains(
      "data-target-ref=\"placement:placement-user-a-policy-hall\"",
    ),
  )
  assert_true(mine.wxml.contains("data-ownership-kind=\"book\""))
  assert_true(mine.wxml.contains("data-ownership-kind=\"agent\""))
  assert_true(mine.wxml.contains("Private Agent Lab Book"))
  assert_true(mine.wxml.contains("moontown-owned-entry"))
  assert_true(mine.wxml.contains("moontown-create-drawer"))
}

///|
test "moontown miniapp generates wechat project with backend hooks" {
  let project = demo_wechat_project()
  assert_eq(project.route, "pages/moontown/index")
  assert_eq(project.page_count, 5)
  assert_true(has_file(project.files, "bunnia.runtime.js"))
  assert_true(has_file(project.files, "bunnia.backend.js"))
  assert_true(has_file(project.files, "pages/moontown/home.wxml"))
  assert_true(has_file(project.files, "pages/moontown/discover.wxml"))
  assert_true(has_file(project.files, "pages/moontown/messages.wxml"))
  assert_true(has_file(project.files, "pages/moontown/my.wxml"))
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
      "\"dev-login\":[{k:\"set\",p:\"session.activeUserId\",v:\"user-a\"}]",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/discover.data.js").contains(
      "\"discover-filter-building\":[{k:\"set\",p:\"discover.filter\",v:\"building\"}]",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/messages.data.js").contains(
      "\"notification-channel-agent\":[{k:\"set\",p:\"messages.channel\",v:\"agent\"}]",
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
      "\"ownership-filter-books\":[{k:\"set\",p:\"ownership.filter\",v:\"books\"}]",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/my.data.js").contains(
      "\"ownership-filter-placements\":[]",
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
    file_content(project.files, "pages/moontown/index.data.js").contains(
      "\"create-private-building\"",
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
      "/miniapp/discover/search",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.backend.js").contains(
      "/miniapp/messages/subscribe",
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
      "/miniapp/buildings/archive",
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
      "['runId','reviewId','decision','buildingId','bookId','agentId','targetUserId','noticeId','noticeKind','targetRef']",
    ),
  )
  assert_true(project.page.js.contains("h=b[k]=d[k]"))
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
      "\"archiveDraft\":{\"buildingId\":\"created-agent-lab\"}",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/index.data.js").contains(
      "\"reviewDecision\":{\"reviewId\":\"review-policy-memory\",\"runId\":\"run-policy-review\",\"decision\":\"accept\"}",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/index.data.js").contains(
      "\"lifecycle\":{\"lastAction\":\"\"}",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/index.data.js").contains(
      "\"placements\":[{\"id\":\"placement-user-a-policy-hall\",\"buildingId\":\"policy-hall\",\"layer\":\"personal\",\"status\":\"pinned\"}]",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/index.wxml").contains(
      "data-bunnia-message=\"dev-login\"",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/index.wxml").contains(
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
  assert_true(project.manifest.pages[0].backend_event_count >= 3)
  assert_true(project.manifest.pages[3].backend_event_count >= 2)
  assert_true(project.manifest.pages[0].scene_marker_count >= 8)
  assert_true(project.manifest.pages[0].scene_region_count == 2)
  assert_true(project.manifest.summary.contains("app_files="))
}

///|
test "moontown miniapp projection supports mock user create search and agent flows" {
  let projection = demo_projection()
  assert_eq(projection.users.length(), 2)
  assert_eq(projection.profile.display_name, "Ada Builder")
  assert_eq(projection.roles.length(), 5)
  assert_eq(local_backend_base_url(), "http://127.0.0.1:18191")
  assert_eq(projection.backend_steps.length(), 8)
  assert_eq(projection.backend_steps[0].endpoint_id, "dev-login")
  assert_eq(projection.backend_steps[1].path, "/miniapp/town/snapshot")
  assert_eq(projection.backend_steps[2].status, "guarded")
  assert_eq(projection.backend_steps[4].endpoint_id, "cancel-run")
  assert_eq(projection.backend_steps[5].endpoint_id, "retry-run")
  assert_eq(projection.backend_steps[6].endpoint_id, "ack-notification")
  assert_eq(projection.backend_steps[7].endpoint_id, "request-subscription")
  assert_eq(projection.backend_cache_states.length(), 4)
  assert_eq(projection.backend_cache_states[1].id, "snapshot")
  assert_eq(projection.backend_cache_states[1].state, "stale-safe")
  assert_eq(projection.backend_cache_states[2].source, "request-log")
  assert_true(!profile_ready_to_publish(projection))
  let gates = setup_gates(projection)
  assert_eq(gates.length(), 6)
  assert_eq(gates[0].id, "session")
  assert_true(gates[0].complete)
  assert_eq(gates[1].id, "onboarding")
  assert_true(!gates[1].complete)
  assert_eq(gates[3].id, "consent")
  assert_true(!gates[3].complete)
  assert_eq(gates[5].id, "publish-ready")
  assert_true(!gates[5].complete)
  assert_eq(projection.tabs.length(), 5)
  assert_eq(projection.active_tab_id, "realm")
  assert_true(projection.tabs[2].map_surface)
  assert_eq(projection.onboarding_steps.length(), 4)
  let guides = guide_steps(projection)
  assert_eq(guides.length(), 5)
  assert_eq(guides[0].id, "enter-town")
  assert_eq(guides[0].tab_id, "realm")
  assert_true(!guides[0].complete)
  assert_eq(guides[2].id, "discover-public")
  assert_eq(guides[2].action_message, "tab-discover")
  assert_true(guides[2].complete)
  assert_eq(guides[3].id, "agent-mail")
  assert_eq(guides[3].status, "review")
  assert_eq(guides[4].id, "passport")
  assert_true(!guides[4].complete)
  assert_eq(projection.districts.length(), 5)
  assert_eq(projection.presence.length(), 4)
  assert_eq(projection.notifications.length(), 7)
  assert_eq(projection.notification_channels.length(), 7)
  assert_eq(projection.discovery_items.length(), 10)
  assert_eq(projection.discovery_filters.length(), 7)
  assert_eq(projection.activity_items.length(), 5)
  assert_eq(projection.audit_events.length(), 4)
  assert_eq(projection.books.length(), 7)
  assert_eq(projection.runs.length(), 4)
  assert_eq(projection.reviews.length(), 1)
  assert_eq(unread_notifications(projection).length(), 5)
  assert_eq(subscription_notifications(projection).length(), 1)
  assert_eq(visible_notifications(projection).length(), 7)
  assert_eq(filtered_notifications(projection).length(), 7)
  let agent_notices = switch_notification_channel(projection, "agent")
  assert_eq(selected_notification_channel(agent_notices).id, "agent")
  assert_eq(filtered_notifications(agent_notices).length(), 1)
  assert_eq(filtered_notifications(agent_notices)[0].kind, "agent-run")
  let follow_notices = switch_notification_channel(projection, "follow")
  assert_eq(selected_notification_channel(follow_notices).id, "follow")
  assert_eq(filtered_notifications(follow_notices).length(), 1)
  assert_eq(filtered_notifications(follow_notices)[0].kind, "follow")
  assert_eq(visible_runs(projection).length(), 4)
  assert_eq(visible_reviews(projection).length(), 1)
  assert_eq(active_runs(projection).length(), 3)
  assert_eq(review_runs(projection).length(), 1)
  assert_eq(pending_reviews(projection).length(), 1)
  assert_eq(selected_building_runs(projection).length(), 1)
  let policy_run_actions = run_actions(selected_building_runs(projection)[0])
  assert_eq(policy_run_actions.length(), 5)
  assert_eq(policy_run_actions[0].id, "open-building")
  assert_true(policy_run_actions[0].allowed)
  assert_eq(policy_run_actions[1].id, "review-accept")
  assert_true(policy_run_actions[1].allowed)
  assert_eq(policy_run_actions[2].id, "review-reject")
  assert_true(policy_run_actions[2].allowed)
  assert_eq(policy_run_actions[3].id, "cancel")
  assert_true(!policy_run_actions[3].allowed)
  assert_eq(policy_run_actions[4].id, "retry")
  assert_eq(policy_run_actions[4].message, "retry-run")
  assert_true(!policy_run_actions[4].allowed)
  let running_run_actions = run_actions(active_runs(projection)[1])
  assert_eq(running_run_actions[3].id, "cancel")
  assert_true(running_run_actions[3].allowed)
  assert_eq(running_run_actions[3].message, "cancel-run")
  assert_eq(visible_audit_events(projection).length(), 4)
  assert_eq(selected_building_audit_events(projection).length(), 1)
  assert_eq(owned_audit_events(projection).length(), 2)
  assert_eq(town_activity_items(projection).length(), 5)
  assert_eq(home_town_stats(projection).length(), 5)
  assert_eq(community_presence(projection).length(), 4)
  assert_eq(projection.districts[4].feature_kind, "credential")
  assert_eq(projection.districts[4].action_label, "Verify")
  assert_eq(projection.buildings.length(), 10)
  assert_eq(projection.placements.length(), 1)
  assert_eq(visible_placements(projection).length(), 1)
  assert_eq(placed_buildings(projection).length(), 1)
  assert_eq(placed_buildings(projection)[0].id, "policy-hall")
  assert_true(placement_for_building(projection, "policy-hall") is Some(_))
  assert_true(placement_for_building(projection, "published-agent-lab") is None)
  assert_eq(visible_buildings(projection).length(), 9)
  assert_eq(visible_books(projection).length(), 7)
  assert_eq(selected_building_book(projection).id, "book-policy-hall")
  assert_eq(search_results(projection).length(), 1)
  assert_true(unified_discovery_results(projection).length() >= 6)
  assert_true(filtered_discovery_results(projection).length() >= 6)
  assert_eq(discovery_results_by_kind(projection, "user").length(), 3)
  assert_eq(discovery_results_by_kind(projection, "circle").length(), 2)
  let people = switch_discovery_filter(projection, "user")
  assert_eq(selected_discovery_filter(people).id, "user")
  assert_eq(filtered_discovery_results(people).length(), 3)
  let circles = switch_discovery_filter(projection, "circle")
  assert_eq(selected_discovery_filter(circles).id, "circle")
  assert_eq(filtered_discovery_results(circles).length(), 2)
  let buildings_only = switch_discovery_filter(projection, "building")
  assert_eq(selected_discovery_filter(buildings_only).id, "building")
  assert_eq(filtered_discovery_results(buildings_only).length(), 1)
  let placeable = switch_discovery_filter(projection, "placeable")
  assert_eq(selected_discovery_filter(placeable).id, "placeable")
  assert_eq(filtered_discovery_results(placeable).length(), 1)
  assert_eq(
    filtered_discovery_results(placeable)[0].target_ref,
    "building:published-agent-lab",
  )
  assert_eq(owned_buildings(projection).length(), 1)
  assert_eq(owned_books(projection).length(), 1)
  assert_eq(ownership_stats(projection).length(), 6)
  assert_eq(ownership_stats(projection)[0].id, "placements")
  assert_eq(ownership_stats(projection)[0].value, 1)
  assert_eq(projection.ownership_filters.length(), 6)
  assert_eq(selected_ownership_filter(projection).id, "all")
  assert_eq(ownership_items(projection).length(), 4)
  assert_eq(filtered_ownership_items(projection).length(), 4)
  let placements = switch_ownership_filter(projection, "placements")
  assert_eq(selected_ownership_filter(placements).kind, "placement")
  assert_eq(filtered_ownership_items(placements).length(), 1)
  assert_eq(filtered_ownership_items(placements)[0].title, "Policy Hall")
  let drafts = switch_ownership_filter(projection, "drafts")
  assert_eq(selected_ownership_filter(drafts).id, "drafts")
  assert_eq(filtered_ownership_items(drafts).length(), 3)
  let books = switch_ownership_filter(projection, "books")
  assert_eq(selected_ownership_filter(books).kind, "book")
  assert_eq(filtered_ownership_items(books).length(), 1)
  assert_eq(filtered_ownership_items(books)[0].title, "Private Agent Lab Book")
  let agents = switch_ownership_filter(projection, "agents")
  assert_eq(selected_ownership_filter(agents).kind, "agent")
  assert_eq(filtered_ownership_items(agents).length(), 1)
  assert_eq(filtered_ownership_items(agents)[0].title, "Builder")
  let accepted = accept_review(projection, "review-policy-memory")
  assert_eq(pending_reviews(accepted).length(), 0)
  assert_eq(review_runs(accepted).length(), 0)
  assert_eq(selected_building_book(accepted).accepted_memory_count, 13)
  assert_eq(selected_building_book(accepted).pending_review_count, 0)
  let rejected = reject_review(projection, "review-policy-memory")
  assert_eq(pending_reviews(rejected).length(), 0)
  assert_eq(review_runs(rejected).length(), 0)
  assert_eq(active_runs(rejected).length(), 3)
  assert_eq(selected_building_runs(rejected)[0].status, "rejected")
  let rejected_run_actions = run_actions(selected_building_runs(rejected)[0])
  assert_true(!rejected_run_actions[1].allowed)
  assert_true(!rejected_run_actions[2].allowed)
  assert_true(!rejected_run_actions[3].allowed)
  assert_true(rejected_run_actions[4].allowed)
  let tabbed = switch_tab(projection, "discover")
  assert_eq(tabbed.active_tab_id, "discover")
  let onboarded = complete_onboarding(projection)
  assert_true(onboarded.onboarding_completed)
  let profiled = complete_profile_setup(
    accept_profile_consent(select_role(projection, "explorer")),
  )
  assert_eq(profiled.profile.role_id, "explorer")
  assert_true(profiled.profile.consent_accepted)
  assert_true(profile_ready_to_publish(profiled))
  let ready_gates = setup_gates(profiled)
  assert_true(ready_gates[2].complete)
  assert_true(ready_gates[3].complete)
  assert_true(ready_gates[4].complete)
  assert_true(ready_gates[5].complete)
  let default_actions = selected_building_lifecycle_actions(projection)
  assert_eq(default_actions.length(), 5)
  assert_eq(default_actions[0].id, "ask")
  assert_true(default_actions[0].allowed)
  assert_eq(default_actions[0].book_id, "book-policy-hall")
  assert_eq(default_actions[1].id, "place")
  assert_true(default_actions[1].allowed)
  assert_eq(default_actions[3].id, "publish")
  assert_true(!default_actions[3].allowed)
  assert_eq(default_actions[3].reason, "owner only")
  let default_steps = publication_steps(projection)
  assert_eq(default_steps.length(), 5)
  assert_eq(default_steps[0].id, "draft")
  assert_true(default_steps[0].current)
  assert_true(!default_steps[1].blocked)
  assert_eq(default_steps[2].id, "review")
  let ready_created = create_private_building(
    profiled, "ready-agent-lab", "Ready Agent Lab",
  )
  let ready_actions = selected_building_lifecycle_actions(ready_created)
  assert_true(ready_actions[2].allowed)
  assert_eq(ready_actions[2].reason, "private draft")
  assert_true(ready_actions[3].allowed)
  assert_eq(ready_actions[3].reason, "ready for town")
  assert_true(ready_actions[4].allowed)
  let ready_steps = publication_steps(ready_created)
  assert_true(ready_steps[0].current)
  assert_eq(ready_steps[1].status, "draft")
  let switched = switch_mock_user(projection, "user-b")
  assert_eq(switched.active_user_id, "user-b")
  assert_true(visible_buildings(switched).length() >= 8)
  assert_eq(community_presence(switched).length(), 3)
  assert_eq(visible_notifications(switched).length(), 6)
  assert_eq(unread_notifications(switched).length(), 4)
  let created = create_private_building(
    projection, "created-agent-lab", "Created Agent Lab",
  )
  assert_eq(created.buildings.length(), 11)
  assert_eq(created.books.length(), 8)
  assert_eq(created.audit_events.length(), 5)
  assert_eq(created.selected_building_id, "created-agent-lab")
  assert_eq(selected_building_book(created).id, "book-created-agent-lab")
  assert_eq(selected_building_audit_events(created).length(), 1)
  let shared = share_selected_building(created)
  assert_eq(selected_building(shared).visibility, "shared_private")
  assert_eq(selected_building_book(shared).visibility, "shared_private")
  assert_eq(selected_building_audit_events(shared).length(), 2)
  let shared_steps = publication_steps(shared)
  assert_true(shared_steps[1].current)
  assert_eq(shared_steps[2].summary, "profile setup needed")
  let published = publish_selected_building(shared)
  assert_eq(selected_building(published).visibility, "published")
  assert_eq(search_results(published).length(), 2)
  let published_steps = publication_steps(published)
  assert_true(published_steps[3].current)
  assert_true(published_steps[3].complete)
  let placed = place_published_building(published, "published-agent-lab")
  assert_eq(placed.selected_building_id, "published-agent-lab")
  assert_eq(placed.buildings.length(), published.buildings.length())
  assert_eq(placed.placements.length(), published.placements.length() + 1)
  assert_eq(visible_placements(placed).length(), 2)
  assert_eq(placed_buildings(placed).length(), 2)
  assert_true(placement_for_building(placed, "published-agent-lab") is Some(_))
  assert_eq(selected_building_audit_events(placed).length(), 2)
  let duplicate_placed = place_published_building(placed, "published-agent-lab")
  assert_eq(duplicate_placed.placements.length(), placed.placements.length())
  let archived = archive_selected_building(published)
  assert_eq(selected_building(archived).visibility, "archived")
  assert_eq(visible_buildings(archived).length(), 9)
  let archived_steps = publication_steps(archived)
  assert_true(archived_steps[4].current)
  assert_true(archived_steps[4].blocked)
  let agent_created = create_agent_for_selected(
    created, "agent-created", "Created Agent",
  )
  assert_eq(agent_created.agents.length(), 4)
}

///|
test "moontown miniapp exposes pressure plans for inspect gates" {
  let patch = demo_patch_plan()
  let snapshot = demo_snapshot_delta_plan()
  let agent = demo_agent_delta_plan()
  let communication = demo_communication_plan()
  let backend = @bunnia.plan_backend_contract(demo_backend_contract())
  let effects = demo_effect_plan()
  let scene = demo_scene_render_plan()
  let surface = demo_scene_surface_plan()
  let threads = demo_scene_thread_plan()
  let assets = demo_asset_plan()
  let quality = demo_scene_visual_quality_plan()
  let inspection = demo_project_inspection()
  assert_eq(patch.patches.length(), 3)
  assert_eq(snapshot.deltas.length(), 3)
  assert_eq(agent.deltas.length(), 2)
  assert_eq(communication.total_count, 3)
  assert_eq(communication.unresolved_review_count, 1)
  assert_eq(backend.endpoint_count, 17)
  assert_eq(backend.cancel_count, 1)
  assert_eq(backend.retry_count, 1)
  assert_eq(effects.effect_count, 17)
  assert_true(scene.marker_count >= 8)
  assert_eq(scene.region_count, 2)
  assert_true(!surface.fallback)
  assert_true(threads.total_link_count >= 8)
  assert_eq(assets.assets.length(), 2)
  assert_eq(quality.diagnostics.length(), 0)
  assert_eq(inspection.route_count, 5)
  assert_true(inspection.max_update_payload_bytes > 0)
  assert_true(inspection.max_scene_marker_count >= 4)
}

///|
fn tab_page(
  projection : MiniTownProjection,
  tab_id : String,
) -> @bunnia.WechatPage {
  @bunnia.generate_wechat_page(
    "Moontown Miniapp",
    mini_town_view(switch_tab(projection, tab_id)),
  )
}

///|
fn has_file(files : Array[@bunnia.WechatFile], path : String) -> Bool {
  for item in files {
    if item.path == path {
      return true
    }
  }
  false
}

///|
fn file_content(files : Array[@bunnia.WechatFile], path : String) -> String {
  for item in files {
    if item.path == path {
      return item.content
    }
  }
  ""
}
