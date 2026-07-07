///|
/// Entry point for local framework probes.
/// Run with `moon run cmd/main` from the project root.
fn main {
  let command = command_from_args(@env.args())
  if command == "help" {
    print_help()
  } else if command == "unknown" {
    println("unsupported command=\{unknown_command_from_args(@env.args())}")
    print_help()
    panic()
  } else if command == "init" {
    let name = scaffold_name_from_args(@env.args())
    let output_dir = scaffold_output_dir_from_args(@env.args(), name)
    let scaffold = scaffold_from_args(@env.args(), name)
    write_scaffold(output_dir, scaffold)
    println("command=init")
    println(scaffold.summary)
    println("wrote=\{scaffold_write_file_count(scaffold)} output=\{output_dir}")
  } else if command == "ci-plan" {
    let plan = ci_plan_from_args(@env.args())
    if ci_script_from_args(@env.args()) {
      println(@bunnia.ci_plan_shell_script(plan))
    } else {
      print_ci_plan(plan)
    }
  } else if command == "limits" {
    print_platform_limits(platform_limits_from_args(@env.args()))
  } else {
    run_build_or_watch(command, @env.args())
  }
}

///|
fn default_command() -> String {
  "build"
}

///|
fn default_target() -> String {
  "wechat"
}

///|
fn default_example() -> String {
  "agent_map"
}

///|
fn default_output_dir_for_build(target : String, example : String) -> String {
  "_build/bunnia/\{target}/\{example}"
}

///|
fn command_from_args(args : Array[String]) -> String {
  if args.contains("help") || args.contains("--help") || args.contains("-h") {
    return "help"
  }
  for i in 0..<args.length() {
    let item = args[i]
    if command_arg_is_ignored(args, i) {
      continue
    }
    if item == "build" {
      return "build"
    } else if item == "init" {
      return "init"
    } else if item == "watch" {
      return "watch"
    } else if item == "snapshot" {
      return "snapshot"
    } else if item == "inspect" {
      return "inspect"
    } else if item == "limits" {
      return "limits"
    } else if item == "ci-plan" {
      return "ci-plan"
    } else {
      return "unknown"
    }
  }
  default_command()
}

///|
fn unknown_command_from_args(args : Array[String]) -> String {
  for i in 0..<args.length() {
    let item = args[i]
    if command_arg_is_ignored(args, i) {
      continue
    }
    if !command_arg_is_known(item) {
      return item
    }
  }
  ""
}

///|
fn command_arg_is_known(item : String) -> Bool {
  item == "build" ||
  item == "init" ||
  item == "watch" ||
  item == "snapshot" ||
  item == "inspect" ||
  item == "limits" ||
  item == "ci-plan"
}

///|
fn command_arg_is_ignored(args : Array[String], index : Int) -> Bool {
  let item = args[index]
  command_arg_is_runner(item) ||
  item.has_prefix("-") ||
  (index > 0 && command_option_consumes_value(args[index - 1]))
}

///|
fn command_arg_is_runner(item : String) -> Bool {
  item == "node" || item.has_suffix("/node") || item.has_suffix(".js")
}

///|
fn command_option_consumes_value(item : String) -> Bool {
  item == "--target" ||
  item == "--example" ||
  item == "--budget" ||
  item == "--render-budget" ||
  item == "--out" ||
  item == "--snapshot-out" ||
  item == "--snapshot-dir" ||
  item == "--name" ||
  item == "--module"
}

///|
fn command_writes_project_output(command : String) -> Bool {
  command == "build" || command == "watch"
}

///|
fn print_help() -> Unit {
  println("Bunnia CLI")
  println("usage=moon run cmd/main -- <command> [options]")
  println("command=build target=wechat writes=_build/bunnia/wechat/<example>")
  println(
    "command=watch target=wechat writes=_build/bunnia/wechat/<example> options=--once",
  )
  println("command=inspect writes=false")
  println("command=snapshot writes=snapshot-file")
  println("command=ci-plan writes=false options=--script")
  println("command=limits writes=false options=--target wechat|alipay|tiktok")
  println("command=init writes=scaffold options=--name --module --out")
  println("options=--target --example --budget --render-budget --strict --out")
}

///|
fn target_from_args(args : Array[String]) -> String {
  for i in 0..<args.length() {
    if args[i] == "--target" && i + 1 < args.length() {
      return args[i + 1]
    }
  }
  default_target()
}

///|
fn example_from_args(args : Array[String]) -> String {
  for i in 0..<args.length() {
    if args[i] == "--example" && i + 1 < args.length() {
      return args[i + 1]
    }
  }
  default_example()
}

///|
fn strict_from_args(args : Array[String]) -> Bool {
  args.contains("--strict") || args.contains("--fail-on-diagnostics")
}

