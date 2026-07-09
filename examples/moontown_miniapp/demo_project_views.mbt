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
        @bunnia.class_name("moontown-miniapp"),
        @bunnia.data("active-user", projection.active_user_id),
      ],
      [
        if full_map {
          town_map_surface(projection)
        } else {
          town_map_backdrop(projection)
        },
        town_top_bar(projection),
        town_active_surface(projection),
        town_tabbar(projection),
      ],
    ),
  ])
}
