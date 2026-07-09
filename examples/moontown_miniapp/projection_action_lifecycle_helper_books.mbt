///|
fn update_book_lifecycle(
  books : Array[MiniTownBook],
  building_id : String,
  visibility : String,
  status : String,
) -> Array[MiniTownBook] {
  let output : Array[MiniTownBook] = []
  for book in books {
    if book.building_id == building_id {
      output.push({ ..book, visibility, status })
    } else {
      output.push(book)
    }
  }
  output
}

///|
fn update_book_profile(
  books : Array[MiniTownBook],
  building_id : String,
  title : String,
  summary : String,
) -> Array[MiniTownBook] {
  let output : Array[MiniTownBook] = []
  for book in books {
    if book.building_id == building_id {
      output.push({ ..book, title, summary })
    } else {
      output.push(book)
    }
  }
  output
}

///|
fn update_book_lifecycle_with_review_delta(
  books : Array[MiniTownBook],
  building_id : String,
  visibility : String,
  status : String,
  review_delta : Int,
) -> Array[MiniTownBook] {
  let output : Array[MiniTownBook] = []
  for book in books {
    if book.building_id == building_id {
      output.push({
        ..book,
        visibility,
        status,
        pending_review_count: clamp_pending_review(
          book.pending_review_count + review_delta,
        ),
      })
    } else {
      output.push(book)
    }
  }
  output
}

///|
fn decrement_book_pending_review(
  books : Array[MiniTownBook],
  book_id : String,
) -> Array[MiniTownBook] {
  let output : Array[MiniTownBook] = []
  for book in books {
    if book.id == book_id {
      output.push({
        ..book,
        pending_review_count: clamp_pending_review(
          book.pending_review_count - 1,
        ),
      })
    } else {
      output.push(book)
    }
  }
  output
}

///|
fn clamp_pending_review(value : Int) -> Int {
  if value < 0 {
    0
  } else {
    value
  }
}
