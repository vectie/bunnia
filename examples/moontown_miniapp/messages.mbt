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
fn message_attention_actions() -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-community-actions")], [
    @bunnia.button("Latest Messages", "load-message-center"),
    @bunnia.button("More", "load-message-center"),
  ])
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

///|
fn run_queue_panel(projection : MiniTownProjection) -> @bunnia.Node {
  let runs = active_runs(projection)
  @bunnia.view_with_attrs([@bunnia.class_name("mt-panel")], [
    @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-title")], [
      @bunnia.text("Agent Work"),
    ]),
    @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-note")], [
      @bunnia.text(
        "Agent work stays attached to places, books, and review decisions.",
      ),
    ]),
    @bunnia.windowed_list(runs, total_count=runs.length(), render=run => {
      run_queue_entry(projection, run)
    }),
  ])
}

///|
fn run_queue_entry(
  projection : MiniTownProjection,
  run : MiniTownRun,
) -> @bunnia.Node {
  @bunnia.keyed(
    "run-queue-\{run.id}",
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("moontown-run-entry bunnia-status-\{run.status}"),
        @bunnia.data("building-id", run.building_id),
        @bunnia.data("book-id", run.book_id),
      ],
      [
        @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
          @bunnia.text(run.title),
        ]),
        @bunnia.text(run.summary),
        @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
          @bunnia.text(run_context_text(projection, run)),
        ]),
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-run-actions")], [
          @bunnia.list(run_actions(run), run_action_button),
        ]),
      ],
    ),
  )
}

///|
fn run_action_button(action : MiniTownRunAction) -> @bunnia.Node {
  let attrs = [
    @bunnia.class_name("moontown-run-action \{action.status}"),
    @bunnia.data("run-action", action.id),
    @bunnia.data("allowed", if action.allowed { "true" } else { "false" }),
    @bunnia.data("blocked-reason", action.reason),
  ]
  if !action.allowed {
    attrs.push(@bunnia.attr("disabled", "true"))
  }
  @bunnia.keyed(
    "run-action-\{action.id}",
    @bunnia.node(
      kind="button",
      attrs~,
      events=[@bunnia.event("tap", action.message)],
      children=[@bunnia.text(run_action_display_label(action))],
    ),
  )
}

///|
fn run_context_text(
  projection : MiniTownProjection,
  run : MiniTownRun,
) -> String {
  "\{town_status_label(run.status)} - \{building_title_by_id(projection, run.building_id)} - \{book_title_by_id(projection, run.book_id)}"
}

///|
fn run_action_display_label(action : MiniTownRunAction) -> String {
  if action.message == "retry-run" {
    "Try Again"
  } else if action.message == "cancel-run" {
    "Stop Work"
  } else {
    action.label
  }
}

///|
fn failed_run_count(projection : MiniTownProjection) -> Int {
  let mut count = 0
  for run in visible_runs(projection) {
    if run.status == "failed" || run.status == "cancelled" {
      count += 1
    }
  }
  count
}

///|
fn building_title_by_id(
  projection : MiniTownProjection,
  building_id : String,
) -> String {
  for building in visible_buildings(projection) {
    if building.id == building_id {
      return building.title
    }
  }
  building_id
}

///|
fn book_title_by_id(
  projection : MiniTownProjection,
  book_id : String,
) -> String {
  for book in visible_books(projection) {
    if book.id == book_id {
      return book.title
    }
  }
  book_id
}

///|
fn tool_result_panel(projection : MiniTownProjection) -> @bunnia.Node {
  let results = visible_tool_results(projection)
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("mt-panel moontown-agent-results"),
      @bunnia.data("agent-result-count", results.length().to_string()),
    ],
    [
      @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-title")], [
        @bunnia.text("Agent Results"),
      ]),
      @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-note")], [
        @bunnia.text(
          "Reviewed agent output stays attached to a place and can be opened or cleared.",
        ),
      ]),
      @bunnia.windowed_list(results, total_count=results.length(), render=item => {
        agent_result_entry(projection, item)
      }),
    ],
  )
}

///|
fn agent_result_entry(
  projection : MiniTownProjection,
  item : MiniTownToolResult,
) -> @bunnia.Node {
  @bunnia.keyed(
    "agent-result-\{item.id}",
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("moontown-agent-result"),
        @bunnia.data("building-id", item.building_id),
      ],
      [
        @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
          @bunnia.text(item.title),
        ]),
        @bunnia.text(item.summary),
        @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
          @bunnia.text(
            "\{building_title_by_id(projection, item.building_id)} - Review result",
          ),
        ]),
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-run-actions")], [
          agent_result_open_button(item),
          @bunnia.button("Review Result", item.acknowledge_message),
        ]),
      ],
    ),
  )
}

