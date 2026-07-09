///|
pub fn create_private_building(
  projection : MiniTownProjection,
  id : String,
  title : String,
) -> MiniTownProjection {
  let created = mini_town_building(
    id~,
    title~,
    kind="agent_lab",
    visibility="private_draft",
    owner_id=projection.active_user_id,
    summary="New private building created from the mini-app form.",
    tags=["agent", "private", "created"],
    x=432,
    y=513,
    status="draft",
  )
  let book = mini_town_book(
    id="book-\{id}",
    building_id=id,
    title="\{title} Book",
    owner_id=projection.active_user_id,
    visibility="private_draft",
    summary="Private book memory created with this building.",
    accepted_memory_count=0,
    pending_review_count=0,
    status="draft",
  )
  {
    ..projection,
    selected_building_id: id,
    buildings: projection.buildings + [created],
    books: projection.books + [book],
    audit_events: projection.audit_events +
    [
      lifecycle_event(
        id="audit-create-\{id}",
        kind="create",
        title="\{title} created",
        summary="Private building and book were created for this user.",
        actor_id=projection.active_user_id,
        building_id=id,
        status="draft",
        visibility="private_draft",
      ),
    ],
  }
}

///|
pub fn edit_selected_building(
  projection : MiniTownProjection,
  title : String,
  summary : String,
  book_title : String,
  book_summary : String,
  tags : Array[String],
) -> MiniTownProjection {
  let building = selected_building(projection)
  if building.owner_id != projection.active_user_id ||
    (
      building.visibility != "private_draft" &&
      building.visibility != "shared_private"
    ) {
    return projection
  }
  {
    ..projection,
    buildings: update_building_profile(
      projection.buildings,
      building.id,
      title,
      summary,
      tags,
    ),
    books: update_book_profile(
      projection.books,
      building.id,
      book_title,
      book_summary,
    ),
    audit_events: projection.audit_events +
    [
      lifecycle_event(
        id="audit-update-\{building.id}",
        kind="update",
        title="\{title} updated",
        summary="Draft building profile and safe book summary were updated.",
        actor_id=projection.active_user_id,
        building_id=building.id,
        status=building.status,
        visibility=building.visibility,
      ),
    ],
  }
}

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

///|
pub fn send_message_to_selected_building(
  projection : MiniTownProjection,
  body : String,
) -> MiniTownProjection {
  let building = selected_building(projection)
  let message = mini_town_message(
    id="msg-local-preview",
    actor_id=projection.active_user_id,
    thread_id="thread-\{building.id}",
    text=body,
    status=@bunnia.run_running(),
  )
  { ..projection, messages: projection.messages + [message] }
}

///|
pub fn place_published_building(
  projection : MiniTownProjection,
  building_id : String,
) -> MiniTownProjection {
  let mut title = building_id
  let mut x = 0
  let mut y = 0
  for building in projection.buildings {
    if building.id == building_id {
      title = building.title
      x = building.x
      y = building.y
    }
  }
  let placement_id = "placement-\{projection.active_user_id}-\{building_id}"
  let placements = if placement_exists(projection, placement_id) {
    projection.placements
  } else {
    projection.placements +
    [
      mini_town_placement(
        id=placement_id,
        building_id~,
        owner_id=projection.active_user_id,
        layer="personal",
        x~,
        y~,
        status="pinned",
        source="discover",
      ),
    ]
  }
  {
    ..projection,
    selected_building_id: building_id,
    placements,
    audit_events: projection.audit_events +
    [
      lifecycle_event(
        id="audit-place-\{building_id}",
        kind="place",
        title="\{title} placed",
        summary="A public building was placed onto this user's map layer.",
        actor_id=projection.active_user_id,
        building_id~,
        status="stable",
        visibility="published",
      ),
    ],
  }
}

///|
fn placement_exists(
  projection : MiniTownProjection,
  placement_id : String,
) -> Bool {
  for placement in projection.placements {
    if placement.id == placement_id {
      return true
    }
  }
  false
}

///|
