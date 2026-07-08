///|
pub struct MiniTownUser {
  id : String
  name : String
} derive(Debug, Eq)

///|
pub struct MiniTownProfile {
  user_id : String
  display_name : String
  role_id : String
  avatar_ref : String
  consent_accepted : Bool
  setup_completed : Bool
} derive(Debug, Eq)

///|
pub struct MiniTownRole {
  id : String
  title : String
  summary : String
  building_id : String
} derive(Debug, Eq)

///|
pub struct MiniTownBuilding {
  id : String
  title : String
  kind : String
  visibility : String
  owner_id : String
  summary : String
  tags : Array[String]
  x : Int
  y : Int
  status : String
  asset_ref : String
} derive(Debug, Eq)

///|
pub struct MiniTownBook {
  id : String
  building_id : String
  title : String
  owner_id : String
  visibility : String
  summary : String
  accepted_memory_count : Int
  pending_review_count : Int
  status : String
} derive(Debug, Eq)

///|
pub struct MiniTownAgent {
  id : String
  name : String
  building_id : String
  status : String
} derive(Debug, Eq)

///|
pub struct MiniTownMessage {
  id : String
  actor_id : String
  thread_id : String
  text : String
  status : @bunnia.RunStatus
} derive(Debug, Eq)

///|
pub struct MiniTownRun {
  id : String
  agent_id : String
  building_id : String
  book_id : String
  thread_id : String
  title : String
  summary : String
  status : String
  review_required : Bool
  artifact_ref : String
} derive(Debug, Eq)

///|
pub struct MiniTownToolResult {
  id : String
  tool_name : String
  building_id : String
  thread_id : String
  title : String
  summary : String
  artifact_ref : String
  status : @bunnia.RunStatus
  open_message : String
  acknowledge_message : String
} derive(Debug, Eq)

///|
pub struct MiniTownReviewItem {
  id : String
  run_id : String
  building_id : String
  book_id : String
  title : String
  summary : String
  artifact_ref : String
  reviewer_id : String
  status : String
  accepted_memory_delta : Int
  accept_message : String
  reject_message : String
} derive(Debug, Eq)

///|
pub struct MiniTownRunAction {
  id : String
  label : String
  message : String
  target_ref : String
  allowed : Bool
  reason : String
  status : String
} derive(Debug, Eq)

///|
pub struct MiniTownLifecycleAction {
  id : String
  label : String
  message : String
  target_ref : String
  book_id : String
  allowed : Bool
  reason : String
  status : String
} derive(Debug, Eq)

///|
pub struct MiniTownSetupGate {
  id : String
  label : String
  summary : String
  action_label : String
  action_message : String
  complete : Bool
  status : String
} derive(Debug, Eq)

///|
pub struct MiniTownPublicationStep {
  id : String
  label : String
  summary : String
  current : Bool
  complete : Bool
  blocked : Bool
  status : String
} derive(Debug, Eq)

///|
pub struct MiniTownTab {
  id : String
  label : String
  map_surface : Bool
} derive(Debug, Eq)

///|
pub struct MiniTownOnboardingStep {
  id : String
  title : String
  body : String
  building_id : String
} derive(Debug, Eq)

///|
pub struct MiniTownDistrict {
  id : String
  title : String
  feature_kind : String
  building_id : String
  summary : String
  stat_label : String
  stat_value : String
  action_label : String
  action_message : String
  discovery_filter_id : String
  search_query : String
  accent : String
  status : String
} derive(Debug, Eq)

///|
pub struct MiniTownPresence {
  id : String
  title : String
  subtitle : String
  actor_kind : String
  building_id : String
  status : String
} derive(Debug, Eq)

///|
pub struct MiniTownNotification {
  id : String
  kind : String
  title : String
  body : String
  target_ref : String
  building_id : String
  action_label : String
  action_message : String
  requires_subscription : Bool
  unread : Bool
} derive(Debug, Eq)

///|
pub struct MiniTownNotificationChannel {
  id : String
  label : String
  kind : String
  unread_only : Bool
} derive(Debug, Eq)

///|
pub struct MiniTownWatch {
  id : String
  user_id : String
  target_ref : String
  title : String
  summary : String
  status : String
  action_message : String
} derive(Debug, Eq)

///|
pub struct MiniTownDiscoveryItem {
  id : String
  kind : String
  title : String
  summary : String
  target_ref : String
  visibility : String
  status : String
} derive(Debug, Eq)

///|
pub struct MiniTownDiscoveryFilter {
  id : String
  label : String
  kind : String
  placeable_only : Bool
} derive(Debug, Eq)

///|
pub struct MiniTownActivityItem {
  id : String
  kind : String
  title : String
  summary : String
  actor_id : String
  target_ref : String
  building_id : String
  status : String
} derive(Debug, Eq)

///|
pub struct MiniTownAuditEvent {
  id : String
  kind : String
  title : String
  summary : String
  actor_id : String
  target_ref : String
  building_id : String
  status : String
  visibility : String
  timestamp : String
} derive(Debug, Eq)

///|
pub struct MiniTownModerationCase {
  id : String
  building_id : String
  reporter_id : String
  target_ref : String
  title : String
  summary : String
  status : String
  action_label : String
  action_message : String
} derive(Debug, Eq)

///|
pub struct MiniTownOwnershipStat {
  id : String
  label : String
  value : Int
} derive(Debug, Eq)

///|
pub struct MiniTownOwnershipItem {
  id : String
  kind : String
  title : String
  summary : String
  target_ref : String
  visibility : String
  status : String
  action_label : String
  action_message : String
} derive(Debug, Eq)

///|
pub struct MiniTownOwnershipFilter {
  id : String
  label : String
  kind : String
  visibility : String
} derive(Debug, Eq)

///|
pub struct MiniTownBackendStep {
  id : String
  label : String
  endpoint_id : String
  http_method : String
  path : String
  summary : String
  status : String
} derive(Debug, Eq)

///|
pub struct MiniTownBackendCacheState {
  id : String
  label : String
  source : String
  state : String
  summary : String
  target_ref : String
  action_label : String
  action_message : String
} derive(Debug, Eq)

