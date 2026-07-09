///|
test "moontown projection handles building messages agents handoff and tool ack" {
  let projection = demo_projection()
  let created = create_private_building(
    projection, "created-agent-lab", "Created Agent Lab",
  )
  let sent_message = send_message_to_selected_building(
    projection, "Can this building publish an agent?",
  )
  assert_eq(selected_building_messages(sent_message).length(), 3)
  assert_eq(
    selected_building_messages(sent_message)[2].text,
    "Can this building publish an agent?",
  )
  assert_eq(selected_building_messages(sent_message)[2].actor_id, "user-a")
  let agent_created = create_agent_for_selected(
    created, "agent-created", "Created Agent",
  )
  assert_eq(agent_created.agents.length(), 4)
  assert_eq(selected_building_messages(agent_created).length(), 1)
  assert_eq(
    selected_building_messages(agent_created)[0].text,
    "Created Agent is ready inside Created Agent Lab.",
  )
  assert_eq(
    selected_building_messages(agent_created)[0].actor_id,
    "agent-created",
  )
  assert_eq(selected_building_audit_events(agent_created).length(), 2)
  let agent_owned = switch_ownership_filter(agent_created, "agents")
  assert_eq(filtered_ownership_items(agent_owned).length(), 2)
  assert_eq(
    filtered_ownership_items(agent_owned)[1].target_ref,
    "agent:agent-created",
  )
  let handed_off = handoff_selected_building_agent(
    projection, "agent-policy-guide", "agent-builder", "Move follow-up planning into the builder queue.",
  )
  assert_eq(selected_building_messages(handed_off).length(), 3)
  assert_eq(
    selected_building_messages(handed_off)[2].text,
    "Policy Guide handed work to Builder: Move follow-up planning into the builder queue.",
  )
  assert_eq(
    selected_building_messages(handed_off)[2].actor_id,
    "agent-policy-guide",
  )
  assert_eq(active_runs(handed_off).length(), 4)
  assert_eq(active_runs(handed_off)[3].agent_id, "agent-builder")
  assert_eq(
    active_runs(handed_off)[3].artifact_ref,
    "handoff://agent-policy-guide/agent-builder/policy-hall",
  )
  assert_eq(visible_notifications(handed_off).length(), 8)
  assert_eq(visible_notifications(handed_off)[7].kind, "handoff")
  assert_eq(selected_building_audit_events(handed_off).length(), 2)
  assert_eq(selected_building_audit_events(handed_off)[1].kind, "handoff")
  let tool_ack = acknowledge_tool_result(projection, "tool-policy-summary")
  assert_true(tool_result_cards(tool_ack)[0].status == @bunnia.run_done())
  assert_eq(selected_building_audit_events(tool_ack).length(), 2)
  assert_eq(selected_building_audit_events(tool_ack)[1].kind, "tool-result-ack")
}
