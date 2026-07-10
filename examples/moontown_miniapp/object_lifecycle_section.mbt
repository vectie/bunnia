///|
fn building_lifecycle_section(projection : MiniTownProjection) -> @bunnia.Node {
  let actions = available_lifecycle_actions(projection)
  let building = selected_building(projection)
  let stages = lifecycle_stage_rows(building)
  let children : Array[@bunnia.Node] = [
    @bunnia.view_with_attrs([@bunnia.class_name("moontown-lifecycle-stages")], [
      @bunnia.windowed_list(
        stages,
        total_count=stages.length(),
        render=lifecycle_stage_entry,
      ),
    ]),
  ]
  if actions.length() > 0 {
    children.push(
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
    )
  }
  object_section(
    section_id="lifecycle",
    title="Lifecycle Stamps",
    note="\{town_visibility_label(building.visibility)} - \{town_status_label(building.status)}",
    extra_class="moontown-lifecycle-section",
    children~,
  )
}

///|
fn available_lifecycle_actions(
  projection : MiniTownProjection,
) -> Array[MiniTownLifecycleAction] {
  let actions : Array[MiniTownLifecycleAction] = []
  for action in selected_building_lifecycle_actions(projection) {
    if action.allowed && action.id != "ask" {
      actions.push(action)
    }
  }
  actions
}
