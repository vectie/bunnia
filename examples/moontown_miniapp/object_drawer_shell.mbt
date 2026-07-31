///|
fn selected_building_drawer(projection : MiniTownProjection) -> @bunnia.Node {
  let drawers : Array[@bunnia.Node] = []
  for building in visible_buildings(projection) {
    let selected_projection = {
      ..projection,
      selected_building_id: building.id,
    }
    if building.id == projection.selected_building_id {
      drawers.push(
        selected_building_detail_drawer(selected_projection, building),
      )
    } else if building.id == "published-agent-lab" {
      drawers.push(routed_building_detail_drawer(building))
    }
  }
  drawers.push(selected_building_summary_drawer())
  @bunnia.view(drawers)
}

///|
fn routed_building_detail_drawer(building : MiniTownBuilding) -> @bunnia.Node {
  @bunnia.keyed(
    "building-routed-drawer-\{building.id}",
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("moontown-building-drawer"),
        @bunnia.attr("wx:if", "{{town.selectedBuildingId == '\{building.id}'}}"),
      ],
      [routed_building_header(building)],
    ),
  )
}

///|
fn routed_building_header(building : MiniTownBuilding) -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-object-header")], [
    @bunnia.view_with_attrs(
      [@bunnia.class_name("mt-title moontown-object-title")],
      [@bunnia.text(building.title)],
    ),
    @bunnia.view_with_attrs(
      [@bunnia.class_name("moontown-object-primary-actions")],
      [
        @bunnia.node(
          kind="button",
          attrs=[
            @bunnia.class_name("moontown-primary-action"),
            @bunnia.data("building-id", building.id),
          ],
          events=[@bunnia.tap("ask-selected-building")],
          children=[
            @bunnia.text(
              "{{ui.feedback == 'ask' ? (requestState.state == 'ready' ? 'Asked' : 'Asking...') : 'Ask'}}",
            ),
          ],
        ),
        @bunnia.node(
          kind="button",
          attrs=[
            @bunnia.class_name("moontown-secondary-action"),
            @bunnia.data("lifecycle-action", "place"),
            @bunnia.data("building-id", building.id),
            @bunnia.attr("wx:if", "{{!placementResult}}"),
          ],
          events=[@bunnia.tap("place-published-building")],
          children=[@bunnia.text("Place")],
        ),
        @bunnia.view_with_attrs(
          [
            @bunnia.class_name("mt-meta bunnia-status-stable"),
            @bunnia.attr("wx:if", "{{placementResult}}"),
          ],
          [@bunnia.text("Placed")],
        ),
      ],
    ),
  ])
}

///|
fn selected_building_detail_drawer(
  projection : MiniTownProjection,
  building : MiniTownBuilding,
) -> @bunnia.Node {
  @bunnia.keyed(
    "building-detail-drawer-\{building.id}",
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name(
          "moontown-building-drawer {{town.detailsOpen ? 'details-open' : ''}}",
        ),
        @bunnia.attr("wx:if", "{{town.selectedBuildingId == '\{building.id}'}}"),
        @bunnia.data("building-id", building.id),
      ],
      [
        building_object_header(projection, building),
        @bunnia.view_with_attrs(
          [
            @bunnia.class_name("moontown-object-details"),
            @bunnia.attr("wx:if", "{{town.detailsOpen}}"),
          ],
          [
            building_detail_actions(),
            building_memory_section(projection),
            building_worker_section(projection),
            building_lifecycle_section(projection),
            building_context_section(projection),
            safety_report_button(projection, building),
          ],
        ),
      ],
    ),
  )
}

///|
fn selected_building_summary_drawer() -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.attr(
        "wx:if", "{{!(town.selectedBuildingId == 'policy-hall' || town.selectedBuildingId == 'published-agent-lab')}}",
      ),
      @bunnia.class_name("moontown-building-drawer"),
    ],
    [
      @bunnia.view_with_attrs([@bunnia.class_name("moontown-object-header")], [
        @bunnia.view_with_attrs(
          [@bunnia.class_name("mt-title moontown-object-title")],
          [@bunnia.text("{{town.names[town.selectedBuildingId] || 'Place'}}")],
        ),
      ]),
    ],
  )
}
