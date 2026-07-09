///|
fn home_district_gates_panel(projection : MiniTownProjection) -> @bunnia.Node {
  let presence = community_presence(projection)
  @bunnia.view_with_attrs([@bunnia.class_name("mt-panel")], [
    @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-title")], [
      @bunnia.text("District Gates"),
    ]),
    @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-note")], [
      @bunnia.text(
        "Market, messages, events, guides, and trust work open from this town board.",
      ),
    ]),
    @bunnia.windowed_list(
      projection.districts,
      total_count=projection.districts.length(),
      render=district_entry,
    ),
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
  ])
}

///|
fn district_panel(projection : MiniTownProjection) -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("mt-panel")], [
    @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-title")], [
      @bunnia.text("Map Districts"),
    ]),
    @bunnia.windowed_list(
      projection.districts,
      total_count=projection.districts.length(),
      render=district_entry,
    ),
  ])
}
