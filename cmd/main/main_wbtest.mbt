///|
test "build output dir defaults to ignored build folder" {
  assert_eq(default_command(), "build")
  assert_eq(default_target(), "wechat")
  assert_eq(default_example(), "agent_map")
  assert_eq(
    output_dir_from_args(
      ["node", "main.js"],
      default_target(),
      default_example(),
    ),
    "_build/bunnia/wechat/agent_map",
  )
}

///|
test "build output dir accepts out flag" {
  assert_eq(
    output_dir_from_args(
      ["node", "main.js", "--out", "/tmp/bunnia-demo"],
      default_target(),
      default_example(),
    ),
    "/tmp/bunnia-demo",
  )
}

///|
test "build command and target parse explicitly" {
  let args = ["node", "main.js", "build", "--target", "wechat"]
  assert_eq(command_from_args(args), "build")
  assert_eq(target_from_args(args), "wechat")
  assert_eq(strict_from_args(args), false)
  assert_eq(budget_profile_from_args(args), "default")
  assert_eq(render_budget_profile_from_args(args), "default")
  assert_eq(
    budget_profile_from_args(["node", "main.js", "--budget", "tight"]),
    "tight",
  )
  assert_eq(
    render_budget_profile_from_args(["node", "main.js", "--budget", "tight"]),
    "tight",
  )
  assert_eq(
    render_budget_profile_from_args([
      "node", "main.js", "--budget", "tight", "--render-budget", "tiny",
    ]),
    "tiny",
  )
  assert_eq(strict_from_args(["node", "main.js", "--strict"]), true)
  assert_eq(
    strict_from_args(["node", "main.js", "--fail-on-diagnostics"]),
    true,
  )
}

///|
test "help command is explicit and does not write generated output" {
  assert_eq(command_from_args(["node", "main.js", "help"]), "help")
  assert_eq(command_from_args(["node", "main.js", "--help"]), "help")
  assert_eq(command_from_args(["node", "main.js", "-h"]), "help")
  assert_eq(command_from_args(["node", "main.js", "init", "--help"]), "help")
  assert_eq(command_from_args(["node", "main.js", "build", "-h"]), "help")
  assert_eq(command_writes_project_output("help"), false)
}

///|
test "unknown positional command does not fall through to build" {
  assert_eq(command_from_args(["node", "main.js", "buid"]), "unknown")
  assert_eq(unknown_command_from_args(["node", "main.js", "buid"]), "buid")
  assert_eq(
    command_from_args([
      "/Users/kq/.nvm/versions/node/v22.22.1/bin/node", "/tmp/main.js", "build",
    ]),
    "build",
  )
  assert_eq(
    command_from_args(["node", "main.js", "--budget", "tight"]),
    "build",
  )
  assert_eq(
    command_from_args(["node", "main.js", "--example", "agent_map"]),
    "build",
  )
  assert_eq(
    command_from_args(["node", "main.js", "--strict", "wat"]),
    "unknown",
  )
  assert_eq(
    unknown_command_from_args(["node", "main.js", "--strict", "wat"]),
    "wat",
  )
}

///|
test "build budgets come from shared named profiles" {
  let render = render_budget_from_args(["node", "main.js", "--budget", "tight"])
  let shared_render = @bunnia.render_budget_for_profile("tight")
  assert_eq(render.max_nodes, shared_render.max_nodes)
  assert_eq(render.max_initial_data_bytes, shared_render.max_initial_data_bytes)
  assert_eq(render.max_scene_markers, shared_render.max_scene_markers)
  assert_eq(render.max_scene_assets, shared_render.max_scene_assets)
  let explicit_render = render_budget_from_args([
    "node", "main.js", "--budget", "tight", "--render-budget", "tiny",
  ])
  let shared_tiny_render = @bunnia.render_budget_for_profile("tiny")
  assert_eq(explicit_render.max_nodes, shared_tiny_render.max_nodes)
  assert_eq(explicit_render.max_events, shared_tiny_render.max_events)
  assert_eq(
    explicit_render.max_scene_assets,
    shared_tiny_render.max_scene_assets,
  )
  let wechat = wechat_build_budget_from_args([
    "node", "main.js", "--budget", "tight",
  ])
  let shared_wechat = @bunnia.wechat_build_budget_for_profile("tight")
  assert_eq(wechat.max_files, shared_wechat.max_files)
  assert_eq(wechat.max_total_bytes, shared_wechat.max_total_bytes)
  assert_eq(
    wechat.max_page_update_payload_bytes,
    shared_wechat.max_page_update_payload_bytes,
  )
}

///|
test "watch command shares build flags and supports once mode" {
  let args = [
    "node", "main.js", "watch", "--target", "wechat", "--example", "wenyu_overview",
    "--out", "/tmp/bunnia-watch", "--once",
  ]
  assert_eq(command_from_args(args), "watch")
  assert_eq(target_from_args(args), "wechat")
  assert_eq(example_from_args(args), "wenyu_overview")
  assert_eq(
    output_dir_from_args(args, target_from_args(args), example_from_args(args)),
    "/tmp/bunnia-watch",
  )
  assert_eq(watch_once_from_args(args), true)
  assert_eq(watch_once_from_args(["node", "main.js", "watch"]), false)
}

///|
test "snapshot command accepts snapshot path without generated output requirement" {
  let args = [
    "node", "main.js", "snapshot", "--target", "wechat", "--example", "agent_map",
    "--snapshot-out", "/tmp/bunnia-agent-map.snapshot.txt", "--budget", "tight",
  ]
  assert_eq(command_from_args(args), "snapshot")
  assert_eq(target_from_args(args), "wechat")
  assert_eq(example_from_args(args), "agent_map")
  assert_eq(budget_profile_from_args(args), "tight")
  assert_eq(
    output_dir_from_args(args, target_from_args(args), example_from_args(args)),
    "_build/bunnia/wechat/agent_map",
  )
  assert_eq(
    snapshot_output_path_from_args(
      args,
      target_from_args(args),
      example_from_args(args),
    ),
    "/tmp/bunnia-agent-map.snapshot.txt",
  )
}

