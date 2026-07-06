///|
/// Entry point for local framework probes.
/// Run with `moon run cmd/main` from the project root.
fn main {
  let project = @demo.demo_wechat_project()
  let page = project.page
  let patches = @demo.demo_patch_plan()
  println(page.plan.summary)
  println(project.summary)
  println(patches.summary)
}
