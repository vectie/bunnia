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
