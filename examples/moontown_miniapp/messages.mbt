///|
// Attention Center assembly stays compact; rows, buckets, and channels live beside it.

///|
fn messages_panel(projection : MiniTownProjection) -> @bunnia.Node {
  let unread = unread_notifications(projection)
  let subscription = subscription_notifications(projection)
  let reviews = review_runs(projection)
  let notices = filtered_notifications(projection)
  @bunnia.view_with_attrs([@bunnia.class_name("mt-panel")], [
    @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-title")], [
      @bunnia.text("Attention Center"),
    ]),
    @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-note")], [
      @bunnia.text(
        "\{unread.length()} unread; \{reviews.length()} agent review; \{subscription.length()} watch prompt.",
      ),
    ]),
    message_attention_actions(),
    message_attention_stack(projection),
    message_bucket_row(projection),
    @bunnia.view_with_attrs([@bunnia.class_name("moontown-message-channels")], [
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
    ]),
    @bunnia.windowed_list(notices, total_count=notices.length(), render=notice => {
      notification_entry(projection, notice)
    }),
  ])
}
