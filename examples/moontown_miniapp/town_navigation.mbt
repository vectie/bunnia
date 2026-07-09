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
        @bunnia.class_name(
          if tab.id == active_tab_id {
            "moontown-tab-button active"
          } else {
            "moontown-tab-button"
          },
        ),
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
fn town_shell_actions(projection : MiniTownProjection) -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-shell-actions")], [
    @bunnia.text("Passport: \{projection.profile.display_name}"),
    @bunnia.button("Enter", "enter-town"),
    @bunnia.button("Realm", "tab-realm"),
    @bunnia.button("Passport", "tab-my"),
  ])
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
