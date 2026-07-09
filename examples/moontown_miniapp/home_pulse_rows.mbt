///|
fn home_pulse_rows(
  projection : MiniTownProjection,
  activity : Array[MiniTownActivityItem],
) -> Array[HomePulseRow] {
  let reviews = visible_reviews(projection)
  let unread = unread_notifications(projection)
  let market = market_discovery_results(projection)
  let refresh_count = home_refresh_count(projection)
  [
    home_pulse_row(
      id="changes",
      title="\{home_changed_places_count(activity)} places changed",
      summary=home_activity_summary(activity),
      status="stable",
      action_label="Open",
      action_message="tab-realm",
      target_tab="realm",
    ),
    home_pulse_row(
      id="attention",
      title=if reviews.length() + unread.length() > 0 {
        "Agent needs your decision"
      } else {
        "Messages are quiet"
      },
      summary=home_attention_summary(reviews, unread),
      status=if reviews.length() + unread.length() > 0 {
        "review"
      } else {
        "stable"
      },
      action_label="Review",
      action_message="tab-messages",
      target_tab="messages",
    ),
    home_pulse_row(
      id="market",
      title="Market has new public places",
      summary="\{market.length()} public results are ready to open or place.",
      status="stable",
      action_label="More",
      action_message="tab-discover",
      target_tab="discover",
    ),
    home_pulse_row(
      id="refresh",
      title=if refresh_count > 0 {
        "Some updates need refresh"
      } else {
        "Town is ready"
      },
      summary=if refresh_count > 0 {
        "Needs refresh before the town can show the latest changes."
      } else {
        "Latest map, messages, and inventory are ready."
      },
      status=if refresh_count > 0 { "stale" } else { "stable" },
      action_label=if refresh_count > 0 { "Try again" } else { "Open" },
      action_message=if refresh_count > 0 { "tab-realm" } else { "tab-realm" },
      target_tab="realm",
    ),
  ]
}
