///|
pub fn selected_building_book_shelf(
  projection : MiniTownProjection,
) -> Array[MiniTownBookShelfItem] {
  building_book_shelf(projection, selected_building(projection).id)
}

///|
pub fn building_book_shelf(
  projection : MiniTownProjection,
  building_id : String,
) -> Array[MiniTownBookShelfItem] {
  book_shelf_items_for_building(projection, building_id)
}
