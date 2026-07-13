///|
fn town_top_bar(projection : MiniTownProjection) -> @bunnia.Node {
  if projection.active_tab_id == "my" {
    @bunnia.view([])
  } else {
    @bunnia.view_with_attrs([@bunnia.class_name("moontown-topbar")], [
      town_passport_entry(projection),
    ])
  }
}

///|
fn town_active_surface(projection : MiniTownProjection) -> @bunnia.Node {
  if projection.active_tab_id == "discover" {
    town_page_surface(projection, [discover_panel(projection)])
  } else if projection.active_tab_id == "messages" {
    town_page_surface(projection, messages_surface_panels(projection))
  } else if projection.active_tab_id == "my" {
    town_page_surface(projection, my_surface_panels(projection))
  } else if projection.active_tab_id == "home" {
    town_page_surface(projection, home_surface_panels(projection))
  } else {
    town_realm_overlay(projection)
  }
}

///|
fn town_page_surface(
  projection : MiniTownProjection,
  panels : Array[@bunnia.Node],
) -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name(
        "moontown-page-surface tab-\{projection.active_tab_id}",
      ),
      @bunnia.data("active-tab", projection.active_tab_id),
    ],
    [
      @bunnia.view_with_attrs(
        [
          @bunnia.class_name(
            town_page_grid_class(projection.active_tab_id, panels.length()),
          ),
        ],
        panels,
      ),
    ],
  )
}

///|
fn town_page_grid_class(tab_id : String, panel_count : Int) -> String {
  if tab_id == "my" {
    "moontown-page-grid moontown-my-layout"
  } else if tab_id == "messages" {
    "moontown-page-grid moontown-messages-layout"
  } else if panel_count == 1 {
    "moontown-page-grid single"
  } else if panel_count > 2 {
    "moontown-page-grid three"
  } else {
    "moontown-page-grid"
  }
}

///|
