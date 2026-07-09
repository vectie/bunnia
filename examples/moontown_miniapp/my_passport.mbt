///|
fn identity_setup_panel(projection : MiniTownProjection) -> @bunnia.Node {
  let gates = setup_gates(projection)
  @bunnia.view_with_attrs([@bunnia.class_name("mt-panel")], [
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

///|
fn setup_gate_entry(item : MiniTownSetupGate) -> @bunnia.Node {
  @bunnia.keyed(
    "setup-gate-\{item.id}",
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("moontown-setup-gate bunnia-status-\{item.status}"),
        @bunnia.data("setup-gate", item.id),
        @bunnia.data("complete", if item.complete { "true" } else { "false" }),
      ],
      [
        @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
          @bunnia.text(item.label),
        ]),
        @bunnia.text(item.summary),
        @bunnia.button(item.action_label, item.action_message),
      ],
    ),
  )
}

///|
fn role_entry(role : MiniTownRole) -> @bunnia.Node {
  @bunnia.keyed(
    "role-\{role.id}",
    @bunnia.node(
      kind="view",
      attrs=[
        @bunnia.class_name("moontown-role-entry"),
        @bunnia.data("role-id", role.id),
        @bunnia.data("building-id", role.building_id),
      ],
      events=[@bunnia.event("tap", "select-role-\{role.id}")],
      children=[
        @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
          @bunnia.text(role.title),
        ]),
        @bunnia.text(role.summary),
      ],
    ),
  )
}

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
        [
          profile_metric_chip(
            label="Watches",
            value=visible_watches(projection).length(),
          ),
          profile_metric_chip(
            label="Followers",
            value=notification_kind_count(projection, "follow"),
          ),
          profile_metric_chip(
            label="Reviews",
            value=pending_reviews(projection).length(),
          ),
          profile_metric_chip(
            label="Published",
            value=ownership_stat_value(stats, "published"),
          ),
        ],
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

///|
fn profile_metric_chip(label~ : String, value~ : Int) -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-profile-metric")], [
    @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
      @bunnia.text(value.to_string()),
    ]),
    @bunnia.text(label),
  ])
}
