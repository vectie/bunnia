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
test "scene assets render sprites and report asset budgets" {
  let assets = [
    @bunnia.sprite_asset("agent-sprite", "/assets/agent.png", 2048),
    @bunnia.remote_image_asset(
      "remote-tile", "https://cdn.example.test/tile.png",
    ),
  ]
  let scene = @bunnia.scene(
    "overview",
    @bunnia.scene_size(640, 480),
    [
      @bunnia.layer("actors", 10, [
        @bunnia.marker(
          id="marker-a",
          label="Agent A",
          x=120,
          y=180,
          status="running",
          tap_message="select-marker-a",
          asset_ref="agent-sprite",
        ),
      ]),
    ],
    assets~,
  )
  let output = @bunnia.generate_wechat_page(
    "Scene Assets",
    @bunnia.page([@bunnia.static_scene_view(scene)]),
  )
  let plan = @bunnia.plan_scene_assets_with_budget(
    assets,
    @bunnia.scene_asset_budget(
      max_assets=1,
      max_package_bytes=1024,
      max_remote_assets=0,
    ),
  )
  let patches = @bunnia.plan_patches([
    @bunnia.select_scene_marker("overview", "marker-a"),
    @bunnia.set_scene_marker_status("overview", "marker-a", "selected"),
  ])
  assert_true(output.wxml.contains("data-scene-assets=\"2\""))
  assert_true(output.wxml.contains("class=\"bunnia-scene-sprite\""))
  assert_true(output.wxml.contains("src=\"/assets/agent.png\""))
  assert_true(output.wxml.contains("data-asset-ref=\"agent-sprite\""))
  assert_true(output.wxss.contains(".bunnia-scene-sprite"))
  assert_eq(plan.package_bytes, 2048)
  assert_eq(plan.remote_assets, 1)
  assert_eq(plan.diagnostics.length(), 3)
  assert_true(plan.diagnostics.contains("scene-asset-count-over-budget:2/1"))
  assert_true(
    plan.diagnostics.contains("scene-package-bytes-over-budget:2048/1024"),
  )
  assert_true(plan.diagnostics.contains("scene-remote-assets-over-budget:1/0"))
  assert_eq(patches.patches.length(), 2)
  assert_true(
    @bunnia.generate_wechat_set_data_call(patches.patches).contains(
      "\"scenes.overview.markers.marker-a.status\":\"selected\"",
    ),
  )
  assert_eq(@bunnia.scene_asset_kind_id(@bunnia.scene_asset_sprite()), "sprite")
}

///|
test "communication trace renders structured agent interactions" {
  let thread = @bunnia.thread(
    id="thread-route",
    title="Route review",
    owner_actor_id="agent-planner",
    subject_ref="scene://ops-map/zone-b",
    status=@bunnia.run_waiting_review(),
  )
  let trace = @bunnia.communication_trace([
    @bunnia.message_event(
      id="comm-message",
      thread_id="thread-route",
      from_actor_id="agent-planner",
      text="Planner opened the route thread.",
    ),
    @bunnia.broadcast(
      id="comm-broadcast",
      thread_id="thread-route",
      from_actor_id="agent-planner",
      text="Planner published a route update.",
    ),
    @bunnia.handoff(
      id="comm-handoff",
      thread_id="thread-route",
      from_actor_id="agent-planner",
      to_actor_id="operator",
      text="Operator review required.",
      open_message="open-review",
    ),
    @bunnia.review_request(
      id="comm-review",
      thread_id="thread-route",
      from_actor_id="agent-planner",
      to_actor_id="operator",
      text="Approve route dispatch?",
      artifact_ref="artifact://route-plan",
    ),
    @bunnia.tool_result(
      id="comm-tool",
      thread_id="thread-route",
      from_actor_id="agent-planner",
      text="Route plan generated.",
      artifact_ref="artifact://route-plan",
    ),
    @bunnia.recovery_notice(
      id="comm-recovery",
      thread_id="thread-route",
      from_actor_id="system",
      text="Retry required after stale route data.",
    ),
  ])
  let output = @bunnia.generate_wechat_page(
    "Communication",
    @bunnia.page([@bunnia.thread_card(thread), trace]),
  )
  assert_true(output.wxml.contains("bunnia-thread bunnia-run-waiting-review"))
  assert_true(
    output.wxml.contains("data-subject-ref=\"scene://ops-map/zone-b\""),
  )
  assert_true(output.wxml.contains("bunnia-communication-trace"))
  assert_true(output.wxml.contains("bunnia-communication-message"))
  assert_true(output.wxml.contains("bunnia-communication-handoff"))
  assert_true(output.wxml.contains("bunnia-communication-recovery-notice"))
  assert_true(
    output.wxml.contains("data-communication-kind=\"review-request\""),
  )
  assert_true(output.wxml.contains("data-to-actor-id=\"operator\""))
  assert_true(
    output.wxml.contains("data-artifact-ref=\"artifact://route-plan\""),
  )
  assert_true(output.wxml.contains("data-bunnia-message=\"open-review\""))
  assert_true(output.plan.event_messages.contains("open-review"))
  assert_eq(
    @bunnia.communication_kind_id(@bunnia.communication_tool_result()),
    "tool-result",
  )
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
  let runtime = @bunnia.wechat_runtime(initial_data_json="{\"counter\":0}", event_patches=[
    @bunnia.wechat_event_patch("open-detail", [@bunnia.set_json("counter", "1")]),
  ])
  let output = @bunnia.generate_wechat_page_with_runtime("Demo", root, runtime)
  assert_true(output.wxml.contains("bindtap=\"__bunniaEvent\""))
  assert_true(output.wxml.contains("data-bunnia-message=\"open-detail\""))
  assert_true(output.js.contains("\"__bunnia.lastMessage\""))
  assert_true(output.js.contains("const __bunniaEventPatches"))
  assert_true(output.js.contains("\"open-detail\":{\"counter\":1}"))
  assert_true(output.js.contains("...({\"counter\":0})"))
  assert_true(output.js.contains("\"__bunnia.handledEvents\""))
  assert_true(output.json.contains("navigationBarTitleText"))
  assert_eq(output.plan.node_count, 5)
}

