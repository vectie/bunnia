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
  let waiting_on_refresh = alerts.length() > 0 &&
    (
      alerts[0].action_message == "load-ownership-snapshot" ||
      alerts[0].action_message == "load-town-snapshot"
    )
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-my-attention")], [
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("mt-title"),
        @bunnia.attr(
          "wx:if",
          if waiting_on_refresh {
            "{{!(ui.feedback == 'inventory' ? requestState.state == 'ready' : false)}}"
          } else {
            "{{true}}"
          },
        ),
      ],
      [
        @bunnia.text(
          if alerts.length() > 0 {
            "Needs You"
          } else {
            "All Clear"
          },
        ),
      ],
    ),
    if waiting_on_refresh {
      @bunnia.view_with_attrs(
        [
          @bunnia.class_name("mt-title bunnia-status-stable"),
          @bunnia.attr(
            "wx:if", "{{ui.feedback == 'inventory' ? requestState.state == 'ready' : false}}",
          ),
        ],
        [@bunnia.text("All Clear")],
      )
    } else {
      @bunnia.view([])
    },
    @bunnia.view_with_attrs(
      [
        @bunnia.attr(
          "wx:if",
          if waiting_on_refresh {
            "{{!(ui.feedback == 'inventory' ? requestState.state == 'ready' : false)}}"
          } else {
            "{{true}}"
          },
        ),
      ],
      [
        @bunnia.windowed_list(
          visible_alerts,
          total_count=visible_alerts.length(),
          render=workbench_alert_entry,
        ),
      ],
    ),
  ])
}