///|
pub struct MiniTownProjection {
  id : String
  active_user_id : String
  organization_id : String
  active_tab_id : String
  onboarding_completed : Bool
  role_id : String
  selected_building_id : String
  search_query : String
  active_discovery_filter_id : String
  active_notification_channel_id : String
  active_ownership_filter_id : String
  users : Array[MiniTownUser]
  profile : MiniTownProfile
  roles : Array[MiniTownRole]
  tabs : Array[MiniTownTab]
  onboarding_steps : Array[MiniTownOnboardingStep]
  districts : Array[MiniTownDistrict]
  presence : Array[MiniTownPresence]
  buildings : Array[MiniTownBuilding]
  placements : Array[MiniTownPlacement]
  books : Array[MiniTownBook]
  agents : Array[MiniTownAgent]
  messages : Array[MiniTownMessage]
  runs : Array[MiniTownRun]
  tool_results : Array[MiniTownToolResult]
  reviews : Array[MiniTownReviewItem]
  notifications : Array[MiniTownNotification]
  notification_channels : Array[MiniTownNotificationChannel]
  watches : Array[MiniTownWatch]
  discovery_items : Array[MiniTownDiscoveryItem]
  discovery_filters : Array[MiniTownDiscoveryFilter]
  ownership_filters : Array[MiniTownOwnershipFilter]
  backend_steps : Array[MiniTownBackendStep]
  backend_cache_states : Array[MiniTownBackendCacheState]
  activity_items : Array[MiniTownActivityItem]
  audit_events : Array[MiniTownAuditEvent]
  moderation_cases : Array[MiniTownModerationCase]
} derive(Debug, Eq)

///|
pub fn mini_town_user(id~ : String, name~ : String) -> MiniTownUser {
  { id, name }
}

///|
pub fn mini_town_profile(
  user_id~ : String,
  display_name~ : String,
  role_id~ : String,
  avatar_ref~ : String,
  consent_accepted? : Bool = false,
  setup_completed? : Bool = false,
) -> MiniTownProfile {
  {
    user_id,
    display_name,
    role_id,
    avatar_ref,
    consent_accepted,
    setup_completed,
  }
}

///|
pub fn mini_town_role(
  id~ : String,
  title~ : String,
  summary~ : String,
  building_id~ : String,
) -> MiniTownRole {
  { id, title, summary, building_id }
}

///|
pub fn mini_town_building(
  id~ : String,
  title~ : String,
  kind~ : String,
  visibility~ : String,
  owner_id~ : String,
  summary~ : String,
  tags~ : Array[String],
  x~ : Int,
  y~ : Int,
  status~ : String,
  asset_ref? : String = "moontown-building",
) -> MiniTownBuilding {
  {
    id,
    title,
    kind,
    visibility,
    owner_id,
    summary,
    tags,
    x,
    y,
    status,
    asset_ref,
  }
}

///|
pub fn mini_town_book(
  id~ : String,
  building_id~ : String,
  title~ : String,
  owner_id~ : String,
  visibility~ : String,
  summary~ : String,
  accepted_memory_count~ : Int,
  pending_review_count~ : Int,
  status~ : String,
) -> MiniTownBook {
  {
    id,
    building_id,
    title,
    owner_id,
    visibility,
    summary,
    accepted_memory_count,
    pending_review_count,
    status,
  }
}

///|
pub fn mini_town_agent(
  id~ : String,
  name~ : String,
  building_id~ : String,
  status~ : String,
) -> MiniTownAgent {
  { id, name, building_id, status }
}

///|
pub fn mini_town_message(
  id~ : String,
  actor_id~ : String,
  thread_id~ : String,
  text~ : String,
  status? : @bunnia.RunStatus = @bunnia.run_done(),
) -> MiniTownMessage {
  { id, actor_id, thread_id, text, status }
}

///|
pub fn mini_town_run(
  id~ : String,
  agent_id~ : String,
  building_id~ : String,
  book_id~ : String,
  thread_id~ : String,
  title~ : String,
  summary~ : String,
  status~ : String,
  review_required? : Bool = false,
  artifact_ref? : String = "",
) -> MiniTownRun {
  {
    id,
    agent_id,
    building_id,
    book_id,
    thread_id,
    title,
    summary,
    status,
    review_required,
    artifact_ref,
  }
}

///|
pub fn mini_town_tool_result(
  id~ : String,
  tool_name~ : String,
  building_id~ : String,
  thread_id~ : String,
  title~ : String,
  summary~ : String,
  artifact_ref~ : String,
  status? : @bunnia.RunStatus = @bunnia.run_done(),
  open_message? : String = "",
  acknowledge_message? : String = "",
) -> MiniTownToolResult {
  {
    id,
    tool_name,
    building_id,
    thread_id,
    title,
    summary,
    artifact_ref,
    status,
    open_message,
    acknowledge_message,
  }
}

///|
pub fn mini_town_review_item(
  id~ : String,
  run_id~ : String,
  building_id~ : String,
  book_id~ : String,
  title~ : String,
  summary~ : String,
  artifact_ref~ : String,
  reviewer_id~ : String,
  status~ : String,
  accepted_memory_delta? : Int = 1,
  accept_message? : String = "accept-memory-review",
  reject_message? : String = "reject-memory-review",
) -> MiniTownReviewItem {
  {
    id,
    run_id,
    building_id,
    book_id,
    title,
    summary,
    artifact_ref,
    reviewer_id,
    status,
    accepted_memory_delta,
    accept_message,
    reject_message,
  }
}

///|
pub fn mini_town_run_action(
  id~ : String,
  label~ : String,
  message~ : String,
  target_ref~ : String,
  allowed~ : Bool,
  reason~ : String,
  status~ : String,
) -> MiniTownRunAction {
  { id, label, message, target_ref, allowed, reason, status }
}

///|
pub fn mini_town_lifecycle_action(
  id~ : String,
  label~ : String,
  message~ : String,
  target_ref~ : String,
  book_id~ : String,
  allowed~ : Bool,
  reason~ : String,
  status~ : String,
) -> MiniTownLifecycleAction {
  { id, label, message, target_ref, book_id, allowed, reason, status }
}

///|
pub fn mini_town_setup_gate(
  id~ : String,
  label~ : String,
  summary~ : String,
  action_label~ : String,
  action_message~ : String,
  complete~ : Bool,
) -> MiniTownSetupGate {
  {
    id,
    label,
    summary,
    action_label,
    action_message,
    complete,
    status: if complete {
      "stable"
    } else {
      "blocked"
    },
  }
}

///|
pub fn mini_town_publication_step(
  id~ : String,
  label~ : String,
  summary~ : String,
  current~ : Bool,
  complete~ : Bool,
  blocked~ : Bool,
) -> MiniTownPublicationStep {
  {
    id,
    label,
    summary,
    current,
    complete,
    blocked,
    status: if blocked {
      "blocked"
    } else if current {
      "review"
    } else if complete {
      "stable"
    } else {
      "draft"
    },
  }
}

///|
pub fn mini_town_tab(
  id~ : String,
  label~ : String,
  map_surface? : Bool = false,
) -> MiniTownTab {
  { id, label, map_surface }
}

///|
pub fn mini_town_onboarding_step(
  id~ : String,
  title~ : String,
  body~ : String,
  building_id~ : String,
) -> MiniTownOnboardingStep {
  { id, title, body, building_id }
}

