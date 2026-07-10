///|
fn ownership_filter_chip(
  filter : MiniTownOwnershipFilter,
  active_filter_id : String,
) -> @bunnia.Node {
  @bunnia.keyed(
    "ownership-filter-\{filter.id}",
    @bunnia.node(
      kind="view",
      attrs=[
        @bunnia.class_name(ownership_filter_class(filter, active_filter_id)),
        @bunnia.data("ownership-filter-id", filter.id),
      ],
      events=[@bunnia.event("tap", "ownership-filter-\{filter.id}")],
      children=[@bunnia.text(filter.label)],
    ),
  )
}

///|
fn ownership_filter_class(
  filter : MiniTownOwnershipFilter,
  active_filter_id : String,
) -> String {
  if filter.id == active_filter_id {
    "moontown-ownership-filter active"
  } else {
    "moontown-ownership-filter"
  }
}
