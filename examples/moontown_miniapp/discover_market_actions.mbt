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
