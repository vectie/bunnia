///|
fn ownership_item_building_id(item : MiniTownOwnershipItem) -> String {
  if item.target_ref.has_prefix("building:") {
    item.target_ref.sub(start=9, end=item.target_ref.length()).to_owned()
  } else if item.action_message.has_prefix("select-") {
    item.action_message
    .sub(start=7, end=item.action_message.length())
    .to_owned()
  } else {
    ""
  }
}

///|
fn ownership_item_target_tab(item : MiniTownOwnershipItem) -> String {
  if item.action_message.has_prefix("tab-") {
    item.action_message
    .sub(start=4, end=item.action_message.length())
    .to_owned()
  } else if item.action_message.has_prefix("select-") {
    "realm"
  } else {
    "my"
  }
}
