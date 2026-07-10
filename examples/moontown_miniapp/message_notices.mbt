///|
fn notification_entry(
  projection : MiniTownProjection,
  notice : MiniTownNotification,
) -> @bunnia.Node {
  @bunnia.keyed(
    "notice-\{notice.id}",
    @bunnia.node(
      kind="view",
      attrs=[
        @bunnia.class_name(
          if notice.unread {
            "moontown-notice-entry moontown-chat-row unread"
          } else {
            "moontown-notice-entry moontown-chat-row read"
          },
        ),
        @bunnia.data(
          "chat-unread",
          if notice.unread {
            "true"
          } else {
            "false"
          },
        ),
        @bunnia.data("notice-action", "open"),
        @bunnia.data("building-id", notice.building_id),
      ],
      events=[@bunnia.tap(notice.action_message)],
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
