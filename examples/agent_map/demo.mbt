///|
pub fn demo_view() -> @bunnia.Node {
  let feed = @bunnia.message_feed([
    @bunnia.message(
      id="msg-agent-start",
      actor_id="agent-planner",
      thread_id="thread-overview",
      text="Planner is checking the active scene.",
      artifact_ref="artifact://scene-report",
    ),
    @bunnia.message(
      id="msg-human-review",
      actor_id="operator",
      thread_id="thread-overview",
      text="Review the suggested route before dispatch.",
      status=@bunnia.run_waiting_review(),
    ),
  ])
  let review = @bunnia.review_controls(
    @bunnia.review_action(
      id="route-review",
      label="Route review",
      approve_message="approve-route",
      reject_message="reject-route",
    ),
  )
  let tool_result = @bunnia.tool_result_card_view(
    @bunnia.tool_result_card(
      id="route-tool-result",
      tool_name="route-inspector",
      title="Route inspection",
      summary="Scene report is ready for operator review.",
      artifact_ref="artifact://scene-report",
      status=@bunnia.run_waiting_review(),
      open_message="open-route-tool",
      acknowledge_message="ack-route-tool",
    ),
  )
  let thread_links = demo_scene_thread_links()
  let scene = demo_scene()
  let camera = demo_camera()
  let camera_plan = @bunnia.plan_scene_camera(scene, camera)
  let map = @bunnia.view_with_attrs(
    [@bunnia.class_name("bunnia-scene-with-threads")],
    [
      @bunnia.static_scene_view_with_camera(scene, camera),
      @bunnia.windowed_anchored_scene_thread_overlay_with_viewport(
        scene,
        camera_plan.viewport,
        thread_links,
        total_count=thread_links.length(),
      ),
    ],
  )
  @bunnia.page([
    @bunnia.view_with_attrs([@bunnia.class_name("demo-shell")], [
      @bunnia.text("Agent Map"),
      feed,
      review,
      tool_result,
      @bunnia.view_with_attrs([@bunnia.class_name("scene-controls")], [
        @bunnia.button("Pan Map", "pan-map-east"),
        @bunnia.button("Zoom Map", "zoom-map-in"),
        @bunnia.button("Cancel Run", "cancel-agent-run"),
        @bunnia.button("Retry Run", "retry-agent-run"),
      ]),
      map,
    ]),
  ])
}

///|
pub fn demo_wechat_page() -> @bunnia.WechatPage {
  @bunnia.generate_wechat_page_with_runtime(
    "Agent Map",
    demo_view(),
    demo_runtime(),
  )
}

///|
pub fn demo_wechat_project() -> @bunnia.WechatProject {
  demo_wechat_project_with_render_budget(@bunnia.default_render_budget())
}

///|
pub fn demo_wechat_project_with_render_budget(
  render_budget : @bunnia.RenderBudget,
) -> @bunnia.WechatProject {
  @bunnia.generate_wechat_project_with_runtime_and_budget_and_backend(
    name="Agent Map",
    root=demo_view(),
    runtime=demo_runtime(),
    render_budget~,
    backend_contract=demo_backend_contract(),
  )
}

///|
pub fn demo_runtime() -> @bunnia.WechatRuntime {
  @bunnia.wechat_runtime(initial_data_json=demo_initial_data_json(), event_patches=[
    @bunnia.wechat_event_patch("select-zone-a", [
      @bunnia.select_scene_region("ops-map", "zone-a"),
      @bunnia.set_scene_region_status("ops-map", "zone-a", "selected"),
    ]),
    @bunnia.wechat_event_patch("select-zone-b", [
      @bunnia.select_scene_region("ops-map", "zone-b"),
      @bunnia.set_scene_region_status("ops-map", "zone-b", "running"),
    ]),
    @bunnia.wechat_event_patch("approve-route", [
      @bunnia.set_json("review.routeReview", "\"approved\""),
    ]),
    @bunnia.wechat_event_patch("reject-route", [
      @bunnia.set_json("review.routeReview", "\"rejected\""),
    ]),
    @bunnia.wechat_event_patch("open-route-tool", [
      @bunnia.set_string("tool.activeResult", "route-tool-result"),
    ]),
    @bunnia.wechat_event_patch("ack-route-tool", [
      @bunnia.set_json("tool.routeToolResult", "\"acknowledged\""),
    ]),
    @bunnia.wechat_event_patch("pan-map-east", [
      @bunnia.set_scene_camera_position("ops-map", 128, 96),
    ]),
    @bunnia.wechat_event_patch("zoom-map-in", [
      @bunnia.set_scene_camera_zoom("ops-map", 150),
    ]),
    @bunnia.wechat_event_patch("cancel-agent-run", [
      @bunnia.set_string("agent.routeRun.status", "cancelled"),
    ]),
    @bunnia.wechat_event_patch("retry-agent-run", [
      @bunnia.set_string("agent.routeRun.status", "retrying"),
    ]),
    @bunnia.wechat_event_patch("open-thread-zone-a", [
      @bunnia.select_scene_region_thread("ops-map", "zone-a", "thread-overview"),
    ]),
    @bunnia.wechat_event_patch("open-thread-zone-b", [
      @bunnia.select_scene_marker_thread(
        "ops-map", "agent-b", "thread-overview",
      ),
    ]),
  ])
}

