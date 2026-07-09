///|
pub fn filtered_discovery_results(
  projection : MiniTownProjection,
) -> Array[MiniTownDiscoveryItem] {
  let output : Array[MiniTownDiscoveryItem] = []
  let filter = selected_discovery_filter(projection)
  for item in unified_discovery_results(projection) {
    if mini_town_discovery_filter_match(projection, filter, item) {
      output.push(item)
    }
  }
  output
}

///|
pub fn selected_discovery_filter(
  projection : MiniTownProjection,
) -> MiniTownDiscoveryFilter {
  for item in projection.discovery_filters {
    if item.id == projection.active_discovery_filter_id {
      return item
    }
  }
  mini_town_discovery_filter(id="all", label="All", kind="all")
}

///|
fn mini_town_discovery_filter_match(
  projection : MiniTownProjection,
  filter : MiniTownDiscoveryFilter,
  item : MiniTownDiscoveryItem,
) -> Bool {
  let kind_match = filter.kind == "all" || filter.kind == item.kind
  let placeable_match = !filter.placeable_only ||
    (
      item.kind == "building" &&
      item.visibility == "published" &&
      placement_for_building(
        projection,
        mini_town_discovery_item_building_id(item),
      )
      is None
    )
  kind_match && placeable_match
}

///|
fn mini_town_discovery_item_building_id(item : MiniTownDiscoveryItem) -> String {
  if item.target_ref.has_prefix("building:") {
    item.target_ref.sub(start=9, end=item.target_ref.length()).to_owned()
  } else {
    item.id
  }
}
