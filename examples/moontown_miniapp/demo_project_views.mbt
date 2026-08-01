///|
pub fn demo_view() -> @bunnia.Node {
  mini_town_view(demo_projection())
}

///|
pub fn mini_town_view(projection : MiniTownProjection) -> @bunnia.Node {
  mini_town_view_with_map_mode(projection, full_map=true)
}

///|
fn mini_town_route_view(projection : MiniTownProjection) -> @bunnia.Node {
  mini_town_view_with_map_mode(
    projection,
    full_map=projection.active_tab_id == "realm",
  )
}

///|
fn mini_town_view_with_map_mode(
  projection : MiniTownProjection,
  full_map~ : Bool,
) -> @bunnia.Node {
  @bunnia.page([
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name(
          "moontown-miniapp {{town.mapFullscreen ? 'map-focus' : ''}}",
        ),
        @bunnia.data("active-user", projection.active_user_id),
      ],
      [
        if full_map {
          town_map_surface(projection)
        } else {
          town_map_backdrop(projection)
        },
        if full_map {
          town_map_focus_toggle()
        } else {
          @bunnia.view([])
        },
        town_top_bar(projection),
        global_request_feedback(),
        town_active_surface(projection),
        town_tabbar(projection),
      ],
    ),
  ])
}
