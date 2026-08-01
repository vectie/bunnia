///|
fn demo_marketplace_listings() -> Array[MiniTownMarketplaceListing] {
  [
    mini_town_marketplace_listing(
      id="listing-policy-guide",
      kind="agent",
      title="Policy Guide",
      summary="Turns public policy evidence into reviewable answers without exposing private memory.",
      publisher="Knowledge House",
      publisher_id="publisher-knowledge-house",
      recommendation_reason="Recommended because you follow reviewed agent work.",
      building_id="policy-hall",
      price_label="Free preview",
      trust_label="12 accepted outcomes",
      recommended=true,
      actions=["install", "invite", "try", "message", "follow", "share"],
    ),
    mini_town_marketplace_listing(
      id="listing-robotics-workshop",
      kind="building",
      title="Robotics Workshop",
      summary="A public building for embodied-agent field notes, prototypes, and team research sessions.",
      publisher="Deep Cultivator",
      publisher_id="publisher-deep-cultivator",
      recommendation_reason="Recommended because you follow robotics and AI research.",
      building_id="published-agent-lab",
      price_label="Visit free",
      trust_label="Rights checked",
      recommended=true,
      actions=["visit", "follow", "message", "request_access", "share"],
    ),
    mini_town_marketplace_listing(
      id="listing-bookkeeper",
      kind="agent",
      title="Bookkeeper Steward",
      summary="Prepares accepted outcome evidence for a named human review and Three-Gap learning.",
      publisher="MoonBook Guild",
      publisher_id="publisher-moonbook-guild",
      building_id="knowledge-house",
      price_label="Request terms",
      trust_label="Human approval required",
      actions=["install", "invite", "message", "follow", "share"],
    ),
    mini_town_marketplace_listing(
      id="listing-mooncast-atelier",
      kind="building",
      title="Mooncast Atelier",
      summary="A production building for scripts, storyboards, shots, editorial review, and delivery.",
      publisher="Mooncast Studio",
      publisher_id="publisher-mooncast-studio",
      building_id="team-studio",
      price_label="Request access",
      trust_label="Published building",
      actions=["visit", "follow", "message", "request_access", "share"],
    ),
    mini_town_marketplace_listing(
      id="listing-sponsored-agent-launch",
      kind="building",
      title="Agent Launch Studio",
      summary="A guided storefront for packaging and publishing a reviewed Town agent.",
      publisher="Launch Guild",
      publisher_id="publisher-launch-guild",
      sponsored=true,
      sponsor_label="Sponsored by Launch Guild",
      building_id="market-square",
      price_label="Paid placement",
      trust_label="Advertisement",
      actions=["visit", "message", "share"],
    ),
  ]
}

///|
fn demo_conversation_channels() -> Array[MiniTownConversationChannel] {
  [
    mini_town_conversation_channel(
      id="channel-dm-bo",
      kind="direct",
      title="Bo",
      preview="I added the evidence links to the shared draft.",
      context_label="Direct message",
      unread_count=2,
    ),
    mini_town_conversation_channel(
      id="channel-team-builders",
      kind="team",
      title="Builders Guild",
      preview="The robotics use-case review starts this afternoon.",
      context_label="Team room · 6 members",
      unread_count=1,
    ),
    mini_town_conversation_channel(
      id="channel-building-policy",
      kind="building",
      title="Policy Hall Room",
      preview="A public answer is ready for named-human review.",
      context_label="Building room",
      building_id="policy-hall",
      unread_count=1,
    ),
    mini_town_conversation_channel(
      id="channel-agent-guide",
      kind="agent",
      title="Policy Guide",
      preview="I found one contradiction that needs your decision.",
      context_label="Private agent conversation",
      building_id="policy-hall",
      unread_count=1,
    ),
  ]
}

///|
fn demo_share_previews() -> Array[MiniTownSharePreview] {
  [
    mini_town_share_preview(
      id="preview-agent-policy-guide",
      listing_id="ada-policy-guide-card",
      kind="agent",
      title="Policy Guide",
      safe_summary="Public capability card with examples, permissions, price, and review evidence.",
      publisher="Ada Builder",
      included_fields=[
        "Name, avatar, publisher", "Capabilities and examples", "Required permissions and price",
        "Reviews and version",
      ],
      withheld_fields=[
        "Private memory and conversations", "Runtime journals and authority receipts",
        "Host paths, secrets, and consent records",
      ],
    ),
    mini_town_share_preview(
      id="preview-building-robotics-workshop",
      listing_id="ada-robotics-workshop",
      kind="building",
      title="Robotics Workshop",
      safe_summary="Public storefront with a safe book summary, services, rights, and accepted outcomes.",
      publisher="Ada Builder",
      included_fields=[
        "Purpose, domain, publisher", "Published artifacts and services", "Rights, license, and price",
        "Reviews and accepted outcomes",
      ],
      withheld_fields=[
        "Raw MoonBook pages and drafts", "Private members and messages", "Runtime payloads, paths, and secrets",
      ],
    ),
  ]
}