///|
fn budget_profile_from_args(args : Array[String]) -> String {
  for i in 0..<args.length() {
    if args[i] == "--budget" && i + 1 < args.length() {
      return args[i + 1]
    }
  }
  "default"
}

///|
fn render_budget_profile_from_args(args : Array[String]) -> String {
  for i in 0..<args.length() {
    if args[i] == "--render-budget" && i + 1 < args.length() {
      return args[i + 1]
    }
  }
  budget_profile_from_args(args)
}

///|
fn render_budget_from_args(args : Array[String]) -> @bunnia.RenderBudget {
  let profile = render_budget_profile_from_args(args)
  if !@bunnia.is_named_budget_profile(profile) {
    println("unsupported render_budget=\{profile}")
    panic()
  }
  @bunnia.render_budget_for_profile(profile)
}

///|
fn wechat_build_budget_from_args(
  args : Array[String],
) -> @bunnia.WechatBuildBudget {
  let profile = budget_profile_from_args(args)
  if !@bunnia.is_named_budget_profile(profile) {
    println("unsupported budget=\{profile}")
    panic()
  }
  @bunnia.wechat_build_budget_for_profile(profile)
}

///|
fn watch_once_from_args(args : Array[String]) -> Bool {
  args.contains("--once")
}

///|
fn default_scaffold_name() -> String {
  "bunnia_starter"
}

///|
fn scaffold_name_from_args(args : Array[String]) -> String {
  for i in 0..<args.length() {
    if args[i] == "--name" && i + 1 < args.length() {
      return args[i + 1]
    }
  }
  default_scaffold_name()
}

///|
fn scaffold_module_from_args(args : Array[String], name : String) -> String {
  for i in 0..<args.length() {
    if args[i] == "--module" && i + 1 < args.length() {
      return args[i + 1]
    }
  }
  "local/\{name}"
}

///|
fn scaffold_output_dir_from_args(args : Array[String], name : String) -> String {
  for i in 0..<args.length() {
    if args[i] == "--out" && i + 1 < args.length() {
      return args[i + 1]
    }
  }
  "_build/bunnia/scaffold/\{name}"
}

///|
fn scaffold_from_args(
  args : Array[String],
  name : String,
) -> @bunnia.ScaffoldPlan {
  @bunnia.scaffold_project(
    name~,
    module_name=scaffold_module_from_args(args, name),
  )
}

///|
fn output_dir_from_args(
  args : Array[String],
  target : String,
  example : String,
) -> String {
  for i in 0..<args.length() {
    if args[i] == "--out" && i + 1 < args.length() {
      return args[i + 1]
    }
  }
  default_output_dir_for_build(target, example)
}

///|
fn snapshot_output_path_from_args(
  args : Array[String],
  target : String,
  example : String,
) -> String {
  for i in 0..<args.length() {
    if args[i] == "--snapshot-out" && i + 1 < args.length() {
      return args[i + 1]
    }
  }
  "_build/bunnia/snapshots/\{target}/\{example}.snapshot.txt"
}

///|
fn ci_snapshot_dir_from_args(args : Array[String]) -> String {
  for i in 0..<args.length() {
    if args[i] == "--snapshot-dir" && i + 1 < args.length() {
      return args[i + 1]
    }
  }
  "_build/bunnia/snapshots"
}

///|
fn ci_examples_from_args(args : Array[String]) -> Array[String] {
  for i in 0..<args.length() {
    if args[i] == "--example" && i + 1 < args.length() {
      return [args[i + 1]]
    }
  }
  [default_example(), "wenyu_overview"]
}

///|
fn ci_budget_profile_from_args(args : Array[String]) -> String {
  for i in 0..<args.length() {
    if args[i] == "--budget" && i + 1 < args.length() {
      return args[i + 1]
    }
  }
  "tight"
}

///|
fn ci_render_budget_profile_from_args(args : Array[String]) -> String {
  for i in 0..<args.length() {
    if args[i] == "--render-budget" && i + 1 < args.length() {
      return args[i + 1]
    }
  }
  ci_budget_profile_from_args(args)
}

///|
fn ci_script_from_args(args : Array[String]) -> Bool {
  args.contains("--script")
}

///|
fn ci_plan_from_args(args : Array[String]) -> @bunnia.CiPlan {
  @bunnia.ci_plan(
    target=target_from_args(args),
    budget_profile=ci_budget_profile_from_args(args),
    render_budget_profile=ci_render_budget_profile_from_args(args),
    examples=ci_examples_from_args(args),
    snapshot_dir=ci_snapshot_dir_from_args(args),
  )
}

