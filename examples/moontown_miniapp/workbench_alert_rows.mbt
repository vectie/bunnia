///|
fn workbench_alert_entry(alert : MiniTownWorkbenchAlert) -> @bunnia.Node {
  @bunnia.keyed(
    "workbench-alert-\{alert.id}",
    @bunnia.node(
      kind="view",
      attrs=[
        @bunnia.class_name(
          "moontown-workbench-alert bunnia-status-\{alert.status}",
        ),
        @bunnia.data("workbench-alert", alert.id),
        @bunnia.data("severity", alert.severity),
        @bunnia.data("status", alert.status),
      ],
      events=[@bunnia.event("tap", alert.action_message)],
      children=[
        @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
          @bunnia.text(alert.title),
        ]),
        @bunnia.text(alert.summary),
        @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
          @bunnia.text(
            "\{town_status_label(alert.status)} - \{alert.action_label}",
          ),
        ]),
      ],
    ),
  )
}
