///|
fn public_passport_panel(projection : MiniTownProjection) -> @bunnia.Node {
  let items = public_passport_items(projection)
  let summary = public_passport_summary(projection)
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-credential-plaque moontown-my-public"),
      @bunnia.data("passport-section", "public"),
      @bunnia.data("passport-count", items.length().to_string()),
    ],
    [
      @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
        @bunnia.text("Public Passport"),
      ]),
      @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
        @bunnia.text(summary),
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
fn public_passport_summary(projection : MiniTownProjection) -> String {
  let published = ownership_stat_value(ownership_stats(projection), "published")
  let watches = visible_watches(projection).length()
  let reviews = pending_reviews(projection).length()
  let published_label = empty_count_label(
    published, "No published places", "published place", "published places",
  )
  let watch_label = optional_count_label(watches, "watch", "watches")
  let review_label = optional_count_label(reviews, "review", "reviews")
  "\{published_label} - \{watch_label} - \{review_label}"
}
