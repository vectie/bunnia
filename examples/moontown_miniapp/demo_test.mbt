///|
fn has_no_forbidden_ordinary_copy(wxml : String) -> Bool {
  let mut ok = true
  for
    label in [
      "Backend Loop", "DevTools target", "runtime filter", "runtime channel", "runtime role",
      "backendStatus.load_town_snapshot", "backendStatus.load_message_center", "Ack Sync",
      "Tool Ack", "Ops Desk", "Own Sync", "Tool Results", "UID:user-a / avatar://ada",
      "GET /miniapp/town/snapshot / ready", "POST /miniapp/runs/cancel / guarded",
      "POST /miniapp/runs/retry / guarded", "POST /miniapp/messages/ack / ready",
      "POST /miniapp/messages/subscribe / platform", "Developer Diagnostics", "Endpoint id",
      "HTTP path", "payload key", "response key", "package diagnostics", "render diagnostics",
      "data-ops-desk=\"admin\"", "data-diagnostics-mode=\"reviewer\"", "data-backend-step=\"admin-ops\"",
      "data-backend-step=\"admin-readiness\"", "data-backend-endpoint=\"load-admin-ops\"",
      "data-backend-readiness-endpoint", "data-backend-path=\"/miniapp/admin/ops\"",
      "data-backend-readiness-path", "adminOpsQuery", "adminReadinessQuery", "adminOpsResult",
      "adminReadinessResult", "rate-limit bucket", "audit retention", "recovery",
      "secrets",
    ] {
    if wxml.contains(label) {
      ok = false
    }
  }
  ok
}

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
  assert_true(page.wxml.contains("Town Gate"))
  assert_true(!page.wxml.contains("System Gateway"))
  assert_true(page.wxml.contains("moontown-thread-pin"))
  assert_true(page.wxml.contains("Review"))
  assert_true(page.wxml.contains("Open"))
  assert_true(
    page.wxml.contains("moontown-map-marker bunnia-status-review selected"),
  )
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
  assert_true(page.wxml.contains("moontown-object-drawer"))
  assert_true(page.wxml.contains("data-object-drawer=\"building\""))
  assert_true(page.wxml.contains("moontown-object-header"))
  assert_true(page.wxml.contains("moontown-object-badge"))
  assert_true(page.wxml.contains("kind-category"))
  assert_true(page.wxml.contains("moontown-object-stats"))
  assert_true(page.wxml.contains("2 books - 1 worker - 1 work item"))
  assert_true(page.wxml.contains("Visitor"))
  assert_true(page.wxml.contains("Public place can be opened and placed"))
  assert_true(page.wxml.contains("Memory Shelf"))
  assert_true(page.wxml.contains("data-object-section=\"memory-shelf\""))
  assert_true(page.wxml.contains("Agent Workers"))
  assert_true(page.wxml.contains("moontown-worker-entry"))
  assert_true(!page.wxml.contains("data-agent-id=\"agent-policy-guide\""))
  assert_true(page.wxml.contains("Latest work: Policy answer review"))
  assert_true(page.wxml.contains("Message"))
  assert_true(page.wxml.contains("Review Work"))
  assert_true(page.wxml.contains("Lifecycle Stamps"))
  assert_true(page.wxml.contains("data-object-section=\"lifecycle\""))
  assert_true(page.wxml.contains("Communication Context"))
  assert_true(!page.wxml.contains("system notices"))
  assert_true(page.wxml.contains("data-object-section=\"communication\""))
  assert_true(page.wxml.contains("Report Concern"))
  assert_true(!page.wxml.contains("Safety Desk"))
  assert_true(!page.wxml.contains("data-moderation-"))
  assert_true(page.wxml.contains("data-safety-report-building=\"policy-hall\""))
  assert_true(page.wxml.contains("data-safety-report-count=\"1\""))
  assert_true(
    page.wxml.contains("data-bunnia-message=\"report-public-building\""),
  )
  assert_true(page.wxml.contains("moontown-book-entry"))
  assert_true(page.wxml.contains("Policy Hall Book"))
  assert_true(page.wxml.contains("Policy Source Shelf"))
  assert_true(!page.wxml.contains("data-book-id=\"book-policy-hall\""))
  assert_true(!page.wxml.contains("data-book-id=\"book-policy-hall-sources\""))
  assert_true(page.wxml.contains("data-book-shelf-role=\"primary\""))
  assert_true(page.wxml.contains("data-book-shelf-role=\"support\""))
  assert_true(page.wxml.contains("12 memories - 1 review - Needs review"))
  assert_true(page.wxml.contains("9 memories - no reviews - Ready"))
  assert_true(page.wxml.contains("Read"))
  assert_true(page.wxml.contains("Open Place"))
  assert_true(page.wxml.contains("moontown-lifecycle-actions"))
  assert_true(page.wxml.contains("data-lifecycle-action=\"ask\""))
  assert_true(page.wxml.contains("data-lifecycle-action=\"edit\""))
  assert_true(page.wxml.contains("data-lifecycle-action=\"submit\""))
  assert_true(page.wxml.contains("data-lifecycle-action=\"publish\""))
  assert_true(
    page.wxml.contains("data-bunnia-message=\"update-private-building\""),
  )
  assert_true(!page.wxml.contains("data-target-ref=\"building:policy-hall\""))
  assert_true(!page.wxml.contains("data-book-id=\"book-policy-hall\""))
  assert_true(page.wxml.contains("moontown-lifecycle-action blocked"))
  assert_true(page.wxml.contains("data-allowed=\"false\""))
  assert_true(!page.wxml.contains("data-blocked-reason=\"owner only\""))
  assert_true(page.wxml.contains("Owner only"))
  assert_true(page.wxml.contains("moontown-lifecycle-stamp"))
  assert_true(page.wxml.contains("disabled=\"true\""))
  assert_true(page.wxml.contains("moontown-object-message"))
  assert_true(page.wxml.contains("Place message - Policy Hall"))
  assert_true(page.wxml.contains("Policy Guide"))
  assert_true(page.wxml.contains("moontown-run-entry"))
  assert_true(page.wxml.contains("Policy answer review"))
  assert_true(!page.wxml.contains("data-run-id=\"run-policy-review\""))
  assert_true(
    !page.wxml.contains("data-artifact-ref=\"artifact://book-policy-hall\""),
  )
  assert_true(!page.wxml.contains("data-actor-id="))
  assert_true(!page.wxml.contains("artifact://book-policy-hall"))
  assert_true(page.wxml.contains("Lifecycle Stamps"))
  assert_true(page.wxml.contains("moontown-audit-entry"))
  assert_true(page.wxml.contains("Policy answer entered review"))
  assert_true(!page.wxml.contains("data-audit-id=\"audit-policy-review\""))
  assert_true(page.wxml.contains("moontown-chat-drawer"))
  assert_true(
    !page.wxml.contains("data-backend-endpoint=\"send-building-message\""),
  )
  assert_true(
    !page.wxml.contains("data-backend-path=\"/miniapp/messages/send\""),
  )
  assert_true(
    page.wxml.contains(
      "Latest message, agent work, and review trail stay tied to this place.",
    ),
  )
  assert_true(
    !page.wxml.contains(
      "runtime: {{backendStatus.send_building_message.state || 'idle'}}",
    ),
  )
  assert_true(
    page.wxml.contains("data-bunnia-message=\"send-building-message\""),
  )
  assert_true(!page.wxml.contains("moontown-search-drawer"))
  assert_true(!page.wxml.contains("moontown-create-drawer"))
  assert_true(page.wxml.contains("moontown-map-state-strip"))
  assert_true(page.wxml.contains("moontown-map-state-chip"))
  assert_true(page.wxml.contains("moontown-map-action-rail"))
  assert_true(page.wxml.contains("data-selected-building-id=\"policy-hall\""))
  assert_true(!page.wxml.contains("data-visibility=\"private_draft\""))
  assert_true(!page.wxml.contains("data-visibility=\"published\""))
  assert_true(page.wxml.contains("select-policy-hall"))
  assert_true(page.wxml.contains("ask-selected-building"))
  assert_true(!page.wxml.contains("create-private-building"))
  assert_true(!page.wxml.contains("create-agent"))
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
  assert_true(page.wxss.contains("env(safe-area-inset-top)"))
  assert_true(page.wxss.contains("env(safe-area-inset-bottom)"))
  assert_true(page.wxss.contains("button:active{opacity:0.82"))
  assert_true(!page.wxss.contains("button:active{transform"))
  assert_true(
    page.wxss.contains("button[disabled],.bunnia-status-disabled{opacity:0.52"),
  )
  assert_true(page.wxss.contains("min-height:72rpx"))
  assert_true(page.wxss.contains("overflow-wrap:anywhere"))
  assert_true(page.wxss.contains("box-shadow:0 2rpx 0"))
  assert_true(
    page.wxss.contains(
      ".bunnia-status-review,.bunnia-status-stale,.bunnia-status-waiting",
    ),
  )
  assert_true(page.js.contains("__bunniaEventPatches"))
  assert_true(page.js.contains("\"tab-realm\""))
  assert_true(page.js.contains("\"complete-onboarding\""))
  assert_true(page.js.contains("\"switch-user-a\""))
  assert_true(page.js.contains("\"switch-user-b\""))
  assert_true(page.js.contains("\"enter-town\""))
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
  assert_true(page.js.contains("\"place-published-building\""))
  assert_true(page.js.contains("\"share-private-building\""))
  assert_true(page.js.contains("\"publish-private-building\""))
  assert_true(page.js.contains("\"archive-private-building\""))
  assert_true(
    page.wxml.contains("data-bunnia-message=\"restore-archived-building\""),
  )
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
  assert_true(has_no_forbidden_ordinary_copy(realm.wxml))
  assert_true(realm.wxml.contains("moontown-map-fullscreen"))
  assert_true(realm.wxml.contains("moontown-left-hud"))
  assert_true(realm.wxml.contains("moontown-right-hud"))
  assert_true(realm.wxml.contains("moontown-map-state-strip"))
  assert_true(realm.wxml.contains("moontown-map-action-rail"))
  assert_true(
    realm.wxml.contains("moontown-map-marker bunnia-status-review selected"),
  )
  assert_true(realm.wxml.contains("Policy Hall: Review"))
  assert_true(realm.wxml.contains("Ask"))
  assert_true(realm.wxml.contains("Messages"))
  assert_true(realm.wxml.contains("Find"))
  assert_true(!realm.wxml.contains("moontown-search-drawer"))
  assert_true(!realm.wxml.contains("moontown-create-drawer"))
  assert_true(!realm.wxml.contains("data-backend-endpoint="))
  assert_true(!realm.wxml.contains("data-backend-path="))
  assert_true(realm.wxml.contains("data-bunnia-route=\"pages/moontown/home\""))
  assert_true(
    realm.wxml.contains("data-bunnia-route=\"pages/moontown/messages\""),
  )
  assert_true(!realm.wxml.contains("moontown-page-surface"))
  assert_true(realm.wxml.contains("data-map-surface=\"true\""))
  assert_true(!realm.wxml.contains("Map Districts"))
  assert_true(!realm.wxml.contains("Community Hub"))

  let home = tab_page(projection, "home")
  assert_true(has_no_forbidden_ordinary_copy(home.wxml))
  assert_true(home.wxml.contains("moontown-map-fullscreen"))
  assert_true(home.wxml.contains("moontown-page-surface"))
  assert_true(home.wxml.contains("data-active-tab=\"home\""))
  assert_true(home.wxml.contains("Town Pulse"))
  assert_true(home.wxml.contains("data-home-pulse=\"changes\""))
  assert_true(home.wxml.contains("3 places changed"))
  assert_true(home.wxml.contains("Policy answer waiting for review"))
  assert_true(home.wxml.contains("data-home-pulse=\"attention\""))
  assert_true(home.wxml.contains("Agent needs your decision"))
  assert_true(home.wxml.contains("Review policy answer"))
  assert_true(home.wxml.contains("data-home-pulse=\"market\""))
  assert_true(home.wxml.contains("Market has new public places"))
  assert_true(home.wxml.contains("More - Discover"))
  assert_true(home.wxml.contains("data-home-pulse=\"refresh\""))
  assert_true(home.wxml.contains("Some updates need refresh"))
  assert_true(home.wxml.contains("Try again - Realm"))
  assert_true(!home.wxml.contains("data-action-message=\"refresh-town\""))
  assert_true(home.wxml.contains("data-target-tab=\"realm\""))
  assert_true(home.wxml.contains("data-target-tab=\"messages\""))
  assert_true(home.wxml.contains("data-target-tab=\"discover\""))
  assert_true(home.wxml.contains("data-bunnia-message=\"tab-realm\""))
  assert_true(home.wxml.contains("data-bunnia-message=\"tab-messages\""))
  assert_true(home.wxml.contains("data-bunnia-message=\"tab-discover\""))
  assert_true(!home.wxml.contains("Town Updates"))
  assert_true(!home.wxml.contains("Recent Activity"))
  assert_true(!home.wxml.contains("Refresh stale town"))
  assert_true(!home.wxml.contains("data-backend-step="))
  assert_true(!home.wxml.contains("data-backend-cache="))
  assert_true(!home.wxml.contains("data-cache-state="))
  assert_true(!home.wxml.contains("load-town-snapshot"))
  assert_true(!home.wxml.contains("Backend Loop"))
  assert_true(!home.wxml.contains("DevTools target"))
  assert_true(
    !home.wxml.contains(
      "runtime: {{backendStatus.load_town_snapshot.state || 'idle'}}",
    ),
  )
  assert_true(home.wxml.contains("Community Hub"))
  assert_true(
    home.wxml.contains(
      "Reference feature pages become tile districts on the map.",
    ),
  )
  assert_true(home.wxml.contains("data-feature-kind=\"market\""))
  assert_true(home.wxml.contains("feature-market tone-blue"))
  assert_true(home.wxml.contains("data-district-filter=\"product\""))
  assert_true(home.wxml.contains("data-district-query=\"product\""))
  assert_true(home.wxml.contains("data-district-accent=\"blue\""))
  assert_true(
    home.wxml.contains("data-bunnia-message=\"discover-filter-product\""),
  )
  assert_true(home.wxml.contains("data-action-message=\"tab-discover\""))
  assert_true(home.wxml.contains("data-target-tab=\"discover\""))
  assert_true(home.wxml.contains("data-feature-kind=\"credential\""))
  assert_true(home.wxml.contains("data-district-query=\"trust policy\""))
  assert_true(home.wxml.contains("data-action-message=\"tab-my\""))
  assert_true(home.wxml.contains("Town Trust"))
  assert_true(!home.wxml.contains("OPC Hub"))
  assert_true(home.wxml.contains("8 checks - Verify My"))
  assert_true(home.wxml.contains("moontown-presence-chip"))
  assert_true(home.wxml.contains("data-presence-id=\"presence-policy-guide\""))
  assert_true(home.wxml.contains("data-actor-kind=\"agent\""))
  assert_true(home.wxml.contains("My holds profile setup"))
  assert_true(!home.wxml.contains("My holds profile readiness"))
  assert_true(home.wxml.contains("Search Town"))
  assert_true(home.wxml.contains("Publish Draft"))
  assert_true(!home.wxml.contains("Map Districts"))
  assert_true(!home.wxml.contains("moontown-right-hud"))

  let discover = tab_page(projection, "discover")
  assert_true(has_no_forbidden_ordinary_copy(discover.wxml))
  assert_true(discover.wxml.contains("moontown-map-fullscreen"))
  assert_true(discover.wxml.contains("moontown-page-surface"))
  assert_true(discover.wxml.contains("data-active-tab=\"discover\""))
  assert_true(discover.wxml.contains("Market Board"))
  assert_true(
    discover.wxml.contains(
      "Find public places, people, books, agents, demands, and events.",
    ),
  )
  assert_true(
    !discover.wxml.contains("runtime filter: {{discover.filter || 'all'}}"),
  )
  assert_true(discover.wxml.contains("moontown-discover-entry"))
  assert_true(discover.wxml.contains("Town People"))
  assert_true(discover.wxml.contains("Town Circles"))
  assert_true(discover.wxml.contains("Town Market"))
  assert_true(discover.wxml.contains("moontown-discovery-chip"))
  assert_true(discover.wxml.contains("Deep Cultivator"))
  assert_true(discover.wxml.contains("AI Exploration Camp"))
  assert_true(discover.wxml.contains("Agent Publishing Kit"))
  assert_true(discover.wxml.contains("data-discovery-kind=\"product\""))
  assert_true(
    discover.wxml.contains("data-target-ref=\"product:agent-publishing-kit\""),
  )
  assert_true(discover.wxml.contains("Open Product"))
  assert_true(discover.wxml.contains("data-discovery-action=\"open\""))
  assert_true(discover.wxml.contains("data-bunnia-message=\"discover-action\""))
  assert_true(discover.wxml.contains("Answer Demand"))
  assert_true(discover.wxml.contains("data-discovery-action=\"request\""))
  assert_true(discover.wxml.contains("data-bunnia-message=\"discover-action\""))
  assert_true(discover.wxml.contains("Team Studio Session"))
  assert_true(discover.wxml.contains("data-discovery-kind=\"event\""))
  assert_true(discover.wxml.contains("Join Event"))
  assert_true(discover.wxml.contains("data-discovery-action=\"join\""))
  assert_true(discover.wxml.contains("data-bunnia-message=\"discover-action\""))
  assert_true(discover.wxml.contains("Read Note"))
  assert_true(discover.wxml.contains("data-discovery-action=\"read\""))
  assert_true(discover.wxml.contains("data-bunnia-message=\"discover-action\""))
  assert_true(discover.wxml.contains("discover-search"))
  assert_true(discover.wxml.contains("moontown-discovery-filter active"))
  assert_true(discover.wxml.contains("data-filter-id=\"user\""))
  assert_true(discover.wxml.contains("data-filter-id=\"circle\""))
  assert_true(discover.wxml.contains("data-filter-id=\"product\""))
  assert_true(discover.wxml.contains("data-filter-id=\"demand\""))
  assert_true(discover.wxml.contains("data-filter-id=\"event\""))
  assert_true(discover.wxml.contains("data-filter-id=\"post\""))
  assert_true(discover.wxml.contains("data-filter-id=\"placeable\""))
  assert_true(!discover.wxml.contains("data-filter-kind="))
  assert_true(discover.wxml.contains("moontown-discovery-badges"))
  assert_true(discover.wxml.contains("moontown-discovery-badge kind-access"))
  assert_true(
    discover.wxml.contains("moontown-discovery-badge kind-eligibility"),
  )
  assert_true(discover.wxml.contains("Public"))
  assert_true(discover.wxml.contains("Can open"))
  assert_true(discover.wxml.contains("Published Agent Lab"))
  assert_true(discover.wxml.contains("data-discovery-kind=\"building\""))
  assert_true(discover.wxml.contains("Open Place"))
  assert_true(
    discover.wxml.contains(
      "data-bunnia-message=\"open-place-published-agent-lab\"",
    ),
  )
  assert_true(discover.wxml.contains("data-place-destination=\"Realm\""))
  assert_true(discover.wxml.contains("Place On Map"))
  assert_true(
    discover.wxml.contains("data-building-id=\"published-agent-lab\""),
  )
  assert_true(discover.wxml.contains("Can place"))
  assert_true(!discover.wxml.contains("data-placement-state="))
  assert_true(!discover.wxml.contains("data-placement-layer="))
  assert_true(!discover.wxml.contains("data-placement-source="))
  assert_true(!discover.wxml.contains("data-placement-x="))
  assert_true(!discover.wxml.contains("data-placement-y="))
  assert_true(discover.wxml.contains("Watch"))
  assert_true(
    discover.wxml.contains("data-bunnia-message=\"request-subscription\""),
  )
  assert_true(discover.wxml.contains("data-notice-kind=\"subscription\""))
  assert_true(discover.wxml.contains("data-notice-id=\"notice-subscribe\""))
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
  assert_true(has_no_forbidden_ordinary_copy(messages.wxml))
  assert_true(messages.wxml.contains("data-active-tab=\"messages\""))
  assert_true(messages.wxml.contains("Attention Center"))
  assert_true(
    !messages.wxml.contains("runtime channel: {{messages.channel || 'all'}}"),
  )
  assert_true(messages.wxml.contains("moontown-message-bucket"))
  assert_true(!messages.wxml.contains("moontown-message-sync"))
  assert_true(!messages.wxml.contains("data-backend-sync="))
  assert_true(!messages.wxml.contains("data-backend-endpoint="))
  assert_true(!messages.wxml.contains("data-backend-path="))
  assert_true(messages.wxml.contains("Latest Messages"))
  assert_true(messages.wxml.contains("More"))
  assert_true(messages.wxml.contains("Mark Read"))
  assert_true(messages.wxml.contains("Review Result"))
  assert_true(!messages.wxml.contains("Ack Sync"))
  assert_true(!messages.wxml.contains("Tool Ack"))
  assert_true(
    !messages.wxml.contains(
      "{{backendStatus.load_message_center.state || 'idle'}}",
    ),
  )
  assert_true(
    messages.wxml.contains("data-bunnia-message=\"load-message-center\""),
  )
  assert_true(
    !messages.wxml.contains(
      "{{backendStatus.ack_notification.state || 'idle'}}",
    ),
  )
  assert_true(
    !messages.wxml.contains(
      "{{backendStatus.request_subscription.state || 'idle'}}",
    ),
  )
  assert_true(messages.wxml.contains("Needs Review"))
  assert_true(messages.wxml.contains("Agent Replies"))
  assert_true(messages.wxml.contains("Interactions"))
  assert_true(messages.wxml.contains("Town Notices"))
  assert_true(messages.wxml.contains("Failed Actions"))
  assert_true(!messages.wxml.contains("New Follows"))
  assert_true(!messages.wxml.contains("data-channel-id="))
  assert_true(!messages.wxml.contains("data-channel-kind="))
  assert_true(messages.wxml.contains("moontown-message-channel active"))
  assert_true(messages.wxml.contains("Deep Cultivator followed your town"))
  assert_true(messages.wxml.contains("Enterprise Club replied"))
  assert_true(messages.wxml.contains("Memory review needed"))
  assert_true(messages.wxml.contains("Agent work completed"))
  assert_true(!messages.wxml.contains("Agent run completed"))
  assert_true(!messages.wxml.contains("data-notice-kind="))
  assert_true(messages.wxml.contains("Agent Work"))
  assert_true(
    messages.wxml.contains(
      "Agent work stays attached to places, books, and review decisions.",
    ),
  )
  assert_true(messages.wxml.contains("Market placement scan"))
  assert_true(!messages.wxml.contains("data-run-id="))
  assert_true(!messages.wxml.contains("moontown-chat-drawer"))
  assert_true(!messages.wxml.contains("data-thread-id=\"thread-market-scan\""))
  assert_true(!messages.wxml.contains("data-artifact-ref="))
  assert_true(!messages.wxml.contains("data-review-required="))
  assert_true(
    messages.wxml.contains("In progress - Market Square - Market Square Ledger"),
  )
  assert_true(messages.wxml.contains("moontown-run-actions"))
  assert_true(messages.wxml.contains("data-run-action=\"open-building\""))
  assert_true(messages.wxml.contains("data-run-action=\"review-accept\""))
  assert_true(messages.wxml.contains("data-run-action=\"review-reject\""))
  assert_true(messages.wxml.contains("data-run-action=\"cancel\""))
  assert_true(messages.wxml.contains("data-run-action=\"retry\""))
  assert_true(!messages.wxml.contains("data-target-ref=\"run:"))
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
  assert_true(messages.wxml.contains("Stop Work"))
  assert_true(messages.wxml.contains("Try Again"))
  assert_true(messages.wxml.contains("data-blocked-reason=\"wait for status\""))
  assert_true(messages.wxml.contains("Agent Results"))
  assert_true(!messages.wxml.contains("Review Results"))
  assert_true(!messages.wxml.contains("Tool Results"))
  assert_true(!messages.wxml.contains("bunnia-tool-result-card"))
  assert_true(!messages.wxml.contains("data-tool-result-id="))
  assert_true(!messages.wxml.contains("data-tool-name="))
  assert_true(messages.wxml.contains("moontown-agent-result"))
  assert_true(messages.wxml.contains("Policy source summary"))
  assert_true(messages.wxml.contains("Open Place"))
  assert_true(messages.wxml.contains("data-bunnia-message=\"ack-tool-result\""))
  assert_true(messages.wxml.contains("Needs Review"))
  assert_true(
    messages.wxml.contains(
      "Approve useful memory or reject work before it enters town books.",
    ),
  )
  assert_true(messages.wxml.contains("Waiting for review - +1 memory"))
  assert_true(!messages.wxml.contains("pending - +1 memory"))
  assert_true(!messages.wxml.contains("data-review-id="))
  assert_true(messages.wxml.contains("data-decision=\"accept\""))
  assert_true(messages.wxml.contains("data-decision=\"reject\""))
  assert_true(!messages.wxml.contains("Moderation Desk"))
  assert_true(!messages.wxml.contains("data-moderation-case="))
  assert_true(!messages.wxml.contains("data-moderation-action="))
  assert_true(
    !messages.wxml.contains("data-bunnia-message=\"hide-public-building\""),
  )
  assert_true(
    !messages.wxml.contains("data-bunnia-message=\"takedown-public-building\""),
  )
  assert_true(
    !messages.wxml.contains("data-bunnia-message=\"appeal-moderation-case\""),
  )
  assert_true(messages.wxml.contains("Subscribe to town signals"))
  assert_true(messages.wxml.contains("data-notice-action=\"open\""))
  assert_true(messages.wxml.contains("data-notice-action=\"ack\""))
  assert_true(messages.wxml.contains("data-place-destination=\"Realm\""))
  assert_true(
    messages.wxml.contains("data-bunnia-message=\"open-place-policy-hall\""),
  )
  assert_true(!messages.wxml.contains("data-notice-id="))
  assert_true(!messages.wxml.contains("data-notice-kind="))
  assert_true(
    !messages.wxml.contains("data-target-ref=\"subscription:wechat\""),
  )
  assert_true(!messages.wxml.contains("data-action-message="))
  assert_true(
    messages.wxml.contains("data-bunnia-message=\"open-notice-review\""),
  )
  assert_true(
    messages.wxml.contains("data-bunnia-message=\"request-subscription\""),
  )
  assert_true(
    messages.wxml.contains("data-bunnia-message=\"ack-notification\""),
  )
  assert_true(
    messages.wxml.contains("data-bunnia-message=\"request-subscription\""),
  )
  assert_true(!messages.wxml.contains("data-requires-subscription="))
  assert_true(messages.wxml.contains("data-building-id=\"policy-hall\""))
  assert_true(!messages.wxml.contains("moontown-chat-drawer"))
  assert_true(!messages.wxml.contains("moontown-bottom-hud"))

  let mine = tab_page(projection, "my")
  assert_true(has_no_forbidden_ordinary_copy(mine.wxml))
  assert_true(mine.wxml.contains("data-active-tab=\"my\""))
  assert_true(mine.wxml.contains("Identity Setup"))
  assert_true(
    !mine.wxml.contains("runtime role: {{profile.roleId || 'builder'}}"),
  )
  assert_true(!mine.wxml.contains("own: {{ownership.filter || 'all'}}"))
  assert_true(mine.wxml.contains("My Inventory"))
  assert_true(mine.wxml.contains("Town passport, setup stamps, and"))
  assert_true(mine.wxml.contains("owned items."))
  assert_true(mine.wxml.contains("data-setup-gate=\"session\""))
  assert_true(mine.wxml.contains("data-setup-gate=\"publish-ready\""))
  assert_true(mine.wxml.contains("Town Entry"))
  assert_true(mine.wxml.contains("Entered as Ada Builder."))
  assert_true(!mine.wxml.contains("Logged in as user-a"))
  assert_true(mine.wxml.contains("Town Role"))
  assert_true(mine.wxml.contains("Role selected: Builder."))
  assert_true(!mine.wxml.contains("Role selected: builder."))
  assert_true(mine.wxml.contains("Ready to Publish"))
  assert_true(
    mine.wxml.contains(
      "Publishing stays blocked until role, consent, and profile are ready.",
    ),
  )
  assert_true(mine.wxml.contains("data-complete=\"false\""))
  assert_true(
    mine.wxml.contains("data-bunnia-message=\"accept-profile-consent\""),
  )
  assert_true(mine.wxml.contains("moontown-profile-card"))
  assert_true(!mine.wxml.contains("data-profile-user-id="))
  assert_true(!mine.wxml.contains("data-profile-role="))
  assert_true(!mine.wxml.contains("data-profile-ready="))
  assert_true(mine.wxml.contains("data-passport-ready=\"false\""))
  assert_true(mine.wxml.contains("Town passport - needs setup"))
  assert_true(mine.wxml.contains("moontown-profile-metric"))
  assert_true(mine.wxml.contains("Followers"))
  assert_true(mine.wxml.contains("Published"))
  assert_true(mine.wxml.contains("data-bunnia-message=\"save-profile\""))
  assert_true(mine.wxml.contains("Public Passport"))
  assert_true(!mine.wxml.contains("data-public-passport="))
  assert_true(!mine.wxml.contains("data-public-passport-items="))
  assert_true(!mine.wxml.contains("data-public-passport-item="))
  assert_true(mine.wxml.contains("data-passport-section=\"public\""))
  assert_true(mine.wxml.contains("data-passport-count=\"4\""))
  assert_true(
    mine.wxml.contains("Public-facing identity without private work."),
  )
  assert_true(mine.wxml.contains("No published places - 1 watch - 1 review"))
  assert_true(mine.wxml.contains("data-passport-kind=\"profile\""))
  assert_true(mine.wxml.contains("data-passport-kind=\"building\""))
  assert_true(mine.wxml.contains("data-passport-kind=\"watch\""))
  assert_true(mine.wxml.contains("data-passport-kind=\"review\""))
  assert_true(mine.wxml.contains("Profile incomplete"))
  assert_true(mine.wxml.contains("No published places"))
  assert_true(mine.wxml.contains("1 watched town link"))
  assert_true(!mine.wxml.contains("1 watched town links"))
  assert_true(mine.wxml.contains("1 review signal"))
  assert_true(!mine.wxml.contains("1 review signals"))
  assert_true(!mine.wxml.contains("data-target-ref=\"review:pending\""))
  assert_true(mine.wxml.contains("data-bunnia-message=\"tab-discover\""))
  assert_true(mine.wxml.contains("data-bunnia-message=\"tab-messages\""))
  assert_true(mine.wxml.contains("moontown-credential-plaque"))
  assert_true(mine.wxml.contains("Town Credential"))
  assert_true(
    mine.wxml.contains(
      "Town Trust: Registration, policy, and public trust checks.",
    ),
  )
  assert_true(!mine.wxml.contains("OPC Credential"))
  assert_true(!mine.wxml.contains("OPC Hub"))
  assert_true(mine.wxml.contains("data-feature-kind=\"credential\""))
  assert_true(mine.wxml.contains("data-target-building-id=\"policy-hall\""))
  assert_true(mine.wxml.contains("data-bunnia-message=\"select-policy-hall\""))
  assert_true(mine.wxml.contains("Placed - My map - Open in Realm"))
  assert_true(!mine.wxml.contains("placement - personal"))
  assert_true(mine.wxml.contains("Inventory Refresh"))
  assert_true(mine.wxml.contains("Refresh My Stuff"))
  assert_true(mine.wxml.contains("My Inventory - Waiting"))
  assert_true(!mine.wxml.contains("Own Sync"))
  assert_true(!mine.wxml.contains("data-backend-step=\"ownership\""))
  assert_true(
    !mine.wxml.contains("data-backend-endpoint=\"load-ownership-snapshot\""),
  )
  assert_true(
    !mine.wxml.contains("data-backend-path=\"/miniapp/me/ownership\""),
  )
  assert_true(!mine.wxml.contains("data-backend-method="))
  assert_true(!mine.wxml.contains("data-backend-cache="))
  assert_true(!mine.wxml.contains("data-cursor="))
  assert_true(!mine.wxml.contains("data-limit="))
  assert_true(
    mine.wxml.contains("data-bunnia-message=\"load-ownership-snapshot\""),
  )
  assert_true(mine.wxml.contains("Reviewer Tools"))
  assert_true(mine.wxml.contains("data-reviewer-tools-gate=\"closed\""))
  assert_true(mine.wxml.contains("Open Reviewer Tools"))
  assert_true(!mine.wxml.contains("Open Reviewer Mode"))
  assert_true(!mine.wxml.contains("Ops Desk"))
  assert_true(!mine.wxml.contains("data-ops-desk=\"admin\""))
  assert_true(!mine.wxml.contains("data-backend-step=\"admin-ops\""))
  assert_true(!mine.wxml.contains("data-backend-endpoint=\"load-admin-ops\""))
  assert_true(!mine.wxml.contains("data-backend-path=\"/miniapp/admin/ops\""))
  assert_true(!mine.wxml.contains("data-target-ref=\"backend:"))
  assert_true(!mine.wxml.contains("data-target-ref=\"profile:"))
  assert_true(!mine.wxml.contains("data-target-ref=\"building:"))
  assert_true(!mine.wxml.contains("data-target-ref=\"book:"))
  assert_true(!mine.wxml.contains("data-target-ref=\"agent:"))
  assert_true(!mine.wxml.contains("data-target-ref=\"run:"))
  assert_true(!mine.wxml.contains("data-action-message="))
  assert_true(!mine.wxml.contains("Local cache"))
  let reviewer_mine = tab_page(open_reviewer_tools(projection), "my")
  assert_true(reviewer_mine.wxml.contains("Reviewer Tools"))
  assert_true(reviewer_mine.wxml.contains("Reviewer Mode"))
  assert_true(reviewer_mine.wxml.contains("data-diagnostics-mode=\"reviewer\""))
  assert_true(
    reviewer_mine.wxml.contains("data-diagnostics-source=\"reviewer-route\""),
  )
  assert_true(reviewer_mine.wxml.contains("Source: reviewer route"))
  assert_true(!reviewer_mine.wxml.contains("Ops Desk"))
  assert_true(reviewer_mine.wxml.contains("data-ops-desk=\"admin\""))
  assert_true(reviewer_mine.wxml.contains("data-backend-step=\"admin-ops\""))
  assert_true(
    reviewer_mine.wxml.contains("data-backend-endpoint=\"load-admin-ops\""),
  )
  assert_true(
    reviewer_mine.wxml.contains(
      "data-backend-readiness-endpoint=\"load-admin-readiness\"",
    ),
  )
  assert_true(
    reviewer_mine.wxml.contains("data-backend-path=\"/miniapp/admin/ops\""),
  )
  assert_true(
    reviewer_mine.wxml.contains(
      "data-backend-readiness-path=\"/miniapp/admin/readiness\"",
    ),
  )
  assert_true(
    reviewer_mine.wxml.contains("data-diagnostic-section=\"Town Safety\""),
  )
  assert_true(
    reviewer_mine.wxml.contains("data-diagnostic-section=\"Launch Checks\""),
  )
  assert_true(reviewer_mine.wxml.contains("health"))
  assert_true(reviewer_mine.wxml.contains("incidents"))
  assert_true(reviewer_mine.wxml.contains("audit retention"))
  assert_true(reviewer_mine.wxml.contains("recovery"))
  assert_true(reviewer_mine.wxml.contains("rate-limit bucket"))
  assert_true(reviewer_mine.wxml.contains("secrets"))
  assert_true(reviewer_mine.wxml.contains("Reviewer Actions"))
  assert_true(
    reviewer_mine.wxml.contains(
      "Review, hide, takedown, release hold, resolve incident, and check readiness.",
    ),
  )
  assert_true(reviewer_mine.wxml.contains("Moderation Desk"))
  assert_true(
    reviewer_mine.wxml.contains("data-moderation-case=\"mod-policy-hall\""),
  )
  assert_true(reviewer_mine.wxml.contains("data-moderation-action=\"hide\""))
  assert_true(
    reviewer_mine.wxml.contains("data-moderation-action=\"takedown\""),
  )
  assert_true(reviewer_mine.wxml.contains("data-moderation-action=\"appeal\""))
  assert_true(
    reviewer_mine.wxml.contains("data-bunnia-message=\"hide-public-building\""),
  )
  assert_true(
    reviewer_mine.wxml.contains(
      "data-bunnia-message=\"takedown-public-building\"",
    ),
  )
  assert_true(
    reviewer_mine.wxml.contains(
      "data-bunnia-message=\"appeal-moderation-case\"",
    ),
  )
  assert_true(reviewer_mine.wxml.contains("Developer Diagnostics"))
  assert_true(
    reviewer_mine.wxml.contains("data-developer-diagnostics=\"local-explicit\""),
  )
  assert_true(reviewer_mine.wxml.contains("data-payload-key=\"adminOpsQuery\""))
  assert_true(
    reviewer_mine.wxml.contains("data-response-key=\"adminOpsResult\""),
  )
  assert_true(
    reviewer_mine.wxml.contains("data-payload-key=\"adminReadinessQuery\""),
  )
  assert_true(
    reviewer_mine.wxml.contains("data-response-key=\"adminReadinessResult\""),
  )
  assert_true(reviewer_mine.wxml.contains("package diagnostics"))
  assert_true(reviewer_mine.wxml.contains("render diagnostics"))
  assert_true(reviewer_mine.wxml.contains("Check Town Safety"))
  assert_true(reviewer_mine.wxml.contains("Launch Checks"))
  assert_true(!reviewer_mine.wxml.contains("Ops Check"))
  assert_true(
    reviewer_mine.wxml.contains("data-bunnia-message=\"load-admin-ops\""),
  )
  assert_true(
    reviewer_mine.wxml.contains("data-bunnia-message=\"load-admin-readiness\""),
  )
  assert_true(mine.wxml.contains("moontown-workbench-alert"))
  assert_true(mine.wxml.contains("data-workbench-alert=\"profile-setup\""))
  assert_true(
    mine.wxml.contains("data-workbench-alert=\"blocked-publication\""),
  )
  assert_true(mine.wxml.contains("data-workbench-alert=\"stale-backend\""))
  assert_true(mine.wxml.contains("Town passport incomplete"))
  assert_true(mine.wxml.contains("1 draft blocked from town"))
  assert_true(
    mine.wxml.contains(
      "Owned drafts and shared places need profile setup before publishing.",
    ),
  )
  assert_true(!mine.wxml.contains("shared-private buildings"))
  assert_true(!mine.wxml.contains("profile readiness"))
  assert_true(mine.wxml.contains("1 update needs refresh"))
  assert_true(!mine.wxml.contains("backend state needs sync"))
  assert_true(!mine.wxml.contains("Sync Town"))
  assert_true(mine.wxml.contains("Refresh Town"))
  assert_true(mine.wxml.contains("data-bunnia-message=\"load-town-snapshot\""))
  assert_true(mine.wxml.contains("Publishing Shelf"))
  assert_true(!mine.wxml.contains("My Lifecycle"))
  assert_true(mine.wxml.contains("data-publication-step=\"draft\""))
  assert_true(mine.wxml.contains("data-publication-step=\"review\""))
  assert_true(mine.wxml.contains("Private Draft"))
  assert_true(mine.wxml.contains("Town Published"))
  assert_true(mine.wxml.contains("Private Agent Lab drafted"))
  assert_true(!mine.wxml.contains("data-audit-kind="))
  assert_true(!mine.wxml.contains("data-audit-id="))
  assert_true(!mine.wxml.contains("data-actor-id="))
  assert_true(mine.wxml.contains("Created - Private draft - Draft"))
  assert_true(mine.wxml.contains("needs setup"))
  assert_true(mine.wxml.contains("data-ownership-stat=\"drafts\""))
  assert_true(mine.wxml.contains("data-ownership-stat=\"placements\""))
  assert_true(mine.wxml.contains("data-ownership-stat=\"books\""))
  assert_true(mine.wxml.contains("data-ownership-stat=\"watches\""))
  assert_true(mine.wxml.contains("moontown-ownership-filter active"))
  assert_true(mine.wxml.contains("data-ownership-filter-id=\"placements\""))
  assert_true(mine.wxml.contains("data-ownership-filter-id=\"drafts\""))
  assert_true(mine.wxml.contains("data-ownership-filter-id=\"books\""))
  assert_true(mine.wxml.contains("data-ownership-filter-id=\"watches\""))
  assert_true(mine.wxml.contains("data-ownership-kind=\"building\""))
  assert_true(
    !mine.wxml.contains("data-action-message=\"submit-private-building\""),
  )
  assert_true(mine.wxml.contains("Place - Private draft - Submit in My"))
  assert_true(mine.wxml.contains("data-ownership-kind=\"placement\""))
  assert_true(!mine.wxml.contains("data-action-message=\"select-policy-hall\""))
  assert_true(
    !mine.wxml.contains(
      "data-target-ref=\"placement:placement-user-a-policy-hall\"",
    ),
  )
  assert_true(mine.wxml.contains("data-ownership-kind=\"book\""))
  assert_true(mine.wxml.contains("Book - Private draft - Review in Messages"))
  assert_true(mine.wxml.contains("data-ownership-kind=\"agent\""))
  assert_true(mine.wxml.contains("Agent - Private draft - Chat in Messages"))
  assert_true(mine.wxml.contains("data-ownership-kind=\"watch\""))
  assert_true(mine.wxml.contains("Watch - Watching - Open in Realm"))
  assert_true(mine.wxml.contains("data-place-destination=\"Realm\""))
  assert_true(
    mine.wxml.contains("data-bunnia-message=\"open-place-private-agent-lab\""),
  )
  assert_true(
    mine.wxml.contains("data-bunnia-message=\"open-place-policy-hall\""),
  )
  assert_true(mine.wxml.contains("Private Agent Lab Book"))
  assert_true(mine.wxml.contains("moontown-owned-entry"))
  assert_true(mine.wxml.contains("moontown-create-drawer"))
}

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
      "\"discover-filter-building\":[{k:\"set\",p:\"discover.filter\",v:\"building\"}",
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
      "\"discover-filter-product\":[{k:\"set\",p:\"discover.filter\",v:\"product\"}",
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
      "\"notification-channel-agent\":[{k:\"set\",p:\"messages.channel\",v:\"agent\"}",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/messages.data.js").contains(
      "p:\"messageCenterQuery\",v:{\"channel\":\"agent-run\",\"limit\":30,\"cursor\":0}",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/messages.data.js").contains(
      "\"notification-channel-unread\":[{k:\"set\",p:\"messages.channel\",v:\"unread\"}",
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
      "\"ownership-filter-books\":[{k:\"set\",p:\"ownership.filter\",v:\"books\"}",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/my.data.js").contains(
      "p:\"ownershipQuery\",v:{\"includeAlerts\":true,\"kind\":\"book\",\"visibility\":\"all\",\"cursor\":0}",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/my.data.js").contains(
      "\"ownership-filter-placements\":[{k:\"set\",p:\"ownership.filter\",v:\"placements\"}",
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
  assert_eq(project.manifest.pages[5].route, "pages/moontown/reviewer")
  assert_true(project.manifest.pages[0].backend_event_count >= 3)
  assert_true(project.manifest.pages[3].backend_event_count >= 2)
  assert_true(project.manifest.pages[0].scene_marker_count >= 8)
  assert_true(project.manifest.pages[0].scene_region_count == 2)
  assert_eq(project.manifest.diagnostic_count, 0)
  assert_true(project.manifest.summary.contains("app_files="))
}

