///|
test "agent feed and scene primitives produce keyed mini-app trees" {
  let messages = [
    @bunnia.message(
      id="msg-1",
      actor_id="agent-a",
      thread_id="thread-a",
      text="Checking status",
      artifact_ref="artifact://a",
    ),
    @bunnia.message(
      id="msg-2",
      actor_id="human-a",
      thread_id="thread-a",
      text="Approve the update?",
    ),
  ]
  let scene = @bunnia.scene("overview", @bunnia.scene_size(640, 480), [
    @bunnia.layer("actors", 10, [
      @bunnia.marker(
        id="marker-a",
        label="Agent A",
        x=120,
        y=180,
        status="running",
        tap_message="select-marker-a",
      ),
    ]),
  ])
  let root = @bunnia.page([
    @bunnia.message_feed(messages),
    @bunnia.static_scene_view(scene),
  ])
  let render = @bunnia.plan(root, @bunnia.wechat())
  assert_true(render.event_messages.contains("select-marker-a"))
  assert_true(render.component_kinds.contains("scroll-view"))
  assert_true(@bunnia.node_count(root) > 8)
}

///|
test "render budgets report large app pressure early" {
  let root = @bunnia.page([
    @bunnia.view([
      @bunnia.view([
        @bunnia.view([
          @bunnia.button("Open", "open"),
          @bunnia.button("Close", "close"),
        ]),
      ]),
    ]),
  ])
  let budget = @bunnia.render_budget(
    max_nodes=3,
    max_depth=2,
    max_events=1,
    max_initial_data_bytes=1024,
  )
  let render = @bunnia.plan_with_budget(root, @bunnia.wechat(), budget)
  assert_eq(render.diagnostics.length(), 3)
  assert_true(render.diagnostics.contains("node-count-over-budget:8/3"))
  assert_true(render.diagnostics.contains("depth-over-budget:6/2"))
  assert_true(render.diagnostics.contains("event-count-over-budget:2/1"))
}

///|
test "wechat generator emits page files with targeted event routing" {
  let root = @bunnia.page([
    @bunnia.view([@bunnia.text("Demo"), @bunnia.button("Open", "open-detail")]),
  ])
  let output = @bunnia.generate_wechat_page("Demo", root)
  assert_true(output.wxml.contains("bindtap=\"__bunniaEvent\""))
  assert_true(output.wxml.contains("data-bunnia-message=\"open-detail\""))
  assert_true(output.js.contains("\"__bunnia.lastMessage\""))
  assert_true(output.json.contains("navigationBarTitleText"))
  assert_eq(output.plan.node_count, 5)
}

///|
test "wechat project generator emits deterministic mini-program files" {
  let root = @bunnia.page([
    @bunnia.view([@bunnia.text("Demo"), @bunnia.button("Open", "open-detail")]),
  ])
  let project = @bunnia.generate_wechat_project(
    name="Demo",
    route="pages/home/home",
    root~,
  )
  assert_eq(project.files.length(), 7)
  assert_eq(project.route, "pages/home/home")
  assert_true(project.summary.contains("files=7"))
  assert_true(project.total_bytes > project.page.wxml.length())
  assert_true(has_file(project.files, "app.json"))
  assert_true(has_file(project.files, "project.config.json"))
  assert_true(has_file(project.files, "sitemap.json"))
  assert_true(has_file(project.files, "pages/home/home.wxml"))
  assert_true(has_file(project.files, "pages/home/home.wxss"))
  assert_true(has_file(project.files, "pages/home/home.js"))
  assert_true(has_file(project.files, "pages/home/home.json"))
  assert_true(
    file_content(project.files, "app.json").contains("pages/home/home"),
  )
}

///|
test "patch plans keep mini-app updates bounded" {
  let patches = [
    @bunnia.set_string("__bunnia.lastMessage", "open-detail"),
    @bunnia.set_json("scene.markers.marker-a.status", "\"running\""),
  ]
  let plan = @bunnia.plan_patches_with_budget(
    patches,
    @bunnia.patch_budget(max_patches=1, max_patch_bytes=32),
  )
  assert_eq(plan.patches.length(), 2)
  assert_eq(plan.diagnostics.length(), 2)
  assert_true(plan.diagnostics.contains("patch-count-over-budget:2/1"))
  let js = @bunnia.generate_wechat_set_data_call(patches)
  assert_true(js.contains("this.setData"))
  assert_true(js.contains("\"__bunnia.lastMessage\":\"open-detail\""))
  assert_true(js.contains("\"scene.markers.marker-a.status\":\"running\""))
}

///|
fn has_file(files : Array[@bunnia.WechatFile], path : String) -> Bool {
  for item in files {
    if item.path == path {
      return true
    }
  }
  false
}

///|
fn file_content(files : Array[@bunnia.WechatFile], path : String) -> String {
  for item in files {
    if item.path == path {
      return item.content
    }
  }
  ""
}
