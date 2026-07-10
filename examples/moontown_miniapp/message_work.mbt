///|
fn agent_work_panel(projection : MiniTownProjection) -> @bunnia.Node {
  let runs = active_runs(projection)
  let results = visible_tool_results(projection)
  @bunnia.view_with_attrs(
    [@bunnia.class_name("mt-panel moontown-message-work")],
    [
      @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-title")], [
        @bunnia.text("Agent Work"),
      ]),
      @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-note")], [
        @bunnia.text(
          "Active work, failed work, and completed results by place.",
        ),
      ]),
      @bunnia.windowed_list(runs, total_count=runs.length(), render=run => {
        run_queue_entry(projection, run)
      }),
      @bunnia.view_with_attrs([@bunnia.class_name("moontown-section-label")], [
        @bunnia.text("Completed Results"),
      ]),
      @bunnia.view_with_attrs([@bunnia.class_name("moontown-agent-results")], [
        @bunnia.windowed_list(results, total_count=results.length(), render=item => {
          agent_result_entry(projection, item)
        }),
      ]),
    ],
  )
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
          @bunnia.list(available_run_actions(run), run_action_button),
        ]),
      ],
    ),
  )
}

///|
fn run_action_button(action : MiniTownRunAction) -> @bunnia.Node {
  let attrs = [
    @bunnia.class_name(run_action_class(action)),
    @bunnia.data("run-action", action.id),
  ]
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
