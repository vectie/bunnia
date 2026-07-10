///|
fn discover_place_button(
  item : MiniTownDiscoveryItem,
  building_id : String,
  placement_state : String,
) -> @bunnia.Node {
  @bunnia.node(
    kind="button",
    attrs=[
      @bunnia.class_name("moontown-secondary-action"),
      @bunnia.data("discovery-id", item.id),
      @bunnia.data("building-id", building_id),
    ],
    events=discover_place_events(placement_state),
    children=[@bunnia.text(discover_place_label(placement_state))],
  )
}

///|
fn discover_place_events(
  placement_state : String,
) -> Array[@bunnia.EventBinding] {
  if placement_state == "pinned" {
    []
  } else {
    [@bunnia.tap("place-published-building")]
  }
}

///|
fn discover_place_label(placement_state : String) -> String {
  if placement_state == "pinned" {
    "Pinned On Map"
  } else {
    "Place On Map"
  }
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
