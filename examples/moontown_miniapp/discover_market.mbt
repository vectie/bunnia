///|
fn discover_panel(projection : MiniTownProjection) -> @bunnia.Node {
  let results = filtered_discovery_results(projection)
  let people = discovery_results_by_kind(projection, "user")
  let circles = discovery_results_by_kind(projection, "circle")
  let market = market_discovery_results(projection)
  @bunnia.view_with_attrs([@bunnia.class_name("mt-panel")], [
    @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-title")], [
      @bunnia.text("Market Board"),
    ]),
    @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-note")], [
      @bunnia.text(
        "Find public places, people, books, agents, demands, and events.",
      ),
    ]),
    @bunnia.input(
      name="discoverSearch",
      value=projection.search_query,
      input_message="discover-search",
    ),
    @bunnia.view_with_attrs(
      [@bunnia.class_name("moontown-community-actions")],
      [@bunnia.button("More", "discover-search")],
    ),
    discover_spotlight_section("Town People", people),
    discover_spotlight_section("Town Circles", circles),
    discover_spotlight_section("Town Market", market),
    @bunnia.view_with_attrs(
      [@bunnia.class_name("moontown-discovery-filters")],
      [
        @bunnia.windowed_list(
          projection.discovery_filters,
          total_count=projection.discovery_filters.length(),
          render=filter => {
            discovery_filter_chip(filter, projection.active_discovery_filter_id)
          },
        ),
      ],
    ),
    discover_results_list(projection, results),
  ])
}

///|
fn discover_results_list(
  projection : MiniTownProjection,
  results : Array[MiniTownDiscoveryItem],
) -> @bunnia.Node {
  if results.length() == 0 {
    discover_empty_state()
  } else {
    @bunnia.windowed_list(results, total_count=results.length(), render=item => {
      discover_entry(projection, item)
    })
  }
}

///|
fn discover_empty_state() -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-discover-empty")], [
    @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
      @bunnia.text("No public match"),
    ]),
    @bunnia.text("Try another search or choose a different market filter."),
  ])
}

///|
fn discover_spotlight_section(
  title : String,
  items : Array[MiniTownDiscoveryItem],
) -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-discovery-strip")], [
    @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
      @bunnia.text(title),
    ]),
    @bunnia.windowed_list(
      items,
      total_count=items.length(),
      render=discover_spotlight_chip,
    ),
  ])
}

///|
fn discover_spotlight_chip(item : MiniTownDiscoveryItem) -> @bunnia.Node {
  @bunnia.keyed(
    "discover-chip-\{item.id}",
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("moontown-discovery-chip"),
        @bunnia.data("discovery-kind", item.kind),
        @bunnia.data("target-ref", item.target_ref),
      ],
      [
        @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
          @bunnia.text(item.title),
        ]),
        @bunnia.text(town_status_label(item.status)),
      ],
    ),
  )
}

///|
fn discovery_filter_chip(
  filter : MiniTownDiscoveryFilter,
  active_filter_id : String,
) -> @bunnia.Node {
  @bunnia.keyed(
    "discover-filter-\{filter.id}",
    @bunnia.node(
      kind="view",
      attrs=[
        @bunnia.class_name(
          if filter.id == active_filter_id {
            "moontown-discovery-filter active"
          } else {
            "moontown-discovery-filter"
          },
        ),
        @bunnia.data("filter-id", filter.id),
      ],
      events=[@bunnia.event("tap", "discover-filter-\{filter.id}")],
      children=[@bunnia.text(filter.label)],
    ),
  )
}

///|
fn discover_entry(
  projection : MiniTownProjection,
  item : MiniTownDiscoveryItem,
) -> @bunnia.Node {
  @bunnia.keyed(
    "discover-\{item.id}",
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name(
          "moontown-discover-entry bunnia-status-\{item.status}",
        ),
        @bunnia.data("discovery-id", item.id),
        @bunnia.data("discovery-kind", item.kind),
      ],
      [
        @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
          @bunnia.text(item.title),
        ]),
        @bunnia.text(item.summary),
        @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
          @bunnia.text(
            "\{town_kind_label(item.kind)} - \{discover_eligibility_label(projection, item)}",
          ),
        ]),
        discover_eligibility_row(projection, item),
        discover_entry_action(projection, item),
      ],
    ),
  )
}

///|
fn discover_eligibility_row(
  projection : MiniTownProjection,
  item : MiniTownDiscoveryItem,
) -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-discovery-badges")], [
    discover_badge("kind", town_kind_label(item.kind)),
    discover_badge("access", discover_access_label(item)),
    discover_badge("eligibility", discover_eligibility_label(projection, item)),
  ])
}

