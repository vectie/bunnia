///|
// My Inventory assembly stays small; UX6 panels live in focused sibling files.

///|
fn profile_panel(projection : MiniTownProjection) -> @bunnia.Node {
  let items = filtered_ownership_items(projection)
  @bunnia.view_with_attrs(
    [@bunnia.class_name("mt-panel moontown-my-inventory")],
    [
      @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-title")], [
        @bunnia.text("My Inventory"),
      ]),
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-ownership-filters")],
        [
          @bunnia.windowed_list(
            projection.ownership_filters,
            total_count=projection.ownership_filters.length(),
            render=filter => {
              ownership_filter_chip(
                filter,
                projection.active_ownership_filter_id,
              )
            },
          ),
        ],
      ),
      @bunnia.windowed_list(
        items,
        total_count=items.length(),
        render=ownership_item_entry,
      ),
      inventory_refresh_plaque(projection),
    ],
  )
}
