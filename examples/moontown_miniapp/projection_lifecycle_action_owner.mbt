///|
fn lifecycle_edit_action(
  projection : MiniTownProjection,
  building : MiniTownBuilding,
  book : MiniTownBook,
) -> MiniTownLifecycleAction {
  let allowed = building.owner_id == projection.active_user_id &&
    (
      building.visibility == "private_draft" ||
      building.visibility == "shared_private"
    )
  mini_town_lifecycle_action(
    id="edit",
    label="Edit",
    message="update-private-building",
    target_ref="building:\{building.id}",
    book_id=book.id,
    allowed~,
    reason=lifecycle_edit_reason(projection, building),
    status=if allowed { "ready" } else { "blocked" },
  )
}

///|
fn lifecycle_share_action(
  projection : MiniTownProjection,
  building : MiniTownBuilding,
  book : MiniTownBook,
) -> MiniTownLifecycleAction {
  let allowed = building.owner_id == projection.active_user_id &&
    building.visibility == "private_draft"
  mini_town_lifecycle_action(
    id="share",
    label="Share",
    message="share-private-building",
    target_ref="building:\{building.id}",
    book_id=book.id,
    allowed~,
    reason=lifecycle_share_reason(projection, building),
    status=if allowed { "ready" } else { "blocked" },
  )
}

///|
fn lifecycle_submit_action(
  projection : MiniTownProjection,
  building : MiniTownBuilding,
  book : MiniTownBook,
) -> MiniTownLifecycleAction {
  let allowed = building.owner_id == projection.active_user_id &&
    (
      building.visibility == "private_draft" ||
      building.visibility == "shared_private"
    ) &&
    profile_ready_to_publish(projection)
  mini_town_lifecycle_action(
    id="submit",
    label="Submit",
    message="submit-private-building",
    target_ref="building:\{building.id}",
    book_id=book.id,
    allowed~,
    reason=lifecycle_publish_reason(projection, building),
    status=if allowed { "ready" } else { "blocked" },
  )
}

///|
fn lifecycle_publish_action(
  projection : MiniTownProjection,
  building : MiniTownBuilding,
  book : MiniTownBook,
) -> MiniTownLifecycleAction {
  let allowed = building.owner_id == projection.active_user_id &&
    building.visibility == "submitted" &&
    profile_ready_to_publish(projection)
  mini_town_lifecycle_action(
    id="publish",
    label="Publish",
    message="publish-private-building",
    target_ref="building:\{building.id}",
    book_id=book.id,
    allowed~,
    reason=lifecycle_publish_reason(projection, building),
    status=if allowed { "ready" } else { "blocked" },
  )
}

///|
fn lifecycle_archive_action(
  projection : MiniTownProjection,
  building : MiniTownBuilding,
  book : MiniTownBook,
) -> MiniTownLifecycleAction {
  let allowed = building.owner_id == projection.active_user_id &&
    building.visibility != "archived"
  mini_town_lifecycle_action(
    id="archive",
    label="Archive",
    message="archive-private-building",
    target_ref="building:\{building.id}",
    book_id=book.id,
    allowed~,
    reason=lifecycle_archive_reason(projection, building),
    status=if allowed { "ready" } else { "blocked" },
  )
}

///|
fn lifecycle_restore_action(
  projection : MiniTownProjection,
  building : MiniTownBuilding,
  book : MiniTownBook,
) -> MiniTownLifecycleAction {
  let allowed = building.owner_id == projection.active_user_id &&
    building.visibility == "archived"
  mini_town_lifecycle_action(
    id="restore",
    label="Restore",
    message="restore-archived-building",
    target_ref="building:\{building.id}",
    book_id=book.id,
    allowed~,
    reason=lifecycle_restore_reason(projection, building),
    status=if allowed { "ready" } else { "blocked" },
  )
}
