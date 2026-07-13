///|
fn notification_entry(
  projection : MiniTownProjection,
  notice : MiniTownNotification,
) -> @bunnia.Node {
  let attrs = [
    @bunnia.class_name(
      if notice.unread {
        "moontown-notice-entry moontown-chat-row unread"
      } else {
        "moontown-notice-entry moontown-chat-row read"
      },
    ),
    @bunnia.data("chat-unread", if notice.unread { "true" } else { "false" }),
    @bunnia.data("notice-action", "open"),
    @bunnia.data("building-id", notice.building_id),
    @bunnia.attr("wx:if", notification_row_visibility(notice)),
  ]
  if !notice.requires_subscription {
    attrs.push(
      town_route_attr(
        if notice.building_id == "" {
          "discover"
        } else {
          "realm"
        },
      ),
    )
  }
  @bunnia.keyed(
    "notice-\{notice.id}",
    @bunnia.node(
      kind="view",
      attrs~,
      events=[@bunnia.tap(notification_tap_message(notice))],
      children=[
        @bunnia.view_with_attrs(
          [@bunnia.class_name("moontown-chat-avatar kind-\{notice.kind}")],
          [@bunnia.text(notification_avatar_label(notice.kind))],
        ),
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-chat-copy")], [
          @bunnia.view_with_attrs(
            [@bunnia.class_name("moontown-chat-title-row")],
            [
              @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
                @bunnia.text(notice.title),
              ]),
              notification_unread_indicator(notice),
            ],
          ),
          @bunnia.view_with_attrs(
            [@bunnia.class_name("moontown-chat-preview")],
            [@bunnia.text(notice.body)],
          ),
          @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
            @bunnia.text(notification_context_text(projection, notice)),
          ]),
        ]),
      ],
    ),
  )
}

///|
fn notification_tap_message(notice : MiniTownNotification) -> String {
  if notice.requires_subscription {
    notice.action_message
  } else if notice.building_id == "" {
    "tab-discover"
  } else {
    "open-place-\{notice.building_id}"
  }
}

///|
fn notification_row_visibility(notice : MiniTownNotification) -> String {
  let channels = ["messages.channel == 'all'"]
  if notice.unread {
    channels.push("messages.channel == 'unread'")
  }
  if notice.kind == "interaction" {
    channels.push("messages.channel == 'interaction'")
  }
  if notice.kind == "agent-run" {
    channels.push("messages.channel == 'agent'")
  }
  if notice.kind == "publish" ||
    notice.kind == "share" ||
    notice.kind == "follow" ||
    notice.kind == "subscription" {
    channels.push("messages.channel == 'notices'")
  }
  "{{\{channels.join(" || ")}}}"
}

///|
fn notification_avatar_label(kind : String) -> String {
  if kind == "agent-run" {
    "A"
  } else if kind == "review" {
    "R"
  } else if kind == "interaction" {
    "I"
  } else if kind == "follow" {
    "F"
  } else if kind == "subscription" {
    "S"
  } else {
    "M"
  }
}

///|
fn notification_unread_indicator(notice : MiniTownNotification) -> @bunnia.Node {
  if notice.unread {
    @bunnia.view_with_attrs([@bunnia.class_name("moontown-chat-unread-dot")], [])
  } else {
    @bunnia.view([])
  }
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