///|
pub fn mini_town_district(
  id~ : String,
  title~ : String,
  feature_kind~ : String,
  building_id~ : String,
  summary~ : String,
  stat_label~ : String,
  stat_value~ : String,
  action_label~ : String,
  status~ : String,
  action_message? : String = "",
  discovery_filter_id? : String = "all",
  search_query? : String = "",
  accent? : String = "blue",
) -> MiniTownDistrict {
  {
    id,
    title,
    feature_kind,
    building_id,
    summary,
    stat_label,
    stat_value,
    action_label,
    action_message,
    discovery_filter_id,
    search_query,
    accent,
    status,
  }
}

///|
pub fn mini_town_presence(
  id~ : String,
  title~ : String,
  subtitle~ : String,
  actor_kind~ : String,
  building_id~ : String,
  status~ : String,
) -> MiniTownPresence {
  { id, title, subtitle, actor_kind, building_id, status }
}

///|
pub fn mini_town_notification(
  id~ : String,
  kind~ : String,
  title~ : String,
  body~ : String,
  target_ref~ : String,
  building_id? : String = "",
  action_label? : String = "Open",
  action_message? : String = "",
  requires_subscription? : Bool = false,
  unread? : Bool = true,
) -> MiniTownNotification {
  {
    id,
    kind,
    title,
    body,
    target_ref,
    building_id,
    action_label,
    action_message,
    requires_subscription,
    unread,
  }
}

///|
pub fn mini_town_notification_channel(
  id~ : String,
  label~ : String,
  kind~ : String,
  unread_only? : Bool = false,
) -> MiniTownNotificationChannel {
  { id, label, kind, unread_only }
}

///|
pub fn mini_town_watch(
  id~ : String,
  user_id~ : String,
  target_ref~ : String,
  title~ : String,
  summary~ : String,
  status? : String = "watching",
  action_message? : String = "tab-discover",
) -> MiniTownWatch {
  { id, user_id, target_ref, title, summary, status, action_message }
}

///|
pub fn mini_town_discovery_item(
  id~ : String,
  kind~ : String,
  title~ : String,
  summary~ : String,
  target_ref~ : String,
  visibility~ : String,
  status~ : String,
) -> MiniTownDiscoveryItem {
  { id, kind, title, summary, target_ref, visibility, status }
}

///|
pub fn mini_town_discovery_filter(
  id~ : String,
  label~ : String,
  kind~ : String,
  placeable_only? : Bool = false,
) -> MiniTownDiscoveryFilter {
  { id, label, kind, placeable_only }
}

///|
pub fn mini_town_activity_item(
  id~ : String,
  kind~ : String,
  title~ : String,
  summary~ : String,
  actor_id~ : String,
  target_ref~ : String,
  building_id~ : String,
  status~ : String,
) -> MiniTownActivityItem {
  { id, kind, title, summary, actor_id, target_ref, building_id, status }
}

///|
pub fn mini_town_audit_event(
  id~ : String,
  kind~ : String,
  title~ : String,
  summary~ : String,
  actor_id~ : String,
  target_ref~ : String,
  building_id~ : String,
  status~ : String,
  visibility~ : String,
  timestamp~ : String,
) -> MiniTownAuditEvent {
  {
    id,
    kind,
    title,
    summary,
    actor_id,
    target_ref,
    building_id,
    status,
    visibility,
    timestamp,
  }
}

///|
pub fn mini_town_moderation_case(
  id~ : String,
  building_id~ : String,
  reporter_id~ : String,
  target_ref~ : String,
  title~ : String,
  summary~ : String,
  status~ : String,
  action_label? : String = "Review",
  action_message? : String = "tab-messages",
) -> MiniTownModerationCase {
  {
    id,
    building_id,
    reporter_id,
    target_ref,
    title,
    summary,
    status,
    action_label,
    action_message,
  }
}

///|
pub fn mini_town_ownership_stat(
  id~ : String,
  label~ : String,
  value~ : Int,
) -> MiniTownOwnershipStat {
  { id, label, value }
}

///|
pub fn mini_town_ownership_item(
  id~ : String,
  kind~ : String,
  title~ : String,
  summary~ : String,
  target_ref~ : String,
  visibility~ : String,
  status~ : String,
  action_label~ : String,
  action_message~ : String,
) -> MiniTownOwnershipItem {
  {
    id,
    kind,
    title,
    summary,
    target_ref,
    visibility,
    status,
    action_label,
    action_message,
  }
}

///|
pub fn mini_town_ownership_filter(
  id~ : String,
  label~ : String,
  kind? : String = "all",
  visibility? : String = "all",
) -> MiniTownOwnershipFilter {
  { id, label, kind, visibility }
}

///|
pub fn mini_town_backend_step(
  id~ : String,
  label~ : String,
  endpoint_id~ : String,
  http_method~ : String,
  path~ : String,
  summary~ : String,
  status~ : String,
) -> MiniTownBackendStep {
  { id, label, endpoint_id, http_method, path, summary, status }
}

///|
pub fn mini_town_backend_cache_state(
  id~ : String,
  label~ : String,
  source~ : String,
  state~ : String,
  summary~ : String,
  target_ref~ : String,
  action_label? : String = "Open",
  action_message? : String = "load-town-snapshot",
) -> MiniTownBackendCacheState {
  {
    id,
    label,
    source,
    state,
    summary,
    target_ref,
    action_label,
    action_message,
  }
}

///|
pub fn demo_projection() -> MiniTownProjection {
  {
    id: "moontown-miniapp",
    active_user_id: "user-a",
    organization_id: "org-a",
    active_tab_id: "realm",
    onboarding_completed: false,
    role_id: "builder",
    selected_building_id: "policy-hall",
    search_query: "agent",
    active_discovery_filter_id: "all",
    active_notification_channel_id: "all",
    active_ownership_filter_id: "all",
    users: [
      mini_town_user(id="user-a", name="Ada"),
      mini_town_user(id="user-b", name="Bo"),
    ],
    profile: mini_town_profile(
      user_id="user-a",
      display_name="Ada Builder",
      role_id="builder",
      avatar_ref="avatar://ada",
      consent_accepted=false,
      setup_completed=false,
    ),
    roles: demo_roles(),
    tabs: demo_tabs(),
    onboarding_steps: demo_onboarding_steps(),
    districts: demo_districts(),
    presence: demo_presence(),
    buildings: demo_buildings(),
    placements: demo_placements(),
    books: demo_books(),
    agents: [
      mini_town_agent(
        id="agent-policy-guide",
        name="Policy Guide",
        building_id="policy-hall",
        status="waiting-review",
      ),
      mini_town_agent(
        id="agent-map-curator",
        name="Map Curator",
        building_id="market-square",
        status="running",
      ),
      mini_town_agent(
        id="agent-builder",
        name="Builder",
        building_id="private-agent-lab",
        status="idle",
      ),
    ],
    messages: [
      mini_town_message(
        id="msg-welcome",
        actor_id="agent-policy-guide",
        thread_id="thread-policy-hall",
        text="Policy Hall can answer public review questions.",
      ),
      mini_town_message(
        id="msg-review",
        actor_id="agent-policy-guide",
        thread_id="thread-policy-hall",
        text="One accepted answer is waiting for book review.",
        status=@bunnia.run_waiting_review(),
      ),
      mini_town_message(
        id="msg-builder",
        actor_id="agent-builder",
        thread_id="thread-private-agent-lab",
        text="Create a private building, then publish it when ready.",
        status=@bunnia.run_running(),
      ),
    ],
    runs: demo_runs(),
    tool_results: demo_tool_results(),
    reviews: demo_reviews(),
    notifications: demo_notifications(),
    notification_channels: demo_notification_channels(),
    watches: demo_watches(),
    discovery_items: demo_discovery_items(),
    discovery_filters: demo_discovery_filters(),
    ownership_filters: demo_ownership_filters(),
    backend_steps: demo_backend_steps(),
    backend_cache_states: demo_backend_cache_states(),
    activity_items: demo_activity_items(),
    audit_events: demo_audit_events(),
    moderation_cases: demo_moderation_cases(),
  }
}

