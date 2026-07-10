///|
fn town_tabbar(projection : MiniTownProjection) -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-tabbar")], [
    @bunnia.list(projection.tabs, fn(tab) {
      tab_button(tab, projection.active_tab_id)
    }),
  ])
}

///|
fn tab_button(tab : MiniTownTab, active_tab_id : String) -> @bunnia.Node {
  @bunnia.keyed(
    "tab-\{tab.id}",
    @bunnia.node(
      kind="button",
      attrs=[
        @bunnia.class_name(tab_button_class(tab, active_tab_id)),
        @bunnia.data("tab-id", tab.id),
        @bunnia.data("bunnia-route", moontown_tab_route(tab.id)),
        @bunnia.data(
          "map-surface",
          if tab.map_surface {
            "true"
          } else {
            "false"
          },
        ),
      ],
      events=[@bunnia.tap("tab-\{tab.id}")],
      children=[@bunnia.text(tab.label)],
    ),
  )
}

///|
fn tab_button_class(tab : MiniTownTab, active_tab_id : String) -> String {
  let surface = if tab.map_surface { " map-surface" } else { "" }
  let active = if tab.id == active_tab_id { " active" } else { "" }
  "moontown-tab-button\{surface}\{active}"
}

///|
fn town_passport_entry(projection : MiniTownProjection) -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-passport-switch")], [
    town_entry_button(),
    town_profile_button(projection),
  ])
}

///|
fn town_entry_button() -> @bunnia.Node {
  @bunnia.node(
    kind="button",
    attrs=[
      @bunnia.class_name("moontown-entry-button"),
      @bunnia.attr("wx:if", "{{!bunniaSessionId}}"),
    ],
    events=[@bunnia.tap("dev-login")],
    children=[
      @bunnia.view_with_attrs([@bunnia.class_name("moontown-passport-name")], [
        @bunnia.text("Enter Town"),
      ]),
      @bunnia.view_with_attrs([@bunnia.class_name("moontown-passport-state")], [
        @bunnia.text("First visit"),
      ]),
    ],
  )
}

///|
fn town_profile_button(projection : MiniTownProjection) -> @bunnia.Node {
  @bunnia.node(
    kind="button",
    attrs=[
      @bunnia.class_name("moontown-passport-entry"),
      @bunnia.attr("wx:if", "{{bunniaSessionId}}"),
      @bunnia.data("bunnia-route", moontown_tab_route("my")),
      @bunnia.data(
        "passport-ready",
        if profile_ready_to_publish(projection) {
          "true"
        } else {
          "false"
        },
      ),
    ],
    events=[@bunnia.tap("tab-my")],
    children=[
      @bunnia.view_with_attrs([@bunnia.class_name("moontown-passport-name")], [
        @bunnia.text(projection.profile.display_name),
      ]),
      @bunnia.view_with_attrs([@bunnia.class_name("moontown-passport-state")], [
        @bunnia.text(ready_word(profile_ready_to_publish(projection))),
      ]),
    ],
  )
}

///|
fn create_drawer(_projection : MiniTownProjection) -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-create-drawer")], [
    @bunnia.form("create-private-building", [
      @bunnia.input(name="buildingTitle", value="New Agent Lab"),
      @bunnia.button("Create Building", "create-private-building"),
    ]),
    @bunnia.form("create-agent", [
      @bunnia.input(name="agentName", value="New Agent"),
      @bunnia.button("Create Agent", "create-agent"),
    ]),
  ])
}

///|
