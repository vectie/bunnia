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
test "agent feeds and traces can be windowed for long conversations" {
  let feed = @bunnia.windowed_message_feed(
    [
      @bunnia.message(
        id="msg-10",
        actor_id="agent-a",
        thread_id="thread-a",
        text="Visible agent message.",
      ),
      @bunnia.message(
        id="msg-11",
        actor_id="operator",
        thread_id="thread-a",
        text="Visible operator reply.",
      ),
    ],
    total_count=128,
    offset=96,
  )
  let trace = @bunnia.windowed_communication_trace(
    [
      @bunnia.handoff(
        id="handoff-visible",
        thread_id="thread-a",
        from_actor_id="agent-a",
        to_actor_id="operator",
        text="Review the current result.",
        open_message="open-handoff",
      ),
    ],
    total_count=42,
    offset=40,
  )
  let output = @bunnia.generate_wechat_page(
    "Agent Window",
    @bunnia.page([feed, trace]),
  )
  assert_eq(output.plan.windowed_list_count, 2)
  assert_eq(output.plan.list_total_count, 170)
  assert_eq(output.plan.list_visible_count, 3)
  assert_true(output.wxml.contains("bunnia-message-feed-windowed"))
  assert_true(output.wxml.contains("bunnia-communication-trace-windowed"))
  assert_true(output.wxml.contains("data-total-count=\"128\""))
  assert_true(output.wxml.contains("data-visible-start=\"96\""))
  assert_true(output.wxml.contains("data-total-count=\"42\""))
  assert_true(output.plan.event_messages.contains("open-handoff"))
}

///|
test "tool result cards expose artifact and action metadata" {
  let card = @bunnia.tool_result_card(
    id="tool-route",
    tool_name="route-inspector",
    title="Route inspection",
    summary="Route report is ready.",
    artifact_ref="artifact://route-report",
    status=@bunnia.run_waiting_review(),
    open_message="open-tool",
    acknowledge_message="ack-tool",
  )
  let output = @bunnia.generate_wechat_page(
    "Tool Result",
    @bunnia.page([
      @bunnia.windowed_tool_result_card_list([card], total_count=12, offset=8),
    ]),
  )
  assert_eq(output.plan.windowed_list_count, 1)
  assert_eq(output.plan.list_total_count, 12)
  assert_eq(output.plan.list_visible_count, 1)
  assert_true(output.wxml.contains("bunnia-tool-result-card"))
  assert_true(output.wxml.contains("bunnia-tool-result-list-windowed"))
  assert_true(output.wxml.contains("data-tool-result-id=\"tool-route\""))
  assert_true(output.wxml.contains("data-tool-name=\"route-inspector\""))
  assert_true(
    output.wxml.contains("data-artifact-ref=\"artifact://route-report\""),
  )
  assert_true(output.wxml.contains("data-run-status=\"waiting-review\""))
  assert_true(output.wxml.contains("data-bunnia-message=\"open-tool\""))
  assert_true(output.wxml.contains("data-bunnia-message=\"ack-tool\""))
  assert_true(output.plan.event_messages.contains("open-tool"))
  assert_true(output.plan.event_messages.contains("ack-tool"))
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
  assert_eq(plan.deferred_asset_count, 1)
  assert_true(plan.deferred_asset_ids.contains("agent-sprite"))
  assert_eq(plan.diagnostics.length(), 4)
  assert_true(plan.diagnostics.contains("scene-asset-count-over-budget:2/1"))
  assert_true(
    plan.diagnostics.contains("scene-package-bytes-over-budget:2048/1024"),
  )
  assert_true(plan.diagnostics.contains("scene-remote-assets-over-budget:1/0"))
  assert_true(plan.diagnostics.contains("scene-deferred-assets:1"))
  assert_eq(patches.patches.length(), 2)
  assert_true(
    @bunnia.generate_wechat_set_data_call(patches.patches).contains(
      "{kind:\"set\",path:\"scenes.overview.markers.marker-a.status\",value:\"selected\"}",
    ),
  )
  assert_eq(@bunnia.scene_asset_kind_id(@bunnia.scene_asset_sprite()), "sprite")
}

