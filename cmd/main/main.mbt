///|
/// Entry point for local framework probes.
/// Run with `moon run cmd/main` from the project root.
fn main {
  let example = example_from_args(@env.args())
  let output_dir = output_dir_from_args(@env.args(), example)
  let project = project_for_example(example)
  let patches = patches_for_example(example)
  write_project(output_dir, project)
  println("example=\{example}")
  println(project.page.plan.summary)
  println(project.summary)
  println(project.report.summary)
  print_diagnostics(project.report.diagnostics)
  println(patches.summary)
  println("wrote=\{project.files.length()} output=\{output_dir}")
}

///|
fn default_example() -> String {
  "agent_map"
}

///|
fn default_output_dir_for_example(example : String) -> String {
  "_build/bunnia/wechat/\{example}"
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
fn output_dir_from_args(args : Array[String], example : String) -> String {
  for i in 0..<args.length() {
    if args[i] == "--out" && i + 1 < args.length() {
      return args[i + 1]
    }
  }
  default_output_dir_for_example(example)
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
fn write_project(output_dir : String, project : @bunnia.WechatProject) -> Unit {
  for file in project.files {
    write_text_file(join_path(output_dir, file.path), file.content)
  }
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
