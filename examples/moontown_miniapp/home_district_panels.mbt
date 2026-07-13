///|
fn home_district_gates_panel(projection : MiniTownProjection) -> @bunnia.Node {
  let presence = community_presence(projection)
  let districts = home_priority_districts(projection)
  @bunnia.view_with_attrs(
    [@bunnia.class_name("mt-panel moontown-home-districts")],
    [
      @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-title")], [
        @bunnia.text("Town Gates"),
      ]),
      @bunnia.view_with_attrs([@bunnia.class_name("moontown-district-grid")], [
        @bunnia.windowed_list(
          districts,
          total_count=districts.length(),
          render=district_entry,
        ),
      ]),
      @bunnia.view_with_attrs([@bunnia.class_name("moontown-section-label")], [
        @bunnia.text("Nearby now"),
      ]),
      @bunnia.view_with_attrs([@bunnia.class_name("moontown-presence-row")], [
        @bunnia.windowed_list(
          presence,
          total_count=presence.length(),
          render=presence_chip,
        ),
      ]),
    ],
  )
}

///|
fn home_priority_districts(
  projection : MiniTownProjection,
) -> Array[MiniTownDistrict] {
  let districts : Array[MiniTownDistrict] = []
  for district in projection.districts {
    if district.id == "product-market" ||
      district.id == "demand-hall" ||
      district.id == "opc-hub" {
      districts.push(district)
    }
  }
  districts
}
