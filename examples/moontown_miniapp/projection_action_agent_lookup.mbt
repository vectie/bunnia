///|
fn agent_name(projection : MiniTownProjection, agent_id : String) -> String {
  for agent in projection.agents {
    if agent.id == agent_id {
      return agent.name
    }
  }
  agent_id
}
