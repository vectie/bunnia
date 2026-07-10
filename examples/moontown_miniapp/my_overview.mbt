///|
fn my_overview_panel(projection : MiniTownProjection) -> @bunnia.Node {
  let alerts = workbench_alerts(projection)
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("mt-panel moontown-my-overview"),
      @bunnia.data("attention-count", alerts.length().to_string()),
    ],
    [
      @bunnia.view_with_attrs([@bunnia.class_name("moontown-my-heading")], [
        @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-title")], [
          @bunnia.text("My Town"),
        ]),
        @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-note")], [
          @bunnia.text("Identity first, then the work that needs you."),
        ]),
      ]),
      profile_identity_card(projection),
      my_attention_queue(alerts),
    ],
  )
}

///|
fn my_attention_queue(alerts : Array[MiniTownWorkbenchAlert]) -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-my-attention")], [
    @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
      @bunnia.text(if alerts.length() > 0 { "Needs You" } else { "All Clear" }),
    ]),
    @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
      @bunnia.text(
        if alerts.length() > 0 {
          "\{alerts.length()} actions are ready to continue."
        } else {
          "No profile, publishing, or recovery actions need attention."
        },
      ),
    ]),
    @bunnia.windowed_list(
      alerts,
      total_count=alerts.length(),
      render=workbench_alert_entry,
    ),
  ])
}
