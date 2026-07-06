///|
/// Entry point for local framework probes.
/// Run with `moon run cmd/main` from the project root.
fn main {
  let command = command_from_args(@env.args())
  if command == "init" {
    let name = scaffold_name_from_args(@env.args())
    let output_dir = scaffold_output_dir_from_args(@env.args(), name)
    let scaffold = scaffold_from_args(@env.args(), name)
    write_scaffold(output_dir, scaffold)
    println("command=init")
    println(scaffold.summary)
    println("wrote=\{scaffold_write_file_count(scaffold)} output=\{output_dir}")
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
  for item in args {
    if item == "build" {
      return "build"
    } else if item == "init" {
      return "init"
    } else if item == "watch" {
      return "watch"
    } else if item == "snapshot" {
      return "snapshot"
    }
  }
  default_command()
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
fn project_for_build(
  target : String,
  example : String,
) -> @bunnia.WechatProject {
  if target != "wechat" {
    println("unsupported target=\{target}")
    panic()
  }
  project_for_example(example)
}

///|
fn project_for_example(example : String) -> @bunnia.WechatProject {
  if example == "wenyu_overview" {
    @wenyu.demo_wechat_project()
  } else if example == "agent_map" {
    @demo.demo_wechat_project()
  } else {
    println("unsupported example=\{example}")
    panic()
  }
}

///|
fn patches_for_build(target : String, example : String) -> @bunnia.PatchPlan {
  if target != "wechat" {
    println("unsupported target=\{target}")
    panic()
  }
  patches_for_example(example)
}

///|
fn patches_for_example(example : String) -> @bunnia.PatchPlan {
  if example == "wenyu_overview" {
    @wenyu.demo_patch_plan()
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
) -> @bunnia.BuildProfile {
  if target != "wechat" {
    println("unsupported target=\{target}")
    panic()
  }
  profile_for_example(example, project, patches)
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
  } else if example == "agent_map" {
    @bunnia.profile_wechat_project(
      project,
      patches,
      communication_plans=[@demo.demo_communication_plan()],
      agent_delta_plans=[@demo.demo_agent_delta_plan()],
      snapshot_plans=[@demo.demo_snapshot_delta_plan()],
      asset_plans=[@demo.demo_asset_plan()],
      thread_plans=[@demo.demo_scene_thread_plan()],
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
  let example = example_from_args(args)
  let output_dir = output_dir_from_args(args, target, example)
  let project = project_for_build(target, example)
  let patches = patches_for_build(target, example)
  let profile = profile_for_build(target, example, project, patches)
  let strict = strict_from_args(args)
  write_project(output_dir, project)
  print_build_result(
    command, target, example, output_dir, project, patches, profile,
  )
  if command == "snapshot" {
    let snapshot = @bunnia.snapshot_wechat_project(
      target~,
      example~,
      project,
      profile,
    )
    let snapshot_path = snapshot_output_path_from_args(args, target, example)
    write_text_file(snapshot_path, snapshot.content)
    println(snapshot.summary)
    println("snapshot=\{snapshot_path}")
  }
  if should_fail_build(strict, project, patches, profile) {
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
fn print_build_result(
  command : String,
  target : String,
  example : String,
  output_dir : String,
  project : @bunnia.WechatProject,
  patches : @bunnia.PatchPlan,
  profile : @bunnia.BuildProfile,
) -> Unit {
  println("command=\{command}")
  println("target=\{target}")
  println("example=\{example}")
  println(project.page.plan.summary)
  println(project.summary)
  println(project.manifest.summary)
  println(project.report.summary)
  print_diagnostics(project.report.diagnostics)
  println(patches.summary)
  println(profile.summary)
  print_profile_diagnostics(profile.diagnostics)
  println("wrote=\{project.files.length()} output=\{output_dir}")
}

///|
fn should_fail_build(
  strict : Bool,
  project : @bunnia.WechatProject,
  patches : @bunnia.PatchPlan,
  profile : @bunnia.BuildProfile,
) -> Bool {
  strict &&
  (
    project_has_render_diagnostics(project) ||
    project.report.diagnostics.length() > 0 ||
    patches.diagnostics.length() > 0 ||
    profile.diagnostics.length() > 0
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
fn write_scaffold(output_dir : String, scaffold : @bunnia.ScaffoldPlan) -> Unit {
  for file in scaffold.files {
    write_text_file(join_path(output_dir, file.path), file.content)
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
fn scaffold_workspace_content(framework_path : String) -> String {
  "members = [\n" + "  \"\{escape_toml_string(framework_path)}\",\n" + "]\n"
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
