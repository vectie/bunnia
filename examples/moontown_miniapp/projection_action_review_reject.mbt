///|
pub fn reject_review(
  projection : MiniTownProjection,
  review_id : String,
) -> MiniTownProjection {
  let mut target_book_id = ""
  let mut target_building_id = ""
  let mut target_run_id = ""
  let reviews : Array[MiniTownReviewItem] = []
  for item in projection.reviews {
    if item.id == review_id && item.status == "pending" {
      target_book_id = item.book_id
      if item.artifact_ref.has_prefix("building://") {
        target_building_id = item.building_id
      }
      target_run_id = item.run_id
      reviews.push({ ..item, status: "rejected" })
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
        "private_draft",
        "draft",
      ),
      books: update_book_lifecycle_with_review_delta(
        projection.books,
        target_building_id,
        "private_draft",
        "draft",
        -1,
      ),
      audit_events: projection.audit_events +
      [
        lifecycle_event(
          id="audit-reject-\{target_building_id}",
          kind="review-reject",
          title="\{target_building_id} publication rejected",
          summary="Publication review rejected; building returned to private drafts.",
          actor_id=projection.active_user_id,
          building_id=target_building_id,
          status="draft",
          visibility="private_draft",
        ),
      ],
    }
  }
  {
    ..projection,
    reviews,
    runs: update_review_run_status(projection.runs, target_run_id, "rejected"),
    books: decrement_book_pending_review(projection.books, target_book_id),
  }
}
