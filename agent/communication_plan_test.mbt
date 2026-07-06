///|
fn fixture_communications() -> Array[Communication] {
  [
    message_event(
      id="comm-open",
      thread_id="thread-a",
      from_actor_id="agent-a",
      text="Opened thread.",
    ),
    handoff(
      id="comm-handoff",
      thread_id="thread-a",
      from_actor_id="agent-a",
      to_actor_id="operator",
      text="Please take over.",
    ),
    review_request(
      id="comm-review",
      thread_id="thread-a",
      from_actor_id="agent-a",
      to_actor_id="operator",
      text="Approve route?",
      artifact_ref="artifact://route",
    ),
    tool_result(
      id="comm-tool",
      thread_id="thread-a",
      from_actor_id="agent-a",
      text="Tool result ready.",
      artifact_ref="artifact://route",
    ),
    recovery_notice(
      id="comm-recovery",
      thread_id="thread-b",
      from_actor_id="system",
      text="Retry after stale data.",
    ),
  ]
}

///|
test "communication plans summarize visible agent interactions" {
  let plan = plan_communications(fixture_communications())
  assert_eq(plan.total_count, 5)
  assert_eq(plan.filtered_count, 5)
  assert_eq(plan.visible_count, 5)
  assert_eq(plan.hidden_count, 0)
  assert_eq(plan.review_request_count, 1)
  assert_eq(plan.unresolved_review_count, 1)
  assert_eq(plan.handoff_count, 1)
  assert_eq(plan.broadcast_count, 0)
  assert_eq(plan.tool_result_count, 1)
  assert_eq(plan.recovery_notice_count, 1)
  assert_eq(plan.artifact_ref_count, 2)
  assert_eq(plan.failed_count, 1)
  assert_eq(plan.diagnostics.length(), 0)
  assert_true(plan.summary.contains("visible=5"))
  assert_true(plan.summary.contains("unresolved_reviews=1"))
}

///|
test "communication plans filter by thread actor and kind" {
  let by_thread = filter_communications(
    fixture_communications(),
    communication_filter(thread_id="thread-b"),
  )
  assert_eq(by_thread.length(), 1)
  assert_eq(by_thread[0].id, "comm-recovery")
  let by_actor = plan_filtered_communications(
    fixture_communications(),
    communication_filter(actor_id="operator"),
  )
  assert_eq(by_actor.filtered_count, 2)
  assert_eq(by_actor.handoff_count, 1)
  assert_eq(by_actor.review_request_count, 1)
  let reviews = plan_filtered_communications(
    fixture_communications(),
    communication_filter(kind_id="review-request"),
  )
  assert_eq(reviews.filtered_count, 1)
  assert_eq(reviews.unresolved_review_count, 1)
}

///|
test "communication plans can hide resolved review requests" {
  let items = [
    communication(
      id="comm-review-done",
      thread_id="thread-a",
      kind=ReviewRequest,
      from_actor_id="agent-a",
      to_actor_id="operator",
      text="Already approved.",
      status=Done,
    ),
    review_request(
      id="comm-review-open",
      thread_id="thread-a",
      from_actor_id="agent-a",
      to_actor_id="operator",
      text="Still pending.",
    ),
  ]
  let plan = plan_filtered_communications(
    items,
    communication_filter(include_resolved_reviews=false),
  )
  assert_eq(plan.total_count, 2)
  assert_eq(plan.filtered_count, 1)
  assert_eq(plan.visible_items[0].id, "comm-review-open")
  assert_eq(plan.unresolved_review_count, 1)
}

///|
test "communication plans report budget pressure" {
  let plan = plan_communications_with_budget(
    fixture_communications(),
    communication_budget(
      max_visible_count=2,
      max_review_request_count=0,
      max_unresolved_review_count=0,
      max_artifact_ref_count=1,
    ),
  )
  assert_eq(plan.visible_count, 2)
  assert_eq(plan.hidden_count, 3)
  assert_true(
    plan.diagnostics.contains("communication-visible-over-budget:5/2"),
  )
  assert_true(
    plan.diagnostics.contains("communication-review-requests-over-budget:1/0"),
  )
  assert_true(
    plan.diagnostics.contains(
      "communication-unresolved-reviews-over-budget:1/0",
    ),
  )
  assert_true(
    plan.diagnostics.contains("communication-artifacts-over-budget:2/1"),
  )
}
