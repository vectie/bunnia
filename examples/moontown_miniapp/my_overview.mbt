///|
fn my_overview_panel(projection : MiniTownProjection) -> @bunnia.Node {
  let alerts = workbench_alerts(projection)
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-my-overview"),
      @bunnia.data("attention-count", alerts.length().to_string()),
    ],
    [profile_identity_card(projection), my_attention_queue(alerts)],
  )
}

///|
fn my_attention_queue(alerts : Array[MiniTownWorkbenchAlert]) -> @bunnia.Node {
  let visible_alerts : Array[MiniTownWorkbenchAlert] = []
  if alerts.length() > 0 {
    visible_alerts.push(alerts[0])
  }
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-my-attention")], [
    @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
      @bunnia.text(if alerts.length() > 0 { "Needs You" } else { "All Clear" }),
    ]),
    @bunnia.windowed_list(
      visible_alerts,
      total_count=visible_alerts.length(),
      render=workbench_alert_entry,
    ),
  ])
}
