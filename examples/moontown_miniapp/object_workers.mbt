///|
fn building_worker_section(projection : MiniTownProjection) -> @bunnia.Node {
  let agents = selected_building_agents(projection)
  let building = selected_building(projection)
  object_section(
    section_id="worker",
    title="Agent Workers",
    note="Workers show role, status, latest work, and the next message action.",
    extra_class="moontown-worker-section",
    children=[
      @bunnia.view_with_attrs([@bunnia.data("building-id", building.id)], [
        if agents.length() == 0 {
          @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
            @bunnia.text("No agent worker is attached yet."),
          ])
        } else {
          @bunnia.list(agents, agent => building_worker_entry(projection, agent))
        },
      ]),
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
            "Role: \{agent_role_label(agent)} - \{town_status_label(agent.status)} - Latest work: \{run.title} - \{book_title_by_id(projection, run.book_id)}",
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
fn agent_role_label(agent : MiniTownAgent) -> String {
  if agent.name.contains("Guide") {
    "place guide"
  } else if agent.name.contains("Builder") {
    "builder"
  } else if agent.name.contains("Moderator") {
    "reviewer"
  } else {
    "town worker"
  }
}