///|
test "only build-like commands write generated project output" {
  assert_eq(command_writes_project_output("build"), true)
  assert_eq(command_writes_project_output("watch"), true)
  assert_eq(command_writes_project_output("snapshot"), false)
  assert_eq(command_writes_project_output("inspect"), false)
  assert_eq(command_writes_project_output("ci-plan"), false)
  assert_eq(command_writes_project_output("init"), false)
  assert_eq(command_writes_project_output("limits"), false)
  assert_eq(command_writes_project_output("help"), false)
}

///|
test "inspect command exposes generated artifact metrics without output path" {
  let args = [
    "node", "main.js", "inspect", "--target", "wechat", "--example", "agent_map",
    "--budget", "tight", "--render-budget", "tight",
  ]
  let project = project_for_build(
    target_from_args(args),
    example_from_args(args),
    render_budget_from_args(args),
  )
  let patches = patches_for_build(
    target_from_args(args),
    example_from_args(args),
  )
  let report = @bunnia.report_wechat_project_with_budget(
    project,
    @bunnia.default_wechat_runtime(),
    wechat_build_budget_from_args(args),
  )
  let profile = profile_for_build(
    target_from_args(args),
    example_from_args(args),
    project,
    patches,
    report,
  )
  let snapshot = snapshot_for_build(
    target=target_from_args(args),
    example=example_from_args(args),
    project,
    report,
    profile,
    budget_profile=budget_profile_from_args(args),
    render_budget_profile=render_budget_profile_from_args(args),
  )
  assert_eq(command_from_args(args), "inspect")
  assert_eq(snapshot.target, "wechat")
  assert_eq(snapshot.example, "agent_map")
  assert_eq(snapshot.route, project.route)
  assert_eq(snapshot.file_count, project.files.length())
  assert_eq(snapshot.total_bytes, project.total_bytes)
  assert_eq(snapshot.max_first_screen_bytes, report.max_page_first_screen_bytes)
  assert_eq(
    snapshot.max_update_payload_bytes,
    report.max_page_update_payload_bytes,
  )
  assert_eq(snapshot.route_diagnostic_route_count, 0)
  assert_eq(snapshot.route_diagnostic_count, 0)
  assert_eq(snapshot.diagnostic_count, 0)
  assert_true(snapshot.summary.contains("budget=tight"))
  assert_true(
    snapshot.content.contains("pages/index/index.data.js kind=page-data"),
  )
  assert_true(snapshot.content.contains("route_diagnostics:"))
  assert_true(snapshot.content.contains("backend_events=3"))
  assert_true(snapshot.content.contains("backend_cancels=1"))
  assert_true(snapshot.content.contains("backend_retries=1"))
  let inspection = @bunnia.inspect_wechat_project(
    target="wechat",
    example="agent_map",
    project,
    report,
  )
  assert_eq(inspection.top_route, "pages/index/index")
  assert_eq(inspection.route_count, 1)
  assert_eq(inspection.total_diagnostics, 0)
  assert_eq(inspection.max_backend_event_count, 3)
  assert_eq(inspection.max_backend_stream_count, 0)
  assert_eq(inspection.max_backend_review_count, 0)
  assert_eq(inspection.max_backend_cancel_count, 1)
  assert_eq(inspection.max_backend_retry_count, 1)
  assert_eq(inspection.max_scene_asset_count, 1)
  assert_eq(inspection.max_scene_remote_asset_count, 0)
  assert_eq(inspection.max_scene_package_bytes, 2048)
  assert_true(inspection.summary.contains("risk_score="))
  assert_true(inspection.summary.contains("max_backend_events=3"))
  assert_true(inspection.summary.contains("max_backend_cancels=1"))
  assert_true(inspection.summary.contains("max_backend_retries=1"))
  assert_true(inspection.summary.contains("max_scene_assets=1"))
  assert_true(inspection.summary.contains("max_scene_remote_assets=0"))
  assert_true(inspection.summary.contains("max_scene_package_bytes=2048"))
  assert_eq(inspection.routes[0].backend_event_count, 3)
  assert_eq(inspection.routes[0].backend_cancel_count, 1)
  assert_eq(inspection.routes[0].backend_retry_count, 1)
  assert_eq(project.manifest.pages[0].scene_marker_count, 2)
  assert_eq(project.manifest.pages[0].scene_visible_marker_count, 2)
  assert_eq(project.manifest.pages[0].scene_assets.length(), 1)
  assert_eq(project.manifest.pages[0].scene_assets[0].id, "zone-pin")
  assert_eq(project.manifest.pages[0].scene_assets[0].estimated_bytes, 2048)
  assert_eq(project.manifest.pages[0].scene_package_bytes, 2048)
  assert_eq(project.manifest.scene_asset_count, 1)
  assert_eq(project.manifest.scene_package_bytes, 2048)
  assert_true(project.manifest.summary.contains("scene_assets=1"))
  assert_true(project.manifest.summary.contains("scene_package_bytes=2048"))
}

