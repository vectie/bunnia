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
  reviewer_tools_open : Bool
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
