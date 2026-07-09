///|
fn selected_building_drawer(projection : MiniTownProjection) -> @bunnia.Node {
  let building = selected_building(projection)
  let book = selected_building_book(projection)
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name(
        "moontown-building-drawer moontown-object-drawer bunnia-status-\{building.status}",
      ),
      @bunnia.data("object-drawer", "building"),
      @bunnia.data("building-id", building.id),
    ],
    [
      building_object_header(projection, building, book),
      safety_report_button(projection, building),
      building_memory_section(projection),
      building_worker_section(projection),
      building_lifecycle_section(projection),
      building_context_section(projection),
    ],
  )
}

///|
fn building_object_header(
  projection : MiniTownProjection,
  building : MiniTownBuilding,
  book : MiniTownBook,
) -> @bunnia.Node {
  let shelf = selected_building_book_shelf(projection)
  let agents = selected_building_agents(projection)
  let runs = selected_building_runs(projection)
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-object-header")], [
    @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
      @bunnia.text(building.title),
    ]),
    @bunnia.text(building.summary),
    @bunnia.view_with_attrs([@bunnia.class_name("moontown-object-badges")], [
      object_badge("category", town_kind_label(building.kind)),
      object_badge("owner", building_owner_label(projection, building)),
      object_badge("visibility", town_visibility_label(building.visibility)),
      object_badge("status", town_status_label(building.status)),
    ]),
    object_stats_row(shelf, agents, runs),
    @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
      @bunnia.text(
        "\{building_capability_label(projection, building)} - Primary book: \{book.title}",
      ),
    ]),
  ])
}

///|
fn object_stats_row(
  shelf : Array[MiniTownBookShelfItem],
  agents : Array[MiniTownAgent],
  runs : Array[MiniTownRun],
) -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [@bunnia.class_name("mt-meta moontown-object-stats")],
    [
      @bunnia.text(
        "\{count_label(shelf.length(), "book", "books")} - \{count_label(agents.length(), "worker", "workers")} - \{count_label(runs.length(), "work item", "work items")}",
      ),
    ],
  )
}

///|
fn object_badge(kind : String, label : String) -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [@bunnia.class_name("moontown-object-badge kind-\{kind}")],
    [@bunnia.text(label)],
  )
}

///|
fn building_memory_section(projection : MiniTownProjection) -> @bunnia.Node {
  let shelf = selected_building_book_shelf(projection)
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-object-section moontown-memory-shelf"),
      @bunnia.data("object-section", "memory-shelf"),
    ],
    [
      @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
        @bunnia.text("Memory Shelf"),
      ]),
      @bunnia.windowed_list(
        shelf,
        total_count=shelf.length(),
        render=book_shelf_entry,
      ),
    ],
  )
}

///|
fn building_worker_section(projection : MiniTownProjection) -> @bunnia.Node {
  let agents = selected_building_agents(projection)
  let building = selected_building(projection)
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-object-section moontown-worker-section"),
      @bunnia.data("object-section", "worker"),
      @bunnia.data("building-id", building.id),
    ],
    [
      @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
        @bunnia.text("Agent Workers"),
      ]),
      if agents.length() == 0 {
        @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
          @bunnia.text("No agent worker is attached yet."),
        ])
      } else {
        @bunnia.list(agents, agent => building_worker_entry(projection, agent))
      },
    ],
  )
}

///|
fn building_worker_entry(
  projection : MiniTownProjection,
  agent : MiniTownAgent,
) -> @bunnia.Node {
  let run = latest_agent_run(projection, agent)
  @bunnia.keyed(
    "worker-\{agent.id}",
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name(
          "moontown-worker-entry bunnia-status-\{agent.status}",
        ),
      ],
      [
        @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
          @bunnia.text(agent.name),
        ]),
        @bunnia.text(run.summary),
        @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
          @bunnia.text(
            "\{town_status_label(agent.status)} - Latest work: \{run.title} - \{book_title_by_id(projection, run.book_id)}",
          ),
        ]),
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-run-actions")], [
          @bunnia.button("Message", "tab-messages"),
          if run.review_required {
            @bunnia.button("Review Work", "tab-messages")
          } else {
            @bunnia.button("Ask", "ask-selected-building")
          },
        ]),
      ],
    ),
  )
}

