///|
fn ownership_item_entry(item : MiniTownOwnershipItem) -> @bunnia.Node {
  @bunnia.keyed(
    "owned-\{item.id}",
    @bunnia.node(
      kind="view",
      attrs=[
        @bunnia.class_name("moontown-owned-entry"),
        @bunnia.data("ownership-kind", item.kind),
        @bunnia.attr("wx:if", ownership_item_visibility(item)),
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
        @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
          @bunnia.text(ownership_item_meta(item)),
        ]),
        ownership_item_place_button(item),
      ],
    ),
  )
}

///|
fn ownership_item_visibility(item : MiniTownOwnershipItem) -> String {
  "{{ownership.filter == 'all' || (ownership.filter == 'placements' && '\{item.kind}' == 'placement') || (ownership.filter == 'drafts' && '\{item.visibility}' == 'private_draft') || (ownership.filter == 'published' && '\{item.visibility}' == 'published') || (ownership.filter == 'books' && '\{item.kind}' == 'book') || (ownership.filter == 'agents' && '\{item.kind}' == 'agent') || (ownership.filter == 'watches' && '\{item.kind}' == 'watch')}}"
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
