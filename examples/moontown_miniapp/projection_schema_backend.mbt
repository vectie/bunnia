///|
pub struct MiniTownBackendStep {
  id : String
  label : String
  endpoint_id : String
  http_method : String
  path : String
  summary : String
  status : String
} derive(Debug, Eq)

///|
pub struct MiniTownBackendCacheState {
  id : String
  label : String
  source : String
  state : String
  summary : String
  target_ref : String
  action_label : String
  action_message : String
} derive(Debug, Eq)

///|
pub fn mini_town_backend_step(
  id~ : String,
  label~ : String,
  endpoint_id~ : String,
  http_method~ : String,
  path~ : String,
  summary~ : String,
  status~ : String,
) -> MiniTownBackendStep {
  { id, label, endpoint_id, http_method, path, summary, status }
}

///|
pub fn mini_town_backend_cache_state(
  id~ : String,
  label~ : String,
  source~ : String,
  state~ : String,
  summary~ : String,
  target_ref~ : String,
  action_label? : String = "Open",
  action_message? : String = "load-town-snapshot",
) -> MiniTownBackendCacheState {
  {
    id,
    label,
    source,
    state,
    summary,
    target_ref,
    action_label,
    action_message,
  }
}
