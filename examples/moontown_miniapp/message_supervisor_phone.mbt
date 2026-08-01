///|
fn supervisor_phone_panel(_projection : MiniTownProjection) -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("mt-panel moontown-supervisor-phone"),
      @bunnia.attr(
        "wx:if",
        "{{messages.mode == 'work' && (messages.channel == 'all' || messages.channel == 'supervisor') && (\{supervisor_runtime_ready_condition()})}}",
      ),
      @bunnia.data(
        "supervisor-id", "{{onboardingSnapshot.profile && (onboardingSnapshot.profile.profileId || onboardingSnapshot.profile.profile_id)}}",
      ),
      @bunnia.data(
        "profile-id", "{{onboardingSnapshot.profile && (onboardingSnapshot.profile.profileId || onboardingSnapshot.profile.profile_id)}}",
      ),
      @bunnia.data(
        "active-run-id", "{{activationResult.activeRunId || activationResult.activation.activeRunId || onboardingSnapshot.activeRunId || onboardingSnapshot.activation.activeRunId || activationResult.active_run_id || activationResult.activation.active_run_id || onboardingSnapshot.active_run_id || onboardingSnapshot.activation.active_run_id}}",
      ),
    ],
    [
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-supervisor-phone-head")],
        [
          supervisor_runtime_avatar(),
          @bunnia.view_with_attrs(
            [@bunnia.class_name("moontown-binding-copy")],
            [
              @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
                @bunnia.text(
                  "{{(onboardingSnapshot.profile && onboardingSnapshot.profile.identity && (onboardingSnapshot.profile.identity.displayName || onboardingSnapshot.profile.identity.display_name)) || 'Supervisor'}}",
                ),
              ]),
              @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
                @bunnia.text(
                  "Runtime acknowledged · {{supervisorRuntime.activeWorkerCount || 0}}/{{supervisorRuntime.maxActiveWorkers || 3}} active workers",
                ),
              ]),
            ],
          ),
        ],
      ),
      supervisor_lifecycle_controls(),
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-supervisor-thread")],
        [
          @bunnia.view_with_attrs(
            [
              @bunnia.class_name("moontown-phone-command-state"),
              @bunnia.attr(
                "wx:if", "{{activationResult.runtimeExecutionStatus == 'pending_provider' || activationResult.activation.runtimeExecutionStatus == 'pending_provider' || onboardingSnapshot.runtimeExecutionStatus == 'pending_provider' || onboardingSnapshot.activation.runtimeExecutionStatus == 'pending_provider' || activationResult.runtime_execution_status == 'pending_provider' || activationResult.activation.runtime_execution_status == 'pending_provider' || onboardingSnapshot.runtime_execution_status == 'pending_provider' || onboardingSnapshot.activation.runtime_execution_status == 'pending_provider'}}",
              ),
              @bunnia.attr("aria-live", "polite"),
            ],
            [
              @bunnia.text(
                "Delegated child queued · waiting for the runtime provider.",
              ),
            ],
          ),
          @bunnia.view_with_attrs(
            [@bunnia.class_name("moontown-supervisor-bubble agent intro")],
            [
              @bunnia.text(
                "I can plan bounded work, assign child tasks, and bring proposals back for review.",
              ),
            ],
          ),
          @bunnia.view_with_attrs(
            [
              @bunnia.class_name("moontown-supervisor-bubble user"),
              @bunnia.attr(
                "wx:if", "{{supervisorMessageResult && supervisorMessageResult.handoffId && supervisorMessage.body}}",
              ),
            ],
            [@bunnia.text("{{supervisorMessage.body}}")],
          ),
          @bunnia.view_with_attrs(
            [
              @bunnia.class_name(
                "moontown-supervisor-bubble {{conversationItem.role == 'assistant' ? 'agent live' : 'user'}}",
              ),
              @bunnia.attr(
                "wx:for", "{{onboardingSnapshot.conversationHistory}}",
              ),
              @bunnia.attr("wx:for-item", "conversationItem"),
              @bunnia.attr("wx:key", "eventId"),
            ],
            [
              @bunnia.text("{{conversationItem.content}}"),
              @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
                @bunnia.text(
                  "Replay-backed · cursor {{conversationItem.cursor}}",
                ),
              ]),
            ],
          ),
          @bunnia.view_with_attrs(
            [
              @bunnia.class_name("moontown-supervisor-bubble agent live"),
              @bunnia.attr(
                "wx:if", "{{(!onboardingSnapshot.conversationHistory || !onboardingSnapshot.conversationHistory.length) && onboardingSnapshot.assistantResponse && onboardingSnapshot.assistantResponse.response && onboardingSnapshot.assistantResponse.response.content}}",
              ),
              @bunnia.attr("aria-live", "polite"),
            ],
            [
              @bunnia.text(
                "{{onboardingSnapshot.assistantResponse.response.content}}",
              ),
              @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
                @bunnia.text(
                  "Receipt-backed reply · cursor {{onboardingSnapshot.assistantResponse.runtimeCursor}}",
                ),
              ]),
            ],
          ),
        ],
      ),
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-supervisor-compose")],
        [
          setup_field_label("Message"),
          setup_bound_input(
            name="supervisorMessage",
            value="{{supervisorMessage.body}}",
            state_path="supervisorMessage.body",
            message="edit-supervisor-message",
          ),
          @bunnia.node(
            kind="button",
            attrs=[
              @bunnia.class_name("moontown-primary-action"),
              @bunnia.attr(
                "disabled",
                "{{!(\{supervisor_runtime_ready_condition()}) || !supervisorMessage.body}}",
              ),
            ],
            events=[@bunnia.tap("send-supervisor-message")],
            children=[@bunnia.text("Send")],
          ),
          @bunnia.node(
            kind="button",
            attrs=[
              @bunnia.class_name("moontown-primary-action"),
              @bunnia.attr(
                "disabled",
                "{{!(\{supervisor_runtime_ready_condition()}) || !supervisorMessage.body}}",
              ),
            ],
            events=[@bunnia.tap("steer-run")],
            children=[@bunnia.text("Steer Current Work")],
          ),
        ],
      ),
      supervisor_worker_policy_card(),
      @bunnia.node(
        kind="button",
        attrs=[
          @bunnia.class_name(
            "moontown-primary-action moontown-assign-worker-action",
          ),
          @bunnia.attr(
            "disabled",
            "{{!(\{supervisor_runtime_ready_condition()}) || !supervisorMessage.body || !(onboardingSnapshot.profile && onboardingSnapshot.profile.bindings && (onboardingSnapshot.profile.bindings.bookIds[0] || onboardingSnapshot.profile.bindings.book_ids[0])) || supervisorRuntime.activeWorkerCount >= supervisorRuntime.maxActiveWorkers}}",
          ),
        ],
        events=[@bunnia.tap("assign-worker")],
        children=[
          @bunnia.view_with_attrs(
            [@bunnia.class_name("moontown-assign-worker-icon")],
            [@bunnia.text("W+")],
          ),
          @bunnia.text("Assign Worker"),
        ],
      ),
      message_command_state(
        "supervisor-message", "Sending to your supervisor…", "Message queued. Waiting for a runtime receipt.",
        "Message not sent. Try again.",
      ),
      message_command_state(
        "steer", "Steering the current supervisor run…", "Supervisor steer queued. Waiting for the runtime receipt.",
        "Supervisor steer was not queued.",
      ),
      message_command_state(
        "delegate", "Assigning one bounded worker…", "Worker assignment queued. Waiting for receipt-backed child identity.",
        "Worker was not assigned. Refresh the supervisor and try again.",
      ),
      message_command_state(
        "supervisor-wake", "Waking the supervisor…", "Supervisor wake queued. Waiting for the runtime receipt.",
        "Supervisor wake was not queued.",
      ),
      message_command_state(
        "supervisor-stop", "Requesting a graceful supervisor stop…", "Supervisor stop queued. Waiting for the runtime receipt.",
        "Supervisor stop was not queued.",
      ),
      message_command_state(
        "supervisor-resume", "Retrying or resuming the supervisor…", "Supervisor resume queued. Waiting for the runtime receipt.",
        "Supervisor resume was not queued.",
      ),
    ],
  )
}

