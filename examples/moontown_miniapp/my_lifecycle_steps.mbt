///|
fn publication_step_list(
  steps : Array[MiniTownPublicationStep],
) -> @bunnia.Node {
  @bunnia.windowed_list(
    steps,
    total_count=steps.length(),
    render=publication_step_entry,
  )
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
