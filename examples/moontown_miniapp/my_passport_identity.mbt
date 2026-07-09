///|
fn profile_identity_card(projection : MiniTownProjection) -> @bunnia.Node {
  let stats = ownership_stats(projection)
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-profile-card"),
      @bunnia.data(
        "passport-ready",
        if profile_ready_to_publish(projection) {
          "true"
        } else {
          "false"
        },
      ),
    ],
    [
      @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
        @bunnia.text(projection.profile.display_name),
      ]),
      @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
        @bunnia.text(
          "Town passport - \{ready_word(profile_ready_to_publish(projection))}",
        ),
      ]),
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-profile-metrics")],
        profile_metric_chips(projection, stats),
      ),
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-profile-actions")],
        [
          @bunnia.button("Edit Profile", "save-profile"),
          @bunnia.button("Accept Consent", "accept-profile-consent"),
        ],
      ),
    ],
  )
}
