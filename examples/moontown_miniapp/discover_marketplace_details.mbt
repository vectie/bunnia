///|
fn marketplace_listing_details() -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-market-details"),
      @bunnia.attr("wx:if", "{{marketplace.detailsOpen}}"),
      @bunnia.attr("role", "dialog"),
      @bunnia.attr("aria-label", "Published listing details"),
    ],
    [
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-market-details-head")],
        [
          @bunnia.view_with_attrs(
            [@bunnia.class_name("moontown-market-details-title")],
            [
              @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
                @bunnia.text("{{marketplace.selected.title}}"),
              ]),
              @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
                @bunnia.text(
                  "{{marketplace.selected.kind == 'agent' ? 'Published agent' : 'Published building'}} by {{marketplace.selected.publisher}}",
                ),
              ]),
            ],
          ),
          @bunnia.node(
            kind="button",
            attrs=[
              @bunnia.class_name("moontown-icon-button"),
              @bunnia.attr("bindtap", "onMarketplaceDetailsClose"),
              @bunnia.attr("aria-label", "Close listing details"),
            ],
            children=[town_icon("close")],
          ),
        ],
      ),
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-market-details-summary")],
        [@bunnia.text("{{marketplace.selected.summary}}")],
      ),
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-market-details-facts")],
        [
          @bunnia.view_with_attrs(
            [@bunnia.class_name("moontown-market-fact")],
            [
              town_icon("price"),
              @bunnia.text("{{marketplace.selected.priceLabel}}"),
            ],
          ),
          @bunnia.view_with_attrs(
            [@bunnia.class_name("moontown-market-fact")],
            [
              town_icon("trust"),
              @bunnia.text("{{marketplace.selected.trustLabel}}"),
            ],
          ),
        ],
      ),
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-market-detail-actions")],
        [
          marketplace_gated_listing_action(
            "follow", "Follow", "follow", "canFollow",
          ),
          marketplace_message_publisher_action(),
          @bunnia.view_with_attrs(
            [
              @bunnia.attr(
                "wx:if", "{{marketplace.selected.kind == 'agent' && (marketplace.selected.canInstall || marketplace.selected.canInvite || marketplace.selected.canTry)}}",
              ),
            ],
            [
              marketplace_gated_listing_action(
                "install", "Request install", "install", "canInstall",
              ),
              marketplace_gated_listing_action(
                "invite", "Invite to building", "invite", "canInvite",
              ),
              marketplace_gated_listing_action(
                "try", "Request trial", "try", "canTry",
              ),
            ],
          ),
          @bunnia.view_with_attrs(
            [
              @bunnia.attr(
                "wx:if", "{{marketplace.selected.kind == 'building' && (marketplace.selected.canVisit || marketplace.selected.canRequestAccess)}}",
              ),
            ],
            [
              marketplace_gated_listing_action(
                "visit", "Request visit", "visit", "canVisit",
              ),
              marketplace_gated_listing_action(
                "request_access", "Request access", "access", "canRequestAccess",
              ),
            ],
          ),
          @bunnia.view_with_attrs(
            [@bunnia.attr("wx:if", "{{marketplace.selected.canShare}}")],
            [
              @bunnia.form("preview-marketplace-share", [
                marketplace_hidden_input(
                  "listingId", "{{marketplace.selected.id}}",
                ),
                marketplace_hidden_input(
                  "listingKind", "{{marketplace.selected.kind}}",
                ),
                marketplace_submit_button("Share preview", "share"),
              ]),
            ],
          ),
        ],
      ),
      marketplace_live_share_preview(),
      backend_feedback(
        "marketplace-share-preview", "Preparing a safe preview...", "Preview ready. No access has been granted.",
        "Preview unavailable. Nothing was shared.",
      ),
      backend_feedback(
        "marketplace-action", "Sending request...", "Request sent. Nothing was installed or shared automatically.",
        "The request was not sent. Try again.",
      ),
      backend_feedback(
        "channel-create", "Creating a private conversation...", "Private conversation created. Open Messages to continue.",
        "Conversation not created. Request contact instead or try again.",
      ),
    ],
  )
}

