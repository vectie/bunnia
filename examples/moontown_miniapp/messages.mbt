///|
// Messages leads with one decision; detailed work and notices follow it.

///|
fn messages_panel(projection : MiniTownProjection) -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-message-inbox")], [
    message_attention_lead(projection),
  ])
}