///|
test "limits command exposes platform mappings and generic targets" {
  let args = ["node", "main.js", "limits", "--target", "wechat"]
  let support = target_support_from_args(args)
  assert_eq(support.target, "wechat")
  assert_eq(support.generator_status_id, "available")
  assert_eq(support.generator_available, true)
  let report = platform_limits_from_args(args)
  assert_eq(command_from_args(args), "limits")
  assert_eq(report.target, "wechat")
  assert_eq(report.generator_status_id, "available")
  assert_eq(report.generator_available, true)
  assert_eq(report.supports_canvas, true)
  assert_eq(report.component_mappings.length(), 9)
  assert_eq(report.event_mappings[0].platform_event, "bindtap")
  assert_eq(report.lifecycle_mappings.length(), 3)
  assert_eq(report.request_mappings[0].platform_api, "wx.request")
  assert_eq(report.diagnostics.length(), 0)
  let generic = platform_limits_from_args([
    "node", "main.js", "limits", "--target", "tiktok",
  ])
  assert_eq(generic.target, "tiktok")
  assert_eq(generic.generator_status_id, "available")
  assert_eq(generic.generator_available, true)
  assert_eq(generic.request_mappings[0].platform_api, "tt.request")
  assert_eq(generic.diagnostics.length(), 0)
  let generic_support = target_support_from_args([
    "node", "main.js", "build", "--target", "tiktok",
  ])
  assert_eq(generic_support.target, "tiktok")
  assert_eq(generic_support.generator_status_id, "available")
  assert_eq(generic_support.generator_available, true)
  assert_eq(generic_support.diagnostics.length(), 0)
}

///|
test "generic miniapp build selects non wechat project files" {
  let support = target_support_from_args([
    "node", "main.js", "build", "--target", "alipay", "--example", "agent_map",
  ])
  let project = generic_miniapp_project_for_build(
    support,
    "agent_map",
    render_budget_from_args(["node", "main.js", "--budget", "tight"]),
  )
  assert_eq(project.platform, @bunnia.alipay())
  assert_eq(project.route, "pages/index/index")
  assert_eq(project.files.length(), 7)
  assert_eq(project.manifest.page_count, 1)
  assert_eq(project.manifest.file_count, 6)
  assert_eq(project.manifest.diagnostic_count, 0)
  let inspection = @bunnia.inspect_miniapp_project(
    target="alipay",
    example="agent_map",
    project,
  )
  let gate = @bunnia.gate_miniapp_inspection(
    inspection,
    @bunnia.miniapp_inspection_budget_for_profile("tight"),
    budget_profile="tight",
  )
  let release = @bunnia.miniapp_release_readiness_report(
    target="alipay",
    example="agent_map",
    budget_profile="tight",
    project,
    inspection,
    gate,
  )
  assert_eq(inspection.status, "ok")
  assert_eq(inspection.file_count, 7)
  assert_eq(inspection.max_event_count, 12)
  assert_eq(gate.diagnostics.length(), 0)
  assert_eq(release.status, "ready")
  assert_eq(release.diagnostics.length(), 0)
  assert_true(has_miniapp_file(project.files, "pages/index/index.axml"))
  assert_true(has_miniapp_file(project.files, "pages/index/index.acss"))
  assert_true(has_miniapp_file(project.files, "bunnia.manifest.json"))
  assert_true(project.page.markup.contains("onTap=\"__bunniaEvent\""))
  assert_true(project.summary.contains("Bunnia alipay project"))
  assert_true(project.manifest.summary.contains("platform=alipay"))
  assert_true(inspection.summary.contains("target=alipay"))
  assert_true(gate.summary.contains("diagnostics=0"))
}

///|
test "generic miniapp inspect accepts non wechat targets without project write" {
  let support = target_support_from_args([
    "node", "main.js", "inspect", "--target", "tiktok", "--example", "agent_map",
  ])
  let project = generic_miniapp_project_for_build(
    support,
    "agent_map",
    render_budget_from_args(["node", "main.js", "--budget", "tight"]),
  )
  let inspection = @bunnia.inspect_miniapp_project(
    target="tiktok",
    example="agent_map",
    project,
  )
  let gate = @bunnia.gate_miniapp_inspection(
    inspection,
    @bunnia.miniapp_inspection_budget_for_profile("tight"),
    budget_profile="tight",
  )
  let release = @bunnia.miniapp_release_readiness_report(
    target="tiktok",
    example="agent_map",
    budget_profile="tight",
    project,
    inspection,
    gate,
  )
  assert_eq(
    command_from_args(["node", "main.js", "inspect", "--target", "tiktok"]),
    "inspect",
  )
  assert_eq(support.target, "tiktok")
  assert_eq(support.generator_available, true)
  assert_eq(inspection.target, "tiktok")
  assert_eq(inspection.file_count, 7)
  assert_eq(inspection.diagnostic_count, 0)
  assert_eq(gate.diagnostics.length(), 0)
  assert_eq(release.status, "ready")
  assert_true(inspection.summary.contains("status=ok"))
  assert_true(gate.summary.contains("budget=tight"))
  assert_true(release.summary.contains("target=tiktok"))
}

///|
test "generic miniapp snapshot accepts non wechat targets without project write" {
  let args = [
    "node", "main.js", "snapshot", "--target", "alipay", "--example", "agent_map",
    "--budget", "tight", "--render-budget", "tight",
  ]
  let support = target_support_from_args(args)
  let project = generic_miniapp_project_for_build(
    support,
    "agent_map",
    render_budget_from_args(args),
  )
  let inspection = @bunnia.inspect_miniapp_project(
    target="alipay",
    example="agent_map",
    project,
  )
  let gate = @bunnia.gate_miniapp_inspection(
    inspection,
    @bunnia.miniapp_inspection_budget_for_profile("tight"),
    budget_profile="tight",
  )
  let release = @bunnia.miniapp_release_readiness_report(
    target="alipay",
    example="agent_map",
    budget_profile="tight",
    project,
    inspection,
    gate,
  )
  let snapshot = @bunnia.snapshot_miniapp_project(
    target="alipay",
    example="agent_map",
    project,
    inspection,
    gate,
    release,
    budget_profile="tight",
    render_budget_profile="tight",
  )
  assert_eq(
    command_from_args(["node", "main.js", "snapshot", "--target", "alipay"]),
    "snapshot",
  )
  assert_eq(support.target, "alipay")
  assert_eq(support.generator_available, true)
  assert_eq(snapshot.target, "alipay")
  assert_eq(snapshot.file_count, project.files.length())
  assert_eq(snapshot.route_diagnostic_count, 0)
  assert_eq(snapshot.inspection_gate_diagnostic_count, 0)
  assert_eq(snapshot.diagnostic_count, 0)
  assert_true(snapshot.summary.contains("release_status=ready"))
  assert_true(snapshot.content.contains("pages/index/index.axml kind=axml"))
  assert_true(snapshot.content.contains("release_diagnostics:"))
}

