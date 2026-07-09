///|
pub fn accept_review(
  projection : MiniTownProjection,
  review_id : String,
) -> MiniTownProjection {
  let mut delta = 0
  let mut target_book_id = ""
  let mut target_building_id = ""
  let mut target_run_id = ""
  let reviews : Array[MiniTownReviewItem] = []
  for item in projection.reviews {
    if item.id == review_id && item.status == "pending" {
      delta = item.accepted_memory_delta
      target_book_id = item.book_id
      if item.artifact_ref.has_prefix("building://") {
        target_building_id = item.building_id
      }
      target_run_id = item.run_id
      reviews.push({ ..item, status: "accepted" })
    } else {
      reviews.push(item)
    }
  }
  if target_building_id != "" {
    return {
      ..projection,
      reviews,
      buildings: update_building_lifecycle(
        projection.buildings,
        target_building_id,
        "published",
        "stable",
      ),
      books: update_book_lifecycle_with_review_delta(
        projection.books,
        target_building_id,
        "published",
        "stable",
        -1,
      ),
      audit_events: projection.audit_events +
      [
        lifecycle_event(
          id="audit-accept-\{target_building_id}",
          kind="review-accept",
          title="\{target_building_id} publication accepted",
          summary="Publication review accepted; building is searchable and placeable.",
          actor_id=projection.active_user_id,
          building_id=target_building_id,
          status="stable",
          visibility="published",
        ),
      ],
    }
  }
  {
    ..projection,
    reviews,
    runs: update_review_run_status(projection.runs, target_run_id, "done"),
    books: accept_book_memory(projection.books, target_book_id, delta),
  }
}
