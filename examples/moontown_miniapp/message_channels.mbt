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
  _active_channel_id : String,
) -> @bunnia.Node {
  @bunnia.keyed(
    "notice-channel-\{channel.id}",
    @bunnia.node(
      kind="view",
      attrs=[
        @bunnia.class_name(
          "moontown-message-channel {{messages.channel == '\{channel.id}' ? 'active' : ''}}",
        ),
      ],
      events=[@bunnia.event("tap", "notification-channel-\{channel.id}")],
      children=[@bunnia.text(channel.label)],
    ),
  )
}
