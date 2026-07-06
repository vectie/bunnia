///|
pub struct ScaffoldFile {
  path : String
  content : String
} derive(Debug, Eq)

///|
pub struct ScaffoldPlan {
  name : String
  module_name : String
  files : Array[ScaffoldFile]
  summary : String
} derive(Debug, Eq)

///|
pub fn scaffold_project(
  name~ : String,
  module_name? : String = "",
) -> ScaffoldPlan {
  let module_id = if module_name == "" { "local/\{name}" } else { module_name }
  let readme_content = readme(name)
  let files = [
    scaffold_file("moon.mod", moon_mod(module_id)),
    scaffold_file("moon.pkg", moon_pkg()),
    scaffold_file("cmd/main/moon.pkg", cmd_main_pkg(module_id)),
    scaffold_file("cmd/main/main.mbt", cmd_main_mbt()),
    scaffold_file("app.mbt", app_mbt(name)),
    scaffold_file("agent_feed.mbt", agent_feed_mbt()),
    scaffold_file("scene.mbt", scene_mbt()),
    scaffold_file("updates.mbt", updates_mbt()),
    scaffold_file("quality.mbt", quality_mbt()),
    scaffold_file("wechat.mbt", wechat_mbt(name)),
    scaffold_file("app_test.mbt", app_test_mbt()),
    scaffold_file("README.mbt.md", readme_content),
    scaffold_file("README.md", readme_content),
    scaffold_file(".gitignore", gitignore()),
    scaffold_file("scripts/ci.sh", ci_script()),
    scaffold_file("scripts/validate_boundaries.sh", boundary_script()),
    scaffold_file(".github/workflows/ci.yml", github_ci_workflow()),
  ]
  {
    name,
    module_name: module_id,
    files,
    summary: "Bunnia scaffold: name=\{name} module=\{module_id} files=\{files.length()}",
  }
}

///|
pub fn scaffold_file(path : String, content : String) -> ScaffoldFile {
  { path, content }
}

///|
fn moon_mod(module_name : String) -> String {
  "name = \"\{escape_toml(module_name)}\"\n\n" +
  "version = \"0.1.0\"\n\n" +
  "readme = \"README.mbt.md\"\n\n" +
  "import {\n" +
  "  \"vectie/bunnia@0.1.0\"\n" +
  "}\n\n" +
  "preferred_target = \"js\"\n\n" +
  "description = \"Bunnia mini-app starter.\"\n"
}

///|
fn gitignore() -> String {
  ".DS_Store\n" + "_build/\n" + "target/\n" + ".mooncakes/\n" + ".moonagent/\n"
}

///|
fn ci_script() -> String {
  "#!/usr/bin/env sh\n" +
  "set -eu\n\n" +
  "mkdir -p _build\n" +
  "moon run cmd/main -- ci-plan --script --strict > _build/bunnia-ci.sh\n" +
  "sh _build/bunnia-ci.sh\n"
}

///|
fn boundary_script() -> String {
  let blocked_module = "vectie/moon" + "town"
  let forbidden = starter_forbidden_pattern()
  "#!/usr/bin/env sh\n" +
  "set -eu\n\n" +
  "blocked_module='\{blocked_module}'\n" +
  "forbidden='\{forbidden}'\n\n" +
  "if grep -n \"$blocked_module\" moon.mod moon.pkg cmd/main/moon.pkg; then\n" +
  "  printf '%s\\n' 'boundary violation: starter must not depend on blocked product module'\n" +
  "  exit 1\n" +
  "fi\n\n" +
  "if grep -n -E -i \"$forbidden\" app.mbt agent_feed.mbt scene.mbt updates.mbt quality.mbt wechat.mbt app_test.mbt cmd/main/main.mbt README.mbt.md README.md; then\n" +
  "  printf '%s\\n' 'boundary violation: starter must stay product-neutral; move product nouns into downstream app examples'\n" +
  "  exit 1\n" +
  "fi\n\n" +
  "printf '%s\\n' 'boundary=ok'\n"
}

///|
fn starter_forbidden_pattern() -> String {
  "moon" +
  "town|wen" +
  "yu|may" +
  "or|civ" +
  "ic[_ -]?build" +
  "ing|" +
  "moon" +
  "book|moon" +
  "claw|stand" +
  "ing[_ -]?watch|to" +
  "wn[_ -]?module"
}

///|
fn github_ci_workflow() -> String {
  "name: Bunnia CI\n\n" +
  "on:\n" +
  "  push:\n" +
  "  pull_request:\n" +
  "  workflow_dispatch:\n\n" +
  "jobs:\n" +
  "  bunnia:\n" +
  "    runs-on: ubuntu-latest\n" +
  "    permissions:\n" +
  "      contents: read\n" +
  "    steps:\n" +
  "      - name: Checkout\n" +
  "        uses: actions/checkout@v5\n" +
  "      - name: Set up MoonBit\n" +
  "        run: |\n" +
  "          curl -fsSL https://cli.moonbitlang.com/install/unix.sh | bash\n" +
  "          echo \"$HOME/.moon/bin\" >> $GITHUB_PATH\n" +
  "      - name: Run Bunnia starter CI\n" +
  "        run: sh scripts/ci.sh\n"
}

