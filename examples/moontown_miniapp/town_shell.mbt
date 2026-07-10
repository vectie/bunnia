///|
fn town_top_bar(projection : MiniTownProjection) -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-topbar")], [
    @bunnia.view_with_attrs([@bunnia.class_name("moontown-title-block")], [
      @bunnia.view_with_attrs([@bunnia.class_name("moontown-eyebrow")], [
        @bunnia.text("Moontown"),
      ]),
      @bunnia.view_with_attrs([@bunnia.class_name("moontown-title")], [
        @bunnia.text(town_screen_title(projection.active_tab_id)),
      ]),
      @bunnia.view_with_attrs([@bunnia.class_name("moontown-subtitle")], [
        @bunnia.text(town_screen_subtitle(projection.active_tab_id)),
      ]),
    ]),
    town_passport_entry(projection),
  ])
}

///|
fn town_active_surface(projection : MiniTownProjection) -> @bunnia.Node {
  if projection.active_tab_id == "discover" {
    town_page_surface(projection, [
      discover_panel(projection),
      district_panel(projection),
    ])
  } else if projection.active_tab_id == "messages" {
    town_page_surface(projection, [
      messages_panel(projection),
      run_queue_panel(projection),
      tool_result_panel(projection),
      review_queue_panel(projection),
    ])
  } else if projection.active_tab_id == "my" {
    town_page_surface(projection, my_surface_panels(projection))
  } else if projection.active_tab_id == "home" {
    town_page_surface(projection, [
      onboarding_panel(projection),
      home_pulse_panel(projection),
      home_district_gates_panel(projection),
    ])
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
      @bunnia.class_name("moontown-page-surface"),
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
