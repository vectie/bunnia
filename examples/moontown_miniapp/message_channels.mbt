///|
fn message_count_text(count : Int) -> String {
  if count == 1 {
    "1 item"
  } else {
    "\{count} items"
  }
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
