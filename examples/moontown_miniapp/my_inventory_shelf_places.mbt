///|
fn inventory_buildings_shelf(count : Int) -> MiniTownInventoryShelf {
  mini_town_inventory_shelf(
    id="buildings",
    title="Buildings",
    summary="Owned places and private work stay together.",
    count~,
    status=if count > 0 { "ready" } else { "stable" },
    action_label="Show All",
    action_message="ownership-filter-all",
    target_tab="my",
  )
}

///|
fn inventory_placements_shelf(
  placements : Array[MiniTownPlacement],
) -> MiniTownInventoryShelf {
  let has_place = placements.length() > 0
  mini_town_inventory_shelf(
    id="placements",
    title="Placements",
    summary="Placed items return to the Realm map.",
    count=placements.length(),
    status=if has_place { "ready" } else { "stable" },
    action_label=if has_place { "Open Place" } else { "Show Placed" },
    action_message=if has_place {
      "select-\{placements[0].building_id}"
    } else {
      "ownership-filter-placements"
    },
    target_tab=if has_place { "realm" } else { "my" },
  )
}

///|
fn inventory_watched_shelf(
  watches : Array[MiniTownWatch],
) -> MiniTownInventoryShelf {
  let has_watch = watches.length() > 0
  mini_town_inventory_shelf(
    id="watched",
    title="Watched",
    summary="Watched public places stay attached to Realm.",
    count=watches.length(),
    status=if has_watch { "ready" } else { "stable" },
    action_label=if has_watch { "Open Place" } else { "Find Places" },
    action_message=if has_watch {
      watches[0].action_message
    } else {
      "tab-discover"
    },
    target_tab=if has_watch { "realm" } else { "discover" },
  )
}
