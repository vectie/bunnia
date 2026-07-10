///|
fn agent_result_entry(
  projection : MiniTownProjection,
  item : MiniTownToolResult,
) -> @bunnia.Node {
  @bunnia.keyed(
    "agent-result-\{item.id}",
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("moontown-agent-result"),
        @bunnia.data("building-id", item.building_id),
      ],
      [
        @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
          @bunnia.text(item.title),
        ]),
        @bunnia.text(item.summary),
        @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
          @bunnia.text(
            "\{building_title_by_id(projection, item.building_id)} - Review result",
          ),
        ]),
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-run-actions")], [
          agent_result_open_button(item),
          @bunnia.node(
            kind="button",
            attrs=[@bunnia.class_name("moontown-primary-action")],
            events=[@bunnia.tap(item.acknowledge_message)],
            children=[@bunnia.text("Review Result")],
          ),
        ]),
      ],
    ),
  )
}

///|
fn agent_result_open_button(item : MiniTownToolResult) -> @bunnia.Node {
  if high_leverage_place_route(item.building_id) {
    open_place_button(item.building_id, emphasis=false)
  } else {
    @bunnia.node(
      kind="button",
      attrs=[@bunnia.class_name("moontown-secondary-action")],
      events=[@bunnia.tap(item.open_message)],
      children=[@bunnia.text("Open Work")],
    )
  }
}
