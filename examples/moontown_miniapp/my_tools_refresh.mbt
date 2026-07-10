///|
fn inventory_refresh_plaque(projection : MiniTownProjection) -> @bunnia.Node {
  let step = ownership_backend_step(projection)
  let cache = ownership_cache_state(projection)
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-credential-plaque"),
      @bunnia.data("inventory-refresh", town_status_label(cache.state)),
    ],
    [
      @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
        @bunnia.text("Inventory Refresh"),
      ]),
      @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
        @bunnia.text("My Inventory - \{town_status_label(cache.state)}"),
      ]),
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-community-actions")],
        [@bunnia.button("Refresh My Stuff", step.endpoint_id)],
      ),
    ],
  )
}
