///|
pub fn demo_scene() -> @bunnia.Scene {
  let projection = demo_projection()
  @bunnia.scene(
    "moontown-map",
    @bunnia.scene_size(moontown_map_width(), moontown_map_height()),
    [demo_scene_district_layer(), demo_scene_building_layer(projection)],
    assets=demo_scene_assets(),
  )
}

///|
fn demo_scene_district_layer() -> @bunnia.SceneLayer {
  @bunnia.layer("districts", 1, [], regions=demo_scene_district_regions())
}

///|
fn demo_scene_building_layer(
  projection : MiniTownProjection,
) -> @bunnia.SceneLayer {
  @bunnia.layer(
    "buildings",
    2,
    markers_from_buildings(visible_buildings(projection)),
  )
}

///|
fn demo_scene_district_regions() -> Array[@bunnia.SceneRegion] {
  [
    @bunnia.region(
      id="central",
      label="Central",
      x=430,
      y=250,
      width=420,
      height=270,
      status="stable",
      tap_message="select-policy-hall",
    ),
    @bunnia.region(
      id="east-market",
      label="East Market",
      x=820,
      y=420,
      width=360,
      height=260,
      status="running",
      tap_message="select-market-square",
    ),
  ]
}