///|
fn platform_limits_from_args(
  args : Array[String],
) -> @bunnia.PlatformLimitsReport {
  @bunnia.platform_limits(target=target_from_args(args))
}

///|
fn target_support_from_args(
  args : Array[String],
) -> @bunnia.PlatformTargetSupport {
  @bunnia.platform_target_support(target=target_from_args(args))
}

///|
fn ensure_target_generator_available(
  support : @bunnia.PlatformTargetSupport,
) -> Unit {
  if !support.generator_available {
    println(support.summary)
    print_diagnostics(support.diagnostics)
    panic()
  }
}

///|
fn project_for_build(
  target : String,
  example : String,
  render_budget : @bunnia.RenderBudget,
) -> @bunnia.WechatProject {
  ensure_target_generator_available(@bunnia.platform_target_support(target~))
  project_for_example(example, render_budget)
}

///|
fn project_for_example(
  example : String,
  render_budget : @bunnia.RenderBudget,
) -> @bunnia.WechatProject {
  if example == "wenyu_overview" {
    @wenyu.demo_wechat_project_with_render_budget(render_budget)
  } else if example == "moontown_miniapp" {
    @moontown.demo_wechat_project_with_render_budget(render_budget)
  } else if example == "agent_map" {
    @demo.demo_wechat_project_with_render_budget(render_budget)
  } else {
    println("unsupported example=\{example}")
    panic()
  }
}

///|
fn patches_for_build(target : String, example : String) -> @bunnia.PatchPlan {
  ensure_target_generator_available(@bunnia.platform_target_support(target~))
  patches_for_example(example)
}

///|
fn patches_for_example(example : String) -> @bunnia.PatchPlan {
  if example == "wenyu_overview" {
    @wenyu.demo_patch_plan()
  } else if example == "moontown_miniapp" {
    @moontown.demo_patch_plan()
  } else if example == "agent_map" {
    @demo.demo_patch_plan()
  } else {
    println("unsupported example=\{example}")
    panic()
  }
}

///|
fn profile_for_build(
  target : String,
  example : String,
  project : @bunnia.WechatProject,
  patches : @bunnia.PatchPlan,
  report : @bunnia.WechatBuildReport,
) -> @bunnia.BuildProfile {
  ensure_target_generator_available(@bunnia.platform_target_support(target~))
  profile_for_example(
    example,
    @bunnia.wechat_project_with_report(project, report),
    patches,
  )
}

///|
fn profile_for_example(
  example : String,
  project : @bunnia.WechatProject,
  patches : @bunnia.PatchPlan,
) -> @bunnia.BuildProfile {
  if example == "wenyu_overview" {
    @bunnia.profile_wechat_project(
      project,
      patches,
      effect_plans=[@wenyu.demo_effect_plan()],
      communication_plans=[@wenyu.demo_communication_plan()],
      backend_plans=[
        @bunnia.plan_backend_contract(@wenyu.demo_backend_contract()),
      ],
      snapshot_plans=[@wenyu.demo_snapshot_delta_plan()],
      asset_plans=[@wenyu.demo_asset_plan()],
      thread_plans=[@wenyu.demo_scene_thread_plan()],
      scene_plans=[@wenyu.demo_scene_render_plan()],
      surface_plans=[@wenyu.demo_scene_surface_plan()],
      quality_plans=[@wenyu.demo_scene_visual_quality_plan()],
    )
  } else if example == "moontown_miniapp" {
    @bunnia.profile_wechat_project(
      project,
      patches,
      effect_plans=[@moontown.demo_effect_plan()],
      communication_plans=[@moontown.demo_communication_plan()],
      agent_delta_plans=[@moontown.demo_agent_delta_plan()],
      backend_plans=[
        @bunnia.plan_backend_contract(@moontown.demo_backend_contract()),
      ],
      snapshot_plans=[@moontown.demo_snapshot_delta_plan()],
      asset_plans=[@moontown.demo_asset_plan()],
      thread_plans=[@moontown.demo_scene_thread_plan()],
      camera_plans=[
        @bunnia.plan_scene_camera(
          @moontown.demo_scene(),
          @moontown.demo_camera(),
        ),
      ],
      scene_plans=[@moontown.demo_scene_render_plan()],
      surface_plans=[@moontown.demo_scene_surface_plan()],
      quality_plans=[@moontown.demo_scene_visual_quality_plan()],
    )
  } else if example == "agent_map" {
    @bunnia.profile_wechat_project(
      project,
      patches,
      effect_plans=[@demo.demo_effect_plan()],
      communication_plans=[@demo.demo_communication_plan()],
      tool_result_plans=[@demo.demo_tool_result_plan()],
      agent_delta_plans=[@demo.demo_agent_delta_plan()],
      backend_plans=[
        @bunnia.plan_backend_contract(@demo.demo_backend_contract()),
      ],
      snapshot_plans=[@demo.demo_snapshot_delta_plan()],
      asset_plans=[@demo.demo_asset_plan()],
      thread_plans=[@demo.demo_scene_thread_plan()],
      camera_plans=[@demo.demo_scene_camera_plan()],
      scene_plans=[@demo.demo_scene_render_plan()],
      surface_plans=[@demo.demo_scene_surface_plan()],
      quality_plans=[@demo.demo_scene_visual_quality_plan()],
    )
  } else {
    println("unsupported example=\{example}")
    panic()
  }
}

