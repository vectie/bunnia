///|
fn child_task_control_panel(projection : MiniTownProjection) -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("mt-panel moontown-child-task-board"),
      @bunnia.attr(
        "wx:if", "{{messages.mode == 'work' && messages.channel == 'tasks'}}",
      ),
    ],
    [
      @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-title")], [
        @bunnia.text("Child Task Board"),
      ]),
      @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-note")], [
        @bunnia.text(
          "The supervisor can use at most \{projection.supervisor.child_limit} bounded workers. Steer, stop, or retry each task here.",
        ),
      ]),
      runtime_child_task_rows(),
      message_command_state(
        "child-steer", "Sending new guidance…", "Guidance recorded for the selected child task.",
        "Guidance was not saved.",
      ),
      message_command_state(
        "cancel", "Stopping child work…", "Child work stopped.", "Could not stop this task.",
      ),
      message_command_state(
        "retry", "Retrying child work…", "Child work restarted.", "Could not retry this task.",
      ),
      message_command_state(
        "bookkeeper-review", "Sending exact outcome evidence to Bookkeeper…", "Bookkeeper review requested; no outcome was auto-accepted.",
        "Bookkeeper review was not requested.",
      ),
    ],
  )
}

///|
fn runtime_child_task_rows() -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("bunnia-list-windowed"),
      @bunnia.attr("wx:for", "{{onboardingSnapshot.executionLineage}}"),
      @bunnia.attr("wx:for-item", "child"),
      @bunnia.attr("wx:key", "handoffId"),
      @bunnia.attr("wx:if", "{{child.workerRunId || child.worker_run_id}}"),
    ],
    [@bunnia.keyed("child-task-row-template", runtime_child_task_row())],
  )
}

///|
fn runtime_child_task_row() -> @bunnia.Node {
  let runtime_status = "child.runtimeExecutionStatus || child.runtime_execution_status || child.status || 'queued'"
  let child_run_id = "child.workerRunId || child.worker_run_id || child.runId || child.run_id"
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name(
        "moontown-child-task bunnia-status-{{\{runtime_status}}}",
      ),
      @bunnia.data("run-id", "{{\{child_run_id}}}"),
      @bunnia.data(
        "parent-run-id", "{{child.parentRunId || child.parent_run_id}}",
      ),
    ],
    [
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-child-task-head")],
        [
          @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
            @bunnia.text("{{child.title || 'Bounded worker task'}}"),
          ]),
          @bunnia.view_with_attrs(
            [@bunnia.class_name("moontown-receipt-stamp {{\{runtime_status}}}")],
            [@bunnia.text("{{\{runtime_status}}}")],
          ),
        ],
      ),
      @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
        @bunnia.text(
          "Worker {{child.workerRunId || child.worker_run_id}} · receipt-backed child of this supervisor",
        ),
      ]),
      @bunnia.view_with_attrs(
        [
          @bunnia.class_name(
            "moontown-phone-command-state bunnia-status-pending",
          ),
          @bunnia.attr(
            "wx:if",
            "{{(\{runtime_status}) == 'pending_provider' || (\{runtime_status}) == 'queued'}}",
          ),
          @bunnia.attr("aria-live", "polite"),
        ],
        [
          @bunnia.text(
            "Queued · waiting for the runtime provider. Controls unlock when work starts.",
          ),
        ],
      ),
      runtime_child_active_controls(runtime_status, child_run_id),
      runtime_child_retry_control(runtime_status, child_run_id),
      runtime_child_outcome_control(runtime_status, child_run_id),
    ],
  )
}

///|
fn runtime_child_active_controls(
  runtime_status : String,
  child_run_id : String,
) -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-child-task-controls"),
      @bunnia.attr(
        "wx:if",
        "{{(\{runtime_status}) == 'running' || (\{runtime_status}) == 'waiting_for_input'}}",
      ),
    ],
    [
      setup_field_label("Guidance"),
      setup_bound_input(
        name="runGuidance",
        value="{{runSteer.guidance}}",
        state_path="runSteer.guidance",
        message="edit-run-guidance",
      ),
      @bunnia.node(
        kind="button",
        attrs=[@bunnia.data("run-id", "{{\{child_run_id}}}")],
        events=[@bunnia.tap("steer-child-run")],
        children=[@bunnia.text("Steer")],
      ),
      @bunnia.node(
        kind="button",
        attrs=[
          @bunnia.class_name("moontown-danger-action"),
          @bunnia.data("run-id", "{{\{child_run_id}}}"),
        ],
        events=[@bunnia.tap("cancel-run")],
        children=[@bunnia.text("Stop")],
      ),
    ],
  )
}

///|
fn runtime_child_retry_control(
  runtime_status : String,
  child_run_id : String,
) -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-run-actions"),
      @bunnia.attr(
        "wx:if",
        "{{(\{runtime_status}) == 'failed' || (\{runtime_status}) == 'cancelled'}}",
      ),
    ],
    [
      @bunnia.node(
        kind="button",
        attrs=[
          @bunnia.class_name("moontown-primary-action"),
          @bunnia.data("run-id", "{{\{child_run_id}}}"),
        ],
        events=[@bunnia.tap("retry-run")],
        children=[@bunnia.text("Try Again")],
      ),
    ],
  )
}

///|
fn runtime_child_outcome_control(
  runtime_status : String,
  child_run_id : String,
) -> @bunnia.Node {
  let full_evidence = "(child.outcomeEvidenceStatus == 'review_ready' || child.outcome_evidence_status == 'review_ready') && child.outcomeSubmission && child.outcomeSubmission.contract_version == 'moonbook.bookkeeper.product_outcome_submission.v1' && child.outcomeSubmission.source_product == 'moonclaw' && child.outcomeSubmission.submission && child.outcomeSubmission.submission.record_id && child.outcomeSubmission.submission.record_version && child.outcomeSubmission.submission.record_digest && child.outcomeSubmission.evidence_refs && child.outcomeSubmission.evidence_refs.length"
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-run-actions"),
      @bunnia.attr("wx:if", "{{(\{runtime_status}) == 'succeeded'}}"),
    ],
    [
      @bunnia.node(
        kind="button",
        attrs=[
          @bunnia.class_name("moontown-primary-action"),
          @bunnia.attr("wx:if", "{{\{full_evidence}}}"),
          @bunnia.data("run-id", "{{\{child_run_id}}}"),
          @bunnia.data("summary", "{{child.summary}}"),
        ],
        events=[@bunnia.tap("request-bookkeeper-review")],
        children=[@bunnia.text("Request Bookkeeper review")],
      ),
      @bunnia.view_with_attrs(
        [
          @bunnia.class_name("moontown-phone-command-state"),
          @bunnia.attr("wx:if", "{{!(\{full_evidence})}}"),
        ],
        [@bunnia.text("Outcome evidence still required")],
      ),
    ],
  )
}