///|
fn agent_result_open_button(item : MiniTownToolResult) -> @bunnia.Node {
  if high_leverage_place_route(item.building_id) {
    open_place_button(item.building_id)
  } else {
    @bunnia.button("Open Work", item.open_message)
  }
}

///|
fn review_queue_panel(projection : MiniTownProjection) -> @bunnia.Node {
  let reviews = pending_reviews(projection)
  @bunnia.view_with_attrs([@bunnia.class_name("mt-panel")], [
    @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-title")], [
      @bunnia.text("Needs Review"),
    ]),
    @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-note")], [
      @bunnia.text(
        "Approve useful memory or reject work before it enters town books.",
      ),
    ]),
    @bunnia.windowed_list(reviews, total_count=reviews.length(), render=item => {
      review_entry(projection, item)
    }),
  ])
}

///|
fn review_entry(
  projection : MiniTownProjection,
  item : MiniTownReviewItem,
) -> @bunnia.Node {
  @bunnia.keyed(
    "review-\{item.id}",
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("moontown-review-entry bunnia-status-\{item.status}"),
        @bunnia.data("building-id", item.building_id),
        @bunnia.data("book-id", item.book_id),
      ],
      [
        @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
          @bunnia.text(item.title),
        ]),
        @bunnia.text(item.summary),
        @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
          @bunnia.text(
            "\{building_title_by_id(projection, item.building_id)} - \{book_title_by_id(projection, item.book_id)} - \{review_meta_text(item)}",
          ),
        ]),
        review_controls_entry(item),
      ],
    ),
  )
}

///|
fn review_controls_entry(item : MiniTownReviewItem) -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("bunnia-review bunnia-review-pending"),
      @bunnia.data("review-enabled", "true"),
    ],
    [
      @bunnia.text(review_kind_label(item)),
      review_decision_button("Approve", "accept", item.accept_message),
      review_decision_button("Reject", "reject", item.reject_message),
    ],
  )
}

///|
fn review_kind_label(item : MiniTownReviewItem) -> String {
  if item.artifact_ref.has_prefix("building://") {
    "Publication review"
  } else {
    "Memory review"
  }
}

///|
fn review_meta_text(item : MiniTownReviewItem) -> String {
  if item.artifact_ref.has_prefix("building://") {
    "\{town_status_label(item.status)} - publication review"
  } else {
    "\{town_status_label(item.status)} - +\{item.accepted_memory_delta} memory"
  }
}

///|
fn review_decision_button(
  label : String,
  decision : String,
  message : String,
) -> @bunnia.Node {
  @bunnia.node(
    kind="button",
    attrs=[
      @bunnia.class_name("bunnia-review-button bunnia-review-button-enabled"),
      @bunnia.data("decision", decision),
    ],
    events=[@bunnia.tap(message)],
    children=[@bunnia.text(label)],
  )
}

///|
fn notification_entry(
  projection : MiniTownProjection,
  notice : MiniTownNotification,
) -> @bunnia.Node {
  @bunnia.keyed(
    "notice-\{notice.id}",
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("moontown-notice-entry"),
        @bunnia.data("building-id", notice.building_id),
      ],
      [
        @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
          @bunnia.text(notice.title),
        ]),
        @bunnia.text(notice.body),
        @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
          @bunnia.text(notification_context_text(projection, notice)),
        ]),
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-run-actions")], [
          notification_place_button(notice),
          notification_action_button(notice),
          notification_ack_button(notice),
        ]),
      ],
    ),
  )
}

///|
fn notification_context_text(
  projection : MiniTownProjection,
  notice : MiniTownNotification,
) -> String {
  if notice.building_id == "" {
    town_kind_label(notice.kind)
  } else {
    "\{building_title_by_id(projection, notice.building_id)} - \{town_kind_label(notice.kind)}"
  }
}

///|
fn notification_action_button(notice : MiniTownNotification) -> @bunnia.Node {
  notification_button(
    notice,
    label=notice.action_label,
    message=notice.action_message,
    action="open",
  )
}

///|
fn notification_place_button(notice : MiniTownNotification) -> @bunnia.Node {
  if high_leverage_place_route(notice.building_id) {
    open_place_button(notice.building_id)
  } else {
    @bunnia.view([])
  }
}

///|
fn notification_ack_button(notice : MiniTownNotification) -> @bunnia.Node {
  notification_button(
    notice,
    label="Mark Read",
    message="ack-notification",
    action="ack",
  )
}

///|
fn notification_button(
  notice : MiniTownNotification,
  label~ : String,
  message~ : String,
  action~ : String,
) -> @bunnia.Node {
  @bunnia.node(
    kind="button",
    attrs=[
      @bunnia.class_name("moontown-notice-action"),
      @bunnia.data("notice-action", action),
      @bunnia.data("building-id", notice.building_id),
    ],
    events=[@bunnia.tap(message)],
    children=[@bunnia.text(label)],
  )
}
