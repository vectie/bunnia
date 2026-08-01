///|
fn add_marketplace_event_patches(
  patches : Array[@bunnia.WechatEventPatch],
) -> Unit {
  patches.push(
    @bunnia.wechat_event_patch("edit-marketplace-search", [
      @bunnia.set_json("discover.suggestionsOpen", "true"),
    ]),
  )
  patches.push(
    @bunnia.wechat_event_patch("marketplace-search", [
      @bunnia.set_string("ui.feedback", "marketplace-search"),
      @bunnia.set_json("discover.suggestionsOpen", "false"),
    ]),
  )
  patches.push(
    @bunnia.wechat_event_patch("load-marketplace-recommendations", [
      @bunnia.set_string("ui.feedback", "marketplace-recommendations"),
    ]),
  )
  patches.push(
    @bunnia.wechat_event_patch("load-marketplace-feed", [
      @bunnia.set_string("ui.feedback", "marketplace-feed"),
    ]),
  )
  patches.push(
    @bunnia.wechat_event_patch("marketplace-listing-action", [
      @bunnia.set_string("ui.feedback", "marketplace-action"),
    ]),
  )
  for
    id in [
      "load-marketplace-action-requests", "decide-marketplace-action-request", "retry-marketplace-action-handoff",
    ] {
    patches.push(
      @bunnia.wechat_event_patch(id, [
        @bunnia.set_string("ui.feedback", "marketplace-action-requests"),
      ]),
    )
  }
  patches.push(
    @bunnia.wechat_event_patch("notification-channel-requests", [
      @bunnia.set_string("messages.channel", "requests"),
    ]),
  )
  patches.push(
    @bunnia.wechat_event_patch("preview-marketplace-share", [
      @bunnia.set_string("ui.feedback", "marketplace-share-preview"),
    ]),
  )
  patches.push(
    @bunnia.wechat_event_patch("publish-agent-listing", [
      @bunnia.set_string("ui.feedback", "publish-listing"),
    ]),
  )
  patches.push(
    @bunnia.wechat_event_patch("publish-building-listing", [
      @bunnia.set_string("ui.feedback", "publish-listing"),
    ]),
  )
  patches.push(
    @bunnia.wechat_event_patch("transition-marketplace-listing", [
      @bunnia.set_string("ui.feedback", "publish-listing"),
    ]),
  )
  patches.push(
    @bunnia.wechat_event_patch("create-marketplace-share-grant", [
      @bunnia.set_string("ui.feedback", "marketplace-share"),
    ]),
  )
  patches.push(
    @bunnia.wechat_event_patch("load-shared-marketplace-listings", [
      @bunnia.set_string("ui.feedback", "marketplace-shared"),
    ]),
  )
  patches.push(
    @bunnia.wechat_event_patch("revoke-marketplace-share-grant", [
      @bunnia.set_string("ui.feedback", "marketplace-share-revoke"),
    ]),
  )
  patches.push(
    @bunnia.wechat_event_patch("edit-marketplace-share-recipient", []),
  )
  patches.push(
    @bunnia.wechat_event_patch("message-mode-chats", [
      @bunnia.set_string("messages.mode", "chats"),
      @bunnia.set_string("messages.channel", "all"),
      @bunnia.set_json("messages.channelOpen", "false"),
    ]),
  )
  patches.push(
    @bunnia.wechat_event_patch("message-mode-notifications", [
      @bunnia.set_string("messages.mode", "notifications"),
      @bunnia.set_string("messages.channel", "all"),
      @bunnia.set_json("messages.channelOpen", "false"),
    ]),
  )
  patches.push(
    @bunnia.wechat_event_patch("message-mode-work", [
      @bunnia.set_string("messages.mode", "work"),
      @bunnia.set_string("messages.channel", "supervisor"),
      @bunnia.set_json("messages.channelOpen", "false"),
    ]),
  )
  for id in ["all", "direct", "team", "building", "agent"] {
    patches.push(
      @bunnia.wechat_event_patch("channel-kind-\{id}", [
        @bunnia.set_string("messages.channelKind", id),
        @bunnia.set_json("messages.channelOpen", "false"),
      ]),
    )
  }
  for id in ["all", "unread"] {
    patches.push(
      @bunnia.wechat_event_patch("notification-channel-\{id}", [
        @bunnia.set_string("messages.channel", id),
      ]),
    )
  }
  patches.push(
    @bunnia.wechat_event_patch("load-marketplace-channels", [
      @bunnia.set_string("ui.feedback", "channels"),
    ]),
  )
  patches.push(
    @bunnia.wechat_event_patch("load-channel-messages", [
      @bunnia.set_string("ui.feedback", "channel-messages"),
    ]),
  )
  patches.push(@bunnia.wechat_event_patch("edit-channel-message", []))
  patches.push(
    @bunnia.wechat_event_patch("send-channel-message", [
      @bunnia.set_string("ui.feedback", "channel-message"),
    ]),
  )
  patches.push(
    @bunnia.wechat_event_patch("load-marketplace-notifications", [
      @bunnia.set_string("ui.feedback", "notifications"),
    ]),
  )
  patches.push(
    @bunnia.wechat_event_patch("read-marketplace-notification", [
      @bunnia.set_string("ui.feedback", "notifications"),
    ]),
  )
  patches.push(
    @bunnia.wechat_event_patch("update-marketplace-subscription", [
      @bunnia.set_string("ui.feedback", "notifications"),
    ]),
  )
  patches.push(
    @bunnia.wechat_event_patch("create-marketplace-channel", [
      @bunnia.set_string("ui.feedback", "channel-create"),
    ]),
  )
  patches.push(@bunnia.wechat_event_patch("edit-channel-title", []))
  patches.push(@bunnia.wechat_event_patch("edit-channel-members", []))
}
