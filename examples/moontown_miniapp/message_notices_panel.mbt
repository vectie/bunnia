///|
fn message_notices_panel(projection : MiniTownProjection) -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [@bunnia.class_name("mt-panel moontown-message-notices")],
    [
      marketplace_message_mode_bar(),
      marketplace_chat_directory(projection),
      marketplace_notification_center(projection),
      marketplace_work_channels(),
      backend_feedback(
        "chats", "Refreshing...", "Inbox is up to date.", "Could not refresh the inbox. Try again.",
      ),
    ],
  )
}

///|
fn simple_message_channel(id : String, label : String) -> @bunnia.Node {
  @bunnia.node(
    kind="button",
    attrs=[
      @bunnia.class_name(
        "moontown-message-channel {{messages.channel == '\{id}' ? 'active' : ''}}",
      ),
    ],
    events=[@bunnia.event("tap", "notification-channel-\{id}")],
    children=[@bunnia.text(label)],
  )
}
