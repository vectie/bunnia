///|
fn home_pulse_panel(projection : MiniTownProjection) -> @bunnia.Node {
  let activity = town_activity_items(projection)
  let attention = visible_reviews(projection).length() +
    unread_notifications(projection).length()
  let rows = home_pulse_rows(projection, activity)
  let lead = home_pulse_lead(rows)
  let followups = home_pulse_followups(rows, lead.id)
  @bunnia.view_with_attrs(
    [@bunnia.class_name("mt-panel moontown-home-pulse")],
    [
      @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-title")], [
        @bunnia.text("Town Pulse"),
      ]),
      @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-note")], [
        @bunnia.text("Start with what needs you, then see what changed."),
      ]),
      home_pulse_lead_entry(lead),
      @bunnia.view_with_attrs([@bunnia.class_name("moontown-home-stats")], [
        home_pulse_stat(
          "changed",
          home_changed_places_count(activity).to_string(),
          "places changed",
        ),
        home_pulse_stat("attention", attention.to_string(), "need attention"),
        home_pulse_stat(
          "nearby",
          community_presence(projection).length().to_string(),
          "nearby now",
        ),
      ]),
      @bunnia.view_with_attrs([@bunnia.class_name("moontown-section-label")], [
        @bunnia.text("Around town"),
      ]),
      @bunnia.windowed_list(
        followups,
        total_count=followups.length(),
        render=home_pulse_entry,
      ),
    ],
  )
}

///|
fn home_pulse_lead_entry(item : HomePulseRow) -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-home-lead bunnia-status-\{item.status}"),
      @bunnia.data("home-lead", item.id),
      @bunnia.data("target-tab", item.target_tab),
    ],
    [
      @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
        @bunnia.text(item.title),
      ]),
      @bunnia.text(item.summary),
      @bunnia.node(
        kind="button",
        attrs=[@bunnia.class_name("moontown-primary-action")],
        events=[@bunnia.tap(item.action_message)],
        children=[
          @bunnia.text(
            "\{item.action_label} \{town_tab_label(item.target_tab)}",
          ),
        ],
      ),
    ],
  )
}

///|
fn home_pulse_stat(id : String, value : String, label : String) -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [@bunnia.class_name("moontown-home-stat"), @bunnia.data("home-stat", id)],
    [
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-home-stat-value")],
        [@bunnia.text(value)],
      ),
      @bunnia.text(label),
    ],
  )
}

///|
fn home_pulse_entry(item : HomePulseRow) -> @bunnia.Node {
  @bunnia.keyed(
    "home-pulse-\{item.id}",
    @bunnia.node(
      kind="view",
      attrs=[
        @bunnia.class_name(
          "moontown-notice-entry moontown-home-followup bunnia-status-\{item.status}",
        ),
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
