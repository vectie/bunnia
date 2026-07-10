///|
fn public_passport_entry(item : MiniTownOwnershipItem) -> @bunnia.Node {
  @bunnia.keyed(
    "public-passport-\{item.id}",
    @bunnia.node(
      kind="view",
      attrs=[
        @bunnia.class_name("moontown-owned-entry bunnia-status-\{item.status}"),
        @bunnia.data("passport-kind", item.kind),
      ],
      events=[@bunnia.event("tap", item.action_message)],
      children=[
        @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
          @bunnia.text(item.title),
        ]),
        @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
          @bunnia.text(
            "\{town_kind_label(item.kind)} - \{town_visibility_label(item.visibility)} - \{item.action_label}",
          ),
        ]),
      ],
    ),
  )
}