///|
fn moon_pkg() -> String {
  "import {\n" + "  \"vectie/bunnia\"\n" + "}\n"
}

///|
fn cmd_main_pkg(module_name : String) -> String {
  "import {\n" +
  "  \"\{escape_toml(module_name)}\" @app,\n" +
  "  \"vectie/bunnia\",\n" +
  "  \"moonbitlang/core/env\",\n" +
  "}\n\n" +
  "options(\n" +
  "  \"is-main\": true,\n" +
  ")\n"
}

///|
fn cmd_main_mbt() -> String {
  "///|\n" +
  "fn main {\n" +
  "  let command = command_from_args(@env.args())\n" +
  "  let strict = strict_from_args(@env.args())\n" +
  "  let target_support = target_support_from_args(@env.args())\n" +
  "  if command == \"help\" {\n" +
  "    print_help()\n" +
  "  } else if command == \"unknown\" {\n" +
  "    println(\"unsupported command=\\{unknown_command_from_args(@env.args())}\")\n" +
  "    print_help()\n" +
  "    panic()\n" +
  "  } else if command == \"ci-plan\" {\n" +
  "    if ci_script_from_args(@env.args()) {\n" +
  "      print_ci_script(strict, target_support)\n" +
  "    } else {\n" +
  "      print_ci_plan(strict, target_support)\n" +
  "    }\n" +
  "  } else if command == \"limits\" {\n" +
  "    print_platform_limits(@bunnia.platform_limits(target=target_from_args(@env.args())))\n" +
  "  } else {\n" +
  "    ensure_target_generator_available(target_support)\n" +
  "    let output_dir = output_dir_from_args(@env.args())\n" +
  "    let project = @app.starter_wechat_project()\n" +
  "    println(\"command=\\{command}\")\n" +
  "    println(\"target=\\{target_support.target}\")\n" +
  "    println(\"strict=\\{strict}\")\n" +
  "    println(project.summary)\n" +
  "    println(project.manifest.summary)\n" +
  "    println(project.report.summary)\n" +
  "    let inspection_gate = @app.inspection_gate(project)\n" +
  "    let profile_gate = @app.profile_gate(project)\n" +
  "    println(inspection_gate.summary)\n" +
  "    println(profile_gate.summary)\n" +
  "    if command == \"inspect\" {\n" +
  "      print_inspect_result(project, profile_gate, inspection_gate)\n" +
  "    } else if command == \"snapshot\" {\n" +
  "      let snapshot = starter_snapshot(project)\n" +
  "      let snapshot_path = snapshot_output_path_from_args(@env.args())\n" +
  "      write_text_file(snapshot_path, snapshot.content)\n" +
  "      println(snapshot.summary)\n" +
  "      println(\"snapshot=\\{snapshot_path}\")\n" +
  "    } else {\n" +
  "      for file in project.files {\n" +
  "        write_text_file(join_path(output_dir, file.path), file.content)\n" +
  "      }\n" +
  "      println(\"wrote=\\{project.files.length()} output=\\{output_dir}\")\n" +
  "    }\n" +
  "    if should_fail(strict, project, profile_gate, inspection_gate) {\n" +
  "      println(\"build_failed=diagnostics\")\n" +
  "      panic()\n" +
  "    }\n" +
  "  }\n" +
  "}\n\n" +
  "///|\n" +
  "fn command_from_args(args : Array[String]) -> String {\n" +
  "  if args.contains(\"help\") || args.contains(\"--help\") || args.contains(\"-h\") {\n" +
  "    return \"help\"\n" +
  "  }\n" +
  "  for i in 0..<args.length() {\n" +
  "    let item = args[i]\n" +
  "    if command_arg_is_ignored(args, i) {\n" +
  "      continue\n" +
  "    }\n" +
  "    if item == \"inspect\" {\n" +
  "      return \"inspect\"\n" +
  "    } else if item == \"snapshot\" {\n" +
  "      return \"snapshot\"\n" +
  "    } else if item == \"ci-plan\" {\n" +
  "      return \"ci-plan\"\n" +
  "    } else if item == \"limits\" {\n" +
  "      return \"limits\"\n" +
  "    } else if item == \"build\" {\n" +
  "      return \"build\"\n" +
  "    } else {\n" +
  "      return \"unknown\"\n" +
  "    }\n" +
  "  }\n" +
  "  \"build\"\n" +
  "}\n\n" +
  "///|\n" +
  "fn unknown_command_from_args(args : Array[String]) -> String {\n" +
  "  for i in 0..<args.length() {\n" +
  "    let item = args[i]\n" +
  "    if command_arg_is_ignored(args, i) {\n" +
  "      continue\n" +
  "    }\n" +
  "    if !command_arg_is_known(item) {\n" +
  "      return item\n" +
  "    }\n" +
  "  }\n" +
  "  \"\"\n" +
  "}\n\n" +
  "///|\n" +
  "fn command_arg_is_known(item : String) -> Bool {\n" +
  "  item == \"build\" ||\n" +
  "  item == \"inspect\" ||\n" +
  "  item == \"snapshot\" ||\n" +
  "  item == \"ci-plan\" ||\n" +
  "  item == \"limits\"\n" +
  "}\n\n" +
  "///|\n" +
  "fn command_arg_is_ignored(args : Array[String], index : Int) -> Bool {\n" +
  "  let item = args[index]\n" +
  "  command_arg_is_runner(item) ||\n" +
  "  item.has_prefix(\"-\") ||\n" +
  "  (index > 0 && command_option_consumes_value(args[index - 1]))\n" +
  "}\n\n" +
  "///|\n" +
  "fn command_arg_is_runner(item : String) -> Bool {\n" +
  "  item == \"node\" || item.has_suffix(\"/node\") || item.has_suffix(\".js\")\n" +
  "}\n\n" +
  "///|\n" +
  "fn command_option_consumes_value(item : String) -> Bool {\n" +
  "  item == \"--target\" ||\n" +
  "  item == \"--out\" ||\n" +
  "  item == \"--snapshot-out\"\n" +
  "}\n\n" +
  "///|\n" +
  "fn print_help() -> Unit {\n" +
  "  println(\"Bunnia starter CLI\")\n" +
  "  println(\"usage=moon run cmd/main -- <command> [options]\")\n" +
  "  println(\"command=build writes=_build/wechat\")\n" +
  "  println(\"command=inspect writes=false\")\n" +
  "  println(\"command=snapshot writes=snapshot-file\")\n" +
  "  println(\"command=ci-plan writes=false options=--script\")\n" +
  "  println(\"command=limits writes=false options=--target wechat|alipay|tiktok\")\n" +
  "  println(\"options=--target --strict --out --snapshot-out\")\n" +
  "}\n\n" +
  "///|\n" +
  "fn target_from_args(args : Array[String]) -> String {\n" +
  "  for i in 0..<args.length() {\n" +
  "    if args[i] == \"--target\" && i + 1 < args.length() {\n" +
  "      return args[i + 1]\n" +
  "    }\n" +
  "  }\n" +
  "  \"wechat\"\n" +
  "}\n\n" +
  "///|\n" +
  "fn output_dir_from_args(args : Array[String]) -> String {\n" +
  "  for i in 0..<args.length() {\n" +
  "    if args[i] == \"--out\" && i + 1 < args.length() {\n" +
  "      return args[i + 1]\n" +
  "    }\n" +
  "  }\n" +
  "  \"_build/wechat\"\n" +
  "}\n\n" +
  "///|\n" +
  "fn snapshot_output_path_from_args(args : Array[String]) -> String {\n" +
  "  for i in 0..<args.length() {\n" +
  "    if args[i] == \"--snapshot-out\" && i + 1 < args.length() {\n" +
  "      return args[i + 1]\n" +
  "    }\n" +
  "  }\n" +
  "  \"_build/snapshots/wechat/starter.snapshot.txt\"\n" +
  "}\n\n" +
  "///|\n" +
  "fn strict_from_args(args : Array[String]) -> Bool {\n" +
  "  args.contains(\"--strict\") || args.contains(\"--fail-on-diagnostics\")\n" +
  "}\n\n" +
  "///|\n" +
  "fn ci_script_from_args(args : Array[String]) -> Bool {\n" +
  "  args.contains(\"--script\")\n" +
  "}\n\n" +
  "///|\n" +
  "fn target_support_from_args(args : Array[String]) -> @bunnia.PlatformTargetSupport {\n" +
  "  @bunnia.platform_target_support(target=target_from_args(args))\n" +
  "}\n\n" +
  "///|\n" +
  "fn ensure_target_generator_available(\n" +
  "  support : @bunnia.PlatformTargetSupport,\n" +
  ") -> Unit {\n" +
  "  if !support.generator_available {\n" +
  "    println(support.summary)\n" +
  "    print_target_diagnostics(support)\n" +
  "    panic()\n" +
  "  }\n" +
  "}\n\n" +
  "///|\n" +
  "fn print_target_diagnostics(support : @bunnia.PlatformTargetSupport) -> Unit {\n" +
  "  for item in support.diagnostics {\n" +
  "    println(\"diagnostic=\\{item}\")\n" +
  "  }\n" +
  "}\n\n" +
  "///|\n" +
  "fn should_fail(\n" +
  "  strict : Bool,\n" +
  "  project : @bunnia.WechatProject,\n" +
  "  profile_gate : @bunnia.BuildProfileGate,\n" +
  "  inspection_gate : @bunnia.ProjectInspectionGate,\n" +
  ") -> Bool {\n" +
  "  strict && (\n" +
  "    project.report.diagnostics.length() > 0 ||\n" +
  "    project.manifest.diagnostic_count > 0 ||\n" +
  "    profile_gate.diagnostics.length() > 0 ||\n" +
  "    inspection_gate.diagnostics.length() > 0\n" +
  "  )\n" +
  "}\n\n" +
  "///|\n" +
  "fn starter_snapshot(project : @bunnia.WechatProject) -> @bunnia.GeneratedSnapshot {\n" +
  "  let profile = @app.build_profile(project)\n" +
  "  @bunnia.snapshot_wechat_project_with_report(\n" +
  "    target=\"wechat\",\n" +
  "    example=\"starter\",\n" +
  "    project,\n" +
  "    project.report,\n" +
  "    profile,\n" +
  "    budget_profile=\"tight\",\n" +
  "    render_budget_profile=\"tight\",\n" +
  "  )\n" +
  "}\n\n" +
  "///|\n" +
  "fn print_inspect_result(\n" +
  "  project : @bunnia.WechatProject,\n" +
  "  profile_gate : @bunnia.BuildProfileGate,\n" +
  "  inspection_gate : @bunnia.ProjectInspectionGate,\n" +
  ") -> Unit {\n" +
  "  let inspection = @app.project_inspection(project)\n" +
  "  let profile = @app.build_profile(project)\n" +
  "  println(profile.summary)\n" +
  "  println(inspection.summary)\n" +
  "  println(\"inspect=pages=\\{project.page_count} files=\\{project.files.length()} bytes=\\{project.total_bytes} risk_route=\\{inspection.top_route} risk_score=\\{inspection.risk_score} diagnostics=\\{project.manifest.diagnostic_count} profile_gate_diagnostics=\\{profile_gate.diagnostics.length()} inspection_gate_diagnostics=\\{inspection_gate.diagnostics.length()}\")\n" +
  "  for page in project.manifest.pages {\n" +
  "    println(\"route=\\{page.route} status=\\{page.status} nodes=\\{page.node_count} events=\\{page.event_count} backend_events=\\{page.backend_event_count} backend_streams=\\{page.backend_stream_count} backend_reviews=\\{page.backend_review_count} scene_markers=\\{page.scene_visible_marker_count}/\\{page.scene_marker_count} scene_regions=\\{page.scene_visible_region_count}/\\{page.scene_region_count} first_screen=\\{page.first_screen_bytes} update_payload=\\{page.update_payload_bytes} update_ops=\\{page.update_operation_count} diagnostics=\\{page.diagnostic_count}\")\n" +
  "  }\n" +
  "  for item in inspection_gate.diagnostics {\n" +
  "    println(\"inspection_diagnostic=\\{item}\")\n" +
  "  }\n" +
  "  for item in profile_gate.diagnostics {\n" +
  "    println(\"profile_gate_diagnostic=\\{item}\")\n" +
  "  }\n" +
  "  for file in project.manifest.files {\n" +
  "    println(\"file=\\{file.path} kind=\\{file.kind} bytes=\\{file.bytes}\")\n" +
  "  }\n" +
  "}\n\n" +
  "///|\n" +
  "fn print_ci_script(\n" +
  "  strict : Bool,\n" +
  "  target_support : @bunnia.PlatformTargetSupport,\n" +
  ") -> Unit {\n" +
  "  let strict_flag = if strict { \" --strict\" } else { \"\" }\n" +
  "  println(\"#!/usr/bin/env sh\")\n" +
  "  println(\"set -eu\")\n" +
  "  println(\"\")\n" +
  "  println(\"# Generated by Bunnia starter ci-plan --script.\")\n" +
  "  println(\"# \\{target_support.summary}\")\n" +
  "  println(\"\")\n" +
  "  if !target_support.generator_available {\n" +
  "    println(\"# Bunnia starter CI plan: steps=9 diagnostics=\\{target_support.diagnostics.length()}\")\n" +
  "    println(\"echo 'Bunnia starter CI plan diagnostics:'\")\n" +
  "    for item in target_support.diagnostics {\n" +
  "      println(\"echo '\\{item}'\")\n" +
  "    }\n" +
  "    println(\"exit 1\")\n" +
  "  } else {\n" +
  "    let project = @app.starter_wechat_project()\n" +
  "    let inspection_gate = @app.inspection_gate(project)\n" +
  "    let profile_gate = @app.profile_gate(project)\n" +
  "    let diagnostics = project.report.diagnostics.length() +\n" +
  "      project.manifest.diagnostic_count +\n" +
  "      inspection_gate.diagnostics.length() +\n" +
  "      profile_gate.diagnostics.length()\n" +
  "    println(\"# Bunnia starter CI plan: steps=9 diagnostics=\\{diagnostics}\")\n" +
  "    println(\"# \\{inspection_gate.summary}\")\n" +
  "    println(\"# \\{profile_gate.summary}\")\n" +
  "    println(\"\")\n" +
  "    if diagnostics > 0 {\n" +
  "      println(\"echo 'Bunnia starter CI plan has diagnostics; run moon run cmd/main -- ci-plan --strict for details.'\")\n" +
  "      println(\"exit 1\")\n" +
  "    } else {\n" +
  "      println(\"echo '==> check'\")\n" +
  "      println(\"moon check\")\n" +
  "      println(\"echo '==> test'\")\n" +
  "      println(\"moon test\")\n" +
  "      println(\"echo '==> info'\")\n" +
  "      println(\"moon info\")\n" +
  "      println(\"echo '==> fmt'\")\n" +
  "      println(\"moon fmt\")\n" +
  "      println(\"echo '==> boundary'\")\n" +
  "      println(\"sh scripts/validate_boundaries.sh\")\n" +
  "      println(\"echo '==> limits'\")\n" +
  "      println(\"moon run cmd/main -- limits --target \\{target_support.target}\")\n" +
  "      println(\"echo '==> inspect'\")\n" +
  "      println(\"moon run cmd/main -- inspect --target \\{target_support.target}\\{strict_flag}\")\n" +
  "      println(\"echo '==> snapshot'\")\n" +
  "      println(\"moon run cmd/main -- snapshot --target \\{target_support.target} --snapshot-out _build/snapshots/wechat/starter.snapshot.txt\\{strict_flag}\")\n" +
  "      println(\"echo '==> build'\")\n" +
  "      println(\"moon run cmd/main -- build --target \\{target_support.target} --out _build/wechat\\{strict_flag}\")\n" +
  "    }\n" +
  "  }\n" +
  "}\n\n" +
  "///|\n" +
  "fn print_ci_plan(\n" +
  "  strict : Bool,\n" +
  "  target_support : @bunnia.PlatformTargetSupport,\n" +
  ") -> Unit {\n" +
  "  let strict_flag = if strict { \" --strict\" } else { \"\" }\n" +
  "  println(\"command=ci-plan\")\n" +
  "  println(\"target=\\{target_support.target}\")\n" +
  "  println(\"strict=\\{strict}\")\n" +
  "  println(target_support.summary)\n" +
  "  if !target_support.generator_available {\n" +
  "    println(\"Bunnia starter CI plan: steps=9 diagnostics=\\{target_support.diagnostics.length()}\")\n" +
  "    print_target_diagnostics(target_support)\n" +
  "  } else {\n" +
  "    let project = @app.starter_wechat_project()\n" +
  "    let inspection_gate = @app.inspection_gate(project)\n" +
  "    let profile_gate = @app.profile_gate(project)\n" +
  "    let diagnostics = project.report.diagnostics.length() +\n" +
  "      project.manifest.diagnostic_count +\n" +
  "      inspection_gate.diagnostics.length() +\n" +
  "      profile_gate.diagnostics.length()\n" +
  "    println(\"Bunnia starter CI plan: steps=9 diagnostics=\\{diagnostics}\")\n" +
  "    println(inspection_gate.summary)\n" +
  "    println(profile_gate.summary)\n" +
  "    for item in project.report.diagnostics {\n" +
  "      println(\"diagnostic=\\{item}\")\n" +
  "    }\n" +
  "    for page in project.manifest.pages {\n" +
  "      for item in page.diagnostics {\n" +
  "        println(\"route_diagnostic=\\{page.route}:\\{item}\")\n" +
  "      }\n" +
  "    }\n" +
  "    for item in inspection_gate.diagnostics {\n" +
  "      println(\"inspection_diagnostic=\\{item}\")\n" +
  "    }\n" +
  "    for item in profile_gate.diagnostics {\n" +
  "      println(\"profile_gate_diagnostic=\\{item}\")\n" +
  "    }\n" +
  "    println(\"step=check command=moon check\")\n" +
  "    println(\"step=test command=moon test\")\n" +
  "    println(\"step=info command=moon info\")\n" +
  "    println(\"step=fmt command=moon fmt\")\n" +
  "    println(\"step=boundary command=sh scripts/validate_boundaries.sh\")\n" +
  "    println(\"step=limits command=moon run cmd/main -- limits --target \\{target_support.target}\")\n" +
  "    println(\"step=inspect command=moon run cmd/main -- inspect --target \\{target_support.target}\\{strict_flag}\")\n" +
  "    println(\"step=snapshot command=moon run cmd/main -- snapshot --target \\{target_support.target} --snapshot-out _build/snapshots/wechat/starter.snapshot.txt\\{strict_flag}\")\n" +
  "    println(\"step=build command=moon run cmd/main -- build --target \\{target_support.target} --out _build/wechat\\{strict_flag}\")\n" +
  "  }\n" +
  "}\n\n" +
  "///|\n" +
  "fn print_platform_limits(report : @bunnia.PlatformLimitsReport) -> Unit {\n" +
  "  println(\"command=limits\")\n" +
  "  println(\"target=\\{report.target}\")\n" +
  "  println(report.summary)\n" +
  "  for item in report.diagnostics {\n" +
  "    println(\"diagnostic=\\{item}\")\n" +
  "  }\n" +
  "  println(\"generator_status=\\{report.generator_status_id}\")\n" +
  "  println(\"capability=canvas:\\{report.supports_canvas} cloud:\\{report.supports_cloud} stream:\\{report.supports_stream} generator:\\{report.generator_available}\")\n" +
  "  for item in report.component_mappings {\n" +
  "    println(\"component=\\{item.bunnia_kind} platform_component=\\{item.platform_component}\")\n" +
  "  }\n" +
  "  for item in report.event_mappings {\n" +
  "    println(\"event=\\{item.bunnia_event} platform_event=\\{item.platform_event}\")\n" +
  "  }\n" +
  "}\n\n" +
  "///|\n" +
  "fn join_path(left : String, right : String) -> String {\n" +
  "  if left == \"\" {\n" +
  "    right\n" +
  "  } else if left.has_suffix(\"/\") {\n" +
  "    \"\\{left}\\{right}\"\n" +
  "  } else {\n" +
  "    \"\\{left}/\\{right}\"\n" +
  "  }\n" +
  "}\n\n" +
  "///|\n" +
  "#cfg(target=\"js\")\n" +
  "extern \"js\" fn write_text_file(path : String, content : String) -> Unit =\n" +
  "  #| function(path, content) {\n" +
  "  #|   const fs = require(\"fs\")\n" +
  "  #|   const nodePath = require(\"path\")\n" +
  "  #|   fs.mkdirSync(nodePath.dirname(path), { recursive: true })\n" +
  "  #|   fs.writeFileSync(path, content, \"utf8\")\n" +
  "  #| }\n\n" +
  "///|\n" +
  "#cfg(not(target=\"js\"))\n" +
  "fn write_text_file(_path : String, _content : String) -> Unit {\n" +
  "  panic()\n" +
  "}\n"
}

