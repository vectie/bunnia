///|
pub fn demo_agent_delta_plan() -> @bunnia.AgentDeltaPlan {
  @bunnia.plan_agent_deltas([
    @bunnia.append_message_delta(
      "chat.messages",
      @bunnia.message(
        id="msg-mock-answer",
        actor_id="agent-policy-guide",
        thread_id="thread-policy-hall",
        text="Mock answer recorded as a run waiting for review.",
        status=@bunnia.run_waiting_review(),
      ),
    ),
    @bunnia.set_run_status_delta(
      "runs.activeRunStatus",
      @bunnia.run_waiting_review(),
    ),
  ])
}

///|
pub fn demo_communication_plan() -> @bunnia.CommunicationPlan {
  @bunnia.plan_communications_with_budget(
    demo_communications(demo_projection()),
    @bunnia.communication_budget(max_visible_count=8),
  )
}

///|
pub fn demo_tool_result_plan() -> @bunnia.ToolResultPlan {
  @bunnia.plan_tool_result_cards_with_budget(
    tool_result_cards(demo_projection()),
    @bunnia.tool_result_budget(max_visible_count=8),
  )
}
