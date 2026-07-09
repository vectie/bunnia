///|
fn inventory_drafts_shelf(count : Int) -> MiniTownInventoryShelf {
  mini_town_inventory_shelf(
    id="drafts",
    title="Drafts",
    summary="Private drafts can be submitted for review.",
    count~,
    status=if count > 0 { "draft" } else { "stable" },
    action_label=if count > 0 { "Submit for review" } else { "Show Drafts" },
    action_message=if count > 0 {
      "submit-private-building"
    } else {
      "ownership-filter-drafts"
    },
    target_tab="my",
  )
}

///|
fn inventory_submitted_shelf(count : Int) -> MiniTownInventoryShelf {
  mini_town_inventory_shelf(
    id="submitted",
    title="Submitted",
    summary="Submitted work waits for a reviewer decision.",
    count~,
    status=if count > 0 { "review" } else { "stable" },
    action_label=if count > 0 { "Check Review" } else { "Show Work" },
    action_message=if count > 0 {
      "tab-messages"
    } else {
      "ownership-filter-all"
    },
    target_tab=if count > 0 { "messages" } else { "my" },
  )
}

///|
fn inventory_published_shelf(count : Int) -> MiniTownInventoryShelf {
  mini_town_inventory_shelf(
    id="published",
    title="Published",
    summary="Public work can be discovered and placed.",
    count~,
    status=if count > 0 { "published" } else { "stable" },
    action_label=if count > 0 { "Open Discover" } else { "Show Published" },
    action_message=if count > 0 {
      "tab-discover"
    } else {
      "ownership-filter-published"
    },
    target_tab=if count > 0 { "discover" } else { "my" },
  )
}

///|
fn inventory_archived_shelf(count : Int) -> MiniTownInventoryShelf {
  mini_town_inventory_shelf(
    id="archived",
    title="Archived",
    summary="Archived work can be restored when needed.",
    count~,
    status=if count > 0 { "waiting" } else { "stable" },
    action_label=if count > 0 { "Restore" } else { "Show Archive" },
    action_message=if count > 0 {
      "restore-archived-building"
    } else {
      "ownership-filter-all"
    },
    target_tab="my",
  )
}
