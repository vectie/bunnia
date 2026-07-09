///|
pub fn ownership_items(
  projection : MiniTownProjection,
) -> Array[MiniTownOwnershipItem] {
  let output : Array[MiniTownOwnershipItem] = []
  for building in owned_buildings(projection) {
    output.push(
      mini_town_ownership_item(
        id="owned-building-\{building.id}",
        kind="building",
        title=building.title,
        summary=building.summary,
        target_ref="building:\{building.id}",
        visibility=building.visibility,
        status=building.status,
        action_label=ownership_building_action_label(building),
        action_message=ownership_building_action_message(building),
      ),
    )
  }
  for placement in visible_placements(projection) {
    output.push(placement_ownership_item(projection, placement))
  }
  for book in owned_books(projection) {
    output.push(
      mini_town_ownership_item(
        id="owned-book-\{book.id}",
        kind="book",
        title=book.title,
        summary=book.summary,
        target_ref="book:\{book.id}",
        visibility=book.visibility,
        status=book.status,
        action_label="Review",
        action_message="tab-messages",
      ),
    )
  }
  for agent in owned_agents(projection) {
    output.push(
      mini_town_ownership_item(
        id="owned-agent-\{agent.id}",
        kind="agent",
        title=agent.name,
        summary="Agent attached to an owned or private building.",
        target_ref="agent:\{agent.id}",
        visibility="private_draft",
        status=agent.status,
        action_label="Chat",
        action_message="tab-messages",
      ),
    )
  }
  for item in visible_watches(projection) {
    output.push(watch_ownership_item(item))
  }
  output
}

///|
fn watch_ownership_item(item : MiniTownWatch) -> MiniTownOwnershipItem {
  mini_town_ownership_item(
    id="owned-\{item.id}",
    kind="watch",
    title=item.title,
    summary=item.summary,
    target_ref=item.target_ref,
    visibility="watching",
    status=item.status,
    action_label="Open",
    action_message=item.action_message,
  )
}

///|
fn placement_ownership_item(
  projection : MiniTownProjection,
  placement : MiniTownPlacement,
) -> MiniTownOwnershipItem {
  let mut title = placement.building_id
  let mut summary = "Placed building on \{placement.layer} layer."
  let mut status = placement.status
  for building in projection.buildings {
    if building.id == placement.building_id {
      title = building.title
      summary = "\{building.summary} / \{placement_source_label(placement.source)}"
      status = building.status
    }
  }
  mini_town_ownership_item(
    id="placement-\{placement.id}",
    kind="placement",
    title~,
    summary~,
    target_ref="placement:\{placement.id}",
    visibility=placement.layer,
    status~,
    action_label="Open",
    action_message="select-\{placement.building_id}",
  )
}

///|
fn ownership_building_action_label(building : MiniTownBuilding) -> String {
  if building.visibility == "private_draft" {
    "Submit"
  } else if building.visibility == "shared_private" {
    "Submit"
  } else if building.visibility == "submitted" {
    "Review"
  } else if building.visibility == "published" {
    "Place"
  } else if building.visibility == "archived" {
    "Restore"
  } else {
    "Open"
  }
}

///|
fn ownership_building_action_message(building : MiniTownBuilding) -> String {
  if building.visibility == "private_draft" {
    "submit-private-building"
  } else if building.visibility == "shared_private" {
    "submit-private-building"
  } else if building.visibility == "submitted" {
    "tab-messages"
  } else if building.visibility == "published" {
    "tab-discover"
  } else if building.visibility == "archived" {
    "restore-archived-building"
  } else {
    "select-\{building.id}"
  }
}
