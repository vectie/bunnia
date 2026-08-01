///|
fn marketplace_listing_row(
  item : MiniTownMarketplaceListing,
  context : String,
) -> @bunnia.Node {
  let sponsorship_class = if item.sponsored {
    "is-sponsored"
  } else {
    "is-organic"
  }
  @bunnia.keyed(
    "marketplace-\{context}-\{item.id}",
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name(
          "moontown-market-listing kind-\{item.kind} \{sponsorship_class}",
        ),
        @bunnia.data("listing-id", item.id),
        @bunnia.data("listing-kind", item.kind),
      ],
      [
        @bunnia.view_with_attrs(
          [@bunnia.class_name("moontown-market-listing-icon")],
          [town_icon(item.kind)],
        ),
        @bunnia.view_with_attrs(
          [@bunnia.class_name("moontown-market-listing-copy")],
          [
            if item.sponsored {
              marketplace_sponsor_label(item.sponsor_label)
            } else {
              @bunnia.view([])
            },
            @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
              @bunnia.text(item.title),
            ]),
            @bunnia.view_with_attrs(
              [@bunnia.class_name("moontown-market-summary")],
              [@bunnia.text(item.summary)],
            ),
            @bunnia.view_with_attrs(
              [@bunnia.class_name("moontown-market-meta")],
              [
                @bunnia.text(
                  "\{item.publisher} · \{item.price_label} · \{item.trust_label}",
                ),
              ],
            ),
            if context == "recommendation" {
              @bunnia.view_with_attrs(
                [@bunnia.class_name("moontown-market-reason")],
                [town_icon("reason"), @bunnia.text(item.recommendation_reason)],
              )
            } else {
              @bunnia.view([])
            },
          ],
        ),
        @bunnia.node(
          kind="button",
          attrs=[
            @bunnia.class_name("moontown-market-open"),
            @bunnia.data("listing-id", item.id),
            @bunnia.data("listing-kind", item.kind),
            @bunnia.data("listing-title", item.title),
            @bunnia.data("listing-summary", item.summary),
            @bunnia.data("listing-publisher", item.publisher),
            @bunnia.data("listing-publisher-id", item.publisher_id),
            @bunnia.data("listing-building-id", item.building_id),
            @bunnia.data("listing-price", item.price_label),
            @bunnia.data("listing-trust", item.trust_label),
            @bunnia.data("listing-actions", item.actions.join(",")),
            @bunnia.attr("bindtap", "onMarketplaceListingTap"),
            @bunnia.attr("aria-label", "View \{item.title} listing details"),
          ],
          children=town_icon_label("open", "Details"),
        ),
      ],
    ),
  )
}

///|
fn marketplace_sponsor_label(label : String) -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-sponsored-label"),
      @bunnia.attr("aria-label", "Sponsored placement"),
    ],
    [town_icon("sponsor"), @bunnia.text(label)],
  )
}

///|
fn dynamic_marketplace_list(path : String, sponsored : Bool) -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.attr("wx:for", "{{\{path}}}"),
      @bunnia.attr("wx:key", "id"),
      @bunnia.class_name(
        if sponsored {
          "moontown-market-listing kind-{{item.kind}} is-sponsored"
        } else {
          "moontown-market-listing kind-{{item.kind}} is-organic"
        },
      ),
    ],
    [
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-market-listing-icon")],
        [
          @bunnia.view_with_attrs(
            [@bunnia.class_name("moontown-line-icon icon-{{item.kind}}")],
            [],
          ),
        ],
      ),
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-market-listing-copy")],
        [
          @bunnia.view_with_attrs(
            [
              @bunnia.class_name("moontown-sponsored-label"),
              @bunnia.attr("wx:if", "{{item.sponsored}}"),
            ],
            [@bunnia.text("{{item.sponsorLabel}}")],
          ),
          @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
            @bunnia.text("{{item.title}}"),
          ]),
          @bunnia.view_with_attrs(
            [@bunnia.class_name("moontown-market-summary")],
            [@bunnia.text("{{item.summary}}")],
          ),
          @bunnia.view_with_attrs(
            [@bunnia.class_name("moontown-market-meta")],
            [
              @bunnia.text(
                "{{item.publisher}} · {{item.priceLabel}} · {{item.trustLabel}}",
              ),
            ],
          ),
          @bunnia.view_with_attrs(
            [
              @bunnia.class_name("moontown-market-reason"),
              @bunnia.attr("wx:if", "{{item.reason}}"),
            ],
            [town_icon("reason"), @bunnia.text("{{item.reason}}")],
          ),
        ],
      ),
      @bunnia.node(
        kind="button",
        attrs=[
          @bunnia.class_name("moontown-market-open"),
          @bunnia.data("listing-id", "{{item.id}}"),
          @bunnia.data("listing-kind", "{{item.kind}}"),
          @bunnia.data("listing-title", "{{item.title}}"),
          @bunnia.data("listing-summary", "{{item.summary}}"),
          @bunnia.data("listing-publisher", "{{item.publisher}}"),
          @bunnia.data("listing-publisher-id", "{{item.publisherId}}"),
          @bunnia.data("listing-building-id", "{{item.buildingId}}"),
          @bunnia.data("listing-price", "{{item.priceLabel}}"),
          @bunnia.data("listing-trust", "{{item.trustLabel}}"),
          @bunnia.data("listing-actions", "{{item.actionCsv}}"),
          @bunnia.attr("bindtap", "onMarketplaceListingTap"),
          @bunnia.attr("aria-label", "View listing details"),
        ],
        children=town_icon_label("open", "Details"),
      ),
    ],
  )
}
