///|
pub fn visible_buildings(
  projection : MiniTownProjection,
) -> Array[MiniTownBuilding] {
  let output : Array[MiniTownBuilding] = []
  for building in projection.buildings {
    if mini_town_building_visible_for(projection, building) {
      output.push(building)
    }
  }
  output
}

///|
pub fn visible_books(projection : MiniTownProjection) -> Array[MiniTownBook] {
  let output : Array[MiniTownBook] = []
  for book in projection.books {
    if mini_town_book_visible_for(projection, book) {
      output.push(book)
    }
  }
  output
}

///|
pub fn visible_runs(projection : MiniTownProjection) -> Array[MiniTownRun] {
  let output : Array[MiniTownRun] = []
  for run in projection.runs {
    if mini_town_run_visible_for(projection, run) {
      output.push(run)
    }
  }
  output
}

///|
pub fn visible_tool_results(
  projection : MiniTownProjection,
) -> Array[MiniTownToolResult] {
  let output : Array[MiniTownToolResult] = []
  for item in projection.tool_results {
    if mini_town_tool_result_visible_for(projection, item) {
      output.push(item)
    }
  }
  output
}

///|
pub fn tool_result_cards(
  projection : MiniTownProjection,
) -> Array[@bunnia.ToolResultCard] {
  let output : Array[@bunnia.ToolResultCard] = []
  for item in visible_tool_results(projection) {
    output.push(
      @bunnia.tool_result_card(
        id=item.id,
        tool_name=item.tool_name,
        title=item.title,
        summary=item.summary,
        artifact_ref=item.artifact_ref,
        status=item.status,
        open_message=item.open_message,
        acknowledge_message=item.acknowledge_message,
      ),
    )
  }
  output
}

///|
pub fn visible_reviews(
  projection : MiniTownProjection,
) -> Array[MiniTownReviewItem] {
  let output : Array[MiniTownReviewItem] = []
  for item in projection.reviews {
    if mini_town_review_visible_for(projection, item) {
      output.push(item)
    }
  }
  output
}

///|
fn mini_town_building_visible_for(
  projection : MiniTownProjection,
  building : MiniTownBuilding,
) -> Bool {
  building.visibility != "archived" &&
  (
    building.visibility == "published" ||
    building.owner_id == projection.active_user_id ||
    building.owner_id == projection.organization_id
  )
}

///|
fn mini_town_book_visible_for(
  projection : MiniTownProjection,
  book : MiniTownBook,
) -> Bool {
  book.visibility == "published" ||
  book.owner_id == projection.active_user_id ||
  book.owner_id == projection.organization_id ||
  mini_town_book_building_visible_for(projection, book)
}

///|
fn mini_town_book_building_visible_for(
  projection : MiniTownProjection,
  book : MiniTownBook,
) -> Bool {
  for building in visible_buildings(projection) {
    if building.id == book.building_id {
      return true
    }
  }
  false
}

///|
fn mini_town_review_visible_for(
  projection : MiniTownProjection,
  item : MiniTownReviewItem,
) -> Bool {
  item.reviewer_id == projection.active_user_id &&
  (
    mini_town_review_run_visible_for(projection, item) ||
    mini_town_review_building_visible_for(projection, item)
  )
}

///|
fn mini_town_review_run_visible_for(
  projection : MiniTownProjection,
  item : MiniTownReviewItem,
) -> Bool {
  for run in visible_runs(projection) {
    if run.id == item.run_id {
      return true
    }
  }
  false
}

///|
fn mini_town_review_building_visible_for(
  projection : MiniTownProjection,
  item : MiniTownReviewItem,
) -> Bool {
  for building in visible_buildings(projection) {
    if building.id == item.building_id {
      return true
    }
  }
  false
}

///|
fn mini_town_run_visible_for(
  projection : MiniTownProjection,
  run : MiniTownRun,
) -> Bool {
  mini_town_run_building_visible_for(projection, run) &&
  mini_town_run_book_visible_for(projection, run)
}

///|
fn mini_town_tool_result_visible_for(
  projection : MiniTownProjection,
  item : MiniTownToolResult,
) -> Bool {
  for building in projection.buildings {
    if building.id == item.building_id {
      return mini_town_building_visible_for(projection, building)
    }
  }
  false
}

///|
fn mini_town_run_building_visible_for(
  projection : MiniTownProjection,
  run : MiniTownRun,
) -> Bool {
  for building in visible_buildings(projection) {
    if building.id == run.building_id {
      return true
    }
  }
  false
}

