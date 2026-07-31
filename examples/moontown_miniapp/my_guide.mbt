///|
fn town_guide_panel() -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("mt-panel moontown-town-guide"),
      @bunnia.data("guide-entry", "my"),
    ],
    [
      @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-title")], [
        @bunnia.text("Town Guide"),
      ]),
      @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
        @bunnia.text("A simple loop"),
      ]),
      @bunnia.text(
        "Discover a public place, open it in Realm, ask its agent, then review the result in Messages.",
      ),
      @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
        @bunnia.text(
          "My keeps your passport, owned work, publishing steps, and reviewer entry.",
        ),
      ]),
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-community-actions")],
        [
          @bunnia.node(
            kind="button",
            attrs=[town_route_attr("discover")],
            events=[@bunnia.tap("tab-discover")],
            children=[@bunnia.text("Start in Discover")],
          ),
          @bunnia.node(
            kind="button",
            attrs=[town_route_attr("messages")],
            events=[@bunnia.tap("tab-messages")],
            children=[@bunnia.text("Review Agent Work")],
          ),
        ],
      ),
    ],
  )
}
