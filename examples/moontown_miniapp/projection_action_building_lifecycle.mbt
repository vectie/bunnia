///|
pub fn share_selected_building(
  projection : MiniTownProjection,
) -> MiniTownProjection {
  let building = selected_building(projection)
  update_selected_building_lifecycle(
    projection,
    visibility="shared_private",
    status="shared",
    kind="share",
    title="\{building.title} shared",
    summary="The building is visible to organization members before publication.",
  )
}

///|
pub fn submit_selected_building(
  projection : MiniTownProjection,
) -> MiniTownProjection {
  let building = selected_building(projection)
  let book = selected_building_book(projection)
  let submitted = update_selected_building_lifecycle(
    projection,
    visibility="submitted",
    status="review",
    kind="submit",
    title="\{building.title} submitted",
    summary="The building is waiting for town publication review.",
  )
  {
    ..submitted,
    books: update_book_lifecycle_with_review_delta(
      submitted.books,
      building.id,
      "submitted",
      "review",
      1,
    ),
    reviews: submitted.reviews +
    [
      mini_town_review_item(
        id="review-publish-\{building.id}",
        run_id="publication-\{building.id}",
        building_id=building.id,
        book_id=book.id,
        title="Review \{building.title} publication",
        summary="Approve this building before it appears in public discovery, or reject it back to drafts.",
        artifact_ref="building://\{building.id}",
        reviewer_id=projection.active_user_id,
        status="pending",
        accepted_memory_delta=0,
      ),
    ],
    notifications: submitted.notifications +
    [
      mini_town_notification(
        id="notice-review-publish-\{building.id}",
        kind="review",
        title="Publication review waiting",
        body="\{building.title} needs a decision before public discovery.",
        target_ref="building:\{building.id}",
        building_id=building.id,
        action_label="Review",
        action_message="open-notice-review",
      ),
    ],
  }
}

///|
pub fn publish_selected_building(
  projection : MiniTownProjection,
) -> MiniTownProjection {
  let building = selected_building(projection)
  update_selected_building_lifecycle(
    projection,
    visibility="published",
    status="stable",
    kind="publish",
    title="\{building.title} published",
    summary="The building is searchable and placeable from public discovery.",
  )
}

///|
pub fn archive_selected_building(
  projection : MiniTownProjection,
) -> MiniTownProjection {
  let building = selected_building(projection)
  update_selected_building_lifecycle(
    projection,
    visibility="archived",
    status="archived",
    kind="archive",
    title="\{building.title} archived",
    summary="The building is hidden from normal map and search surfaces.",
  )
}

///|
pub fn restore_selected_building(
  projection : MiniTownProjection,
) -> MiniTownProjection {
  let building = selected_building(projection)
  update_selected_building_lifecycle(
    projection,
    visibility="private_draft",
    status="draft",
    kind="restore",
    title="\{building.title} restored",
    summary="The archived building returned to the private draft workbench.",
  )
}
