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
