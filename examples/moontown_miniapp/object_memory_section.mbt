///|
fn building_memory_section(projection : MiniTownProjection) -> @bunnia.Node {
  let shelf = selected_building_book_shelf(projection)
  object_section(
    section_id="memory-shelf",
    title="Memory Shelf",
    note="\{count_label(shelf.length(), "book", "books")} - \{count_label(shelf_pending_review_count(shelf), "review", "reviews")}",
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
fn shelf_pending_review_count(shelf : Array[MiniTownBookShelfItem]) -> Int {
  let mut count = 0
  for item in shelf {
    count += item.pending_review_count
  }
  count
}
