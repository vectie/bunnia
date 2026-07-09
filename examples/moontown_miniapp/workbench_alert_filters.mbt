///|
fn blocked_publication_count(projection : MiniTownProjection) -> Int {
  let mut count = 0
  for building in owned_buildings(projection) {
    if (
        building.visibility == "private_draft" ||
        building.visibility == "shared_private"
      ) &&
      !profile_ready_to_publish(projection) {
      count += 1
    }
  }
  count
}

///|
fn retryable_workbench_runs(
  projection : MiniTownProjection,
) -> Array[MiniTownRun] {
  let output : Array[MiniTownRun] = []
  for run in visible_runs(projection) {
    if run.status == "failed" ||
      run.status == "rejected" ||
      run.status == "cancelled" {
      output.push(run)
    }
  }
  output
}

///|
fn stale_backend_states(
  projection : MiniTownProjection,
) -> Array[MiniTownBackendCacheState] {
  let output : Array[MiniTownBackendCacheState] = []
  for state in projection.backend_cache_states {
    if state.state.contains("stale") ||
      state.state == "failed" ||
      state.state == "malformed" ||
      state.state == "cancelled" ||
      state.state == "retrying" {
      output.push(state)
    }
  }
  output
}
