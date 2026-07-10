///|
fn message_notices_panel(projection : MiniTownProjection) -> @bunnia.Node {
  let notices = filtered_notifications(projection)
  @bunnia.view_with_attrs(
    [@bunnia.class_name("mt-panel moontown-message-notices")],
    [
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-chat-list-header")],
        [
          @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-title")], [
            @bunnia.text("Chats"),
          ]),
          @bunnia.node(
            kind="button",
            attrs=[
              @bunnia.class_name("moontown-chat-refresh"),
              @bunnia.attr("aria-label", "Refresh chats"),
            ],
            events=[@bunnia.tap("load-message-center")],
            children=[@bunnia.text("↻")],
          ),
        ],
      ),
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-message-channels")],
        [
          @bunnia.windowed_list(
            projection.notification_channels,
            total_count=projection.notification_channels.length(),
            render=channel => {
              notification_channel_chip(
                channel,
                projection.active_notification_channel_id,
              )
            },
          ),
        ],
      ),
      @bunnia.view_with_attrs([@bunnia.class_name("moontown-notice-list")], [
        @bunnia.windowed_list(notices, total_count=notices.length(), render=notice => {
          notification_entry(projection, notice)
        }),
      ]),
    ],
  )
}
