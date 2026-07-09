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