///|
test "program model updates through messages and effects" {
  let app = @bunnia.program(
    id="counter",
    model=0,
    view=counter_view,
    update=counter_update,
  )
  let next = @bunnia.apply(app, "inc")
  let root = @bunnia.current_view(next)
  let output = @bunnia.generate_wechat_page("Counter", root)
  assert_eq(next.model, 1)
  assert_eq(next.effects.length(), 1)
  assert_true(output.wxml.contains("Count 1"))
  assert_true(output.wxml.contains("data-bunnia-message=\"inc\""))
}

///|
test "form input and list controls lower to mini-app events" {
  let root = @bunnia.page([
    @bunnia.form("save-profile", [
      @bunnia.input(
        name="displayName",
        value="Bunnia",
        input_message="edit-name",
      ),
      @bunnia.list(["agent", "map"], render_tag),
    ]),
  ])
  let output = @bunnia.generate_wechat_page("Form", root)
  assert_true(output.wxml.contains("<form"))
  assert_true(output.wxml.contains("bindsubmit=\"__bunniaEvent\""))
  assert_true(output.wxml.contains("bindinput=\"__bunniaEvent\""))
  assert_true(output.wxml.contains("data-bunnia-message=\"edit-name\""))
  assert_true(output.wxml.contains("class=\"bunnia-list\""))
  assert_true(output.plan.event_messages.contains("save-profile"))
  assert_true(output.plan.event_messages.contains("edit-name"))
}

///|
test "effect constructors cover mini-app backend capabilities" {
  let effects = [
    @bunnia.storage("save-draft", "storage:draft", "draft"),
    @bunnia.login("login", "wechat-login"),
    @bunnia.share("share-route", "route-card"),
    @bunnia.cloud_function("refresh", "refreshSnapshot", "snapshot"),
    @bunnia.stream("agent-stream", "/agent/stream", "thread-a"),
  ]
  assert_eq(effects.length(), 5)
  assert_eq(effects[0].payload_key, "draft")
  assert_eq(effects[4].target, "/agent/stream")
  assert_true(@bunnia.effect_chip(effects[3]).text == "")
}

