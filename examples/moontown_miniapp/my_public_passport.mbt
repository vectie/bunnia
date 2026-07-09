///|
fn public_passport_panel(projection : MiniTownProjection) -> @bunnia.Node {
  let items = public_passport_items(projection)
  let published = ownership_stat_value(ownership_stats(projection), "published")
  let watches = visible_watches(projection).length()
  let reviews = pending_reviews(projection).length()
  let published_label = empty_count_label(
    published, "No published places", "published place", "published places",
  )
  let watch_label = optional_count_label(watches, "watch", "watches")
  let review_label = optional_count_label(reviews, "review", "reviews")
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-credential-plaque"),
      @bunnia.data("passport-section", "public"),
      @bunnia.data("passport-count", items.length().to_string()),
    ],
    [
      @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
        @bunnia.text("Public Passport"),
      ]),
      @bunnia.text("Public-facing identity without private work."),
      @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
        @bunnia.text("\{published_label} - \{watch_label} - \{review_label}"),
      ]),
      @bunnia.windowed_list(
        items,
        total_count=items.length(),
        render=public_passport_entry,
      ),
    ],
  )
}

///|
fn public_passport_items(
  projection : MiniTownProjection,
) -> Array[MiniTownOwnershipItem] {
  let stats = ownership_stats(projection)
  let published = ownership_stat_value(stats, "published")
  let watches = visible_watches(projection)
  let reviews = pending_reviews(projection)
  let profile_ready = profile_ready_to_publish(projection)
  [
    mini_town_ownership_item(
      id="passport-profile",
      kind="profile",
      title=if profile_ready { "Profile ready" } else { "Profile incomplete" },
      summary=if profile_ready {
        "Role, consent, and saved profile can publish."
      } else {
        "Finish role, consent, and profile setup."
      },
      target_ref="profile:\{projection.profile.user_id}",
      visibility="public",
      status=if profile_ready { "ready" } else { "blocked" },
      action_label="Save",
      action_message="save-profile",
    ),
    mini_town_ownership_item(
      id="passport-published",
      kind="building",
      title=empty_count_label(
        published, "No published places", "published place", "published places",
      ),
      summary="Public buildings can be discovered and placed.",
      target_ref="building:published",
      visibility="public",
      status=if published > 0 { "ready" } else { "empty" },
      action_label="Discover",
      action_message="tab-discover",
    ),
    mini_town_ownership_item(
      id="passport-watches",
      kind="watch",
      title=count_label(
        watches.length(),
        "watched town link",
        "watched town links",
      ),
      summary="Watched places stay attached to Realm.",
      target_ref=if watches.length() > 0 {
        watches[0].target_ref
      } else {
        "watch:none"
      },
      visibility="public",
      status=if watches.length() > 0 { "watching" } else { "empty" },
      action_label=if watches.length() > 0 { "Open" } else { "Discover" },
      action_message=if watches.length() > 0 {
        watches[0].action_message
      } else {
        "tab-discover"
      },
    ),
    mini_town_ownership_item(
      id="passport-reviews",
      kind="review",
      title=count_label(reviews.length(), "review signal", "review signals"),
      summary="Review requests show accountable agent work.",
      target_ref="review:pending",
      visibility="public",
      status=if reviews.length() > 0 { "review" } else { "clear" },
      action_label="Messages",
      action_message="tab-messages",
    ),
  ]
}

///|
fn public_passport_entry(item : MiniTownOwnershipItem) -> @bunnia.Node {
  @bunnia.keyed(
    "public-passport-\{item.id}",
    @bunnia.node(
      kind="view",
      attrs=[
        @bunnia.class_name("moontown-owned-entry bunnia-status-\{item.status}"),
        @bunnia.data("passport-kind", item.kind),
      ],
      events=[@bunnia.event("tap", item.action_message)],
      children=[
        @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
          @bunnia.text(item.title),
        ]),
        @bunnia.text(item.summary),
        @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
          @bunnia.text(
            "\{town_kind_label(item.kind)} - \{town_visibility_label(item.visibility)} - \{item.action_label}",
          ),
        ]),
      ],
    ),
  )
}

///|
fn profile_credential_plaque(projection : MiniTownProjection) -> @bunnia.Node {
  let district = profile_credential_district(projection)
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-credential-plaque"),
      @bunnia.data("district-id", district.id),
      @bunnia.data("feature-kind", district.feature_kind),
      @bunnia.data("target-building-id", district.building_id),
      @bunnia.data("status", district.status),
    ],
    [
      @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
        @bunnia.text("Town Credential"),
      ]),
      @bunnia.text("\{district.title}: \{district.summary}"),
      @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
        @bunnia.text(
          "\{district.stat_value} \{district.stat_label} - \{town_status_label(district.status)}",
        ),
      ]),
      open_place_button(district.building_id),
    ],
  )
}

///|
fn profile_credential_district(
  projection : MiniTownProjection,
) -> MiniTownDistrict {
  for district in projection.districts {
    if district.feature_kind == "credential" {
      return district
    }
  }
  projection.districts[0]
}
