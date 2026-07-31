///|
fn discover_entry_action(
  _projection : MiniTownProjection,
  item : MiniTownDiscoveryItem,
) -> @bunnia.Node {
  if item.kind == "building" && item.visibility == "published" {
    @bunnia.view_with_attrs([@bunnia.class_name("moontown-discovery-action")], [
      open_place_button(discovery_item_building_id(item)),
    ])
  } else {
    @bunnia.view([])
  }
}
