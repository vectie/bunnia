///|
fn town_right_hud(projection : MiniTownProjection) -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-right-hud")], [
    selected_building_drawer(projection),
  ])
}

///|
fn town_realm_overlay(projection : MiniTownProjection) -> @bunnia.Node {
  @bunnia.view([town_right_hud(projection), town_bottom_hud(projection)])
}

///|
fn town_bottom_hud(projection : MiniTownProjection) -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-bottom-hud")], [
    realm_map_state_strip(projection),
  ])
}

///|
fn realm_map_state_strip(projection : MiniTownProjection) -> @bunnia.Node {
  let building = selected_building(projection)
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-map-state-strip")], [
    realm_map_state_chip(
      id="selected",
      label=building.title,
      value=map_marker_badge_label(building),
      status=building.status,
    ),
    realm_map_state_chip(
      id="access",
      label="Access",
      value=town_visibility_label(building.visibility),
      status=building.status,
    ),
    realm_map_state_chip(
      id="placement",
      label="Placement",
      value=selected_building_placement_label(projection, building),
      status=building.status,
    ),
    realm_map_state_chip(
      id="workers",
      label="Workers",
      value=count_label(
        selected_building_agents(projection).length(),
        "worker",
        "workers",
      ),
      status=building.status,
    ),
  ])
}

///|
fn realm_map_state_chip(
  id~ : String,
  label~ : String,
  value~ : String,
  status~ : String,
) -> @bunnia.Node {
  @bunnia.keyed(
    "map-state-\{id}",
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("moontown-map-state-chip bunnia-status-\{status}"),
        @bunnia.data("map-state", id),
      ],
      [@bunnia.text("\{label}: \{value}")],
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
