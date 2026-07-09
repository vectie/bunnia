///|
pub fn search_results(
  projection : MiniTownProjection,
) -> Array[MiniTownBuilding] {
  let visible = visible_buildings(projection)
  let output : Array[MiniTownBuilding] = []
  for building in visible {
    if building.visibility == "published" &&
      mini_town_search_match(projection.search_query, building) {
      output.push(building)
    }
  }
  output
}

///|
pub fn unified_discovery_results(
  projection : MiniTownProjection,
) -> Array[MiniTownDiscoveryItem] {
  let output : Array[MiniTownDiscoveryItem] = []
  for building in search_results(projection) {
    output.push(
      mini_town_discovery_item(
        id="building-\{building.id}",
        kind="building",
        title=building.title,
        summary=building.summary,
        target_ref="building:\{building.id}",
        visibility=building.visibility,
        status=building.status,
      ),
    )
  }
  for book in visible_books(projection) {
    if book.visibility == "published" &&
      mini_town_book_match(projection.search_query, book) {
      output.push(
        mini_town_discovery_item(
          id="book-\{book.id}",
          kind="book",
          title=book.title,
          summary=book.summary,
          target_ref="book:\{book.id}",
          visibility=book.visibility,
          status=book.status,
        ),
      )
    }
  }
  for item in projection.discovery_items {
    if mini_town_discovery_visible_for(projection, item) &&
      mini_town_discovery_match(projection.search_query, item) {
      output.push(item)
    }
  }
  output
}

///|
pub fn filtered_discovery_results(
  projection : MiniTownProjection,
) -> Array[MiniTownDiscoveryItem] {
  let output : Array[MiniTownDiscoveryItem] = []
  let filter = selected_discovery_filter(projection)
  for item in unified_discovery_results(projection) {
    if mini_town_discovery_filter_match(projection, filter, item) {
      output.push(item)
    }
  }
  output
}

///|
pub fn discovery_results_by_kind(
  projection : MiniTownProjection,
  kind : String,
) -> Array[MiniTownDiscoveryItem] {
  let output : Array[MiniTownDiscoveryItem] = []
  for item in unified_discovery_results(projection) {
    if item.kind == kind {
      output.push(item)
    }
  }
  output
}

///|
pub fn market_discovery_results(
  projection : MiniTownProjection,
) -> Array[MiniTownDiscoveryItem] {
  let output : Array[MiniTownDiscoveryItem] = []
  for item in unified_discovery_results(projection) {
    if item.kind == "product" ||
      item.kind == "demand" ||
      item.kind == "event" ||
      item.kind == "post" {
      output.push(item)
    }
  }
  output
}

///|
pub fn selected_discovery_filter(
  projection : MiniTownProjection,
) -> MiniTownDiscoveryFilter {
  for item in projection.discovery_filters {
    if item.id == projection.active_discovery_filter_id {
      return item
    }
  }
  mini_town_discovery_filter(id="all", label="All", kind="all")
}

///|
fn mini_town_discovery_filter_match(
  projection : MiniTownProjection,
  filter : MiniTownDiscoveryFilter,
  item : MiniTownDiscoveryItem,
) -> Bool {
  let kind_match = filter.kind == "all" || filter.kind == item.kind
  let placeable_match = !filter.placeable_only ||
    (
      item.kind == "building" &&
      item.visibility == "published" &&
      placement_for_building(
        projection,
        mini_town_discovery_item_building_id(item),
      )
      is None
    )
  kind_match && placeable_match
}

///|
fn mini_town_discovery_item_building_id(item : MiniTownDiscoveryItem) -> String {
  if item.target_ref.has_prefix("building:") {
    item.target_ref.sub(start=9, end=item.target_ref.length()).to_owned()
  } else {
    item.id
  }
}

///|
pub fn town_activity_items(
  projection : MiniTownProjection,
) -> Array[MiniTownActivityItem] {
  let output : Array[MiniTownActivityItem] = []
  for item in projection.activity_items {
    if mini_town_activity_visible_for(projection, item) {
      output.push(item)
    }
  }
  output
}

///|
pub fn visible_audit_events(
  projection : MiniTownProjection,
) -> Array[MiniTownAuditEvent] {
  let output : Array[MiniTownAuditEvent] = []
  for item in projection.audit_events {
    if mini_town_audit_visible_for(projection, item) {
      output.push(item)
    }
  }
  output
}

///|
pub fn selected_building_audit_events(
  projection : MiniTownProjection,
) -> Array[MiniTownAuditEvent] {
  let output : Array[MiniTownAuditEvent] = []
  for item in visible_audit_events(projection) {
    if item.building_id == projection.selected_building_id {
      output.push(item)
    }
  }
  output
}

///|
pub fn selected_building_moderation_cases(
  projection : MiniTownProjection,
) -> Array[MiniTownModerationCase] {
  let output : Array[MiniTownModerationCase] = []
  for item in projection.moderation_cases {
    if item.building_id == projection.selected_building_id {
      output.push(item)
    }
  }
  output
}

///|
pub fn owned_audit_events(
  projection : MiniTownProjection,
) -> Array[MiniTownAuditEvent] {
  let output : Array[MiniTownAuditEvent] = []
  for item in visible_audit_events(projection) {
    if item.actor_id == projection.active_user_id ||
      audit_event_attached_to_owned_building(projection, item) {
      output.push(item)
    }
  }
  output
}

///|
pub fn active_runs(projection : MiniTownProjection) -> Array[MiniTownRun] {
  let output : Array[MiniTownRun] = []
  for run in visible_runs(projection) {
    if run.status == "running" ||
      run.status == "review" ||
      run.status == "failed" ||
      run.status == "rejected" ||
      run.status == "cancelled" {
      output.push(run)
    }
  }
  output
}

