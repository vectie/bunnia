///|
fn ownership_lifecycle_panel(projection : MiniTownProjection) -> @bunnia.Node {
  lifecycle_panel_with_events(
    "Publishing Shelf",
    "Drafts, shares, review steps, published places, and archives stay visible here.",
    publication_steps(projection),
    owned_audit_events(projection),
  )
}

///|
fn lifecycle_panel_with_events(
  title : String,
  note : String,
  steps : Array[MiniTownPublicationStep],
  events : Array[MiniTownAuditEvent],
) -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [@bunnia.class_name("mt-panel")],
    lifecycle_panel_children(title, note, steps, events),
  )
}

///|
fn lifecycle_panel_children(
  title : String,
  note : String,
  steps : Array[MiniTownPublicationStep],
  events : Array[MiniTownAuditEvent],
) -> Array[@bunnia.Node] {
  let children = [
    @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-title")], [
      @bunnia.text(title),
    ]),
    @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-note")], [
      @bunnia.text(note),
    ]),
  ]
  if steps.length() > 0 {
    children.push(publication_step_list(steps))
  }
  children.push(audit_event_list(events))
  children
}
