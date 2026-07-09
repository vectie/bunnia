///|
pub fn visible_buildings(
  projection : MiniTownProjection,
) -> Array[MiniTownBuilding] {
  let output : Array[MiniTownBuilding] = []
  for building in projection.buildings {
    if mini_town_building_visible_for(projection, building) {
      output.push(building)
    }
  }
  output
}

///|
pub fn visible_books(projection : MiniTownProjection) -> Array[MiniTownBook] {
  let output : Array[MiniTownBook] = []
  for book in projection.books {
    if mini_town_book_visible_for(projection, book) {
      output.push(book)
    }
  }
  output
}

///|
pub fn visible_runs(projection : MiniTownProjection) -> Array[MiniTownRun] {
  let output : Array[MiniTownRun] = []
  for run in projection.runs {
    if mini_town_run_visible_for(projection, run) {
      output.push(run)
    }
  }
  output
}

///|
pub fn visible_tool_results(
  projection : MiniTownProjection,
) -> Array[MiniTownToolResult] {
  let output : Array[MiniTownToolResult] = []
  for item in projection.tool_results {
    if mini_town_tool_result_visible_for(projection, item) {
      output.push(item)
    }
  }
  output
}

///|
pub fn tool_result_cards(
  projection : MiniTownProjection,
) -> Array[@bunnia.ToolResultCard] {
  let output : Array[@bunnia.ToolResultCard] = []
  for item in visible_tool_results(projection) {
    output.push(
      @bunnia.tool_result_card(
        id=item.id,
        tool_name=item.tool_name,
        title=item.title,
        summary=item.summary,
        artifact_ref=item.artifact_ref,
        status=item.status,
        open_message=item.open_message,
        acknowledge_message=item.acknowledge_message,
      ),
    )
  }
  output
}

///|
pub fn visible_reviews(
  projection : MiniTownProjection,
) -> Array[MiniTownReviewItem] {
  let output : Array[MiniTownReviewItem] = []
  for item in projection.reviews {
    if mini_town_review_visible_for(projection, item) {
      output.push(item)
    }
  }
  output
}

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

///|
pub fn selected_building(projection : MiniTownProjection) -> MiniTownBuilding {
  for building in projection.buildings {
    if building.id == projection.selected_building_id {
      return building
    }
  }
  projection.buildings[0]
}

///|
pub fn selected_building_book(projection : MiniTownProjection) -> MiniTownBook {
  let selected = selected_building(projection)
  for book in visible_books(projection) {
    if book.building_id == selected.id {
      return book
    }
  }
  projection.books[0]
}

///|
pub fn selected_building_runs(
  projection : MiniTownProjection,
) -> Array[MiniTownRun] {
  let selected = selected_building(projection)
  let output : Array[MiniTownRun] = []
  for run in visible_runs(projection) {
    if run.building_id == selected.id {
      output.push(run)
    }
  }
  output
}

///|
pub fn selected_building_agents(
  projection : MiniTownProjection,
) -> Array[MiniTownAgent] {
  let selected = selected_building(projection)
  let output : Array[MiniTownAgent] = []
  for agent in projection.agents {
    if agent.building_id == selected.id {
      output.push(agent)
    }
  }
  output
}

///|
pub fn visible_messages(
  projection : MiniTownProjection,
) -> Array[MiniTownMessage] {
  let output : Array[MiniTownMessage] = []
  for message in projection.messages {
    if mini_town_message_visible_for(projection, message) {
      output.push(message)
    }
  }
  output
}

///|
pub fn selected_building_messages(
  projection : MiniTownProjection,
) -> Array[MiniTownMessage] {
  let selected = selected_building(projection)
  let thread_id = "thread-\{selected.id}"
  let output : Array[MiniTownMessage] = []
  for message in visible_messages(projection) {
    if message.thread_id == thread_id {
      output.push(message)
    }
  }
  output
}