///|
fn app_mbt(name : String) -> String {
  "///|\n" +
  "pub fn view() -> @bunnia.Node {\n" +
  "  @bunnia.page([\n" +
  "    @bunnia.view_with_attrs([@bunnia.class_name(\"demo-shell\")], [\n" +
  "      @bunnia.text(\"\{escape_mbt(name)}\"),\n" +
  "      @bunnia.surface_status_overlay(starter_status(), starter_agent_feed()),\n" +
  "      @bunnia.static_scene_view(starter_scene()),\n" +
  "      @bunnia.button(\"Refresh\", \"refresh\"),\n" +
  "    ]),\n" +
  "  ])\n" +
  "}\n\n" +
  "///|\n" +
  "fn starter_status() -> @bunnia.SurfaceStatus {\n" +
  "  @bunnia.surface_stale(\n" +
  "    label=\"Live context\",\n" +
  "    detail=\"Refresh keeps the visible feed small while preserving total conversation scale.\",\n" +
  "    action_message=\"refresh\",\n" +
  "  )\n" +
  "}\n"
}

///|
fn agent_feed_mbt() -> String {
  "///|\n" +
  "fn starter_agent_feed() -> @bunnia.Node {\n" +
  "  @bunnia.windowed_message_feed([\n" +
  "    @bunnia.message(\n" +
  "      id=\"msg-1\",\n" +
  "      actor_id=\"agent\",\n" +
  "      thread_id=\"thread-main\",\n" +
  "      text=\"Ready for mini-app work.\",\n" +
  "      status=@bunnia.run_done(),\n" +
  "    ),\n" +
  "  ], total_count=1)\n" +
  "}\n"
}

