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
fn ownership_lifecycle_panel(projection : MiniTownProjection) -> @bunnia.Node {
  lifecycle_panel_with_events(
    "Publishing Shelf",
    "Drafts, shares, review steps, published places, and archives stay visible here.",
    publication_steps(projection),
    owned_audit_events(projection),
  )
}

///|
fn lifecycle_panel_with_events(
  title : String,
  note : String,
  steps : Array[MiniTownPublicationStep],
  events : Array[MiniTownAuditEvent],
) -> @bunnia.Node {
  let children = [
    @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-title")], [
      @bunnia.text(title),
    ]),
    @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-note")], [
      @bunnia.text(note),
    ]),
  ]
  if steps.length() > 0 {
    children.push(
      @bunnia.windowed_list(
        steps,
        total_count=steps.length(),
        render=publication_step_entry,
      ),
    )
  }
  children.push(
    @bunnia.windowed_list(
      events,
      total_count=events.length(),
      render=audit_entry,
    ),
  )
  @bunnia.view_with_attrs([@bunnia.class_name("mt-panel")], children)
}

///|
fn publication_step_entry(item : MiniTownPublicationStep) -> @bunnia.Node {
  @bunnia.keyed(
    "publication-step-\{item.id}",
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name(
          "moontown-publication-step bunnia-status-\{item.status}",
        ),
        @bunnia.data("publication-step", item.id),
        @bunnia.data("current", if item.current { "true" } else { "false" }),
        @bunnia.data("complete", if item.complete { "true" } else { "false" }),
        @bunnia.data("blocked", if item.blocked { "true" } else { "false" }),
      ],
      [
        @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
          @bunnia.text(item.label),
        ]),
        @bunnia.text(item.summary),
      ],
    ),
  )
}

///|
fn audit_entry(item : MiniTownAuditEvent) -> @bunnia.Node {
  @bunnia.keyed(
    "audit-\{item.id}",
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("moontown-audit-entry bunnia-status-\{item.status}"),
        @bunnia.data("building-id", item.building_id),
      ],
      [
        @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
          @bunnia.text(item.title),
        ]),
        @bunnia.text(item.summary),
        @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
          @bunnia.text(
            "\{ownership_event_label(item.kind)} - \{town_visibility_label(item.visibility)} - \{town_status_label(item.status)}",
          ),
        ]),
      ],
    ),
  )
}

///|
fn ownership_event_label(kind : String) -> String {
  if kind == "create" {
    "Created"
  } else if kind == "update" {
    "Updated"
  } else if kind == "share" {
    "Shared"
  } else if kind == "submit" {
    "Submitted"
  } else if kind == "publish" {
    "Published"
  } else if kind == "archive" {
    "Archived"
  } else if kind == "restore" {
    "Restored"
  } else {
    "Changed"
  }
}

///|
fn profile_panel(projection : MiniTownProjection) -> @bunnia.Node {
  let stats = ownership_stats(projection)
  let items = filtered_ownership_items(projection)
  let alerts = workbench_alerts(projection)
  @bunnia.view_with_attrs([@bunnia.class_name("mt-panel")], [
    @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-title")], [
      @bunnia.text("My Inventory"),
    ]),
    @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-note")], [
      @bunnia.text(
        "Owned shelves, alerts, and \{items.length()} items are ready to manage.",
      ),
    ]),
    profile_identity_card(projection),
    @bunnia.windowed_list(
      alerts,
      total_count=alerts.length(),
      render=workbench_alert_entry,
    ),
    public_passport_panel(projection),
    inventory_shelves_panel(projection),
    @bunnia.windowed_list(
      stats,
      total_count=stats.length(),
      render=ownership_stat_entry,
    ),
    @bunnia.view_with_attrs(
      [@bunnia.class_name("moontown-ownership-filters")],
      [
        @bunnia.windowed_list(
          projection.ownership_filters,
          total_count=projection.ownership_filters.length(),
          render=filter => {
            ownership_filter_chip(filter, projection.active_ownership_filter_id)
          },
        ),
      ],
    ),
    @bunnia.windowed_list(
      items,
      total_count=items.length(),
      render=ownership_item_entry,
    ),
    profile_credential_plaque(projection),
    inventory_refresh_plaque(projection),
    reviewer_tools_panel(projection),
  ])
}

