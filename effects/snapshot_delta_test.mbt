///|
test "snapshot deltas lower section refreshes to small patches" {
  let deltas = [
    set_snapshot_section_delta("home", "hero", "{\"title\":\"Bunnia\"}"),
    append_snapshot_item_delta(
      "home", "messages", "msg-1", "{\"id\":\"msg-1\",\"text\":\"ready\"}",
    ),
    remove_snapshot_section_delta("home", "staleCards"),
  ]
  let plan = plan_snapshot_deltas(deltas)
  assert_eq(plan.deltas.length(), 3)
  assert_eq(plan.patch_plan.patches.length(), 3)
  assert_eq(plan.section_update_count, 2)
  assert_eq(plan.append_item_count, 1)
  assert_eq(plan.full_snapshot_count, 0)
  assert_eq(plan.diagnostics.length(), 0)
  assert_eq(plan.patch_plan.patches[0].path, "snapshots.home.hero")
  assert_eq(plan.patch_plan.patches[1].path, "snapshots.home.messages")
  assert_true(plan.patch_plan.total_estimated_bytes < 160)
  assert_true(plan.summary.contains("sections=2"))
}

///|
test "snapshot delta plans flag full replacements duplicate ids and budgets" {
  let deltas = [
    replace_snapshot_delta("home", "{\"large\":true}"),
    append_snapshot_item_delta(
      "home", "messages", "msg-1", "{\"id\":\"msg-1\"}",
    ),
    append_snapshot_item_delta(
      "home", "messages", "msg-1", "{\"id\":\"msg-1\"}",
    ),
  ]
  let plan = plan_snapshot_deltas_with_budget(
    deltas,
    @core.patch_budget(max_patches=2, max_patch_bytes=64),
  )
  assert_eq(plan.full_snapshot_count, 1)
  assert_true(plan.diagnostics.contains("snapshot-delta-full-replace:home"))
  assert_true(
    plan.diagnostics.contains(
      "snapshot-delta-duplicate-item:home.messages:msg-1",
    ),
  )
  assert_true(plan.diagnostics.contains("patch-count-over-budget:3/2"))
}

///|
test "snapshot delta kind ids stay stable" {
  assert_eq(snapshot_delta_kind_id(SnapshotSetSection), "set-section")
  assert_eq(snapshot_delta_kind_id(SnapshotAppendItem), "append-item")
  assert_eq(snapshot_delta_kind_id(SnapshotRemoveSection), "remove-section")
  assert_eq(snapshot_delta_kind_id(SnapshotReplaceAll), "replace-all")
}