///|
fn marketplace_message_publisher_action() -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [@bunnia.attr("wx:if", "{{marketplace.selected.canMessage}}")],
    [
      @bunnia.view_with_attrs(
        [@bunnia.attr("wx:if", "{{marketplace.selected.publisherId}}")],
        [
          @bunnia.form("create-marketplace-channel", [
            marketplace_hidden_input("channelId", ""),
            marketplace_hidden_input(
              "title", "Conversation with {{marketplace.selected.publisher}}",
            ),
            marketplace_hidden_input("visibility", "direct"),
            marketplace_hidden_input("sensitivity", "internal"),
            marketplace_hidden_input(
              "memberPrincipalIds", "{{marketplace.selected.publisherId}}",
            ),
            marketplace_submit_button("Message publisher", "message"),
          ]),
        ],
      ),
      @bunnia.view_with_attrs(
        [@bunnia.attr("wx:if", "{{!marketplace.selected.publisherId}}")],
        [
          marketplace_listing_action_form(
            "message", "Request contact", "message",
          ),
        ],
      ),
    ],
  )
}

///|
fn marketplace_gated_listing_action(
  action_id : String,
  label : String,
  icon : String,
  gate : String,
) -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [@bunnia.attr("wx:if", "{{marketplace.selected.\{gate}}}")],
    [marketplace_listing_action_form(action_id, label, icon)],
  )
}

///|
fn marketplace_live_share_preview() -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-live-share-preview"),
      @bunnia.attr("wx:if", "{{marketplace.sharePreviewOpen}}"),
      @bunnia.attr("role", "status"),
      @bunnia.attr("aria-live", "polite"),
    ],
    [
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-preview-fields-title")],
        [town_icon("visible"), @bunnia.text("Safe share preview")],
      ),
      @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
        @bunnia.text("{{marketplace.sharePreview.title}}"),
      ]),
      @bunnia.view_with_attrs([@bunnia.class_name("moontown-market-summary")], [
        @bunnia.text("{{marketplace.sharePreview.safeSummary}}"),
      ]),
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-preview-fields kind-included")],
        [
          @bunnia.view_with_attrs(
            [@bunnia.class_name("moontown-preview-fields-title")],
            [town_icon("visible"), @bunnia.text("Included for this viewer")],
          ),
          @bunnia.view_with_attrs(
            [
              @bunnia.class_name("moontown-preview-field"),
              @bunnia.attr(
                "wx:for", "{{marketplace.sharePreview.includedFields}}",
              ),
              @bunnia.attr("wx:key", "*this"),
            ],
            [@bunnia.text("{{item}}")],
          ),
        ],
      ),
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-preview-fields kind-withheld")],
        [
          @bunnia.view_with_attrs(
            [@bunnia.class_name("moontown-preview-fields-title")],
            [town_icon("private"), @bunnia.text("Withheld by policy")],
          ),
          @bunnia.view_with_attrs(
            [
              @bunnia.class_name("moontown-preview-field"),
              @bunnia.attr(
                "wx:for", "{{marketplace.sharePreview.withheldFields}}",
              ),
              @bunnia.attr("wx:key", "*this"),
            ],
            [@bunnia.text("{{item}}")],
          ),
        ],
      ),
      @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
        @bunnia.text("Previewing does not grant access or publish anything."),
      ]),
      @bunnia.form("create-marketplace-share-grant", [
        marketplace_hidden_input("listingId", "{{marketplace.selected.id}}"),
        marketplace_hidden_input("listingKind", "{{marketplace.selected.kind}}"),
        marketplace_hidden_input("permission", "view"),
        @bunnia.node(
          kind="input",
          attrs=[
            @bunnia.attr("name", "targetPrincipalId"),
            @bunnia.attr("value", "{{marketplaceShareGrant.targetPrincipalId}}"),
            @bunnia.attr("placeholder", "Recipient Town ID"),
            @bunnia.attr("aria-label", "Recipient Town ID"),
            @bunnia.data(
              "bunnia-input-path", "marketplaceShareGrant.targetPrincipalId",
            ),
          ],
          events=[@bunnia.event("input", "edit-marketplace-share-recipient")],
          children=[],
        ),
        marketplace_submit_button(
          "Grant view access",
          "share",
          emphasis="primary",
        ),
      ]),
      backend_feedback(
        "marketplace-share", "Granting view access...", "View access granted to the named recipient.",
        "Access was not granted. Check the recipient and try again.",
      ),
      @bunnia.view_with_attrs(
        [
          @bunnia.class_name("moontown-share-revoke"),
          @bunnia.attr("wx:if", "{{marketplace.lastShareGrantId}}"),
        ],
        [
          @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
            @bunnia.text(
              "You remain in control. Revoking removes this recipient's private-card access.",
            ),
          ]),
          @bunnia.form("revoke-marketplace-share-grant", [
            marketplace_hidden_input(
              "grantId", "{{marketplace.lastShareGrantId}}",
            ),
            marketplace_submit_button("Revoke access", "close"),
          ]),
        ],
      ),
      backend_feedback(
        "marketplace-share-revoke", "Revoking private access...", "Private access revoked.",
        "Access was not revoked. Verify that you created this grant.",
      ),
    ],
  )
}

