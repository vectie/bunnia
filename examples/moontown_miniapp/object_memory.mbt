///|
fn building_memory_section(projection : MiniTownProjection) -> @bunnia.Node {
  let shelf = selected_building_book_shelf(projection)
  object_section(
    section_id="memory-shelf",
    title="Memory Shelf",
    note="Safe book summaries, accepted memory, and review needs stay here.",
    extra_class="moontown-memory-shelf",
    children=[
      @bunnia.windowed_list(
        shelf,
        total_count=shelf.length(),
        render=book_shelf_entry,
      ),
    ],
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