///|
fn run_build_or_watch(command : String, args : Array[String]) -> Unit {
  let target = target_from_args(args)
  let target_support = target_support_from_args(args)
  ensure_target_generator_available(target_support)
  if target != "wechat" {
    run_generic_miniapp_build(command, args, target_support)
    return
  }
  let example = example_from_args(args)
  let output_dir = output_dir_from_args(args, target, example)
  let render_budget = render_budget_from_args(args)
  let render_budget_profile = render_budget_profile_from_args(args)
  let project = project_for_build(target, example, render_budget)
  let patches = patches_for_build(target, example)
  let budget_profile = budget_profile_from_args(args)
  let report = @bunnia.report_wechat_project_with_budget(
    project,
    @bunnia.default_wechat_runtime(),
    wechat_build_budget_from_args(args),
  )
  let profile = profile_for_build(target, example, project, patches, report)
  let inspection = @bunnia.inspect_wechat_project(
    target~,
    example~,
    project,
    report,
  )
  let inspection_gate = @bunnia.gate_project_inspection(
    inspection,
    @bunnia.inspection_budget_for_profile(budget_profile),
    budget_profile~,
  )
  let profile_gate = @bunnia.gate_build_profile(
    profile,
    @bunnia.build_profile_budget_for_profile(budget_profile),
    budget_profile~,
  )
  let release = @bunnia.release_readiness_report(
    target~,
    example~,
    budget_profile~,
    project,
    profile,
    profile_gate,
    inspection,
    inspection_gate,
  )
  let strict = strict_from_args(args)
  if command == "inspect" {
    let snapshot = snapshot_for_build(
      target~,
      example~,
      project,
      report,
      profile,
      budget_profile~,
      render_budget_profile~,
    )
    print_inspect_result(
      target, example, budget_profile, render_budget_profile, project, report, patches,
      profile, profile_gate, snapshot, inspection, inspection_gate, release,
    )
  } else if command == "snapshot" {
    let snapshot = snapshot_for_build(
      target~,
      example~,
      project,
      report,
      profile,
      budget_profile~,
      render_budget_profile~,
    )
    print_snapshot_result(
      target, example, budget_profile, render_budget_profile, project, report, patches,
      profile, profile_gate, inspection_gate, release,
    )
    let snapshot_path = snapshot_output_path_from_args(args, target, example)
    write_text_file(snapshot_path, snapshot.content)
    println(snapshot.summary)
    println("snapshot=\{snapshot_path}")
  } else if command_writes_project_output(command) {
    write_project(output_dir, project)
    print_build_result(
      command, target, example, budget_profile, render_budget_profile, output_dir,
      project, report, patches, profile, profile_gate, inspection_gate, release,
    )
  } else {
    println("unsupported command=\{command}")
    panic()
  }
  if should_fail_build(
      strict, project, report, patches, profile, profile_gate, inspection_gate, release,
    ) {
    println("build_failed=diagnostics")
    panic()
  }
  if command == "watch" {
    if watch_once_from_args(args) {
      println("watch=once")
    } else {
      watch_generated_output(target, example, output_dir, strict)
    }
  }
}

///|
fn run_generic_miniapp_build(
  command : String,
  args : Array[String],
  target_support : @bunnia.PlatformTargetSupport,
) -> Unit {
  let target = target_from_args(args)
  let example = example_from_args(args)
  let output_dir = output_dir_from_args(args, target, example)
  let render_budget = render_budget_from_args(args)
  let render_budget_profile = render_budget_profile_from_args(args)
  let budget_profile = budget_profile_from_args(args)
  let strict = strict_from_args(args)
  if command != "build" {
    println(
      "unsupported command=\{command} target=\{target} reason=generic-miniapp-build-only",
    )
    panic()
  }
  let project = generic_miniapp_project_for_build(
    target_support, example, render_budget,
  )
  write_miniapp_project(output_dir, project)
  print_generic_miniapp_build_result(
    command, target, example, budget_profile, render_budget_profile, output_dir,
    project,
  )
  if strict && project.page.plan.diagnostics.length() > 0 {
    println("build_failed=diagnostics")
    panic()
  }
}