///|
fn discover_badge(kind : String, label : String) -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [@bunnia.class_name("moontown-discovery-badge kind-\{kind}")],
    [@bunnia.text(label)],
  )
}

///|
fn discover_access_label(item : MiniTownDiscoveryItem) -> String {
  if item.visibility == "published" || item.visibility == "public" {
    "Public"
  } else if item.visibility == "personal" {
    "Owner only"
  } else if item.visibility == "shared_private" {
    "Shared"
  } else if item.visibility == "private_draft" {
    "Needs setup"
  } else {
    town_visibility_label(item.visibility)
  }
}

///|
fn discover_eligibility_label(
  projection : MiniTownProjection,
  item : MiniTownDiscoveryItem,
) -> String {
  if item.kind == "building" && item.visibility == "published" {
    if discovery_item_placement_state(projection, item) == "pinned" {
      "Already placed"
    } else {
      "Can place"
    }
  } else if item.visibility == "published" || item.visibility == "public" {
    "Can open"
  } else if item.visibility == "personal" {
    "Owner only"
  } else {
    "Needs setup"
  }
}

///|
fn discover_entry_action(
  projection : MiniTownProjection,
  item : MiniTownDiscoveryItem,
) -> @bunnia.Node {
  if item.kind == "building" && item.visibility == "published" {
    let placement_state = discovery_item_placement_state(projection, item)
    let building_id = discovery_item_building_id(item)
    let place_events = if placement_state == "pinned" {
      []
    } else {
      [@bunnia.tap("place-published-building")]
    }
    @bunnia.view_with_attrs([@bunnia.class_name("moontown-discovery-action")], [
      open_place_button(building_id),
      @bunnia.node(
        kind="button",
        attrs=[
          @bunnia.data("discovery-id", item.id),
          @bunnia.data("building-id", building_id),
        ],
        events=place_events,
        children=[
          @bunnia.text(
            if placement_state == "pinned" {
              "Pinned On Map"
            } else {
              "Place On Map"
            },
          ),
        ],
      ),
      discover_watch_button(item),
    ])
  } else if item.visibility == "published" {
    @bunnia.view_with_attrs([@bunnia.class_name("moontown-discovery-action")], [
      discover_primary_action_button(item),
      discover_watch_button(item),
    ])
  } else {
    @bunnia.view([])
  }
}

///|
fn discover_primary_action_button(item : MiniTownDiscoveryItem) -> @bunnia.Node {
  @bunnia.node(
    kind="button",
    attrs=[
      @bunnia.data("discovery-action", discover_primary_action_kind(item)),
      @bunnia.data("discovery-id", item.id),
      @bunnia.data("discovery-kind", item.kind),
      @bunnia.data("target-ref", item.target_ref),
    ],
    events=[@bunnia.tap("discover-action")],
    children=[@bunnia.text(discover_primary_action_label(item))],
  )
}

///|
fn discover_primary_action_kind(item : MiniTownDiscoveryItem) -> String {
  if item.kind == "demand" {
    "request"
  } else if item.kind == "event" || item.kind == "circle" {
    "join"
  } else if item.kind == "post" || item.kind == "book" {
    "read"
  } else {
    "open"
  }
}

///|
fn discover_primary_action_label(item : MiniTownDiscoveryItem) -> String {
  if item.kind == "product" {
    "Open Product"
  } else if item.kind == "demand" {
    "Answer Demand"
  } else if item.kind == "event" {
    "Join Event"
  } else if item.kind == "circle" {
    "Enter Circle"
  } else if item.kind == "post" {
    "Read Note"
  } else if item.kind == "book" {
    "Read Book"
  } else if item.kind == "agent" {
    "Open Agent"
  } else if item.kind == "user" {
    "View Profile"
  } else {
    "Open"
  }
}

///|
fn discover_watch_button(item : MiniTownDiscoveryItem) -> @bunnia.Node {
  @bunnia.node(
    kind="button",
    attrs=[
      @bunnia.data("discovery-id", item.id),
      @bunnia.data("notice-id", "notice-subscribe"),
      @bunnia.data("notice-kind", "subscription"),
      @bunnia.data("target-ref", item.target_ref),
    ],
    events=[@bunnia.tap("request-subscription")],
    children=[@bunnia.text("Watch")],
  )
}

///|
fn discovery_item_placement_state(
  projection : MiniTownProjection,
  item : MiniTownDiscoveryItem,
) -> String {
  match placement_for_building(projection, discovery_item_building_id(item)) {
    Some(placement) => placement.status
    None => "not-placed"
  }
}

///|
fn discovery_item_building_id(item : MiniTownDiscoveryItem) -> String {
  if item.target_ref.has_prefix("building:") {
    item.target_ref.sub(start=9, end=item.target_ref.length()).to_owned()
  } else {
    item.id
  }
}
