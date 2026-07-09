///|
fn message_bucket_row(projection : MiniTownProjection) -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-message-buckets")], [
    message_bucket_chip(
      label="Needs Review",
      count=notification_kind_count(projection, "review") +
        review_runs(projection).length(),
      channel_id="review",
    ),
    message_bucket_chip(
      label="Agent Replies",
      count=notification_kind_count(projection, "agent-run"),
      channel_id="agent",
    ),
    message_bucket_chip(
      label="Interactions",
      count=notification_kind_count(projection, "interaction"),
      channel_id="interaction",
    ),
    message_bucket_chip(
      label="Town Notices",
      count=notification_kind_count(projection, "follow") +
        notification_kind_count(projection, "subscription"),
      channel_id="system",
    ),
    message_bucket_chip(
      label="Failed Actions",
      count=failed_run_count(projection),
      channel_id="unread",
    ),
  ])
}

///|
fn message_bucket_chip(
  label~ : String,
  count~ : Int,
  channel_id~ : String,
) -> @bunnia.Node {
  @bunnia.node(
    kind="view",
    attrs=[@bunnia.class_name("moontown-message-bucket")],
    events=[@bunnia.event("tap", "notification-channel-\{channel_id}")],
    children=[
      @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
        @bunnia.text(label),
      ]),
      @bunnia.text(message_count_text(count)),
    ],
  )
}