///|
test "generic miniapp watch once can reuse build output path" {
  let args = [
    "node", "main.js", "watch", "--target", "tiktok", "--example", "agent_map", "--budget",
    "tight", "--render-budget", "tight", "--once",
  ]
  let support = target_support_from_args(args)
  let project = generic_miniapp_project_for_build(
    support,
    "agent_map",
    render_budget_from_args(args),
  )
  let inspection = @bunnia.inspect_miniapp_project(
    target="tiktok",
    example="agent_map",
    project,
  )
  let gate = @bunnia.gate_miniapp_inspection(
    inspection,
    @bunnia.miniapp_inspection_budget_for_profile("tight"),
    budget_profile="tight",
  )
  let release = @bunnia.miniapp_release_readiness_report(
    target="tiktok",
    example="agent_map",
    budget_profile="tight",
    project,
    inspection,
    gate,
  )
  assert_eq(command_from_args(args), "watch")
  assert_eq(watch_once_from_args(args), true)
  assert_eq(support.target, "tiktok")
  assert_eq(support.generator_available, true)
  assert_eq(project.platform, @bunnia.tiktok())
  assert_eq(project.files.length(), 7)
  assert_eq(gate.diagnostics.length(), 0)
  assert_eq(release.status, "ready")
  assert_true(has_miniapp_file(project.files, "pages/index/index.ttml"))
}

///|
test "ci plan command prints active example workflow" {
  let args = ["node", "main.js", "ci-plan"]
  let plan = ci_plan_from_args(args)
  assert_eq(command_from_args(args), "ci-plan")
  assert_eq(ci_script_from_args(args), false)
  assert_eq(plan.target, "wechat")
  assert_eq(plan.budget_profile, "tight")
  assert_eq(plan.render_budget_profile, "tight")
  assert_eq(plan.diagnostics.length(), 0)
  assert_eq(plan.examples.length(), 2)
  assert_eq(plan.examples[0], "agent_map")
  assert_eq(plan.examples[1], "wenyu_overview")
  assert_eq(plan.step_count, 17)
  assert_eq(
    plan.steps[7].command,
    "moon run cmd/main -- limits --target wechat",
  )
  assert_eq(plan.steps[6].command, "sh scripts/validate_boundaries.sh")
  assert_true(plan.steps[8].command.contains("inspect --target wechat"))
  assert_true(plan.steps[12].command.contains("--example wenyu_overview"))
  assert_true(plan.steps[14].command.contains("watch --target wechat"))
  assert_true(plan.steps[14].command.contains("--once"))
  assert_eq(plan.steps[16].command, "sh scripts/scaffold_smoke.sh")
  assert_true(plan.summary.contains("snapshot_dir=_build/bunnia/snapshots"))
  assert_true(
    plan.summary.contains("profile_max_communication_unresolved_reviews=8"),
  )
  assert_true(plan.summary.contains("profile_max_route_diagnostic_routes=0"))
  assert_true(plan.summary.contains("profile_max_route_diagnostics=0"))
  assert_true(plan.summary.contains("profile_max_unwindowed_list_children=16"))
  assert_true(plan.summary.contains("profile_max_unkeyed_list_children=0"))
  assert_true(plan.summary.contains("profile_max_duplicate_list_keys=0"))
  assert_true(plan.summary.contains("profile_max_tool_result_missing_acks=0"))
  assert_true(
    plan.summary.contains("profile_max_scene_unapproved_remote_assets=0"),
  )
  assert_true(plan.summary.contains("profile_max_scene_deferred_assets=0"))
  assert_true(plan.summary.contains("inspection_max_update_payload=1024"))
  assert_true(plan.summary.contains("inspection_max_update_ops=16"))
  assert_true(
    plan.summary.contains("inspection_max_unwindowed_list_children=16"),
  )
  assert_true(plan.summary.contains("inspection_max_unkeyed_list_children=0"))
  assert_true(plan.summary.contains("inspection_max_duplicate_list_keys=0"))
}

///|
test "ci plan command accepts target budget example and snapshot dir" {
  let args = [
    "node", "main.js", "ci-plan", "--target", "wechat", "--budget", "tight", "--render-budget",
    "tiny", "--example", "agent_map", "--snapshot-dir", "/tmp/bunnia-ci",
  ]
  let plan = ci_plan_from_args(args)
  assert_eq(command_from_args(args), "ci-plan")
  assert_eq(plan.target, "wechat")
  assert_eq(plan.budget_profile, "tight")
  assert_eq(plan.render_budget_profile, "tiny")
  assert_eq(plan.diagnostics.length(), 0)
  assert_eq(plan.examples.length(), 1)
  assert_eq(plan.snapshot_dir, "/tmp/bunnia-ci")
  assert_eq(plan.step_count, 13)
  assert_eq(plan.steps[6].command, "sh scripts/validate_boundaries.sh")
  assert_true(plan.steps[8].command.contains("--budget tight"))
  assert_true(plan.steps[8].command.contains("--render-budget tiny"))
  assert_true(plan.steps[8].command.contains("inspect --target wechat"))
  assert_true(plan.steps[9].command.contains("build --target wechat"))
  assert_true(plan.steps[10].command.contains("watch --target wechat"))
  assert_true(plan.steps[10].command.contains("--once"))
  assert_true(
    plan.steps[11].command.contains(
      "/tmp/bunnia-ci/wechat/agent_map.snapshot.txt",
    ),
  )
  assert_true(plan.steps[11].command.contains("--render-budget tiny"))
  assert_eq(plan.steps[12].command, "sh scripts/scaffold_smoke.sh")
}

