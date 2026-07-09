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
