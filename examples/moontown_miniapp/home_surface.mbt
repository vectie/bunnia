///|
fn home_surface_panels(projection : MiniTownProjection) -> Array[@bunnia.Node] {
  let panels : Array[@bunnia.Node] = []
  panels.push(supervisor_registration_kiosk(projection))
  panels.push(home_supervisor_control_panel(projection))
  if !projection.onboarding_completed {
    panels.push(onboarding_panel(projection))
  }
  panels.push(home_pulse_panel(projection))
  panels.push(home_district_gates_panel(projection))
  panels
}
