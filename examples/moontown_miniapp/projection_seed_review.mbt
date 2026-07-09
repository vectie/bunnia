///|
fn demo_moderation_cases() -> Array[MiniTownModerationCase] {
  [
    mini_town_moderation_case(
      id="mod-policy-hall",
      building_id="policy-hall",
      reporter_id="user-a",
      target_ref="building:policy-hall",
      title="Policy Hall safety watch",
      summary="Reports and appeals stay reviewed.",
      status="watch",
      action_label="Appeal",
      action_message="appeal-moderation-case",
    ),
  ]
}

///|
fn demo_audit_events() -> Array[MiniTownAuditEvent] {
  [
    mini_town_audit_event(
      id="audit-policy-review",
      kind="review",
      title="Policy answer entered review",
      summary="Agent output is held until a reviewer accepts it into the book.",
      actor_id="agent-policy-guide",
      target_ref="run:run-policy-review",
      building_id="policy-hall",
      status="review",
      visibility="published",
      timestamp="2026-07-08T10:00:00Z",
    ),
    mini_town_audit_event(
      id="audit-team-share",
      kind="share",
      title="Team Studio shared with team",
      summary="Organization members can inspect this building before publication.",
      actor_id="user-a",
      target_ref="building:team-studio",
      building_id="team-studio",
      status="shared",
      visibility="shared_private",
      timestamp="2026-07-08T09:24:00Z",
    ),
    mini_town_audit_event(
      id="audit-private-draft",
      kind="create",
      title="Private Agent Lab drafted",
      summary="Private work stays owner-scoped until shared or published.",
      actor_id="user-a",
      target_ref="building:private-agent-lab",
      building_id="private-agent-lab",
      status="draft",
      visibility="private_draft",
      timestamp="2026-07-08T08:48:00Z",
    ),
    mini_town_audit_event(
      id="audit-published-agent-lab",
      kind="publish",
      title="Published Agent Lab approved",
      summary="This building is searchable and placeable from public town search.",
      actor_id="user-b",
      target_ref="building:published-agent-lab",
      building_id="published-agent-lab",
      status="stable",
      visibility="published",
      timestamp="2026-07-08T08:12:00Z",
    ),
  ]
}

///|
fn demo_reviews() -> Array[MiniTownReviewItem] {
  [
    mini_town_review_item(
      id="review-policy-memory",
      run_id="run-policy-review",
      building_id="policy-hall",
      book_id="book-policy-hall",
      title="Review policy answer",
      summary="Accept this answer into Policy Hall Book or reject it for more work.",
      artifact_ref="artifact://book-policy-hall",
      reviewer_id="user-a",
      status="pending",
      accepted_memory_delta=1,
      accept_message="accept-memory-review",
      reject_message="reject-memory-review",
    ),
  ]
}

///|
fn demo_runs() -> Array[MiniTownRun] {
  [
    mini_town_run(
      id="run-policy-review",
      agent_id="agent-policy-guide",
      building_id="policy-hall",
      book_id="book-policy-hall",
      thread_id="thread-policy-hall",
      title="Policy answer review",
      summary="Agent answer is waiting before it becomes public book memory.",
      status="review",
      review_required=true,
      artifact_ref="artifact://book-policy-hall",
    ),
    mini_town_run(
      id="run-market-scan",
      agent_id="agent-map-curator",
      building_id="market-square",
      book_id="book-market-square",
      thread_id="thread-market-square",
      title="Market placement scan",
      summary="Map Curator is finding published buildings that can be placed.",
      status="running",
      artifact_ref="artifact://market-square",
    ),
    mini_town_run(
      id="run-private-lab-draft",
      agent_id="agent-builder",
      building_id="private-agent-lab",
      book_id="book-private-agent-lab",
      thread_id="thread-private-agent-lab",
      title="Private lab setup",
      summary="Builder is preparing the private agent lab before publishing.",
      status="running",
      artifact_ref="artifact://book-private-agent-lab",
    ),
    mini_town_run(
      id="run-knowledge-sync",
      agent_id="agent-policy-guide",
      building_id="knowledge-house",
      book_id="book-knowledge-house",
      thread_id="thread-knowledge-house",
      title="Knowledge memory sync",
      summary="Accepted memories were synchronized into Knowledge House.",
      status="done",
      artifact_ref="artifact://book-knowledge-house",
    ),
  ]
}

///|
fn demo_tool_results() -> Array[MiniTownToolResult] {
  [
    mini_town_tool_result(
      id="tool-policy-summary",
      tool_name="book-summarizer",
      building_id="policy-hall",
      thread_id="thread-policy-hall",
      title="Policy source summary",
      summary="Summarized 9 public source notes for the pending policy answer.",
      artifact_ref="artifact://book-policy-hall-sources",
      status=@bunnia.run_waiting_review(),
      open_message="open-tool-policy-summary",
      acknowledge_message="ack-tool-result",
    ),
    mini_town_tool_result(
      id="tool-market-scan",
      tool_name="placement-scanner",
      building_id="market-square",
      thread_id="thread-market-square",
      title="Placement scan artifact",
      summary="Found reusable public buildings that can be pinned into the town map.",
      artifact_ref="artifact://market-square",
      status=@bunnia.run_running(),
      open_message="open-tool-market-scan",
      acknowledge_message="ack-tool-result",
    ),
  ]
}

///|
