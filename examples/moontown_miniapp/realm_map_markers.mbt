///|
fn map_markers(projection : MiniTownProjection) -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-map-markers")], [
    @bunnia.list(visible_buildings(projection), fn(building) {
      map_marker(projection, building)
    }),
  ])
}

///|
fn map_marker(
  projection : MiniTownProjection,
  building : MiniTownBuilding,
) -> @bunnia.Node {
  let selected = building.id == projection.selected_building_id
  let children : Array[@bunnia.Node] = []
  if selected || map_marker_has_signal(building) {
    children.push(map_marker_signal(building))
  }
  children.push(
    @bunnia.view_with_attrs([@bunnia.class_name("moontown-map-marker-title")], [
      @bunnia.text(building.title),
    ]),
  )
  @bunnia.keyed(
    "map-marker-\{building.id}",
    @bunnia.node(
      kind="view",
      attrs=[
        @bunnia.class_name(
          "moontown-map-marker {{town.selectedBuildingId == '\{building.id}' ? 'selected' : ''}} bunnia-status-\{building.status}",
        ),
        @bunnia.attr(
          "style",
          "left: \{map_display_position(building.x)}rpx; top: \{map_display_position(building.y)}rpx;",
        ),
        @bunnia.data("building-id", building.id),
      ],
      events=[@bunnia.event("tap", "select-\{building.id}")],
      children~,
    ),
  )
}

///|
fn map_display_position(position : Int) -> Int {
  position * moontown_map_display_scale()
}

///|
fn map_marker_signal(building : MiniTownBuilding) -> @bunnia.Node {
  @bunnia.node(
    kind="view",
    attrs=[@bunnia.class_name("moontown-thread-pin")],
    events=[@bunnia.event("tap", "open-thread-\{building.id}")],
    children=[@bunnia.text(map_marker_signal_label(building))],
  )
}

///|
fn map_marker_has_signal(building : MiniTownBuilding) -> Bool {
  building.status == "review" ||
  building.status == "running" ||
  building.visibility == "shared_private" ||
  building.visibility == "private_draft"
}

///|
fn map_marker_signal_label(building : MiniTownBuilding) -> String {
  if building.status == "review" {
    "Review"
  } else if building.status == "running" {
    "Active"
  } else if building.visibility == "shared_private" {
    "Shared"
  } else if building.visibility == "private_draft" {
    "Draft"
  } else {
    "Open"
  }
}
