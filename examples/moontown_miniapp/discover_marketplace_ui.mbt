///|
fn marketplace_discover_toolbar() -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [@bunnia.class_name("moontown-marketplace-toolbar")],
    [
      @bunnia.form("marketplace-search", [
        @bunnia.node(
          kind="input",
          attrs=[
            @bunnia.attr("name", "query"),
            @bunnia.attr("value", "{{marketplaceSearch.q}}"),
            @bunnia.attr("placeholder", "Find an agent or building"),
            @bunnia.attr("confirm-type", "search"),
            @bunnia.attr("aria-label", "Search published agents and buildings"),
            @bunnia.data("bunnia-input-path", "marketplaceSearch.q"),
          ],
          events=[@bunnia.event("input", "edit-marketplace-search")],
          children=[],
        ),
        marketplace_submit_button("Search", "search", emphasis="primary"),
      ]),
      @bunnia.node(
        kind="button",
        attrs=[
          @bunnia.class_name("moontown-market-publish-button"),
          @bunnia.attr("aria-label", "Preview a safe public listing"),
          @bunnia.attr("bindtap", "onMarketplacePublisherOpen"),
        ],
        children=town_icon_label("publish", "Publish"),
      ),
      @bunnia.form("load-marketplace-feed", [
        marketplace_submit_button("Refresh discovery", "refresh"),
      ]),
    ],
  )
}

///|
fn marketplace_autocomplete() -> @bunnia.Node {
  let suggestions = [
    ("robotics agents", "Robotics agents"),
    ("research buildings", "Research buildings"),
    ("bookkeeper", "Bookkeeper"),
  ]
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-market-suggestions"),
      @bunnia.attr("wx:if", "{{discover.suggestionsOpen}}"),
      @bunnia.attr("aria-label", "Search suggestions"),
    ],
    [
      @bunnia.list(suggestions, suggestion => {
        @bunnia.node(
          kind="button",
          attrs=[
            @bunnia.class_name("moontown-market-suggestion"),
            @bunnia.data("query", suggestion.0),
            @bunnia.attr("bindtap", "onMarketplaceSuggestion"),
            @bunnia.attr("aria-label", "Search for \{suggestion.1}"),
          ],
          children=town_icon_label("search", suggestion.1),
        )
      }),
    ],
  )
}

///|
fn marketplace_discover_filters() -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-discovery-primary-filters marketplace"),
      @bunnia.attr("aria-label", "Listing type"),
    ],
    [
      marketplace_filter_chip("all", "All", "market"),
      marketplace_filter_chip("agent", "Agents", "agent"),
      marketplace_filter_chip("building", "Buildings", "building"),
    ],
  )
}

///|
fn marketplace_filter_chip(
  filter_id : String,
  label : String,
  icon : String,
) -> @bunnia.Node {
  @bunnia.node(
    kind="button",
    attrs=[
      @bunnia.class_name(
        "moontown-discovery-filter {{discover.filter == '\{filter_id}' ? 'active' : ''}}",
      ),
      @bunnia.data("filter-id", filter_id),
      @bunnia.attr("aria-label", "Show \{label}"),
    ],
    events=[@bunnia.event("tap", "discover-filter-\{filter_id}")],
    children=town_icon_label(icon, label),
  )
}

///|
fn marketplace_request_states() -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-market-state-stack")], [
    marketplace_state(
      "loading", "Finding public listings", "Search and recommendations are being refreshed.",
      "{{ui.feedback == 'marketplace-search' && requestState.state == 'loading'}}",
    ),
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("moontown-market-state error"),
        @bunnia.attr("role", "alert"),
        @bunnia.attr(
          "wx:if", "{{ui.feedback == 'marketplace-search' && requestState.state == 'failed'}}",
        ),
      ],
      [
        town_icon("warning"),
        @bunnia.view_with_attrs(
          [@bunnia.class_name("moontown-market-state-copy")],
          [
            @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
              @bunnia.text("Search could not refresh"),
            ]),
            @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
              @bunnia.text(
                "Your current results are still here. Check the connection and try again.",
              ),
            ]),
          ],
        ),
        @bunnia.form("marketplace-search", [
          marketplace_submit_button("Try again", "retry", emphasis="primary"),
        ]),
      ],
    ),
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("moontown-market-state empty"),
        @bunnia.attr(
          "wx:if", "{{marketplace.remote && requestState.state == 'ready' && marketplace.organic.length == 0}}",
        ),
      ],
      [
        town_icon("search"),
        @bunnia.view_with_attrs(
          [@bunnia.class_name("moontown-market-state-copy")],
          [
            @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
              @bunnia.text("No public match yet"),
            ]),
            @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
              @bunnia.text(
                "Try “robotics agents”, remove a filter, or browse recommendations.",
              ),
            ]),
          ],
        ),
        @bunnia.node(
          kind="button",
          attrs=[
            @bunnia.class_name("moontown-market-action action-secondary"),
            @bunnia.data("query", ""),
            @bunnia.attr("bindtap", "onMarketplaceSuggestion"),
            @bunnia.attr(
              "aria-label", "Clear search and browse recommendations",
            ),
          ],
          children=town_icon_label("close", "Clear search"),
        ),
      ],
    ),
  ])
}

///|
fn marketplace_state(
  state : String,
  title : String,
  body : String,
  condition : String,
) -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-market-state \{state}"),
      @bunnia.attr("wx:if", condition),
      @bunnia.attr("aria-live", "polite"),
    ],
    [
      town_icon("progress"),
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-market-state-copy")],
        [
          @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
            @bunnia.text(title),
          ]),
          @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
            @bunnia.text(body),
          ]),
        ],
      ),
    ],
  )
}

