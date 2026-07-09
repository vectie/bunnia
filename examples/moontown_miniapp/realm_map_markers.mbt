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
  @bunnia.keyed(
    "map-marker-\{building.id}",
    @bunnia.node(
      kind="view",
      attrs=[
        @bunnia.class_name(
          "moontown-map-marker bunnia-status-\{building.status}\{if building.id == projection.selected_building_id { " selected" } else { "" }}",
        ),
        @bunnia.attr(
          "style",
          "left: \{map_display_position(building.x)}rpx; top: \{map_display_position(building.y)}rpx;",
        ),
        @bunnia.data("building-id", building.id),
      ],
      events=[@bunnia.event("tap", "select-\{building.id}")],
      children=[
        @bunnia.node(
          kind="view",
          attrs=[@bunnia.class_name("moontown-thread-pin")],
          events=[@bunnia.event("tap", "open-thread-\{building.id}")],
          children=[@bunnia.text(map_marker_badge_label(building))],
        ),
        @bunnia.view_with_attrs(
          [@bunnia.class_name("moontown-map-marker-title")],
          [@bunnia.text(building.title)],
        ),
        @bunnia.view_with_attrs(
          [@bunnia.class_name("moontown-map-marker-kind")],
          [@bunnia.text(town_kind_label(building.kind))],
        ),
      ],
    ),
  )
}

///|
fn map_display_position(position : Int) -> Int {
  position * moontown_map_display_scale()
}

///|
fn map_marker_badge_label(building : MiniTownBuilding) -> String {
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
