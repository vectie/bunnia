///|
pub struct MiniTownWorkbenchAlert {
  id : String
  title : String
  summary : String
  target_ref : String
  severity : String
  action_label : String
  action_message : String
  status : String
} derive(Debug, Eq)

///|
pub fn mini_town_workbench_alert(
  id~ : String,
  title~ : String,
  summary~ : String,
  target_ref~ : String,
  severity~ : String,
  action_label~ : String,
  action_message~ : String,
  status~ : String,
) -> MiniTownWorkbenchAlert {
  {
    id,
    title,
    summary,
    target_ref,
    severity,
    action_label,
    action_message,
    status,
  }
}

///|
pub fn workbench_alerts(
  projection : MiniTownProjection,
) -> Array[MiniTownWorkbenchAlert] {
  let output : Array[MiniTownWorkbenchAlert] = []
  if !profile_ready_to_publish(projection) {
    output.push(
      mini_town_workbench_alert(
        id="profile-setup",
        title="Town passport incomplete",
        summary="Finish role, consent, and profile setup before public publishing.",
        target_ref="profile:setup",
        severity="warning",
        action_label="Finish Setup",
        action_message="save-profile",
        status="review",
      ),
    )
  }
  let blocked_publications = blocked_publication_count(projection)
  if blocked_publications > 0 {
    output.push(
      mini_town_workbench_alert(
        id="blocked-publication",
        title="\{blocked_publications} draft blocked from town",
        summary="Owned draft or shared-private buildings need profile readiness before publish.",
        target_ref="building:publication",
        severity="warning",
        action_label="Open Drafts",
        action_message="ownership-filter-drafts",
        status="blocked",
      ),
    )
  }
  let retry_runs = retryable_workbench_runs(projection)
  if retry_runs.length() > 0 {
    output.push(
      mini_town_workbench_alert(
        id="retry-runs",
        title="\{retry_runs.length()} agent work item needs retry",
        summary="Failed, rejected, or cancelled agent work should be retried from Messages.",
        target_ref="run:\{retry_runs[0].id}",
        severity="danger",
        action_label="Review Work",
        action_message="tab-messages",
        status="failed",
      ),
    )
  }
  let stale_backends = stale_backend_states(projection)
  if stale_backends.length() > 0 {
    output.push(
      mini_town_workbench_alert(
        id="stale-backend",
        title="\{stale_backends.length()} update needs refresh",
        summary="Some town updates could not finish. Refresh to recover.",
        target_ref=stale_backends[0].target_ref,
        severity="notice",
        action_label="Refresh Town",
        action_message="load-town-snapshot",
        status="stale",
      ),
    )
  }
  output
}

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
