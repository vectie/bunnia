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
