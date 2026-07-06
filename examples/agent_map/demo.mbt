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
  let map = @bunnia.static_scene_view(
    @bunnia.scene("ops-map", @bunnia.scene_size(720, 520), [
      @bunnia.layer("zones", 1, [
        @bunnia.marker(
          id="zone-a",
          label="North Gate",
          x=96,
          y=144,
          status="stable",
          tap_message="select-zone-a",
        ),
        @bunnia.marker(
          id="zone-b",
          label="Review Dock",
          x=420,
          y=260,
          status="review",
          tap_message="select-zone-b",
        ),
      ]),
    ]),
  )
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
  @bunnia.generate_wechat_page("Agent Map", demo_view())
}

///|
pub fn demo_patch_plan() -> @bunnia.PatchPlan {
  @bunnia.plan_patches([
    @bunnia.set_string("__bunnia.lastMessage", "select-zone-b"),
    @bunnia.set_json("scene.zones.zone-b.status", "\"running\""),
  ])
}
