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
