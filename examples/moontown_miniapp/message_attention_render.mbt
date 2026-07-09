///|
fn message_attention_row_entry(row : MessageAttentionRow) -> @bunnia.Node {
  @bunnia.keyed(
    "attention-row-\{row.id}",
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("moontown-attention-row bunnia-status-\{row.status}"),
        @bunnia.data("building-id", row.building_id),
      ],
      [
        @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
          @bunnia.text(row.title),
        ]),
        @bunnia.text(row.summary),
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-run-actions")], [
          @bunnia.button(row.action_label, row.action_message),
        ]),
      ],
    ),
  )
}
