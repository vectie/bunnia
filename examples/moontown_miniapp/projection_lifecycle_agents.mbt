///|
pub fn selected_agent(projection : MiniTownProjection) -> MiniTownAgent {
  let selected = selected_building(projection)
  for agent in projection.agents {
    if agent.building_id == selected.id {
      return agent
    }
  }
  projection.agents[0]
}