///|
fn supervisor_lifecycle_controls() -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-worker-policy-card")], [
    @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
      @bunnia.text("Supervisor runtime controls"),
    ]),
    @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
      @bunnia.text(
        "These commands target the receipt-backed parent supervisor run. Child stop and retry remain separate on the Task board.",
      ),
    ]),
    @bunnia.view_with_attrs([@bunnia.class_name("moontown-run-actions")], [
      @bunnia.node(
        kind="button",
        attrs=[@bunnia.class_name("moontown-primary-action")],
        events=[@bunnia.tap("wake-supervisor")],
        children=[@bunnia.text("Wake")],
      ),
      @bunnia.node(
        kind="button",
        attrs=[@bunnia.class_name("moontown-danger-action")],
        events=[@bunnia.tap("stop-supervisor")],
        children=[@bunnia.text("Stop Supervisor")],
      ),
      @bunnia.node(
        kind="button",
        attrs=[@bunnia.class_name("moontown-primary-action")],
        events=[@bunnia.tap("resume-supervisor")],
        children=[@bunnia.text("Retry / Resume")],
      ),
    ]),
  ])
}

///|
fn supervisor_runtime_avatar() -> @bunnia.Node {
  let avatar_ref = "onboardingSnapshot.profile && onboardingSnapshot.profile.identity && (onboardingSnapshot.profile.identity.avatarUrl || onboardingSnapshot.profile.identity.avatar_url)"
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-supervisor-avatar")], [
    @bunnia.node(
      kind="image",
      attrs=[
        @bunnia.class_name("moontown-supervisor-avatar-image otter"),
        @bunnia.attr("src", supervisor_avatar_asset_src()),
        @bunnia.attr("wx:if", "{{(\{avatar_ref}) == 'avatar://otter-steward'}}"),
        @bunnia.attr("mode", "aspectFill"),
        @bunnia.attr("alt", "Otter Steward"),
        @bunnia.data("asset-id", "moontown-supervisor-avatar"),
        @bunnia.data("asset-kind", "image"),
        @bunnia.data("asset-source", supervisor_avatar_asset_source()),
        @bunnia.data("asset-remote", "false"),
        @bunnia.data("asset-bytes", supervisor_avatar_asset_bytes().to_string()),
      ],
      children=[],
    ),
    @bunnia.node(
      kind="image",
      attrs=[
        @bunnia.class_name("moontown-supervisor-avatar-image lantern"),
        @bunnia.attr("src", supervisor_avatar_asset_src()),
        @bunnia.attr("wx:if", "{{(\{avatar_ref}) == 'avatar://moon-lantern'}}"),
        @bunnia.attr("mode", "aspectFill"),
        @bunnia.attr("alt", "Moon Lantern"),
      ],
      children=[],
    ),
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("moontown-supervisor-avatar-fallback"),
        @bunnia.attr(
          "wx:if",
          "{{(\{avatar_ref}) != 'avatar://otter-steward' && (\{avatar_ref}) != 'avatar://moon-lantern'}}",
        ),
      ],
      [@bunnia.text("S")],
    ),
  ])
}

