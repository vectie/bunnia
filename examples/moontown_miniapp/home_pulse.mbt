///|
priv struct HomePulseRow {
  id : String
  title : String
  summary : String
  status : String
  action_label : String
  action_message : String
  target_tab : String
}

///|
fn home_pulse_row(
  id~ : String,
  title~ : String,
  summary~ : String,
  status~ : String,
  action_label~ : String,
  action_message~ : String,
  target_tab~ : String,
) -> HomePulseRow {
  { id, title, summary, status, action_label, action_message, target_tab }
}

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
fn home_pulse_rows(
  projection : MiniTownProjection,
  activity : Array[MiniTownActivityItem],
) -> Array[HomePulseRow] {
  let reviews = visible_reviews(projection)
  let unread = unread_notifications(projection)
  let market = market_discovery_results(projection)
  let refresh_count = home_refresh_count(projection)
  [
    home_pulse_row(
      id="changes",
      title="\{home_changed_places_count(activity)} places changed",
      summary=home_activity_summary(activity),
      status="stable",
      action_label="Open",
      action_message="tab-realm",
      target_tab="realm",
    ),
    home_pulse_row(
      id="attention",
      title=if reviews.length() + unread.length() > 0 {
        "Agent needs your decision"
      } else {
        "Messages are quiet"
      },
      summary=home_attention_summary(reviews, unread),
      status=if reviews.length() + unread.length() > 0 {
        "review"
      } else {
        "stable"
      },
      action_label="Review",
      action_message="tab-messages",
      target_tab="messages",
    ),
    home_pulse_row(
      id="market",
      title="Market has new public places",
      summary="\{market.length()} public results are ready to open or place.",
      status="stable",
      action_label="More",
      action_message="tab-discover",
      target_tab="discover",
    ),
    home_pulse_row(
      id="refresh",
      title=if refresh_count > 0 {
        "Some updates need refresh"
      } else {
        "Town is ready"
      },
      summary=if refresh_count > 0 {
        "Needs refresh before the town can show the latest changes."
      } else {
        "Latest map, messages, and inventory are ready."
      },
      status=if refresh_count > 0 { "stale" } else { "stable" },
      action_label=if refresh_count > 0 { "Try again" } else { "Open" },
      action_message=if refresh_count > 0 { "tab-realm" } else { "tab-realm" },
      target_tab="realm",
    ),
  ]
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

///|
fn home_changed_places_count(activity : Array[MiniTownActivityItem]) -> Int {
  let ids : Array[String] = []
  for item in activity {
    if !home_contains_id(ids, item.building_id) {
      ids.push(item.building_id)
      if ids.length() == 3 {
        return 3
      }
    }
  }
  ids.length()
}

///|
fn home_contains_id(ids : Array[String], id : String) -> Bool {
  for item in ids {
    if item == id {
      return true
    }
  }
  false
}

///|
fn home_activity_summary(activity : Array[MiniTownActivityItem]) -> String {
  if activity.length() > 0 {
    activity[0].title
  } else {
    "Open Realm to see what changed around the map."
  }
}

///|
fn home_attention_summary(
  reviews : Array[MiniTownReviewItem],
  unread : Array[MiniTownNotification],
) -> String {
  if reviews.length() > 0 {
    reviews[0].title
  } else if unread.length() > 0 {
    unread[0].title
  } else {
    "No agent handoff is waiting right now."
  }
}

///|
fn home_refresh_count(projection : MiniTownProjection) -> Int {
  let mut count = 0
  for item in projection.backend_cache_states {
    if item.state.has_prefix("stale") || item.state == "failed" {
      count += 1
    }
  }
  count
}

///|
