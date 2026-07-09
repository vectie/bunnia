///|
fn ready_word(ready : Bool) -> String {
  if ready {
    "ready"
  } else {
    "needs setup"
  }
}

///|
fn count_label(count : Int, singular : String, plural : String) -> String {
  if count == 1 {
    "1 \{singular}"
  } else {
    "\{count} \{plural}"
  }
}

///|
fn optional_count_label(
  count : Int,
  singular : String,
  plural : String,
) -> String {
  if count == 0 {
    "no \{plural}"
  } else {
    count_label(count, singular, plural)
  }
}

///|
fn empty_count_label(
  count : Int,
  empty : String,
  singular : String,
  plural : String,
) -> String {
  if count == 0 {
    empty
  } else {
    count_label(count, singular, plural)
  }
}

///|
fn profile_publish_sentence(name : String, ready : Bool) -> String {
  if ready {
    "\{name} is ready to publish."
  } else {
    "\{name} needs setup before publishing."
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
  } else if kind == "placement" {
    "Placed"
  } else if kind == "policy_hall" {
    "Policy hall"
  } else if kind == "agent_lab" {
    "Agent lab"
  } else if kind == "project_studio" {
    "Team studio"
  } else if kind == "market_square" {
    "Market"
  } else if kind == "review_council" {
    "Review hall"
  } else if kind == "knowledge_house" {
    "Knowledge house"
  } else if kind == "system_gateway" {
    "Gateway"
  } else if kind == "review" {
    "Needs review"
  } else if kind == "agent-run" {
    "Agent reply"
  } else if kind == "interaction" {
    "Interaction"
  } else if kind == "subscription" {
    "Town notice"
  } else if kind == "follow" {
    "Town notice"
  } else if kind == "publish" {
    "Publishing"
  } else if kind == "share" {
    "Shared place"
  } else if kind == "run" {
    "Agent work"
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
fn placement_source_label(source : String) -> String {
  if source == "starter-map" {
    "already on your map"
  } else if source == "discover" {
    "placed from Discover"
  } else {
    "saved to your map"
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
