///|
fn setup_gate_entry(item : MiniTownSetupGate) -> @bunnia.Node {
  @bunnia.keyed(
    "setup-gate-\{item.id}",
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("moontown-setup-gate bunnia-status-\{item.status}"),
        @bunnia.data("setup-gate", item.id),
        @bunnia.data("complete", if item.complete { "true" } else { "false" }),
      ],
      [
        @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
          @bunnia.text(item.label),
        ]),
        @bunnia.text(item.summary),
        @bunnia.button(item.action_label, item.action_message),
      ],
    ),
  )
}

///|
fn role_entry(role : MiniTownRole) -> @bunnia.Node {
  @bunnia.keyed(
    "role-\{role.id}",
    @bunnia.node(
      kind="view",
      attrs=[
        @bunnia.class_name("moontown-role-entry"),
        @bunnia.data("role-id", role.id),
        @bunnia.data("building-id", role.building_id),
      ],
      events=[@bunnia.event("tap", "select-role-\{role.id}")],
      children=[
        @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
          @bunnia.text(role.title),
        ]),
        @bunnia.text(role.summary),
      ],
    ),
  )
}
