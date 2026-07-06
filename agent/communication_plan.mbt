///|
pub struct CommunicationFilter {
  thread_id : String
  actor_id : String
  kind_id : String
  include_resolved_reviews : Bool
} derive(Debug, Eq)

///|
pub struct CommunicationBudget {
  max_visible_count : Int
  max_review_request_count : Int
  max_unresolved_review_count : Int
  max_artifact_ref_count : Int
} derive(Debug, Eq)

///|
pub struct CommunicationPlan {
  total_count : Int
  filtered_count : Int
  visible_count : Int
  hidden_count : Int
  visible_items : Array[Communication]
  review_request_count : Int
  unresolved_review_count : Int
  handoff_count : Int
  broadcast_count : Int
  tool_result_count : Int
  recovery_notice_count : Int
  artifact_ref_count : Int
  running_count : Int
  failed_count : Int
  diagnostics : Array[String]
  summary : String
} derive(Debug, Eq)

///|
pub fn communication_filter(
  thread_id? : String = "",
  actor_id? : String = "",
  kind_id? : String = "",
  include_resolved_reviews? : Bool = true,
) -> CommunicationFilter {
  { thread_id, actor_id, kind_id, include_resolved_reviews }
}

///|
pub fn all_communication_filter() -> CommunicationFilter {
  communication_filter()
}

///|
pub fn communication_budget(
  max_visible_count? : Int = 80,
  max_review_request_count? : Int = 32,
  max_unresolved_review_count? : Int = 16,
  max_artifact_ref_count? : Int = 32,
) -> CommunicationBudget {
  {
    max_visible_count,
    max_review_request_count,
    max_unresolved_review_count,
    max_artifact_ref_count,
  }
}

///|
pub fn default_communication_budget() -> CommunicationBudget {
  communication_budget()
}

///|
pub fn filter_communications(
  items : Array[Communication],
  filter : CommunicationFilter,
) -> Array[Communication] {
  let output : Array[Communication] = []
  for item in items {
    if communication_matches_filter(item, filter) {
      output.push(item)
    }
  }
  output
}

///|
pub fn plan_communications(items : Array[Communication]) -> CommunicationPlan {
  plan_filtered_communications(
    items,
    all_communication_filter(),
    budget=default_communication_budget(),
  )
}

///|
pub fn plan_communications_with_budget(
  items : Array[Communication],
  budget : CommunicationBudget,
) -> CommunicationPlan {
  plan_filtered_communications(items, all_communication_filter(), budget~)
}

///|
pub fn plan_filtered_communications(
  items : Array[Communication],
  filter : CommunicationFilter,
  budget? : CommunicationBudget = default_communication_budget(),
) -> CommunicationPlan {
  let filtered = filter_communications(items, filter)
  let visible_count = clamp_visible_count(
    filtered.length(),
    budget.max_visible_count,
  )
  let visible_items : Array[Communication] = []
  for i in 0..<visible_count {
    visible_items.push(filtered[i])
  }
  let review_request_count = count_review_requests(filtered)
  let unresolved_review_count = count_unresolved_reviews(filtered)
  let handoff_count = count_kind(filtered, Handoff)
  let broadcast_count = count_kind(filtered, Broadcast)
  let tool_result_count = count_kind(filtered, ToolResult)
  let recovery_notice_count = count_kind(filtered, RecoveryNotice)
  let artifact_ref_count = count_artifact_refs(filtered)
  let running_count = count_status(filtered, Running)
  let failed_count = count_status(filtered, Failed)
  let diagnostics = communication_diagnostics(
    filtered_count=filtered.length(),
    visible_count~,
    review_request_count~,
    unresolved_review_count~,
    artifact_ref_count~,
    budget~,
  )
  {
    total_count: items.length(),
    filtered_count: filtered.length(),
    visible_count,
    hidden_count: filtered.length() - visible_count,
    visible_items,
    review_request_count,
    unresolved_review_count,
    handoff_count,
    broadcast_count,
    tool_result_count,
    recovery_notice_count,
    artifact_ref_count,
    running_count,
    failed_count,
    diagnostics,
    summary: "Bunnia communication plan: total=\{items.length()} filtered=\{filtered.length()} visible=\{visible_count} hidden=\{filtered.length() - visible_count} review_requests=\{review_request_count} unresolved_reviews=\{unresolved_review_count} handoffs=\{handoff_count} broadcasts=\{broadcast_count} tool_results=\{tool_result_count} recovery_notices=\{recovery_notice_count} artifacts=\{artifact_ref_count} running=\{running_count} failed=\{failed_count} diagnostics=\{diagnostics.length()}",
  }
}

