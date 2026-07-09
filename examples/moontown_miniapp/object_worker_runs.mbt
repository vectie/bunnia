///|
fn latest_agent_run(
  projection : MiniTownProjection,
  agent : MiniTownAgent,
) -> MiniTownRun {
  for run in selected_building_runs(projection) {
    if run.agent_id == agent.id {
      return run
    }
  }
  selected_building_latest_run(projection)
}