///|
test "scene thread links connect map markers to agent communication cheaply" {
  let scene = @bunnia.scene("ops-map", @bunnia.scene_size(640, 480), [
    @bunnia.layer("regions", 1, [
      @bunnia.marker(
        id="zone-a",
        label="Zone A",
        x=160,
        y=180,
        status="review",
        tap_message="select-zone-a",
      ),
    ]),
  ])
  let link = @bunnia.scene_thread_link(
    id="link-zone-a",
    scene_id="ops-map",
    marker_id="zone-a",
    thread_id="thread-zone-a",
    subject_ref="scene://ops-map/zone-a",
    status="review",
    unread_count=3,
    open_message="open-thread-zone-a",
  )
  let root = @bunnia.page([
    @bunnia.static_scene_with_windowed_threads(
      scene,
      [link],
      total_count=24,
      offset=12,
    ),
  ])
  let output = @bunnia.generate_wechat_page("Agentic Map", root)
  let thread_plan = @bunnia.plan_scene_threads_with_budget(
    scene,
    [link],
    @bunnia.scene_thread_budget(max_visible_links=4, max_unread_total=8),
  )
  let patches = @bunnia.plan_patches([
    @bunnia.select_scene_thread("ops-map", "zone-a", "thread-zone-a"),
    @bunnia.set_scene_thread_unread("ops-map", "thread-zone-a", 0),
    @bunnia.set_scene_thread_status("ops-map", "thread-zone-a", "running"),
    @bunnia.append_scene_thread_link("scenes.ops-map.threadLinks", link),
  ])
  assert_eq(output.plan.windowed_list_count, 1)
  assert_eq(output.plan.list_total_count, 24)
  assert_eq(output.plan.list_visible_count, 1)
  assert_true(output.wxml.contains("bunnia-scene-with-threads"))
  assert_true(output.wxml.contains("bunnia-scene-thread-overlay"))
  assert_true(output.wxml.contains("data-marker-id=\"zone-a\""))
  assert_true(output.wxml.contains("data-thread-id=\"thread-zone-a\""))
  assert_true(
    output.wxml.contains("data-subject-ref=\"scene://ops-map/zone-a\""),
  )
  assert_true(output.wxml.contains("data-unread-count=\"3\""))
  assert_true(output.plan.event_messages.contains("select-zone-a"))
  assert_true(output.plan.event_messages.contains("open-thread-zone-a"))
  assert_eq(thread_plan.total_link_count, 1)
  assert_eq(thread_plan.visible_link_count, 1)
  assert_eq(thread_plan.unread_total, 3)
  assert_eq(thread_plan.orphan_link_count, 0)
  assert_eq(thread_plan.diagnostics.length(), 0)
  assert_true(thread_plan.summary.contains("links=1/1"))
  assert_eq(patches.patches.length(), 4)
  assert_true(
    patches.patches[0].value_json.contains("\"threadId\":\"thread-zone-a\""),
  )
  assert_eq(patches.patches[1].value_json, "0")
  assert_eq(patches.patches[2].value_json, "\"running\"")
  assert_true(patches.patches[3].value_json.contains("\"unreadCount\":3"))
  assert_true(patches.total_estimated_bytes < 520)
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
  let plan = @bunnia.plan_filtered_communications(
    [
      @bunnia.message_event(
        id="comm-message",
        thread_id="thread-route",
        from_actor_id="agent-planner",
        text="Planner opened the route thread.",
      ),
      @bunnia.review_request(
        id="comm-review",
        thread_id="thread-route",
        from_actor_id="agent-planner",
        to_actor_id="operator",
        text="Approve route dispatch?",
        artifact_ref="artifact://route-plan",
      ),
    ],
    @bunnia.communication_filter(thread_id="thread-route"),
    budget=@bunnia.communication_budget(max_visible_count=1),
  )
  assert_eq(plan.filtered_count, 2)
  assert_eq(plan.visible_count, 1)
  assert_eq(plan.unresolved_review_count, 1)
  assert_true(
    plan.diagnostics.contains("communication-visible-over-budget:2/1"),
  )
}