///|
fn scene_mbt() -> String {
  "///|\n" +
  "fn starter_scene() -> @bunnia.Scene {\n" +
  "  @bunnia.scene(\n" +
  "    \"starter-map\",\n" +
  "    @bunnia.scene_size(320, 240),\n" +
  "    [\n" +
  "      @bunnia.layer(\"regions\", 1, [], regions=[\n" +
  "        @bunnia.region(\n" +
  "          id=\"workbench\",\n" +
  "          label=\"Workbench\",\n" +
  "          x=32,\n" +
  "          y=48,\n" +
  "          width=180,\n" +
  "          height=120,\n" +
  "          status=\"ready\",\n" +
  "          tap_message=\"select-workbench\",\n" +
  "        ),\n" +
  "      ]),\n" +
  "      @bunnia.layer(\"agents\", 1, [\n" +
  "        @bunnia.marker(\n" +
  "          id=\"agent-a\",\n" +
  "          label=\"Agent A\",\n" +
  "          x=96,\n" +
  "          y=120,\n" +
  "          status=\"ready\",\n" +
  "          tap_message=\"select-agent-a\",\n" +
  "        ),\n" +
  "      ]),\n" +
  "    ],\n" +
  "  )\n" +
  "}\n\n" +
  "///|\n" +
  "pub fn scene_render_plan() -> @bunnia.SceneRenderPlan {\n" +
  "  @bunnia.plan_scene_render(starter_scene())\n" +
  "}\n"
}

