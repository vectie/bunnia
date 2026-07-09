///|
pub fn demo_patch_plan() -> @bunnia.PatchPlan {
  @bunnia.plan_patches([
    @bunnia.set_string("town.selectedBuildingId", "published-agent-lab"),
    @bunnia.select_scene_marker("moontown-map", "published-agent-lab"),
    @bunnia.append_json(
      "chat.messages", "{\"id\":\"msg-mock-answer\",\"text\":\"Mock answer.\"}",
    ),
  ])
}

///|
pub fn demo_snapshot_delta_plan() -> @bunnia.SnapshotDeltaPlan {
  @bunnia.plan_snapshot_deltas([
    @bunnia.set_snapshot_section_delta(
      "moontown-miniapp", "selectedBuildingId", "\"policy-hall\"",
    ),
    @bunnia.append_snapshot_item_delta(
      "moontown-miniapp", "buildings", "created-agent-lab", "{\"id\":\"created-agent-lab\",\"visibility\":\"private_draft\"}",
    ),
    @bunnia.append_snapshot_item_delta(
      "moontown-miniapp", "messages", "msg-mock-answer", "{\"id\":\"msg-mock-answer\",\"status\":\"waiting-review\"}",
    ),
  ])
}
