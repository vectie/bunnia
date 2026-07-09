///|
fn update_selected_building_lifecycle(
  projection : MiniTownProjection,
  visibility~ : String,
  status~ : String,
  kind~ : String,
  title~ : String,
  summary~ : String,
) -> MiniTownProjection {
  let selected_id = projection.selected_building_id
  {
    ..projection,
    buildings: update_building_lifecycle(
      projection.buildings,
      selected_id,
      visibility,
      status,
    ),
    books: update_book_lifecycle(
      projection.books,
      selected_id,
      visibility,
      status,
    ),
    audit_events: projection.audit_events +
    [
      lifecycle_event(
        id="audit-\{kind}-\{selected_id}",
        kind~,
        title~,
        summary~,
        actor_id=projection.active_user_id,
        building_id=selected_id,
        status~,
        visibility~,
      ),
    ],
  }
}

///|
fn update_building_lifecycle(
  buildings : Array[MiniTownBuilding],
  building_id : String,
  visibility : String,
  status : String,
) -> Array[MiniTownBuilding] {
  let output : Array[MiniTownBuilding] = []
  for building in buildings {
    if building.id == building_id {
      output.push({ ..building, visibility, status })
    } else {
      output.push(building)
    }
  }
  output
}

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
fn update_building_profile(
  buildings : Array[MiniTownBuilding],
  building_id : String,
  title : String,
  summary : String,
  tags : Array[String],
) -> Array[MiniTownBuilding] {
  let output : Array[MiniTownBuilding] = []
  for building in buildings {
    if building.id == building_id {
      output.push({ ..building, title, summary, tags })
    } else {
      output.push(building)
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

///|
fn lifecycle_event(
  id~ : String,
  kind~ : String,
  title~ : String,
  summary~ : String,
  actor_id~ : String,
  building_id~ : String,
  status~ : String,
  visibility~ : String,
) -> MiniTownAuditEvent {
  mini_town_audit_event(
    id~,
    kind~,
    title~,
    summary~,
    actor_id~,
    target_ref="building:\{building_id}",
    building_id~,
    status~,
    visibility~,
    timestamp="local-dev",
  )
}

///|
