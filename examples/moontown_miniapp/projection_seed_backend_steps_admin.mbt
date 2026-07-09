///|
fn demo_backend_admin_steps() -> Array[MiniTownBackendStep] {
  [
    mini_town_backend_step(
      id="admin-ops",
      label="Ops",
      endpoint_id="load-admin-ops",
      http_method="GET",
      path="/miniapp/admin/ops",
      summary="Reviewer-only town counts, checks, incidents, holds, retention, and recovery status.",
      status="review",
    ),
    mini_town_backend_step(
      id="admin-readiness",
      label="Readiness",
      endpoint_id="load-admin-readiness",
      http_method="GET",
      path="/miniapp/admin/readiness",
      summary="Production checklist for WeChat login, domain, storage, monitoring, reviewers, and secrets.",
      status="guarded",
    ),
  ]
}