///|
fn marketplace_listing_action_form(
  action_id : String,
  label : String,
  icon : String,
) -> @bunnia.Node {
  @bunnia.form("marketplace-listing-action", [
    marketplace_hidden_input("listingId", "{{marketplace.selected.id}}"),
    marketplace_hidden_input("listingKind", "{{marketplace.selected.kind}}"),
    marketplace_hidden_input("actionId", action_id),
    marketplace_hidden_input(
      "message", "Requested from the public listing card.",
    ),
    marketplace_submit_button(label, icon),
  ])
}

///|
fn marketplace_publisher_preview(
  projection : MiniTownProjection,
) -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-market-publisher"),
      @bunnia.attr("wx:if", "{{marketplace.publisherOpen}}"),
      @bunnia.attr("role", "dialog"),
      @bunnia.attr("aria-label", "Safe publication preview"),
    ],
    [
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-market-details-head")],
        [
          @bunnia.view_with_attrs(
            [@bunnia.class_name("moontown-market-details-title")],
            [
              @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
                @bunnia.text("Publish a safe Town card"),
              ]),
              @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
                @bunnia.text(
                  "Preview exactly what becomes public before submitting it for review.",
                ),
              ]),
            ],
          ),
          @bunnia.node(
            kind="button",
            attrs=[
              @bunnia.class_name("moontown-icon-button"),
              @bunnia.attr("bindtap", "onMarketplacePublisherClose"),
              @bunnia.attr("aria-label", "Close publication preview"),
            ],
            children=[town_icon("close")],
          ),
        ],
      ),
      @bunnia.windowed_list(
        projection.share_previews,
        total_count=projection.share_previews.length(),
        render=marketplace_publish_preview_row,
      ),
      marketplace_review_queue_panel(),
      backend_feedback(
        "publish-listing", "Saving publication request...", "Publication request saved. Nothing became public automatically.",
        "The draft remains private. Fix the issue and try again.",
      ),
    ],
  )
}

///|
fn marketplace_review_queue_panel() -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-review-queue")], [
    @bunnia.view_with_attrs(
      [@bunnia.class_name("moontown-market-section-heading")],
      [
        town_icon("review"),
        @bunnia.view_with_attrs(
          [@bunnia.class_name("moontown-market-heading-copy")],
          [
            @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
              @bunnia.text("Independent review"),
            ]),
            @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
              @bunnia.text(
                "Review another publisher's submitted public card before it appears in Town.",
              ),
            ]),
          ],
        ),
      ],
    ),
    @bunnia.form("load-marketplace-review-queue", [
      marketplace_submit_button("Check review queue", "refresh"),
    ]),
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("moontown-market-state empty"),
        @bunnia.attr(
          "wx:if", "{{marketplaceReviewQueue.remote && marketplaceReviewQueue.items.length == 0}}",
        ),
      ],
      [
        town_icon("review"),
        @bunnia.view_with_attrs(
          [@bunnia.class_name("moontown-market-state-copy")],
          [
            @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
              @bunnia.text("No submitted cards"),
            ]),
            @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
              @bunnia.text("Another publisher's submissions will appear here."),
            ]),
          ],
        ),
      ],
    ),
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("moontown-review-queue-list"),
        @bunnia.attr("wx:for", "{{marketplaceReviewQueue.items}}"),
        @bunnia.attr("wx:for-item", "reviewItem"),
        @bunnia.attr("wx:key", "id"),
      ],
      [
        @bunnia.keyed(
          "marketplace-review-row-template",
          marketplace_review_queue_row(),
        ),
      ],
    ),
    backend_feedback(
      "marketplace-review-queue", "Checking submitted cards...", "Review queue updated.",
      "The review queue is available only to publishers and moderators.",
    ),
  ])
}

