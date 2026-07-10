///|
fn audit_event_list(events : Array[MiniTownAuditEvent]) -> @bunnia.Node {
  @bunnia.windowed_list(events, total_count=events.length(), render=audit_entry)
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
          @bunnia.text(ownership_event_meta(item)),
        ]),
      ],
    ),
  )
}

///|
fn ownership_event_meta(item : MiniTownAuditEvent) -> String {
  "\{ownership_event_label(item.kind)} - \{town_visibility_label(item.visibility)} - \{town_status_label(item.status)}"
}