///|
fn latest_agent_run(
  projection : MiniTownProjection,
  agent : MiniTownAgent,
) -> MiniTownRun {
  for run in selected_building_runs(projection) {
    if run.agent_id == agent.id {
      return run
    }
  }
  selected_building_latest_run(projection)
}

///|
fn building_lifecycle_section(projection : MiniTownProjection) -> @bunnia.Node {
  let actions = selected_building_lifecycle_actions(projection)
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-object-section moontown-lifecycle-section"),
      @bunnia.data("object-section", "lifecycle"),
    ],
    [
      @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
        @bunnia.text("Lifecycle Stamps"),
      ]),
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-lifecycle-actions")],
        [@bunnia.list(actions, lifecycle_action_button)],
      ),
    ],
  )
}

///|
fn building_context_section(projection : MiniTownProjection) -> @bunnia.Node {
  let building = selected_building(projection)
  let messages = selected_building_messages(projection)
  let runs = selected_building_runs(projection)
  let events = selected_building_audit_events(projection)
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-object-section moontown-chat-drawer"),
      @bunnia.data("object-section", "communication"),
      @bunnia.data("building-id", building.id),
    ],
    [
      @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
        @bunnia.text("Communication Context"),
      ]),
      @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
        @bunnia.text(
          "Latest message, agent work, and review trail stay tied to this place.",
        ),
      ]),
      @bunnia.windowed_list(messages, total_count=messages.length(), render=message => {
        building_message_entry(projection, message)
      }),
      @bunnia.windowed_list(runs, total_count=runs.length(), render=run => {
        building_run_entry(projection, run)
      }),
      @bunnia.windowed_list(
        events,
        total_count=events.length(),
        render=audit_entry,
      ),
      @bunnia.form("send-building-message", [
        @bunnia.input(
          name="chatDraft.body",
          value="Can it publish an agent?",
          input_message="edit-chat-draft",
        ),
        @bunnia.button("Send", "send-building-message"),
      ]),
    ],
  )
}

///|
fn building_message_entry(
  projection : MiniTownProjection,
  message : MiniTownMessage,
) -> @bunnia.Node {
  let building = selected_building(projection)
  @bunnia.keyed(
    "building-message-\{message.id}",
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("moontown-object-message"),
        @bunnia.data("building-id", building.id),
      ],
      [
        @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
          @bunnia.text(message_actor_label(projection, message.actor_id)),
        ]),
        @bunnia.text(message.text),
        @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
          @bunnia.text("Place message - \{building.title}"),
        ]),
      ],
    ),
  )
}

///|
fn building_run_entry(
  projection : MiniTownProjection,
  run : MiniTownRun,
) -> @bunnia.Node {
  @bunnia.keyed(
    "building-run-\{run.id}",
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("moontown-run-entry bunnia-status-\{run.status}"),
        @bunnia.data("building-id", run.building_id),
      ],
      [
        @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
          @bunnia.text(run.title),
        ]),
        @bunnia.text(run.summary),
        @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
          @bunnia.text(
            "\{town_status_label(run.status)} - \{message_actor_label(projection, run.agent_id)} - \{book_title_by_id(projection, run.book_id)}",
          ),
        ]),
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-run-actions")], [
          if run.review_required {
            @bunnia.button("Review Work", "tab-messages")
          } else {
            @bunnia.button("Open Work", "tab-messages")
          },
          @bunnia.button("Ask", "ask-selected-building"),
        ]),
      ],
    ),
  )
}

///|
fn message_actor_label(
  projection : MiniTownProjection,
  actor_id : String,
) -> String {
  if actor_id == projection.active_user_id {
    projection.profile.display_name
  } else if actor_id == "system" {
    "Town notice"
  } else {
    agent_name(projection, actor_id)
  }
}

///|
fn selected_building_latest_run(projection : MiniTownProjection) -> MiniTownRun {
  let runs = selected_building_runs(projection)
  if runs.length() > 0 {
    runs[0]
  } else {
    projection.runs[0]
  }
}

///|
fn building_owner_label(
  projection : MiniTownProjection,
  building : MiniTownBuilding,
) -> String {
  if building.owner_id == projection.active_user_id {
    "Owner"
  } else if building.visibility == "shared_private" {
    "Team member"
  } else {
    "Visitor"
  }
}