///|
test "ci plan command gives generic targets full workflow" {
  let args = [
    "node", "main.js", "ci-plan", "--target", "alipay", "--budget", "tight", "--render-budget",
    "tight", "--example", "agent_map", "--snapshot-dir", "/tmp/bunnia-ci",
  ]
  let plan = ci_plan_from_args(args)
  assert_eq(command_from_args(args), "ci-plan")
  assert_eq(plan.target, "alipay")
  assert_eq(plan.target_generator_available, true)
  assert_eq(plan.diagnostics.length(), 0)
  assert_eq(plan.step_count, 13)
  assert_true(plan.steps[8].command.contains("inspect --target alipay"))
  assert_true(plan.steps[9].command.contains("build --target alipay"))
  assert_true(plan.steps[10].command.contains("watch --target alipay"))
  assert_true(plan.steps[10].command.contains("--once"))
  assert_true(
    plan.steps[11].command.contains(
      "/tmp/bunnia-ci/alipay/agent_map.snapshot.txt",
    ),
  )
  assert_eq(plan.steps[12].command, "sh scripts/scaffold_smoke.sh")
}

///|
test "ci plan command can emit shell script" {
  let args = [
    "node", "main.js", "ci-plan", "--script", "--example", "agent_map",
  ]
  let plan = ci_plan_from_args(args)
  let script = @bunnia.ci_plan_shell_script(plan)
  assert_eq(command_from_args(args), "ci-plan")
  assert_eq(ci_script_from_args(args), true)
  assert_eq(plan.examples.length(), 1)
  assert_true(script.has_prefix("#!/usr/bin/env sh"))
  assert_true(script.contains("moon check"))
  assert_true(script.contains("moon run cmd/main -- build --target wechat"))
  assert_true(script.contains("--example agent_map"))
}

///|
test "ci plan can target Moontown miniapp with large-app budgets" {
  let args = [
    "node", "main.js", "ci-plan", "--example", "moontown_miniapp", "--budget", "large",
  ]
  let plan = ci_plan_from_args(args)
  assert_eq(plan.examples.length(), 1)
  assert_eq(plan.examples[0], "moontown_miniapp")
  assert_eq(plan.budget_profile, "large")
  assert_eq(plan.render_budget_profile, "large")
  assert_eq(plan.step_count, 13)
  assert_true(plan.steps[8].command.contains("--example moontown_miniapp"))
  assert_true(plan.steps[8].command.contains("--budget large"))
  assert_true(plan.steps[11].command.contains("moontown_miniapp.snapshot.txt"))
}

///|
test "ci plan command reports unknown budget profiles" {
  let args = [
    "node", "main.js", "ci-plan", "--target", "alipay", "--budget", "oversized",
    "--render-budget", "microscopic", "--example", "agent_map",
  ]
  let plan = ci_plan_from_args(args)
  assert_eq(plan.target, "alipay")
  assert_eq(plan.budget_profile, "oversized")
  assert_eq(plan.render_budget_profile, "microscopic")
  assert_eq(plan.target_generator_status_id, "available")
  assert_eq(plan.target_generator_available, true)
  assert_true(plan.diagnostics.contains("ci-budget-profile-unknown:oversized"))
  assert_true(
    plan.diagnostics.contains("ci-render-budget-profile-unknown:microscopic"),
  )
}

///|
test "init command builds a scaffold plan" {
  let args = [
    "node", "main.js", "init", "--name", "agent_demo", "--module", "local/agent_demo",
  ]
  let name = scaffold_name_from_args(args)
  let scaffold = scaffold_from_args(args, name)
  assert_eq(command_from_args(args), "init")
  assert_eq(name, "agent_demo")
  assert_eq(scaffold.module_name, "local/agent_demo")
  assert_eq(scaffold.files.length(), 17)
  assert_eq(scaffold_write_file_count(scaffold), 18)
  assert_eq(
    scaffold_output_dir_from_args(args, name),
    "_build/bunnia/scaffold/agent_demo",
  )
  assert_true(scaffold.summary.contains("files=17"))
}

///|
test "init command accepts output override and module default" {
  let args = ["node", "main.js", "init", "--out", "/tmp/bunnia-init"]
  let name = scaffold_name_from_args(args)
  let scaffold = scaffold_from_args(args, name)
  assert_eq(name, default_scaffold_name())
  assert_eq(scaffold.module_name, "local/bunnia_starter")
  assert_eq(scaffold_output_dir_from_args(args, name), "/tmp/bunnia-init")
}

///|
test "init command writes a local workspace link" {
  assert_eq(
    scaffold_workspace_content("/Users/kq/Workspace/moonmini"),
    "members = [\n  \".\",\n  \"/Users/kq/Workspace/moonmini\",\n]\n",
  )
}

///|
test "init command marks starter scripts executable" {
  assert_eq(scaffold_file_is_executable("scripts/ci.sh"), true)
  assert_eq(scaffold_file_is_executable("README.md"), false)
  assert_eq(scaffold_file_is_executable("cmd/main/main.mbt"), false)
}

///|
test "build example flag selects Wenyu proof output folder" {
  let example = example_from_args([
    "node", "main.js", "--example", "wenyu_overview",
  ])
  assert_eq(example, "wenyu_overview")
  assert_eq(
    output_dir_from_args(["node", "main.js"], default_target(), example),
    "_build/bunnia/wechat/wenyu_overview",
  )
}

