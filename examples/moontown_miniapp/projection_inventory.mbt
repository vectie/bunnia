///|
pub fn owned_buildings(
  projection : MiniTownProjection,
) -> Array[MiniTownBuilding] {
  let output : Array[MiniTownBuilding] = []
  for building in projection.buildings {
    if building.owner_id == projection.active_user_id {
      output.push(building)
    }
  }
  output
}

///|
pub fn owned_books(projection : MiniTownProjection) -> Array[MiniTownBook] {
  let output : Array[MiniTownBook] = []
  for book in projection.books {
    if book.owner_id == projection.active_user_id {
      output.push(book)
    }
  }
  output
}

///|
pub fn visible_watches(projection : MiniTownProjection) -> Array[MiniTownWatch] {
  let output : Array[MiniTownWatch] = []
  for item in projection.watches {
    if item.user_id == projection.active_user_id {
      output.push(item)
    }
  }
  output
}

///|
pub fn ownership_stats(
  projection : MiniTownProjection,
) -> Array[MiniTownOwnershipStat] {
  [
    mini_town_ownership_stat(
      id="placements",
      label="Placed",
      value=visible_placements(projection).length(),
    ),
    mini_town_ownership_stat(
      id="drafts",
      label="Drafts",
      value=count_owned_buildings_by_visibility(projection, "private_draft"),
    ),
    mini_town_ownership_stat(
      id="shared",
      label="Shared",
      value=count_shared_buildings(projection),
    ),
    mini_town_ownership_stat(
      id="published",
      label="Published",
      value=count_owned_buildings_by_visibility(projection, "published"),
    ),
    mini_town_ownership_stat(
      id="agents",
      label="Agents",
      value=owned_agents(projection).length(),
    ),
    mini_town_ownership_stat(
      id="books",
      label="Books",
      value=owned_books(projection).length(),
    ),
    mini_town_ownership_stat(
      id="watches",
      label="Watches",
      value=visible_watches(projection).length(),
    ),
  ]
}

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

///|
pub fn selected_ownership_filter(
  projection : MiniTownProjection,
) -> MiniTownOwnershipFilter {
  for item in projection.ownership_filters {
    if item.id == projection.active_ownership_filter_id {
      return item
    }
  }
  mini_town_ownership_filter(id="all", label="All")
}

///|
pub fn filtered_ownership_items(
  projection : MiniTownProjection,
) -> Array[MiniTownOwnershipItem] {
  let filter = selected_ownership_filter(projection)
  let output : Array[MiniTownOwnershipItem] = []
  for item in ownership_items(projection) {
    if mini_town_ownership_filter_match(filter, item) {
      output.push(item)
    }
  }
  output
}

///|
fn mini_town_ownership_filter_match(
  filter : MiniTownOwnershipFilter,
  item : MiniTownOwnershipItem,
) -> Bool {
  (filter.kind == "all" || filter.kind == item.kind) &&
  (filter.visibility == "all" || filter.visibility == item.visibility)
}

///|
pub fn switch_ownership_filter(
  projection : MiniTownProjection,
  filter_id : String,
) -> MiniTownProjection {
  { ..projection, active_ownership_filter_id: filter_id }
}

///|
fn owned_agents(projection : MiniTownProjection) -> Array[MiniTownAgent] {
  let output : Array[MiniTownAgent] = []
  for agent in projection.agents {
    if agent_attached_to_owned_building(projection, agent) {
      output.push(agent)
    }
  }
  output
}

///|
fn agent_attached_to_owned_building(
  projection : MiniTownProjection,
  agent : MiniTownAgent,
) -> Bool {
  for building in owned_buildings(projection) {
    if building.id == agent.building_id {
      return true
    }
  }
  false
}

///|
fn count_owned_buildings_by_visibility(
  projection : MiniTownProjection,
  visibility : String,
) -> Int {
  let mut count = 0
  for building in owned_buildings(projection) {
    if building.visibility == visibility {
      count += 1
    }
  }
  count
}

///|
fn count_shared_buildings(projection : MiniTownProjection) -> Int {
  let mut count = 0
  for building in projection.buildings {
    if building.owner_id == projection.organization_id {
      count += 1
    }
  }
  count
}
