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
    building_primary_actions(building),
    @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
      @bunnia.text(
        "\{building_capability_label(projection, building)} - Primary book: \{book.title}",
      ),
    ]),
  ])
}

///|
fn building_primary_actions(building : MiniTownBuilding) -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-object-primary-actions"),
      @bunnia.data("building-id", building.id),
    ],
    [
      @bunnia.button("Ask", "ask-selected-building"),
      @bunnia.button("Messages", "tab-messages"),
      @bunnia.button("Find Similar", "tab-discover"),
    ],
  )
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
fn object_section(
  section_id~ : String,
  title~ : String,
  note~ : String,
  children~ : Array[@bunnia.Node],
  extra_class? : String = "",
) -> @bunnia.Node {
  let class_name = if extra_class == "" {
    "moontown-object-section"
  } else {
    "moontown-object-section \{extra_class}"
  }
  let output = [
    @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
      @bunnia.text(title),
    ]),
    @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
      @bunnia.text(note),
    ]),
  ]
  for child in children {
    output.push(child)
  }
  @bunnia.view_with_attrs(
    [@bunnia.class_name(class_name), @bunnia.data("object-section", section_id)],
    output,
  )
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
