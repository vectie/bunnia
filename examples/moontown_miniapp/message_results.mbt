///|
fn tool_result_panel(projection : MiniTownProjection) -> @bunnia.Node {
  let results = visible_tool_results(projection)
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("mt-panel moontown-agent-results"),
      @bunnia.data("agent-result-count", results.length().to_string()),
    ],
    [
      @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-title")], [
        @bunnia.text("Agent Results"),
      ]),
      @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-note")], [
        @bunnia.text(
          "Reviewed agent output stays attached to a place and can be opened or cleared.",
        ),
      ]),
      @bunnia.windowed_list(results, total_count=results.length(), render=item => {
        agent_result_entry(projection, item)
      }),
    ],
  )
}

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
          @bunnia.button("Review Result", item.acknowledge_message),
        ]),
      ],
    ),
  )
}

///|
fn agent_result_open_button(item : MiniTownToolResult) -> @bunnia.Node {
  if high_leverage_place_route(item.building_id) {
    open_place_button(item.building_id)
  } else {
    @bunnia.button("Open Work", item.open_message)
  }
}
