///|
priv struct MiniTownInventoryShelf {
  id : String
  title : String
  summary : String
  count : Int
  status : String
  action_label : String
  action_message : String
  target_tab : String
}

///|
fn mini_town_inventory_shelf(
  id~ : String,
  title~ : String,
  summary~ : String,
  count~ : Int,
  status~ : String,
  action_label~ : String,
  action_message~ : String,
  target_tab~ : String,
) -> MiniTownInventoryShelf {
  {
    id,
    title,
    summary,
    count,
    status,
    action_label,
    action_message,
    target_tab,
  }
}

///|
fn inventory_shelf_count_text(row : MiniTownInventoryShelf) -> String {
  count_label(row.count, "item", "items")
}
