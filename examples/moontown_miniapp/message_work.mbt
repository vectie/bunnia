///|
fn run_queue_panel(projection : MiniTownProjection) -> @bunnia.Node {
  let runs = active_runs(projection)
  @bunnia.view_with_attrs([@bunnia.class_name("mt-panel")], [
    @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-title")], [
      @bunnia.text("Agent Work"),
    ]),
    @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-note")], [
      @bunnia.text(
        "Agent work stays attached to places, books, and review decisions.",
      ),
    ]),
    @bunnia.windowed_list(runs, total_count=runs.length(), render=run => {
      run_queue_entry(projection, run)
    }),
  ])
}

///|
fn run_queue_entry(
  projection : MiniTownProjection,
  run : MiniTownRun,
) -> @bunnia.Node {
  @bunnia.keyed(
    "run-queue-\{run.id}",
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("moontown-run-entry bunnia-status-\{run.status}"),
        @bunnia.data("building-id", run.building_id),
        @bunnia.data("book-id", run.book_id),
      ],
      [
        @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
          @bunnia.text(run.title),
        ]),
        @bunnia.text(run.summary),
        @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
          @bunnia.text(run_context_text(projection, run)),
        ]),
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-run-actions")], [
          @bunnia.list(run_actions(run), run_action_button),
        ]),
      ],
    ),
  )
}

///|
fn run_action_button(action : MiniTownRunAction) -> @bunnia.Node {
  let attrs = [
    @bunnia.class_name("moontown-run-action \{action.status}"),
    @bunnia.data("run-action", action.id),
    @bunnia.data("allowed", if action.allowed { "true" } else { "false" }),
    @bunnia.data("blocked-reason", action.reason),
  ]
  if !action.allowed {
    attrs.push(@bunnia.attr("disabled", "true"))
  }
  @bunnia.keyed(
    "run-action-\{action.id}",
    @bunnia.node(
      kind="button",
      attrs~,
      events=[@bunnia.event("tap", action.message)],
      children=[@bunnia.text(run_action_display_label(action))],
    ),
  )
}

///|
fn run_context_text(
  projection : MiniTownProjection,
  run : MiniTownRun,
) -> String {
  "\{town_status_label(run.status)} - \{building_title_by_id(projection, run.building_id)} - \{book_title_by_id(projection, run.book_id)}"
}

///|
fn run_action_display_label(action : MiniTownRunAction) -> String {
  if action.message == "retry-run" {
    "Try Again"
  } else if action.message == "cancel-run" {
    "Stop Work"
  } else {
    action.label
  }
}
