///|
fn home_district_gates_panel(projection : MiniTownProjection) -> @bunnia.Node {
  let presence = community_presence(projection)
  @bunnia.view_with_attrs(
    [@bunnia.class_name("mt-panel moontown-home-districts")],
    [
      @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-title")], [
        @bunnia.text("Town Gates"),
      ]),
      @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-note")], [
        @bunnia.text("Enter a district or see who is active nearby."),
      ]),
      @bunnia.view_with_attrs([@bunnia.class_name("moontown-district-grid")], [
        @bunnia.windowed_list(
          projection.districts,
          total_count=projection.districts.length(),
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
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-community-actions")],
        [
          @bunnia.button("Search Town", "tab-discover"),
          @bunnia.button("Publish Draft", "publish-private-building"),
        ],
      ),
    ],
  )
}
