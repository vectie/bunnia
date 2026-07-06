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
test "snapshot command accepts generated output and snapshot paths" {
  let args = [
    "node", "main.js", "snapshot", "--target", "wechat", "--example", "agent_map",
    "--out", "/tmp/bunnia-generated", "--snapshot-out", "/tmp/bunnia-agent-map.snapshot.txt",
    "--budget", "tight",
  ]
  assert_eq(command_from_args(args), "snapshot")
  assert_eq(target_from_args(args), "wechat")
  assert_eq(example_from_args(args), "agent_map")
  assert_eq(budget_profile_from_args(args), "tight")
  assert_eq(
    output_dir_from_args(args, target_from_args(args), example_from_args(args)),
    "/tmp/bunnia-generated",
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
  let profile = profile_for_build(
    target_from_args(args),
    example_from_args(args),
    project,
    patches,
  )
  let report = @bunnia.report_wechat_project_with_budget(
    project,
    @bunnia.default_wechat_runtime(),
    wechat_build_budget_from_args(args),
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
  let inspection = @bunnia.inspect_wechat_project(
    target="wechat",
    example="agent_map",
    project,
    report,
  )
  assert_eq(inspection.top_route, "pages/index/index")
  assert_eq(inspection.route_count, 1)
  assert_eq(inspection.total_diagnostics, 0)
  assert_true(inspection.summary.contains("risk_score="))
  assert_eq(project.manifest.pages[0].scene_marker_count, 2)
  assert_eq(project.manifest.pages[0].scene_visible_marker_count, 2)
  assert_eq(project.manifest.pages[0].scene_assets.length(), 1)
  assert_eq(project.manifest.pages[0].scene_assets[0].id, "zone-pin")
  assert_eq(project.manifest.scene_asset_count, 1)
  assert_true(project.manifest.summary.contains("scene_assets=1"))
}

///|
test "limits command exposes platform mappings and deferred targets" {
  let args = ["node", "main.js", "limits", "--target", "wechat"]
  let report = platform_limits_from_args(args)
  assert_eq(command_from_args(args), "limits")
  assert_eq(report.target, "wechat")
  assert_eq(report.generator_available, true)
  assert_eq(report.supports_canvas, true)
  assert_eq(report.component_mappings.length(), 9)
  assert_eq(report.event_mappings[0].platform_event, "bindtap")
  assert_eq(report.diagnostics.length(), 0)
  let deferred = platform_limits_from_args([
    "node", "main.js", "limits", "--target", "tiktok",
  ])
  assert_eq(deferred.target, "tiktok")
  assert_eq(deferred.generator_available, false)
  assert_true(
    deferred.diagnostics.contains("platform-generator-deferred:tiktok"),
  )
}

///|
test "ci plan command prints active example workflow" {
  let args = ["node", "main.js", "ci-plan"]
  let plan = ci_plan_from_args(args)
  assert_eq(command_from_args(args), "ci-plan")
  assert_eq(plan.target, "wechat")
  assert_eq(plan.budget_profile, "tight")
  assert_eq(plan.render_budget_profile, "tight")
  assert_eq(plan.diagnostics.length(), 0)
  assert_eq(plan.examples.length(), 2)
  assert_eq(plan.examples[0], "agent_map")
  assert_eq(plan.examples[1], "wenyu_overview")
  assert_eq(plan.step_count, 13)
  assert_eq(
    plan.steps[6].command,
    "moon run cmd/main -- limits --target wechat",
  )
  assert_true(plan.steps[7].command.contains("inspect --target wechat"))
  assert_true(plan.summary.contains("snapshot_dir=_build/bunnia/snapshots"))
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
  assert_eq(plan.step_count, 10)
  assert_true(plan.steps[7].command.contains("--budget tight"))
  assert_true(plan.steps[7].command.contains("--render-budget tiny"))
  assert_true(plan.steps[7].command.contains("inspect --target wechat"))
  assert_true(plan.steps[8].command.contains("build --target wechat"))
  assert_true(
    plan.steps[9].command.contains(
      "/tmp/bunnia-ci/wechat/agent_map.snapshot.txt",
    ),
  )
  assert_true(plan.steps[9].command.contains("--render-budget tiny"))
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
  assert_true(plan.diagnostics.contains("ci-target-unsupported:alipay"))
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
  assert_eq(scaffold.files.length(), 4)
  assert_eq(scaffold_write_file_count(scaffold), 5)
  assert_eq(
    scaffold_output_dir_from_args(args, name),
    "_build/bunnia/scaffold/agent_demo",
  )
  assert_true(scaffold.summary.contains("files=4"))
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
    "members = [\n  \"/Users/kq/Workspace/moonmini\",\n]\n",
  )
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
test "build example flag selects Wenyu project" {
  let project = project_for_build(
    "wechat",
    "wenyu_overview",
    render_budget_from_args(["node", "main.js", "--budget", "tight"]),
  )
  let patches = patches_for_build("wechat", "wenyu_overview")
  let profile = profile_for_build("wechat", "wenyu_overview", project, patches)
  let report = @bunnia.report_wechat_project_with_budget(
    project,
    @bunnia.default_wechat_runtime(),
    wechat_build_budget_from_args(["node", "main.js", "--budget", "tight"]),
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
  assert_eq(should_fail_build(false, project, report, patches, profile), false)
  assert_eq(should_fail_build(true, project, report, patches, profile), false)
}

///|
test "build profile keeps agent map diagnostics visible" {
  let project = project_for_build(
    "wechat",
    "agent_map",
    render_budget_from_args(["node", "main.js"]),
  )
  let patches = patches_for_build("wechat", "agent_map")
  let profile = profile_for_build("wechat", "agent_map", project, patches)
  let report = @bunnia.report_wechat_project_with_budget(
    project,
    @bunnia.default_wechat_runtime(),
    wechat_build_budget_from_args(["node", "main.js"]),
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
  assert_eq(profile.effect_count, 4)
  assert_eq(profile.stream_effect_count, 1)
  assert_eq(profile.backend_endpoint_count, 4)
  assert_eq(profile.backend_streaming_count, 1)
  assert_eq(profile.backend_review_required_count, 1)
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
  assert_true(profile.summary.contains("effects=4"))
  assert_true(profile.summary.contains("streams=1"))
  assert_true(profile.summary.contains("backend_endpoints=4"))
  assert_true(profile.summary.contains("backend_streams=1"))
  assert_true(profile.summary.contains("backend_reviews=1"))
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
    should_fail_build(false, project, report, bad_patches, profile),
    false,
  )
  assert_eq(
    should_fail_build(true, project, report, bad_patches, profile),
    true,
  )
  assert_eq(
    should_fail_build(true, project, tiny_report, patches, profile),
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
  let profile = profile_for_build("wechat", "agent_map", project, patches)
  let report = @bunnia.report_wechat_project_with_budget(
    project,
    @bunnia.default_wechat_runtime(),
    wechat_build_budget_from_args(["node", "main.js"]),
  )
  assert_true(
    project.page.plan.diagnostics.contains("node-count-over-budget:39/8"),
  )
  assert_true(
    report.diagnostics.contains(
      "wechat-render:pages/index/index:scene-marker-count-over-budget:2/1",
    ),
  )
  assert_true(
    profile.diagnostics.contains(
      "render:pages/index/index:scene-marker-count-over-budget:2/1",
    ),
  )
  assert_eq(should_fail_build(false, project, report, patches, profile), false)
  assert_eq(should_fail_build(true, project, report, patches, profile), true)
}

///|
test "join path keeps generated routes stable" {
  assert_eq(
    join_path("_build/demo", "pages/index/index.wxml"),
    "_build/demo/pages/index/index.wxml",
  )
  assert_eq(join_path("_build/demo/", "app.json"), "_build/demo/app.json")
}
