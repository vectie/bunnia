///|
// Market Board assembly stays compact; lists, entries, and actions live beside it.

///|
fn discover_panel(projection : MiniTownProjection) -> @bunnia.Node {
  let results = filtered_discovery_results(projection)
  let people = discovery_results_by_kind(projection, "user")
  let circles = discovery_results_by_kind(projection, "circle")
  let market = market_discovery_results(projection)
  @bunnia.view_with_attrs(
    [@bunnia.class_name("mt-panel moontown-discover-board")],
    [
      @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-title")], [
        @bunnia.text("Market Board"),
      ]),
      @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-note")], [
        @bunnia.text(
          "Find something useful, then open it or bring it into town.",
        ),
      ]),
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
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-discovery-browse")],
        [
          @bunnia.view_with_attrs(
            [@bunnia.class_name("moontown-section-label")],
            [@bunnia.text("Browse Town")],
          ),
          discover_spotlight_section("People", people),
          discover_spotlight_section("Circles", circles),
          discover_spotlight_section("Market", market),
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
    @bunnia.text("\{filter.label} in the public town market."),
  ])
}
