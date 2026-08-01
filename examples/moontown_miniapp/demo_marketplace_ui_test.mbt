///|
test "moontown Discover renders a truthful public marketplace workflow" {
  let discover = tab_page(demo_projection(), "discover")
  assert_true(discover.wxml.contains("Find an agent or building"))
  assert_true(discover.wxml.contains("moontown-market-suggestions"))
  assert_true(discover.wxml.contains("Recommended for you"))
  assert_true(discover.wxml.contains("Every recommendation explains why"))
  assert_true(discover.wxml.contains("Sponsored"))
  assert_true(discover.wxml.contains("Shared with me"))
  assert_true(discover.wxml.contains("Check private shares"))
  assert_true(discover.wxml.contains("Revoke access"))
  assert_true(
    string_appears_before(discover.wxml, "Recommended for you", "Sponsored"),
  )
  assert_true(discover.wxml.contains("role=\"alert\""))
  assert_true(discover.wxml.contains("No public match yet"))
  assert_true(discover.wxml.contains("Safe share preview"))
  assert_true(discover.wxml.contains("Withheld by policy"))
  assert_true(discover.wxml.contains("Previewing does not grant access"))
}

///|
test "moontown listing controls are gated by declared action ids" {
  let discover = tab_page(demo_projection(), "discover")
  let wxml = discover.wxml
  for
    gate in [
      "canFollow", "canMessage", "canInstall", "canInvite", "canTry", "canVisit",
      "canRequestAccess", "canShare",
    ] {
    assert_true(wxml.contains("marketplace.selected.\{gate}"))
  }
  assert_true(wxml.contains("data-listing-actions="))
  let project = demo_wechat_project()
  let js = file_content(project.files, "pages/moontown/discover.js")
  assert_true(js.contains("source.action_ids"))
  assert_true(js.contains("publisherId=String(source.publisher_id"))
  assert_true(wxml.contains("Message publisher"))
  assert_true(wxml.contains("memberPrincipalIds"))
  assert_true(
    js.contains(
      "allowed=['follow','message','install','invite','try','visit','request_access','share']",
    ),
  )
  assert_true(js.contains("canVisit:actions.includes('visit')"))
  assert_true(js.contains("canTry:actions.includes('try')"))
  assert_true(js.contains("canShare:actions.includes('share')"))
}

///|
test "moontown Messages exposes scoped conversations and live notifications" {
  let messages = tab_page(demo_projection(), "messages")
  let wxml = messages.wxml
  assert_true(wxml.contains("<text>Chats</text>"))
  assert_true(wxml.contains("<text>Notifications</text>"))
  assert_true(wxml.contains("<text>Agent work</text>"))
  assert_true(wxml.contains("Show DMs channels"))
  assert_true(wxml.contains("Show Buildings channels"))
  assert_true(wxml.contains("Start a private room"))
  assert_true(wxml.contains("name=\"memberPrincipalIds\""))
  assert_true(
    wxml.contains("data-bunnia-message=\"create-marketplace-channel\""),
  )
  assert_true(wxml.contains("Participants only"))
  assert_true(wxml.contains("Message participants"))
  assert_true(wxml.contains("wx:for=\"{{channels.items}}\""))
  assert_true(wxml.contains("wx:for=\"{{notifications.items}}\""))
  assert_true(
    wxml.contains("data-bunnia-message=\"read-marketplace-notification\""),
  )
  assert_true(wxml.contains("Ads never become notifications"))
}

///|
test "moontown marketplace project uses generic Town routes and safe mappers" {
  let project = demo_wechat_project()
  let backend = file_content(project.files, "bunnia.backend.js")
  let discover_js = file_content(project.files, "pages/moontown/discover.js")
  let messages_js = file_content(project.files, "pages/moontown/messages.js")
  for
    route in [
      "/miniapp/marketplace/discovery/search", "/miniapp/marketplace/discovery/recommendations",
      "/miniapp/marketplace/discovery/feed", "/miniapp/marketplace/listings/action",
      "/miniapp/marketplace/channels", "/miniapp/marketplace/messages", "/miniapp/marketplace/notifications",
      "/miniapp/marketplace/subscriptions", "/miniapp/marketplace/shared-listings",
      "/miniapp/marketplace/share-grants/revoke", "/miniapp/marketplace/shares/preview",
    ] {
    assert_true(backend.contains(route))
  }
  assert_true(discover_js.contains("data.payload!==undefined"))
  assert_true(discover_js.contains("sponsored_placements"))
  assert_true(discover_js.contains("excluded_fields"))
  assert_true(messages_js.contains("attachment_refs:[]"))
  assert_true(messages_js.contains("public_audience:false"))
  assert_true(messages_js.contains("reply_to_message_id:null"))
  assert_true(messages_js.contains("load-marketplace-channels"))
  assert_true(messages_js.contains("load-marketplace-notifications"))
}

///|
test "moontown marketplace isolates its session and sends query data normally" {
  let project = demo_wechat_project()
  let backend = file_content(project.files, "bunnia.backend.js")
  let messages_js = file_content(project.files, "pages/moontown/messages.js")
  assert_true(
    backend.contains("header: __bunniaRequestHeaders(page, endpointId)"),
  )
  assert_true(backend.contains("__bunniaSessionTokenForEndpoint"))
  assert_true(backend.contains("data: requestPayload"))
  assert_false(backend.contains("encodeURIComponent(requestPayload"))
  assert_true(messages_js.contains("marketplaceSessionId"))
  assert_true(messages_js.contains("__moontown_marketplace_session__"))
  assert_true(
    messages_js.contains(
      "__bunniaSessionTokenForEndpoint(endpointId){if(this.__moontownMarketplaceEndpoint(endpointId))return this.__moontownMarketplaceSession();return undefined}",
    ),
  )
}

///|
test "moontown marketplace maps current drafts to exact Town wire fields" {
  let project = demo_wechat_project()
  let discover_js = file_content(project.files, "pages/moontown/discover.js")
  let messages_js = file_content(project.files, "pages/moontown/messages.js")
  let messages_data = file_content(
    project.files,
    "pages/moontown/messages.data.js",
  )
  assert_true(
    discover_js.contains("capabilities:list(p.capabilities,p.capability_labels"),
  )
  assert_true(discover_js.contains("tags:list(p.tags,p.domain_labels"))
  assert_true(
    discover_js.contains(
      "pricing_summary:text(p.pricing_summary||p.price_label",
    ),
  )
  assert_true(
    discover_js.contains("p.expiresAtMs??p.expiresAt??p.expires_at_ms"),
  )
  assert_true(discover_js.contains("source.listings||source.shared_listings"))
  assert_true(
    discover_js.contains("return {grant_id:text(p.grantId||p.grant_id"),
  )
  for
    field in [
      "channel_id", "visibility", "sensitivity", "workspace_id", "building_listing_id",
      "agent_listing_id", "member_principal_ids",
    ] {
    assert_true(messages_js.contains(field))
  }
  assert_true(messages_data.contains("channelDraft"))
  assert_true(messages_js.contains("memberPrincipalIds"))
}
