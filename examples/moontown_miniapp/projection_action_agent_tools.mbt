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
