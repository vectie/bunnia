///|
fn demo_notifications() -> Array[MiniTownNotification] {
  [
    mini_town_notification(
      id="notice-review",
      kind="review",
      title="Memory review needed",
      body="Policy Hall has an accepted answer waiting for book review.",
      target_ref="thread-policy-hall",
      building_id="policy-hall",
      action_label="Review",
      action_message="open-notice-review",
    ),
    mini_town_notification(
      id="notice-publish",
      kind="publish",
      title="Draft ready to publish",
      body="Private Agent Lab can be submitted after profile consent.",
      target_ref="building-private-agent-lab",
      building_id="private-agent-lab",
      action_label="Open Draft",
      action_message="open-notice-publish",
    ),
    mini_town_notification(
      id="notice-share",
      kind="share",
      title="Team building shared",
      body="Team Studio is visible to organization members.",
      target_ref="building-team-studio",
      building_id="team-studio",
      action_label="Open Team",
      action_message="open-notice-share",
      unread=false,
    ),
    mini_town_notification(
      id="notice-run",
      kind="agent-run",
      title="Agent work completed",
      body="Market placement scan finished with a placeable building suggestion.",
      target_ref="run-market-scan",
      building_id="market-square",
      action_label="Open Work",
      action_message="open-notice-run",
    ),
    mini_town_notification(
      id="notice-follow",
      kind="follow",
      title="Deep Cultivator followed your town",
      body="A new AI walker is watching your public building updates.",
      target_ref="user:user-deep-cultivator",
      building_id="",
      action_label="Open Walker",
      action_message="open-notice-follow",
    ),
    mini_town_notification(
      id="notice-interaction",
      kind="interaction",
      title="Enterprise Club replied",
      body="The circle left feedback on your team place.",
      target_ref="circle:enterprise-club",
      building_id="team-studio",
      action_label="Open Circle",
      action_message="open-notice-interaction",
    ),
    mini_town_notification(
      id="notice-subscribe",
      kind="subscription",
      title="Subscribe to town signals",
      body="Receive agent work, review, publish, and share notices through WeChat.",
      target_ref="subscription:wechat",
      building_id="gateway",
      action_label="Subscribe",
      action_message="request-subscription",
      requires_subscription=true,
      unread=false,
    ),
  ]
}

///|
fn demo_notification_channels() -> Array[MiniTownNotificationChannel] {
  [
    mini_town_notification_channel(id="all", label="All", kind="all"),
    mini_town_notification_channel(
      id="unread",
      label="Unread",
      kind="all",
      unread_only=true,
    ),
    mini_town_notification_channel(
      id="interaction",
      label="Activity",
      kind="interaction",
    ),
    mini_town_notification_channel(
      id="agent",
      label="Replies",
      kind="agent-run",
    ),
    mini_town_notification_channel(id="notices", label="Notices", kind="notice"),
  ]
}

///|
fn demo_watches() -> Array[MiniTownWatch] {
  [
    mini_town_watch(
      id="watch-policy-hall",
      user_id="user-a",
      target_ref="building:policy-hall",
      title="Policy Hall",
      summary="Public review and book-memory updates are watched.",
      action_message="select-policy-hall",
    ),
  ]
}

///|
fn demo_ownership_filters() -> Array[MiniTownOwnershipFilter] {
  [
    mini_town_ownership_filter(id="all", label="All"),
    mini_town_ownership_filter(
      id="placements",
      label="Placed",
      kind="placement",
    ),
    mini_town_ownership_filter(
      id="drafts",
      label="Drafts",
      visibility="private_draft",
    ),
    mini_town_ownership_filter(
      id="published",
      label="Published",
      visibility="published",
    ),
    mini_town_ownership_filter(id="books", label="Books", kind="book"),
    mini_town_ownership_filter(id="agents", label="Agents", kind="agent"),
    mini_town_ownership_filter(id="watches", label="Watches", kind="watch"),
  ]
}

///|
