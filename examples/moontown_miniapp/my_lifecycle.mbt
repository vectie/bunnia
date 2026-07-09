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
  let children = [
    @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-title")], [
      @bunnia.text(title),
    ]),
    @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-note")], [
      @bunnia.text(note),
    ]),
  ]
  if steps.length() > 0 {
    children.push(
      @bunnia.windowed_list(
        steps,
        total_count=steps.length(),
        render=publication_step_entry,
      ),
    )
  }
  children.push(
    @bunnia.windowed_list(
      events,
      total_count=events.length(),
      render=audit_entry,
    ),
  )
  @bunnia.view_with_attrs([@bunnia.class_name("mt-panel")], children)
}

///|
fn publication_step_entry(item : MiniTownPublicationStep) -> @bunnia.Node {
  @bunnia.keyed(
    "publication-step-\{item.id}",
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name(
          "moontown-publication-step bunnia-status-\{item.status}",
        ),
        @bunnia.data("publication-step", item.id),
        @bunnia.data("current", if item.current { "true" } else { "false" }),
        @bunnia.data("complete", if item.complete { "true" } else { "false" }),
        @bunnia.data("blocked", if item.blocked { "true" } else { "false" }),
      ],
      [
        @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
          @bunnia.text(item.label),
        ]),
        @bunnia.text(item.summary),
      ],
    ),
  )
}

///|
fn audit_entry(item : MiniTownAuditEvent) -> @bunnia.Node {
  @bunnia.keyed(
    "audit-\{item.id}",
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("moontown-audit-entry bunnia-status-\{item.status}"),
        @bunnia.data("building-id", item.building_id),
      ],
      [
        @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
          @bunnia.text(item.title),
        ]),
        @bunnia.text(item.summary),
        @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
          @bunnia.text(
            "\{ownership_event_label(item.kind)} - \{town_visibility_label(item.visibility)} - \{town_status_label(item.status)}",
          ),
        ]),
      ],
    ),
  )
}

///|
fn ownership_event_label(kind : String) -> String {
  if kind == "create" {
    "Created"
  } else if kind == "update" {
    "Updated"
  } else if kind == "share" {
    "Shared"
  } else if kind == "submit" {
    "Submitted"
  } else if kind == "publish" {
    "Published"
  } else if kind == "archive" {
    "Archived"
  } else if kind == "restore" {
    "Restored"
  } else {
    "Changed"
  }
}
