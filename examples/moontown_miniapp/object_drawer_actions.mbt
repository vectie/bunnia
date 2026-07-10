///|
fn building_primary_actions(building : MiniTownBuilding) -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-object-primary-actions"),
      @bunnia.data("building-id", building.id),
    ],
    [
      drawer_header_action(
        "Ask", "ask-selected-building", "moontown-primary-action",
      ),
      drawer_header_action(
        "Messages", "tab-messages", "moontown-secondary-action",
      ),
      drawer_header_action(
        "Find Similar", "tab-discover", "moontown-secondary-action",
      ),
    ],
  )
}

///|
fn drawer_header_action(
  label : String,
  message : String,
  emphasis : String,
) -> @bunnia.Node {
  @bunnia.node(
    kind="button",
    attrs=[@bunnia.class_name(emphasis)],
    events=[@bunnia.tap(message)],
    children=[@bunnia.text(label)],
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
      @bunnia.class_name("moontown-drawer-report moontown-danger-action"),
      @bunnia.data("safety-report-building", building.id),
      @bunnia.data("safety-report-count", cases.length().to_string()),
    ],
    events=[@bunnia.tap("report-public-building")],
    children=[@bunnia.text("Report Concern")],
  )
}