///|
fn generic_miniapp_project_for_build(
  target_support : @bunnia.PlatformTargetSupport,
  example : String,
  render_budget : @bunnia.RenderBudget,
) -> @bunnia.MiniappProject {
  if example == "wenyu_overview" {
    @bunnia.generate_miniapp_project_with_budget(
      name="Wenyu Overview",
      route="pages/wenyu/index",
      root=@wenyu.demo_view(),
      platform=target_support.adapter.platform,
      render_budget~,
    )
  } else if example == "moontown_miniapp" {
    @bunnia.generate_miniapp_project_with_budget(
      name="Moontown Miniapp",
      route="pages/moontown/index",
      root=@moontown.demo_view(),
      platform=target_support.adapter.platform,
      render_budget~,
    )
  } else if example == "agent_map" {
    @bunnia.generate_miniapp_project_with_budget(
      name="Agent Map",
      root=@demo.demo_view(),
      platform=target_support.adapter.platform,
      render_budget~,
    )
  } else {
    println("unsupported example=\{example}")
    panic()
  }
}

///|
fn snapshot_for_build(
  target~ : String,
  example~ : String,
  project : @bunnia.WechatProject,
  report : @bunnia.WechatBuildReport,
  profile : @bunnia.BuildProfile,
  budget_profile~ : String,
  render_budget_profile~ : String,
) -> @bunnia.GeneratedSnapshot {
  @bunnia.snapshot_wechat_project_with_report(
    target~,
    example~,
    project,
    report,
    profile,
    budget_profile~,
    render_budget_profile~,
  )
}

///|
fn print_snapshot_result(
  target : String,
  example : String,
  budget_profile : String,
  render_budget_profile : String,
  project : @bunnia.WechatProject,
  report : @bunnia.WechatBuildReport,
  patches : @bunnia.PatchPlan,
  profile : @bunnia.BuildProfile,
  profile_gate : @bunnia.BuildProfileGate,
  inspection_gate : @bunnia.ProjectInspectionGate,
  release : @bunnia.ReleaseReadinessReport,
) -> Unit {
  println("command=snapshot")
  println("target=\{target}")
  println("example=\{example}")
  println("budget=\{budget_profile}")
  println("render_budget=\{render_budget_profile}")
  println(project.page.plan.summary)
  println(project.summary)
  println(project.manifest.summary)
  println(report.summary)
  print_diagnostics(report.diagnostics)
  println(patches.summary)
  println(profile.summary)
  print_profile_diagnostics(profile.diagnostics)
  println(profile_gate.summary)
  print_profile_gate_diagnostics(profile_gate.diagnostics)
  println(inspection_gate.summary)
  print_inspection_gate_diagnostics(inspection_gate.diagnostics)
  println(release.summary)
  print_release_diagnostics(release.diagnostics)
}

///|
fn print_build_result(
  command : String,
  target : String,
  example : String,
  budget_profile : String,
  render_budget_profile : String,
  output_dir : String,
  project : @bunnia.WechatProject,
  report : @bunnia.WechatBuildReport,
  patches : @bunnia.PatchPlan,
  profile : @bunnia.BuildProfile,
  profile_gate : @bunnia.BuildProfileGate,
  inspection_gate : @bunnia.ProjectInspectionGate,
  release : @bunnia.ReleaseReadinessReport,
) -> Unit {
  println("command=\{command}")
  println("target=\{target}")
  println("example=\{example}")
  println("budget=\{budget_profile}")
  println("render_budget=\{render_budget_profile}")
  println(project.page.plan.summary)
  println(project.summary)
  println(project.manifest.summary)
  println(report.summary)
  print_diagnostics(report.diagnostics)
  println(patches.summary)
  println(profile.summary)
  print_profile_diagnostics(profile.diagnostics)
  println(profile_gate.summary)
  print_profile_gate_diagnostics(profile_gate.diagnostics)
  println(inspection_gate.summary)
  print_inspection_gate_diagnostics(inspection_gate.diagnostics)
  println(release.summary)
  print_release_diagnostics(release.diagnostics)
  println("wrote=\{project.files.length()} output=\{output_dir}")
}

///|
fn print_generic_miniapp_build_result(
  command : String,
  target : String,
  example : String,
  budget_profile : String,
  render_budget_profile : String,
  output_dir : String,
  project : @bunnia.MiniappProject,
) -> Unit {
  println("command=\{command}")
  println("target=\{target}")
  println("example=\{example}")
  println("budget=\{budget_profile}")
  println("render_budget=\{render_budget_profile}")
  println(project.page.plan.summary)
  println(project.summary)
  println(project.manifest.summary)
  print_diagnostics(project.page.plan.diagnostics)
  println(
    "Bunnia generic miniapp build: platform=\{@bunnia.platform_id(project.platform)} files=\{project.files.length()} bytes=\{project.total_bytes} markup=\{project.page.markup_extension} style=\{project.page.style_extension} route_diagnostic_routes=\{project.manifest.diagnostic_route_count} diagnostics=\{project.manifest.diagnostic_count}",
  )
  println("wrote=\{project.files.length()} output=\{output_dir}")
}