///|
fn demo_moderation_cases() -> Array[MiniTownModerationCase] {
  [
    mini_town_moderation_case(
      id="mod-policy-hall",
      building_id="policy-hall",
      reporter_id="user-a",
      target_ref="building:policy-hall",
      title="Policy Hall safety watch",
      summary="Reports and appeals stay reviewed.",
      status="watch",
      action_label="Appeal",
      action_message="appeal-moderation-case",
    ),
  ]
}

///|
fn demo_audit_events() -> Array[MiniTownAuditEvent] {
  [
    mini_town_audit_event(
      id="audit-policy-review",
      kind="review",
      title="Policy answer entered review",
      summary="Agent output is held until a reviewer accepts it into the book.",
      actor_id="agent-policy-guide",
      target_ref="run:run-policy-review",
      building_id="policy-hall",
      status="review",
      visibility="published",
      timestamp="2026-07-08T10:00:00Z",
    ),
    mini_town_audit_event(
      id="audit-team-share",
      kind="share",
      title="Team Studio shared privately",
      summary="Organization members can inspect this building before publication.",
      actor_id="user-a",
      target_ref="building:team-studio",
      building_id="team-studio",
      status="shared",
      visibility="shared_private",
      timestamp="2026-07-08T09:24:00Z",
    ),
    mini_town_audit_event(
      id="audit-private-draft",
      kind="create",
      title="Private Agent Lab drafted",
      summary="Private work stays owner-scoped until shared or published.",
      actor_id="user-a",
      target_ref="building:private-agent-lab",
      building_id="private-agent-lab",
      status="draft",
      visibility="private_draft",
      timestamp="2026-07-08T08:48:00Z",
    ),
    mini_town_audit_event(
      id="audit-published-agent-lab",
      kind="publish",
      title="Published Agent Lab approved",
      summary="This building is searchable and placeable from public town search.",
      actor_id="user-b",
      target_ref="building:published-agent-lab",
      building_id="published-agent-lab",
      status="stable",
      visibility="published",
      timestamp="2026-07-08T08:12:00Z",
    ),
  ]
}

///|
fn demo_reviews() -> Array[MiniTownReviewItem] {
  [
    mini_town_review_item(
      id="review-policy-memory",
      run_id="run-policy-review",
      building_id="policy-hall",
      book_id="book-policy-hall",
      title="Review policy answer",
      summary="Accept this answer into Policy Hall Book or reject it for more work.",
      artifact_ref="artifact://book-policy-hall",
      reviewer_id="user-a",
      status="pending",
      accepted_memory_delta=1,
      accept_message="accept-memory-review",
      reject_message="reject-memory-review",
    ),
  ]
}

///|
fn demo_runs() -> Array[MiniTownRun] {
  [
    mini_town_run(
      id="run-policy-review",
      agent_id="agent-policy-guide",
      building_id="policy-hall",
      book_id="book-policy-hall",
      thread_id="thread-policy-hall",
      title="Policy answer review",
      summary="Agent answer is waiting before it becomes public book memory.",
      status="review",
      review_required=true,
      artifact_ref="artifact://book-policy-hall",
    ),
    mini_town_run(
      id="run-market-scan",
      agent_id="agent-map-curator",
      building_id="market-square",
      book_id="book-market-square",
      thread_id="thread-market-square",
      title="Market placement scan",
      summary="Map Curator is finding published buildings that can be placed.",
      status="running",
      artifact_ref="artifact://market-square",
    ),
    mini_town_run(
      id="run-private-lab-draft",
      agent_id="agent-builder",
      building_id="private-agent-lab",
      book_id="book-private-agent-lab",
      thread_id="thread-private-agent-lab",
      title="Private lab setup",
      summary="Builder is preparing the private agent lab before publishing.",
      status="running",
      artifact_ref="artifact://book-private-agent-lab",
    ),
    mini_town_run(
      id="run-knowledge-sync",
      agent_id="agent-policy-guide",
      building_id="knowledge-house",
      book_id="book-knowledge-house",
      thread_id="thread-knowledge-house",
      title="Knowledge memory sync",
      summary="Accepted memories were synchronized into Knowledge House.",
      status="done",
      artifact_ref="artifact://book-knowledge-house",
    ),
  ]
}

///|
fn demo_tool_results() -> Array[MiniTownToolResult] {
  [
    mini_town_tool_result(
      id="tool-policy-summary",
      tool_name="book-summarizer",
      building_id="policy-hall",
      thread_id="thread-policy-hall",
      title="Policy source summary",
      summary="Summarized 9 public source notes for the pending policy answer.",
      artifact_ref="artifact://book-policy-hall-sources",
      status=@bunnia.run_waiting_review(),
      open_message="open-tool-policy-summary",
      acknowledge_message="ack-tool-result",
    ),
    mini_town_tool_result(
      id="tool-market-scan",
      tool_name="placement-scanner",
      building_id="market-square",
      thread_id="thread-market-square",
      title="Placement scan artifact",
      summary="Found reusable public buildings that can be pinned into the town map.",
      artifact_ref="artifact://market-square",
      status=@bunnia.run_running(),
      open_message="open-tool-market-scan",
      acknowledge_message="ack-tool-result",
    ),
  ]
}

