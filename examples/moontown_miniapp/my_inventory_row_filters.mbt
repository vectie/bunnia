///|
fn ownership_filter_chip(
  filter : MiniTownOwnershipFilter,
  _active_filter_id : String,
) -> @bunnia.Node {
  @bunnia.keyed(
    "ownership-filter-\{filter.id}",
    @bunnia.node(
      kind="view",
      attrs=[
        @bunnia.class_name(
          "moontown-ownership-filter {{ownership.filter == '\{filter.id}' ? 'active' : ''}}",
        ),
        @bunnia.data("ownership-filter-id", filter.id),
      ],
      events=[@bunnia.event("tap", "ownership-filter-\{filter.id}")],
      children=[@bunnia.text(filter.label)],
    ),
  )
}
