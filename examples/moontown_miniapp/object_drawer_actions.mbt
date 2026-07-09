///|
fn building_primary_actions(building : MiniTownBuilding) -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-object-primary-actions"),
      @bunnia.data("building-id", building.id),
    ],
    [
      @bunnia.button("Ask", "ask-selected-building"),
      @bunnia.button("Messages", "tab-messages"),
      @bunnia.button("Find Similar", "tab-discover"),
    ],
  )
}

///|
fn safety_report_button(
  projection : MiniTownProjection,
  building : MiniTownBuilding,
) -> @bunnia.Node {
  let cases = selected_building_moderation_cases(projection)
  @bunnia.node(
    kind="button",
    attrs=[
      @bunnia.class_name("moontown-notice-action"),
      @bunnia.data("safety-report-building", building.id),
      @bunnia.data("safety-report-count", cases.length().to_string()),
    ],
    events=[@bunnia.tap("report-public-building")],
    children=[@bunnia.text("Report Concern")],
  )
}
