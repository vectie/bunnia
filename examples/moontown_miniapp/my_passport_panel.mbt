///|
fn identity_setup_panel(projection : MiniTownProjection) -> @bunnia.Node {
  let gates : Array[MiniTownSetupGate] = []
  for gate in setup_gates(projection) {
    if !gate.complete {
      gates.push(gate)
    }
  }
  @bunnia.view_with_attrs([@bunnia.class_name("mt-panel moontown-my-setup")], [
    @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-title")], [
      @bunnia.text("Town Passport"),
    ]),
    @bunnia.view_with_attrs([@bunnia.class_name("moontown-profile-status")], [
      @bunnia.text(
        profile_publish_sentence(
          projection.profile.display_name,
          profile_ready_to_publish(projection),
        ),
      ),
    ]),
    @bunnia.windowed_list(
      gates,
      total_count=gates.length(),
      render=setup_gate_entry,
    ),
  ])
}
