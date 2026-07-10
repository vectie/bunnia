///|
fn identity_setup_panel(projection : MiniTownProjection) -> @bunnia.Node {
  let gates = setup_gates(projection)
  @bunnia.view_with_attrs([@bunnia.class_name("mt-panel moontown-my-setup")], [
    @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-title")], [
      @bunnia.text("Town Passport"),
    ]),
    @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-note")], [
      @bunnia.text("Choose a role and accept consent before publishing."),
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
    @bunnia.windowed_list(
      projection.roles,
      total_count=projection.roles.length(),
      render=role_entry,
    ),
    @bunnia.button("Accept Consent", "accept-profile-consent"),
    @bunnia.button("Save Profile", "save-profile"),
  ])
}