///|
fn demo_initial_data_json() -> String {
  "{\"scenes\":{\"ops-map\":{\"selectedRegion\":\"\",\"regions\":{\"zone-a\":{\"status\":\"stable\"},\"zone-b\":{\"status\":\"review\"}},\"camera\":{\"x\":0,\"y\":0,\"width\":520,\"height\":360,\"zoomPercent\":100}}},\"review\":{\"routeReview\":\"pending\"},\"tool\":{\"activeResult\":\"\",\"routeToolResult\":\"pending\"},\"agent\":{\"routeRun\":{\"status\":\"running\"}},\"runCancel\":{\"runId\":\"route-run-1\"},\"runRetry\":{\"runId\":\"route-run-1\"}}"
}

///|
pub fn demo_patch_plan() -> @bunnia.PatchPlan {
  @bunnia.plan_patches([
    @bunnia.set_string("__bunnia.lastMessage", "select-zone-b"),
    @bunnia.set_scene_region_status("ops-map", "zone-b", "running"),
  ])
}

///|
pub fn demo_snapshot_delta_plan() -> @bunnia.SnapshotDeltaPlan {
  @bunnia.plan_snapshot_deltas([
    @bunnia.set_snapshot_section_delta(
      "agent-map", "selectedZone", "\"zone-b\"",
    ),
    @bunnia.append_snapshot_item_delta(
      "agent-map", "messages", "msg-agent-progress", "{\"id\":\"msg-agent-progress\",\"text\":\"Planner marked Review Dock as active.\"}",
    ),
  ])
}

///|
pub fn demo_agent_delta_plan() -> @bunnia.AgentDeltaPlan {
  @bunnia.plan_agent_deltas([
    @bunnia.append_message_delta(
      "agent.feed",
      @bunnia.message(
        id="msg-agent-progress",
        actor_id="agent-planner",
        thread_id="thread-overview",
        text="Planner marked Review Dock as active.",
      ),
    ),
    @bunnia.append_stream_chunk_delta(
      "agent.streamChunks", "route-chunk-1", "Checking route coverage...",
    ),
    @bunnia.set_stream_chunk_delta(
      "agent.streamChunks",
      "route-chunk-1",
      "Route coverage checked.",
      status=@bunnia.run_done(),
    ),
    @bunnia.set_review_state_delta(
      "review.routeReview",
      @bunnia.review_pending(),
    ),
  ])
}

///|
pub fn demo_communication_plan() -> @bunnia.CommunicationPlan {
  @bunnia.plan_communications_with_budget(
    [
      @bunnia.message_event(
        id="comm-planner-opened",
        thread_id="thread-overview",
        from_actor_id="agent-planner",
        text="Planner opened the active scene thread.",
      ),
      @bunnia.review_request(
        id="comm-route-review",
        thread_id="thread-overview",
        from_actor_id="agent-planner",
        to_actor_id="operator",
        text="Review the suggested route before dispatch.",
        artifact_ref="artifact://scene-report",
      ),
      @bunnia.tool_result(
        id="comm-route-tool",
        thread_id="thread-overview",
        from_actor_id="agent-planner",
        text="Route inspection produced a scene report.",
        artifact_ref="artifact://scene-report",
      ),
    ],
    @bunnia.communication_budget(max_visible_count=8),
  )
}

///|
pub fn demo_tool_result_plan() -> @bunnia.ToolResultPlan {
  @bunnia.plan_tool_result_cards_with_budget(
    [
      @bunnia.tool_result_card(
        id="route-tool-result",
        tool_name="route-inspector",
        title="Route inspection",
        summary="Scene report is ready for operator review.",
        artifact_ref="artifact://scene-report",
        status=@bunnia.run_waiting_review(),
        open_message="open-route-tool",
        acknowledge_message="ack-route-tool",
      ),
    ],
    @bunnia.tool_result_budget(max_visible_count=8),
  )
}