///|
fn demo_books() -> Array[MiniTownBook] {
  [
    mini_town_book(
      id="book-policy-hall",
      building_id="policy-hall",
      title="Policy Hall Book",
      owner_id="system",
      visibility="published",
      summary="Accepted policy answers and public review records.",
      accepted_memory_count=12,
      pending_review_count=1,
      status="review",
    ),
    mini_town_book(
      id="book-policy-hall-sources",
      building_id="policy-hall",
      title="Policy Source Shelf",
      owner_id="system",
      visibility="published",
      summary="Public support sources used by Policy Hall answers.",
      accepted_memory_count=9,
      pending_review_count=0,
      status="stable",
    ),
    mini_town_book(
      id="book-private-agent-lab",
      building_id="private-agent-lab",
      title="Private Agent Lab Book",
      owner_id="user-a",
      visibility="private_draft",
      summary="Draft prompts, agent setup notes, and private memory.",
      accepted_memory_count=3,
      pending_review_count=2,
      status="draft",
    ),
    mini_town_book(
      id="book-team-studio",
      building_id="team-studio",
      title="Team Studio Book",
      owner_id="org-a",
      visibility="shared_private",
      summary="Organization planning notes and accepted team decisions.",
      accepted_memory_count=8,
      pending_review_count=0,
      status="shared",
    ),
    mini_town_book(
      id="book-market-square",
      building_id="market-square",
      title="Market Square Ledger",
      owner_id="system",
      visibility="published",
      summary="Published placement results, market scans, and public listings.",
      accepted_memory_count=20,
      pending_review_count=0,
      status="running",
    ),
    mini_town_book(
      id="book-knowledge-house",
      building_id="knowledge-house",
      title="Knowledge House Book",
      owner_id="system",
      visibility="published",
      summary="Public memory behind reusable building answers.",
      accepted_memory_count=36,
      pending_review_count=0,
      status="stable",
    ),
    mini_town_book(
      id="book-workshop-book",
      building_id="book-workshop",
      title="Book Workshop Ledger",
      owner_id="org-a",
      visibility="shared_private",
      summary="Team review queue for accepted memories before publication.",
      accepted_memory_count=14,
      pending_review_count=4,
      status="review",
    ),
    mini_town_book(
      id="book-published-agent-lab",
      building_id="published-agent-lab",
      title="Published Agent Lab Book",
      owner_id="user-b",
      visibility="published",
      summary="Public setup memory for a reusable agent lab.",
      accepted_memory_count=7,
      pending_review_count=0,
      status="stable",
    ),
  ]
}

///|
fn demo_activity_items() -> Array[MiniTownActivityItem] {
  [
    mini_town_activity_item(
      id="activity-review-policy",
      kind="run",
      title="Policy answer waiting for review",
      summary="Policy Guide produced an answer that can enter book memory.",
      actor_id="agent-policy-guide",
      target_ref="thread-policy-hall",
      building_id="policy-hall",
      status="review",
    ),
    mini_town_activity_item(
      id="activity-market-curator",
      kind="agent",
      title="Map Curator scanning published buildings",
      summary="Market Square is refreshing placeable agent buildings.",
      actor_id="agent-map-curator",
      target_ref="agent:agent-map-curator",
      building_id="market-square",
      status="running",
    ),
    mini_town_activity_item(
      id="activity-team-share",
      kind="share",
      title="Team Studio shared to the organization",
      summary="Shared private planning is visible to members only.",
      actor_id="user-a",
      target_ref="building:team-studio",
      building_id="team-studio",
      status="shared",
    ),
    mini_town_activity_item(
      id="activity-book-memory",
      kind="book",
      title="Knowledge House memory updated",
      summary="Accepted building answers are backed by durable books.",
      actor_id="system",
      target_ref="book:knowledge-house",
      building_id="knowledge-house",
      status="stable",
    ),
    mini_town_activity_item(
      id="activity-publish-agent-lab",
      kind="publish",
      title="Published Agent Lab is placeable",
      summary="A public agent lab can now be placed by other users.",
      actor_id="user-b",
      target_ref="building:published-agent-lab",
      building_id="published-agent-lab",
      status="stable",
    ),
  ]
}

///|
fn demo_discovery_items() -> Array[MiniTownDiscoveryItem] {
  [
    mini_town_discovery_item(
      id="discover-user-ada",
      kind="user",
      title="Ada Builder",
      summary="Creates private agent labs and publishes stable buildings.",
      target_ref="user:user-a",
      visibility="personal",
      status="stable",
    ),
    mini_town_discovery_item(
      id="discover-user-deep-cultivator",
      kind="user",
      title="Deep Cultivator",
      summary="Shares applied agent notes and building experiments.",
      target_ref="user:user-deep-cultivator",
      visibility="published",
      status="stable",
    ),
    mini_town_discovery_item(
      id="discover-user-gabriel",
      kind="user",
      title="Gabriel",
      summary="Follows market buildings and agent run reports.",
      target_ref="user:user-gabriel",
      visibility="published",
      status="stable",
    ),
    mini_town_discovery_item(
      id="discover-circle-ai-camp",
      kind="circle",
      title="AI Exploration Camp",
      summary="Public agent circle for AI walkers, demands, and product notes.",
      target_ref="circle:ai-exploration-camp",
      visibility="published",
      status="running",
    ),
    mini_town_discovery_item(
      id="discover-circle-enterprise-club",
      kind="circle",
      title="Enterprise Club",
      summary="Small shared agent circle for builders validating real use cases.",
      target_ref="circle:enterprise-club",
      visibility="published",
      status="shared",
    ),
    mini_town_discovery_item(
      id="discover-agent-policy",
      kind="agent",
      title="Policy Guide",
      summary="Agent for public review, policy answers, and book memory.",
      target_ref="agent:agent-policy-guide",
      visibility="published",
      status="review",
    ),
    mini_town_discovery_item(
      id="discover-book-knowledge",
      kind="book",
      title="Knowledge House Book",
      summary="Accepted memory behind public building answers.",
      target_ref="book:knowledge-house",
      visibility="published",
      status="stable",
    ),
    mini_town_discovery_item(
      id="discover-demand-review",
      kind="demand",
      title="Review Demand",
      summary="Human approval needed before agent output becomes memory.",
      target_ref="demand:review-council",
      visibility="published",
      status="review",
    ),
    mini_town_discovery_item(
      id="discover-product-agent-kit",
      kind="product",
      title="Agent Publishing Kit",
      summary="Reusable workflow kit for publishing reviewed agent buildings.",
      target_ref="product:agent-publishing-kit",
      visibility="published",
      status="stable",
    ),
    mini_town_discovery_item(
      id="discover-event-studio",
      kind="event",
      title="Team Studio Session",
      summary="Shared organization agent session for map and book planning.",
      target_ref="event:team-studio",
      visibility="published",
      status="shared",
    ),
    mini_town_discovery_item(
      id="discover-post-agent",
      kind="post",
      title="Agent Lab Field Note",
      summary="A public note about placing published agent buildings.",
      target_ref="post:published-agent-lab",
      visibility="published",
      status="stable",
    ),
  ]
}