///|
test "review controls disable resolved and failed agent actions" {
  let pending = @bunnia.review_action(
    id="route-review",
    label="Route review",
    approve_message="approve-route",
    reject_message="reject-route",
  )
  let failed = @bunnia.review_action(
    id="route-review-failed",
    label="Route review failed",
    approve_message="approve-failed-route",
    reject_message="reject-failed-route",
    state=@bunnia.review_failed(),
  )
  let output = @bunnia.generate_wechat_page(
    "Review Controls",
    @bunnia.page([
      @bunnia.review_controls(pending),
      @bunnia.review_controls(failed),
    ]),
  )
  let failed_delta = @bunnia.set_review_state_delta(
    "reviews.route.state",
    @bunnia.review_failed(),
  )
  let plan = @bunnia.plan_agent_deltas([failed_delta])
  assert_eq(@bunnia.review_action_enabled(pending), true)
  assert_eq(@bunnia.review_action_enabled(failed), false)
  assert_eq(@bunnia.review_state_id(@bunnia.review_failed()), "failed")
  assert_true(output.wxml.contains("data-review-enabled=\"true\""))
  assert_true(output.wxml.contains("data-review-enabled=\"false\""))
  assert_true(output.wxml.contains("bunnia-review-failed"))
  assert_true(output.wxml.contains("bunnia-review-button-disabled"))
  assert_true(output.wxml.contains("disabled=\"true\""))
  assert_true(output.plan.event_messages.contains("approve-route"))
  assert_true(!output.plan.event_messages.contains("approve-failed-route"))
  assert_eq(plan.patch_plan.patches.length(), 1)
  assert_eq(plan.patch_plan.patches[0].value_json, "\"failed\"")
}

///|
test "surface statuses wrap large panels without changing their model" {
  let scene = @bunnia.scene("status-map", @bunnia.scene_size(320, 240), [
    @bunnia.layer("actors", 1, [
      @bunnia.marker(
        id="actor-a",
        label="Actor A",
        x=80,
        y=80,
        status="running",
      ),
    ]),
  ])
  let status = @bunnia.surface_error(
    label="Snapshot failed",
    detail="Tap to retry without rebuilding the scene.",
    action_message="retry-snapshot",
  )
  let badge = @bunnia.surface_status_badge(
    @bunnia.surface_stale(label="Stale", detail="Last update is old."),
  )
  let output = @bunnia.generate_wechat_page(
    "Surface Status",
    @bunnia.page([
      @bunnia.surface_status_overlay(status, @bunnia.static_scene_view(scene)),
      badge,
    ]),
  )
  assert_eq(@bunnia.surface_status_kind_id(status.kind), "error")
  assert_eq(
    @bunnia.surface_status_kind_id(@bunnia.surface_status_degraded()),
    "degraded",
  )
  assert_true(output.plan.event_messages.contains("retry-snapshot"))
  assert_true(output.wxml.contains("bunnia-status-surface"))
  assert_true(output.wxml.contains("bunnia-status-badge"))
  assert_true(output.wxml.contains("data-surface-status=\"error\""))
  assert_true(output.wxml.contains("data-action-message=\"retry-snapshot\""))
  assert_true(output.wxml.contains("bunnia-surface-state-stale"))
  assert_true(output.wxss.contains(".bunnia-status-surface"))
}

///|
test "scene visual quality plans expose map readiness diagnostics" {
  let scene = @bunnia.scene("weak-map", @bunnia.scene_size(160, 120), [
    @bunnia.layer("markers", 1, [
      @bunnia.marker(id="actor-a", label="Actor A", x=80, y=80),
    ]),
  ])
  let plan = @bunnia.plan_scene_visual_quality(scene)
  assert_eq(plan.marker_count, 1)
  assert_eq(plan.markers_without_status_count, 1)
  assert_eq(plan.markers_without_tap_count, 1)
  assert_eq(plan.markers_without_asset_ref_count, 1)
  assert_eq(plan.degraded, true)
  assert_true(plan.diagnostics.contains("scene-width-under-min:160/320"))
  assert_true(plan.diagnostics.contains("scene-height-under-min:120/240"))
  assert_true(plan.diagnostics.contains("scene-markers-without-status:1/0"))
  assert_true(plan.summary.contains("degraded=true"))
}

