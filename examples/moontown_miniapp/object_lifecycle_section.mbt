///|
fn building_lifecycle_section(projection : MiniTownProjection) -> @bunnia.Node {
  let actions = selected_building_lifecycle_actions(projection)
  let building = selected_building(projection)
  let stages = lifecycle_stage_rows(building)
  object_section(
    section_id="lifecycle",
    title="Lifecycle Stamps",
    note="Private draft, team sharing, review, publishing, hiding, and archive states stay visible.",
    extra_class="moontown-lifecycle-section",
    children=[
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-lifecycle-stages")],
        [
          @bunnia.windowed_list(
            stages,
            total_count=stages.length(),
            render=lifecycle_stage_entry,
          ),
        ],
      ),
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-lifecycle-actions")],
        [
          @bunnia.windowed_list(
            actions,
            total_count=actions.length(),
            render=lifecycle_action_button,
          ),
        ],
      ),
    ],
  )
}
