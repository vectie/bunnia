///|
pub fn selected_ownership_filter(
  projection : MiniTownProjection,
) -> MiniTownOwnershipFilter {
  for item in projection.ownership_filters {
    if item.id == projection.active_ownership_filter_id {
      return item
    }
  }
  mini_town_ownership_filter(id="all", label="All")
}

///|
pub fn filtered_ownership_items(
  projection : MiniTownProjection,
) -> Array[MiniTownOwnershipItem] {
  let filter = selected_ownership_filter(projection)
  let output : Array[MiniTownOwnershipItem] = []
  for item in ownership_items(projection) {
    if mini_town_ownership_filter_match(filter, item) {
      output.push(item)
    }
  }
  output
}

///|
fn mini_town_ownership_filter_match(
  filter : MiniTownOwnershipFilter,
  item : MiniTownOwnershipItem,
) -> Bool {
  (filter.kind == "all" || filter.kind == item.kind) &&
  (filter.visibility == "all" || filter.visibility == item.visibility)
}

///|
pub fn switch_ownership_filter(
  projection : MiniTownProjection,
  filter_id : String,
) -> MiniTownProjection {
  { ..projection, active_ownership_filter_id: filter_id }
}