///|
pub fn demo_backend_contract() -> @bunnia.BackendContract {
  @bunnia.backend_contract(id="agent-map-backend", endpoints=[
    @bunnia.agent_message_endpoint(
      "send-agent-message", "/agent/message", "draftMessage", "messageResult",
    ),
    @bunnia.agent_stream_endpoint(
      "stream-route-status", "/agent/route/status", "threadId", "routeStatus",
    ),
    @bunnia.review_decision_endpoint(
      "review-route", "/review/route", "reviewDecision", "reviewResult",
    ),
    @bunnia.tool_ack_endpoint("ack-route-tool", "/tool/route/ack", "toolAck"),
    @bunnia.agent_cancel_endpoint(
      "cancel-agent-run", "/agent/route/cancel", "runCancel", "cancelResult",
    ),
    @bunnia.agent_retry_endpoint(
      "retry-agent-run", "/agent/route/retry", "runRetry", "retryResult",
    ),
  ])
}

///|
pub fn demo_effect_plan() -> @bunnia.EffectPlan {
  @bunnia.plan_backend_effects_for_platform(
    demo_backend_contract(),
    @bunnia.wechat(),
  )
}

///|
pub fn demo_scene_render_plan() -> @bunnia.SceneRenderPlan {
  @bunnia.plan_scene_render(demo_scene())
}

///|
pub fn demo_scene_camera_plan() -> @bunnia.SceneCameraPlan {
  @bunnia.plan_scene_camera(demo_scene(), demo_camera())
}

///|
pub fn demo_scene_surface_plan() -> @bunnia.SceneSurfacePlan {
  @bunnia.plan_scene_surface_for_platform(
    demo_scene(),
    @bunnia.wechat(),
    preference=@bunnia.prefer_static_surface(),
  )
}

///|
pub fn demo_scene_thread_plan() -> @bunnia.SceneThreadPlan {
  let scene = demo_scene()
  let camera_plan = @bunnia.plan_scene_camera(scene, demo_camera())
  @bunnia.plan_scene_threads_viewport_with_budget(
    scene,
    camera_plan.viewport,
    demo_scene_thread_links(),
    @bunnia.scene_thread_budget(max_visible_links=8, max_unread_total=8),
  )
}

///|
pub fn demo_asset_plan() -> @bunnia.SceneAssetPlan {
  @bunnia.plan_scene_assets(demo_scene_assets())
}

///|
pub fn demo_scene_visual_quality_plan() -> @bunnia.SceneVisualQualityPlan {
  @bunnia.plan_scene_visual_quality(demo_scene())
}

///|
fn demo_scene() -> @bunnia.Scene {
  @bunnia.scene(
    "ops-map",
    @bunnia.scene_size(720, 520),
    [
      @bunnia.layer("zones", 1, [], regions=[
        @bunnia.region(
          id="zone-a",
          label="North Gate",
          x=64,
          y=96,
          width=220,
          height=160,
          status="stable",
          tap_message="select-zone-a",
        ),
        @bunnia.region(
          id="zone-b",
          label="Review Dock",
          x=360,
          y=210,
          width=240,
          height=180,
          status="review",
          tap_message="select-zone-b",
        ),
      ]),
      @bunnia.layer("actors", 2, [
        @bunnia.marker(
          id="agent-a",
          label="Planner",
          x=156,
          y=156,
          status="running",
          tap_message="select-zone-a",
          asset_ref="zone-pin",
        ),
        @bunnia.marker(
          id="agent-b",
          label="Reviewer",
          x=450,
          y=280,
          status="review",
          tap_message="select-zone-b",
          asset_ref="zone-pin",
        ),
      ]),
    ],
    assets=demo_scene_assets(),
  )
}

///|
fn demo_camera() -> @bunnia.SceneCamera {
  @bunnia.scene_camera(scene_id="ops-map", x=0, y=0, width=520, height=360)
}

///|
fn demo_scene_assets() -> Array[@bunnia.SceneAsset] {
  [@bunnia.sprite_asset("zone-pin", "/assets/zone-pin.png", 2048)]
}

///|
fn demo_scene_thread_links() -> Array[@bunnia.SceneThreadLink] {
  [
    @bunnia.scene_region_thread_link(
      id="thread-zone-a-link",
      scene_id="ops-map",
      region_id="zone-a",
      thread_id="thread-overview",
      subject_ref="scene://ops-map/zone-a",
      status="stable",
      unread_count=0,
      open_message="open-thread-zone-a",
    ),
    @bunnia.scene_marker_thread_link(
      id="thread-zone-b-link",
      scene_id="ops-map",
      marker_id="agent-b",
      thread_id="thread-overview",
      subject_ref="scene://ops-map/zone-b",
      status="review",
      unread_count=2,
      open_message="open-thread-zone-b",
    ),
  ]
}
