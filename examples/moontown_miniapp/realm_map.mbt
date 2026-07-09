///|
fn town_map_surface(projection : MiniTownProjection) -> @bunnia.Node {
  let scene = demo_scene()
  let camera = demo_camera()
  let camera_plan = @bunnia.plan_scene_camera(scene, camera)
  let thread_links = demo_scene_thread_links(projection)
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-map-fullscreen")], [
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("moontown-map-touch-area"),
        @bunnia.attr("bindtouchstart", "onMoontownMapTouchStart"),
        @bunnia.attr("catchtouchmove", "onMoontownMapTouchMove"),
        @bunnia.attr("bindtouchend", "onMoontownMapTouchEnd"),
        @bunnia.attr("bindtouchcancel", "onMoontownMapTouchEnd"),
      ],
      [
        @bunnia.view_with_attrs(
          [
            @bunnia.class_name("moontown-map-drag-content"),
            @bunnia.attr("style", "{{mapViewport.style}}"),
          ],
          [moontown_map_image(), map_markers(projection)],
        ),
      ],
    ),
    @bunnia.view_with_attrs([@bunnia.class_name("moontown-semantic-scene")], [
      @bunnia.static_scene_view_with_camera(scene, camera),
      @bunnia.windowed_anchored_scene_thread_overlay_with_viewport(
        scene,
        camera_plan.viewport,
        thread_links,
        total_count=thread_links.length(),
      ),
    ]),
  ])
}

///|
fn town_map_backdrop(projection : MiniTownProjection) -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-map-fullscreen moontown-map-backdrop"),
      @bunnia.data("map-backdrop", projection.active_tab_id),
    ],
    [
      @bunnia.view_with_attrs([@bunnia.class_name("moontown-map-touch-area")], [
        @bunnia.view_with_attrs(
          [@bunnia.class_name("moontown-map-drag-content")],
          [moontown_map_backdrop_image()],
        ),
      ]),
    ],
  )
}

///|
fn moontown_map_backdrop_image() -> @bunnia.Node {
  @bunnia.node(kind="image", attrs=[
    @bunnia.class_name("moontown-wenyu-map-image"),
    @bunnia.attr("src", moontown_map_asset_src()),
    @bunnia.attr("alt", "Moontown Wenyu Valley map backdrop"),
    @bunnia.attr("mode", "scaleToFill"),
  ])
}

///|
fn moontown_map_image() -> @bunnia.Node {
  @bunnia.node(kind="image", attrs=[
    @bunnia.class_name("moontown-wenyu-map-image"),
    @bunnia.attr("src", moontown_map_asset_src()),
    @bunnia.attr("alt", "Moontown Wenyu Valley map"),
    @bunnia.attr("mode", "scaleToFill"),
    @bunnia.data("asset-id", "moontown-wenyu-map"),
    @bunnia.data("asset-kind", "image"),
    @bunnia.data("asset-source", moontown_map_asset_source()),
    @bunnia.data("asset-remote", "false"),
    @bunnia.data("asset-bytes", moontown_map_asset_bytes().to_string()),
  ])
}

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

///|
fn town_right_hud(projection : MiniTownProjection) -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-right-hud")], [
    selected_building_drawer(projection),
  ])
}

///|
fn town_realm_overlay(projection : MiniTownProjection) -> @bunnia.Node {
  @bunnia.view([town_right_hud(projection), town_bottom_hud(projection)])
}

///|
fn town_bottom_hud(projection : MiniTownProjection) -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-bottom-hud")], [
    realm_map_state_strip(projection),
  ])
}

///|
fn realm_map_state_strip(projection : MiniTownProjection) -> @bunnia.Node {
  let building = selected_building(projection)
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-map-state-strip")], [
    realm_map_state_chip(
      id="selected",
      label=building.title,
      value=map_marker_badge_label(building),
      status=building.status,
    ),
    realm_map_state_chip(
      id="access",
      label="Access",
      value=town_visibility_label(building.visibility),
      status=building.status,
    ),
    realm_map_state_chip(
      id="placement",
      label="Placement",
      value=selected_building_placement_label(projection, building),
      status=building.status,
    ),
    realm_map_state_chip(
      id="workers",
      label="Workers",
      value=count_label(
        selected_building_agents(projection).length(),
        "worker",
        "workers",
      ),
      status=building.status,
    ),
  ])
}

///|
fn realm_map_state_chip(
  id~ : String,
  label~ : String,
  value~ : String,
  status~ : String,
) -> @bunnia.Node {
  @bunnia.keyed(
    "map-state-\{id}",
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("moontown-map-state-chip bunnia-status-\{status}"),
        @bunnia.data("map-state", id),
      ],
      [@bunnia.text("\{label}: \{value}")],
    ),
  )
}

///|
fn selected_building_placement_label(
  projection : MiniTownProjection,
  building : MiniTownBuilding,
) -> String {
  match placement_for_building(projection, building.id) {
    Some(placement) =>
      if placement.status == "pinned" {
        "Pinned"
      } else {
        town_status_label(placement.status)
      }
    None =>
      if building.visibility == "published" {
        "Can place"
      } else {
        "Place private"
      }
  }
}
