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

///|
test "generic miniapp release readiness passes clean project" {
  let project = @miniapp.generate_project_with_budget(
    name="Generic Release",
    route="pages/generic/index",
    root=@core.page([@core.button("Open", "open")]),
    platform=@core.Alipay,
    render_budget=@core.render_budget(
      max_nodes=16,
      max_depth=8,
      max_events=4,
      max_initial_data_bytes=1024,
      max_scene_markers=4,
      max_scene_regions=4,
      max_scene_assets=4,
    ),
  )
  let inspection = inspect_miniapp_project(
    target="alipay",
    example="generic_release",
    project,
  )
  let inspection_gate = gate_miniapp_inspection(
    inspection,
    miniapp_inspection_budget_for_profile("tight"),
    budget_profile="tight",
  )
  let release = miniapp_release_readiness_report(
    target="alipay",
    example="generic_release",
    budget_profile="tight",
    project,
    inspection,
    inspection_gate,
  )
  assert_eq(release.status, "ready")
  assert_eq(release.diagnostic_count, 0)
  assert_eq(release.passed_count, release.checklist_count)
  assert_true(release.summary.contains("generic miniapp release readiness"))
  assert_true(release.summary.contains("checks=7/7"))
}

///|
test "generic miniapp release readiness blocks target and budget diagnostics" {
  let project = @miniapp.generate_project_with_budget(
    name="Generic Blocked",
    route="pages/generic-blocked/index",
    root=@core.page([@core.button("Open", "open")]),
    platform=@core.Alipay,
    render_budget=@core.render_budget(
      max_nodes=16,
      max_depth=8,
      max_events=4,
      max_initial_data_bytes=1024,
      max_scene_markers=4,
      max_scene_regions=4,
      max_scene_assets=4,
    ),
  )
  let inspection = inspect_miniapp_project(
    target="tiktok",
    example="generic_blocked",
    project,
  )
  let inspection_gate = gate_miniapp_inspection(
    inspection,
    miniapp_inspection_budget(
      max_pages=1,
      max_files=1,
      max_total_bytes=128,
      max_route_diagnostic_routes=0,
      max_route_diagnostics=0,
      max_nodes=1,
      max_depth=1,
      max_events=0,
      max_scene_markers=0,
      max_scene_regions=0,
      max_scene_assets=0,
    ),
    budget_profile="tiny-custom",
  )
  let release = miniapp_release_readiness_report(
    target="tiktok",
    example="generic_blocked",
    budget_profile="tiny-custom",
    project,
    inspection,
    inspection_gate,
  )
  assert_eq(release.status, "blocked")
  assert_true(
    release.diagnostics.contains(
      "release-miniapp-target-mismatch:alipay/tiktok",
    ),
  )
  assert_true(
    release.diagnostics.contains(
      "release-miniapp-inspection-gate-diagnostics:\{inspection_gate.diagnostics.length()}",
    ),
  )
}
