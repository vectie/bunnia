///|
fn lifecycle_stage_rows(
  building : MiniTownBuilding,
) -> Array[ObjectLifecycleStage] {
  [
    object_lifecycle_stage(
      id="private-draft",
      label="Private Draft",
      status=lifecycle_stage_status(building, "private_draft"),
    ),
    object_lifecycle_stage(
      id="team-shared",
      label="Team Shared",
      status=lifecycle_stage_status(building, "shared_private"),
    ),
    object_lifecycle_stage(
      id="submitted",
      label="Submitted",
      status=lifecycle_stage_status(building, "submitted"),
    ),
    object_lifecycle_stage(
      id="published",
      label="Published",
      status=lifecycle_stage_status(building, "published"),
    ),
    object_lifecycle_stage(
      id="hidden",
      label="Hidden",
      status=lifecycle_stage_status(building, "hidden"),
    ),
    object_lifecycle_stage(
      id="archived",
      label="Archived",
      status=lifecycle_stage_status(building, "archived"),
    ),
  ]
}

///|
fn lifecycle_stage_status(
  building : MiniTownBuilding,
  visibility : String,
) -> String {
  if building.visibility == visibility || building.status == visibility {
    "current"
  } else if visibility == "hidden" && building.status == "hidden" {
    "current"
  } else {
    "stable"
  }
}

///|
fn lifecycle_stage_entry(item : ObjectLifecycleStage) -> @bunnia.Node {
  @bunnia.keyed(
    "lifecycle-stage-\{item.id}",
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name(
          "moontown-lifecycle-stage bunnia-status-\{item.status}",
        ),
        @bunnia.data("lifecycle-stage", item.id),
      ],
      [@bunnia.text(item.label)],
    ),
  )
}
