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
