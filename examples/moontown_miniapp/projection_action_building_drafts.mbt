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