///|
fn supervisor_worker_policy_card() -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-worker-policy-card")], [
    @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
      @bunnia.text("Bounded worker policy"),
    ]),
    @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
      @bunnia.text(
        "Reviewable claim · $2 max · 5 min · 12K tokens · 3 artifacts",
      ),
    ]),
    @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
      @bunnia.text("Model gpt-5.6-sol · Web off · 3 active workers max"),
    ]),
    @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
      @bunnia.text(
        "Bound book: {{onboardingSnapshot.profile && onboardingSnapshot.profile.bindings && (onboardingSnapshot.profile.bindings.bookIds[0] || onboardingSnapshot.profile.bindings.book_ids[0])}} · MoonDesk resolves its trusted workspace path.",
      ),
    ]),
  ])
}

///|
fn supervisor_phone_registration_cta() -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("mt-panel moontown-supervisor-registration-cta"),
      @bunnia.attr(
        "wx:if",
        "{{messages.mode == 'work' && (messages.channel == 'all' || messages.channel == 'supervisor') && !(\{supervisor_runtime_ready_condition()})}}",
      ),
    ],
    [
      @bunnia.view_with_attrs([@bunnia.class_name("moontown-kiosk-sign")], [
        @bunnia.text("SUPERVISOR LODGE · NOT OPEN"),
      ]),
      @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
        @bunnia.text("Create and activate your first supervisor"),
      ]),
      @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
        @bunnia.text(
          "Finish the registration kiosk before messaging or controlling work.",
        ),
      ]),
      @bunnia.node(
        kind="button",
        attrs=[
          @bunnia.class_name("moontown-primary-action"),
          town_route_attr("home"),
        ],
        events=[@bunnia.tap("tab-home")],
        children=[@bunnia.text("Open Registration Kiosk")],
      ),
    ],
  )
}

///|
fn supervisor_runtime_ready_condition() -> String {
  "(activationResult.activeRunId || activationResult.activation.activeRunId || onboardingSnapshot.activeRunId || onboardingSnapshot.activation.activeRunId || activationResult.active_run_id || activationResult.activation.active_run_id || onboardingSnapshot.active_run_id || onboardingSnapshot.activation.active_run_id) && (activationResult.runtimeCursor > 0 || activationResult.activation.runtimeCursor > 0 || onboardingSnapshot.runtimeCursor > 0 || onboardingSnapshot.activation.runtimeCursor > 0 || activationResult.runtime_cursor > 0 || activationResult.activation.runtime_cursor > 0 || onboardingSnapshot.runtime_cursor > 0 || onboardingSnapshot.activation.runtime_cursor > 0) && (activationResult.cursor > 0 || onboardingSnapshot.cursor > 0) && (activationResult.profile.revision > 0 || onboardingSnapshot.profile.revision > 0)"
}

///|
fn message_command_state(
  feedback_key : String,
  loading_copy : String,
  ready_copy : String,
  failed_copy : String,
) -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-phone-command-state"),
      @bunnia.attr("aria-live", "polite"),
    ],
    [
      @bunnia.view_with_attrs(
        [
          @bunnia.attr(
            "wx:if",
            "{{ui.feedback == '\{feedback_key}' && requestState.state == 'loading'}}",
          ),
        ],
        [@bunnia.text(loading_copy)],
      ),
      @bunnia.view_with_attrs(
        [
          @bunnia.attr(
            "wx:if",
            "{{ui.feedback == '\{feedback_key}' && requestState.state == 'ready'}}",
          ),
        ],
        [@bunnia.text(ready_copy)],
      ),
      @bunnia.view_with_attrs(
        [
          @bunnia.attr(
            "wx:if",
            "{{ui.feedback == '\{feedback_key}' && requestState.state == 'failed'}}",
          ),
        ],
        [@bunnia.text(failed_copy)],
      ),
    ],
  )
}
