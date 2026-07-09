///|
pub fn selected_building(projection : MiniTownProjection) -> MiniTownBuilding {
  for building in projection.buildings {
    if building.id == projection.selected_building_id {
      return building
    }
  }
  projection.buildings[0]
}

///|
pub fn selected_building_book(projection : MiniTownProjection) -> MiniTownBook {
  let selected = selected_building(projection)
  for book in visible_books(projection) {
    if book.building_id == selected.id {
      return book
    }
  }
  projection.books[0]
}

///|
pub fn selected_building_runs(
  projection : MiniTownProjection,
) -> Array[MiniTownRun] {
  let selected = selected_building(projection)
  let output : Array[MiniTownRun] = []
  for run in visible_runs(projection) {
    if run.building_id == selected.id {
      output.push(run)
    }
  }
  output
}

///|
pub fn selected_building_agents(
  projection : MiniTownProjection,
) -> Array[MiniTownAgent] {
  let selected = selected_building(projection)
  let output : Array[MiniTownAgent] = []
  for agent in projection.agents {
    if agent.building_id == selected.id {
      output.push(agent)
    }
  }
  output
}

///|
pub fn selected_building_messages(
  projection : MiniTownProjection,
) -> Array[MiniTownMessage] {
  let selected = selected_building(projection)
  let thread_id = "thread-\{selected.id}"
  let output : Array[MiniTownMessage] = []
  for message in visible_messages(projection) {
    if message.thread_id == thread_id {
      output.push(message)
    }
  }
  output
}
