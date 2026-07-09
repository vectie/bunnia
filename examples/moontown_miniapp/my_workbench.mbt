///|
// My Inventory assembly stays small; UX6 panels live in focused sibling files.

///|
fn profile_panel(projection : MiniTownProjection) -> @bunnia.Node {
  let stats = ownership_stats(projection)
  let items = filtered_ownership_items(projection)
  let alerts = workbench_alerts(projection)
  @bunnia.view_with_attrs([@bunnia.class_name("mt-panel")], [
    @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-title")], [
      @bunnia.text("My Inventory"),
    ]),
    @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-note")], [
      @bunnia.text(
        "Owned shelves, alerts, and \{items.length()} items are ready to manage.",
      ),
    ]),
    profile_identity_card(projection),
    @bunnia.windowed_list(
      alerts,
      total_count=alerts.length(),
      render=workbench_alert_entry,
    ),
    public_passport_panel(projection),
    inventory_shelves_panel(projection),
    @bunnia.windowed_list(
      stats,
      total_count=stats.length(),
      render=ownership_stat_entry,
    ),
    @bunnia.view_with_attrs(
      [@bunnia.class_name("moontown-ownership-filters")],
      [
        @bunnia.windowed_list(
          projection.ownership_filters,
          total_count=projection.ownership_filters.length(),
          render=filter => {
            ownership_filter_chip(filter, projection.active_ownership_filter_id)
          },
        ),
      ],
    ),
    @bunnia.windowed_list(
      items,
      total_count=items.length(),
      render=ownership_item_entry,
    ),
    profile_credential_plaque(projection),
    inventory_refresh_plaque(projection),
    reviewer_tools_panel(projection),
  ])
}
