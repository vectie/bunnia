///|
fn home_supervisor_control_panel(
  _projection : MiniTownProjection,
) -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("mt-panel moontown-supervisor-lodge"),
      @bunnia.attr("wx:if", "{{\{supervisor_runtime_ready_condition()}}}"),
      @bunnia.data(
        "supervisor-id", "{{onboardingSnapshot.profile && (onboardingSnapshot.profile.profileId || onboardingSnapshot.profile.profile_id)}}",
      ),
    ],
    [
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-supervisor-lodge-header")],
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
                @bunnia.text("Supervisor Lodge · controllable"),
              ]),
            ],
          ),
          @bunnia.view_with_attrs(
            [@bunnia.class_name("moontown-agent-live-status")],
            [
              @bunnia.text(
                "{{onboardingSnapshot.readiness.state || 'runtime acknowledged'}}",
              ),
            ],
          ),
        ],
      ),
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-supervisor-metrics")],
        [
          @bunnia.view_with_attrs(
            [@bunnia.class_name("moontown-profile-metric")],
            [
              @bunnia.text(
                "{{supervisorRuntime.activeWorkerCount || 0}}/{{supervisorRuntime.maxActiveWorkers || 3}} active workers",
              ),
            ],
          ),
          @bunnia.view_with_attrs(
            [@bunnia.class_name("moontown-profile-metric")],
            [@bunnia.text("Bookkeeper separate")],
          ),
        ],
      ),
      @bunnia.view_with_attrs([@bunnia.class_name("moontown-kiosk-actions")], [
        @bunnia.node(
          kind="button",
          attrs=[town_messages_route_attr("supervisor")],
          events=[@bunnia.tap("tab-messages")],
          children=[@bunnia.text("Message Supervisor")],
        ),
        @bunnia.node(
          kind="button",
          attrs=[town_messages_route_attr("tasks")],
          events=[@bunnia.tap("notification-channel-tasks")],
          children=[@bunnia.text("Inspect Worker Tasks")],
        ),
      ]),
    ],
  )
}
