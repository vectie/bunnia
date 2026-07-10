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
