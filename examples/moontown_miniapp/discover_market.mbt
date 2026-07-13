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
        [@bunnia.class_name("moontown-discovery-primary-filters")],
        [
          discovery_filter_chip("all", "All"),
          discovery_filter_chip("building", "Places"),
          discovery_filter_chip("user", "People"),
          @bunnia.node(
            kind="button",
            attrs=[
              @bunnia.class_name(
                "moontown-discovery-more {{discover.moreOpen ? 'active' : ''}}",
              ),
              @bunnia.attr("aria-label", "Show more filters"),
            ],
            events=[@bunnia.tap("discover-more-open")],
            children=[@bunnia.text("More")],
          ),
        ],
      ),
      discover_more_filters(projection),
      discover_results_heading(projection, results),
      discover_results_list(projection, results),
    ],
  )
}

///|
fn discover_more_filters(projection : MiniTownProjection) -> @bunnia.Node {
  let filters : Array[MiniTownDiscoveryFilter] = []
  for filter in projection.discovery_filters {
    if filter.id != "all" && filter.id != "building" && filter.id != "user" {
      filters.push(filter)
    }
  }
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-discovery-more-panel"),
      @bunnia.attr("wx:if", "{{discover.moreOpen}}"),
    ],
    [
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-discovery-more-header")],
        [
          @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
            @bunnia.text("More filters"),
          ]),
          @bunnia.node(
            kind="button",
            attrs=[@bunnia.attr("aria-label", "Hide more filters")],
            events=[@bunnia.tap("discover-more-close")],
            children=[@bunnia.text("Close")],
          ),
        ],
      ),
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-discovery-secondary-filters")],
        [
          @bunnia.windowed_list(filters, total_count=filters.length(), render=filter => {
            discovery_filter_chip(filter.id, filter.label)
          }),
        ],
      ),
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
