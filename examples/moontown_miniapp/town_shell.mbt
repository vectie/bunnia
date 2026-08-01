///|
fn town_top_bar(projection : MiniTownProjection) -> @bunnia.Node {
  if projection.active_tab_id != "realm" {
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
      town_page_header(projection.active_tab_id),
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
fn town_page_header(tab_id : String) -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-page-header")], [
    @bunnia.view_with_attrs([@bunnia.class_name("moontown-page-title")], [
      @bunnia.text(town_page_title(tab_id)),
    ]),
    @bunnia.view_with_attrs([@bunnia.class_name("moontown-page-subtitle")], [
      @bunnia.text(town_page_subtitle(tab_id)),
    ]),
  ])
}

///|
fn town_page_title(tab_id : String) -> String {
  if tab_id == "home" {
    "Home"
  } else if tab_id == "discover" {
    "Discover"
  } else if tab_id == "messages" {
    "Inbox"
  } else {
    "My"
  }
}

///|
fn town_page_subtitle(tab_id : String) -> String {
  if tab_id == "home" {
    "Town pulse - what is happening now"
  } else if tab_id == "discover" {
    "Market board - find something useful"
  } else if tab_id == "messages" {
    "Updates and requests from your town"
  } else {
    "Inventory shelf - your place in town"
  }
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
