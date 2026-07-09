///|
pub fn owned_buildings(
  projection : MiniTownProjection,
) -> Array[MiniTownBuilding] {
  let output : Array[MiniTownBuilding] = []
  for building in projection.buildings {
    if building.owner_id == projection.active_user_id {
      output.push(building)
    }
  }
  output
}

///|
pub fn owned_books(projection : MiniTownProjection) -> Array[MiniTownBook] {
  let output : Array[MiniTownBook] = []
  for book in projection.books {
    if book.owner_id == projection.active_user_id {
      output.push(book)
    }
  }
  output
}

///|
pub fn visible_watches(projection : MiniTownProjection) -> Array[MiniTownWatch] {
  let output : Array[MiniTownWatch] = []
  for item in projection.watches {
    if item.user_id == projection.active_user_id {
      output.push(item)
    }
  }
  output
}

///|
fn owned_agents(projection : MiniTownProjection) -> Array[MiniTownAgent] {
  let output : Array[MiniTownAgent] = []
  for agent in projection.agents {
    if agent_attached_to_owned_building(projection, agent) {
      output.push(agent)
    }
  }
  output
}

///|
fn agent_attached_to_owned_building(
  projection : MiniTownProjection,
  agent : MiniTownAgent,
) -> Bool {
  for building in owned_buildings(projection) {
    if building.id == agent.building_id {
      return true
    }
  }
  false
}
