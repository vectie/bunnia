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
        "Details", "open-place-details", "moontown-secondary-action",
      ),
    ],
  )
}

///|
fn building_detail_actions() -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [@bunnia.class_name("moontown-object-detail-actions")],
    [
      drawer_header_action(
        "Messages", "tab-messages", "moontown-secondary-action",
      ),
      drawer_header_action(
        "Find Similar", "tab-discover", "moontown-secondary-action",
      ),
      drawer_header_action(
        "Back to map", "close-place-details", "moontown-secondary-action",
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
  let attrs = [@bunnia.class_name(emphasis)]
  if message == "tab-messages" {
    attrs.push(town_route_attr("messages"))
  } else if message == "tab-discover" {
    attrs.push(town_route_attr("discover"))
  }
  @bunnia.node(kind="button", attrs~, events=[@bunnia.tap(message)], children=[
    @bunnia.text(label),
  ])
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