///|
test "build example flag selects Moontown miniapp output folder" {
  let example = example_from_args([
    "node", "main.js", "--example", "moontown_miniapp",
  ])
  assert_eq(example, "moontown_miniapp")
  assert_eq(
    output_dir_from_args(["node", "main.js"], default_target(), example),
    "_build/bunnia/wechat/moontown_miniapp",
  )
}

///|
test "build example flag selects Wenyu project" {
  let project = project_for_build(
    "wechat",
    "wenyu_overview",
    render_budget_from_args(["node", "main.js", "--budget", "tight"]),
  )
  let patches = patches_for_build("wechat", "wenyu_overview")
  let report = @bunnia.report_wechat_project_with_budget(
    project,
    @bunnia.default_wechat_runtime(),
    wechat_build_budget_from_args(["node", "main.js", "--budget", "tight"]),
  )
  let profile = profile_for_build(
    "wechat", "wenyu_overview", project, patches, report,
  )
  assert_eq(project.route, "pages/wenyu/index")
  assert_eq(patches.patches.length(), 2)
  assert_eq(report.diagnostics.length(), 0)
  assert_eq(profile.backend_endpoint_count, 4)
  assert_eq(profile.backend_streaming_count, 0)
  assert_eq(profile.backend_review_required_count, 2)
  assert_eq(profile.communication_count, 2)
  assert_eq(profile.communication_visible_count, 2)
  assert_eq(profile.communication_unresolved_review_count, 1)
  assert_eq(profile.communication_artifact_ref_count, 1)
  assert_eq(profile.tool_result_count, 0)
  assert_eq(profile.tool_result_visible_count, 0)
  assert_eq(profile.tool_result_pending_ack_count, 0)
  assert_eq(profile.tool_result_missing_ack_count, 0)
  assert_eq(profile.tool_result_artifact_ref_count, 0)
  assert_eq(profile.agent_delta_count, 0)
  assert_eq(profile.agent_duplicate_stream_chunk_count, 0)
  assert_eq(profile.snapshot_delta_count, 3)
  assert_eq(profile.snapshot_section_update_count, 2)
  assert_eq(profile.snapshot_append_item_count, 1)
  assert_eq(profile.snapshot_full_replace_count, 0)
  assert_eq(profile.scene_marker_count, 4)
  assert_eq(profile.scene_asset_count, 1)
  assert_eq(profile.scene_deferred_asset_count, 0)
  assert_eq(profile.scene_thread_link_count, 1)
  assert_eq(profile.scene_thread_visible_link_count, 1)
  assert_eq(profile.scene_thread_unread_total, 1)
  assert_eq(profile.scene_thread_orphan_link_count, 0)
  assert_eq(profile.scene_camera_count, 0)
  assert_eq(profile.scene_camera_clamped_count, 0)
  assert_eq(profile.scene_static_surface_count, 1)
  assert_eq(profile.scene_surface_fallback_count, 0)
  assert_true(profile.summary.contains("agent_deltas=0"))
  assert_true(profile.summary.contains("communications=2/2"))
  assert_true(profile.summary.contains("tool_results=0/0"))
  assert_true(profile.summary.contains("backend_streams=0"))
  assert_true(profile.summary.contains("backend_reviews=2"))
  assert_true(profile.summary.contains("communication_unresolved_reviews=1"))
  assert_true(profile.summary.contains("snapshot_deltas=3"))
  assert_true(profile.summary.contains("snapshot_sections=2"))
  assert_true(profile.summary.contains("snapshot_appends=1"))
  assert_true(profile.summary.contains("scene_package_bytes=4096"))
  assert_true(profile.summary.contains("scene_deferred_assets=0"))
  assert_true(profile.summary.contains("scene_threads=1/1"))
  assert_true(profile.summary.contains("scene_thread_unread=1"))
  assert_true(profile.summary.contains("scene_cameras=0"))
  assert_true(profile.summary.contains("scene_camera_clamped=0"))
  assert_true(profile.summary.contains("scene_surfaces=static:1"))
  let gate = inspection_gate_for_test(
    "wechat", "wenyu_overview", project, report,
  )
  let profile_gate = profile_gate_for_test(profile)
  let release = release_for_test(
    "wechat", "wenyu_overview", project, report, profile, profile_gate, gate,
  )
  assert_eq(
    should_fail_build(
      false, project, report, patches, profile, profile_gate, gate, release,
    ),
    false,
  )
  assert_eq(
    should_fail_build(
      true, project, report, patches, profile, profile_gate, gate, release,
    ),
    false,
  )
}

