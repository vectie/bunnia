///|
fn message_attention_lead_entry(row : MessageAttentionRow) -> @bunnia.Node {
  @bunnia.keyed(
    "attention-lead-\{row.id}",
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name(
          "moontown-message-lead moontown-home-lead bunnia-status-\{row.status}",
        ),
        @bunnia.data("attention-id", row.id),
        @bunnia.data("building-id", row.building_id),
      ],
      [
        @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
          @bunnia.text(row.title),
        ]),
        @bunnia.text(row.summary),
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-run-actions")], [
          @bunnia.node(
            kind="button",
            attrs=[@bunnia.class_name("moontown-primary-action")],
            events=[@bunnia.tap(row.action_message)],
            children=[@bunnia.text(row.action_label)],
          ),
        ]),
      ],
    ),
  )
}
