///|
pub fn handoff_selected_building_agent(
  projection : MiniTownProjection,
  from_agent_id : String,
  to_agent_id : String,
  summary : String,
) -> MiniTownProjection {
  let building = selected_building(projection)
  let book = selected_building_book(projection)
  let from_agent_name = agent_name(projection, from_agent_id)
  let to_agent_name = agent_name(projection, to_agent_id)
  let run_id = "run-handoff-\{from_agent_id}-\{to_agent_id}"
  let message = mini_town_message(
    id="msg-handoff-\{from_agent_id}-\{to_agent_id}",
    actor_id=from_agent_id,
    thread_id="thread-\{building.id}",
    text="\{from_agent_name} handed work to \{to_agent_name}: \{summary}",
    status=@bunnia.run_running(),
  )
  let run = mini_town_run(
    id=run_id,
    agent_id=to_agent_id,
    building_id=building.id,
    book_id=book.id,
    thread_id="thread-\{building.id}",
    title="\{to_agent_name} handoff",
    summary~,
    status="running",
    artifact_ref="handoff://\{from_agent_id}/\{to_agent_id}/\{building.id}",
  )
  let notice = mini_town_notification(
    id="notice-handoff-\{from_agent_id}-\{to_agent_id}",
    kind="handoff",
    title="Agent handoff started",
    body="\{from_agent_name} moved work to \{to_agent_name} inside \{building.title}.",
    target_ref="run:\{run_id}",
    building_id=building.id,
    action_label="Open Handoff",
    action_message="open-notice-handoff",
  )
  {
    ..projection,
    messages: projection.messages + [message],
    runs: projection.runs + [run],
    notifications: projection.notifications + [notice],
    audit_events: projection.audit_events +
    [
      mini_town_audit_event(
        id="audit-handoff-\{from_agent_id}-\{to_agent_id}",
        kind="handoff",
        title="\{from_agent_name} handed off work",
        summary="\{to_agent_name} received work in \{building.title}.",
        actor_id=from_agent_id,
        target_ref="run:\{run_id}",
        building_id=building.id,
        status="running",
        visibility=building.visibility,
        timestamp="local-dev",
      ),
    ],
  }
}
