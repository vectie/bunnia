///|
test "tool result plans summarize visible cards" {
  let plan = plan_tool_result_cards([
    tool_result_card(
      id="tool-a",
      tool_name="search",
      title="Search result",
      summary="Ready.",
      artifact_ref="artifact://search",
      status=WaitingReview,
      acknowledge_message="ack-search",
    ),
    tool_result_card(
      id="tool-b",
      tool_name="route",
      title="Route result",
      summary="Running.",
      status=Running,
      acknowledge_message="ack-route",
    ),
  ])
  assert_eq(plan.total_count, 2)
  assert_eq(plan.visible_count, 2)
  assert_eq(plan.hidden_count, 0)
  assert_eq(plan.artifact_ref_count, 1)
  assert_eq(plan.pending_ack_count, 2)
  assert_eq(plan.missing_ack_count, 0)
  assert_eq(plan.running_count, 1)
  assert_eq(plan.failed_count, 0)
  assert_eq(plan.diagnostics.length(), 0)
  assert_true(plan.summary.contains("pending_acks=2"))
}

///|
test "tool result plans report budget pressure" {
  let plan = plan_tool_result_cards_with_budget(
    [
      tool_result_card(
        id="tool-a",
        tool_name="search",
        title="Search result",
        summary="Ready.",
        artifact_ref="artifact://search",
        status=WaitingReview,
        acknowledge_message="ack-search",
      ),
      tool_result_card(
        id="tool-b",
        tool_name="route",
        title="Route result",
        summary="Needs ack.",
        artifact_ref="artifact://route",
        status=WaitingReview,
      ),
      tool_result_card(
        id="tool-c",
        tool_name="runner",
        title="Runner result",
        summary="Failed.",
        status=Failed,
      ),
    ],
    tool_result_budget(
      max_visible_count=1,
      max_pending_ack_count=0,
      max_missing_ack_count=0,
      max_artifact_ref_count=1,
    ),
  )
  assert_eq(plan.visible_count, 1)
  assert_eq(plan.hidden_count, 2)
  assert_eq(plan.artifact_ref_count, 2)
  assert_eq(plan.pending_ack_count, 1)
  assert_eq(plan.missing_ack_count, 1)
  assert_eq(plan.failed_count, 1)
  assert_true(plan.diagnostics.contains("tool-results-visible-over-budget:3/1"))
  assert_true(
    plan.diagnostics.contains("tool-results-pending-acks-over-budget:1/0"),
  )
  assert_true(plan.diagnostics.contains("tool-results-missing-acks:1/0"))
  assert_true(
    plan.diagnostics.contains("tool-results-artifacts-over-budget:2/1"),
  )
}
