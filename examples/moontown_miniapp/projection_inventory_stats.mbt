///|
pub fn ownership_stats(
  projection : MiniTownProjection,
) -> Array[MiniTownOwnershipStat] {
  [
    mini_town_ownership_stat(
      id="placements",
      label="Placed",
      value=visible_placements(projection).length(),
    ),
    mini_town_ownership_stat(
      id="drafts",
      label="Drafts",
      value=count_owned_buildings_by_visibility(projection, "private_draft"),
    ),
    mini_town_ownership_stat(
      id="shared",
      label="Shared",
      value=count_shared_buildings(projection),
    ),
    mini_town_ownership_stat(
      id="published",
      label="Published",
      value=count_owned_buildings_by_visibility(projection, "published"),
    ),
    mini_town_ownership_stat(
      id="agents",
      label="Agents",
      value=owned_agents(projection).length(),
    ),
    mini_town_ownership_stat(
      id="books",
      label="Books",
      value=owned_books(projection).length(),
    ),
    mini_town_ownership_stat(
      id="watches",
      label="Watches",
      value=visible_watches(projection).length(),
    ),
  ]
}

///|
fn count_owned_buildings_by_visibility(
  projection : MiniTownProjection,
  visibility : String,
) -> Int {
  let mut count = 0
  for building in owned_buildings(projection) {
    if building.visibility == visibility {
      count += 1
    }
  }
  count
}

///|
fn count_shared_buildings(projection : MiniTownProjection) -> Int {
  let mut count = 0
  for building in projection.buildings {
    if building.owner_id == projection.organization_id {
      count += 1
    }
  }
  count
}
