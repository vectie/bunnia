///|
priv struct HomePulseRow {
  id : String
  title : String
  summary : String
  status : String
  action_label : String
  action_message : String
  target_tab : String
}

///|
fn home_pulse_row(
  id~ : String,
  title~ : String,
  summary~ : String,
  status~ : String,
  action_label~ : String,
  action_message~ : String,
  target_tab~ : String,
) -> HomePulseRow {
  { id, title, summary, status, action_label, action_message, target_tab }
}
