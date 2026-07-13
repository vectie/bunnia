///|
fn my_surface_panels(projection : MiniTownProjection) -> Array[@bunnia.Node] {
  [
    my_overview_panel(projection),
    profile_panel(projection),
    public_passport_panel(projection),
    ownership_lifecycle_panel(projection),
    create_drawer(projection),
    reviewer_tools_panel(projection),
  ]
}