///|
fn updates_mbt() -> String {
  "///|\n" +
  "pub fn patch_plan() -> @bunnia.PatchPlan {\n" +
  "  @bunnia.plan_agent_deltas([\n" +
  "    @bunnia.append_stream_chunk_delta(\n" +
  "      \"streams.main.chunks\",\n" +
  "      \"chunk-1\",\n" +
  "      \"Refresh requested.\",\n" +
  "    ),\n" +
  "  ]).patch_plan\n" +
  "}\n\n" +
  "///|\n" +
  "pub fn scene_patch_plan() -> @bunnia.PatchPlan {\n" +
  "  @bunnia.plan_patches([\n" +
  "    @bunnia.select_scene_region(\"starter-map\", \"workbench\"),\n" +
  "    @bunnia.set_scene_region_status(\"starter-map\", \"workbench\", \"selected\"),\n" +
  "    @bunnia.select_scene_marker(\"starter-map\", \"agent-a\"),\n" +
  "    @bunnia.set_scene_marker_status(\"starter-map\", \"agent-a\", \"selected\"),\n" +
  "  ])\n" +
  "}\n"
}

///|
fn quality_mbt() -> String {
  "///|\n" +
  "pub fn render_plan() -> @bunnia.RenderPlan {\n" +
  "  @bunnia.plan(view(), @bunnia.wechat())\n" +
  "}\n\n" +
  "///|\n" +
  "pub fn strict_render_plan() -> @bunnia.RenderPlan {\n" +
  "  @bunnia.plan_with_budget(\n" +
  "    view(),\n" +
  "    @bunnia.wechat(),\n" +
  "    @bunnia.render_budget_for_profile(\"tight\"),\n" +
  "  )\n" +
  "}\n\n" +
  "///|\n" +
  "pub fn effect_plan() -> @bunnia.EffectPlan {\n" +
  "  @bunnia.plan_backend_effects_for_platform(\n" +
  "    starter_backend_contract(),\n" +
  "    @bunnia.wechat(),\n" +
  "  )\n" +
  "}\n\n" +
  "///|\n" +
  "pub fn backend_plan() -> @bunnia.BackendPlan {\n" +
  "  @bunnia.plan_backend_contract(starter_backend_contract())\n" +
  "}\n\n" +
  "///|\n" +
  "pub fn build_profile(project : @bunnia.WechatProject) -> @bunnia.BuildProfile {\n" +
  "  @bunnia.profile_wechat_project(\n" +
  "    project,\n" +
  "    patch_plan(),\n" +
  "    effect_plans=[effect_plan()],\n" +
  "    backend_plans=[backend_plan()],\n" +
  "    scene_plans=[scene_render_plan()],\n" +
  "  )\n" +
  "}\n\n" +
  "///|\n" +
  "pub fn project_inspection(\n" +
  "  project : @bunnia.WechatProject,\n" +
  ") -> @bunnia.ProjectInspection {\n" +
  "  @bunnia.inspect_wechat_project(\n" +
  "    target=\"wechat\",\n" +
  "    example=\"starter\",\n" +
  "    project,\n" +
  "    project.report,\n" +
  "  )\n" +
  "}\n\n" +
  "///|\n" +
  "pub fn inspection_gate(\n" +
  "  project : @bunnia.WechatProject,\n" +
  ") -> @bunnia.ProjectInspectionGate {\n" +
  "  @bunnia.gate_project_inspection(\n" +
  "    project_inspection(project),\n" +
  "    @bunnia.inspection_budget_for_profile(\"tight\"),\n" +
  "    budget_profile=\"tight\",\n" +
  "  )\n" +
  "}\n\n" +
  "///|\n" +
  "pub fn profile_gate(\n" +
  "  project : @bunnia.WechatProject,\n" +
  ") -> @bunnia.BuildProfileGate {\n" +
  "  @bunnia.gate_build_profile(\n" +
  "    build_profile(project),\n" +
  "    @bunnia.build_profile_budget_for_profile(\"tight\"),\n" +
  "    budget_profile=\"tight\",\n" +
  "  )\n" +
  "}\n"
}

