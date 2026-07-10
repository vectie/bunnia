///|
fn messages_surface_panels(
  projection : MiniTownProjection,
) -> Array[@bunnia.Node] {
  [
    messages_panel(projection),
    review_queue_panel(projection),
    agent_work_panel(projection),
    message_notices_panel(projection),
  ]
}