///|
fn demo_discovery_filters() -> Array[MiniTownDiscoveryFilter] {
  [
    mini_town_discovery_filter(id="all", label="All", kind="all"),
    mini_town_discovery_filter(id="user", label="People", kind="user"),
    mini_town_discovery_filter(id="circle", label="Circles", kind="circle"),
    mini_town_discovery_filter(id="product", label="Products", kind="product"),
    mini_town_discovery_filter(id="demand", label="Demands", kind="demand"),
    mini_town_discovery_filter(id="event", label="Events", kind="event"),
    mini_town_discovery_filter(id="post", label="Posts", kind="post"),
    mini_town_discovery_filter(
      id="building",
      label="Buildings",
      kind="building",
    ),
    mini_town_discovery_filter(id="agent", label="Agents", kind="agent"),
    mini_town_discovery_filter(id="book", label="Books", kind="book"),
    mini_town_discovery_filter(
      id="placeable",
      label="Placeable",
      kind="building",
      placeable_only=true,
    ),
  ]
}

///|
fn demo_roles() -> Array[MiniTownRole] {
  [
    mini_town_role(
      id="builder",
      title="Town Builder",
      summary="Create buildings, agents, and private workspaces.",
      building_id="private-agent-lab",
    ),
    mini_town_role(
      id="creator",
      title="Creative Operator",
      summary="Publish useful products, prompts, and agent experiences.",
      building_id="market-square",
    ),
    mini_town_role(
      id="explorer",
      title="Knowledge Explorer",
      summary="Search public buildings and learn from shared books.",
      building_id="knowledge-house",
    ),
    mini_town_role(
      id="practitioner",
      title="AI Practitioner",
      summary="Route real demands through reviewable agent workflows.",
      building_id="review-council",
    ),
    mini_town_role(
      id="wanderer",
      title="Town Wanderer",
      summary="Browse the town before committing to a public role.",
      building_id="gateway",
    ),
  ]
}

///|
fn demo_tabs() -> Array[MiniTownTab] {
  [
    mini_town_tab(id="home", label="Home"),
    mini_town_tab(id="discover", label="Discover"),
    mini_town_tab(id="realm", label="Realm", map_surface=true),
    mini_town_tab(id="messages", label="Messages"),
    mini_town_tab(id="my", label="My"),
  ]
}

///|
fn demo_onboarding_steps() -> Array[MiniTownOnboardingStep] {
  [
    mini_town_onboarding_step(
      id="welcome",
      title="Enter Moontown",
      body="Start from the tile town map and let agents guide each building.",
      building_id="gateway",
    ),
    mini_town_onboarding_step(
      id="inspiration",
      title="Read the town pulse",
      body="Shared discoveries appear as activity around buildings and books.",
      building_id="knowledge-house",
    ),
    mini_town_onboarding_step(
      id="districts",
      title="Use feature districts",
      body="Markets, demands, events, and guides are real places on the map.",
      building_id="market-square",
    ),
    mini_town_onboarding_step(
      id="navigation",
      title="Realm is the map",
      body="The Realm tab always returns to this same full-screen town.",
      building_id="policy-hall",
    ),
  ]
}

///|
fn demo_districts() -> Array[MiniTownDistrict] {
  [
    mini_town_district(
      id="product-market",
      title="Product Market",
      feature_kind="market",
      building_id="market-square",
      summary="Published building and product showcase.",
      stat_label="products",
      stat_value="20",
      action_label="Browse",
      action_message="tab-discover",
      discovery_filter_id="product",
      search_query="product",
      accent="blue",
      status="running",
    ),
    mini_town_district(
      id="demand-hall",
      title="Demand Hall",
      feature_kind="demand",
      building_id="review-council",
      summary="Requests, reviews, and agent jobs.",
      stat_label="demands",
      stat_value="34",
      action_label="Review",
      action_message="tab-messages",
      discovery_filter_id="demand",
      search_query="review demand",
      accent="orange",
      status="review",
    ),
    mini_town_district(
      id="event-calendar",
      title="Event Calendar",
      feature_kind="event",
      building_id="team-studio",
      summary="Team and public town activities.",
      stat_label="events",
      stat_value="6",
      action_label="Join",
      action_message="tab-messages",
      discovery_filter_id="event",
      search_query="team event",
      accent="purple",
      status="shared",
    ),
    mini_town_district(
      id="city-guide",
      title="City Guide",
      feature_kind="guide",
      building_id="gateway",
      summary="Search, onboarding, and safe routing.",
      stat_label="guides",
      stat_value="4",
      action_label="Open",
      action_message="tab-home",
      discovery_filter_id="post",
      search_query="guide",
      accent="pink",
      status="stable",
    ),
    mini_town_district(
      id="opc-hub",
      title="OPC Hub",
      feature_kind="credential",
      building_id="policy-hall",
      summary="Registration, policy, and public trust checks.",
      stat_label="checks",
      stat_value="8",
      action_label="Verify",
      action_message="tab-my",
      discovery_filter_id="all",
      search_query="trust policy",
      accent="green",
      status="stable",
    ),
  ]
}

///|
fn demo_presence() -> Array[MiniTownPresence] {
  [
    mini_town_presence(
      id="presence-ada",
      title="Ada Builder",
      subtitle="publishing a private lab",
      actor_kind="user",
      building_id="private-agent-lab",
      status="draft",
    ),
    mini_town_presence(
      id="presence-policy-guide",
      title="Policy Guide",
      subtitle="reviewing public memory",
      actor_kind="agent",
      building_id="policy-hall",
      status="review",
    ),
    mini_town_presence(
      id="presence-map-curator",
      title="Map Curator",
      subtitle="placing market signals",
      actor_kind="agent",
      building_id="market-square",
      status="running",
    ),
    mini_town_presence(
      id="presence-team-studio",
      title="Team Studio",
      subtitle="shared with org members",
      actor_kind="building",
      building_id="team-studio",
      status="shared",
    ),
  ]
}