///|
fn communication_matches_filter(
  item : Communication,
  filter : CommunicationFilter,
) -> Bool {
  let thread_match = filter.thread_id == "" ||
    item.thread_id == filter.thread_id
  let actor_match = filter.actor_id == "" ||
    item.from_actor_id == filter.actor_id ||
    item.to_actor_id == filter.actor_id
  let kind_match = filter.kind_id == "" ||
    communication_kind_id(item.kind) == filter.kind_id
  let review_match = filter.include_resolved_reviews ||
    !resolved_review_request(item)
  thread_match && actor_match && kind_match && review_match
}

///|
fn clamp_visible_count(total : Int, max_visible_count : Int) -> Int {
  if max_visible_count < 0 {
    0
  } else if max_visible_count < total {
    max_visible_count
  } else {
    total
  }
}

///|
fn communication_diagnostics(
  filtered_count~ : Int,
  visible_count~ : Int,
  review_request_count~ : Int,
  unresolved_review_count~ : Int,
  artifact_ref_count~ : Int,
  budget~ : CommunicationBudget,
) -> Array[String] {
  let diagnostics : Array[String] = []
  if visible_count < filtered_count {
    diagnostics.push(
      "communication-visible-over-budget:\{filtered_count}/\{budget.max_visible_count}",
    )
  }
  if review_request_count > budget.max_review_request_count {
    diagnostics.push(
      "communication-review-requests-over-budget:\{review_request_count}/\{budget.max_review_request_count}",
    )
  }
  if unresolved_review_count > budget.max_unresolved_review_count {
    diagnostics.push(
      "communication-unresolved-reviews-over-budget:\{unresolved_review_count}/\{budget.max_unresolved_review_count}",
    )
  }
  if artifact_ref_count > budget.max_artifact_ref_count {
    diagnostics.push(
      "communication-artifacts-over-budget:\{artifact_ref_count}/\{budget.max_artifact_ref_count}",
    )
  }
  diagnostics
}

///|
fn count_review_requests(items : Array[Communication]) -> Int {
  count_kind(items, ReviewRequest)
}

///|
fn count_unresolved_reviews(items : Array[Communication]) -> Int {
  let mut count = 0
  for item in items {
    if unresolved_review_request(item) {
      count += 1
    }
  }
  count
}

///|
fn count_kind(items : Array[Communication], kind : CommunicationKind) -> Int {
  let mut count = 0
  for item in items {
    if item.kind == kind {
      count += 1
    }
  }
  count
}

///|
fn count_status(items : Array[Communication], status : RunStatus) -> Int {
  let mut count = 0
  for item in items {
    if item.status == status {
      count += 1
    }
  }
  count
}

///|
fn count_artifact_refs(items : Array[Communication]) -> Int {
  let mut count = 0
  for item in items {
    if item.artifact_ref != "" {
      count += 1
    }
  }
  count
}

///|
fn unresolved_review_request(item : Communication) -> Bool {
  item.kind is ReviewRequest &&
  (item.status is WaitingReview || item.status is Running)
}

///|
fn resolved_review_request(item : Communication) -> Bool {
  item.kind is ReviewRequest && !unresolved_review_request(item)
}
