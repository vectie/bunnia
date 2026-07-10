///|
// Market Board assembly stays compact; lists, entries, and actions live beside it.

///|
fn discover_panel(projection : MiniTownProjection) -> @bunnia.Node {
  let results = filtered_discovery_results(projection)
  @bunnia.view_with_attrs(
    [@bunnia.class_name("mt-panel moontown-discover-board")],
    [
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-discovery-search")],
        [
          @bunnia.input(
            name="discoverSearch",
            value=projection.search_query,
            input_message="discover-search",
          ),
          @bunnia.node(
            kind="button",
            attrs=[@bunnia.class_name("moontown-primary-action")],
            events=[@bunnia.tap("discover-search")],
            children=[@bunnia.text("Search")],
          ),
        ],
      ),
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-discovery-filters")],
        [
          @bunnia.windowed_list(
            projection.discovery_filters,
            total_count=projection.discovery_filters.length(),
            render=filter => {
              discovery_filter_chip(
                filter,
                projection.active_discovery_filter_id,
              )
            },
          ),
        ],
      ),
      discover_results_heading(projection, results),
      discover_results_list(projection, results),
    ],
  )
}

///|
fn discover_results_heading(
  projection : MiniTownProjection,
  results : Array[MiniTownDiscoveryItem],
) -> @bunnia.Node {
  let filter = selected_discovery_filter(projection)
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-results-heading")], [
    @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
      @bunnia.text("\{results.length()} matches"),
    ]),
    @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
      @bunnia.text(filter.label),
    ]),
  ])
}