///|
test "scene surface planning keeps map rendering capability explicit" {
  let scene = @bunnia.scene("ops-map", @bunnia.scene_size(640, 480), [
    @bunnia.layer("markers", 1, [
      @bunnia.marker(
        id="actor-a",
        label="Actor A",
        x=80,
        y=80,
        status="running",
        tap_message="open-actor-a",
      ),
    ]),
  ])
  let constrained = @bunnia.platform_adapter(
    platform=@bunnia.wechat(),
    id="wechat-lite",
    page_component="page",
    tap_event="bindtap",
    supports_canvas=false,
  )
  let plan = @bunnia.plan_scene_surface(
    scene,
    constrained,
    preference=@bunnia.prefer_canvas_surface(),
  )
  assert_true(plan.requested_mode == @bunnia.scene_mode_canvas_surface())
  assert_true(plan.mode == @bunnia.scene_mode_static_markup())
  assert_eq(plan.fallback, true)
  assert_eq(@bunnia.scene_surface_preference_id(plan.preference), "canvas")
  assert_true(plan.diagnostics.contains("scene-canvas-unsupported:wechat-lite"))
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
test "render plans report canvas capability pressure through adapters" {
  let root = @bunnia.page([
    @bunnia.canvas("surface-canvas"),
    @bunnia.view([@bunnia.canvas("overlay-canvas")]),
  ])
  let constrained = @bunnia.platform_adapter(
    platform=@bunnia.wechat(),
    id="wechat-no-canvas",
    page_component="page",
    tap_event="bindtap",
    supports_canvas=false,
  )
  let supported = @bunnia.plan(root, @bunnia.wechat())
  let unsupported = @bunnia.plan_for_adapter(root, constrained)
  assert_eq(supported.canvas_count, 2)
  assert_eq(supported.unsupported_canvas_count, 0)
  assert_eq(unsupported.canvas_count, 2)
  assert_eq(unsupported.unsupported_canvas_count, 2)
  assert_true(
    unsupported.diagnostics.contains("canvas-unsupported:wechat-no-canvas:2"),
  )
  assert_true(unsupported.summary.contains("unsupported_canvas=2"))
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
  assert_true(output.js.contains("path: '__bunnia.lastMessage'"))
  assert_true(output.js.contains("const __bunniaEventPatches"))
  assert_true(output.js.contains("__bunniaApplyPatches"))
  assert_true(
    output.js.contains(
      "\"open-detail\":[{kind:\"set\",path:\"counter\",value:1}]",
    ),
  )
  assert_true(output.js.contains("...({\"counter\":0})"))
  assert_true(output.js.contains("path: '__bunnia.handledEvents'"))
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
test "windowed lists expose total count without rendering every row" {
  let root = @bunnia.page([
    @bunnia.windowed_list(
      ["agent", "map", "review"],
      total_count=120,
      offset=24,
      render=render_tag,
    ),
  ])
  let output = @bunnia.generate_wechat_page("Windowed", root)
  assert_eq(output.plan.windowed_list_count, 1)
  assert_eq(output.plan.list_total_count, 120)
  assert_eq(output.plan.list_visible_count, 3)
  assert_true(output.plan.component_kinds.contains("windowed-list"))
  assert_true(output.wxml.contains("<view"))
  assert_true(output.wxml.contains("bunnia-list-windowed"))
  assert_true(output.wxml.contains("data-total-count=\"120\""))
  assert_true(output.wxml.contains("data-visible-start=\"24\""))
  assert_true(output.wxml.contains("data-visible-count=\"3\""))
  assert_true(output.wxss.contains(".bunnia-list-windowed"))
}

///|
test "render plans diagnose unkeyed repeated surface rows" {
  let keyed = @bunnia.plan(
    @bunnia.page([
      @bunnia.list(["agent", "map"], render_tag),
      @bunnia.windowed_message_feed(
        [
          @bunnia.message(
            id="msg-keyed",
            actor_id="agent",
            thread_id="thread-a",
            text="Keyed row.",
          ),
        ],
        total_count=4,
      ),
    ]),
    @bunnia.wechat(),
  )
  let unkeyed = @bunnia.plan(
    @bunnia.page([
      @bunnia.list(["agent", "map"], value => {
        @bunnia.view([@bunnia.text(value)])
      }),
    ]),
    @bunnia.wechat(),
  )
  let duplicate = @bunnia.plan(
    @bunnia.page([
      @bunnia.list(["agent", "map"], value => {
        @bunnia.keyed("same-row", @bunnia.view([@bunnia.text(value)]))
      }),
    ]),
    @bunnia.wechat(),
  )
  assert_eq(keyed.unkeyed_list_child_count, 0)
  assert_eq(keyed.unwindowed_list_child_count, 2)
  assert_eq(keyed.duplicate_list_key_count, 0)
  assert_eq(keyed.diagnostics.length(), 0)
  assert_true(keyed.summary.contains("unwindowed_list_children=2"))
  assert_eq(unkeyed.unkeyed_list_child_count, 2)
  assert_eq(unkeyed.unwindowed_list_child_count, 2)
  assert_eq(unkeyed.duplicate_list_key_count, 0)
  assert_true(unkeyed.diagnostics.contains("list-child-missing-key:2"))
  assert_true(unkeyed.summary.contains("unkeyed_list_children=2"))
  assert_eq(duplicate.unkeyed_list_child_count, 0)
  assert_eq(duplicate.unwindowed_list_child_count, 2)
  assert_eq(duplicate.duplicate_list_key_count, 1)
  assert_true(duplicate.diagnostics.contains("list-child-duplicate-key:1"))
  assert_true(duplicate.summary.contains("duplicate_list_keys=1"))
}

///|
test "render plans diagnose large non-windowed repeated surfaces" {
  let plan = @bunnia.plan_with_budget(
    @bunnia.page([@bunnia.list(["agent", "map", "review"], render_tag)]),
    @bunnia.wechat(),
    @bunnia.render_budget(
      max_nodes=32,
      max_depth=8,
      max_events=8,
      max_initial_data_bytes=1024,
      max_unwindowed_list_children=2,
    ),
  )
  assert_eq(plan.unwindowed_list_child_count, 3)
  assert_eq(plan.unkeyed_list_child_count, 0)
  assert_eq(plan.duplicate_list_key_count, 0)
  assert_true(
    plan.diagnostics.contains("unwindowed-list-children-over-budget:3/2"),
  )
  assert_true(plan.summary.contains("unwindowed_list_children=3"))
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
  let wechat_plan = @bunnia.plan_effects_for_platform(effects, @bunnia.wechat())
  let tiktok_plan = @bunnia.plan_effects_for_platform(effects, @bunnia.tiktok())
  let no_stream_adapter = @bunnia.platform_adapter(
    platform=@bunnia.wechat(),
    id="wechat-no-stream",
    page_component="page",
    tap_event="bindtap",
    supports_stream=false,
  )
  let no_stream_plan = @bunnia.plan_effects_for_adapter(
    effects, no_stream_adapter,
  )
  assert_eq(wechat_plan.effect_count, 5)
  assert_eq(wechat_plan.cloud_function_count, 1)
  assert_eq(wechat_plan.stream_effect_count, 1)
  assert_eq(wechat_plan.diagnostics.length(), 0)
  assert_eq(wechat_plan.adapter.supports_stream, true)
  assert_eq(tiktok_plan.adapter.supports_cloud, false)
  assert_true(
    tiktok_plan.diagnostics.contains(
      "effect-cloud-function-unsupported:tiktok:1",
    ),
  )
  assert_true(tiktok_plan.summary.contains("platform=tiktok"))
  assert_eq(no_stream_plan.stream_effect_count, 1)
  assert_true(
    no_stream_plan.diagnostics.contains(
      "effect-stream-unsupported:wechat-no-stream:1",
    ),
  )
  assert_true(no_stream_plan.summary.contains("adapter=wechat-no-stream"))
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
  let effect_plan = @bunnia.plan_backend_effects_for_platform(
    contract,
    @bunnia.wechat(),
  )
  let no_stream_effect_plan = @bunnia.plan_backend_effects_for_adapter(
    contract,
    @bunnia.platform_adapter(
      platform=@bunnia.wechat(),
      id="wechat-request-only",
      page_component="page",
      tap_event="bindtap",
      supports_stream=false,
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
  assert_eq(effect_plan.effect_count, 6)
  assert_eq(effect_plan.stream_effect_count, 1)
  assert_eq(effect_plan.cloud_function_count, 0)
  assert_eq(effect_plan.diagnostics.length(), 0)
  assert_eq(no_stream_effect_plan.effect_count, 6)
  assert_true(
    no_stream_effect_plan.diagnostics.contains(
      "effect-stream-unsupported:wechat-request-only:1",
    ),
  )
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
test "snapshot delta plans expose section updates through facade" {
  let deltas = [
    @bunnia.set_snapshot_section_delta(
      "town", "buildings", "[{\"id\":\"hall\"}]",
    ),
    @bunnia.append_snapshot_item_delta(
      "town", "messages", "msg-1", "{\"id\":\"msg-1\",\"text\":\"ready\"}",
    ),
  ]
  let plan = @bunnia.plan_snapshot_deltas(deltas)
  assert_eq(plan.section_update_count, 1)
  assert_eq(plan.append_item_count, 1)
  assert_eq(plan.full_snapshot_count, 0)
  assert_eq(plan.diagnostics.length(), 0)
  assert_eq(plan.patch_plan.patches[0].path, "snapshots.town.buildings")
  assert_eq(@bunnia.snapshot_delta_kind_id(deltas[1].kind), "append-item")
  assert_true(
    @bunnia.generate_wechat_set_data_call(plan.patch_plan.patches).contains(
      "snapshots.town.messages",
    ),
  )
}

///|
test "wechat project generator emits deterministic mini-program files" {
  let root = @bunnia.page([
    @bunnia.view([@bunnia.text("Demo"), @bunnia.button("Open", "open-detail")]),
  ])
  let runtime = @bunnia.wechat_runtime(event_patches=[
    @bunnia.wechat_event_patch("open-detail", [
      @bunnia.set_string("__bunnia.lastMessage", "open-detail"),
    ]),
  ])
  let project = @bunnia.generate_wechat_project_with_runtime(
    name="Demo",
    route="pages/home/home",
    root~,
    runtime~,
  )
  assert_eq(project.files.length(), 8)
  assert_eq(project.route, "pages/home/home")
  assert_eq(project.page_count, 1)
  assert_eq(project.pages.length(), 1)
  assert_true(project.summary.contains("files=8"))
  assert_true(project.report.summary.contains("pages=1"))
  assert_true(project.total_bytes > project.page.wxml.length())
  assert_true(project.manifest.summary.contains("app_files=7"))
  assert_eq(project.manifest.page_count, 1)
  assert_eq(project.manifest.app_file_count, 7)
  assert_true(project.manifest.app_total_bytes < project.total_bytes)
  assert_true(has_file(project.files, "app.json"))
  assert_true(has_file(project.files, "project.config.json"))
  assert_true(has_file(project.files, "sitemap.json"))
  assert_true(has_file(project.files, "bunnia.manifest.json"))
  assert_true(has_file(project.files, "pages/home/home.wxml"))
  assert_true(has_file(project.files, "pages/home/home.wxss"))
  assert_true(has_file(project.files, "pages/home/home.js"))
  assert_true(has_file(project.files, "pages/home/home.json"))
  assert_eq(project.report.file_count, 8)
  assert_eq(project.report.page_count, 1)
  assert_eq(project.report.missing_event_patch_count, 0)
  assert_eq(project.report.orphan_event_patch_count, 0)
  assert_eq(project.report.total_bytes, project.total_bytes)
  assert_true(project.report.wxml_bytes > 0)
  assert_true(project.report.wxss_bytes > 0)
  assert_true(project.report.js_bytes > 0)
  assert_eq(project.report.diagnostics.length(), 0)
  assert_true(
    file_content(project.files, "app.json").contains("pages/home/home"),
  )
  assert_true(
    file_content(project.files, "bunnia.manifest.json").contains(
      "\"entryRoute\": \"pages/home/home\"",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.manifest.json").contains(
      "\"path\":\"pages/home/home.wxml\"",
    ),
  )
}

///|
test "wechat project generator supports multiple app routes" {
  let home = @bunnia.wechat_project_page(
    name="Home",
    route="pages/home/home",
    root=@bunnia.page([
      @bunnia.view([
        @bunnia.text("Home"),
        @bunnia.button("Open Chat", "open-chat"),
      ]),
    ]),
    runtime=@bunnia.wechat_runtime(initial_data_json="{\"home\":true}", event_patches=[
      @bunnia.wechat_event_patch("open-chat", [
        @bunnia.set_string("nav.intent", "chat"),
      ]),
    ]),
  )
  let chat = @bunnia.wechat_project_page(
    name="Chat",
    route="pages/chat/index",
    root=@bunnia.page([
      @bunnia.windowed_message_feed(
        [
          @bunnia.message(
            id="msg-1",
            actor_id="agent",
            thread_id="thread-main",
            text="Ready.",
          ),
        ],
        total_count=24,
        offset=23,
      ),
    ]),
    runtime=@bunnia.wechat_runtime(initial_data_json="{\"chat\":true}"),
  )
  let project = @bunnia.generate_wechat_project_from_pages(name="Multi Route", pages=[
    home, chat,
  ])
  let report = @bunnia.report_wechat_project_with_budget(
    project,
    @bunnia.default_wechat_runtime(),
    @bunnia.wechat_build_budget(
      max_pages=1,
      max_files=16,
      max_total_bytes=262144,
      max_wxml_bytes=65536,
      max_wxss_bytes=65536,
      max_js_bytes=65536,
      max_initial_data_bytes=65536,
      max_event_patch_bytes=8192,
      max_page_first_screen_bytes=98304,
      max_page_update_payload_bytes=8192,
    ),
  )
  assert_eq(project.page_count, 2)
  assert_eq(project.pages.length(), 2)
  assert_eq(project.route, "pages/home/home")
  assert_eq(project.files.length(), 12)
  assert_true(project.summary.contains("pages=2"))
  assert_eq(project.manifest.app_file_count, 11)
  assert_eq(project.manifest.pages.length(), 2)
  assert_eq(project.manifest.pages[0].route, "pages/home/home")
  assert_eq(project.manifest.pages[1].route, "pages/chat/index")
  assert_true(project.manifest.pages[0].event_patch_bytes > 0)
  assert_eq(project.manifest.pages[0].windowed_list_count, 0)
  assert_eq(project.manifest.pages[1].windowed_list_count, 1)
  assert_eq(project.manifest.pages[1].list_total_count, 24)
  assert_eq(project.manifest.pages[1].list_visible_count, 1)
  assert_eq(project.manifest.pages[1].unwindowed_list_child_count, 0)
  assert_eq(project.manifest.pages[1].unkeyed_list_child_count, 0)
  assert_eq(project.manifest.pages[1].duplicate_list_key_count, 0)
  assert_eq(
    project.manifest.pages[1].first_screen_bytes,
    project.manifest.pages[1].file_bytes +
    project.manifest.pages[1].initial_data_bytes,
  )
  assert_eq(
    project.manifest.pages[1].update_payload_bytes,
    project.manifest.pages[1].event_patch_bytes,
  )
  assert_eq(project.manifest.pages[1].render_diagnostics.length(), 0)
  assert_true(has_file(project.files, "pages/chat/index.wxml"))
  assert_true(
    file_content(project.files, "app.json").contains("pages/chat/index"),
  )
  assert_true(
    file_content(project.files, "bunnia.manifest.json").contains(
      "\"route\":\"pages/chat/index\"",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.manifest.json").contains(
      "\"unwindowedListChildren\":0",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.manifest.json").contains(
      "\"unkeyedListChildren\":0",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.manifest.json").contains(
      "\"duplicateListKeys\":0",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.manifest.json").contains(
      "\"firstScreenBytes\":",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.manifest.json").contains(
      "\"updatePayloadBytes\":",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.manifest.json").contains(
      "\"renderDiagnostics\":[]",
    ),
  )
  assert_eq(project.report.page_count, 2)
  assert_eq(project.report.initial_data_bytes, 26)
  assert_true(project.report.event_patch_bytes > 0)
  assert_true(report.diagnostics.contains("wechat-page-count-over-budget:2/1"))
}

///|
test "wechat manifest records route render diagnostics" {
  let project = @bunnia.generate_wechat_project(
    name="Diagnostics",
    route="pages/diagnostics/index",
    root=@bunnia.page([
      @bunnia.list(["agent", "map"], value => {
        @bunnia.view([@bunnia.text(value)])
      }),
    ]),
  )
  assert_eq(project.manifest.pages.length(), 1)
  assert_eq(project.manifest.pages[0].route, "pages/diagnostics/index")
  assert_eq(project.manifest.pages[0].unwindowed_list_child_count, 2)
  assert_eq(project.manifest.pages[0].unkeyed_list_child_count, 2)
  assert_true(
    project.manifest.pages[0].render_diagnostics.contains(
      "list-child-missing-key:2",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.manifest.json").contains(
      "\"unwindowedListChildren\":2",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.manifest.json").contains(
      "\"renderDiagnostics\":[\"list-child-missing-key:2\"]",
    ),
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
      max_pages=1,
      max_files=1,
      max_total_bytes=128,
      max_wxml_bytes=8,
      max_wxss_bytes=8,
      max_js_bytes=8,
      max_initial_data_bytes=4,
      max_event_patch_bytes=4,
      max_page_first_screen_bytes=4,
      max_page_update_payload_bytes=4,
    ),
  )
  assert_eq(report.file_count, 8)
  assert_eq(report.initial_data_bytes, 13)
  assert_true(report.event_patch_bytes > 4)
  assert_true(report.max_page_first_screen_bytes > 4)
  assert_eq(report.max_page_update_payload_bytes, report.event_patch_bytes)
  assert_eq(report.diagnostics.length(), 9)
  assert_true(report.diagnostics.contains("wechat-file-count-over-budget:8/1"))
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
  assert_true(
    report.diagnostics.contains(
      "wechat-page-first-screen-bytes-over-budget:pages/index/index:\{report.max_page_first_screen_bytes}/4",
    ),
  )
  assert_true(
    report.diagnostics.contains(
      "wechat-page-update-payload-bytes-over-budget:pages/index/index:\{report.max_page_update_payload_bytes}/4",
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
  assert_true(js.contains("__bunniaApplyPatches(this"))
  assert_true(
    js.contains(
      "{kind:\"set\",path:\"__bunnia.lastMessage\",value:\"open-detail\"}",
    ),
  )
  assert_true(
    js.contains(
      "{kind:\"set\",path:\"scene.markers.marker-a.status\",value:\"running\"}",
    ),
  )
}

///|
test "agent deltas lower chat and review updates to small patch plans" {
  let deltas = [
    @bunnia.append_message_delta(
      "threads.thread-a.messages",
      @bunnia.message(
        id="msg-stream",
        actor_id="agent-a",
        thread_id="thread-a",
        text="Starting stream",
        status=@bunnia.run_running(),
      ),
    ),
    @bunnia.append_stream_chunk_delta(
      "streams.run-a.chunks", "chunk-1", "partial",
    ),
    @bunnia.set_stream_chunk_delta(
      "streams.run-a.chunksById", "chunk-1", "latest",
    ),
    @bunnia.set_review_state_delta(
      "reviews.route.state",
      @bunnia.review_approved(),
    ),
  ]
  let plan = @bunnia.plan_agent_deltas(deltas)
  assert_eq(plan.deltas.length(), 4)
  assert_eq(plan.patch_plan.patches.length(), 4)
  assert_eq(plan.duplicate_stream_chunk_count, 0)
  assert_true(plan.summary.contains("deltas=4"))
  assert_eq(@bunnia.agent_delta_kind_id(deltas[1].kind), "append-stream-chunk")
  assert_eq(@bunnia.agent_delta_kind_id(deltas[2].kind), "set-stream-chunk")
  assert_true(
    @bunnia.generate_wechat_set_data_call(plan.patch_plan.patches).contains(
      "{kind:\"set\",path:\"reviews.route.state\",value:\"approved\"}",
    ),
  )
}

///|
test "scaffold project exposes starter files through facade" {
  let scaffold = @bunnia.scaffold_project(
    name="mini_agent",
    module_name="local/mini_agent",
  )
  assert_eq(scaffold.files.length(), 4)
  assert_eq(scaffold.module_name, "local/mini_agent")
  assert_true(scaffold.summary.contains("Bunnia scaffold"))
  assert_true(
    scaffold_file_content(scaffold.files, "app.mbt").contains(
      "windowed_message_feed",
    ),
  )
  assert_true(
    scaffold_file_content(scaffold.files, "app.mbt").contains(
      "surface_status_overlay",
    ),
  )
  assert_true(
    scaffold_file_content(scaffold.files, "app.mbt").contains("render_plan"),
  )
  assert_true(
    scaffold_file_content(scaffold.files, "moon.pkg").contains(
      "\"vectie/bunnia\"",
    ),
  )
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
fn scaffold_file_content(
  files : Array[@bunnia.ScaffoldFile],
  path : String,
) -> String {
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
