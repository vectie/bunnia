///|
fn building_object_header(
  projection : MiniTownProjection,
  building : MiniTownBuilding,
) -> @bunnia.Node {
  let agents = selected_building_agents(projection)
  let runs = selected_building_runs(projection)
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-object-header")], [
    @bunnia.view_with_attrs([@bunnia.class_name("moontown-object-kicker")], [
      object_badge("status", town_status_label(building.status)),
    ]),
    @bunnia.view_with_attrs(
      [@bunnia.class_name("mt-title moontown-object-title")],
      [@bunnia.text(building.title)],
    ),
    @bunnia.text(building.summary),
    @bunnia.view_with_attrs([@bunnia.class_name("moontown-object-badges")], [
      object_badge("category", town_kind_label(building.kind)),
      object_badge("owner", building_owner_label(projection, building)),
    ]),
    selected_place_facts(projection, building, agents, runs),
    building_primary_actions(building),
  ])
}