///|
fn building_capability_label(
  projection : MiniTownProjection,
  building : MiniTownBuilding,
) -> String {
  if building.visibility == "archived" {
    "Archived; owner can restore"
  } else if building.owner_id == projection.active_user_id &&
    (
      building.visibility == "private_draft" ||
      building.visibility == "shared_private"
    ) {
    "Owner can edit, share, and submit"
  } else if building.visibility == "published" {
    "Public place can be opened and placed"
  } else if building.visibility == "submitted" {
    "Waiting for review decision"
  } else {
    "Open for safe reading"
  }
}

///|
fn safety_report_button(
  projection : MiniTownProjection,
  building : MiniTownBuilding,
) -> @bunnia.Node {
  let cases = selected_building_moderation_cases(projection)
  @bunnia.node(
    kind="button",
    attrs=[
      @bunnia.class_name("moontown-notice-action"),
      @bunnia.data("safety-report-building", building.id),
      @bunnia.data("safety-report-count", cases.length().to_string()),
    ],
    events=[@bunnia.tap("report-public-building")],
    children=[@bunnia.text("Report Concern")],
  )
}

///|
fn book_shelf_entry(item : MiniTownBookShelfItem) -> @bunnia.Node {
  let memory_label = count_label(
    item.accepted_memory_count,
    "memory",
    "memories",
  )
  let review_label = optional_count_label(
    item.pending_review_count,
    "review",
    "reviews",
  )
  @bunnia.keyed(
    "book-shelf-\{item.id}",
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("moontown-book-entry bunnia-status-\{item.status}"),
        @bunnia.data("book-shelf-role", item.role),
        @bunnia.data("building-id", item.building_id),
      ],
      [
        @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
          @bunnia.text("\{item.title}"),
        ]),
        @bunnia.text(item.safe_summary),
        @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
          @bunnia.text(
            "\{memory_label} - \{review_label} - \{town_status_label(item.status)}",
          ),
        ]),
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-run-actions")], [
          @bunnia.button("Read", "select-\{item.building_id}"),
          if item.pending_review_count > 0 {
            @bunnia.button("Review", "tab-messages")
          } else {
            @bunnia.button("Open Place", "select-\{item.building_id}")
          },
        ]),
      ],
    ),
  )
}

///|
fn lifecycle_action_button(action : MiniTownLifecycleAction) -> @bunnia.Node {
  let button_attrs = [
    @bunnia.class_name("moontown-lifecycle-action \{action.status}"),
    @bunnia.data("lifecycle-action", action.id),
    @bunnia.data("building-id", lifecycle_action_building_id(action)),
    @bunnia.data("allowed", if action.allowed { "true" } else { "false" }),
  ]
  if !action.allowed {
    button_attrs.push(@bunnia.attr("disabled", "true"))
  }
  @bunnia.keyed(
    "lifecycle-action-\{action.id}",
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name(
          "moontown-lifecycle-stamp bunnia-status-\{action.status}",
        ),
      ],
      [
        @bunnia.node(
          kind="button",
          attrs=button_attrs,
          events=[@bunnia.event("tap", action.message)],
          children=[@bunnia.text(action.label)],
        ),
        @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
          @bunnia.text(lifecycle_reason_label(action.reason)),
        ]),
      ],
    ),
  )
}

///|
fn lifecycle_reason_label(reason : String) -> String {
  if reason == "owner only" {
    "Owner only"
  } else if reason == "profile setup needed" {
    "Finish profile first"
  } else if reason == "book linked" {
    "Book linked"
  } else if reason == "published building" {
    "Published place"
  } else if reason == "ready for review" {
    "Ready for review"
  } else if reason == "review accepted" {
    "Review accepted"
  } else if reason == "owner action" {
    "Owner action"
  } else if reason == "already archived" {
    "Already archived"
  } else if reason == "already active" {
    "Already active"
  } else if reason == "draft editable" {
    "Draft editable"
  } else if reason == "locked after submit" {
    "Locked after submit"
  } else if reason == "not submitted" {
    "Submit first"
  } else {
    reason
  }
}

///|
fn lifecycle_action_building_id(action : MiniTownLifecycleAction) -> String {
  action.target_ref.replace_all(old="building:", new="")
}
