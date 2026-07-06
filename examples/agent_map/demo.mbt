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
  let map = @bunnia.static_scene_view(demo_scene())
  @bunnia.page([
    @bunnia.view_with_attrs([@bunnia.class_name("demo-shell")], [
      @bunnia.text("Agent Map"),
      feed,
      review,
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
  @bunnia.generate_wechat_project_with_runtime(
    name="Agent Map",
    root=demo_view(),
    runtime=demo_runtime(),
  )
}

///|
pub fn demo_runtime() -> @bunnia.WechatRuntime {
  @bunnia.wechat_runtime(initial_data_json=demo_initial_data_json(), event_patches=[
    @bunnia.wechat_event_patch("select-zone-a", [
      @bunnia.set_string("scene.selectedZone", "zone-a"),
      @bunnia.set_json("scene.zones.zone-a.status", "\"selected\""),
    ]),
    @bunnia.wechat_event_patch("select-zone-b", [
      @bunnia.set_string("scene.selectedZone", "zone-b"),
      @bunnia.set_json("scene.zones.zone-b.status", "\"running\""),
    ]),
    @bunnia.wechat_event_patch("approve-route", [
      @bunnia.set_json("review.routeReview", "\"approved\""),
    ]),
    @bunnia.wechat_event_patch("reject-route", [
      @bunnia.set_json("review.routeReview", "\"rejected\""),
    ]),
  ])
}

///|
fn demo_initial_data_json() -> String {
  "{\"scene\":{\"selectedZone\":\"\",\"zones\":{\"zone-a\":{\"status\":\"stable\"},\"zone-b\":{\"status\":\"review\"}}},\"review\":{\"routeReview\":\"pending\"}}"
}

///|
pub fn demo_patch_plan() -> @bunnia.PatchPlan {
  @bunnia.plan_patches([
    @bunnia.set_string("__bunnia.lastMessage", "select-zone-b"),
    @bunnia.set_json("scene.zones.zone-b.status", "\"running\""),
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
pub fn demo_scene_render_plan() -> @bunnia.SceneRenderPlan {
  @bunnia.plan_scene_render(demo_scene())
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
      @bunnia.layer("zones", 1, [
        @bunnia.marker(
          id="zone-a",
          label="North Gate",
          x=96,
          y=144,
          status="stable",
          tap_message="select-zone-a",
          asset_ref="zone-pin",
        ),
        @bunnia.marker(
          id="zone-b",
          label="Review Dock",
          x=420,
          y=260,
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
fn demo_scene_assets() -> Array[@bunnia.SceneAsset] {
  [@bunnia.sprite_asset("zone-pin", "/assets/zone-pin.png", 2048)]
}
