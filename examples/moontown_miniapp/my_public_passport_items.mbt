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
    public_passport_profile_item(projection, profile_ready),
    public_passport_published_item(published),
    public_passport_watch_item(watches),
    public_passport_review_item(reviews),
  ]
}

///|
fn public_passport_profile_item(
  projection : MiniTownProjection,
  profile_ready : Bool,
) -> MiniTownOwnershipItem {
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
  )
}

///|
fn public_passport_published_item(published : Int) -> MiniTownOwnershipItem {
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
  )
}

///|
fn public_passport_watch_item(
  watches : Array[MiniTownWatch],
) -> MiniTownOwnershipItem {
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
  )
}

///|
fn public_passport_review_item(
  reviews : Array[MiniTownReviewItem],
) -> MiniTownOwnershipItem {
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
  )
}
