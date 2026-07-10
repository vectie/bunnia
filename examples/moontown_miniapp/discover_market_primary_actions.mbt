///|
fn discover_primary_action_button(item : MiniTownDiscoveryItem) -> @bunnia.Node {
  @bunnia.node(
    kind="button",
    attrs=[
      @bunnia.data("discovery-action", discover_primary_action_kind(item)),
      @bunnia.data("discovery-id", item.id),
      @bunnia.data("discovery-kind", item.kind),
      @bunnia.data("target-ref", item.target_ref),
    ],
    events=[@bunnia.tap("discover-action")],
    children=[@bunnia.text(discover_primary_action_label(item))],
  )
}

///|
fn discover_primary_action_kind(item : MiniTownDiscoveryItem) -> String {
  if item.kind == "demand" {
    "request"
  } else if item.kind == "event" || item.kind == "circle" {
    "join"
  } else if item.kind == "post" || item.kind == "book" {
    "read"
  } else {
    "open"
  }
}

///|
fn discover_primary_action_label(item : MiniTownDiscoveryItem) -> String {
  if item.kind == "product" {
    "Open Product"
  } else if item.kind == "demand" {
    "Answer Demand"
  } else if item.kind == "event" {
    "Join Event"
  } else if item.kind == "circle" {
    "Enter Circle"
  } else if item.kind == "post" {
    "Read Note"
  } else if item.kind == "book" {
    "Read Book"
  } else if item.kind == "agent" {
    "Open Agent"
  } else if item.kind == "user" {
    "View Profile"
  } else {
    "Open"
  }
}
