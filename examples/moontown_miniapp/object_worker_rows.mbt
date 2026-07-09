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
        worker_title(agent),
        @bunnia.text(run.summary),
        worker_meta(projection, agent, run),
        worker_actions(run),
      ],
    ),
  )
}

///|
fn worker_title(agent : MiniTownAgent) -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
    @bunnia.text(agent.name),
  ])
}

///|
fn worker_meta(
  projection : MiniTownProjection,
  agent : MiniTownAgent,
  run : MiniTownRun,
) -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
    @bunnia.text(worker_meta_copy(projection, agent, run)),
  ])
}

///|
fn worker_actions(run : MiniTownRun) -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-run-actions")], [
    @bunnia.button("Message", "tab-messages"),
    if run.review_required {
      @bunnia.button("Review Work", "tab-messages")
    } else {
      @bunnia.button("Ask", "ask-selected-building")
    },
  ])
}
