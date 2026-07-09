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