///|
fn marketplace_recommendations(projection : MiniTownProjection) -> @bunnia.Node {
  let recommendations = recommended_marketplace_listings(projection)
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-market-section recommendations"),
      @bunnia.attr(
        "wx:if", "{{!marketplaceSearch.q && requestState.state != 'loading'}}",
      ),
    ],
    [
      marketplace_section_heading(
        "Recommended for you", "Every recommendation explains why it appears.", "recommend",
      ),
      @bunnia.form("load-marketplace-recommendations", [
        marketplace_submit_button("Refresh recommendations", "refresh"),
      ]),
      @bunnia.view_with_attrs(
        [
          @bunnia.class_name("moontown-market-list remote"),
          @bunnia.attr("wx:if", "{{marketplace.remote}}"),
        ],
        [dynamic_marketplace_list("marketplace.recommendations", false)],
      ),
      @bunnia.view_with_attrs(
        [
          @bunnia.class_name("moontown-market-list fixture"),
          @bunnia.attr("wx:if", "{{!marketplace.remote}}"),
        ],
        [
          @bunnia.windowed_list(
            recommendations,
            total_count=recommendations.length(),
            render=item => marketplace_listing_row(item, "recommendation"),
          ),
        ],
      ),
    ],
  )
}

///|
fn marketplace_shared_with_me() -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [@bunnia.class_name("moontown-market-section shared")],
    [
      marketplace_section_heading(
        "Shared with me", "Private cards appear only while an owner-authorized grant is active.",
        "share",
      ),
      @bunnia.form("load-shared-marketplace-listings", [
        marketplace_submit_button("Check private shares", "refresh"),
      ]),
      backend_feedback(
        "marketplace-shared", "Checking your private shares...", "Private shares refreshed.",
        "Private shares could not be loaded.",
      ),
      @bunnia.view_with_attrs(
        [
          @bunnia.class_name("moontown-market-list remote"),
          @bunnia.attr("wx:if", "{{marketplace.shared.length > 0}}"),
        ],
        [dynamic_marketplace_list("marketplace.shared", false)],
      ),
      @bunnia.view_with_attrs(
        [
          @bunnia.class_name("moontown-market-state empty"),
          @bunnia.attr(
            "wx:if", "{{marketplace.sharedLoaded && marketplace.shared.length == 0}}",
          ),
        ],
        [
          town_icon("private"),
          @bunnia.view_with_attrs(
            [@bunnia.class_name("moontown-market-state-copy")],
            [
              @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
                @bunnia.text("No active private shares"),
              ]),
              @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
                @bunnia.text(
                  "Ask an owner to share an agent or building card with your Town ID.",
                ),
              ]),
            ],
          ),
        ],
      ),
    ],
  )
}

///|
fn marketplace_organic_results(projection : MiniTownProjection) -> @bunnia.Node {
  let listings = organic_marketplace_listings(projection)
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-market-section organic"),
      @bunnia.attr(
        "wx:if", "{{marketplaceSearch.q && requestState.state != 'loading'}}",
      ),
    ],
    [
      marketplace_section_heading(
        "Organic results", "Ranked by match and evidence. Paid placement never changes this list.",
        "search",
      ),
      @bunnia.view_with_attrs(
        [
          @bunnia.class_name("moontown-market-list remote"),
          @bunnia.attr("wx:if", "{{marketplace.remote}}"),
        ],
        [dynamic_marketplace_list("marketplace.organic", false)],
      ),
      @bunnia.view_with_attrs(
        [
          @bunnia.class_name("moontown-market-list fixture"),
          @bunnia.attr("wx:if", "{{!marketplace.remote}}"),
        ],
        [
          @bunnia.windowed_list(listings, total_count=listings.length(), render=item => {
            marketplace_listing_row(item, "search")
          }),
        ],
      ),
    ],
  )
}

///|
fn marketplace_sponsored_results(
  projection : MiniTownProjection,
) -> @bunnia.Node {
  let sponsored = sponsored_marketplace_listings(projection)
  @bunnia.view_with_attrs(
    [@bunnia.class_name("moontown-market-section sponsored")],
    [
      marketplace_section_heading(
        "Sponsored", "Paid placements are labeled and remain separate from organic ranking.",
        "sponsor",
      ),
      @bunnia.view_with_attrs(
        [
          @bunnia.class_name("moontown-market-list remote"),
          @bunnia.attr("wx:if", "{{marketplace.remote}}"),
        ],
        [dynamic_marketplace_list("marketplace.sponsored", true)],
      ),
      @bunnia.view_with_attrs(
        [
          @bunnia.class_name("moontown-market-list fixture"),
          @bunnia.attr("wx:if", "{{!marketplace.remote}}"),
        ],
        [
          @bunnia.windowed_list(sponsored, total_count=sponsored.length(), render=item => {
            marketplace_listing_row(item, "sponsored")
          }),
        ],
      ),
    ],
  )
}

///|
fn marketplace_section_heading(
  title : String,
  note : String,
  icon : String,
) -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [@bunnia.class_name("moontown-market-section-heading")],
    [
      town_icon(icon),
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-market-heading-copy")],
        [
          @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
            @bunnia.text(title),
          ]),
          @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
            @bunnia.text(note),
          ]),
        ],
      ),
    ],
  )
}
