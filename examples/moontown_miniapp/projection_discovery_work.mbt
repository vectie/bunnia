///|
pub fn active_runs(projection : MiniTownProjection) -> Array[MiniTownRun] {
  let output : Array[MiniTownRun] = []
  for run in visible_runs(projection) {
    if run.status == "running" ||
      run.status == "review" ||
      run.status == "failed" ||
      run.status == "rejected" ||
      run.status == "cancelled" {
      output.push(run)
    }
  }
  output
}

///|
pub fn review_runs(projection : MiniTownProjection) -> Array[MiniTownRun] {
  let output : Array[MiniTownRun] = []
  for run in visible_runs(projection) {
    if run.review_required || run.status == "review" {
      output.push(run)
    }
  }
  output
}

///|
pub fn run_actions(run : MiniTownRun) -> Array[MiniTownRunAction] {
  let reviewable = run.review_required &&
    (run.status == "review" || run.status == "waiting-review")
  let cancellable = run.status == "running"
  let retryable = run_can_retry(run)
  [
    mini_town_run_action(
      id="open-building",
      label="Open",
      message="select-\{run.building_id}",
      target_ref="building:\{run.building_id}",
      allowed=true,
      reason="building context",
      status="ready",
    ),
    mini_town_run_action(
      id="review-accept",
      label="Accept",
      message="accept-memory-review",
      target_ref=run.artifact_ref,
      allowed=reviewable,
      reason=if reviewable { "review required" } else { "not waiting review" },
      status=if reviewable { "ready" } else { "blocked" },
    ),
    mini_town_run_action(
      id="review-reject",
      label="Reject",
      message="reject-memory-review",
      target_ref=run.artifact_ref,
      allowed=reviewable,
      reason=if reviewable { "review required" } else { "not waiting review" },
      status=if reviewable { "ready" } else { "blocked" },
    ),
    mini_town_run_action(
      id="cancel",
      label="Cancel",
      message="cancel-run",
      target_ref="run:\{run.id}",
      allowed=cancellable,
      reason=if cancellable { "running run" } else { "not running" },
      status=if cancellable { "ready" } else { "blocked" },
    ),
    mini_town_run_action(
      id="retry",
      label="Retry",
      message="retry-run",
      target_ref="run:\{run.id}",
      allowed=retryable,
      reason=if retryable { "run can be retried" } else { "wait for status" },
      status=if retryable { "ready" } else { "blocked" },
    ),
  ]
}

///|
fn run_can_retry(run : MiniTownRun) -> Bool {
  run.status == "failed" ||
  run.status == "rejected" ||
  run.status == "cancelled"
}

///|
pub fn pending_reviews(
  projection : MiniTownProjection,
) -> Array[MiniTownReviewItem] {
  let output : Array[MiniTownReviewItem] = []
  for item in visible_reviews(projection) {
    if item.status == "pending" {
      output.push(item)
    }
  }
  output
}
