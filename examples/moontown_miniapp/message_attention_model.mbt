///|
priv struct MessageAttentionRow {
  id : String
  title : String
  summary : String
  status : String
  action_label : String
  action_message : String
  building_id : String
}

///|
fn message_attention_row(
  id~ : String,
  title~ : String,
  summary~ : String,
  status~ : String,
  action_label~ : String,
  action_message~ : String,
  building_id~ : String,
) -> MessageAttentionRow {
  { id, title, summary, status, action_label, action_message, building_id }
}
