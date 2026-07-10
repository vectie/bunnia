///|
fn home_surface_panels(projection : MiniTownProjection) -> Array[@bunnia.Node] {
  let panels : Array[@bunnia.Node] = []
  if !projection.onboarding_completed {
    panels.push(onboarding_panel(projection))
  }
  panels.push(home_pulse_panel(projection))
  panels.push(home_district_gates_panel(projection))
  panels
}