///|
fn mini_town_run_book_visible_for(
  projection : MiniTownProjection,
  run : MiniTownRun,
) -> Bool {
  if run.book_id == "" {
    true
  } else {
    for book in visible_books(projection) {
      if book.id == run.book_id {
        return true
      }
    }
    false
  }
}

///|
fn mini_town_message_visible_for(
  projection : MiniTownProjection,
  message : MiniTownMessage,
) -> Bool {
  let building_id = mini_town_building_id_from_thread(message.thread_id)
  for building in visible_buildings(projection) {
    if building.id == building_id {
      return true
    }
  }
  false
}

///|
fn mini_town_building_id_from_thread(thread_id : String) -> String {
  thread_id.replace_all(old="thread-", new="")
}

///|
pub fn selected_building(projection : MiniTownProjection) -> MiniTownBuilding {
  for building in projection.buildings {
    if building.id == projection.selected_building_id {
      return building
    }
  }
  projection.buildings[0]
}

///|
pub fn selected_building_book(projection : MiniTownProjection) -> MiniTownBook {
  let selected = selected_building(projection)
  for book in visible_books(projection) {
    if book.building_id == selected.id {
      return book
    }
  }
  projection.books[0]
}

///|
pub fn selected_building_runs(
  projection : MiniTownProjection,
) -> Array[MiniTownRun] {
  let selected = selected_building(projection)
  let output : Array[MiniTownRun] = []
  for run in visible_runs(projection) {
    if run.building_id == selected.id {
      output.push(run)
    }
  }
  output
}

///|
pub fn selected_building_agents(
  projection : MiniTownProjection,
) -> Array[MiniTownAgent] {
  let selected = selected_building(projection)
  let output : Array[MiniTownAgent] = []
  for agent in projection.agents {
    if agent.building_id == selected.id {
      output.push(agent)
    }
  }
  output
}

///|
pub fn visible_messages(
  projection : MiniTownProjection,
) -> Array[MiniTownMessage] {
  let output : Array[MiniTownMessage] = []
  for message in projection.messages {
    if mini_town_message_visible_for(projection, message) {
      output.push(message)
    }
  }
  output
}

///|
pub fn selected_building_messages(
  projection : MiniTownProjection,
) -> Array[MiniTownMessage] {
  let selected = selected_building(projection)
  let thread_id = "thread-\{selected.id}"
  let output : Array[MiniTownMessage] = []
  for message in visible_messages(projection) {
    if message.thread_id == thread_id {
      output.push(message)
    }
  }
  output
}

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
pub fn publication_steps(
  projection : MiniTownProjection,
) -> Array[MiniTownPublicationStep] {
  let building = publication_subject_building(projection)
  let private_ready = building.visibility == "private_draft" &&
    is_owned_by_active_user(projection, building)
  let shared_ready = building.visibility == "shared_private" &&
    is_owned_by_active_user(projection, building) &&
    profile_ready_to_publish(projection)
  let submitted = building.visibility == "submitted"
  [
    mini_town_publication_step(
      id="draft",
      label="Private Draft",
      summary=if building.visibility == "private_draft" {
        "Owner can edit and prepare the building book."
      } else {
        "Initial private owner workspace is complete."
      },
      current=building.visibility == "private_draft",
      complete=building.visibility != "private_draft",
      blocked=!is_owned_by_active_user(projection, building),
    ),
    mini_town_publication_step(
      id="share",
      label="Team Share",
      summary=if private_ready {
        "Share privately with invited or organization members."
      } else if building.visibility == "shared_private" {
        "Visible to the team before public publication."
      } else {
        lifecycle_share_reason(projection, building)
      },
      current=building.visibility == "shared_private",
      complete=building.visibility == "submitted" ||
        building.visibility == "published" ||
        building.visibility == "archived",
      blocked=!private_ready && building.visibility == "private_draft",
    ),
    mini_town_publication_step(
      id="review",
      label="Publish Review",
      summary=if shared_ready {
        "Ready to submit into town publication review."
      } else if submitted {
        "Submitted and waiting for publication decision."
      } else {
        lifecycle_publish_reason(projection, building)
      },
      current=submitted,
      complete=building.visibility == "published" ||
        building.visibility == "archived",
      blocked=building.visibility == "shared_private" &&
        !profile_ready_to_publish(projection),
    ),
    mini_town_publication_step(
      id="approve",
      label="Review Decision",
      summary=if submitted {
        "A reviewer can publish or reject before public discovery."
      } else if building.visibility == "published" {
        "Publication review accepted."
      } else {
        "Submit before a reviewer can decide."
      },
      current=submitted,
      complete=building.visibility == "published" ||
        building.visibility == "archived",
      blocked=!submitted && building.visibility != "published",
    ),
    mini_town_publication_step(
      id="published",
      label="Town Published",
      summary=if building.visibility == "published" {
        "Searchable and placeable by allowed users."
      } else {
        "Not yet visible in public discovery."
      },
      current=building.visibility == "published",
      complete=building.visibility == "published" ||
        building.visibility == "archived",
      blocked=false,
    ),
    mini_town_publication_step(
      id="archive",
      label="Archive",
      summary=if building.visibility == "archived" {
        "Hidden from normal map and discovery surfaces; owner can restore to draft."
      } else {
        lifecycle_archive_reason(projection, building)
      },
      current=building.visibility == "archived",
      complete=building.visibility == "archived",
      blocked=building.visibility == "archived" &&
        !is_owned_by_active_user(projection, building),
    ),
  ]
}

