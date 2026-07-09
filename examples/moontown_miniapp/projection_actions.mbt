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
