///|
fn ready_word(ready : Bool) -> String {
  if ready {
    "ready"
  } else {
    "needs setup"
  }
}

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
  } else if status == "idle" {
    "Waiting"
  } else {
    status
  }
}

///|
fn town_visibility_label(visibility : String) -> String {
  if visibility == "published" || visibility == "public" {
    "Public in town"
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

///|
fn town_kind_label(kind : String) -> String {
  if kind == "user" {
    "Person"
  } else if kind == "circle" {
    "Circle"
  } else if kind == "product" {
    "Product"
  } else if kind == "demand" {
    "Demand"
  } else if kind == "event" {
    "Event"
  } else if kind == "post" {
    "Note"
  } else if kind == "book" {
    "Book"
  } else if kind == "agent" {
    "Agent"
  } else if kind == "building" {
    "Place"
  } else if kind == "review" {
    "Review"
  } else if kind == "run" {
    "Agent work"
  } else if kind == "publish" {
    "Published"
  } else if kind == "place" {
    "Placed"
  } else if kind == "watch" {
    "Watch"
  } else if kind == "profile" {
    "Profile"
  } else {
    kind
  }
}

///|
fn town_tab_label(tab : String) -> String {
  if tab == "home" {
    "Home"
  } else if tab == "discover" {
    "Discover"
  } else if tab == "messages" {
    "Messages"
  } else if tab == "my" {
    "My"
  } else {
    "Realm"
  }
}

///|
fn backend_step_user_title(step : MiniTownBackendStep) -> String {
  if step.endpoint_id == "load-town-snapshot" {
    "Refresh Town"
  } else if step.endpoint_id == "load-ownership-snapshot" {
    "Refresh My Stuff"
  } else if step.endpoint_id == "load-message-center" {
    "Latest Messages"
  } else if step.endpoint_id == "ack-notification" {
    "Mark Read"
  } else if step.endpoint_id == "ack-tool-result" {
    "Review Result"
  } else if step.endpoint_id == "request-subscription" {
    "Watch Notices"
  } else if step.endpoint_id == "dev-login" {
    "Enter Town"
  } else if step.endpoint_id == "cancel-run" {
    "Cancel Agent Work"
  } else if step.endpoint_id == "retry-run" {
    "Try Again"
  } else {
    step.label
  }
}

///|
fn backend_step_user_summary(step : MiniTownBackendStep) -> String {
  if step.endpoint_id == "load-town-snapshot" {
    "Bring in the latest places, activity, and map updates."
  } else if step.endpoint_id == "load-ownership-snapshot" {
    "Bring in owned places, books, agents, and alerts."
  } else if step.endpoint_id == "load-message-center" {
    "Check who needs your attention."
  } else if step.endpoint_id == "ack-notification" {
    "Clear notices after you have seen them."
  } else if step.endpoint_id == "ack-tool-result" {
    "Confirm a reviewed agent result."
  } else if step.endpoint_id == "request-subscription" {
    "Ask the town to keep you posted."
  } else if step.endpoint_id == "dev-login" {
    "Use the demo town identity."
  } else if step.endpoint_id == "cancel-run" {
    "Stop agent work that should not continue."
  } else if step.endpoint_id == "retry-run" {
    "Run failed or cancelled agent work again."
  } else {
    step.summary
  }
}

///|
fn cache_user_title(cache : MiniTownBackendCacheState) -> String {
  if cache.id == "snapshot" {
    "Town Map"
  } else if cache.id == "ownership" {
    "My Inventory"
  } else if cache.id == "messages" {
    "Latest Messages"
  } else {
    cache.label
  }
}

///|
fn cache_user_summary(cache : MiniTownBackendCacheState) -> String {
  if cache.state.contains("stale") {
    "Needs refresh before the town can show the latest changes."
  } else if cache.state == "failed" || cache.state == "malformed" {
    "Could not update. Try again."
  } else if cache.state == "cancelled" {
    "Update cancelled."
  } else if cache.state == "retrying" {
    "Trying again now."
  } else {
    cache.summary
  }
}

///|
fn cache_user_action_label(cache : MiniTownBackendCacheState) -> String {
  if cache.action_message == "load-town-snapshot" {
    "Refresh Town"
  } else if cache.action_message == "load-ownership-snapshot" {
    "Refresh My Stuff"
  } else if cache.action_message == "load-message-center" {
    "Latest Messages"
  } else if cache.action_message == "dev-login" {
    "Enter Town"
  } else if cache.action_label == "Sync" || cache.action_label == "Reload" {
    "Refresh"
  } else {
    cache.action_label
  }
}

///|
fn backend_endpoint_user_summary(endpoint_id : String) -> String {
  if endpoint_id == "load-message-center" {
    "Check who needs your attention."
  } else if endpoint_id == "ack-notification" {
    "Clear notices after you have seen them."
  } else if endpoint_id == "ack-tool-result" {
    "Confirm a reviewed agent result."
  } else if endpoint_id == "request-subscription" {
    "Ask the town to keep you posted."
  } else if endpoint_id == "send-building-message" {
    "Send a message in this building thread."
  } else {
    "Ready when you need it."
  }
}
