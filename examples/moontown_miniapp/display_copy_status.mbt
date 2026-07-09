///|
fn town_status_label(status : String) -> String {
  if status == "ready" || status == "stable" {
    "Ready"
  } else if status == "review" || status == "waiting-review" {
    "Needs review"
  } else if status == "running" || status == "retrying" {
    "In progress"
  } else if status == "draft" || status == "private_draft" {
    "Draft"
  } else if status == "blocked" {
    "Blocked"
  } else if status == "failed" || status == "malformed" {
    "Could not update"
  } else if status == "cancelled" {
    "Cancelled"
  } else if status == "stale" || status.contains("stale") {
    "Needs refresh"
  } else if status == "published" || status == "public" {
    "Public"
  } else if status == "shared" || status == "shared_private" {
    "Shared"
  } else if status == "watching" {
    "Watching"
  } else if status == "empty" {
    "Empty"
  } else if status == "clear" {
    "Clear"
  } else if status == "pending" {
    "Waiting for review"
  } else if status == "idle" {
    "Waiting"
  } else {
    status
  }
}

///|
fn town_visibility_label(visibility : String) -> String {
  if visibility == "published" ||
    visibility == "public" ||
    visibility == "system_public" {
    "Public in town"
  } else if visibility == "personal" {
    "My map"
  } else if visibility == "private_draft" {
    "Private draft"
  } else if visibility == "shared_private" {
    "Shared privately"
  } else if visibility == "hidden" {
    "Hidden from town"
  } else {
    town_status_label(visibility)
  }
}
