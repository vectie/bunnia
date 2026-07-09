///|
fn moderation_desk_panel(projection : MiniTownProjection) -> @bunnia.Node {
  let cases = projection.moderation_cases
  @bunnia.view_with_attrs([@bunnia.class_name("mt-panel")], [
    @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-title")], [
      @bunnia.text("Moderation Desk"),
    ]),
    @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-note")], [
      @bunnia.text(
        "\{cases.length()} report case; hide or takedown stays audited.",
      ),
    ]),
    @bunnia.windowed_list(
      cases,
      total_count=cases.length(),
      render=moderation_case_entry,
    ),
  ])
}

///|
fn moderation_case_entry(item : MiniTownModerationCase) -> @bunnia.Node {
  @bunnia.keyed(
    "moderation-\{item.id}",
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("moontown-review-entry bunnia-status-\{item.status}"),
        @bunnia.data("moderation-case", item.id),
        @bunnia.data("building-id", item.building_id),
        @bunnia.data("target-ref", item.target_ref),
        @bunnia.data("reporter-id", item.reporter_id),
      ],
      [
        @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
          @bunnia.text(item.title),
        ]),
        @bunnia.text(item.summary),
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-run-actions")], [
          moderation_case_action_button(item),
          moderation_button(item, "Hide", "hide", "hide-public-building"),
          moderation_button(
            item, "Takedown", "takedown", "takedown-public-building",
          ),
        ]),
      ],
    ),
  )
}

///|
fn moderation_case_action_button(item : MiniTownModerationCase) -> @bunnia.Node {
  moderation_button(
    item,
    item.action_label,
    moderation_case_action_id(item),
    item.action_message,
  )
}

///|
fn moderation_case_action_id(item : MiniTownModerationCase) -> String {
  if item.action_message == "appeal-moderation-case" {
    "appeal"
  } else {
    "review"
  }
}

///|
fn moderation_button(
  item : MiniTownModerationCase,
  label : String,
  action : String,
  message : String,
) -> @bunnia.Node {
  @bunnia.node(
    kind="button",
    attrs=[
      @bunnia.class_name("moontown-run-action stable"),
      @bunnia.data("moderation-action", action),
      @bunnia.data("moderation-case", item.id),
      @bunnia.data("building-id", item.building_id),
    ],
    events=[@bunnia.tap(message)],
    children=[@bunnia.text(label)],
  )
}