///|
test "build example flag selects Moontown miniapp project" {
  let project = project_for_build(
    "wechat",
    "moontown_miniapp",
    render_budget_from_args(["node", "main.js", "--budget", "large"]),
  )
  let patches = patches_for_build("wechat", "moontown_miniapp")
  let report = @bunnia.report_wechat_project_with_budget(
    project,
    @bunnia.default_wechat_runtime(),
    wechat_build_budget_from_args(["node", "main.js", "--budget", "large"]),
  )
  let profile = profile_for_build(
    "wechat", "moontown_miniapp", project, patches, report,
  )
  let inspection = @bunnia.inspect_wechat_project(
    target="wechat",
    example="moontown_miniapp",
    project,
    report,
  )
  assert_eq(project.route, "pages/moontown/index")
  assert_eq(patches.patches.length(), 3)
  assert_eq(report.diagnostics.length(), 0)
  assert_eq(profile.effect_count, 10)
  assert_eq(profile.backend_endpoint_count, 10)
  assert_eq(profile.backend_streaming_count, 0)
  assert_eq(profile.backend_review_required_count, 6)
  assert_eq(profile.communication_count, 3)
  assert_eq(profile.communication_visible_count, 3)
  assert_eq(profile.communication_unresolved_review_count, 1)
  assert_eq(profile.agent_delta_count, 2)
  assert_eq(profile.snapshot_delta_count, 3)
  assert_eq(profile.snapshot_section_update_count, 1)
  assert_eq(profile.snapshot_append_item_count, 2)
  assert_eq(profile.snapshot_full_replace_count, 0)
  assert_true(profile.scene_marker_count >= 8)
  assert_eq(profile.scene_region_count, 2)
  assert_eq(profile.scene_asset_count, 1)
  assert_true(profile.scene_thread_link_count >= 8)
  assert_true(profile.scene_thread_visible_link_count >= 5)
  assert_eq(profile.scene_thread_orphan_link_count, 0)
  assert_eq(profile.scene_camera_count, 1)
  assert_eq(profile.scene_camera_clamped_count, 0)
  assert_eq(profile.scene_static_surface_count, 1)
  assert_eq(profile.scene_surface_fallback_count, 0)
  assert_eq(profile.scene_quality_issue_count, 0)
  assert_eq(profile.degraded_scene_count, 0)
  assert_eq(inspection.top_route, "pages/moontown/index")
  assert_eq(inspection.max_backend_event_count >= 3, true)
  assert_true(inspection.max_scene_marker_count >= 5)
  assert_true(project.page.wxml.contains("moontown-map-fullscreen"))
  assert_true(project.page.js.contains("__bunniaEventPatches"))
  assert_true(profile.summary.contains("backend_endpoints=10"))
  assert_true(profile.summary.contains("agent_deltas=2"))
  assert_true(profile.summary.contains("snapshot_deltas=3"))
  let gate = inspection_gate_for_test(
    "wechat", "moontown_miniapp", project, report,
  )
  let profile_gate = @bunnia.gate_build_profile(
    profile,
    @bunnia.build_profile_budget_for_profile("large"),
    budget_profile="large",
  )
  let release = release_for_test_with_budget(
    "wechat", "moontown_miniapp", project, report, profile, profile_gate, gate, "large",
  )
  assert_eq(
    should_fail_build(
      true, project, report, patches, profile, profile_gate, gate, release,
    ),
    false,
  )
}

///|
test "build profile keeps agent map diagnostics visible" {
  let project = project_for_build(
    "wechat",
    "agent_map",
    render_budget_from_args(["node", "main.js"]),
  )
  let patches = patches_for_build("wechat", "agent_map")
  let report = @bunnia.report_wechat_project_with_budget(
    project,
    @bunnia.default_wechat_runtime(),
    wechat_build_budget_from_args(["node", "main.js"]),
  )
  let profile = profile_for_build(
    "wechat", "agent_map", project, patches, report,
  )
  let tiny_report = @bunnia.report_wechat_project_with_budget(
    project,
    @bunnia.default_wechat_runtime(),
    wechat_build_budget_from_args(["node", "main.js", "--budget", "tiny"]),
  )
  let bad_patches = @bunnia.plan_patches_with_budget(
    patches.patches,
    @bunnia.patch_budget(max_patches=0, max_patch_bytes=1),
  )
  let gate = inspection_gate_for_test("wechat", "agent_map", project, report)
  let profile_gate = profile_gate_for_test(profile)
  let tiny_gate = inspection_gate_for_test_with_profile(
    "wechat", "agent_map", project, report, "tiny",
  )
  let release = release_for_test(
    "wechat", "agent_map", project, report, profile, profile_gate, gate,
  )
  let tiny_release = release_for_test(
    "wechat", "agent_map", project, report, profile, profile_gate, tiny_gate,
  )
  assert_eq(profile.route, "pages/index/index")
  assert_eq(profile.scene_marker_count, 2)
  assert_eq(profile.scene_deferred_asset_count, 0)
  assert_eq(profile.scene_thread_link_count, 2)
  assert_eq(profile.scene_thread_visible_link_count, 2)
  assert_eq(profile.scene_thread_unread_total, 2)
  assert_eq(profile.scene_thread_orphan_link_count, 0)
  assert_eq(profile.scene_camera_count, 1)
  assert_eq(profile.scene_camera_clamped_count, 0)
  assert_eq(profile.scene_static_surface_count, 1)
  assert_eq(profile.scene_surface_fallback_count, 0)
  assert_eq(profile.effect_count, 6)
  assert_eq(profile.stream_effect_count, 1)
  assert_eq(profile.backend_endpoint_count, 6)
  assert_eq(profile.backend_streaming_count, 1)
  assert_eq(profile.backend_review_required_count, 1)
  assert_eq(profile.backend_cancel_count, 1)
  assert_eq(profile.backend_retry_count, 1)
  assert_eq(profile.communication_count, 3)
  assert_eq(profile.communication_visible_count, 3)
  assert_eq(profile.communication_unresolved_review_count, 1)
  assert_eq(profile.communication_artifact_ref_count, 2)
  assert_eq(profile.tool_result_count, 1)
  assert_eq(profile.tool_result_visible_count, 1)
  assert_eq(profile.tool_result_pending_ack_count, 1)
  assert_eq(profile.tool_result_missing_ack_count, 0)
  assert_eq(profile.tool_result_artifact_ref_count, 1)
  assert_eq(profile.agent_delta_count, 4)
  assert_eq(profile.agent_duplicate_stream_chunk_count, 0)
  assert_eq(profile.snapshot_delta_count, 2)
  assert_eq(profile.snapshot_section_update_count, 1)
  assert_eq(profile.snapshot_append_item_count, 1)
  assert_eq(profile.snapshot_full_replace_count, 0)
  assert_eq(profile.diagnostics.length(), 0)
  assert_true(profile.summary.contains("effects=6"))
  assert_true(profile.summary.contains("streams=1"))
  assert_true(profile.summary.contains("backend_endpoints=6"))
  assert_true(profile.summary.contains("backend_streams=1"))
  assert_true(profile.summary.contains("backend_reviews=1"))
  assert_true(profile.summary.contains("backend_cancels=1"))
  assert_true(profile.summary.contains("backend_retries=1"))
  assert_true(profile.summary.contains("agent_deltas=4"))
  assert_true(profile.summary.contains("communications=3/3"))
  assert_true(profile.summary.contains("tool_results=1/1"))
  assert_true(profile.summary.contains("tool_result_pending_acks=1"))
  assert_true(profile.summary.contains("snapshot_deltas=2"))
  assert_true(profile.summary.contains("scene_threads=2/2"))
  assert_true(profile.summary.contains("scene_thread_unread=2"))
  assert_true(profile.summary.contains("scene_cameras=1"))
  assert_true(profile.summary.contains("scene_camera_clamped=0"))
  assert_true(profile.summary.contains("agent_duplicate_stream_chunks=0"))
  assert_eq(tiny_report.diagnostics.length() > 0, true)
  assert_true(
    tiny_report.diagnostics.contains("wechat-file-count-over-budget:11/1"),
  )
  assert_eq(
    should_fail_build(
      false, project, report, bad_patches, profile, profile_gate, gate, release,
    ),
    false,
  )
  assert_eq(
    should_fail_build(
      true, project, report, bad_patches, profile, profile_gate, gate, release,
    ),
    true,
  )
  assert_eq(
    should_fail_build(
      true, project, tiny_report, patches, profile, profile_gate, gate, release,
    ),
    true,
  )
  assert_eq(
    should_fail_build(
      true, project, report, patches, profile, profile_gate, tiny_gate, tiny_release,
    ),
    true,
  )
}

