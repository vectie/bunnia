///|
fn messages_surface_panels(
  projection : MiniTownProjection,
) -> Array[@bunnia.Node] {
  let panels : Array[@bunnia.Node] = [message_notices_panel(projection)]
  if message_attention_rows(projection).length() > 0 {
    panels.push(messages_panel(projection))
  }
  panels.push(review_queue_panel(projection))
  panels.push(agent_work_panel(projection))
  panels
}
