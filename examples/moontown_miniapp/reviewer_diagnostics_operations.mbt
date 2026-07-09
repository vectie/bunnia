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