///|
fn reviewer_tools_panel(projection : MiniTownProjection) -> @bunnia.Node {
  if projection.reviewer_tools_open {
    operations_desk_panel(projection)
  } else {
    reviewer_tools_gate_panel()
  }
}

///|
fn reviewer_tools_gate_panel() -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-credential-plaque"),
      @bunnia.data("reviewer-tools-gate", "closed"),
    ],
    [
      @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
        @bunnia.text("Reviewer Tools"),
      ]),
      @bunnia.text(
        "Safety checks and launch tools stay behind a deliberate reviewer entry.",
      ),
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-community-actions")],
        [reviewer_tools_open_button()],
      ),
    ],
  )
}

///|
fn reviewer_tools_open_button() -> @bunnia.Node {
  @bunnia.node(
    kind="button",
    attrs=[@bunnia.data("bunnia-route", "pages/moontown/reviewer")],
    events=[@bunnia.tap("open-reviewer-tools")],
    children=[@bunnia.text("Open Reviewer Tools")],
  )
}

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
      @bunnia.text("Bring in owned places, books, agents, pins, and alerts."),
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

///|
fn ownership_backend_step(
  projection : MiniTownProjection,
) -> MiniTownBackendStep {
  for step in projection.backend_steps {
    if step.id == "ownership" {
      return step
    }
  }
  mini_town_backend_step(
    id="ownership",
    label="Refresh My Stuff",
    endpoint_id="load-ownership-snapshot",
    http_method="GET",
    path="/miniapp/me/ownership",
    summary="Pull owned buildings, books, agents, placements, and alerts for My.",
    status="ready",
  )
}

///|
fn ownership_cache_state(
  projection : MiniTownProjection,
) -> MiniTownBackendCacheState {
  for cache in projection.backend_cache_states {
    if cache.id == "ownership" {
      return cache
    }
  }
  mini_town_backend_cache_state(
    id="ownership",
    label="Ownership Snapshot",
    source="cache",
    state="idle",
    summary="My can reload owned buildings, books, agents, placements, and alerts.",
    target_ref="backend:load-ownership-snapshot",
    action_label="Sync",
    action_message="load-ownership-snapshot",
  )
}

///|
fn workbench_alert_entry(alert : MiniTownWorkbenchAlert) -> @bunnia.Node {
  @bunnia.keyed(
    "workbench-alert-\{alert.id}",
    @bunnia.node(
      kind="view",
      attrs=[
        @bunnia.class_name(
          "moontown-workbench-alert bunnia-status-\{alert.status}",
        ),
        @bunnia.data("workbench-alert", alert.id),
        @bunnia.data("severity", alert.severity),
        @bunnia.data("status", alert.status),
      ],
      events=[@bunnia.event("tap", alert.action_message)],
      children=[
        @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
          @bunnia.text(alert.title),
        ]),
        @bunnia.text(alert.summary),
        @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
          @bunnia.text(
            "\{town_status_label(alert.status)} - \{alert.action_label}",
          ),
        ]),
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

///|
fn public_passport_panel(projection : MiniTownProjection) -> @bunnia.Node {
  let items = public_passport_items(projection)
  let published = ownership_stat_value(ownership_stats(projection), "published")
  let watches = visible_watches(projection).length()
  let reviews = pending_reviews(projection).length()
  let published_label = empty_count_label(
    published, "No published places", "published place", "published places",
  )
  let watch_label = optional_count_label(watches, "watch", "watches")
  let review_label = optional_count_label(reviews, "review", "reviews")
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-credential-plaque"),
      @bunnia.data("passport-section", "public"),
      @bunnia.data("passport-count", items.length().to_string()),
    ],
    [
      @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
        @bunnia.text("Public Passport"),
      ]),
      @bunnia.text("Public-facing identity without private work."),
      @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
        @bunnia.text("\{published_label} - \{watch_label} - \{review_label}"),
      ]),
      @bunnia.windowed_list(
        items,
        total_count=items.length(),
        render=public_passport_entry,
      ),
    ],
  )
}

