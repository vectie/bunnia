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
