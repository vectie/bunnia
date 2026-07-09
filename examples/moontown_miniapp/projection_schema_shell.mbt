///|
pub struct MiniTownTab {
  id : String
  label : String
  map_surface : Bool
} derive(Debug, Eq)

///|
pub struct MiniTownOnboardingStep {
  id : String
  title : String
  body : String
  building_id : String
} derive(Debug, Eq)

///|
pub struct MiniTownDistrict {
  id : String
  title : String
  feature_kind : String
  building_id : String
  summary : String
  stat_label : String
  stat_value : String
  action_label : String
  action_message : String
  discovery_filter_id : String
  search_query : String
  accent : String
  status : String
} derive(Debug, Eq)

///|
pub struct MiniTownPresence {
  id : String
  title : String
  subtitle : String
  actor_kind : String
  building_id : String
  status : String
} derive(Debug, Eq)

///|
pub fn mini_town_tab(
  id~ : String,
  label~ : String,
  map_surface? : Bool = false,
) -> MiniTownTab {
  { id, label, map_surface }
}

///|
pub fn mini_town_onboarding_step(
  id~ : String,
  title~ : String,
  body~ : String,
  building_id~ : String,
) -> MiniTownOnboardingStep {
  { id, title, body, building_id }
}

///|
pub fn mini_town_district(
  id~ : String,
  title~ : String,
  feature_kind~ : String,
  building_id~ : String,
  summary~ : String,
  stat_label~ : String,
  stat_value~ : String,
  action_label~ : String,
  status~ : String,
  action_message? : String = "",
  discovery_filter_id? : String = "all",
  search_query? : String = "",
  accent? : String = "blue",
) -> MiniTownDistrict {
  {
    id,
    title,
    feature_kind,
    building_id,
    summary,
    stat_label,
    stat_value,
    action_label,
    action_message,
    discovery_filter_id,
    search_query,
    accent,
    status,
  }
}

///|
pub fn mini_town_presence(
  id~ : String,
  title~ : String,
  subtitle~ : String,
  actor_kind~ : String,
  building_id~ : String,
  status~ : String,
) -> MiniTownPresence {
  { id, title, subtitle, actor_kind, building_id, status }
}
