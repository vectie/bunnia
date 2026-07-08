///|
pub struct MiniTownPlacement {
  id : String
  building_id : String
  owner_id : String
  layer : String
  x : Int
  y : Int
  status : String
  source : String
} derive(Debug, Eq)

///|
pub fn mini_town_placement(
  id~ : String,
  building_id~ : String,
  owner_id~ : String,
  layer~ : String,
  x~ : Int,
  y~ : Int,
  status~ : String,
  source~ : String,
) -> MiniTownPlacement {
  { id, building_id, owner_id, layer, x, y, status, source }
}

///|
pub fn visible_placements(
  projection : MiniTownProjection,
) -> Array[MiniTownPlacement] {
  let output : Array[MiniTownPlacement] = []
  for placement in projection.placements {
    if mini_town_placement_visible_for(projection, placement) {
      output.push(placement)
    }
  }
  output
}

///|
pub fn placed_buildings(
  projection : MiniTownProjection,
) -> Array[MiniTownBuilding] {
  let output : Array[MiniTownBuilding] = []
  for placement in visible_placements(projection) {
    for building in projection.buildings {
      if building.id == placement.building_id &&
        !mini_town_building_seen(output, building.id) {
        output.push(building)
      }
    }
  }
  output
}

///|
pub fn placement_for_building(
  projection : MiniTownProjection,
  building_id : String,
) -> MiniTownPlacement? {
  for placement in visible_placements(projection) {
    if placement.building_id == building_id {
      return Some(placement)
    }
  }
  None
}

///|
fn mini_town_placement_visible_for(
  projection : MiniTownProjection,
  placement : MiniTownPlacement,
) -> Bool {
  placement.owner_id == projection.active_user_id ||
  placement.owner_id == projection.organization_id ||
  placement.layer == "town_public"
}

///|
fn mini_town_building_seen(
  buildings : Array[MiniTownBuilding],
  building_id : String,
) -> Bool {
  for building in buildings {
    if building.id == building_id {
      return true
    }
  }
  false
}
