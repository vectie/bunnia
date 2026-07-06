///|
test "agent deltas append messages as bounded patches" {
  let delta = append_message_delta(
    "threads.thread-a.messages",
    message(
      id="msg-1",
      actor_id="agent-a",
      thread_id="thread-a",
      text="hello \"mini\" app",
      artifact_ref="artifact://route",
      status=Running,
    ),
  )
  let plan = plan_agent_deltas([delta])
  assert_true(delta.kind is AppendMessage)
  assert_eq(delta.target_path, "threads.thread-a.messages")
  assert_eq(plan.deltas.length(), 1)
  assert_eq(plan.patch_plan.patches.length(), 1)
  assert_true(
    plan.patch_plan.patches[0].value_json.contains("\"id\":\"msg-1\""),
  )
  assert_true(
    plan.patch_plan.patches[0].value_json.contains("\"text\":\"hello"),
  )
  assert_true(plan.patch_plan.patches[0].value_json.contains("mini"))
  assert_true(plan.patch_plan.total_estimated_bytes < 220)
}

///|
test "agent deltas cover communication stream status and review updates" {
  let communication = append_communication_delta(
    "threads.thread-a.trace",
    review_request(
      id="comm-review",
      thread_id="thread-a",
      from_actor_id="agent-a",
      to_actor_id="operator",
      text="Approve result?",
      artifact_ref="artifact://result",
    ),
  )
  let chunk = append_stream_chunk_delta(
    "streams.run-a.chunks", "chunk-1", "partial text",
  )
  let status = set_run_status_delta("runs.run-a.status", Done)
  let review = set_review_state_delta("reviews.review-a.state", Approved)
  let plan = plan_agent_deltas([communication, chunk, status, review])
  assert_eq(plan.deltas.length(), 4)
  assert_eq(plan.patch_plan.patches.length(), 4)
  assert_true(
    plan.patch_plan.patches[0].value_json.contains(
      "\"kind\":\"review-request\"",
    ),
  )
  assert_true(
    plan.patch_plan.patches[1].value_json.contains("\"status\":\"running\""),
  )
  assert_eq(plan.patch_plan.patches[2].value_json, "\"done\"")
  assert_eq(plan.patch_plan.patches[3].value_json, "\"approved\"")
  assert_eq(plan.diagnostics.length(), 0)
}

///|
test "agent deltas can update in-flight stream chunks compactly" {
  let delta = set_stream_chunk_delta(
    "streams.run-a.chunksById",
    "chunk-1",
    "partial update",
    status=Running,
  )
  let plan = plan_agent_deltas([delta])
  assert_true(delta.kind is SetStreamChunk)
  assert_eq(delta.patches.length(), 1)
  assert_eq(delta.patches[0].path, "streams.run-a.chunksById.chunk-1")
  assert_true(delta.patches[0].value_json.contains("\"id\":\"chunk-1\""))
  assert_true(delta.patches[0].value_json.contains("partial update"))
  assert_eq(plan.duplicate_stream_chunk_count, 0)
  assert_eq(plan.diagnostics.length(), 0)
}

///|
test "agent delta plans flag duplicate appended stream chunks" {
  let plan = plan_agent_deltas([
    append_stream_chunk_delta("streams.run-a.chunks", "chunk-1", "first"),
    append_stream_chunk_delta("streams.run-a.chunks", "chunk-1", "second"),
    set_stream_chunk_delta("streams.run-a.chunksById", "chunk-1", "latest"),
  ])
  assert_eq(plan.patch_plan.patches.length(), 3)
  assert_eq(plan.duplicate_stream_chunk_count, 1)
  assert_true(plan.diagnostics.contains("agent-stream-chunk-duplicate:1"))
  assert_true(plan.summary.contains("duplicate_stream_chunks=1"))
}

///|
test "agent delta plans reuse patch budgets" {
  let plan = plan_agent_deltas_with_budget(
    [
      append_stream_chunk_delta("streams.run-a.chunks", "chunk-1", "a"),
      append_stream_chunk_delta("streams.run-a.chunks", "chunk-2", "b"),
    ],
    @core.patch_budget(max_patches=1, max_patch_bytes=10),
  )
  assert_eq(plan.patch_plan.patches.length(), 2)
  assert_true(plan.diagnostics.contains("patch-count-over-budget:2/1"))
  assert_eq(plan.duplicate_stream_chunk_count, 0)
  assert_true(plan.summary.contains("deltas=2"))
}

///|
test "agent delta kind ids stay stable" {
  assert_eq(agent_delta_kind_id(AppendMessage), "append-message")
  assert_eq(agent_delta_kind_id(AppendCommunication), "append-communication")
  assert_eq(agent_delta_kind_id(AppendStreamChunk), "append-stream-chunk")
  assert_eq(agent_delta_kind_id(SetStreamChunk), "set-stream-chunk")
  assert_eq(agent_delta_kind_id(SetRunStatus), "set-run-status")
  assert_eq(agent_delta_kind_id(SetReviewState), "set-review-state")
}
