///|
fn message_attention_actions() -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-community-actions")], [
    @bunnia.button("Latest Messages", "load-message-center"),
    @bunnia.button("More", "load-message-center"),
  ])
}

///|
fn message_attention_stack(projection : MiniTownProjection) -> @bunnia.Node {
  let rows = message_attention_rows(projection)
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-attention-rows")], [
    @bunnia.windowed_list(
      rows,
      total_count=rows.length(),
      render=message_attention_row_entry,
    ),
  ])
}
