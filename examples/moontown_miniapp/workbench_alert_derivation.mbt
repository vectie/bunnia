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
        summary="Owned drafts and shared places need profile setup before publishing.",
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
        action_label="Refresh My Stuff",
        action_message="load-town-snapshot",
        status="stale",
      ),
    )
  }
  output
}
