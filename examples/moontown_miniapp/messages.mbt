///|
// Messages opens as an inbox; its highest-priority work follows the chat list.

///|
fn messages_panel(projection : MiniTownProjection) -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-message-inbox"),
      @bunnia.attr(
        "wx:if", "{{messages.mode == 'work' && messages.channel == 'tasks'}}",
      ),
    ],
    [message_attention_lead(projection)],
  )
}
