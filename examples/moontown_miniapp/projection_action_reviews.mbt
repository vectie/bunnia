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
    runs: update_run_status(projection.runs, target_run_id, "done"),
    books: accept_book_memory(projection.books, target_book_id, delta),
  }
}

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
    runs: update_run_status(projection.runs, target_run_id, "rejected"),
    books: decrement_book_pending_review(projection.books, target_book_id),
  }
}

///|
fn update_run_status(
  runs : Array[MiniTownRun],
  run_id : String,
  status : String,
) -> Array[MiniTownRun] {
  let output : Array[MiniTownRun] = []
  for run in runs {
    if run.id == run_id {
      output.push({ ..run, status, review_required: false })
    } else {
      output.push(run)
    }
  }
  output
}

///|
fn accept_book_memory(
  books : Array[MiniTownBook],
  book_id : String,
  delta : Int,
) -> Array[MiniTownBook] {
  let output : Array[MiniTownBook] = []
  for book in books {
    if book.id == book_id {
      output.push({
        ..book,
        accepted_memory_count: book.accepted_memory_count + delta,
        pending_review_count: if book.pending_review_count > 0 {
          book.pending_review_count - 1
        } else {
          0
        },
        status: "stable",
      })
    } else {
      output.push(book)
    }
  }
  output
}
