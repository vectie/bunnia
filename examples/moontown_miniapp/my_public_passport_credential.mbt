///|
fn profile_credential_plaque(projection : MiniTownProjection) -> @bunnia.Node {
  let district = profile_credential_district(projection)
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-credential-plaque"),
      @bunnia.data("district-id", district.id),
      @bunnia.data("feature-kind", district.feature_kind),
      @bunnia.data("target-building-id", district.building_id),
      @bunnia.data("status", district.status),
    ],
    [
      @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
        @bunnia.text("Town Credential"),
      ]),
      @bunnia.text("\{district.title}: \{district.summary}"),
      @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
        @bunnia.text(
          "\{district.stat_value} \{district.stat_label} - \{town_status_label(district.status)}",
        ),
      ]),
      open_place_button(district.building_id),
    ],
  )
}

///|
fn profile_credential_district(
  projection : MiniTownProjection,
) -> MiniTownDistrict {
  for district in projection.districts {
    if district.feature_kind == "credential" {
      return district
    }
  }
  projection.districts[0]
}
