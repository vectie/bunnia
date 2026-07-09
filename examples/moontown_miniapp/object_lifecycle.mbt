///|
priv struct ObjectLifecycleStage {
  id : String
  label : String
  status : String
}

///|
fn object_lifecycle_stage(
  id~ : String,
  label~ : String,
  status~ : String,
) -> ObjectLifecycleStage {
  { id, label, status }
}

///|
fn building_lifecycle_section(projection : MiniTownProjection) -> @bunnia.Node {
  let actions = selected_building_lifecycle_actions(projection)
  let building = selected_building(projection)
  let stages = lifecycle_stage_rows(building)
  object_section(
    section_id="lifecycle",
    title="Lifecycle Stamps",
    note="Private draft, team sharing, review, publishing, hiding, and archive states stay visible.",
    extra_class="moontown-lifecycle-section",
    children=[
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-lifecycle-stages")],
        [
          @bunnia.windowed_list(
            stages,
            total_count=stages.length(),
            render=lifecycle_stage_entry,
          ),
        ],
      ),
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-lifecycle-actions")],
        [
          @bunnia.windowed_list(
            actions,
            total_count=actions.length(),
            render=lifecycle_action_button,
          ),
        ],
      ),
    ],
  )
}

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

///|
fn lifecycle_action_button(action : MiniTownLifecycleAction) -> @bunnia.Node {
  let button_attrs = [
    @bunnia.class_name("moontown-lifecycle-action \{action.status}"),
    @bunnia.data("lifecycle-action", action.id),
    @bunnia.data("building-id", lifecycle_action_building_id(action)),
    @bunnia.data("allowed", if action.allowed { "true" } else { "false" }),
  ]
  if !action.allowed {
    button_attrs.push(@bunnia.attr("disabled", "true"))
  }
  @bunnia.keyed(
    "lifecycle-action-\{action.id}",
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name(
          "moontown-lifecycle-stamp bunnia-status-\{action.status}",
        ),
      ],
      [
        @bunnia.node(
          kind="button",
          attrs=button_attrs,
          events=[@bunnia.event("tap", action.message)],
          children=[@bunnia.text(action.label)],
        ),
        @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
          @bunnia.text(lifecycle_reason_label(action.reason)),
        ]),
      ],
    ),
  )
}

///|
fn lifecycle_reason_label(reason : String) -> String {
  if reason == "owner only" {
    "Owner only"
  } else if reason == "profile setup needed" {
    "Finish profile first"
  } else if reason == "book linked" {
    "Book linked"
  } else if reason == "published building" {
    "Published place"
  } else if reason == "ready for review" {
    "Ready for review"
  } else if reason == "review accepted" {
    "Review accepted"
  } else if reason == "owner action" {
    "Owner action"
  } else if reason == "already archived" {
    "Already archived"
  } else if reason == "already active" {
    "Already active"
  } else if reason == "draft editable" {
    "Draft editable"
  } else if reason == "locked after submit" {
    "Locked after submit"
  } else if reason == "not submitted" {
    "Submit first"
  } else {
    reason
  }
}

///|
fn lifecycle_action_building_id(action : MiniTownLifecycleAction) -> String {
  action.target_ref.replace_all(old="building:", new="")
}