///|
fn wechat_mbt(name : String) -> String {
  "///|\n" +
  "pub fn starter_backend_contract() -> @bunnia.BackendContract {\n" +
  "  @bunnia.backend_contract(id=\"starter-backend\", endpoints=[\n" +
  "    @bunnia.agent_message_endpoint(\n" +
  "      \"refresh\", \"/agent/message\", \"refreshDraft\", \"refreshResult\",\n" +
  "    ),\n" +
  "  ])\n" +
  "}\n\n" +
  "///|\n" +
  "pub fn starter_wechat_runtime() -> @bunnia.WechatRuntime {\n" +
  "  @bunnia.wechat_runtime(\n" +
  "    initial_data_json=\"{}\",\n" +
  "    event_patches=[\n" +
  "      @bunnia.wechat_event_patch(\"refresh\", patch_plan().patches),\n" +
  "      @bunnia.wechat_event_patch(\"select-workbench\", scene_patch_plan().patches),\n" +
  "      @bunnia.wechat_event_patch(\"select-agent-a\", scene_patch_plan().patches),\n" +
  "    ],\n" +
  "  )\n" +
  "}\n\n" +
  "///|\n" +
  "pub fn starter_wechat_project() -> @bunnia.WechatProject {\n" +
  "  @bunnia.generate_wechat_project_with_runtime_and_budget_and_backend(\n" +
  "    name=\"\{escape_mbt(name)}\",\n" +
  "    route=\"pages/index/index\",\n" +
  "    root=view(),\n" +
  "    runtime=starter_wechat_runtime(),\n" +
  "    render_budget=@bunnia.render_budget_for_profile(\"tight\"),\n" +
  "    backend_contract=starter_backend_contract(),\n" +
  "  )\n" +
  "}\n\n" +
  "///|\n" +
  "pub fn starter_wechat_report() -> @bunnia.WechatBuildReport {\n" +
  "  starter_wechat_project().report\n" +
  "}\n"
}

