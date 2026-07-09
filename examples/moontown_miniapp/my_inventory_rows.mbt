///|
fn ownership_stat_value(
  stats : Array[MiniTownOwnershipStat],
  id : String,
) -> Int {
  for stat in stats {
    if stat.id == id {
      return stat.value
    }
  }
  0
}

///|
fn ownership_filter_chip(
  filter : MiniTownOwnershipFilter,
  active_filter_id : String,
) -> @bunnia.Node {
  @bunnia.keyed(
    "ownership-filter-\{filter.id}",
    @bunnia.node(
      kind="view",
      attrs=[
        @bunnia.class_name(
          if filter.id == active_filter_id {
            "moontown-ownership-filter active"
          } else {
            "moontown-ownership-filter"
          },
        ),
        @bunnia.data("ownership-filter-id", filter.id),
      ],
      events=[@bunnia.event("tap", "ownership-filter-\{filter.id}")],
      children=[@bunnia.text(filter.label)],
    ),
  )
}

///|
fn ownership_stat_entry(stat : MiniTownOwnershipStat) -> @bunnia.Node {
  @bunnia.keyed(
    "ownership-stat-\{stat.id}",
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("moontown-owned-entry"),
        @bunnia.data("ownership-stat", stat.id),
      ],
      [
        @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
          @bunnia.text(stat.label),
        ]),
        @bunnia.text(stat.value.to_string()),
      ],
    ),
  )
}

///|
fn ownership_item_entry(item : MiniTownOwnershipItem) -> @bunnia.Node {
  @bunnia.keyed(
    "owned-\{item.id}",
    @bunnia.node(
      kind="view",
      attrs=[
        @bunnia.class_name("moontown-owned-entry"),
        @bunnia.data("ownership-kind", item.kind),
        @bunnia.data(
          "ownership-destination",
          town_tab_label(ownership_item_target_tab(item)),
        ),
      ],
      events=[@bunnia.event("tap", item.action_message)],
      children=[
        @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
          @bunnia.text(item.title),
        ]),
        @bunnia.text(item.summary),
        @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
          @bunnia.text(
            "\{town_kind_label(item.kind)} - \{town_visibility_label(item.visibility)} - \{item.action_label} in \{town_tab_label(ownership_item_target_tab(item))}",
          ),
        ]),
        ownership_item_place_button(item),
      ],
    ),
  )
}

///|
fn ownership_item_place_button(item : MiniTownOwnershipItem) -> @bunnia.Node {
  let building_id = ownership_item_building_id(item)
  if high_leverage_place_route(building_id) {
    open_place_button(building_id)
  } else {
    @bunnia.view([])
  }
}

///|
fn ownership_item_building_id(item : MiniTownOwnershipItem) -> String {
  if item.target_ref.has_prefix("building:") {
    item.target_ref.sub(start=9, end=item.target_ref.length()).to_owned()
  } else if item.action_message.has_prefix("select-") {
    item.action_message
    .sub(start=7, end=item.action_message.length())
    .to_owned()
  } else {
    ""
  }
}

///|
fn ownership_item_target_tab(item : MiniTownOwnershipItem) -> String {
  if item.action_message.has_prefix("tab-") {
    item.action_message
    .sub(start=4, end=item.action_message.length())
    .to_owned()
  } else if item.action_message.has_prefix("select-") {
    "realm"
  } else if item.action_message.contains("building") ||
    item.action_message.contains("publish") ||
    item.action_message.contains("archive") ||
    item.action_message.contains("restore") {
    "my"
  } else {
    "my"
  }
}
