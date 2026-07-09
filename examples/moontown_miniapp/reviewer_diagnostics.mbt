///|
fn moderation_desk_panel(projection : MiniTownProjection) -> @bunnia.Node {
  let cases = projection.moderation_cases
  @bunnia.view_with_attrs([@bunnia.class_name("mt-panel")], [
    @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-title")], [
      @bunnia.text("Moderation Desk"),
    ]),
    @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-note")], [
      @bunnia.text(
        "\{cases.length()} report case; hide or takedown stays audited.",
      ),
    ]),
    @bunnia.windowed_list(
      cases,
      total_count=cases.length(),
      render=moderation_case_entry,
    ),
  ])
}

///|
fn moderation_case_entry(item : MiniTownModerationCase) -> @bunnia.Node {
  @bunnia.keyed(
    "moderation-\{item.id}",
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("moontown-review-entry bunnia-status-\{item.status}"),
        @bunnia.data("moderation-case", item.id),
        @bunnia.data("building-id", item.building_id),
        @bunnia.data("target-ref", item.target_ref),
        @bunnia.data("reporter-id", item.reporter_id),
      ],
      [
        @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
          @bunnia.text(item.title),
        ]),
        @bunnia.text(item.summary),
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-run-actions")], [
          moderation_case_action_button(item),
          moderation_button(item, "Hide", "hide", "hide-public-building"),
          moderation_button(
            item, "Takedown", "takedown", "takedown-public-building",
          ),
        ]),
      ],
    ),
  )
}

///|
fn moderation_case_action_button(item : MiniTownModerationCase) -> @bunnia.Node {
  moderation_button(
    item,
    item.action_label,
    moderation_case_action_id(item),
    item.action_message,
  )
}

///|
fn moderation_case_action_id(item : MiniTownModerationCase) -> String {
  if item.action_message == "appeal-moderation-case" {
    "appeal"
  } else {
    "review"
  }
}

///|
fn moderation_button(
  item : MiniTownModerationCase,
  label : String,
  action : String,
  message : String,
) -> @bunnia.Node {
  @bunnia.node(
    kind="button",
    attrs=[
      @bunnia.class_name("moontown-run-action stable"),
      @bunnia.data("moderation-action", action),
      @bunnia.data("moderation-case", item.id),
      @bunnia.data("building-id", item.building_id),
    ],
    events=[@bunnia.tap(message)],
    children=[@bunnia.text(label)],
  )
}

///|
fn reviewer_tools_back_button() -> @bunnia.Node {
  @bunnia.node(
    kind="button",
    attrs=[@bunnia.data("bunnia-route", "pages/moontown/my")],
    events=[@bunnia.tap("tab-my")],
    children=[@bunnia.text("Back to My")],
  )
}

///|
fn operations_desk_panel(projection : MiniTownProjection) -> @bunnia.Node {
  let ops = backend_step_by_id(projection, "admin-ops")
  let readiness = backend_step_by_id(projection, "admin-readiness")
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-credential-plaque"),
      @bunnia.data("ops-desk", "admin"),
      @bunnia.data("diagnostics-mode", "reviewer"),
      @bunnia.data("diagnostics-source", "reviewer-route"),
      @bunnia.data("backend-step", ops.id),
      @bunnia.data("backend-endpoint", ops.endpoint_id),
      @bunnia.data("backend-readiness-endpoint", readiness.endpoint_id),
      @bunnia.data("backend-path", ops.path),
      @bunnia.data("backend-readiness-path", readiness.path),
    ],
    [
      @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
        @bunnia.text("Reviewer Tools"),
      ]),
      @bunnia.text(
        "Reviewer Mode keeps safety, launch, and developer diagnostics behind this deliberate entry.",
      ),
      @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
        @bunnia.text(
          "Source: reviewer route - ordinary town pages stay product-only",
        ),
      ]),
      reviewer_diagnostics_section("Town Safety", ops, [
        "health", "incidents", "holds", "audit retention", "backup", "recovery",
        "rate-limit bucket",
      ]),
      reviewer_diagnostics_section("Launch Checks", readiness, [
        "WeChat login", "domain", "storage", "monitoring", "reviewers", "secrets",
      ]),
      reviewer_action_section(),
      moderation_desk_panel(projection),
      developer_diagnostics_section(ops, readiness),
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-community-actions")],
        [
          @bunnia.button("Check Town Safety", ops.endpoint_id),
          @bunnia.button("Launch Checks", readiness.endpoint_id),
        ],
      ),
    ],
  )
}

