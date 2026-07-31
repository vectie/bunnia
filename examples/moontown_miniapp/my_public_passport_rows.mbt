///|
fn public_passport_entry(item : MiniTownOwnershipItem) -> @bunnia.Node {
  let events : Array[@bunnia.EventBinding] = []
  let action_label = if item.kind == "profile" && item.status == "ready" {
    "Ready"
  } else {
    item.action_label
  }
  if item.kind != "profile" || item.status != "ready" {
    events.push(@bunnia.event("tap", item.action_message))
  }
  @bunnia.keyed(
    "public-passport-\{item.id}",
    @bunnia.node(
      kind="view",
      attrs=[
        @bunnia.class_name("moontown-owned-entry bunnia-status-\{item.status}"),
        @bunnia.data("passport-kind", item.kind),
      ],
      events~,
      children=[
        @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
          @bunnia.text(item.title),
        ]),
        @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
          @bunnia.text(
            "\{town_kind_label(item.kind)} - \{town_visibility_label(item.visibility)} - \{action_label}",
          ),
        ]),
      ],
    ),
  )
}