///|
fn demo_notifications() -> Array[MiniTownNotification] {
  [
    mini_town_notification(
      id="notice-review",
      kind="review",
      title="Memory review needed",
      body="Policy Hall has an accepted answer waiting for book review.",
      target_ref="thread-policy-hall",
      building_id="policy-hall",
      action_label="Review",
      action_message="open-notice-review",
    ),
    mini_town_notification(
      id="notice-publish",
      kind="publish",
      title="Draft ready to publish",
      body="Private Agent Lab can be submitted after profile consent.",
      target_ref="building-private-agent-lab",
      building_id="private-agent-lab",
      action_label="Open Draft",
      action_message="open-notice-publish",
    ),
    mini_town_notification(
      id="notice-share",
      kind="share",
      title="Team building shared",
      body="Team Studio is visible to organization members.",
      target_ref="building-team-studio",
      building_id="team-studio",
      action_label="Open Team",
      action_message="open-notice-share",
      unread=false,
    ),
    mini_town_notification(
      id="notice-run",
      kind="agent-run",
      title="Agent run completed",
      body="Market placement scan finished with a placeable building suggestion.",
      target_ref="run-market-scan",
      building_id="market-square",
      action_label="Open Run",
      action_message="open-notice-run",
    ),
    mini_town_notification(
      id="notice-follow",
      kind="follow",
      title="Deep Cultivator followed your town",
      body="A new AI walker is watching your public building updates.",
      target_ref="user:user-deep-cultivator",
      building_id="",
      action_label="Open Walker",
      action_message="open-notice-follow",
    ),
    mini_town_notification(
      id="notice-interaction",
      kind="interaction",
      title="Enterprise Club replied",
      body="The circle left feedback on your shared private building.",
      target_ref="circle:enterprise-club",
      building_id="team-studio",
      action_label="Open Circle",
      action_message="open-notice-interaction",
    ),
    mini_town_notification(
      id="notice-subscribe",
      kind="subscription",
      title="Subscribe to town signals",
      body="Receive run, review, publish, and share notices through WeChat.",
      target_ref="subscription:wechat",
      building_id="gateway",
      action_label="Subscribe",
      action_message="request-subscription",
      requires_subscription=true,
      unread=false,
    ),
  ]
}

///|
fn demo_notification_channels() -> Array[MiniTownNotificationChannel] {
  [
    mini_town_notification_channel(id="all", label="All", kind="all"),
    mini_town_notification_channel(
      id="unread",
      label="Unread",
      kind="all",
      unread_only=true,
    ),
    mini_town_notification_channel(id="follow", label="Follows", kind="follow"),
    mini_town_notification_channel(
      id="interaction",
      label="Interactions",
      kind="interaction",
    ),
    mini_town_notification_channel(id="agent", label="Agents", kind="agent-run"),
    mini_town_notification_channel(id="review", label="Reviews", kind="review"),
    mini_town_notification_channel(
      id="system",
      label="System",
      kind="subscription",
    ),
  ]
}

///|
fn demo_watches() -> Array[MiniTownWatch] {
  [
    mini_town_watch(
      id="watch-policy-hall",
      user_id="user-a",
      target_ref="building:policy-hall",
      title="Policy Hall",
      summary="Public review and book-memory updates are watched.",
      action_message="select-policy-hall",
    ),
  ]
}

///|
fn demo_ownership_filters() -> Array[MiniTownOwnershipFilter] {
  [
    mini_town_ownership_filter(id="all", label="All"),
    mini_town_ownership_filter(
      id="placements",
      label="Placed",
      kind="placement",
    ),
    mini_town_ownership_filter(
      id="drafts",
      label="Drafts",
      visibility="private_draft",
    ),
    mini_town_ownership_filter(
      id="published",
      label="Published",
      visibility="published",
    ),
    mini_town_ownership_filter(id="books", label="Books", kind="book"),
    mini_town_ownership_filter(id="agents", label="Agents", kind="agent"),
    mini_town_ownership_filter(id="watches", label="Watches", kind="watch"),
  ]
}

///|
fn demo_backend_steps() -> Array[MiniTownBackendStep] {
  [
    mini_town_backend_step(
      id="login",
      label="Dev Login",
      endpoint_id="dev-login",
      http_method="POST",
      path="/miniapp/auth/dev-login",
      summary="Create or reuse a local user profile and session.",
      status="ready",
    ),
    mini_town_backend_step(
      id="snapshot",
      label="Load Snapshot",
      endpoint_id="load-town-snapshot",
      http_method="GET",
      path="/miniapp/town/snapshot",
      summary="Pull scoped buildings, books, agents, runs, and reviews.",
      status="ready",
    ),
    mini_town_backend_step(
      id="ownership",
      label="Sync Ownership",
      endpoint_id="load-ownership-snapshot",
      http_method="GET",
      path="/miniapp/me/ownership",
      summary="Pull owned buildings, books, agents, placements, and alerts for My.",
      status="ready",
    ),
    mini_town_backend_step(
      id="publish",
      label="Publish",
      endpoint_id="publish-private-building",
      http_method="POST",
      path="/miniapp/buildings/publish",
      summary="Move an owned draft into public discovery.",
      status="guarded",
    ),
    mini_town_backend_step(
      id="chat",
      label="Ask Agent",
      endpoint_id="ask-selected-building",
      http_method="POST",
      path="/miniapp/buildings/query",
      summary="Send a building question and record a reviewable run.",
      status="guarded",
    ),
    mini_town_backend_step(
      id="cancel-run",
      label="Cancel Run",
      endpoint_id="cancel-run",
      http_method="POST",
      path="/miniapp/runs/cancel",
      summary="Stop a running agent task without accepting output as memory.",
      status="guarded",
    ),
    mini_town_backend_step(
      id="retry-run",
      label="Retry Run",
      endpoint_id="retry-run",
      http_method="POST",
      path="/miniapp/runs/retry",
      summary="Restart a failed, rejected, or cancelled run with the same context.",
      status="guarded",
    ),
    mini_town_backend_step(
      id="ack-notification",
      label="Ack Notice",
      endpoint_id="ack-notification",
      http_method="POST",
      path="/miniapp/messages/ack",
      summary="Mark a follow, interaction, review, or run notice as handled.",
      status="ready",
    ),
    mini_town_backend_step(
      id="request-subscription",
      label="Subscribe",
      endpoint_id="request-subscription",
      http_method="POST",
      path="/miniapp/messages/subscribe",
      summary="Request WeChat subscription delivery for important town signals.",
      status="platform",
    ),
    mini_town_backend_step(
      id="discover-action",
      label="Discover Action",
      endpoint_id="discover-action",
      http_method="POST",
      path="/miniapp/discover/action",
      summary="Open, answer, join, or read a public discovery target with viewer-scoped audit.",
      status="ready",
    ),
    mini_town_backend_step(
      id="handoff-agent-work",
      label="Handoff",
      endpoint_id="handoff-agent-work",
      http_method="POST",
      path="/miniapp/agents/handoff",
      summary="Move work from one town agent to another while preserving building context.",
      status="guarded",
    ),
    mini_town_backend_step(
      id="admin-ops",
      label="Ops",
      endpoint_id="load-admin-ops",
      http_method="GET",
      path="/miniapp/admin/ops",
      summary="Reviewer-only town counts, checks, incidents, holds, retention, and recovery status.",
      status="review",
    ),
    mini_town_backend_step(
      id="admin-readiness",
      label="Readiness",
      endpoint_id="load-admin-readiness",
      http_method="GET",
      path="/miniapp/admin/readiness",
      summary="Production checklist for WeChat login, domain, storage, monitoring, reviewers, and secrets.",
      status="guarded",
    ),
  ]
}

