///|
fn reviewer_tools_panel(projection : MiniTownProjection) -> @bunnia.Node {
  if projection.reviewer_tools_open {
    operations_desk_panel(projection)
  } else {
    reviewer_tools_gate_panel()
  }
}

///|
fn reviewer_tools_gate_panel() -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-credential-plaque"),
      @bunnia.data("reviewer-tools-gate", "closed"),
    ],
    [
      @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
        @bunnia.text("Reviewer Tools"),
      ]),
      @bunnia.text(
        "Safety checks and launch tools stay behind a deliberate reviewer entry.",
      ),
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-community-actions")],
        [reviewer_tools_open_button()],
      ),
    ],
  )
}

///|
fn reviewer_tools_open_button() -> @bunnia.Node {
  @bunnia.node(
    kind="button",
    attrs=[@bunnia.data("bunnia-route", "pages/moontown/reviewer")],
    events=[@bunnia.tap("open-reviewer-tools")],
    children=[@bunnia.text("Open Reviewer Tools")],
  )
}

///|
fn inventory_refresh_plaque(projection : MiniTownProjection) -> @bunnia.Node {
  let step = ownership_backend_step(projection)
  let cache = ownership_cache_state(projection)
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-credential-plaque"),
      @bunnia.data("inventory-refresh", town_status_label(cache.state)),
    ],
    [
      @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
        @bunnia.text("Inventory Refresh"),
      ]),
      @bunnia.text("Bring in owned places, books, agents, pins, and alerts."),
      @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
        @bunnia.text("My Inventory - \{town_status_label(cache.state)}"),
      ]),
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-community-actions")],
        [@bunnia.button("Refresh My Stuff", step.endpoint_id)],
      ),
    ],
  )
}

///|
fn ownership_backend_step(
  projection : MiniTownProjection,
) -> MiniTownBackendStep {
  for step in projection.backend_steps {
    if step.id == "ownership" {
      return step
    }
  }
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
