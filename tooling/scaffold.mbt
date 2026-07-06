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
    scaffold_file("README.mbt.md", readme(name)),
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
fn moon_pkg() -> String {
  "import {\n" + "  \"vectie/bunnia\"\n" + "}\n"
}

///|
fn cmd_main_pkg(module_name : String) -> String {
  "import {\n" +
  "  \"\{escape_toml(module_name)}\" @app,\n" +
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
  "  let output_dir = output_dir_from_args(@env.args())\n" +
  "  let project = @app.starter_wechat_project()\n" +
  "  for file in project.files {\n" +
  "    write_text_file(join_path(output_dir, file.path), file.content)\n" +
  "  }\n" +
  "  println(\"command=build\")\n" +
  "  println(project.summary)\n" +
  "  println(project.report.summary)\n" +
  "  println(\"wrote=\\{project.files.length()} output=\\{output_dir}\")\n" +
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
  "}\n"
}

///|
fn wechat_mbt(name : String) -> String {
  "///|\n" +
  "pub fn starter_wechat_runtime() -> @bunnia.WechatRuntime {\n" +
  "  @bunnia.wechat_runtime(\n" +
  "    initial_data_json=\"{}\",\n" +
  "    event_patches=[\n" +
  "      @bunnia.wechat_event_patch(\"refresh\", patch_plan().patches),\n" +
  "      @bunnia.wechat_event_patch(\"select-agent-a\", scene_patch_plan().patches),\n" +
  "    ],\n" +
  "  )\n" +
  "}\n\n" +
  "///|\n" +
  "pub fn starter_wechat_project() -> @bunnia.WechatProject {\n" +
  "  @bunnia.generate_wechat_project_with_runtime_and_budget(\n" +
  "    name=\"\{escape_mbt(name)}\",\n" +
  "    route=\"pages/index/index\",\n" +
  "    root=view(),\n" +
  "    runtime=starter_wechat_runtime(),\n" +
  "    render_budget=@bunnia.render_budget_for_profile(\"tight\"),\n" +
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
  "  assert_eq(plan.degraded_scene_count, 0)\n" +
  "  let scene = scene_render_plan()\n" +
  "  assert_eq(scene.marker_count, 1)\n" +
  "  assert_eq(scene.visible_marker_count, 1)\n" +
  "  assert_eq(scene.diagnostics.length(), 0)\n" +
  "}\n\n" +
  "///|\n" +
  "test \"starter updates stay bounded\" {\n" +
  "  let agent = patch_plan()\n" +
  "  assert_eq(agent.patches.length(), 1)\n" +
  "  assert_eq(agent.diagnostics.length(), 0)\n" +
  "  let scene = scene_patch_plan()\n" +
  "  assert_eq(scene.patches.length(), 2)\n" +
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
  "  assert_true(project.files.length() > 0)\n" +
  "}\n"
}

///|
fn readme(name : String) -> String {
  "# \{name}\n\n" +
  "A Bunnia mini-app starter generated by `bunnia init`.\n\n" +
  "The starter keeps app view, agent feed, scene model, bounded updates, budget checks, WeChat generation, a local build command, and starter tests in separate files so the app can grow without mixing product code into the framework.\n\n" +
  "```bash\n" +
  "moon check\n" +
  "moon test\n" +
  "moon run cmd/main -- --out _build/wechat\n" +
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