///|
fn public_passport_items(
  projection : MiniTownProjection,
) -> Array[MiniTownOwnershipItem] {
  let stats = ownership_stats(projection)
  let published = ownership_stat_value(stats, "published")
  let watches = visible_watches(projection)
  let reviews = pending_reviews(projection)
  let profile_ready = profile_ready_to_publish(projection)
  [
    mini_town_ownership_item(
      id="passport-profile",
      kind="profile",
      title=if profile_ready { "Profile ready" } else { "Profile incomplete" },
      summary=if profile_ready {
        "Role, consent, and saved profile can publish."
      } else {
        "Finish role, consent, and profile setup."
      },
      target_ref="profile:\{projection.profile.user_id}",
      visibility="public",
      status=if profile_ready { "ready" } else { "blocked" },
      action_label="Save",
      action_message="save-profile",
    ),
    mini_town_ownership_item(
      id="passport-published",
      kind="building",
      title=empty_count_label(
        published, "No published places", "published place", "published places",
      ),
      summary="Public buildings can be discovered and placed.",
      target_ref="building:published",
      visibility="public",
      status=if published > 0 { "ready" } else { "empty" },
      action_label="Discover",
      action_message="tab-discover",
    ),
    mini_town_ownership_item(
      id="passport-watches",
      kind="watch",
      title=count_label(
        watches.length(),
        "watched town link",
        "watched town links",
      ),
      summary="Watched places stay attached to Realm.",
      target_ref=if watches.length() > 0 {
        watches[0].target_ref
      } else {
        "watch:none"
      },
      visibility="public",
      status=if watches.length() > 0 { "watching" } else { "empty" },
      action_label=if watches.length() > 0 { "Open" } else { "Discover" },
      action_message=if watches.length() > 0 {
        watches[0].action_message
      } else {
        "tab-discover"
      },
    ),
    mini_town_ownership_item(
      id="passport-reviews",
      kind="review",
      title=count_label(reviews.length(), "review signal", "review signals"),
      summary="Review requests show accountable agent work.",
      target_ref="review:pending",
      visibility="public",
      status=if reviews.length() > 0 { "review" } else { "clear" },
      action_label="Messages",
      action_message="tab-messages",
    ),
  ]
}

///|
fn public_passport_entry(item : MiniTownOwnershipItem) -> @bunnia.Node {
  @bunnia.keyed(
    "public-passport-\{item.id}",
    @bunnia.node(
      kind="view",
      attrs=[
        @bunnia.class_name("moontown-owned-entry bunnia-status-\{item.status}"),
        @bunnia.data("passport-kind", item.kind),
      ],
      events=[@bunnia.event("tap", item.action_message)],
      children=[
        @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
          @bunnia.text(item.title),
        ]),
        @bunnia.text(item.summary),
        @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
          @bunnia.text(
            "\{town_kind_label(item.kind)} - \{town_visibility_label(item.visibility)} - \{item.action_label}",
          ),
        ]),
      ],
    ),
  )
}

///|
fn profile_credential_plaque(projection : MiniTownProjection) -> @bunnia.Node {
  let district = profile_credential_district(projection)
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-credential-plaque"),
      @bunnia.data("district-id", district.id),
      @bunnia.data("feature-kind", district.feature_kind),
      @bunnia.data("target-building-id", district.building_id),
      @bunnia.data("status", district.status),
    ],
    [
      @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
        @bunnia.text("Town Credential"),
      ]),
      @bunnia.text("\{district.title}: \{district.summary}"),
      @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
        @bunnia.text(
          "\{district.stat_value} \{district.stat_label} - \{town_status_label(district.status)}",
        ),
      ]),
      open_place_button(district.building_id),
    ],
  )
}

