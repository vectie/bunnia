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

///|
priv struct MessageAttentionRow {
  id : String
  title : String
  summary : String
  status : String
  action_label : String
  action_message : String
  building_id : String
}

///|
fn message_attention_row(
  id~ : String,
  title~ : String,
  summary~ : String,
  status~ : String,
  action_label~ : String,
  action_message~ : String,
  building_id~ : String,
) -> MessageAttentionRow {
  { id, title, summary, status, action_label, action_message, building_id }
}

///|
fn message_attention_actions() -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-community-actions")], [
    @bunnia.button("Latest Messages", "load-message-center"),
    @bunnia.button("More", "load-message-center"),
  ])
}

///|
fn message_attention_stack(projection : MiniTownProjection) -> @bunnia.Node {
  let rows = message_attention_rows(projection)
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-attention-rows")], [
    @bunnia.windowed_list(
      rows,
      total_count=rows.length(),
      render=message_attention_row_entry,
    ),
  ])
}

///|
fn message_attention_rows(
  projection : MiniTownProjection,
) -> Array[MessageAttentionRow] {
  let rows : Array[MessageAttentionRow] = []
  let reviews = pending_reviews(projection)
  if reviews.length() > 0 {
    let review = reviews[0]
    rows.push(
      message_attention_row(
        id="review",
        title="Review waiting answer",
        summary="\{building_title_by_id(projection, review.building_id)} needs a decision before memory is saved.",
        status="review",
        action_label="Review",
        action_message="open-notice-review",
        building_id=review.building_id,
      ),
    )
  }
  let runs = active_runs(projection)
  if runs.length() > 0 {
    let run = runs[0]
    rows.push(
      message_attention_row(
        id="agent-work",
        title="Agent work in progress",
        summary="\{building_title_by_id(projection, run.building_id)} is working from \{book_title_by_id(projection, run.book_id)}.",
        status=run.status,
        action_label="Open Place",
        action_message="open-place-\{run.building_id}",
        building_id=run.building_id,
      ),
    )
  }
  let failed = failed_run_count(projection)
  if failed > 0 {
    rows.push(
      message_attention_row(
        id="failed-work",
        title="Work needs recovery",
        summary="\{message_count_text(failed)} can be retried or stopped from Agent Work.",
        status="failed",
        action_label="Review Work",
        action_message="notification-channel-unread",
        building_id="",
      ),
    )
  }
  let subscriptions = subscription_notifications(projection)
  if subscriptions.length() > 0 {
    let notice = subscriptions[0]
    rows.push(
      message_attention_row(
        id="signals",
        title="Town signals are available",
        summary=notice.body,
        status="stable",
        action_label=notice.action_label,
        action_message=notice.action_message,
        building_id=notice.building_id,
      ),
    )
  }
  if rows.length() == 0 {
    rows.push(
      message_attention_row(
        id="quiet",
        title="No urgent messages",
        summary="Agent replies, reviews, and town notices will appear here.",
        status="stable",
        action_label="Latest Messages",
        action_message="load-message-center",
        building_id="",
      ),
    )
  }
  rows
}

///|
fn message_attention_row_entry(row : MessageAttentionRow) -> @bunnia.Node {
  @bunnia.keyed(
    "attention-row-\{row.id}",
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("moontown-attention-row bunnia-status-\{row.status}"),
        @bunnia.data("building-id", row.building_id),
      ],
      [
        @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
          @bunnia.text(row.title),
        ]),
        @bunnia.text(row.summary),
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-run-actions")], [
          @bunnia.button(row.action_label, row.action_message),
        ]),
      ],
    ),
  )
}

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