///|
test "backend contracts plan request and streaming effects" {
  let endpoints = [
    @bunnia.snapshot_load_endpoint("load-snapshot", "/snapshot", "snapshot"),
    @bunnia.operator_submit_endpoint(
      "submit-operator", "/operator/submit", "operatorRequest", "operatorResult",
    ),
    @bunnia.agent_message_endpoint(
      "send-agent-message", "/agent/message", "message", "messageResult",
    ),
    @bunnia.agent_stream_endpoint(
      "stream-agent-status", "/agent/status", "thread", "agentStatus",
    ),
    @bunnia.review_decision_endpoint(
      "review-decision", "/review/decision", "review", "reviewResult",
    ),
    @bunnia.tool_ack_endpoint("ack-tool", "/tool/ack", "toolResult"),
  ]
  let contract = @bunnia.backend_contract(
    id="agent-backend",
    base_url_key="backendBaseUrl",
    endpoints~,
  )
  let plan = @bunnia.plan_backend_contract_with_budget(
    contract,
    @bunnia.backend_budget(
      max_endpoints=3,
      max_streaming=0,
      max_review_required=1,
    ),
  )
  let stream_effect = @bunnia.endpoint_effect(endpoints[3])
  let patches = @bunnia.plan_patches([
    @bunnia.backend_state_patch(
      "stream-agent-status",
      @bunnia.backend_state_loading(),
    ),
    @bunnia.backend_error_patch("stream-agent-status", "timeout"),
    @bunnia.backend_response_patch("load-snapshot", "{\"ok\":true}"),
  ])
  let adapter = @bunnia.generate_wechat_request_adapter(contract)
  assert_eq(plan.endpoint_count, 6)
  assert_eq(plan.streaming_count, 1)
  assert_eq(plan.review_required_count, 2)
  assert_eq(plan.diagnostics.length(), 3)
  assert_true(
    plan.diagnostics.contains("backend-endpoint-count-over-budget:6/3"),
  )
  assert_true(
    plan.diagnostics.contains("backend-streaming-count-over-budget:1/0"),
  )
  assert_true(plan.diagnostics.contains("backend-review-count-over-budget:2/1"))
  assert_eq(@bunnia.effect_kind_id(stream_effect.kind), "stream")
  assert_eq(stream_effect.target, "/agent/status")
  assert_eq(stream_effect.message, "stream-agent-status")
  assert_true(patches.total_estimated_bytes < 160)
  assert_true(adapter.contains("wx.request"))
  assert_true(adapter.contains("baseUrlKey:\"backendBaseUrl\""))
  assert_true(adapter.contains("\"stream-agent-status\""))
  assert_true(adapter.contains("streaming:true"))
  assert_true(adapter.contains("requiresReview:true"))
  assert_true(!adapter.contains("secret"))
  assert_eq(
    @bunnia.backend_endpoint_kind_id(@bunnia.endpoint_review_decision()),
    "review-decision",
  )
  assert_eq(@bunnia.http_method_id(@bunnia.http_post()), "POST")
  assert_eq(
    @bunnia.backend_state_id(@bunnia.backend_state_malformed()),
    "malformed",
  )
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
  assert_eq(project.report.file_count, 7)
  assert_eq(project.report.total_bytes, project.total_bytes)
  assert_true(project.report.wxml_bytes > 0)
  assert_true(project.report.wxss_bytes > 0)
  assert_true(project.report.js_bytes > 0)
  assert_eq(project.report.diagnostics.length(), 0)
  assert_true(
    file_content(project.files, "app.json").contains("pages/home/home"),
  )
}

///|
test "wechat build reports catch generated-output budget regressions" {
  let root = @bunnia.page([
    @bunnia.view([@bunnia.text("Demo"), @bunnia.button("Open", "open-detail")]),
  ])
  let runtime = @bunnia.wechat_runtime(initial_data_json="{\"counter\":0}", event_patches=[
    @bunnia.wechat_event_patch("open-detail", [
      @bunnia.set_json("counter", "1"),
      @bunnia.set_string("backend.open-detail.state", "ready"),
    ]),
  ])
  let project = @bunnia.generate_wechat_project_with_runtime(
    name="Demo",
    root~,
    runtime~,
  )
  let report = @bunnia.report_wechat_project_with_budget(
    project,
    runtime,
    @bunnia.wechat_build_budget(
      max_files=1,
      max_total_bytes=128,
      max_wxml_bytes=8,
      max_wxss_bytes=8,
      max_js_bytes=8,
      max_initial_data_bytes=4,
      max_event_patch_bytes=4,
    ),
  )
  assert_eq(report.file_count, 7)
  assert_eq(report.initial_data_bytes, 13)
  assert_true(report.event_patch_bytes > 4)
  assert_eq(report.diagnostics.length(), 7)
  assert_true(report.diagnostics.contains("wechat-file-count-over-budget:7/1"))
  assert_true(
    report.diagnostics.contains(
      "wechat-total-bytes-over-budget:\{report.total_bytes}/128",
    ),
  )
  assert_true(
    report.diagnostics.contains("wechat-initial-data-bytes-over-budget:13/4"),
  )
  assert_true(
    report.diagnostics.contains(
      "wechat-event-patch-bytes-over-budget:\{report.event_patch_bytes}/4",
    ),
  )
  assert_true(project.report.summary.contains("Bunnia WeChat build report"))
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

///|
fn counter_view(count : Int) -> @bunnia.Node {
  @bunnia.page([
    @bunnia.view([
      @bunnia.text("Count \{count}"),
      @bunnia.button("Increment", "inc"),
    ]),
  ])
}

///|
fn counter_update(count : Int, message : String) -> @bunnia.Step[Int] {
  if message == "inc" {
    @bunnia.step(
      model=count + 1,
      effects=[@bunnia.request("sync-counter", "/counter", "count")],
      patches=[@bunnia.set_json("counter.value", (count + 1).to_string())],
    )
  } else {
    @bunnia.step(model=count)
  }
}

///|
fn render_tag(value : String) -> @bunnia.Node {
  @bunnia.keyed(
    value,
    @bunnia.view_with_attrs([@bunnia.class_name("bunnia-row")], [
      @bunnia.text(value),
    ]),
  )
}
