///|
pub fn selected_building_lifecycle_actions(
  projection : MiniTownProjection,
) -> Array[MiniTownLifecycleAction] {
  let building = selected_building(projection)
  let book = selected_building_book(projection)
  [
    mini_town_lifecycle_action(
      id="ask",
      label="Ask",
      message="ask-selected-building",
      target_ref="building:\{building.id}",
      book_id=book.id,
      allowed=building.visibility != "archived",
      reason=if building.visibility == "archived" {
        "archived building"
      } else {
        "book linked"
      },
      status=if building.visibility == "archived" { "blocked" } else { "ready" },
    ),
    mini_town_lifecycle_action(
      id="edit",
      label="Edit",
      message="update-private-building",
      target_ref="building:\{building.id}",
      book_id=book.id,
      allowed=building.owner_id == projection.active_user_id &&
        (
          building.visibility == "private_draft" ||
          building.visibility == "shared_private"
        ),
      reason=lifecycle_edit_reason(projection, building),
      status=if building.owner_id == projection.active_user_id &&
        (
          building.visibility == "private_draft" ||
          building.visibility == "shared_private"
        ) {
        "ready"
      } else {
        "blocked"
      },
    ),
    mini_town_lifecycle_action(
      id="place",
      label="Place",
      message="place-published-building",
      target_ref="building:\{building.id}",
      book_id=book.id,
      allowed=building.visibility == "published",
      reason=if building.visibility == "published" {
        "published building"
      } else {
        "publish first"
      },
      status=if building.visibility == "published" {
        "ready"
      } else {
        "blocked"
      },
    ),
    mini_town_lifecycle_action(
      id="share",
      label="Share",
      message="share-private-building",
      target_ref="building:\{building.id}",
      book_id=book.id,
      allowed=building.owner_id == projection.active_user_id &&
        building.visibility == "private_draft",
      reason=lifecycle_share_reason(projection, building),
      status=if building.owner_id == projection.active_user_id &&
        building.visibility == "private_draft" {
        "ready"
      } else {
        "blocked"
      },
    ),
    mini_town_lifecycle_action(
      id="submit",
      label="Submit",
      message="submit-private-building",
      target_ref="building:\{building.id}",
      book_id=book.id,
      allowed=building.owner_id == projection.active_user_id &&
        (
          building.visibility == "private_draft" ||
          building.visibility == "shared_private"
        ) &&
        profile_ready_to_publish(projection),
      reason=lifecycle_publish_reason(projection, building),
      status=if building.owner_id == projection.active_user_id &&
        (
          building.visibility == "private_draft" ||
          building.visibility == "shared_private"
        ) &&
        profile_ready_to_publish(projection) {
        "ready"
      } else {
        "blocked"
      },
    ),
    mini_town_lifecycle_action(
      id="publish",
      label="Publish",
      message="publish-private-building",
      target_ref="building:\{building.id}",
      book_id=book.id,
      allowed=building.owner_id == projection.active_user_id &&
        building.visibility == "submitted" &&
        profile_ready_to_publish(projection),
      reason=lifecycle_publish_reason(projection, building),
      status=if building.owner_id == projection.active_user_id &&
        building.visibility == "submitted" &&
        profile_ready_to_publish(projection) {
        "ready"
      } else {
        "blocked"
      },
    ),
    mini_town_lifecycle_action(
      id="archive",
      label="Archive",
      message="archive-private-building",
      target_ref="building:\{building.id}",
      book_id=book.id,
      allowed=building.owner_id == projection.active_user_id &&
        building.visibility != "archived",
      reason=lifecycle_archive_reason(projection, building),
      status=if building.owner_id == projection.active_user_id &&
        building.visibility != "archived" {
        "ready"
      } else {
        "blocked"
      },
    ),
    mini_town_lifecycle_action(
      id="restore",
      label="Restore",
      message="restore-archived-building",
      target_ref="building:\{building.id}",
      book_id=book.id,
      allowed=building.owner_id == projection.active_user_id &&
        building.visibility == "archived",
      reason=lifecycle_restore_reason(projection, building),
      status=if building.owner_id == projection.active_user_id &&
        building.visibility == "archived" {
        "ready"
      } else {
        "blocked"
      },
    ),
  ]
}

///|
fn lifecycle_share_reason(
  projection : MiniTownProjection,
  building : MiniTownBuilding,
) -> String {
  if building.owner_id != projection.active_user_id {
    "owner only"
  } else if building.visibility == "private_draft" {
    "private draft"
  } else {
    "already shared"
  }
}

///|
fn lifecycle_edit_reason(
  projection : MiniTownProjection,
  building : MiniTownBuilding,
) -> String {
  if building.owner_id != projection.active_user_id {
    "owner only"
  } else if building.visibility == "private_draft" ||
    building.visibility == "shared_private" {
    "draft editable"
  } else {
    "locked after submit"
  }
}

///|
fn lifecycle_publish_reason(
  projection : MiniTownProjection,
  building : MiniTownBuilding,
) -> String {
  if building.owner_id != projection.active_user_id {
    "owner only"
  } else if !profile_ready_to_publish(projection) {
    "Finish profile first"
  } else if building.visibility == "private_draft" ||
    building.visibility == "shared_private" {
    "ready for review"
  } else if building.visibility == "submitted" {
    "review accepted"
  } else {
    "not submitted"
  }
}

///|
fn lifecycle_archive_reason(
  projection : MiniTownProjection,
  building : MiniTownBuilding,
) -> String {
  if building.owner_id != projection.active_user_id {
    "owner only"
  } else if building.visibility == "archived" {
    "already archived"
  } else {
    "Owner can archive"
  }
}

///|
fn lifecycle_restore_reason(
  projection : MiniTownProjection,
  building : MiniTownBuilding,
) -> String {
  if building.owner_id != projection.active_user_id {
    "owner only"
  } else if building.visibility == "archived" {
    "restore to draft"
  } else {
    "not archived"
  }
}