///|
fn print_inspect_result(
  target : String,
  example : String,
  budget_profile : String,
  render_budget_profile : String,
  project : @bunnia.WechatProject,
  report : @bunnia.WechatBuildReport,
  patches : @bunnia.PatchPlan,
  profile : @bunnia.BuildProfile,
  profile_gate : @bunnia.BuildProfileGate,
  snapshot : @bunnia.GeneratedSnapshot,
  inspection : @bunnia.ProjectInspection,
  inspection_gate : @bunnia.ProjectInspectionGate,
  release : @bunnia.ReleaseReadinessReport,
) -> Unit {
  println("command=inspect")
  println("target=\{target}")
  println("example=\{example}")
  println("budget=\{budget_profile}")
  println("render_budget=\{render_budget_profile}")
  println(project.page.plan.summary)
  println(project.summary)
  println(project.manifest.summary)
  println(report.summary)
  print_diagnostics(report.diagnostics)
  println(patches.summary)
  println(profile.summary)
  print_profile_diagnostics(profile.diagnostics)
  println(profile_gate.summary)
  print_profile_gate_diagnostics(profile_gate.diagnostics)
  println(inspection_gate.summary)
  print_inspection_gate_diagnostics(inspection_gate.diagnostics)
  println(release.summary)
  print_release_diagnostics(release.diagnostics)
  println(snapshot.summary)
  println(inspection.summary)
  println(
    "inspect=route=\{snapshot.route} pages=\{snapshot.page_count} files=\{snapshot.file_count} bytes=\{snapshot.total_bytes} max_first_screen=\{snapshot.max_first_screen_bytes} max_update_payload=\{snapshot.max_update_payload_bytes} max_update_ops=\{snapshot.max_update_operation_count} route_diagnostic_routes=\{snapshot.route_diagnostic_route_count} route_diagnostics=\{snapshot.route_diagnostic_count} diagnostics=\{snapshot.diagnostic_count}",
  )
  println(
    "risk_route=\{inspection.top_route} risk_score=\{inspection.risk_score} routes=\{inspection.route_count} diagnostics=\{inspection.total_diagnostics} max_unwindowed_list_children=\{inspection.max_unwindowed_list_child_count} max_unkeyed_list_children=\{inspection.max_unkeyed_list_child_count} max_duplicate_list_keys=\{inspection.max_duplicate_list_key_count} max_backend_events=\{inspection.max_backend_event_count} max_backend_streams=\{inspection.max_backend_stream_count} max_backend_reviews=\{inspection.max_backend_review_count} max_backend_cancels=\{inspection.max_backend_cancel_count} max_backend_retries=\{inspection.max_backend_retry_count} max_scene_markers=\{inspection.max_scene_marker_count} max_scene_regions=\{inspection.max_scene_region_count} max_scene_assets=\{inspection.max_scene_asset_count} max_scene_remote_assets=\{inspection.max_scene_remote_asset_count} max_scene_package_bytes=\{inspection.max_scene_package_bytes}",
  )
  for route in inspection.routes {
    println(route.summary)
  }
  for page in project.manifest.pages {
    println(
      "route=\{page.route} status=\{page.status} nodes=\{page.node_count} depth=\{page.depth} components=\{page.component_count} events=\{page.event_count} unwindowed_list_children=\{page.unwindowed_list_child_count} unkeyed_list_children=\{page.unkeyed_list_child_count} duplicate_list_keys=\{page.duplicate_list_key_count} backend_events=\{page.backend_event_count} backend_streams=\{page.backend_stream_count} backend_reviews=\{page.backend_review_count} backend_cancels=\{page.backend_cancel_count} backend_retries=\{page.backend_retry_count} scene_markers=\{page.scene_visible_marker_count}/\{page.scene_marker_count} scene_regions=\{page.scene_visible_region_count}/\{page.scene_region_count} scene_assets=\{page.scene_assets.length()} scene_remote_assets=\{page.scene_remote_asset_count} scene_package_bytes=\{page.scene_package_bytes} first_screen=\{page.first_screen_bytes} update_payload=\{page.update_payload_bytes} update_ops=\{page.update_operation_count} file_bytes=\{page.file_bytes} diagnostics=\{page.diagnostic_count}",
    )
    for asset in page.scene_assets {
      println(
        "scene_asset=\{asset.route}:\{asset.id} kind=\{asset.kind} src=\{asset.src} remote=\{asset.remote} estimated_bytes=\{asset.estimated_bytes}",
      )
    }
    for item in page.diagnostics {
      println("route_diagnostic=\{page.route}:\{item}")
    }
  }
  for file in snapshot.files {
    println(
      "file=\{file.path} kind=\{file.kind} bytes=\{file.bytes} checksum=\{file.checksum}",
    )
  }
}

