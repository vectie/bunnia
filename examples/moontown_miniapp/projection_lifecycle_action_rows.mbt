///|
pub fn selected_building_lifecycle_actions(
  projection : MiniTownProjection,
) -> Array[MiniTownLifecycleAction] {
  let building = selected_building(projection)
  let book = selected_building_book(projection)
  [
    lifecycle_ask_action(building, book),
    lifecycle_edit_action(projection, building, book),
    lifecycle_place_action(building, book),
    lifecycle_share_action(projection, building, book),
    lifecycle_submit_action(projection, building, book),
    lifecycle_publish_action(projection, building, book),
    lifecycle_archive_action(projection, building, book),
    lifecycle_restore_action(projection, building, book),
  ]
}
