///|
pub fn home_town_stats(
  projection : MiniTownProjection,
) -> Array[MiniTownOwnershipStat] {
  [
    mini_town_ownership_stat(
      id="visible-buildings",
      label="visible buildings",
      value=visible_buildings(projection).length(),
    ),
    mini_town_ownership_stat(
      id="agents",
      label="active agents",
      value=projection.agents.length(),
    ),
    mini_town_ownership_stat(
      id="unread",
      label="unread events",
      value=unread_notifications(projection).length(),
    ),
    mini_town_ownership_stat(
      id="pulse",
      label="town pulse",
      value=town_activity_items(projection).length(),
    ),
    mini_town_ownership_stat(
      id="placements",
      label="placed",
      value=visible_placements(projection).length(),
    ),
  ]
}

///|
pub fn community_presence(
  projection : MiniTownProjection,
) -> Array[MiniTownPresence] {
  let output : Array[MiniTownPresence] = []
  for item in projection.presence {
    if mini_town_presence_visible_for(projection, item) {
      output.push(item)
    }
  }
  output
}

///|
fn mini_town_presence_visible_for(
  projection : MiniTownProjection,
  item : MiniTownPresence,
) -> Bool {
  for building in visible_buildings(projection) {
    if building.id == item.building_id {
      return true
    }
  }
  false
}
