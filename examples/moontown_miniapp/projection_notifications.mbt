///|
pub fn unread_notifications(
  projection : MiniTownProjection,
) -> Array[MiniTownNotification] {
  let output : Array[MiniTownNotification] = []
  for notice in visible_notifications(projection) {
    if notice.unread {
      output.push(notice)
    }
  }
  output
}

///|
pub fn subscription_notifications(
  projection : MiniTownProjection,
) -> Array[MiniTownNotification] {
  let output : Array[MiniTownNotification] = []
  for notice in visible_notifications(projection) {
    if notice.requires_subscription {
      output.push(notice)
    }
  }
  output
}

///|
pub fn visible_notifications(
  projection : MiniTownProjection,
) -> Array[MiniTownNotification] {
  let output : Array[MiniTownNotification] = []
  for notice in projection.notifications {
    if mini_town_notification_visible_for(projection, notice) {
      output.push(notice)
    }
  }
  output
}

///|
pub fn filtered_notifications(
  projection : MiniTownProjection,
) -> Array[MiniTownNotification] {
  let channel = selected_notification_channel(projection)
  let output : Array[MiniTownNotification] = []
  for notice in visible_notifications(projection) {
    if mini_town_notification_channel_match(channel, notice) {
      output.push(notice)
    }
  }
  output
}

///|
pub fn selected_notification_channel(
  projection : MiniTownProjection,
) -> MiniTownNotificationChannel {
  for item in projection.notification_channels {
    if item.id == projection.active_notification_channel_id {
      return item
    }
  }
  mini_town_notification_channel(id="all", label="All", kind="all")
}

///|
fn mini_town_notification_channel_match(
  channel : MiniTownNotificationChannel,
  notice : MiniTownNotification,
) -> Bool {
  let kind_match = if channel.kind == "notice" {
    notice.kind == "follow" ||
    notice.kind == "subscription" ||
    notice.kind == "publish" ||
    notice.kind == "share"
  } else {
    channel.kind == "all" || channel.kind == notice.kind
  }
  let unread_match = !channel.unread_only || notice.unread
  kind_match && unread_match
}

///|
fn mini_town_notification_visible_for(
  projection : MiniTownProjection,
  notice : MiniTownNotification,
) -> Bool {
  if notice.building_id == "" {
    return true
  }
  for building in visible_buildings(projection) {
    if building.id == notice.building_id {
      return true
    }
  }
  false
}
