///|
fn onboarding_panel(projection : MiniTownProjection) -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("mt-panel")], [
    @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-title")], [
      @bunnia.text("First Visit"),
    ]),
    @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-note")], [
      @bunnia.text("Choose what to do first, then enter the tile town."),
    ]),
    @bunnia.windowed_list(
      projection.onboarding_steps,
      total_count=projection.onboarding_steps.length(),
      render=onboarding_step_entry,
    ),
    guide_strip(projection),
    @bunnia.button("Enter Realm", "complete-onboarding"),
  ])
}

///|
fn guide_strip(projection : MiniTownProjection) -> @bunnia.Node {
  let steps = guide_steps(projection)
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-guide-strip")], [
    @bunnia.windowed_list(
      steps,
      total_count=steps.length(),
      render=guide_step_entry,
    ),
  ])
}

///|
fn guide_step_entry(step : MiniTownGuideStep) -> @bunnia.Node {
  @bunnia.keyed(
    "guide-\{step.id}",
    @bunnia.node(
      kind="view",
      attrs=[
        @bunnia.class_name("moontown-guide-step bunnia-status-\{step.status}"),
        @bunnia.data("guide-step", step.id),
        @bunnia.data("tab-id", step.tab_id),
        @bunnia.data("building-id", step.building_id),
        @bunnia.data("complete", if step.complete { "true" } else { "false" }),
        @bunnia.data("bunnia-route", moontown_tab_route(step.tab_id)),
      ],
      events=[@bunnia.event("tap", step.action_message)],
      children=[
        @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
          @bunnia.text(step.title),
        ]),
        @bunnia.text(step.summary),
        @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
          @bunnia.text(
            "\{step.action_label} - \{town_status_label(step.status)}",
          ),
        ]),
      ],
    ),
  )
}

///|
fn onboarding_step_entry(step : MiniTownOnboardingStep) -> @bunnia.Node {
  @bunnia.keyed(
    "onboarding-\{step.id}",
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("moontown-onboarding-step"),
        @bunnia.data("building-id", step.building_id),
      ],
      [
        @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
          @bunnia.text(step.title),
        ]),
        @bunnia.text(step.body),
      ],
    ),
  )
}

///|
