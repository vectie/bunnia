///|
pub fn create_agent_for_selected(
  projection : MiniTownProjection,
  id : String,
  name : String,
) -> MiniTownProjection {
  let building = selected_building(projection)
  let agent = mini_town_agent(
    id~,
    name~,
    building_id=building.id,
    status="idle",
  )
  let message = mini_town_message(
    id="msg-agent-\{id}",
    actor_id=id,
    thread_id="thread-\{building.id}",
    text="\{name} is ready inside \{building.title}.",
  )
  {
    ..projection,
    agents: projection.agents + [agent],
    messages: projection.messages + [message],
    audit_events: projection.audit_events +
    [
      lifecycle_event(
        id="audit-agent-\{id}",
        kind="agent-create",
        title="\{name} created",
        summary="Agent is attached to \{building.title} and can join building threads.",
        actor_id=projection.active_user_id,
        building_id=building.id,
        status="idle",
        visibility=building.visibility,
      ),
    ],
  }
}
