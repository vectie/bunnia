///|
fn selected_building_drawer(projection : MiniTownProjection) -> @bunnia.Node {
  let building = selected_building(projection)
  let book = selected_building_book(projection)
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name(
        "moontown-building-drawer moontown-object-drawer bunnia-status-\{building.status}",
      ),
      @bunnia.data("object-drawer", "building"),
      @bunnia.data("building-id", building.id),
    ],
    [
      building_object_header(projection, building, book),
      building_memory_section(projection),
      building_worker_section(projection),
      building_lifecycle_section(projection),
      building_context_section(projection),
      safety_report_button(projection, building),
    ],
  )
}
