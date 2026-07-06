///|
/// Entry point for local framework probes.
/// Run with `moon run cmd/main` from the project root.
fn main {
  let page = @demo.demo_wechat_page()
  let patches = @demo.demo_patch_plan()
  println(page.plan.summary)
  println("wxml-bytes=\{page.wxml.length()} js-bytes=\{page.js.length()}")
  println(patches.summary)
}
