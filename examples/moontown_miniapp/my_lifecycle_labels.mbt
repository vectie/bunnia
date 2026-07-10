///|
fn ownership_event_label(kind : String) -> String {
  if kind == "create" {
    "Created"
  } else if kind == "update" {
    "Updated"
  } else if kind == "share" {
    "Shared"
  } else if kind == "submit" {
    "Submitted"
  } else if kind == "publish" {
    "Published"
  } else if kind == "archive" {
    "Archived"
  } else if kind == "restore" {
    "Restored"
  } else {
    "Changed"
  }
}
