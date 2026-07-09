///|
priv struct BuildingContextCard {
  id : String
  title : String
  summary : String
  meta : String
  status : String
  action_label : String
  action_message : String
}

///|
fn building_context_card(
  id~ : String,
  title~ : String,
  summary~ : String,
  meta~ : String,
  status~ : String,
  action_label~ : String,
  action_message~ : String,
) -> BuildingContextCard {
  { id, title, summary, meta, status, action_label, action_message }
}
