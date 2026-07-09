///|
fn message_count_text(count : Int) -> String {
  if count == 1 {
    "1 item"
  } else {
    "\{count} items"
  }
}

///|
fn notification_kind_count(
  projection : MiniTownProjection,
  kind : String,
) -> Int {
  let mut count = 0
  for notice in visible_notifications(projection) {
    if notice.kind == kind {
      count += 1
    }
  }
  count
}

///|
fn notification_channel_chip(
  channel : MiniTownNotificationChannel,
  active_channel_id : String,
) -> @bunnia.Node {
  @bunnia.keyed(
    "notice-channel-\{channel.id}",
    @bunnia.node(
      kind="view",
      attrs=[
        @bunnia.class_name(
          if channel.id == active_channel_id {
            "moontown-message-channel active"
          } else {
            "moontown-message-channel"
          },
        ),
      ],
      events=[@bunnia.event("tap", "notification-channel-\{channel.id}")],
      children=[@bunnia.text(channel.label)],
    ),
  )
}
