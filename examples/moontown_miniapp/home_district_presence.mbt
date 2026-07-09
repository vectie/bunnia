///|
fn presence_chip(item : MiniTownPresence) -> @bunnia.Node {
  @bunnia.keyed(
    "presence-\{item.id}",
    @bunnia.node(
      kind="view",
      attrs=[
        @bunnia.class_name(
          "moontown-presence-chip bunnia-status-\{item.status}",
        ),
        @bunnia.data("presence-id", item.id),
        @bunnia.data("actor-kind", item.actor_kind),
        @bunnia.data("building-id", item.building_id),
      ],
      events=[@bunnia.event("tap", "select-\{item.building_id}")],
      children=[
        @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
          @bunnia.text(item.title),
        ]),
        @bunnia.text(item.subtitle),
      ],
    ),
  )
}
