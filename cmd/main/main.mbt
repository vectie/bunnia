///|
/// Entry point for local framework probes.
/// Run with `moon run cmd/main` from the project root.
fn main {
  let output_dir = output_dir_from_args(@env.args())
  let project = @demo.demo_wechat_project()
  let patches = @demo.demo_patch_plan()
  write_project(output_dir, project)
  println(project.page.plan.summary)
  println(project.summary)
  println(patches.summary)
  println("wrote=\{project.files.length()} output=\{output_dir}")
}

///|
fn default_output_dir() -> String {
  "_build/bunnia/wechat/agent_map"
}

///|
fn output_dir_from_args(args : Array[String]) -> String {
  for i in 0..<args.length() {
    if args[i] == "--out" && i + 1 < args.length() {
      return args[i + 1]
    }
  }
  default_output_dir()
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
