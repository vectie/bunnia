///|
fn add_discovery_filter_event_patches(
  patches : Array[@bunnia.WechatEventPatch],
  projection : MiniTownProjection,
) -> Unit {
  for filter in projection.discovery_filters {
    let patch : Array[@bunnia.Patch] = [
      @bunnia.set_string("discover.filter", filter.id),
    ]
    if discover_filter_updates_backend(filter.id) {
      patch.push(
        @bunnia.set_json(
          "discoverSearch",
          discover_search_filter_json(filter, projection.search_query),
        ),
      )
    }
    patches.push(
      @bunnia.wechat_event_patch("discover-filter-\{filter.id}", patch),
    )
  }
}

///|
fn add_notification_channel_event_patches(
  patches : Array[@bunnia.WechatEventPatch],
  projection : MiniTownProjection,
) -> Unit {
  for channel in projection.notification_channels {
    let patch : Array[@bunnia.Patch] = [
      @bunnia.set_string("messages.channel", channel.id),
    ]
    if notification_channel_updates_backend(channel.id) {
      patch.push(
        @bunnia.set_json(
          "messageCenterQuery",
          message_center_query_json(channel),
        ),
      )
    }
    patches.push(
      @bunnia.wechat_event_patch("notification-channel-\{channel.id}", patch),
    )
  }
}

///|
fn add_ownership_filter_event_patches(
  patches : Array[@bunnia.WechatEventPatch],
  projection : MiniTownProjection,
) -> Unit {
  for filter in projection.ownership_filters {
    let patch : Array[@bunnia.Patch] = [
      @bunnia.set_string("ownership.filter", filter.id),
    ]
    if ownership_filter_updates_backend(filter.id) {
      patch.push(
        @bunnia.set_json("ownershipQuery", ownership_query_json(filter)),
      )
    }
    patches.push(
      @bunnia.wechat_event_patch("ownership-filter-\{filter.id}", patch),
    )
  }
}

///|
fn discover_filter_updates_backend(id : String) -> Bool {
  id == "product" || id == "placeable"
}

///|
fn notification_channel_updates_backend(id : String) -> Bool {
  id == "unread" || id == "agent"
}

///|
fn ownership_filter_updates_backend(id : String) -> Bool {
  id == "drafts" || id == "placements" || id == "books"
}

///|
fn bool_json(value : Bool) -> String {
  if value {
    "true"
  } else {
    "false"
  }
}

///|
fn discover_search_filter_json(
  filter : MiniTownDiscoveryFilter,
  query : String,
) -> String {
  "{\"query\":\"\{query}\",\"filter\":\"\{filter.id}\",\"kind\":\"\{filter.kind}\",\"placeableOnly\":\{bool_json(filter.placeable_only)},\"cursor\":0}"
}

///|
fn ownership_query_json(filter : MiniTownOwnershipFilter) -> String {
  "{\"includeAlerts\":true,\"kind\":\"\{filter.kind}\",\"visibility\":\"\{filter.visibility}\",\"cursor\":0}"
}

///|
fn message_center_query_json(channel : MiniTownNotificationChannel) -> String {
  "{\"channel\":\"\{message_center_channel_for(channel)}\",\"limit\":30,\"cursor\":0}"
}

///|
fn message_center_channel_for(channel : MiniTownNotificationChannel) -> String {
  if channel.unread_only {
    "unread"
  } else {
    channel.kind
  }
}
