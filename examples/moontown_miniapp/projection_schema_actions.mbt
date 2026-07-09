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
