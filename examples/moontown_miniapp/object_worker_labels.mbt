///|
fn worker_meta_copy(
  projection : MiniTownProjection,
  agent : MiniTownAgent,
  run : MiniTownRun,
) -> String {
  "Role: \{agent_role_label(agent)} - \{town_status_label(agent.status)} - Latest work: \{run.title} - \{book_title_by_id(projection, run.book_id)}"
}

///|
fn agent_role_label(agent : MiniTownAgent) -> String {
  if agent.name.contains("Guide") {
    "place guide"
  } else if agent.name.contains("Builder") {
    "builder"
  } else if agent.name.contains("Moderator") {
    "reviewer"
  } else {
    "town worker"
  }
}
