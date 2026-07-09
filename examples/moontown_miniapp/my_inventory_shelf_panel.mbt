///|
fn inventory_shelves_panel(projection : MiniTownProjection) -> @bunnia.Node {
  let shelves = inventory_shelf_rows(projection)
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-inventory-shelves"),
      @bunnia.data("inventory-shelf-count", shelves.length().to_string()),
    ],
    [
      @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
        @bunnia.text("Inventory Shelves"),
      ]),
      @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
        @bunnia.text(
          "Buildings, books, agents, placements, drafts, submitted, published, archives, and watches.",
        ),
      ]),
      @bunnia.windowed_list(
        shelves,
        total_count=shelves.length(),
        render=inventory_shelf_entry,
      ),
    ],
  )
}

///|
fn inventory_shelf_entry(row : MiniTownInventoryShelf) -> @bunnia.Node {
  @bunnia.keyed(
    "inventory-shelf-\{row.id}",
    @bunnia.node(
      kind="view",
      attrs=[
        @bunnia.class_name(
          "moontown-inventory-shelf bunnia-status-\{row.status}",
        ),
        @bunnia.data("inventory-shelf", row.id),
        @bunnia.data("inventory-destination", town_tab_label(row.target_tab)),
      ],
      events=[@bunnia.event("tap", row.action_message)],
      children=[
        @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
          @bunnia.text(row.title),
        ]),
        @bunnia.text(inventory_shelf_count_text(row)),
        @bunnia.text(row.summary),
        @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
          @bunnia.text(
            "\{row.action_label} in \{town_tab_label(row.target_tab)}",
          ),
        ]),
      ],
    ),
  )
}