///|
fn profile_credential_district(
  projection : MiniTownProjection,
) -> MiniTownDistrict {
  for district in projection.districts {
    if district.feature_kind == "credential" {
      return district
    }
  }
  projection.districts[0]
}

///|
fn ownership_stat_value(
  stats : Array[MiniTownOwnershipStat],
  id : String,
) -> Int {
  for stat in stats {
    if stat.id == id {
      return stat.value
    }
  }
  0
}

///|
fn ownership_filter_chip(
  filter : MiniTownOwnershipFilter,
  active_filter_id : String,
) -> @bunnia.Node {
  @bunnia.keyed(
    "ownership-filter-\{filter.id}",
    @bunnia.node(
      kind="view",
      attrs=[
        @bunnia.class_name(
          if filter.id == active_filter_id {
            "moontown-ownership-filter active"
          } else {
            "moontown-ownership-filter"
          },
        ),
        @bunnia.data("ownership-filter-id", filter.id),
      ],
      events=[@bunnia.event("tap", "ownership-filter-\{filter.id}")],
      children=[@bunnia.text(filter.label)],
    ),
  )
}

///|
fn ownership_stat_entry(stat : MiniTownOwnershipStat) -> @bunnia.Node {
  @bunnia.keyed(
    "ownership-stat-\{stat.id}",
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("moontown-owned-entry"),
        @bunnia.data("ownership-stat", stat.id),
      ],
      [
        @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
          @bunnia.text(stat.label),
        ]),
        @bunnia.text(stat.value.to_string()),
      ],
    ),
  )
}

///|
fn ownership_item_entry(item : MiniTownOwnershipItem) -> @bunnia.Node {
  @bunnia.keyed(
    "owned-\{item.id}",
    @bunnia.node(
      kind="view",
      attrs=[
        @bunnia.class_name("moontown-owned-entry"),
        @bunnia.data("ownership-kind", item.kind),
        @bunnia.data(
          "ownership-destination",
          town_tab_label(ownership_item_target_tab(item)),
        ),
      ],
      events=[@bunnia.event("tap", item.action_message)],
      children=[
        @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
          @bunnia.text(item.title),
        ]),
        @bunnia.text(item.summary),
        @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
          @bunnia.text(
            "\{town_kind_label(item.kind)} - \{town_visibility_label(item.visibility)} - \{item.action_label} in \{town_tab_label(ownership_item_target_tab(item))}",
          ),
        ]),
        ownership_item_place_button(item),
      ],
    ),
  )
}

///|
fn ownership_item_place_button(item : MiniTownOwnershipItem) -> @bunnia.Node {
  let building_id = ownership_item_building_id(item)
  if high_leverage_place_route(building_id) {
    open_place_button(building_id)
  } else {
    @bunnia.view([])
  }
}

///|
fn ownership_item_building_id(item : MiniTownOwnershipItem) -> String {
  if item.target_ref.has_prefix("building:") {
    item.target_ref.sub(start=9, end=item.target_ref.length()).to_owned()
  } else if item.action_message.has_prefix("select-") {
    item.action_message
    .sub(start=7, end=item.action_message.length())
    .to_owned()
  } else {
    ""
  }
}

///|
fn ownership_item_target_tab(item : MiniTownOwnershipItem) -> String {
  if item.action_message.has_prefix("tab-") {
    item.action_message
    .sub(start=4, end=item.action_message.length())
    .to_owned()
  } else if item.action_message.has_prefix("select-") {
    "realm"
  } else if item.action_message.contains("building") ||
    item.action_message.contains("publish") ||
    item.action_message.contains("archive") ||
    item.action_message.contains("restore") {
    "my"
  } else {
    "my"
  }
}