///|
test "moontown miniapp projection supports mock user create search and agent flows" {
  let projection = demo_projection()
  assert_eq(projection.users.length(), 2)
  assert_eq(projection.profile.display_name, "Ada Builder")
  assert_eq(projection.roles.length(), 5)
  assert_eq(local_backend_base_url(), "http://127.0.0.1:18191")
  assert_eq(projection.backend_steps.length(), 14)
  assert_eq(projection.backend_steps[0].endpoint_id, "dev-login")
  assert_eq(projection.backend_steps[1].path, "/miniapp/town/snapshot")
  assert_eq(projection.backend_steps[2].endpoint_id, "load-ownership-snapshot")
  assert_eq(projection.backend_steps[2].path, "/miniapp/me/ownership")
  assert_eq(projection.backend_steps[3].endpoint_id, "load-message-center")
  assert_eq(projection.backend_steps[3].path, "/miniapp/messages/center")
  assert_eq(projection.backend_steps[4].status, "guarded")
  assert_eq(projection.backend_steps[6].endpoint_id, "cancel-run")
  assert_eq(projection.backend_steps[7].endpoint_id, "retry-run")
  assert_eq(projection.backend_steps[8].endpoint_id, "ack-notification")
  assert_eq(projection.backend_steps[9].endpoint_id, "request-subscription")
  assert_eq(projection.backend_steps[10].endpoint_id, "discover-action")
  assert_eq(projection.backend_steps[10].path, "/miniapp/discover/action")
  assert_eq(projection.backend_steps[11].endpoint_id, "handoff-agent-work")
  assert_eq(projection.backend_steps[12].endpoint_id, "load-admin-ops")
  assert_eq(projection.backend_steps[12].path, "/miniapp/admin/ops")
  assert_eq(projection.backend_steps[13].endpoint_id, "load-admin-readiness")
  assert_eq(projection.backend_steps[13].path, "/miniapp/admin/readiness")
  assert_eq(projection.backend_cache_states.length(), 5)
  assert_eq(projection.backend_cache_states[1].id, "snapshot")
  assert_eq(projection.backend_cache_states[1].state, "stale-safe")
  assert_eq(projection.backend_cache_states[1].action_label, "Reload")
  assert_eq(
    projection.backend_cache_states[1].action_message,
    "load-town-snapshot",
  )
  assert_eq(projection.backend_cache_states[2].id, "ownership")
  assert_eq(projection.backend_cache_states[2].state, "idle")
  assert_eq(
    projection.backend_cache_states[2].action_message,
    "load-ownership-snapshot",
  )
  assert_eq(projection.backend_cache_states[3].source, "request-log")
  assert_eq(projection.backend_cache_states[3].action_message, "tab-my")
  assert_eq(projection.backend_cache_states[4].action_message, "tab-messages")
  assert_eq(projection.moderation_cases.length(), 1)
  assert_eq(projection.moderation_cases[0].id, "mod-policy-hall")
  assert_eq(selected_building_moderation_cases(projection).length(), 1)
  assert_eq(
    selected_building_moderation_cases(projection)[0].action_message,
    "appeal-moderation-case",
  )
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
  assert_eq(projection.districts[0].discovery_filter_id, "product")
  assert_eq(projection.districts[0].search_query, "product")
  assert_eq(projection.districts[0].accent, "blue")
  assert_eq(projection.presence.length(), 4)
  assert_eq(projection.notifications.length(), 7)
  assert_eq(projection.notification_channels.length(), 7)
  assert_eq(projection.watches.length(), 1)
  assert_eq(projection.discovery_items.length(), 11)
  assert_eq(projection.discovery_filters.length(), 11)
  assert_eq(projection.activity_items.length(), 5)
  assert_eq(projection.audit_events.length(), 4)
  assert_eq(projection.books.length(), 8)
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
  assert_eq(visible_messages(projection).length(), 3)
  assert_eq(selected_building_messages(projection).length(), 2)
  assert_eq(visible_tool_results(projection).length(), 2)
  assert_eq(tool_result_cards(projection).length(), 2)
  assert_eq(tool_result_cards(projection)[0].id, "tool-policy-summary")
  let bob_projection = switch_mock_user(projection, "user-b")
  assert_eq(visible_messages(bob_projection).length(), 2)
  assert_eq(visible_reviews(projection).length(), 1)
  assert_eq(active_runs(projection).length(), 3)
  assert_eq(review_runs(projection).length(), 1)
  assert_eq(pending_reviews(projection).length(), 1)
  assert_eq(selected_building_runs(projection).length(), 1)
  assert_eq(selected_building_agents(projection).length(), 1)
  assert_eq(selected_building_agents(projection)[0].id, "agent-policy-guide")
  let empty_worker_projection = place_published_building(
    projection, "published-agent-lab",
  )
  assert_eq(
    selected_building(empty_worker_projection).id,
    "published-agent-lab",
  )
  assert_eq(selected_building_agents(empty_worker_projection).length(), 0)
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
  assert_eq(projection.districts[0].action_message, "tab-discover")
  assert_eq(projection.districts[1].action_message, "tab-messages")
  assert_eq(projection.districts[4].action_message, "tab-my")
  assert_eq(projection.buildings.length(), 10)
  assert_eq(projection.placements.length(), 1)
  assert_eq(visible_placements(projection).length(), 1)
  assert_eq(placed_buildings(projection).length(), 1)
  assert_eq(placed_buildings(projection)[0].id, "policy-hall")
  assert_true(placement_for_building(projection, "policy-hall") is Some(_))
  assert_true(placement_for_building(projection, "published-agent-lab") is None)
  assert_eq(visible_buildings(projection).length(), 9)
  assert_eq(visible_books(projection).length(), 8)
  assert_eq(selected_building_book(projection).id, "book-policy-hall")
  let policy_shelf = selected_building_book_shelf(projection)
  assert_eq(policy_shelf.length(), 2)
  assert_eq(policy_shelf[0].role, "primary")
  assert_eq(policy_shelf[0].book_id, "book-policy-hall")
  assert_eq(policy_shelf[1].role, "support")
  assert_eq(policy_shelf[1].book_id, "book-policy-hall-sources")
  assert_true(policy_shelf[1].safe_summary.contains("Public support sources"))
  assert_eq(search_results(projection).length(), 1)
  assert_true(unified_discovery_results(projection).length() >= 6)
  assert_true(filtered_discovery_results(projection).length() >= 6)
  assert_eq(discovery_results_by_kind(projection, "user").length(), 3)
  assert_eq(discovery_results_by_kind(projection, "circle").length(), 2)
  assert_eq(discovery_results_by_kind(projection, "product").length(), 1)
  assert_eq(discovery_results_by_kind(projection, "demand").length(), 1)
  assert_eq(discovery_results_by_kind(projection, "event").length(), 1)
  assert_eq(discovery_results_by_kind(projection, "post").length(), 1)
  assert_eq(market_discovery_results(projection).length(), 4)
  assert_eq(visible_watches(projection).length(), 1)
  assert_eq(visible_watches(projection)[0].target_ref, "building:policy-hall")
  let people = switch_discovery_filter(projection, "user")
  assert_eq(selected_discovery_filter(people).id, "user")
  assert_eq(filtered_discovery_results(people).length(), 3)
  let circles = switch_discovery_filter(projection, "circle")
  assert_eq(selected_discovery_filter(circles).id, "circle")
  assert_eq(filtered_discovery_results(circles).length(), 2)
  let products = switch_discovery_filter(projection, "product")
  assert_eq(selected_discovery_filter(products).id, "product")
  assert_eq(filtered_discovery_results(products).length(), 1)
  let demands = switch_discovery_filter(projection, "demand")
  assert_eq(selected_discovery_filter(demands).id, "demand")
  assert_eq(filtered_discovery_results(demands).length(), 1)
  let events = switch_discovery_filter(projection, "event")
  assert_eq(selected_discovery_filter(events).id, "event")
  assert_eq(filtered_discovery_results(events).length(), 1)
  let posts = switch_discovery_filter(projection, "post")
  assert_eq(selected_discovery_filter(posts).id, "post")
  assert_eq(filtered_discovery_results(posts).length(), 1)
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
  assert_eq(ownership_stats(projection).length(), 7)
  assert_eq(ownership_stats(projection)[0].id, "placements")
  assert_eq(ownership_stats(projection)[0].value, 1)
  assert_eq(ownership_stats(projection)[6].id, "watches")
  assert_eq(ownership_stats(projection)[6].value, 1)
  assert_eq(projection.ownership_filters.length(), 7)
  assert_eq(selected_ownership_filter(projection).id, "all")
  assert_eq(ownership_items(projection).length(), 5)
  assert_eq(filtered_ownership_items(projection).length(), 5)
  let owned = ownership_items(projection)
  assert_eq(owned[0].action_label, "Submit")
  assert_eq(owned[0].action_message, "submit-private-building")
  assert_eq(owned[1].action_message, "select-policy-hall")
  assert_eq(owned[2].action_message, "tab-messages")
  assert_eq(owned[3].action_label, "Chat")
  assert_eq(owned[3].action_message, "tab-messages")
  assert_eq(owned[4].kind, "watch")
  assert_eq(owned[4].action_message, "select-policy-hall")
  let default_alerts = workbench_alerts(projection)
  assert_eq(default_alerts.length(), 3)
  assert_eq(default_alerts[0].id, "profile-setup")
  assert_eq(default_alerts[1].id, "blocked-publication")
  assert_eq(default_alerts[2].id, "stale-backend")
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
  let watches = switch_ownership_filter(projection, "watches")
  assert_eq(selected_ownership_filter(watches).kind, "watch")
  assert_eq(filtered_ownership_items(watches).length(), 1)
  assert_eq(filtered_ownership_items(watches)[0].title, "Policy Hall")
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
  let rejected_alerts = workbench_alerts(rejected)
  assert_true(rejected_alerts.length() >= 4)
  assert_eq(rejected_alerts[2].id, "retry-runs")
  assert_eq(rejected_alerts[2].status, "failed")
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
  let ready_alerts = workbench_alerts(profiled)
  assert_eq(ready_alerts.length(), 1)
  assert_eq(ready_alerts[0].id, "stale-backend")
  let ready_gates = setup_gates(profiled)
  assert_true(ready_gates[2].complete)
  assert_true(ready_gates[3].complete)
  assert_true(ready_gates[4].complete)
  assert_true(ready_gates[5].complete)
  let default_actions = selected_building_lifecycle_actions(projection)
  assert_eq(default_actions.length(), 8)
  assert_eq(default_actions[0].id, "ask")
  assert_true(default_actions[0].allowed)
  assert_eq(default_actions[0].book_id, "book-policy-hall")
  assert_eq(default_actions[1].id, "edit")
  assert_true(!default_actions[1].allowed)
  assert_eq(default_actions[1].reason, "owner only")
  assert_eq(default_actions[2].id, "place")
  assert_true(default_actions[2].allowed)
  assert_eq(default_actions[4].id, "submit")
  assert_true(!default_actions[4].allowed)
  assert_eq(default_actions[4].reason, "owner only")
  assert_eq(default_actions[5].id, "publish")
  assert_true(!default_actions[5].allowed)
  let default_steps = publication_steps(projection)
  assert_eq(default_steps.length(), 6)
  assert_eq(default_steps[0].id, "draft")
  assert_true(default_steps[0].current)
  assert_true(!default_steps[1].blocked)
  assert_eq(default_steps[2].id, "review")
  assert_eq(default_steps[3].id, "approve")
  let ready_created = create_private_building(
    profiled, "ready-agent-lab", "Ready Agent Lab",
  )
  let ready_actions = selected_building_lifecycle_actions(ready_created)
  assert_eq(ready_actions[1].id, "edit")
  assert_true(ready_actions[1].allowed)
  assert_eq(ready_actions[1].reason, "draft editable")
  assert_true(ready_actions[3].allowed)
  assert_eq(ready_actions[3].reason, "private draft")
  assert_true(ready_actions[4].allowed)
  assert_eq(ready_actions[4].reason, "ready for review")
  assert_true(!ready_actions[5].allowed)
  assert_eq(ready_actions[5].reason, "ready for review")
  assert_true(ready_actions[6].allowed)
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
  assert_eq(created.books.length(), 9)
  assert_eq(created.audit_events.length(), 5)
  assert_eq(created.selected_building_id, "created-agent-lab")
  assert_eq(selected_building_book(created).id, "book-created-agent-lab")
  assert_eq(selected_building_audit_events(created).length(), 1)
  let edited = edit_selected_building(
    created,
    "Edited Agent Lab",
    "Edited private building profile.",
    "Edited Agent Lab Book",
    "Edited safe memory summary.",
    ["agent", "edited"],
  )
  assert_eq(selected_building(edited).title, "Edited Agent Lab")
  assert_eq(
    selected_building(edited).summary,
    "Edited private building profile.",
  )
  assert_eq(selected_building(edited).tags[1], "edited")
  assert_eq(selected_building_book(edited).title, "Edited Agent Lab Book")
  assert_eq(
    selected_building_book(edited).summary,
    "Edited safe memory summary.",
  )
  assert_eq(selected_building_audit_events(edited).length(), 2)
  let blocked_edit = edit_selected_building(
    projection,
    "Published Edit",
    "Should not change published building.",
    "Published Edit Book",
    "Blocked book summary.",
    ["blocked"],
  )
  assert_eq(selected_building(blocked_edit).title, "Policy Hall")
  assert_eq(selected_building_audit_events(blocked_edit).length(), 1)
  let shared = share_selected_building(created)
  assert_eq(selected_building(shared).visibility, "shared_private")
  assert_eq(selected_building_book(shared).visibility, "shared_private")
  assert_eq(selected_building_audit_events(shared).length(), 2)
  let shared_steps = publication_steps(shared)
  assert_true(shared_steps[1].current)
  assert_eq(shared_steps[2].summary, "Finish profile first")
  let shared_unread_count = unread_notifications(shared).length()
  let submitted = submit_selected_building(shared)
  assert_eq(selected_building(submitted).visibility, "submitted")
  assert_eq(selected_building_book(submitted).visibility, "submitted")
  assert_eq(selected_building_book(submitted).pending_review_count, 1)
  assert_eq(pending_reviews(submitted).length(), 2)
  assert_eq(
    pending_reviews(submitted)[1].artifact_ref,
    "building://created-agent-lab",
  )
  assert_eq(pending_reviews(submitted)[1].accepted_memory_delta, 0)
  assert_eq(unread_notifications(submitted).length(), shared_unread_count + 1)
  let submitted_steps = publication_steps(submitted)
  assert_true(submitted_steps[2].current)
  assert_true(submitted_steps[3].current)
  let submitted_actions = selected_building_lifecycle_actions(submitted)
  assert_eq(submitted_actions[5].id, "publish")
  assert_true(!submitted_actions[5].allowed)
  let rejected_publication = reject_review(
    submitted, "review-publish-created-agent-lab",
  )
  assert_eq(selected_building(rejected_publication).visibility, "private_draft")
  assert_eq(
    selected_building_book(rejected_publication).visibility,
    "private_draft",
  )
  assert_eq(
    selected_building_book(rejected_publication).pending_review_count,
    0,
  )
  assert_eq(pending_reviews(rejected_publication).length(), 1)
  let resubmitted = submit_selected_building(rejected_publication)
  let published = accept_review(resubmitted, "review-publish-created-agent-lab")
  assert_eq(selected_building(published).visibility, "published")
  assert_eq(selected_building_book(published).visibility, "published")
  assert_eq(selected_building_book(published).pending_review_count, 0)
  assert_eq(pending_reviews(published).length(), 1)
  assert_eq(search_results(published).length(), 2)
  let published_steps = publication_steps(published)
  assert_true(published_steps[4].current)
  assert_true(published_steps[4].complete)
  let placeable_before_pin = switch_discovery_filter(published, "placeable")
  let placed = place_published_building(published, "published-agent-lab")
  assert_eq(placed.selected_building_id, "published-agent-lab")
  assert_eq(placed.buildings.length(), published.buildings.length())
  assert_eq(placed.placements.length(), published.placements.length() + 1)
  assert_eq(visible_placements(placed).length(), 2)
  assert_eq(placed_buildings(placed).length(), 2)
  assert_true(placement_for_building(placed, "published-agent-lab") is Some(_))
  assert_eq(selected_building_audit_events(placed).length(), 2)
  let placed_placeable = switch_discovery_filter(placed, "placeable")
  assert_eq(
    filtered_discovery_results(placed_placeable).length(),
    filtered_discovery_results(placeable_before_pin).length() - 1,
  )
  for item in filtered_discovery_results(placed_placeable) {
    assert_true(item.target_ref != "building:published-agent-lab")
  }
  let placed_discover = tab_page(placed, "discover")
  assert_true(placed_discover.wxml.contains("Pinned On Map"))
  assert_true(placed_discover.wxml.contains("Already placed"))
  assert_true(!placed_discover.wxml.contains("data-placement-state="))
  let duplicate_placed = place_published_building(placed, "published-agent-lab")
  assert_eq(duplicate_placed.placements.length(), placed.placements.length())
  let archived = archive_selected_building(published)
  assert_eq(selected_building(archived).visibility, "archived")
  assert_eq(visible_buildings(archived).length(), 9)
  let archived_steps = publication_steps(archived)
  assert_true(archived_steps[5].current)
  assert_true(!archived_steps[5].blocked)
  let archived_actions = selected_building_lifecycle_actions(archived)
  assert_eq(archived_actions[7].id, "restore")
  assert_true(archived_actions[7].allowed)
  let restored = restore_selected_building(archived)
  assert_eq(selected_building(restored).visibility, "private_draft")
  assert_eq(selected_building_book(restored).visibility, "private_draft")
  assert_eq(selected_building(restored).status, "draft")
  assert_eq(selected_building_audit_events(restored).length(), 8)
  let sent_message = send_message_to_selected_building(
    projection, "Can this building publish an agent?",
  )
  assert_eq(selected_building_messages(sent_message).length(), 3)
  assert_eq(
    selected_building_messages(sent_message)[2].text,
    "Can this building publish an agent?",
  )
  assert_eq(selected_building_messages(sent_message)[2].actor_id, "user-a")
  let agent_created = create_agent_for_selected(
    created, "agent-created", "Created Agent",
  )
  assert_eq(agent_created.agents.length(), 4)
  assert_eq(selected_building_messages(agent_created).length(), 1)
  assert_eq(
    selected_building_messages(agent_created)[0].text,
    "Created Agent is ready inside Created Agent Lab.",
  )
  assert_eq(
    selected_building_messages(agent_created)[0].actor_id,
    "agent-created",
  )
  assert_eq(selected_building_audit_events(agent_created).length(), 2)
  let agent_owned = switch_ownership_filter(agent_created, "agents")
  assert_eq(filtered_ownership_items(agent_owned).length(), 2)
  assert_eq(
    filtered_ownership_items(agent_owned)[1].target_ref,
    "agent:agent-created",
  )
  let handed_off = handoff_selected_building_agent(
    projection, "agent-policy-guide", "agent-builder", "Move follow-up planning into the builder queue.",
  )
  assert_eq(selected_building_messages(handed_off).length(), 3)
  assert_eq(
    selected_building_messages(handed_off)[2].text,
    "Policy Guide handed work to Builder: Move follow-up planning into the builder queue.",
  )
  assert_eq(
    selected_building_messages(handed_off)[2].actor_id,
    "agent-policy-guide",
  )
  assert_eq(active_runs(handed_off).length(), 4)
  assert_eq(active_runs(handed_off)[3].agent_id, "agent-builder")
  assert_eq(
    active_runs(handed_off)[3].artifact_ref,
    "handoff://agent-policy-guide/agent-builder/policy-hall",
  )
  assert_eq(visible_notifications(handed_off).length(), 8)
  assert_eq(visible_notifications(handed_off)[7].kind, "handoff")
  assert_eq(selected_building_audit_events(handed_off).length(), 2)
  assert_eq(selected_building_audit_events(handed_off)[1].kind, "handoff")
  let tool_ack = acknowledge_tool_result(projection, "tool-policy-summary")
  assert_true(tool_result_cards(tool_ack)[0].status == @bunnia.run_done())
  assert_eq(selected_building_audit_events(tool_ack).length(), 2)
  assert_eq(selected_building_audit_events(tool_ack)[1].kind, "tool-result-ack")
}

