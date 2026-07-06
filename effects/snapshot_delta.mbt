///|
pub(all) enum SnapshotDeltaKind {
  SnapshotSetSection
  SnapshotAppendItem
  SnapshotRemoveSection
  SnapshotReplaceAll
} derive(Debug, Eq)

///|
pub struct SnapshotDelta {
  kind : SnapshotDeltaKind
  scope : String
  section : String
  item_id : String
  value_json : String
  patch : @core.Patch
} derive(Debug, Eq)

///|
pub struct SnapshotDeltaPlan {
  deltas : Array[SnapshotDelta]
  patch_plan : @core.PatchPlan
  section_update_count : Int
  append_item_count : Int
  full_snapshot_count : Int
  diagnostics : Array[String]
  summary : String
} derive(Debug, Eq)

///|
pub fn set_snapshot_section_delta(
  scope : String,
  section : String,
  value_json : String,
) -> SnapshotDelta {
  snapshot_delta(
    kind=SnapshotSetSection,
    scope~,
    section~,
    value_json~,
    patch=@core.set_json(snapshot_section_path(scope, section), value_json),
  )
}

///|
pub fn append_snapshot_item_delta(
  scope : String,
  section : String,
  item_id : String,
  value_json : String,
) -> SnapshotDelta {
  snapshot_delta(
    kind=SnapshotAppendItem,
    scope~,
    section~,
    item_id~,
    value_json~,
    patch=@core.append_json(snapshot_section_path(scope, section), value_json),
  )
}

///|
pub fn remove_snapshot_section_delta(
  scope : String,
  section : String,
) -> SnapshotDelta {
  snapshot_delta(
    kind=SnapshotRemoveSection,
    scope~,
    section~,
    patch=@core.remove_path(snapshot_section_path(scope, section)),
  )
}

///|
pub fn replace_snapshot_delta(
  scope : String,
  value_json : String,
) -> SnapshotDelta {
  snapshot_delta(
    kind=SnapshotReplaceAll,
    scope~,
    value_json~,
    patch=@core.set_json(snapshot_scope_path(scope), value_json),
  )
}

///|
pub fn plan_snapshot_deltas(deltas : Array[SnapshotDelta]) -> SnapshotDeltaPlan {
  plan_snapshot_deltas_with_budget(deltas, @core.default_patch_budget())
}

///|
pub fn plan_snapshot_deltas_with_budget(
  deltas : Array[SnapshotDelta],
  budget : @core.PatchBudget,
) -> SnapshotDeltaPlan {
  let patches : Array[@core.Patch] = []
  let diagnostics : Array[String] = []
  let mut section_update_count = 0
  let mut append_item_count = 0
  let mut full_snapshot_count = 0
  for delta in deltas {
    patches.push(delta.patch)
    append_delta_diagnostics(delta, diagnostics)
    match delta.kind {
      SnapshotSetSection | SnapshotRemoveSection => section_update_count += 1
      SnapshotAppendItem => append_item_count += 1
      SnapshotReplaceAll => full_snapshot_count += 1
    }
  }
  append_duplicate_item_diagnostics(deltas, diagnostics)
  let patch_plan = @core.plan_patches_with_budget(patches, budget)
  for item in patch_plan.diagnostics {
    diagnostics.push(item)
  }
  {
    deltas,
    patch_plan,
    section_update_count,
    append_item_count,
    full_snapshot_count,
    diagnostics,
    summary: "Bunnia snapshot delta plan: deltas=\{deltas.length()} patches=\{patch_plan.patches.length()} sections=\{section_update_count} appends=\{append_item_count} full_snapshots=\{full_snapshot_count} bytes=\{patch_plan.total_estimated_bytes} diagnostics=\{diagnostics.length()}",
  }
}

///|
pub fn snapshot_delta_kind_id(kind : SnapshotDeltaKind) -> String {
  match kind {
    SnapshotSetSection => "set-section"
    SnapshotAppendItem => "append-item"
    SnapshotRemoveSection => "remove-section"
    SnapshotReplaceAll => "replace-all"
  }
}

///|
fn snapshot_delta(
  kind~ : SnapshotDeltaKind,
  scope~ : String,
  section? : String = "",
  item_id? : String = "",
  value_json? : String = "null",
  patch~ : @core.Patch,
) -> SnapshotDelta {
  { kind, scope, section, item_id, value_json, patch }
}

///|
fn snapshot_scope_path(scope : String) -> String {
  "snapshots.\{scope}"
}

///|
fn snapshot_section_path(scope : String, section : String) -> String {
  "\{snapshot_scope_path(scope)}.\{section}"
}

///|
fn append_delta_diagnostics(
  delta : SnapshotDelta,
  diagnostics : Array[String],
) -> Unit {
  if delta.scope == "" {
    diagnostics.push("snapshot-delta-missing-scope")
  }
  match delta.kind {
    SnapshotSetSection | SnapshotAppendItem | SnapshotRemoveSection =>
      if delta.section == "" {
        diagnostics.push(
          "snapshot-delta-missing-section:\{diagnostic_scope(delta.scope)}",
        )
      }
    SnapshotReplaceAll =>
      diagnostics.push(
        "snapshot-delta-full-replace:\{diagnostic_scope(delta.scope)}",
      )
  }
  if delta.kind is SnapshotAppendItem && delta.item_id == "" {
    diagnostics.push(
      "snapshot-delta-missing-item-id:\{diagnostic_section(delta.scope, delta.section)}",
    )
  }
}

///|
fn append_duplicate_item_diagnostics(
  deltas : Array[SnapshotDelta],
  diagnostics : Array[String],
) -> Unit {
  for i in 0..<deltas.length() {
    let left = deltas[i]
    if left.kind is SnapshotAppendItem && left.item_id != "" {
      for j in (i + 1)..<deltas.length() {
        let right = deltas[j]
        if right.kind is SnapshotAppendItem &&
          left.scope == right.scope &&
          left.section == right.section &&
          left.item_id == right.item_id {
          diagnostics.push(
            "snapshot-delta-duplicate-item:\{diagnostic_section(left.scope, left.section)}:\{left.item_id}",
          )
        }
      }
    }
  }
}

///|
fn diagnostic_scope(scope : String) -> String {
  if scope == "" {
    "<root>"
  } else {
    scope
  }
}

///|
fn diagnostic_section(scope : String, section : String) -> String {
  "\{diagnostic_scope(scope)}.\{if section == "" { "<section>" } else { section }}"
}
