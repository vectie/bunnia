///|
// Market Board assembly stays compact; lists, entries, and actions live beside it.

///|
fn discover_panel(projection : MiniTownProjection) -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [@bunnia.class_name("mt-panel moontown-discover-board")],
    [
      marketplace_discover_toolbar(),
      marketplace_autocomplete(),
      marketplace_discover_filters(),
      marketplace_request_states(),
      marketplace_shared_with_me(),
      marketplace_recommendations(projection),
      marketplace_organic_results(projection),
      marketplace_sponsored_results(projection),
      marketplace_listing_details(),
      marketplace_publisher_preview(projection),
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
  _results : Array[MiniTownDiscoveryItem],
) -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-results-headings")], [
    @bunnia.windowed_list(
      projection.discovery_filters,
      total_count=projection.discovery_filters.length(),
      render=filter => {
        @bunnia.keyed(
          "discover-heading-\{filter.id}",
          @bunnia.view_with_attrs(
            [
              @bunnia.class_name("moontown-results-heading"),
              @bunnia.attr("wx:if", "{{discover.filter == '\{filter.id}'}}"),
            ],
            [
              @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
                @bunnia.text(
                  "\{discovery_filter_match_count(projection, filter)} matches",
                ),
              ]),
              @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
                @bunnia.text(filter.label),
              ]),
            ],
          ),
        )
      },
    ),
  ])
}