///|
test "moontown miniapp exposes pressure plans for inspect gates" {
  let patch = demo_patch_plan()
  let snapshot = demo_snapshot_delta_plan()
  let agent = demo_agent_delta_plan()
  let communication = demo_communication_plan()
  let tool_result = demo_tool_result_plan()
  let backend = demo_backend_plan()
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
  assert_eq(tool_result.total_count, 2)
  assert_eq(tool_result.visible_count, 2)
  assert_eq(tool_result.pending_ack_count, 2)
  assert_eq(tool_result.missing_ack_count, 0)
  assert_eq(tool_result.artifact_ref_count, 2)
  assert_eq(tool_result.diagnostics.length(), 0)
  assert_eq(backend.endpoint_count, 32)
  assert_eq(backend.review_required_count, 15)
  assert_eq(backend.cancel_count, 1)
  assert_eq(backend.retry_count, 1)
  assert_eq(backend.diagnostics.length(), 0)
  assert_eq(effects.effect_count, 32)
  assert_true(scene.marker_count >= 8)
  assert_eq(scene.region_count, 2)
  assert_true(!surface.fallback)
  assert_true(threads.total_link_count >= 8)
  assert_eq(assets.assets.length(), 2)
  assert_eq(quality.diagnostics.length(), 0)
  assert_eq(inspection.route_count, 6)
  assert_eq(inspection.total_diagnostics, 0)
  assert_true(inspection.max_first_screen_bytes <= 72000)
  assert_true(inspection.max_update_payload_bytes > 0)
  assert_true(inspection.max_update_payload_bytes <= 4096)
  assert_true(inspection.max_update_operation_count <= 64)
  assert_true(inspection.max_unwindowed_list_child_count <= 64)
  assert_eq(inspection.max_unkeyed_list_child_count, 0)
  assert_eq(inspection.max_duplicate_list_key_count, 0)
  assert_true(inspection.max_backend_event_count <= 64)
  assert_true(inspection.max_backend_review_count <= 16)
  assert_true(inspection.max_scene_marker_count >= 4)
  assert_eq(inspection.max_scene_asset_count, 2)
  assert_eq(inspection.max_scene_remote_asset_count, 0)
  assert_true(inspection.max_scene_package_bytes <= 2097152)
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
fn ordinary_wxml_paths() -> Array[String] {
  [
    "pages/moontown/index.wxml", "pages/moontown/home.wxml", "pages/moontown/discover.wxml",
    "pages/moontown/messages.wxml", "pages/moontown/my.wxml",
  ]
}

///|
fn has_no_forbidden_generated_ordinary_wxml(
  files : Array[@bunnia.WechatFile],
) -> Bool {
  for path in ordinary_wxml_paths() {
    let wxml = file_content(files, path)
    if wxml == "" || !has_no_forbidden_ordinary_copy(wxml) {
      return false
    }
    for
      raw in [
        "GET /miniapp", "POST /miniapp", "payload_key", "response_key", "backendStatus",
        "DevTools", "runtime filter", "runtime channel", "data-backend-", "data-payload-key",
        "data-response-key", "Developer Diagnostics", "adminOpsQuery", "adminReadinessQuery",
        "Moderation Desk", "Safety Desk", "OPC Hub", "System Gateway", "system notices",
        "data-moderation-", "hide-public-building", "takedown-public-building", "appeal-moderation-case",
        " is needs setup", "12 memories - 1 reviews", "9 memories - 0 reviews", "0 published place",
        "placement - personal", "Agent run completed", "agent run", "Messages collects runs",
        "Receive run,", "profile readiness", "shared-private buildings",
      ] {
      if wxml.contains(raw) {
        return false
      }
    }
    for
      label in [
        "endpoint", "payload", "response_key", "cursor", "offset", "load-message-center",
        "load-ownership-snapshot", "load-admin-ops", "load-admin-readiness",
      ] {
      if wxml.contains(">\{label}</text>") {
        return false
      }
    }
  }
  true
}

///|
fn has_reviewer_diagnostics_allowlist(
  files : Array[@bunnia.WechatFile],
) -> Bool {
  let reviewer = file_content(files, "pages/moontown/reviewer.wxml")
  reviewer.contains("data-reviewer-route=\"true\"") &&
  reviewer.contains("Developer Diagnostics") &&
  reviewer.contains("data-diagnostics-mode=\"reviewer\"") &&
  reviewer.contains("data-http-path=\"/miniapp/admin/ops\"") &&
  reviewer.contains("data-http-path=\"/miniapp/admin/readiness\"") &&
  reviewer.contains("data-payload-key=\"adminOpsQuery\"") &&
  reviewer.contains("data-response-key=\"adminReadinessResult\"")
}

///|
fn generated_contract_data_stays_out_of_ordinary_wxml(
  files : Array[@bunnia.WechatFile],
) -> Bool {
  let data_js = file_content(files, "pages/moontown/index.data.js")
  let backend_js = file_content(files, "bunnia.backend.js")
  if !data_js.contains("adminOpsQuery") ||
    !data_js.contains("messageCenterQuery") ||
    !backend_js.contains("/miniapp/admin/ops") ||
    !backend_js.contains("/miniapp/messages/center") {
    return false
  }
  for path in ordinary_wxml_paths() {
    let wxml = file_content(files, path)
    for
      key in [
        "adminOpsQuery", "adminReadinessQuery", "messageCenterQuery", "ownershipQuery",
        "/miniapp/admin/ops", "/miniapp/messages/center", "/miniapp/me/ownership",
      ] {
      if wxml.contains(key) {
        return false
      }
    }
  }
  true
}

///|
fn generated_wxss_has_tile_visual_system(
  files : Array[@bunnia.WechatFile],
) -> Bool {
  let wxss = file_content(files, "app.wxss")
  wxss.contains("button{min-width:88rpx;min-height:72rpx") &&
  wxss.contains(
    "button[disabled],.bunnia-status-disabled{opacity:0.52;pointer-events:none",
  ) &&
  wxss.contains(".mt-panel input{width:100%;min-height:72rpx") &&
  wxss.contains(".moontown-discovery-badges,.moontown-object-badges") &&
  wxss.contains(".moontown-object-section,.moontown-worker-entry") &&
  wxss.contains(
    ".moontown-community-actions button,.moontown-discovery-action button",
  ) &&
  ordinary_pages_share_app_wxss(files)
}

///|
fn ordinary_pages_share_app_wxss(files : Array[@bunnia.WechatFile]) -> Bool {
  for
    path in [
      "pages/moontown/index.wxss", "pages/moontown/home.wxss", "pages/moontown/discover.wxss",
      "pages/moontown/messages.wxss", "pages/moontown/my.wxss",
    ] {
    if has_file(files, path) {
      return false
    }
  }
  true
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
fn backend_contract_contains(
  contract : @bunnia.BackendContract,
  id : String,
  path : String,
) -> Bool {
  for endpoint in contract.endpoints {
    if endpoint.id == id && endpoint.path == path {
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
