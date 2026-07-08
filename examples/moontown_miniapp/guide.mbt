///|
pub struct MiniTownGuideStep {
  id : String
  title : String
  summary : String
  tab_id : String
  action_label : String
  action_message : String
  building_id : String
  status : String
  complete : Bool
} derive(Debug, Eq)

///|
pub fn mini_town_guide_step(
  id~ : String,
  title~ : String,
  summary~ : String,
  tab_id~ : String,
  action_label~ : String,
  action_message~ : String,
  building_id~ : String,
  status~ : String,
  complete~ : Bool,
) -> MiniTownGuideStep {
  {
    id,
    title,
    summary,
    tab_id,
    action_label,
    action_message,
    building_id,
    status,
    complete,
  }
}

///|
pub fn guide_steps(projection : MiniTownProjection) -> Array[MiniTownGuideStep] {
  [
    mini_town_guide_step(
      id="enter-town",
      title="Enter The Tile Town",
      summary="Start from Realm, the existing full-screen Moontown map.",
      tab_id="realm",
      action_label="Enter",
      action_message="complete-onboarding",
      building_id="gateway",
      status=if projection.onboarding_completed { "stable" } else { "review" },
      complete=projection.onboarding_completed,
    ),
    mini_town_guide_step(
      id="town-pulse",
      title="Read Town Pulse",
      summary="Home turns community pages into district shortcuts and activity.",
      tab_id="home",
      action_label="Home",
      action_message="tab-home",
      building_id="market-square",
      status="running",
      complete=projection.active_tab_id == "home",
    ),
    mini_town_guide_step(
      id="discover-public",
      title="Find Public Places",
      summary="Discover searches buildings, people, agents, books, and circles.",
      tab_id="discover",
      action_label="Discover",
      action_message="tab-discover",
      building_id="market-square",
      status=if projection.search_query != "" { "stable" } else { "draft" },
      complete=projection.search_query != "",
    ),
    mini_town_guide_step(
      id="agent-mail",
      title="Review Agent Mail",
      summary="Messages collects runs, reviews, shares, and system notices.",
      tab_id="messages",
      action_label="Messages",
      action_message="tab-messages",
      building_id="policy-hall",
      status=if unread_notifications(projection).length() > 0 {
        "review"
      } else {
        "stable"
      },
      complete=unread_notifications(projection).length() > 0,
    ),
    mini_town_guide_step(
      id="passport",
      title="Finish Passport",
      summary="My holds profile readiness, owned work, publishing, and archives.",
      tab_id="my",
      action_label="My",
      action_message="tab-my",
      building_id="private-agent-lab",
      status=if profile_ready_to_publish(projection) {
        "stable"
      } else {
        "draft"
      },
      complete=profile_ready_to_publish(projection),
    ),
  ]
}
