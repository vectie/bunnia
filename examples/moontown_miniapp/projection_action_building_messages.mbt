///|
pub fn send_message_to_selected_building(
  projection : MiniTownProjection,
  body : String,
) -> MiniTownProjection {
  let building = selected_building(projection)
  let message = mini_town_message(
    id="msg-local-preview",
    actor_id=projection.active_user_id,
    thread_id="thread-\{building.id}",
    text=body,
    status=@bunnia.run_running(),
  )
  { ..projection, messages: projection.messages + [message] }
}
