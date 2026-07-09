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
