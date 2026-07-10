///|
fn ownership_backend_step(
  projection : MiniTownProjection,
) -> MiniTownBackendStep {
  for step in projection.backend_steps {
    if step.id == "ownership" {
      return step
    }
  }
  default_ownership_backend_step()
}

///|
fn default_ownership_backend_step() -> MiniTownBackendStep {
  mini_town_backend_step(
    id="ownership",
    label="Refresh My Stuff",
    endpoint_id="load-ownership-snapshot",
    http_method="GET",
    path="/miniapp/me/ownership",
    summary="Pull owned buildings, books, agents, placements, and alerts for My.",
    status="ready",
  )
}

///|
fn ownership_cache_state(
  projection : MiniTownProjection,
) -> MiniTownBackendCacheState {
  for cache in projection.backend_cache_states {
    if cache.id == "ownership" {
      return cache
    }
  }
  default_ownership_cache_state()
}

///|
fn default_ownership_cache_state() -> MiniTownBackendCacheState {
  mini_town_backend_cache_state(
    id="ownership",
    label="Ownership Snapshot",
    source="cache",
    state="idle",
    summary="My can reload owned buildings, books, agents, placements, and alerts.",
    target_ref="backend:load-ownership-snapshot",
    action_label="Sync",
    action_message="load-ownership-snapshot",
  )
}
