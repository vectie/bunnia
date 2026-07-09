///|
fn building_worker_section(projection : MiniTownProjection) -> @bunnia.Node {
  let agents = selected_building_agents(projection)
  let building = selected_building(projection)
  object_section(
    section_id="worker",
    title="Agent Workers",
    note="Workers show role, status, latest work, and the next message action.",
    extra_class="moontown-worker-section",
    children=[
      @bunnia.view_with_attrs([@bunnia.data("building-id", building.id)], [
        worker_list_content(projection, agents),
      ]),
    ],
  )
}

///|
fn worker_list_content(
  projection : MiniTownProjection,
  agents : Array[MiniTownAgent],
) -> @bunnia.Node {
  if agents.length() == 0 {
    empty_worker_state()
  } else {
    @bunnia.list(agents, agent => building_worker_entry(projection, agent))
  }
}

///|
fn empty_worker_state() -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
    @bunnia.text("No agent worker is attached yet."),
  ])
}