///|
fn marketplace_review_queue_row() -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-review-queue-row")], [
    @bunnia.view_with_attrs(
      [@bunnia.class_name("moontown-publish-preview-title")],
      [
        town_icon("review"),
        @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
          @bunnia.text("{{reviewItem.title}}"),
        ]),
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-public-stamp")], [
          @bunnia.text("{{reviewItem.kind}}"),
        ]),
      ],
    ),
    @bunnia.view_with_attrs([@bunnia.class_name("moontown-market-summary")], [
      @bunnia.text("{{reviewItem.summary}}"),
    ]),
    @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
      @bunnia.text(
        "By {{reviewItem.publisher}} · {{reviewItem.licenseClass}} · {{reviewItem.rightsSummary}}",
      ),
    ]),
    @bunnia.form("transition-marketplace-listing", [
      marketplace_hidden_input("listingId", "{{reviewItem.id}}"),
      marketplace_hidden_input("listingKind", "{{reviewItem.kind}}"),
      marketplace_hidden_input("targetState", "published"),
      marketplace_hidden_input(
        "reviewSummary", "Independent reviewer approved rights, public fields, offered actions, and authority ceiling.",
      ),
      marketplace_submit_button(
        "Approve & publish",
        "check",
        emphasis="primary",
      ),
    ]),
  ])
}

///|
fn marketplace_publish_preview_row(
  preview : MiniTownSharePreview,
) -> @bunnia.Node {
  let endpoint = if preview.kind == "agent" {
    "publish-agent-listing"
  } else {
    "publish-building-listing"
  }
  @bunnia.keyed(
    "publish-preview-\{preview.id}",
    @bunnia.view_with_attrs(
      [@bunnia.class_name("moontown-publish-preview-row")],
      [
        @bunnia.view_with_attrs(
          [@bunnia.class_name("moontown-publish-preview-title")],
          [
            town_icon(preview.kind),
            @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
              @bunnia.text(preview.title),
            ]),
            @bunnia.view_with_attrs(
              [@bunnia.class_name("moontown-public-stamp")],
              [@bunnia.text(preview.visibility_label)],
            ),
          ],
        ),
        @bunnia.view_with_attrs(
          [@bunnia.class_name("moontown-market-summary")],
          [@bunnia.text(preview.safe_summary)],
        ),
        marketplace_preview_field_list(
          "Included on the card",
          preview.included_fields,
          "included",
        ),
        marketplace_preview_field_list(
          "Always private",
          preview.withheld_fields,
          "withheld",
        ),
        @bunnia.form(endpoint, [
          marketplace_submit_button(
            "Save \{preview.kind} draft",
            "save",
            emphasis="primary",
          ),
        ]),
        @bunnia.form("transition-marketplace-listing", [
          marketplace_hidden_input("listingId", preview.listing_id),
          marketplace_hidden_input("listingKind", preview.kind),
          marketplace_hidden_input("targetState", "submitted"),
          marketplace_submit_button(
            "Submit for review",
            "review",
            emphasis="secondary",
          ),
        ]),
      ],
    ),
  )
}

///|
fn marketplace_preview_field_list(
  title : String,
  items : Array[String],
  kind : String,
) -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [@bunnia.class_name("moontown-preview-fields kind-\{kind}")],
    [
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-preview-fields-title")],
        [
          town_icon(if kind == "included" { "visible" } else { "private" }),
          @bunnia.text(title),
        ],
      ),
      @bunnia.list(items, item => {
        @bunnia.keyed(
          "marketplace-preview-\{kind}-\{item}",
          @bunnia.view_with_attrs(
            [@bunnia.class_name("moontown-preview-field")],
            [@bunnia.text(item)],
          ),
        )
      }),
    ],
  )
}
