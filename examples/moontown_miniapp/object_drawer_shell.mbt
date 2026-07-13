///|
fn selected_building_drawer(projection : MiniTownProjection) -> @bunnia.Node {
  let building = selected_building(projection)
  @bunnia.view([
    selected_building_detail_drawer(projection, building),
    selected_building_summary_drawer(projection),
  ])
}

///|
fn selected_building_detail_drawer(
  projection : MiniTownProjection,
  building : MiniTownBuilding,
) -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name(
        "moontown-building-drawer moontown-object-drawer {{town.detailsOpen ? 'details-open' : 'compact'}} bunnia-status-\{building.status}",
      ),
      @bunnia.attr("wx:if", "{{town.selectedBuildingId == '\{building.id}'}}"),
      @bunnia.data("object-drawer", "building"),
      @bunnia.data("building-id", building.id),
    ],
    [
      building_object_header(projection, building),
      @bunnia.view_with_attrs(
        [
          @bunnia.class_name("moontown-object-details"),
          @bunnia.attr("wx:if", "{{town.detailsOpen}}"),
        ],
        [
          building_detail_actions(),
          building_memory_section(projection),
          building_worker_section(projection),
          building_lifecycle_section(projection),
          building_context_section(projection),
          safety_report_button(projection, building),
        ],
      ),
    ],
  )
}

///|
fn selected_building_summary_drawer(
  _projection : MiniTownProjection,
) -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-building-drawer moontown-object-drawer"),
      @bunnia.attr("wx:if", "{{town.selectedBuildingId != 'policy-hall'}}"),
      @bunnia.data("object-drawer", "building"),
    ],
    [
      @bunnia.view_with_attrs([@bunnia.class_name("moontown-object-header")], [
        @bunnia.view_with_attrs(
          [@bunnia.class_name("mt-title moontown-object-title")],
          [@bunnia.text(selected_building_title_binding())],
        ),
      ]),
    ],
  )
}

///|
fn selected_building_title_binding() -> String {
  "{{town.names[town.selectedBuildingId] || 'Place'}}"
}