///|
fn print_inspection_gate_diagnostics(items : Array[String]) -> Unit {
  for item in items {
    println("inspection_diagnostic=\{item}")
  }
}

///|
fn print_profile_gate_diagnostics(items : Array[String]) -> Unit {
  for item in items {
    println("profile_gate_diagnostic=\{item}")
  }
}

///|
fn print_release_diagnostics(items : Array[String]) -> Unit {
  for item in items {
    println("release_diagnostic=\{item}")
  }
}

///|
fn print_ci_plan(plan : @bunnia.CiPlan) -> Unit {
  println("command=ci-plan")
  println("target=\{plan.target}")
  println("budget=\{plan.budget_profile}")
  println("render_budget=\{plan.render_budget_profile}")
  println(plan.summary)
  println(plan.inspection_gate_summary)
  println(plan.profile_gate_summary)
  print_diagnostics(plan.diagnostics)
  for step in plan.steps {
    println("step=\{step.name} command=\{step.command}")
  }
}

///|
fn print_platform_limits(report : @bunnia.PlatformLimitsReport) -> Unit {
  println("command=limits")
  println("target=\{report.target}")
  println(report.summary)
  print_diagnostics(report.diagnostics)
  println("generator_status=\{report.generator_status_id}")
  println(
    "capability=canvas:\{report.supports_canvas} cloud:\{report.supports_cloud} stream:\{report.supports_stream} generator:\{report.generator_available}",
  )
  for item in report.component_mappings {
    println(
      "component=\{item.bunnia_kind} platform_component=\{item.platform_component}",
    )
  }
  for item in report.event_mappings {
    println("event=\{item.bunnia_event} platform_event=\{item.platform_event}")
  }
}

///|
fn should_fail_build(
  strict : Bool,
  project : @bunnia.WechatProject,
  report : @bunnia.WechatBuildReport,
  patches : @bunnia.PatchPlan,
  profile : @bunnia.BuildProfile,
  profile_gate : @bunnia.BuildProfileGate,
  inspection_gate : @bunnia.ProjectInspectionGate,
  release : @bunnia.ReleaseReadinessReport,
) -> Bool {
  strict &&
  (
    project_has_render_diagnostics(project) ||
    report.diagnostics.length() > 0 ||
    patches.diagnostics.length() > 0 ||
    profile.diagnostics.length() > 0 ||
    profile_gate.diagnostics.length() > 0 ||
    inspection_gate.diagnostics.length() > 0 ||
    release.diagnostics.length() > 0
  )
}

///|
fn project_has_render_diagnostics(project : @bunnia.WechatProject) -> Bool {
  for page in project.pages {
    if page.page.plan.diagnostics.length() > 0 {
      return true
    }
  }
  false
}

///|
fn write_project(output_dir : String, project : @bunnia.WechatProject) -> Unit {
  for file in project.files {
    write_text_file(join_path(output_dir, file.path), file.content)
  }
}

///|
fn write_miniapp_project(
  output_dir : String,
  project : @bunnia.MiniappProject,
) -> Unit {
  for file in project.files {
    write_text_file(join_path(output_dir, file.path), file.content)
  }
}

///|
fn write_scaffold(output_dir : String, scaffold : @bunnia.ScaffoldPlan) -> Unit {
  for file in scaffold.files {
    let path = join_path(output_dir, file.path)
    if scaffold_file_is_executable(file.path) {
      write_executable_text_file(path, file.content)
    } else {
      write_text_file(path, file.content)
    }
  }
  write_text_file(
    join_path(output_dir, "moon.work"),
    scaffold_workspace_content(current_working_dir()),
  )
}

///|
fn scaffold_write_file_count(scaffold : @bunnia.ScaffoldPlan) -> Int {
  scaffold.files.length() + 1
}

///|
fn scaffold_file_is_executable(path : String) -> Bool {
  path.has_prefix("scripts/")
}

///|
fn scaffold_workspace_content(framework_path : String) -> String {
  "members = [\n" +
  "  \".\",\n" +
  "  \"\{escape_toml_string(framework_path)}\",\n" +
  "]\n"
}

