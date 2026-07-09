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
