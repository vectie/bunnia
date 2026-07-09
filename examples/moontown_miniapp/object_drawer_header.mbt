///|
fn building_object_header(
  projection : MiniTownProjection,
  building : MiniTownBuilding,
  book : MiniTownBook,
) -> @bunnia.Node {
  let shelf = selected_building_book_shelf(projection)
  let agents = selected_building_agents(projection)
  let runs = selected_building_runs(projection)
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-object-header")], [
    @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
      @bunnia.text(building.title),
    ]),
    @bunnia.text(building.summary),
    @bunnia.view_with_attrs([@bunnia.class_name("moontown-object-badges")], [
      object_badge("category", town_kind_label(building.kind)),
      object_badge("owner", building_owner_label(projection, building)),
      object_badge("visibility", town_visibility_label(building.visibility)),
      object_badge("status", town_status_label(building.status)),
    ]),
    object_stats_row(shelf, agents, runs),
    building_primary_actions(building),
    @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
      @bunnia.text(
        "\{building_capability_label(projection, building)} - Primary book: \{book.title}",
      ),
    ]),
  ])
}
