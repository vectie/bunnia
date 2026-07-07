///|
test "release readiness passes clean backend-aware project" {
  let contract = @effects.backend_contract(id="release-backend", endpoints=[
    @effects.agent_message_endpoint(
      "send-message", "/agent/message", "draft", "message",
    ),
  ])
  let project = @wechat.generate_project_with_runtime_and_backend(
    name="Release Ready",
    route="pages/release/index",
    root=@core.page([@core.button("Send", "send-message")]),
    runtime=@wechat.runtime(
      initial_data_json="{\"backendBaseUrl\":\"\",\"draft\":{\"text\":\"hello\"}}",
      event_patches=[
        @wechat.event_patch("send-message", [
          @core.set_string("backend.send-message.state", "loading"),
        ]),
      ],
    ),
    backend_contract=contract,
  )
  let profile = profile_wechat_project(project, @core.plan_patches([]), backend_plans=[
    @effects.plan_backend_contract(contract),
  ])
  let inspection = inspect_wechat_project(
    target="wechat",
    example="release_ready",
    project,
    project.report,
  )
  let profile_gate = gate_build_profile(
    profile,
    build_profile_budget_for_profile("tight"),
    budget_profile="tight",
  )
  let inspection_gate = gate_project_inspection(
    inspection,
    inspection_budget_for_profile("tight"),
    budget_profile="tight",
  )
  let release = release_readiness_report(
    target="wechat",
    example="release_ready",
    budget_profile="tight",
    project,
    profile,
    profile_gate,
    inspection,
    inspection_gate,
  )
  assert_eq(release.status, "ready")
  assert_eq(release.diagnostic_count, 0)
  assert_eq(release.passed_count, release.checklist_count)
  assert_true(release.summary.contains("status=ready"))
  assert_true(release.summary.contains("checks=8/8"))
}

///|
test "release readiness blocks frontend secret markers" {
  let project = @wechat.generate_project_with_runtime(
    name="Release Secret",
    route="pages/release-secret/index",
    root=@core.page([@core.text("Secret")]),
    runtime=@wechat.runtime(initial_data_json="{\"appSecret\":\"bad\"}"),
  )
  let profile = profile_wechat_project(project, @core.plan_patches([]))
  let inspection = inspect_wechat_project(
    target="wechat",
    example="release_secret",
    project,
    project.report,
  )
  let profile_gate = gate_build_profile(
    profile,
    build_profile_budget_for_profile("tight"),
    budget_profile="tight",
  )
  let inspection_gate = gate_project_inspection(
    inspection,
    inspection_budget_for_profile("tight"),
    budget_profile="tight",
  )
  let release = release_readiness_report(
    target="wechat",
    example="release_secret",
    budget_profile="tight",
    project,
    profile,
    profile_gate,
    inspection,
    inspection_gate,
  )
  assert_eq(release.status, "blocked")
  assert_true(
    release.diagnostics.contains("release-frontend-secret-marker-found"),
  )
  assert_true(release.summary.contains("diagnostics=1"))
}