///|
fn reviewer_diagnostics_section(
  title : String,
  step : MiniTownBackendStep,
  checks : Array[String],
) -> @bunnia.Node {
  let items = []
  for check in checks {
    items.push(
      @bunnia.view_with_attrs(
        [
          @bunnia.class_name("moontown-diagnostic-row"),
          @bunnia.data("diagnostic-check", check),
        ],
        [
          @bunnia.text(check),
          @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
            @bunnia.text(town_status_label(step.status)),
          ]),
        ],
      ),
    )
  }
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-diagnostic-section"),
      @bunnia.data("diagnostic-section", title),
      @bunnia.data("backend-step", step.id),
    ],
    [
      @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
        @bunnia.text(title),
      ]),
      @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
        @bunnia.text(step.summary),
      ]),
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-diagnostic-list")],
        items,
      ),
    ],
  )
}

///|
fn reviewer_action_section() -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-diagnostic-section"),
      @bunnia.data("diagnostic-section", "reviewer-actions"),
    ],
    [
      @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
        @bunnia.text("Reviewer Actions"),
      ]),
      @bunnia.text(
        "Review, hide, takedown, release hold, resolve incident, and check readiness.",
      ),
    ],
  )
}

///|
fn developer_diagnostics_section(
  ops : MiniTownBackendStep,
  readiness : MiniTownBackendStep,
) -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-diagnostic-section"),
      @bunnia.data("diagnostic-section", "developer"),
      @bunnia.data("developer-diagnostics", "local-explicit"),
      @bunnia.data("ops-endpoint", ops.endpoint_id),
      @bunnia.data("readiness-endpoint", readiness.endpoint_id),
    ],
    [
      @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
        @bunnia.text("Developer Diagnostics"),
      ]),
      @bunnia.text(
        "Endpoint id, HTTP path, payload key, response key, package diagnostics, and render diagnostics stay visible only here.",
      ),
      diagnostic_contract_row(
        "Town Safety", ops, "adminOpsQuery", "adminOpsResult",
      ),
      diagnostic_contract_row(
        "Launch Checks", readiness, "adminReadinessQuery", "adminReadinessResult",
      ),
    ],
  )
}

///|
fn diagnostic_contract_row(
  label : String,
  step : MiniTownBackendStep,
  payload_key : String,
  response_key : String,
) -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-diagnostic-row"),
      @bunnia.data("diagnostic-contract", step.id),
      @bunnia.data("endpoint-id", step.endpoint_id),
      @bunnia.data("http-method", step.http_method),
      @bunnia.data("http-path", step.path),
      @bunnia.data("payload-key", payload_key),
      @bunnia.data("response-key", response_key),
    ],
    [
      @bunnia.text(label),
      @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
        @bunnia.text(
          "\{step.endpoint_id} - \{step.http_method} \{step.path} - payload \{payload_key} - response \{response_key}",
        ),
      ]),
    ],
  )
}

///|
fn backend_step_by_id(
  projection : MiniTownProjection,
  id : String,
) -> MiniTownBackendStep {
  for step in projection.backend_steps {
    if step.id == id {
      return step
    }
  }
  mini_town_backend_step(
    id~,
    label=id,
    endpoint_id=id,
    http_method="GET",
    path="/miniapp/admin/ops",
    summary="Missing backend step.",
    status="missing",
  )
}
