///|
fn primary_book_for_shelf(
  projection : MiniTownProjection,
  building_id : String,
) -> MiniTownBook {
  for book in visible_books(projection) {
    if book.building_id == building_id {
      return book
    }
  }
  projection.books[0]
}
