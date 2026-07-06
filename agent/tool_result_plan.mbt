///|
pub struct ToolResultBudget {
  max_visible_count : Int
  max_pending_ack_count : Int
  max_missing_ack_count : Int
  max_artifact_ref_count : Int
} derive(Debug, Eq)

///|
pub struct ToolResultPlan {
  total_count : Int
  visible_count : Int
  hidden_count : Int
  visible_items : Array[ToolResultCard]
  artifact_ref_count : Int
  pending_ack_count : Int
  missing_ack_count : Int
  running_count : Int
  failed_count : Int
  diagnostics : Array[String]
  summary : String
} derive(Debug, Eq)

///|
pub fn tool_result_budget(
  max_visible_count? : Int = 32,
  max_pending_ack_count? : Int = 16,
  max_missing_ack_count? : Int = 0,
  max_artifact_ref_count? : Int = 32,
) -> ToolResultBudget {
  {
    max_visible_count,
    max_pending_ack_count,
    max_missing_ack_count,
    max_artifact_ref_count,
  }
}

///|
pub fn default_tool_result_budget() -> ToolResultBudget {
  tool_result_budget()
}

///|
pub fn plan_tool_result_cards(cards : Array[ToolResultCard]) -> ToolResultPlan {
  plan_tool_result_cards_with_budget(cards, default_tool_result_budget())
}

///|
pub fn plan_tool_result_cards_with_budget(
  cards : Array[ToolResultCard],
  budget : ToolResultBudget,
) -> ToolResultPlan {
  let visible_count = clamp_tool_result_visible_count(
    cards.length(),
    budget.max_visible_count,
  )
  let visible_items : Array[ToolResultCard] = []
  for i in 0..<visible_count {
    visible_items.push(cards[i])
  }
  let artifact_ref_count = count_tool_result_artifacts(cards)
  let pending_ack_count = count_pending_tool_result_acks(cards)
  let missing_ack_count = count_missing_tool_result_acks(cards)
  let running_count = count_tool_result_status(cards, Running)
  let failed_count = count_tool_result_status(cards, Failed)
  let diagnostics = tool_result_diagnostics(
    total_count=cards.length(),
    visible_count~,
    artifact_ref_count~,
    pending_ack_count~,
    missing_ack_count~,
    budget~,
  )
  {
    total_count: cards.length(),
    visible_count,
    hidden_count: cards.length() - visible_count,
    visible_items,
    artifact_ref_count,
    pending_ack_count,
    missing_ack_count,
    running_count,
    failed_count,
    diagnostics,
    summary: "Bunnia tool result plan: total=\{cards.length()} visible=\{visible_count} hidden=\{cards.length() - visible_count} artifacts=\{artifact_ref_count} pending_acks=\{pending_ack_count} missing_acks=\{missing_ack_count} running=\{running_count} failed=\{failed_count} diagnostics=\{diagnostics.length()}",
  }
}

///|
fn clamp_tool_result_visible_count(total : Int, max_visible_count : Int) -> Int {
  if max_visible_count < 0 {
    0
  } else if max_visible_count < total {
    max_visible_count
  } else {
    total
  }
}

///|
fn tool_result_diagnostics(
  total_count~ : Int,
  visible_count~ : Int,
  artifact_ref_count~ : Int,
  pending_ack_count~ : Int,
  missing_ack_count~ : Int,
  budget~ : ToolResultBudget,
) -> Array[String] {
  let diagnostics : Array[String] = []
  if visible_count < total_count {
    diagnostics.push(
      "tool-results-visible-over-budget:\{total_count}/\{budget.max_visible_count}",
    )
  }
  if pending_ack_count > budget.max_pending_ack_count {
    diagnostics.push(
      "tool-results-pending-acks-over-budget:\{pending_ack_count}/\{budget.max_pending_ack_count}",
    )
  }
  if missing_ack_count > budget.max_missing_ack_count {
    diagnostics.push(
      "tool-results-missing-acks:\{missing_ack_count}/\{budget.max_missing_ack_count}",
    )
  }
  if artifact_ref_count > budget.max_artifact_ref_count {
    diagnostics.push(
      "tool-results-artifacts-over-budget:\{artifact_ref_count}/\{budget.max_artifact_ref_count}",
    )
  }
  diagnostics
}

///|
fn count_tool_result_artifacts(cards : Array[ToolResultCard]) -> Int {
  let mut count = 0
  for card in cards {
    if card.artifact_ref != "" {
      count += 1
    }
  }
  count
}

///|
fn count_pending_tool_result_acks(cards : Array[ToolResultCard]) -> Int {
  let mut count = 0
  for card in cards {
    if card.acknowledge_message != "" && tool_result_ack_pending(card.status) {
      count += 1
    }
  }
  count
}

///|
fn count_missing_tool_result_acks(cards : Array[ToolResultCard]) -> Int {
  let mut count = 0
  for card in cards {
    if card.acknowledge_message == "" && card.status is WaitingReview {
      count += 1
    }
  }
  count
}

///|
fn tool_result_ack_pending(status : RunStatus) -> Bool {
  status is WaitingReview || status is Running
}

///|
fn count_tool_result_status(
  cards : Array[ToolResultCard],
  status : RunStatus,
) -> Int {
  let mut count = 0
  for card in cards {
    if card.status == status {
      count += 1
    }
  }
  count
}
