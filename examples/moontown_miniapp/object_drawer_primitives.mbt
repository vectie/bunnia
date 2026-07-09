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
