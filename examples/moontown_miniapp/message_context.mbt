///|
fn failed_run_count(projection : MiniTownProjection) -> Int {
  let mut count = 0
  for run in visible_runs(projection) {
    if run.status == "failed" || run.status == "cancelled" {
      count += 1
    }
  }
  count
}

///|
fn building_title_by_id(
  projection : MiniTownProjection,
  building_id : String,
) -> String {
  for building in visible_buildings(projection) {
    if building.id == building_id {
      return building.title
    }
  }
  building_id
}

///|
fn book_title_by_id(
  projection : MiniTownProjection,
  book_id : String,
) -> String {
  for book in visible_books(projection) {
    if book.id == book_id {
      return book.title
    }
  }
  book_id
}
