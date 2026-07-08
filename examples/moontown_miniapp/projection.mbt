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
  books : Array[MiniTownBook]
  agents : Array[MiniTownAgent]
  messages : Array[MiniTownMessage]
  runs : Array[MiniTownRun]
  reviews : Array[MiniTownReviewItem]
  notifications : Array[MiniTownNotification]
  notification_channels : Array[MiniTownNotificationChannel]
  discovery_items : Array[MiniTownDiscoveryItem]
  discovery_filters : Array[MiniTownDiscoveryFilter]
  ownership_filters : Array[MiniTownOwnershipFilter]
  backend_steps : Array[MiniTownBackendStep]
  backend_cache_states : Array[MiniTownBackendCacheState]
  activity_items : Array[MiniTownActivityItem]
  audit_events : Array[MiniTownAuditEvent]
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
) -> MiniTownOwnershipItem {
  { id, kind, title, summary, target_ref, visibility, status, action_label }
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
) -> MiniTownBackendCacheState {
  { id, label, source, state, summary, target_ref }
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
    reviews: demo_reviews(),
    notifications: demo_notifications(),
    notification_channels: demo_notification_channels(),
    discovery_items: demo_discovery_items(),
    discovery_filters: demo_discovery_filters(),
    ownership_filters: demo_ownership_filters(),
    backend_steps: demo_backend_steps(),
    backend_cache_states: demo_backend_cache_states(),
    activity_items: demo_activity_items(),
    audit_events: demo_audit_events(),
  }
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
      id="discover-event-studio",
      kind="event",
      title="Team Studio Session",
      summary="Shared organization session for map and book planning.",
      target_ref="event:team-studio",
      visibility="shared_private",
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
fn demo_ownership_filters() -> Array[MiniTownOwnershipFilter] {
  [
    mini_town_ownership_filter(id="all", label="All"),
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
      summary="Create a local session for the active user.",
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
      summary="Dev login fills bunniaSessionId and sends x-miniapp-session.",
      target_ref="backend:dev-login",
    ),
    mini_town_backend_cache_state(
      id="snapshot",
      label="Town Snapshot",
      source="cache",
      state="stale-safe",
      summary="Last visible town stays rendered when snapshot loading fails.",
      target_ref="backend:load-town-snapshot",
    ),
    mini_town_backend_cache_state(
      id="mutations",
      label="Mutation Queue",
      source="request-log",
      state="idle",
      summary="Create, share, publish, archive, and place actions keep retry payloads.",
      target_ref="backend:mutations",
    ),
    mini_town_backend_cache_state(
      id="reviews",
      label="Review Result",
      source="run-log",
      state="pending",
      summary="Agent answers wait for review before becoming book memory.",
      target_ref="review:memory",
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
  mini_town_review_run_visible_for(projection, item)
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
fn mini_town_run_visible_for(
  projection : MiniTownProjection,
  run : MiniTownRun,
) -> Bool {
  mini_town_run_building_visible_for(projection, run) &&
  mini_town_run_book_visible_for(projection, run)
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
      id="publish",
      label="Publish",
      message="publish-private-building",
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
      complete=building.visibility == "published" ||
        building.visibility == "archived",
      blocked=!private_ready && building.visibility == "private_draft",
    ),
    mini_town_publication_step(
      id="review",
      label="Publish Review",
      summary=if shared_ready {
        "Ready to submit into town publication."
      } else {
        lifecycle_publish_reason(projection, building)
      },
      current=building.visibility == "shared_private" &&
        profile_ready_to_publish(projection),
      complete=building.visibility == "published" ||
        building.visibility == "archived",
      blocked=building.visibility == "shared_private" &&
        !profile_ready_to_publish(projection),
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
        "Hidden from normal map and discovery surfaces."
      } else {
        lifecycle_archive_reason(projection, building)
      },
      current=building.visibility == "archived",
      complete=building.visibility == "archived",
      blocked=building.visibility == "archived",
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
    "ready for town"
  } else {
    "not a draft"
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
    if mini_town_discovery_filter_match(filter, item) {
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
  filter : MiniTownDiscoveryFilter,
  item : MiniTownDiscoveryItem,
) -> Bool {
  let kind_match = filter.kind == "all" || filter.kind == item.kind
  let placeable_match = !filter.placeable_only ||
    (item.kind == "building" && item.visibility == "published")
  kind_match && placeable_match
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
    if run.status == "running" || run.status == "review" {
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
pub fn place_published_building(
  projection : MiniTownProjection,
  building_id : String,
) -> MiniTownProjection {
  let mut title = building_id
  for building in projection.buildings {
    if building.id == building_id {
      title = building.title
    }
  }
  {
    ..projection,
    selected_building_id: building_id,
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
  let agent = mini_town_agent(
    id~,
    name~,
    building_id=projection.selected_building_id,
    status="idle",
  )
  { ..projection, agents: projection.agents + [agent] }
}

///|
pub fn accept_review(
  projection : MiniTownProjection,
  review_id : String,
) -> MiniTownProjection {
  let mut delta = 0
  let mut target_book_id = ""
  let mut target_run_id = ""
  let reviews : Array[MiniTownReviewItem] = []
  for item in projection.reviews {
    if item.id == review_id && item.status == "pending" {
      delta = item.accepted_memory_delta
      target_book_id = item.book_id
      target_run_id = item.run_id
      reviews.push({ ..item, status: "accepted" })
    } else {
      reviews.push(item)
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
  let mut target_run_id = ""
  let reviews : Array[MiniTownReviewItem] = []
  for item in projection.reviews {
    if item.id == review_id && item.status == "pending" {
      target_run_id = item.run_id
      reviews.push({ ..item, status: "rejected" })
    } else {
      reviews.push(item)
    }
  }
  {
    ..projection,
    reviews,
    runs: update_run_status(projection.runs, target_run_id, "rejected"),
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
pub fn ownership_stats(
  projection : MiniTownProjection,
) -> Array[MiniTownOwnershipStat] {
  [
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
        action_label="Open",
      ),
    )
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
      ),
    )
  }
  output
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