///|
test "build render budget can fail map-heavy routes before preview" {
  let project = project_for_build(
    "wechat",
    "agent_map",
    render_budget_from_args(["node", "main.js", "--render-budget", "tiny"]),
  )
  let patches = patches_for_build("wechat", "agent_map")
  let report = @bunnia.report_wechat_project_with_budget(
    project,
    @bunnia.default_wechat_runtime(),
    wechat_build_budget_from_args(["node", "main.js"]),
  )
  let profile = profile_for_build(
    "wechat", "agent_map", project, patches, report,
  )
  assert_true(
    project.page.plan.diagnostics.contains("node-count-over-budget:54/8"),
  )
  assert_true(
    report.diagnostics.contains(
      "wechat-render:pages/index/index:scene-marker-count-over-budget:2/1",
    ),
  )
  assert_true(
    report.diagnostics.contains(
      "wechat-render:pages/index/index:scene-region-count-over-budget:2/1",
    ),
  )
  assert_true(
    profile.diagnostics.contains(
      "render:pages/index/index:scene-marker-count-over-budget:2/1",
    ),
  )
  assert_true(
    profile.diagnostics.contains(
      "render:pages/index/index:scene-region-count-over-budget:2/1",
    ),
  )
  let gate = inspection_gate_for_test("wechat", "agent_map", project, report)
  let profile_gate = profile_gate_for_test(profile)
  let release = release_for_test(
    "wechat", "agent_map", project, report, profile, profile_gate, gate,
  )
  assert_eq(
    should_fail_build(
      false, project, report, patches, profile, profile_gate, gate, release,
    ),
    false,
  )
  assert_eq(
    should_fail_build(
      true, project, report, patches, profile, profile_gate, gate, release,
    ),
    true,
  )
}

///|
fn inspection_gate_for_test(
  target : String,
  example : String,
  project : @bunnia.WechatProject,
  report : @bunnia.WechatBuildReport,
) -> @bunnia.ProjectInspectionGate {
  inspection_gate_for_test_with_profile(
    target, example, project, report, "default",
  )
}

///|
fn release_for_test(
  target : String,
  example : String,
  project : @bunnia.WechatProject,
  report : @bunnia.WechatBuildReport,
  profile : @bunnia.BuildProfile,
  profile_gate : @bunnia.BuildProfileGate,
  inspection_gate : @bunnia.ProjectInspectionGate,
) -> @bunnia.ReleaseReadinessReport {
  release_for_test_with_budget(
    target, example, project, report, profile, profile_gate, inspection_gate, "tight",
  )
}

///|
fn release_for_test_with_budget(
  target : String,
  example : String,
  project : @bunnia.WechatProject,
  report : @bunnia.WechatBuildReport,
  profile : @bunnia.BuildProfile,
  profile_gate : @bunnia.BuildProfileGate,
  inspection_gate : @bunnia.ProjectInspectionGate,
  budget_profile : String,
) -> @bunnia.ReleaseReadinessReport {
  @bunnia.release_readiness_report(
    target~,
    example~,
    budget_profile~,
    project,
    profile,
    profile_gate,
    @bunnia.inspect_wechat_project(target~, example~, project, report),
    inspection_gate,
  )
}

///|
fn inspection_gate_for_test_with_profile(
  target : String,
  example : String,
  project : @bunnia.WechatProject,
  report : @bunnia.WechatBuildReport,
  budget_profile : String,
) -> @bunnia.ProjectInspectionGate {
  @bunnia.gate_project_inspection(
    @bunnia.inspect_wechat_project(target~, example~, project, report),
    @bunnia.inspection_budget_for_profile(budget_profile),
    budget_profile~,
  )
}

///|
fn profile_gate_for_test(
  profile : @bunnia.BuildProfile,
) -> @bunnia.BuildProfileGate {
  @bunnia.gate_build_profile(
    profile,
    @bunnia.build_profile_budget_for_profile("default"),
    budget_profile="default",
  )
}

///|
fn has_miniapp_file(files : Array[@bunnia.MiniappFile], path : String) -> Bool {
  for item in files {
    if item.path == path {
      return true
    }
  }
  false
}

///|
test "join path keeps generated routes stable" {
  assert_eq(
    join_path("_build/demo", "pages/index/index.wxml"),
    "_build/demo/pages/index/index.wxml",
  )
  assert_eq(join_path("_build/demo/", "app.json"), "_build/demo/app.json")
}
