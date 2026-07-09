///|
fn discover_results_list(
  projection : MiniTownProjection,
  results : Array[MiniTownDiscoveryItem],
) -> @bunnia.Node {
  if results.length() == 0 {
    discover_empty_state()
  } else {
    @bunnia.windowed_list(results, total_count=results.length(), render=item => {
      discover_entry(projection, item)
    })
  }
}

///|
fn discover_empty_state() -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-discover-empty")], [
    @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
      @bunnia.text("No public match"),
    ]),
    @bunnia.text("Try another search or choose a different market filter."),
  ])
}

///|
fn discover_spotlight_section(
  title : String,
  items : Array[MiniTownDiscoveryItem],
) -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-discovery-strip")], [
    @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
      @bunnia.text(title),
    ]),
    @bunnia.windowed_list(
      items,
      total_count=items.length(),
      render=discover_spotlight_chip,
    ),
  ])
}

///|
fn discover_spotlight_chip(item : MiniTownDiscoveryItem) -> @bunnia.Node {
  @bunnia.keyed(
    "discover-chip-\{item.id}",
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("moontown-discovery-chip"),
        @bunnia.data("discovery-kind", item.kind),
        @bunnia.data("target-ref", item.target_ref),
      ],
      [
        @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
          @bunnia.text(item.title),
        ]),
        @bunnia.text(town_status_label(item.status)),
      ],
    ),
  )
}

///|
fn discovery_filter_chip(
  filter : MiniTownDiscoveryFilter,
  active_filter_id : String,
) -> @bunnia.Node {
  @bunnia.keyed(
    "discover-filter-\{filter.id}",
    @bunnia.node(
      kind="view",
      attrs=[
        @bunnia.class_name(
          if filter.id == active_filter_id {
            "moontown-discovery-filter active"
          } else {
            "moontown-discovery-filter"
          },
        ),
        @bunnia.data("filter-id", filter.id),
      ],
      events=[@bunnia.event("tap", "discover-filter-\{filter.id}")],
      children=[@bunnia.text(filter.label)],
    ),
  )
}
