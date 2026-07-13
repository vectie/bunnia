///|
fn district_entry(district : MiniTownDistrict) -> @bunnia.Node {
  @bunnia.keyed(
    "district-\{district.id}",
    @bunnia.node(
      kind="view",
      attrs=district_entry_attrs(district),
      events=[@bunnia.event("tap", district_action_message(district))],
      children=[
        @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
          @bunnia.text(district.title),
        ]),
        @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
          @bunnia.text(district_meta_text(district)),
        ]),
        district_action_row(district),
      ],
    ),
  )
}

///|
fn district_entry_attrs(district : MiniTownDistrict) -> Array[@bunnia.Attr] {
  [
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
  ]
}

///|
fn district_meta_text(district : MiniTownDistrict) -> String {
  "\{district.stat_value} \{district.stat_label} - \{district_cta_label(district)}"
}

///|
fn district_action_row(district : MiniTownDistrict) -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-district-actions")], [
    @bunnia.node(
      kind="button",
      attrs=[
        @bunnia.data("district-id", district.id),
        @bunnia.data("target-tab", district_target_tab(district)),
        town_route_attr(district_target_tab(district)),
      ],
      events=[@bunnia.tap(district_action_message(district))],
      children=[@bunnia.text(district_cta_label(district))],
    ),
  ])
}
