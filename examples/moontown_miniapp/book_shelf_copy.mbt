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
