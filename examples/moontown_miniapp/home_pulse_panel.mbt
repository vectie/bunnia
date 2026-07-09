///|
fn home_pulse_panel(projection : MiniTownProjection) -> @bunnia.Node {
  let activity = town_activity_items(projection)
  let attention = visible_reviews(projection).length() +
    unread_notifications(projection).length()
  let rows = home_pulse_rows(projection, activity)
  @bunnia.view_with_attrs([@bunnia.class_name("mt-panel")], [
    @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-title")], [
      @bunnia.text("Town Pulse"),
    ]),
    @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-note")], [
      @bunnia.text(
        "\{home_changed_places_count(activity)} places changed. \{attention} items need attention.",
      ),
    ]),
    @bunnia.view_with_attrs(
      [@bunnia.class_name("moontown-community-actions")],
      [
        @bunnia.button("Open", "tab-realm"),
        @bunnia.button("Review", "tab-messages"),
        @bunnia.button("More", "tab-discover"),
      ],
    ),
    @bunnia.windowed_list(
      rows,
      total_count=rows.length(),
      render=home_pulse_entry,
    ),
  ])
}

///|
fn home_pulse_entry(item : HomePulseRow) -> @bunnia.Node {
  @bunnia.keyed(
    "home-pulse-\{item.id}",
    @bunnia.node(
      kind="view",
      attrs=[
        @bunnia.class_name("moontown-notice-entry bunnia-status-\{item.status}"),
        @bunnia.data("home-pulse", item.id),
        @bunnia.data("action-message", item.action_message),
        @bunnia.data("target-tab", item.target_tab),
      ],
      events=[@bunnia.event("tap", item.action_message)],
      children=[
        @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
          @bunnia.text(item.title),
        ]),
        @bunnia.text(item.summary),
        @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
          @bunnia.text(
            "\{item.action_label} - \{town_tab_label(item.target_tab)}",
          ),
        ]),
      ],
    ),
  )
}
