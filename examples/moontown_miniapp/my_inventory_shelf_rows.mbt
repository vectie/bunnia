///|
fn inventory_shelf_rows(
  projection : MiniTownProjection,
) -> Array[MiniTownInventoryShelf] {
  let owned = owned_buildings(projection)
  let placements = visible_placements(projection)
  let books = owned_books(projection)
  let agents = owned_agents(projection)
  let watches = visible_watches(projection)
  let drafts = count_owned_buildings_by_visibility(projection, "private_draft")
  let submitted = count_owned_buildings_by_visibility(projection, "submitted")
  let published = count_owned_buildings_by_visibility(projection, "published")
  let archived = count_owned_buildings_by_visibility(projection, "archived")
  [
    mini_town_inventory_shelf(
      id="buildings",
      title="Buildings",
      summary="Owned places and private work stay together.",
      count=owned.length(),
      status=if owned.length() > 0 { "ready" } else { "stable" },
      action_label="Show All",
      action_message="ownership-filter-all",
      target_tab="my",
    ),
    mini_town_inventory_shelf(
      id="placements",
      title="Placements",
      summary="Placed items return to the Realm map.",
      count=placements.length(),
      status=if placements.length() > 0 { "ready" } else { "stable" },
      action_label=if placements.length() > 0 {
        "Open Place"
      } else {
        "Show Placed"
      },
      action_message=if placements.length() > 0 {
        "select-\{placements[0].building_id}"
      } else {
        "ownership-filter-placements"
      },
      target_tab=if placements.length() > 0 { "realm" } else { "my" },
    ),
    mini_town_inventory_shelf(
      id="drafts",
      title="Drafts",
      summary="Private drafts can be submitted for review.",
      count=drafts,
      status=if drafts > 0 { "draft" } else { "stable" },
      action_label=if drafts > 0 { "Submit for review" } else { "Show Drafts" },
      action_message=if drafts > 0 {
        "submit-private-building"
      } else {
        "ownership-filter-drafts"
      },
      target_tab="my",
    ),
    mini_town_inventory_shelf(
      id="submitted",
      title="Submitted",
      summary="Submitted work waits for a reviewer decision.",
      count=submitted,
      status=if submitted > 0 { "review" } else { "stable" },
      action_label=if submitted > 0 { "Check Review" } else { "Show Work" },
      action_message=if submitted > 0 {
        "tab-messages"
      } else {
        "ownership-filter-all"
      },
      target_tab=if submitted > 0 { "messages" } else { "my" },
    ),
    mini_town_inventory_shelf(
      id="published",
      title="Published",
      summary="Public work can be discovered and placed.",
      count=published,
      status=if published > 0 { "published" } else { "stable" },
      action_label=if published > 0 {
        "Open Discover"
      } else {
        "Show Published"
      },
      action_message=if published > 0 {
        "tab-discover"
      } else {
        "ownership-filter-published"
      },
      target_tab=if published > 0 { "discover" } else { "my" },
    ),
    mini_town_inventory_shelf(
      id="archived",
      title="Archived",
      summary="Archived work can be restored when needed.",
      count=archived,
      status=if archived > 0 { "waiting" } else { "stable" },
      action_label=if archived > 0 { "Restore" } else { "Show Archive" },
      action_message=if archived > 0 {
        "restore-archived-building"
      } else {
        "ownership-filter-all"
      },
      target_tab="my",
    ),
    mini_town_inventory_shelf(
      id="books",
      title="Books",
      summary="Safe memory summaries stay tied to owned places.",
      count=books.length(),
      status=if books.length() > 0 { "ready" } else { "stable" },
      action_label=if books.length() > 0 {
        "Review Books"
      } else {
        "Show Books"
      },
      action_message=if books.length() > 0 {
        "tab-messages"
      } else {
        "ownership-filter-books"
      },
      target_tab=if books.length() > 0 { "messages" } else { "my" },
    ),
    mini_town_inventory_shelf(
      id="agents",
      title="Agents",
      summary="Workers attached to owned places are managed from Messages.",
      count=agents.length(),
      status=if agents.length() > 0 { "running" } else { "stable" },
      action_label=if agents.length() > 0 {
        "Message Agents"
      } else {
        "Show Agents"
      },
      action_message=if agents.length() > 0 {
        "tab-messages"
      } else {
        "ownership-filter-agents"
      },
      target_tab=if agents.length() > 0 { "messages" } else { "my" },
    ),
    mini_town_inventory_shelf(
      id="watched",
      title="Watched",
      summary="Watched public places stay attached to Realm.",
      count=watches.length(),
      status=if watches.length() > 0 { "ready" } else { "stable" },
      action_label=if watches.length() > 0 {
        "Open Place"
      } else {
        "Find Places"
      },
      action_message=if watches.length() > 0 {
        watches[0].action_message
      } else {
        "tab-discover"
      },
      target_tab=if watches.length() > 0 { "realm" } else { "discover" },
    ),
  ]
}
