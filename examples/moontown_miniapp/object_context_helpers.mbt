///|
fn building_pending_review(
  projection : MiniTownProjection,
  building_id : String,
) -> MiniTownReviewItem {
  for review in pending_reviews(projection) {
    if review.building_id == building_id {
      return review
    }
  }
  mini_town_review_item(
    id="",
    run_id="",
    building_id="",
    book_id="",
    title="",
    summary="",
    artifact_ref="",
    reviewer_id="",
    status="stable",
  )
}

///|
fn message_actor_label(
  projection : MiniTownProjection,
  actor_id : String,
) -> String {
  if actor_id == projection.active_user_id {
    projection.profile.display_name
  } else if actor_id == "system" {
    "Town notice"
  } else {
    agent_name(projection, actor_id)
  }
}

///|
fn selected_building_latest_run(projection : MiniTownProjection) -> MiniTownRun {
  let runs = selected_building_runs(projection)
  if runs.length() > 0 {
    runs[0]
  } else {
    projection.runs[0]
  }
}