///|
fn app_test_mbt() -> String {
  "///|\n" +
  "test \"starter render plans stay within tight budgets\" {\n" +
  "  let plan = strict_render_plan()\n" +
  "  assert_eq(plan.diagnostics.length(), 0)\n" +
  "  assert_eq(plan.scene_count, 1)\n" +
  "  assert_eq(plan.scene_marker_count, 1)\n" +
  "  assert_eq(plan.scene_region_count, 1)\n" +
  "  assert_eq(plan.degraded_scene_count, 0)\n" +
  "  let scene = scene_render_plan()\n" +
  "  assert_eq(scene.marker_count, 1)\n" +
  "  assert_eq(scene.visible_marker_count, 1)\n" +
  "  assert_eq(scene.region_count, 1)\n" +
  "  assert_eq(scene.visible_region_count, 1)\n" +
  "  assert_eq(scene.diagnostics.length(), 0)\n" +
  "}\n\n" +
  "///|\n" +
  "test \"starter updates stay bounded\" {\n" +
  "  let agent = patch_plan()\n" +
  "  assert_eq(agent.patches.length(), 1)\n" +
  "  assert_eq(agent.diagnostics.length(), 0)\n" +
  "  let scene = scene_patch_plan()\n" +
  "  assert_eq(scene.patches.length(), 4)\n" +
  "  assert_eq(scene.diagnostics.length(), 0)\n" +
  "}\n\n" +
  "///|\n" +
  "test \"starter generates clean wechat output\" {\n" +
  "  let project = starter_wechat_project()\n" +
  "  assert_eq(project.page_count, 1)\n" +
  "  assert_eq(project.report.diagnostics.length(), 0)\n" +
  "  assert_eq(project.report.missing_event_patch_count, 0)\n" +
  "  assert_eq(project.report.orphan_event_patch_count, 0)\n" +
  "  assert_eq(project.manifest.pages[0].scene_count, 1)\n" +
  "  assert_eq(project.manifest.pages[0].backend_event_count, 1)\n" +
  "  assert_eq(backend_plan().endpoint_count, 1)\n" +
  "  assert_eq(profile_gate(project).diagnostics.length(), 0)\n" +
  "  assert_eq(inspection_gate(project).diagnostics.length(), 0)\n" +
  "  assert_true(project.files.length() > 0)\n" +
  "}\n"
}

