///|
fn town_right_hud(projection : MiniTownProjection) -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-right-hud")], [
    selected_building_drawer(projection),
  ])
}

///|
fn town_realm_overlay(projection : MiniTownProjection) -> @bunnia.Node {
  town_right_hud(projection)
}

///|
fn selected_place_facts(
  projection : MiniTownProjection,
  building : MiniTownBuilding,
  agents : Array[MiniTownAgent],
  runs : Array[MiniTownRun],
) -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-place-facts")], [
    selected_place_fact(
      id="access",
      label="Access",
      value=town_visibility_label(building.visibility),
      status=building.status,
    ),
    selected_place_fact(
      id="placement",
      label="Placement",
      value=selected_building_placement_label(projection, building),
      status=building.status,
    ),
    selected_place_fact(
      id="workers",
      label="Workers",
      value=count_label(agents.length(), "worker", "workers"),
      status=building.status,
    ),
    selected_place_fact(
      id="work",
      label="Work",
      value=count_label(runs.length(), "item", "items"),
      status=building.status,
    ),
  ])
}

///|
fn selected_place_fact(
  id~ : String,
  label~ : String,
  value~ : String,
  status~ : String,
) -> @bunnia.Node {
  @bunnia.keyed(
    "map-state-\{id}",
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("moontown-place-fact bunnia-status-\{status}"),
        @bunnia.data("place-fact", id),
      ],
      [
        @bunnia.view_with_attrs(
          [@bunnia.class_name("moontown-place-fact-label")],
          [@bunnia.text(label)],
        ),
        @bunnia.view_with_attrs(
          [@bunnia.class_name("moontown-place-fact-value")],
          [@bunnia.text(value)],
        ),
      ],
    ),
  )
}

///|
fn selected_building_placement_label(
  projection : MiniTownProjection,
  building : MiniTownBuilding,
) -> String {
  match placement_for_building(projection, building.id) {
    Some(placement) =>
      if placement.status == "pinned" {
        "Pinned"
      } else {
        town_status_label(placement.status)
      }
    None =>
      if building.visibility == "published" {
        "Can place"
      } else {
        "Place private"
      }
  }
}