///|
fn publication_subject_building(
  projection : MiniTownProjection,
) -> MiniTownBuilding {
  let selected = selected_building(projection)
  if is_owned_by_active_user(projection, selected) {
    selected
  } else {
    let owned = owned_buildings(projection)
    if owned.length() > 0 {
      owned[0]
    } else {
      selected
    }
  }
}

///|
fn is_owned_by_active_user(
  projection : MiniTownProjection,
  building : MiniTownBuilding,
) -> Bool {
  building.owner_id == projection.active_user_id
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

///|
pub fn selected_agent(projection : MiniTownProjection) -> MiniTownAgent {
  let selected = selected_building(projection)
  for agent in projection.agents {
    if agent.building_id == selected.id {
      return agent
    }
  }
  projection.agents[0]
}

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

///|
pub fn switch_mock_user(
  projection : MiniTownProjection,
  user_id : String,
) -> MiniTownProjection {
  let next = { ..projection, active_user_id: user_id }
  let visible = visible_buildings(next)
  if visible.length() == 0 {
    next
  } else {
    { ..next, selected_building_id: visible[0].id }
  }
}

///|
pub fn switch_tab(
  projection : MiniTownProjection,
  tab_id : String,
) -> MiniTownProjection {
  { ..projection, active_tab_id: tab_id }
}

///|
pub fn switch_discovery_filter(
  projection : MiniTownProjection,
  filter_id : String,
) -> MiniTownProjection {
  { ..projection, active_discovery_filter_id: filter_id }
}

///|
pub fn search_discovery(
  projection : MiniTownProjection,
  query : String,
) -> MiniTownProjection {
  { ..projection, search_query: query }
}

///|
pub fn switch_notification_channel(
  projection : MiniTownProjection,
  channel_id : String,
) -> MiniTownProjection {
  { ..projection, active_notification_channel_id: channel_id }
}

///|
pub fn complete_onboarding(
  projection : MiniTownProjection,
) -> MiniTownProjection {
  { ..projection, onboarding_completed: true }
}

///|
pub fn select_role(
  projection : MiniTownProjection,
  role_id : String,
) -> MiniTownProjection {
  { ..projection, role_id, profile: { ..projection.profile, role_id, } }
}

///|
pub fn accept_profile_consent(
  projection : MiniTownProjection,
) -> MiniTownProjection {
  { ..projection, profile: { ..projection.profile, consent_accepted: true } }
}

///|
pub fn complete_profile_setup(
  projection : MiniTownProjection,
) -> MiniTownProjection {
  { ..projection, profile: { ..projection.profile, setup_completed: true } }
}

///|
pub fn profile_ready_to_publish(projection : MiniTownProjection) -> Bool {
  projection.profile.setup_completed &&
  projection.profile.consent_accepted &&
  projection.profile.role_id != ""
}

///|
pub fn open_reviewer_tools(
  projection : MiniTownProjection,
) -> MiniTownProjection {
  { ..projection, reviewer_tools_open: true }
}

///|
pub fn close_reviewer_tools(
  projection : MiniTownProjection,
) -> MiniTownProjection {
  { ..projection, reviewer_tools_open: false }
}

///|
pub fn setup_gates(projection : MiniTownProjection) -> Array[MiniTownSetupGate] {
  [
    mini_town_setup_gate(
      id="session",
      label="Town Entry",
      summary=if projection.active_user_id == "" {
        "Enter town before private places and agent work can belong to you."
      } else {
        "Entered as \{projection.profile.display_name}."
      },
      action_label="Enter",
      action_message="dev-login",
      complete=projection.active_user_id != "",
    ),
    mini_town_setup_gate(
      id="onboarding",
      label="Town Intro",
      summary=if projection.onboarding_completed {
        "Realm intro is complete."
      } else {
        "Read the tile-town intro before entering public workflows."
      },
      action_label="Enter Realm",
      action_message="complete-onboarding",
      complete=projection.onboarding_completed,
    ),
    mini_town_setup_gate(
      id="role",
      label="Town Role",
      summary=if projection.profile.role_id == "" {
        "Choose how you show up in town."
      } else {
        "Role selected: \{town_profile_role_label(projection.profile.role_id)}."
      },
      action_label="Choose Role",
      action_message="select-role-builder",
      complete=projection.profile.role_id != "",
    ),
    mini_town_setup_gate(
      id="consent",
      label="Town Consent",
      summary=if projection.profile.consent_accepted {
        "Consent accepted for publishing and sharing."
      } else {
        "Accept consent before publishing or sharing town content."
      },
      action_label="Accept Consent",
      action_message="accept-profile-consent",
      complete=projection.profile.consent_accepted,
    ),
    mini_town_setup_gate(
      id="profile",
      label="Profile Details",
      summary=if projection.profile.setup_completed {
        "Profile setup is complete."
      } else {
        "Save profile details before public building actions."
      },
      action_label="Finish Profile",
      action_message="save-profile",
      complete=projection.profile.setup_completed,
    ),
    mini_town_setup_gate(
      id="publish-ready",
      label="Ready to Publish",
      summary=if profile_ready_to_publish(projection) {
        "Drafts can be submitted, shared, and published."
      } else {
        "Publishing stays blocked until role, consent, and profile are ready."
      },
      action_label=if profile_ready_to_publish(projection) {
        "Open Inventory"
      } else {
        "Finish Profile"
      },
      action_message="tab-my",
      complete=profile_ready_to_publish(projection),
    ),
  ]
}

///|
fn town_profile_role_label(role_id : String) -> String {
  if role_id == "builder" {
    "Builder"
  } else if role_id == "reviewer" {
    "Reviewer"
  } else if role_id == "walker" {
    "Walker"
  } else if role_id == "owner" {
    "Owner"
  } else {
    "Town member"
  }
}

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
fn update_selected_building_lifecycle(
  projection : MiniTownProjection,
  visibility~ : String,
  status~ : String,
  kind~ : String,
  title~ : String,
  summary~ : String,
) -> MiniTownProjection {
  let selected_id = projection.selected_building_id
  {
    ..projection,
    buildings: update_building_lifecycle(
      projection.buildings,
      selected_id,
      visibility,
      status,
    ),
    books: update_book_lifecycle(
      projection.books,
      selected_id,
      visibility,
      status,
    ),
    audit_events: projection.audit_events +
    [
      lifecycle_event(
        id="audit-\{kind}-\{selected_id}",
        kind~,
        title~,
        summary~,
        actor_id=projection.active_user_id,
        building_id=selected_id,
        status~,
        visibility~,
      ),
    ],
  }
}

///|
fn update_building_lifecycle(
  buildings : Array[MiniTownBuilding],
  building_id : String,
  visibility : String,
  status : String,
) -> Array[MiniTownBuilding] {
  let output : Array[MiniTownBuilding] = []
  for building in buildings {
    if building.id == building_id {
      output.push({ ..building, visibility, status })
    } else {
      output.push(building)
    }
  }
  output
}

///|
fn update_book_lifecycle(
  books : Array[MiniTownBook],
  building_id : String,
  visibility : String,
  status : String,
) -> Array[MiniTownBook] {
  let output : Array[MiniTownBook] = []
  for book in books {
    if book.building_id == building_id {
      output.push({ ..book, visibility, status })
    } else {
      output.push(book)
    }
  }
  output
}

///|
fn update_building_profile(
  buildings : Array[MiniTownBuilding],
  building_id : String,
  title : String,
  summary : String,
  tags : Array[String],
) -> Array[MiniTownBuilding] {
  let output : Array[MiniTownBuilding] = []
  for building in buildings {
    if building.id == building_id {
      output.push({ ..building, title, summary, tags })
    } else {
      output.push(building)
    }
  }
  output
}

///|
fn update_book_profile(
  books : Array[MiniTownBook],
  building_id : String,
  title : String,
  summary : String,
) -> Array[MiniTownBook] {
  let output : Array[MiniTownBook] = []
  for book in books {
    if book.building_id == building_id {
      output.push({ ..book, title, summary })
    } else {
      output.push(book)
    }
  }
  output
}

///|
fn update_book_lifecycle_with_review_delta(
  books : Array[MiniTownBook],
  building_id : String,
  visibility : String,
  status : String,
  review_delta : Int,
) -> Array[MiniTownBook] {
  let output : Array[MiniTownBook] = []
  for book in books {
    if book.building_id == building_id {
      output.push({
        ..book,
        visibility,
        status,
        pending_review_count: clamp_pending_review(
          book.pending_review_count + review_delta,
        ),
      })
    } else {
      output.push(book)
    }
  }
  output
}

///|
fn decrement_book_pending_review(
  books : Array[MiniTownBook],
  book_id : String,
) -> Array[MiniTownBook] {
  let output : Array[MiniTownBook] = []
  for book in books {
    if book.id == book_id {
      output.push({
        ..book,
        pending_review_count: clamp_pending_review(
          book.pending_review_count - 1,
        ),
      })
    } else {
      output.push(book)
    }
  }
  output
}

///|
fn clamp_pending_review(value : Int) -> Int {
  if value < 0 {
    0
  } else {
    value
  }
}

///|
fn lifecycle_event(
  id~ : String,
  kind~ : String,
  title~ : String,
  summary~ : String,
  actor_id~ : String,
  building_id~ : String,
  status~ : String,
  visibility~ : String,
) -> MiniTownAuditEvent {
  mini_town_audit_event(
    id~,
    kind~,
    title~,
    summary~,
    actor_id~,
    target_ref="building:\{building_id}",
    building_id~,
    status~,
    visibility~,
    timestamp="local-dev",
  )
}

///|
pub fn create_agent_for_selected(
  projection : MiniTownProjection,
  id : String,
  name : String,
) -> MiniTownProjection {
  let building = selected_building(projection)
  let agent = mini_town_agent(
    id~,
    name~,
    building_id=building.id,
    status="idle",
  )
  let message = mini_town_message(
    id="msg-agent-\{id}",
    actor_id=id,
    thread_id="thread-\{building.id}",
    text="\{name} is ready inside \{building.title}.",
  )
  {
    ..projection,
    agents: projection.agents + [agent],
    messages: projection.messages + [message],
    audit_events: projection.audit_events +
    [
      lifecycle_event(
        id="audit-agent-\{id}",
        kind="agent-create",
        title="\{name} created",
        summary="Agent is attached to \{building.title} and can join building threads.",
        actor_id=projection.active_user_id,
        building_id=building.id,
        status="idle",
        visibility=building.visibility,
      ),
    ],
  }
}

///|
pub fn handoff_selected_building_agent(
  projection : MiniTownProjection,
  from_agent_id : String,
  to_agent_id : String,
  summary : String,
) -> MiniTownProjection {
  let building = selected_building(projection)
  let book = selected_building_book(projection)
  let from_agent_name = agent_name(projection, from_agent_id)
  let to_agent_name = agent_name(projection, to_agent_id)
  let run_id = "run-handoff-\{from_agent_id}-\{to_agent_id}"
  let message = mini_town_message(
    id="msg-handoff-\{from_agent_id}-\{to_agent_id}",
    actor_id=from_agent_id,
    thread_id="thread-\{building.id}",
    text="\{from_agent_name} handed work to \{to_agent_name}: \{summary}",
    status=@bunnia.run_running(),
  )
  let run = mini_town_run(
    id=run_id,
    agent_id=to_agent_id,
    building_id=building.id,
    book_id=book.id,
    thread_id="thread-\{building.id}",
    title="\{to_agent_name} handoff",
    summary~,
    status="running",
    artifact_ref="handoff://\{from_agent_id}/\{to_agent_id}/\{building.id}",
  )
  let notice = mini_town_notification(
    id="notice-handoff-\{from_agent_id}-\{to_agent_id}",
    kind="handoff",
    title="Agent handoff started",
    body="\{from_agent_name} moved work to \{to_agent_name} inside \{building.title}.",
    target_ref="run:\{run_id}",
    building_id=building.id,
    action_label="Open Handoff",
    action_message="open-notice-handoff",
  )
  {
    ..projection,
    messages: projection.messages + [message],
    runs: projection.runs + [run],
    notifications: projection.notifications + [notice],
    audit_events: projection.audit_events +
    [
      mini_town_audit_event(
        id="audit-handoff-\{from_agent_id}-\{to_agent_id}",
        kind="handoff",
        title="\{from_agent_name} handed off work",
        summary="\{to_agent_name} received work in \{building.title}.",
        actor_id=from_agent_id,
        target_ref="run:\{run_id}",
        building_id=building.id,
        status="running",
        visibility=building.visibility,
        timestamp="local-dev",
      ),
    ],
  }
}

///|
fn agent_name(projection : MiniTownProjection, agent_id : String) -> String {
  for agent in projection.agents {
    if agent.id == agent_id {
      return agent.name
    }
  }
  agent_id
}

///|
pub fn acknowledge_tool_result(
  projection : MiniTownProjection,
  tool_result_id : String,
) -> MiniTownProjection {
  let mut building_id = projection.selected_building_id
  let mut title = tool_result_id
  for item in projection.tool_results {
    if item.id == tool_result_id {
      building_id = item.building_id
      title = item.title
    }
  }
  {
    ..projection,
    tool_results: update_tool_result_status(
      projection.tool_results,
      tool_result_id,
      @bunnia.run_done(),
    ),
    audit_events: projection.audit_events +
    [
      mini_town_audit_event(
        id="audit-tool-ack-\{tool_result_id}",
        kind="tool-result-ack",
        title="\{title} acknowledged",
        summary="Tool result was reviewed and cleared from the pending agent queue.",
        actor_id=projection.active_user_id,
        target_ref="tool-result:\{tool_result_id}",
        building_id~,
        status="done",
        visibility=selected_tool_result_visibility(projection, building_id),
        timestamp="local-dev",
      ),
    ],
  }
}

///|
fn update_tool_result_status(
  items : Array[MiniTownToolResult],
  tool_result_id : String,
  status : @bunnia.RunStatus,
) -> Array[MiniTownToolResult] {
  let output : Array[MiniTownToolResult] = []
  for item in items {
    if item.id == tool_result_id {
      output.push({ ..item, status, })
    } else {
      output.push(item)
    }
  }
  output
}

///|
fn selected_tool_result_visibility(
  projection : MiniTownProjection,
  building_id : String,
) -> String {
  for building in projection.buildings {
    if building.id == building_id {
      return building.visibility
    }
  }
  "private_draft"
}

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

///|
pub fn unread_notifications(
  projection : MiniTownProjection,
) -> Array[MiniTownNotification] {
  let output : Array[MiniTownNotification] = []
  for notice in visible_notifications(projection) {
    if notice.unread {
      output.push(notice)
    }
  }
  output
}

///|
pub fn subscription_notifications(
  projection : MiniTownProjection,
) -> Array[MiniTownNotification] {
  let output : Array[MiniTownNotification] = []
  for notice in visible_notifications(projection) {
    if notice.requires_subscription {
      output.push(notice)
    }
  }
  output
}

///|
pub fn visible_notifications(
  projection : MiniTownProjection,
) -> Array[MiniTownNotification] {
  let output : Array[MiniTownNotification] = []
  for notice in projection.notifications {
    if mini_town_notification_visible_for(projection, notice) {
      output.push(notice)
    }
  }
  output
}

///|
pub fn filtered_notifications(
  projection : MiniTownProjection,
) -> Array[MiniTownNotification] {
  let channel = selected_notification_channel(projection)
  let output : Array[MiniTownNotification] = []
  for notice in visible_notifications(projection) {
    if mini_town_notification_channel_match(channel, notice) {
      output.push(notice)
    }
  }
  output
}

///|
pub fn selected_notification_channel(
  projection : MiniTownProjection,
) -> MiniTownNotificationChannel {
  for item in projection.notification_channels {
    if item.id == projection.active_notification_channel_id {
      return item
    }
  }
  mini_town_notification_channel(id="all", label="All", kind="all")
}

///|
fn mini_town_notification_channel_match(
  channel : MiniTownNotificationChannel,
  notice : MiniTownNotification,
) -> Bool {
  let kind_match = channel.kind == "all" || channel.kind == notice.kind
  let unread_match = !channel.unread_only || notice.unread
  kind_match && unread_match
}

///|
fn mini_town_notification_visible_for(
  projection : MiniTownProjection,
  notice : MiniTownNotification,
) -> Bool {
  if notice.building_id == "" {
    return true
  }
  for building in visible_buildings(projection) {
    if building.id == notice.building_id {
      return true
    }
  }
  false
}
