///|
fn discover_results_list(
  projection : MiniTownProjection,
  results : Array[MiniTownDiscoveryItem],
) -> @bunnia.Node {
  if results.length() == 0 {
    @bunnia.view_with_attrs(
      [@bunnia.class_name("moontown-discovery-results")],
      [discover_empty_state()],
    )
  } else {
    @bunnia.view_with_attrs(
      [@bunnia.class_name("moontown-discovery-results")],
      [
        @bunnia.windowed_list(results, total_count=results.length(), render=item => {
          discover_entry(projection, item)
        }),
      ],
    )
  }
}

///|
fn discover_empty_state() -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-discover-empty")], [
    @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
      @bunnia.text("No public match"),
    ]),
    @bunnia.text("Change the search or filter."),
  ])
}

///|
fn discovery_filter_chip(
  filter : MiniTownDiscoveryFilter,
  _active_filter_id : String,
) -> @bunnia.Node {
  @bunnia.keyed(
    "discover-filter-\{filter.id}",
    @bunnia.node(
      kind="view",
      attrs=[
        @bunnia.class_name(
          "moontown-discovery-filter {{discover.filter == '\{filter.id}' ? 'active' : ''}}",
        ),
        @bunnia.data("filter-id", filter.id),
      ],
      events=[@bunnia.event("tap", "discover-filter-\{filter.id}")],
      children=[@bunnia.text(filter.label)],
    ),
  )
}
