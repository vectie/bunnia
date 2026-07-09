///|
fn home_district_gates_panel(projection : MiniTownProjection) -> @bunnia.Node {
  let presence = community_presence(projection)
  @bunnia.view_with_attrs([@bunnia.class_name("mt-panel")], [
    @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-title")], [
      @bunnia.text("District Gates"),
    ]),
    @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-note")], [
      @bunnia.text(
        "Market, messages, events, guides, and trust work open from this town board.",
      ),
    ]),
    @bunnia.windowed_list(
      projection.districts,
      total_count=projection.districts.length(),
      render=district_entry,
    ),
    @bunnia.view_with_attrs([@bunnia.class_name("moontown-presence-row")], [
      @bunnia.windowed_list(
        presence,
        total_count=presence.length(),
        render=presence_chip,
      ),
    ]),
    @bunnia.view_with_attrs(
      [@bunnia.class_name("moontown-community-actions")],
      [
        @bunnia.button("Search Town", "tab-discover"),
        @bunnia.button("Publish Draft", "publish-private-building"),
      ],
    ),
  ])
}

///|
fn district_panel(projection : MiniTownProjection) -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("mt-panel")], [
    @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-title")], [
      @bunnia.text("Map Districts"),
    ]),
    @bunnia.windowed_list(
      projection.districts,
      total_count=projection.districts.length(),
      render=district_entry,
    ),
  ])
}

///|
fn district_entry(district : MiniTownDistrict) -> @bunnia.Node {
  @bunnia.keyed(
    "district-\{district.id}",
    @bunnia.node(
      kind="view",
      attrs=[
        @bunnia.class_name(
          "moontown-district-entry feature-\{district.feature_kind} tone-\{district.accent} bunnia-status-\{district.status}",
        ),
        @bunnia.data("district-id", district.id),
        @bunnia.data("feature-kind", district.feature_kind),
        @bunnia.data("building-id", district.building_id),
        @bunnia.data("district-filter", district.discovery_filter_id),
        @bunnia.data("district-query", district.search_query),
        @bunnia.data("district-accent", district.accent),
        @bunnia.data("action-message", district_action_message(district)),
        @bunnia.data("target-tab", district_target_tab(district)),
      ],
      events=[@bunnia.event("tap", district_action_message(district))],
      children=[
        @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
          @bunnia.text(district.title),
        ]),
        @bunnia.text(district.summary),
        @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
          @bunnia.text(
            "\{district.stat_value} \{district.stat_label} - \{district.action_label} \{town_tab_label(district_target_tab(district))}",
          ),
        ]),
        @bunnia.view_with_attrs(
          [@bunnia.class_name("moontown-district-actions")],
          [
            @bunnia.node(
              kind="button",
              attrs=[
                @bunnia.data("district-id", district.id),
                @bunnia.data("target-tab", district_target_tab(district)),
              ],
              events=[@bunnia.tap(district_action_message(district))],
              children=[@bunnia.text(district_cta_label(district))],
            ),
          ],
        ),
      ],
    ),
  )
}

///|
fn district_cta_label(district : MiniTownDistrict) -> String {
  "\{district.action_label} \{town_tab_label(district_target_tab(district))}"
}

///|
fn district_action_message(district : MiniTownDistrict) -> String {
  if district.action_message == "" {
    "select-\{district.building_id}"
  } else {
    district.action_message
  }
}

///|
fn district_target_tab(district : MiniTownDistrict) -> String {
  if district.action_message.has_prefix("tab-") {
    district.action_message
    .sub(start=4, end=district.action_message.length())
    .to_owned()
  } else {
    "realm"
  }
}

///|
fn presence_chip(item : MiniTownPresence) -> @bunnia.Node {
  @bunnia.keyed(
    "presence-\{item.id}",
    @bunnia.node(
      kind="view",
      attrs=[
        @bunnia.class_name(
          "moontown-presence-chip bunnia-status-\{item.status}",
        ),
        @bunnia.data("presence-id", item.id),
        @bunnia.data("actor-kind", item.actor_kind),
        @bunnia.data("building-id", item.building_id),
      ],
      events=[@bunnia.event("tap", "select-\{item.building_id}")],
      children=[
        @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
          @bunnia.text(item.title),
        ]),
        @bunnia.text(item.subtitle),
      ],
    ),
  )
}

///|
