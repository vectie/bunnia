///|
fn discover_entry_action(
  projection : MiniTownProjection,
  item : MiniTownDiscoveryItem,
) -> @bunnia.Node {
  if item.kind == "building" && item.visibility == "published" {
    let placement_state = discovery_item_placement_state(projection, item)
    let building_id = discovery_item_building_id(item)
    @bunnia.view_with_attrs([@bunnia.class_name("moontown-discovery-action")], [
      open_place_button(building_id),
      discover_place_button(item, building_id, placement_state),
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
