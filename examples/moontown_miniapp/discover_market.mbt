///|
// Market Board assembly stays compact; lists, entries, and actions live beside it.

///|
fn discover_panel(projection : MiniTownProjection) -> @bunnia.Node {
  let results = filtered_discovery_results(projection)
  let people = discovery_results_by_kind(projection, "user")
  let circles = discovery_results_by_kind(projection, "circle")
  let market = market_discovery_results(projection)
  @bunnia.view_with_attrs([@bunnia.class_name("mt-panel")], [
    @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-title")], [
      @bunnia.text("Market Board"),
    ]),
    @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-note")], [
      @bunnia.text(
        "Find public places, people, books, agents, demands, and events.",
      ),
    ]),
    @bunnia.input(
      name="discoverSearch",
      value=projection.search_query,
      input_message="discover-search",
    ),
    @bunnia.view_with_attrs(
      [@bunnia.class_name("moontown-community-actions")],
      [@bunnia.button("More", "discover-search")],
    ),
    discover_spotlight_section("Town People", people),
    discover_spotlight_section("Town Circles", circles),
    discover_spotlight_section("Town Market", market),
    @bunnia.view_with_attrs(
      [@bunnia.class_name("moontown-discovery-filters")],
      [
        @bunnia.windowed_list(
          projection.discovery_filters,
          total_count=projection.discovery_filters.length(),
          render=filter => {
            discovery_filter_chip(filter, projection.active_discovery_filter_id)
          },
        ),
      ],
    ),
    discover_results_list(projection, results),
  ])
}
