///|
fn moontown_project_tab_root(tab_id : String) -> @bunnia.Node {
  if tab_id == "reviewer" {
    reviewer_route_view(
      open_reviewer_tools(switch_tab(demo_projection(), "my")),
    )
  } else {
    mini_town_route_view(switch_tab(demo_projection(), tab_id))
  }
}

///|
fn reviewer_route_view(projection : MiniTownProjection) -> @bunnia.Node {
  @bunnia.page([
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("moontown-miniapp"),
        @bunnia.data("reviewer-route", "true"),
      ],
      [
        @bunnia.view_with_attrs(
          [
            @bunnia.class_name("moontown-page-surface"),
            @bunnia.data("active-tab", "reviewer"),
          ],
          [operations_desk_panel(projection), reviewer_tools_back_button()],
        ),
      ],
    ),
  ])
}