///|
pub fn review_runs(projection : MiniTownProjection) -> Array[MiniTownRun] {
  let output : Array[MiniTownRun] = []
  for run in visible_runs(projection) {
    if run.review_required || run.status == "review" {
      output.push(run)
    }
  }
  output
}

///|
pub fn run_actions(run : MiniTownRun) -> Array[MiniTownRunAction] {
  let reviewable = run.review_required &&
    (run.status == "review" || run.status == "waiting-review")
  let cancellable = run.status == "running"
  let retryable = run.status == "failed" ||
    run.status == "rejected" ||
    run.status == "cancelled"
  [
    mini_town_run_action(
      id="open-building",
      label="Open",
      message="select-\{run.building_id}",
      target_ref="building:\{run.building_id}",
      allowed=true,
      reason="building context",
      status="ready",
    ),
    mini_town_run_action(
      id="review-accept",
      label="Accept",
      message="accept-memory-review",
      target_ref=run.artifact_ref,
      allowed=reviewable,
      reason=if reviewable { "review required" } else { "not waiting review" },
      status=if reviewable { "ready" } else { "blocked" },
    ),
    mini_town_run_action(
      id="review-reject",
      label="Reject",
      message="reject-memory-review",
      target_ref=run.artifact_ref,
      allowed=reviewable,
      reason=if reviewable { "review required" } else { "not waiting review" },
      status=if reviewable { "ready" } else { "blocked" },
    ),
    mini_town_run_action(
      id="cancel",
      label="Cancel",
      message="cancel-run",
      target_ref="run:\{run.id}",
      allowed=cancellable,
      reason=if cancellable { "running run" } else { "not running" },
      status=if cancellable { "ready" } else { "blocked" },
    ),
    mini_town_run_action(
      id="retry",
      label="Retry",
      message="retry-run",
      target_ref="run:\{run.id}",
      allowed=retryable,
      reason=if retryable { "run can be retried" } else { "wait for status" },
      status=if retryable { "ready" } else { "blocked" },
    ),
  ]
}

///|
pub fn pending_reviews(
  projection : MiniTownProjection,
) -> Array[MiniTownReviewItem] {
  let output : Array[MiniTownReviewItem] = []
  for item in visible_reviews(projection) {
    if item.status == "pending" {
      output.push(item)
    }
  }
  output
}

///|
pub fn home_town_stats(
  projection : MiniTownProjection,
) -> Array[MiniTownOwnershipStat] {
  [
    mini_town_ownership_stat(
      id="visible-buildings",
      label="visible buildings",
      value=visible_buildings(projection).length(),
    ),
    mini_town_ownership_stat(
      id="agents",
      label="active agents",
      value=projection.agents.length(),
    ),
    mini_town_ownership_stat(
      id="unread",
      label="unread events",
      value=unread_notifications(projection).length(),
    ),
    mini_town_ownership_stat(
      id="pulse",
      label="town pulse",
      value=town_activity_items(projection).length(),
    ),
    mini_town_ownership_stat(
      id="placements",
      label="placed",
      value=visible_placements(projection).length(),
    ),
  ]
}

///|
pub fn community_presence(
  projection : MiniTownProjection,
) -> Array[MiniTownPresence] {
  let output : Array[MiniTownPresence] = []
  for item in projection.presence {
    if mini_town_presence_visible_for(projection, item) {
      output.push(item)
    }
  }
  output
}

///|
fn mini_town_presence_visible_for(
  projection : MiniTownProjection,
  item : MiniTownPresence,
) -> Bool {
  for building in visible_buildings(projection) {
    if building.id == item.building_id {
      return true
    }
  }
  false
}

///|
fn mini_town_activity_visible_for(
  projection : MiniTownProjection,
  item : MiniTownActivityItem,
) -> Bool {
  for building in visible_buildings(projection) {
    if building.id == item.building_id {
      return true
    }
  }
  false
}

///|
fn mini_town_audit_visible_for(
  projection : MiniTownProjection,
  item : MiniTownAuditEvent,
) -> Bool {
  item.visibility == "published" ||
  item.actor_id == projection.active_user_id ||
  (item.visibility == "shared_private" && projection.organization_id != "")
}

///|
fn audit_event_attached_to_owned_building(
  projection : MiniTownProjection,
  item : MiniTownAuditEvent,
) -> Bool {
  for building in owned_buildings(projection) {
    if building.id == item.building_id {
      return true
    }
  }
  false
}

///|
fn mini_town_discovery_visible_for(
  projection : MiniTownProjection,
  item : MiniTownDiscoveryItem,
) -> Bool {
  item.visibility == "published" ||
  item.visibility == "system_public" ||
  item.visibility == "personal" ||
  (item.visibility == "shared_private" && projection.organization_id != "")
}

///|
fn mini_town_discovery_match(
  query : String,
  item : MiniTownDiscoveryItem,
) -> Bool {
  query == "" ||
  item.kind.contains(query) ||
  item.title.contains(query) ||
  item.summary.contains(query)
}

///|
fn mini_town_search_match(query : String, building : MiniTownBuilding) -> Bool {
  if query == "" {
    true
  } else if building.title.contains(query) || building.summary.contains(query) {
    true
  } else {
    building.tags.contains(query)
  }
}

///|
fn mini_town_book_match(query : String, book : MiniTownBook) -> Bool {
  query == "" ||
  book.title.contains(query) ||
  book.summary.contains(query) ||
  book.status.contains(query)
}
