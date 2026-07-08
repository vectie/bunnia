///|
pub struct MiniTownBookShelfItem {
  id : String
  book_id : String
  building_id : String
  role : String
  title : String
  safe_summary : String
  visibility : String
  status : String
  accepted_memory_count : Int
  pending_review_count : Int
  target_ref : String
} derive(Debug, Eq)

///|
pub fn mini_town_book_shelf_item(
  id~ : String,
  book_id~ : String,
  building_id~ : String,
  role~ : String,
  title~ : String,
  safe_summary~ : String,
  visibility~ : String,
  status~ : String,
  accepted_memory_count~ : Int,
  pending_review_count~ : Int,
  target_ref~ : String,
) -> MiniTownBookShelfItem {
  {
    id,
    book_id,
    building_id,
    role,
    title,
    safe_summary,
    visibility,
    status,
    accepted_memory_count,
    pending_review_count,
    target_ref,
  }
}

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
  let primary = selected_building_book_for(projection, building_id)
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
fn selected_building_book_for(
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

///|
fn safe_book_summary(book : MiniTownBook) -> String {
  if book.visibility == "published" {
    book.summary
  } else if book.visibility == "shared_private" {
    "Team-safe summary: \{book.summary}"
  } else {
    "Private owner summary: \{book.summary}"
  }
}