///|
fn demo_backend_cache_states() -> Array[MiniTownBackendCacheState] {
  [
    mini_town_backend_cache_state(
      id="session",
      label="Session",
      source="local",
      state="empty",
      summary="Dev login sets local session headers.",
      target_ref="backend:dev-login",
      action_label="Login",
      action_message="dev-login",
    ),
    mini_town_backend_cache_state(
      id="snapshot",
      label="Town Snapshot",
      source="cache",
      state="stale-safe",
      summary="Stale town remains visible on reload failure.",
      target_ref="backend:load-town-snapshot",
      action_label="Reload",
      action_message="load-town-snapshot",
    ),
    mini_town_backend_cache_state(
      id="ownership",
      label="Ownership Snapshot",
      source="cache",
      state="idle",
      summary="My reloads owned places, books, agents, pins, and alerts.",
      target_ref="backend:load-ownership-snapshot",
      action_label="Sync",
      action_message="load-ownership-snapshot",
    ),
    mini_town_backend_cache_state(
      id="mutations",
      label="Mutation Queue",
      source="request-log",
      state="idle",
      summary="Town actions keep retry payloads.",
      target_ref="backend:mutations",
      action_label="Open My",
      action_message="tab-my",
    ),
    mini_town_backend_cache_state(
      id="reviews",
      label="Review Result",
      source="run-log",
      state="pending",
      summary="Agent answers wait for book-memory review.",
      target_ref="review:memory",
      action_label="Review",
      action_message="tab-messages",
    ),
  ]
}

///|
pub fn local_backend_base_url() -> String {
  "http://127.0.0.1:18191"
}

///|
fn demo_buildings() -> Array[MiniTownBuilding] {
  [
    mini_town_building(
      id="policy-hall",
      title="Policy Hall",
      kind="policy_hall",
      visibility="published",
      owner_id="system",
      summary="Public policy answers and review routing.",
      tags=["policy", "review", "public"],
      x=479,
      y=388,
      status="review",
    ),
    mini_town_building(
      id="private-agent-lab",
      title="Private Agent Lab",
      kind="agent_lab",
      visibility="private_draft",
      owner_id="user-a",
      summary="Draft agent creation space visible only to Ada.",
      tags=["agent", "private", "draft"],
      x=432,
      y=513,
      status="draft",
    ),
    mini_town_building(
      id="team-studio",
      title="Team Studio",
      kind="project_studio",
      visibility="shared_private",
      owner_id="org-a",
      summary="Organization planning room shared by members.",
      tags=["team", "project", "shared"],
      x=462,
      y=468,
      status="shared",
    ),
    mini_town_building(
      id="market-square",
      title="Market Square",
      kind="market_square",
      visibility="published",
      owner_id="system",
      summary="Published buildings can be searched and placed.",
      tags=["market", "public", "search"],
      x=530,
      y=592,
      status="running",
    ),
    mini_town_building(
      id="review-council",
      title="Review Council",
      kind="review_council",
      visibility="published",
      owner_id="system",
      summary="Moderation and publishing decisions happen here.",
      tags=["review", "publish", "moderation"],
      x=462,
      y=341,
      status="review",
    ),
    mini_town_building(
      id="knowledge-house",
      title="Knowledge House",
      kind="knowledge_house",
      visibility="published",
      owner_id="system",
      summary="Book-backed accepted memory for public queries.",
      tags=["book", "memory", "public"],
      x=518,
      y=430,
      status="stable",
    ),
    mini_town_building(
      id="gateway",
      title="System Gateway",
      kind="system_gateway",
      visibility="published",
      owner_id="system",
      summary="Login, session, and safe backend handoff.",
      tags=["system", "login", "session"],
      x=696,
      y=556,
      status="stable",
    ),
    mini_town_building(
      id="book-workshop",
      title="Book Workshop",
      kind="knowledge_house",
      visibility="shared_private",
      owner_id="org-a",
      summary="Team book review queue for accepted memories.",
      tags=["book", "team", "review"],
      x=662,
      y=415,
      status="shared",
    ),
    mini_town_building(
      id="draft-observatory",
      title="Draft Observatory",
      kind="custom",
      visibility="private_draft",
      owner_id="user-b",
      summary="Bo's hidden draft should not appear for Ada.",
      tags=["hidden", "private"],
      x=535,
      y=347,
      status="hidden",
    ),
    mini_town_building(
      id="published-agent-lab",
      title="Published Agent Lab",
      kind="agent_lab",
      visibility="published",
      owner_id="user-b",
      summary="A public agent lab Ada can place on her map.",
      tags=["agent", "public", "place"],
      x=538,
      y=528,
      status="stable",
    ),
  ]
}

///|
fn demo_placements() -> Array[MiniTownPlacement] {
  [
    mini_town_placement(
      id="placement-user-a-policy-hall",
      building_id="policy-hall",
      owner_id="user-a",
      layer="personal",
      x=479,
      y=388,
      status="pinned",
      source="starter-map",
    ),
  ]
}

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
    "profile setup needed"
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
    "owner action"
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
pub fn setup_gates(projection : MiniTownProjection) -> Array[MiniTownSetupGate] {
  [
    mini_town_setup_gate(
      id="session",
      label="Session",
      summary=if projection.active_user_id == "" {
        "Login before private buildings and agent runs can be scoped."
      } else {
        "Logged in as \{projection.active_user_id}."
      },
      action_label="Login",
      action_message="dev-login",
      complete=projection.active_user_id != "",
    ),
    mini_town_setup_gate(
      id="onboarding",
      label="Onboarding",
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
      label="Role",
      summary=if projection.profile.role_id == "" {
        "Choose a role so recommendations and labels are scoped."
      } else {
        "Role selected: \{projection.profile.role_id}."
      },
      action_label="Choose",
      action_message="select-role-builder",
      complete=projection.profile.role_id != "",
    ),
    mini_town_setup_gate(
      id="consent",
      label="Consent",
      summary=if projection.profile.consent_accepted {
        "Agreement accepted for publish and share workflows."
      } else {
        "Accept consent before publishing or sharing town content."
      },
      action_label="Accept",
      action_message="accept-profile-consent",
      complete=projection.profile.consent_accepted,
    ),
    mini_town_setup_gate(
      id="profile",
      label="Profile",
      summary=if projection.profile.setup_completed {
        "Profile setup is complete."
      } else {
        "Save profile details before public building actions."
      },
      action_label="Save",
      action_message="save-profile",
      complete=projection.profile.setup_completed,
    ),
    mini_town_setup_gate(
      id="publish-ready",
      label="Publish Ready",
      summary=if profile_ready_to_publish(projection) {
        "Create, share, and publish actions can be enabled by ownership."
      } else {
        "Publishing stays blocked until role, consent, and profile are ready."
      },
      action_label="My",
      action_message="tab-my",
      complete=profile_ready_to_publish(projection),
    ),
  ]
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
      summary = "\{building.summary} / placed from \{placement.source}"
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
