///|
fn realm_supervisor_signal(projection : MiniTownProjection) -> @bunnia.Node {
  let supervisor = projection.supervisor
  @bunnia.node(
    kind="button",
    attrs=[
      @bunnia.class_name(
        "moontown-realm-supervisor-signal bunnia-status-\{supervisor.status}",
      ),
      @bunnia.attr("wx:if", "{{\{supervisor_runtime_ready_condition()}}}"),
      @bunnia.data(
        "supervisor-id", "{{onboardingSnapshot.profile && (onboardingSnapshot.profile.profileId || onboardingSnapshot.profile.profile_id)}}",
      ),
      @bunnia.data("supervisor-status", supervisor.status),
      @bunnia.data(
        "bookkeeper-status",
        projection.supervisor_setup.bookkeeper_status,
      ),
      town_messages_route_attr("supervisor"),
    ],
    events=[@bunnia.tap("tab-messages")],
    children=[
      supervisor_runtime_avatar(),
      @bunnia.view_with_attrs([@bunnia.class_name("moontown-binding-copy")], [
        @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
          @bunnia.text(
            "{{(onboardingSnapshot.profile && onboardingSnapshot.profile.identity && (onboardingSnapshot.profile.identity.displayName || onboardingSnapshot.profile.identity.display_name)) || 'Supervisor'}}",
          ),
        ]),
        @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
          @bunnia.text(
            "{{supervisorRuntime.activeWorkerCount || 0}}/{{supervisorRuntime.maxActiveWorkers || 3}} active child workers · runtime acknowledged",
          ),
        ]),
      ]),
    ],
  )
}
