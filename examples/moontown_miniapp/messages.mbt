///|
// Message Inbox assembly stays compact; detailed work and notices live beside it.

///|
fn messages_panel(projection : MiniTownProjection) -> @bunnia.Node {
  let unread = unread_notifications(projection)
  let reviews = pending_reviews(projection)
  let failed = failed_run_count(projection)
  @bunnia.view_with_attrs(
    [@bunnia.class_name("mt-panel moontown-message-inbox")],
    [
      @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-title")], [
        @bunnia.text("Message Inbox"),
      ]),
      @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-note")], [
        @bunnia.text(
          "\{reviews.length()} decisions, \{failed} failed items, \{unread.length()} unread.",
        ),
      ]),
      message_attention_lead(projection),
      message_bucket_row(projection),
    ],
  )
}
