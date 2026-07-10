///|
fn ownership_item_entry(item : MiniTownOwnershipItem) -> @bunnia.Node {
  @bunnia.keyed(
    "owned-\{item.id}",
    @bunnia.node(
      kind="view",
      attrs=[
        @bunnia.class_name("moontown-owned-entry"),
        @bunnia.data("ownership-kind", item.kind),
        @bunnia.data(
          "ownership-destination",
          town_tab_label(ownership_item_target_tab(item)),
        ),
      ],
      events=[@bunnia.event("tap", item.action_message)],
      children=[
        @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
          @bunnia.text(item.title),
        ]),
        @bunnia.text(item.summary),
        @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
          @bunnia.text(ownership_item_meta(item)),
        ]),
        ownership_item_place_button(item),
      ],
    ),
  )
}

///|
fn ownership_item_meta(item : MiniTownOwnershipItem) -> String {
  "\{town_kind_label(item.kind)} - \{town_visibility_label(item.visibility)} - \{item.action_label} in \{town_tab_label(ownership_item_target_tab(item))}"
}

///|
fn ownership_item_place_button(item : MiniTownOwnershipItem) -> @bunnia.Node {
  let building_id = ownership_item_building_id(item)
  if high_leverage_place_route(building_id) {
    open_place_button(building_id)
  } else {
    @bunnia.view([])
  }
}