///|
fn readme(name : String) -> String {
  "# \{name}\n\n" +
  "A Bunnia mini-app starter generated by `bunnia init`.\n\n" +
  "The starter keeps app view, agent feed, scene model, bounded updates, backend contract, inspection gates, WeChat generation, a local build command, and starter tests in separate files so the app can grow without mixing product code into the framework.\n\n" +
  "```bash\n" +
  "moon check\n" +
  "moon run cmd/main -- help\n" +
  "moon test\n" +
  "moon info\n" +
  "moon fmt\n" +
  "moon run cmd/main -- ci-plan --strict\n" +
  "moon run cmd/main -- ci-plan --script --strict\n" +
  "sh scripts/ci.sh\n" +
  "sh scripts/validate_boundaries.sh\n" +
  "# GitHub Actions runs the same script from .github/workflows/ci.yml\n" +
  "moon run cmd/main -- limits --target wechat\n" +
  "moon run cmd/main -- inspect --target wechat --strict\n" +
  "moon run cmd/main -- snapshot --target wechat --snapshot-out _build/snapshots/wechat/starter.snapshot.txt --strict\n" +
  "moon run cmd/main -- build --target wechat --out _build/wechat --strict\n" +
  "```\n"
}

///|
fn escape_toml(value : String) -> String {
  value.replace(old="\\", new="\\\\").replace(old="\"", new="\\\"").to_string()
}

///|
fn escape_mbt(value : String) -> String {
  value
  .replace(old="\\", new="\\\\")
  .replace(old="\"", new="\\\"")
  .replace(old="\n", new=" ")
  .to_string()
}
