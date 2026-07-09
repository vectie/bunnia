///|
pub fn unified_discovery_results(
  projection : MiniTownProjection,
) -> Array[MiniTownDiscoveryItem] {
  let output : Array[MiniTownDiscoveryItem] = []
  for building in search_results(projection) {
    output.push(
      mini_town_discovery_item(
        id="building-\{building.id}",
        kind="building",
        title=building.title,
        summary=building.summary,
        target_ref="building:\{building.id}",
        visibility=building.visibility,
        status=building.status,
      ),
    )
  }
  for book in visible_books(projection) {
    if book.visibility == "published" &&
      mini_town_book_match(projection.search_query, book) {
      output.push(
        mini_town_discovery_item(
          id="book-\{book.id}",
          kind="book",
          title=book.title,
          summary=book.summary,
          target_ref="book:\{book.id}",
          visibility=book.visibility,
          status=book.status,
        ),
      )
    }
  }
  for item in projection.discovery_items {
    if mini_town_discovery_visible_for(projection, item) &&
      mini_town_discovery_match(projection.search_query, item) {
      output.push(item)
    }
  }
  output
}

///|
pub fn discovery_results_by_kind(
  projection : MiniTownProjection,
  kind : String,
) -> Array[MiniTownDiscoveryItem] {
  let output : Array[MiniTownDiscoveryItem] = []
  for item in unified_discovery_results(projection) {
    if item.kind == kind {
      output.push(item)
    }
  }
  output
}

///|
pub fn market_discovery_results(
  projection : MiniTownProjection,
) -> Array[MiniTownDiscoveryItem] {
  let output : Array[MiniTownDiscoveryItem] = []
  for item in unified_discovery_results(projection) {
    if item.kind == "product" ||
      item.kind == "demand" ||
      item.kind == "event" ||
      item.kind == "post" {
      output.push(item)
    }
  }
  output
}
