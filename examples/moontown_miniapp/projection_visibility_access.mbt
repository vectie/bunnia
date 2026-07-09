///|
fn mini_town_building_visible_for(
  projection : MiniTownProjection,
  building : MiniTownBuilding,
) -> Bool {
  building.visibility != "archived" &&
  (
    building.visibility == "published" ||
    building.owner_id == projection.active_user_id ||
    building.owner_id == projection.organization_id
  )
}

///|
fn mini_town_book_visible_for(
  projection : MiniTownProjection,
  book : MiniTownBook,
) -> Bool {
  book.visibility == "published" ||
  book.owner_id == projection.active_user_id ||
  book.owner_id == projection.organization_id ||
  mini_town_book_building_visible_for(projection, book)
}

///|
fn mini_town_book_building_visible_for(
  projection : MiniTownProjection,
  book : MiniTownBook,
) -> Bool {
  for building in visible_buildings(projection) {
    if building.id == book.building_id {
      return true
    }
  }
  false
}

///|
fn mini_town_review_visible_for(
  projection : MiniTownProjection,
  item : MiniTownReviewItem,
) -> Bool {
  item.reviewer_id == projection.active_user_id &&
  (
    mini_town_review_run_visible_for(projection, item) ||
    mini_town_review_building_visible_for(projection, item)
  )
}

///|
fn mini_town_review_run_visible_for(
  projection : MiniTownProjection,
  item : MiniTownReviewItem,
) -> Bool {
  for run in visible_runs(projection) {
    if run.id == item.run_id {
      return true
    }
  }
  false
}

///|
fn mini_town_review_building_visible_for(
  projection : MiniTownProjection,
  item : MiniTownReviewItem,
) -> Bool {
  for building in visible_buildings(projection) {
    if building.id == item.building_id {
      return true
    }
  }
  false
}

///|
fn mini_town_run_visible_for(
  projection : MiniTownProjection,
  run : MiniTownRun,
) -> Bool {
  mini_town_run_building_visible_for(projection, run) &&
  mini_town_run_book_visible_for(projection, run)
}

///|
fn mini_town_tool_result_visible_for(
  projection : MiniTownProjection,
  item : MiniTownToolResult,
) -> Bool {
  for building in projection.buildings {
    if building.id == item.building_id {
      return mini_town_building_visible_for(projection, building)
    }
  }
  false
}

///|
fn mini_town_run_building_visible_for(
  projection : MiniTownProjection,
  run : MiniTownRun,
) -> Bool {
  for building in visible_buildings(projection) {
    if building.id == run.building_id {
      return true
    }
  }
  false
}

///|
fn mini_town_run_book_visible_for(
  projection : MiniTownProjection,
  run : MiniTownRun,
) -> Bool {
  if run.book_id == "" {
    true
  } else {
    for book in visible_books(projection) {
      if book.id == run.book_id {
        return true
      }
    }
    false
  }
}

///|
fn mini_town_message_visible_for(
  projection : MiniTownProjection,
  message : MiniTownMessage,
) -> Bool {
  let building_id = mini_town_building_id_from_thread(message.thread_id)
  for building in visible_buildings(projection) {
    if building.id == building_id {
      return true
    }
  }
  false
}

///|
fn mini_town_building_id_from_thread(thread_id : String) -> String {
  thread_id.replace_all(old="thread-", new="")
}
