///|
test "moontown miniapp renders dedicated tab surfaces around the same map" {
  let projection = demo_projection()
  let realm = tab_page(projection, "realm")
  assert_true(has_no_forbidden_ordinary_copy(realm.wxml))
  assert_true(realm.wxml.contains("moontown-map-fullscreen"))
  assert_true(!realm.wxml.contains("moontown-left-hud"))
  assert_true(realm.wxml.contains("moontown-right-hud"))
  assert_true(realm.wxml.contains("moontown-map-state-strip"))
  assert_true(!realm.wxml.contains("moontown-map-action-rail"))
  assert_true(
    realm.wxml.contains("moontown-map-marker bunnia-status-review selected"),
  )
  assert_true(realm.wxml.contains("Policy Hall: Review"))
  assert_true(realm.wxml.contains("Access: Public in town"))
  assert_true(realm.wxml.contains("Placement: Pinned"))
  assert_true(realm.wxml.contains("Ask"))
  assert_true(realm.wxml.contains("Messages"))
  assert_true(realm.wxml.contains("Find Similar"))
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
  assert_true(!realm.wxml.contains("District Gates"))

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
  assert_true(home.wxml.contains("District Gates"))
  assert_true(
    home.wxml.contains(
      "Market, messages, events, guides, and trust work open from this town board.",
    ),
  )
  assert_true(home.wxml.contains("data-feature-kind=\"market\""))
  assert_true(home.wxml.contains("feature-market tone-blue"))
  assert_true(home.wxml.contains("data-district-filter=\"product\""))
  assert_true(home.wxml.contains("data-district-query=\"product\""))
  assert_true(home.wxml.contains("data-district-accent=\"blue\""))
  assert_true(home.wxml.contains("Browse Discover"))
  assert_true(home.wxml.contains("Review Messages"))
  assert_true(home.wxml.contains("Verify My"))
  assert_true(!home.wxml.contains("<text>Filter</text>"))
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
  assert_true(!home.wxml.contains("Reference feature pages"))
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

  let empty_discover_projection = search_discovery(
    projection, "no public market result matches this",
  )
  let empty_discover = tab_page(empty_discover_projection, "discover")
  assert_true(has_no_forbidden_ordinary_copy(empty_discover.wxml))
  assert_true(empty_discover.wxml.contains("moontown-discover-empty"))
  assert_true(empty_discover.wxml.contains("No public match"))
  assert_true(
    empty_discover.wxml.contains(
      "Try another search or choose a different market filter.",
    ),
  )

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
  assert_true(messages.wxml.contains("moontown-attention-row"))
  assert_true(messages.wxml.contains("Review waiting answer"))
  assert_true(
    messages.wxml.contains(
      "Policy Hall needs a decision before memory is saved.",
    ),
  )
  assert_true(messages.wxml.contains("Agent work in progress"))
  assert_true(
    messages.wxml.contains("Policy Hall is working from Policy Hall Book."),
  )
  assert_true(messages.wxml.contains("Town signals are available"))
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
  assert_true(messages.wxml.contains("team place"))
  assert_true(!messages.wxml.contains("shared private"))
  assert_true(!messages.wxml.contains("shared privately"))
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
  assert_true(mine.wxml.contains("Town Passport"))
  assert_true(!mine.wxml.contains("Identity Setup"))
  assert_true(
    !mine.wxml.contains("runtime role: {{profile.roleId || 'builder'}}"),
  )
  assert_true(!mine.wxml.contains("own: {{ownership.filter || 'all'}}"))
  assert_true(mine.wxml.contains("My Inventory"))
  assert_true(
    mine.wxml.contains(
      "Owned shelves, alerts, and 5 items are ready to manage.",
    ),
  )
  assert_true(!mine.wxml.contains("Town passport, setup stamps"))
  assert_eq(
    string_occurrence_count(mine.wxml, "data-setup-gate=\"session\""),
    1,
  )
  assert_eq(
    string_occurrence_count(mine.wxml, "data-setup-gate=\"publish-ready\""),
    1,
  )
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
  assert_true(mine.wxml.contains("Inventory Shelves"))
  assert_true(mine.wxml.contains("moontown-inventory-shelf"))
  assert_true(mine.wxml.contains("data-inventory-shelf-count=\"9\""))
  assert_true(mine.wxml.contains("data-inventory-shelf=\"buildings\""))
  assert_true(mine.wxml.contains("data-inventory-shelf=\"placements\""))
  assert_true(mine.wxml.contains("data-inventory-shelf=\"drafts\""))
  assert_true(mine.wxml.contains("data-inventory-shelf=\"submitted\""))
  assert_true(mine.wxml.contains("data-inventory-shelf=\"published\""))
  assert_true(mine.wxml.contains("data-inventory-shelf=\"archived\""))
  assert_true(mine.wxml.contains("data-inventory-shelf=\"books\""))
  assert_true(mine.wxml.contains("data-inventory-shelf=\"agents\""))
  assert_true(mine.wxml.contains("data-inventory-shelf=\"watched\""))
  assert_true(mine.wxml.contains("Submit for review in My"))
  assert_true(mine.wxml.contains("Open Place in Realm"))
  assert_true(mine.wxml.contains("Review Books in Messages"))
  assert_true(mine.wxml.contains("Message Agents in Messages"))
  assert_true(mine.wxml.contains("Open Place in Realm"))
  assert_true(!mine.wxml.contains("data-inventory-target-ref="))
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
  assert_true(mine.wxml.contains("already on your map"))
  assert_true(!mine.wxml.contains("starter-map"))
  assert_true(!mine.wxml.contains("placed from starter-map"))
  assert_true(mine.wxml.contains("Inventory Refresh"))
  assert_true(mine.wxml.contains("Refresh My Stuff"))
  assert_true(!mine.wxml.contains("<text>More</text>"))
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
