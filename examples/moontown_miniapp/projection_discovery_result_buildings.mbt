///|
pub fn search_results(
  projection : MiniTownProjection,
) -> Array[MiniTownBuilding] {
  let visible = visible_buildings(projection)
  let output : Array[MiniTownBuilding] = []
  for building in visible {
    if building.visibility == "published" &&
      mini_town_search_match(projection.search_query, building) {
      output.push(building)
    }
  }
  output
}

///|
fn mini_town_search_match(query : String, building : MiniTownBuilding) -> Bool {
  if query == "" {
    true
  } else if building.title.contains(query) || building.summary.contains(query) {
    true
  } else {
    building.tags.contains(query)
  }
}
