///|
fn ownership_lifecycle_panel(projection : MiniTownProjection) -> @bunnia.Node {
  let visible_steps : Array[MiniTownPublicationStep] = []
  for step in publication_steps(projection) {
    if step.current || step.blocked {
      visible_steps.push(step)
    }
  }
  @bunnia.view_with_attrs(
    [@bunnia.class_name("mt-panel moontown-my-lifecycle")],
    [
      @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-title")], [
        @bunnia.text("Publishing Shelf"),
      ]),
      publication_step_list(visible_steps),
      audit_event_list(owned_audit_events(projection)),
    ],
  )
}
