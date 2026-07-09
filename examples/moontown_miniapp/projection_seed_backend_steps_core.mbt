///|
fn demo_backend_core_steps() -> Array[MiniTownBackendStep] {
  [
    mini_town_backend_step(
      id="login",
      label="Dev Login",
      endpoint_id="dev-login",
      http_method="POST",
      path="/miniapp/auth/dev-login",
      summary="Create or reuse a local user profile and session.",
      status="ready",
    ),
    mini_town_backend_step(
      id="snapshot",
      label="Load Snapshot",
      endpoint_id="load-town-snapshot",
      http_method="GET",
      path="/miniapp/town/snapshot",
      summary="Pull scoped buildings, books, agents, runs, and reviews.",
      status="ready",
    ),
    mini_town_backend_step(
      id="ownership",
      label="Sync Ownership",
      endpoint_id="load-ownership-snapshot",
      http_method="GET",
      path="/miniapp/me/ownership",
      summary="Pull owned buildings, books, agents, placements, and alerts for My.",
      status="ready",
    ),
    mini_town_backend_step(
      id="message-center",
      label="Sync Messages",
      endpoint_id="load-message-center",
      http_method="GET",
      path="/miniapp/messages/center",
      summary="Pull a filtered, cursor-windowed mail stream for Messages.",
      status="ready",
    ),
  ]
}
