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
      @bunnia.class_name("moontown-credential-plaque moontown-my-reviewer"),
      @bunnia.data("reviewer-tools-gate", "closed"),
    ],
    [
      @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
        @bunnia.text("Reviewer Tools"),
      ]),
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
