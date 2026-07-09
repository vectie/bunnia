///|
fn inventory_books_shelf(count : Int) -> MiniTownInventoryShelf {
  mini_town_inventory_shelf(
    id="books",
    title="Books",
    summary="Safe memory summaries stay tied to owned places.",
    count~,
    status=if count > 0 { "ready" } else { "stable" },
    action_label=if count > 0 { "Review Books" } else { "Show Books" },
    action_message=if count > 0 {
      "tab-messages"
    } else {
      "ownership-filter-books"
    },
    target_tab=if count > 0 { "messages" } else { "my" },
  )
}

///|
fn inventory_agents_shelf(count : Int) -> MiniTownInventoryShelf {
  mini_town_inventory_shelf(
    id="agents",
    title="Agents",
    summary="Workers attached to owned places are managed from Messages.",
    count~,
    status=if count > 0 { "running" } else { "stable" },
    action_label=if count > 0 { "Message Agents" } else { "Show Agents" },
    action_message=if count > 0 {
      "tab-messages"
    } else {
      "ownership-filter-agents"
    },
    target_tab=if count > 0 { "messages" } else { "my" },
  )
}