///|
fn join_path(left : String, right : String) -> String {
  if left == "" {
    right
  } else if left.has_suffix("/") {
    "\{left}\{right}"
  } else {
    "\{left}/\{right}"
  }
}

///|
fn print_diagnostics(items : Array[String]) -> Unit {
  for item in items {
    println("diagnostic=\{item}")
  }
}

///|
fn print_profile_diagnostics(items : Array[String]) -> Unit {
  for item in items {
    println("profile_diagnostic=\{item}")
  }
}

///|
fn escape_toml_string(value : String) -> String {
  value.replace(old="\\", new="\\\\").replace(old="\"", new="\\\"").to_string()
}

///|
#cfg(target="js")
extern "js" fn current_working_dir() -> String =
  #| function() {
  #|   return process.cwd()
  #| }

///|
#cfg(not(target="js"))
fn current_working_dir() -> String {
  "."
}

///|
#cfg(target="js")
extern "js" fn watch_generated_output(
  target : String,
  example : String,
  output_dir : String,
  strict : Bool,
) -> Unit =
  #| function(target, example, outputDir, strict) {
  #|   const fs = require("fs")
  #|   const childProcess = require("child_process")
  #|   const watchRoots = [
  #|     "core",
  #|     "agent",
  #|     "scene",
  #|     "effects",
  #|     "program",
  #|     "adapters",
  #|     "tooling",
  #|     "examples",
  #|     "cmd",
  #|     "docs",
  #|   ]
  #|   const rootFiles = ["moon.mod", "moon.pkg", "README.mbt.md"]
  #|   const buildArgs = ["run", "cmd/main", "--", "build", "--target", target, "--example", example, "--out", outputDir]
  #|   if (strict) buildArgs.push("--strict")
  #|   function shouldRebuild(filename) {
  #|     if (!filename) return true
  #|     const text = String(filename)
  #|     if (text.includes("_build") || text.includes(".git")) return false
  #|     return text.endsWith(".mbt") ||
  #|       text.endsWith(".mbt.md") ||
  #|       text.endsWith(".md") ||
  #|       text.endsWith(".mbti") ||
  #|       text.endsWith("moon.pkg") ||
  #|       text.endsWith("moon.mod")
  #|   }
  #|   let timer = null
  #|   function rebuild(reason) {
  #|     if (!shouldRebuild(reason)) return
  #|     clearTimeout(timer)
  #|     timer = setTimeout(() => {
  #|       console.log("watch=rebuild reason=" + (reason || "change"))
  #|       const result = childProcess.spawnSync("moon", buildArgs, { stdio: "inherit" })
  #|       if (result.error) {
  #|         console.error("watch_error=" + result.error.message)
  #|       } else if (result.status !== 0) {
  #|         console.error("watch_exit=" + result.status)
  #|       }
  #|     }, 150)
  #|   }
  #|   for (const file of rootFiles) {
  #|     if (fs.existsSync(file)) {
  #|       fs.watch(file, () => rebuild(file))
  #|     }
  #|   }
  #|   for (const root of watchRoots) {
  #|     if (fs.existsSync(root)) {
  #|       fs.watch(root, { recursive: true }, (_event, filename) => {
  #|         rebuild(filename ? root + "/" + filename : root)
  #|       })
  #|     }
  #|   }
  #|   console.log("watch=active target=" + target + " example=" + example + " output=" + outputDir)
  #|   console.log("watching=" + watchRoots.join(","))
  #|   process.stdin.resume()
  #| }

///|
#cfg(not(target="js"))
fn watch_generated_output(
  _target : String,
  _example : String,
  _output_dir : String,
  _strict : Bool,
) -> Unit {
  panic()
}

///|
#cfg(target="js")
extern "js" fn write_text_file(path : String, content : String) -> Unit =
  #| function(path, content) {
  #|   const fs = require("fs")
  #|   const nodePath = require("path")
  #|   fs.mkdirSync(nodePath.dirname(path), { recursive: true })
  #|   fs.writeFileSync(path, content, "utf8")
  #| }

///|
#cfg(not(target="js"))
fn write_text_file(_path : String, _content : String) -> Unit {
  panic()
}

///|
#cfg(target="js")
extern "js" fn write_executable_text_file(
  path : String,
  content : String,
) -> Unit =
  #| function(path, content) {
  #|   const fs = require("fs")
  #|   const nodePath = require("path")
  #|   fs.mkdirSync(nodePath.dirname(path), { recursive: true })
  #|   fs.writeFileSync(path, content, { encoding: "utf8", mode: 0o755 })
  #|   fs.chmodSync(path, 0o755)
  #| }

///|
#cfg(not(target="js"))
fn write_executable_text_file(_path : String, _content : String) -> Unit {
  panic()
}
