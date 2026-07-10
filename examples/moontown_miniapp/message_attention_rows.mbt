///|
fn message_attention_rows(
  projection : MiniTownProjection,
) -> Array[MessageAttentionRow] {
  let rows : Array[MessageAttentionRow] = []
  push_attention_row(message_attention_review_row(projection), rows)
  push_attention_row(message_attention_failed_work_row(projection), rows)
  push_attention_row(message_attention_agent_work_row(projection), rows)
  rows
}

///|
fn push_attention_row(
  row : MessageAttentionRow?,
  rows : Array[MessageAttentionRow],
) -> Unit {
  if row is Some(row) {
    rows.push(row)
  }
}
