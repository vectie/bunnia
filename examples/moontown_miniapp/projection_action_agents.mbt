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

///|
fn agent_name(projection : MiniTownProjection, agent_id : String) -> String {
  for agent in projection.agents {
    if agent.id == agent_id {
      return agent.name
    }
  }
  agent_id
}

///|
pub fn acknowledge_tool_result(
  projection : MiniTownProjection,
  tool_result_id : String,
) -> MiniTownProjection {
  let mut building_id = projection.selected_building_id
  let mut title = tool_result_id
  for item in projection.tool_results {
    if item.id == tool_result_id {
      building_id = item.building_id
      title = item.title
    }
  }
  {
    ..projection,
    tool_results: update_tool_result_status(
      projection.tool_results,
      tool_result_id,
      @bunnia.run_done(),
    ),
    audit_events: projection.audit_events +
    [
      mini_town_audit_event(
        id="audit-tool-ack-\{tool_result_id}",
        kind="tool-result-ack",
        title="\{title} acknowledged",
        summary="Tool result was reviewed and cleared from the pending agent queue.",
        actor_id=projection.active_user_id,
        target_ref="tool-result:\{tool_result_id}",
        building_id~,
        status="done",
        visibility=selected_tool_result_visibility(projection, building_id),
        timestamp="local-dev",
      ),
    ],
  }
}

///|
fn update_tool_result_status(
  items : Array[MiniTownToolResult],
  tool_result_id : String,
  status : @bunnia.RunStatus,
) -> Array[MiniTownToolResult] {
  let output : Array[MiniTownToolResult] = []
  for item in items {
    if item.id == tool_result_id {
      output.push({ ..item, status, })
    } else {
      output.push(item)
    }
  }
  output
}

///|
fn selected_tool_result_visibility(
  projection : MiniTownProjection,
  building_id : String,
) -> String {
  for building in projection.buildings {
    if building.id == building_id {
      return building.visibility
    }
  }
  "private_draft"
}

///|
