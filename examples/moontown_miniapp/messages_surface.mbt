///|
fn messages_surface_panels(
  projection : MiniTownProjection,
) -> Array[@bunnia.Node] {
  let panels = [
    message_notices_panel(projection),
    supervisor_phone_registration_cta(),
    supervisor_phone_panel(projection),
  ]
  panels.push(messages_panel(projection))
  panels.push(marketplace_action_request_panel())
  panels.push(child_task_control_panel(projection))
  panels.push(review_queue_panel(projection))
  panels.push(agent_work_panel(projection))
  panels.push(acceptance_receipts_panel(projection))
  panels
}
