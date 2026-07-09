///|
fn book_shelf_items_for_building(
  projection : MiniTownProjection,
  building_id : String,
) -> Array[MiniTownBookShelfItem] {
  let primary = primary_book_for_shelf(projection, building_id)
  let output : Array[MiniTownBookShelfItem] = []
  for book in visible_books(projection) {
    if book.building_id == building_id {
      let role = if book.id == primary.id { "primary" } else { "support" }
      output.push(book_shelf_item_from_book(book, role))
    }
  }
  output
}

///|
fn book_shelf_item_from_book(
  book : MiniTownBook,
  role : String,
) -> MiniTownBookShelfItem {
  mini_town_book_shelf_item(
    id="\{role}-\{book.id}",
    book_id=book.id,
    building_id=book.building_id,
    role~,
    title=book.title,
    safe_summary=safe_book_summary(book),
    visibility=book.visibility,
    status=book.status,
    accepted_memory_count=book.accepted_memory_count,
    pending_review_count=book.pending_review_count,
    target_ref="book:\{book.id}",
  )
}
