///|
fn message_attention_lead(projection : MiniTownProjection) -> @bunnia.Node {
  let rows = message_attention_rows(projection)
  message_attention_lead_entry(rows[0])
}
