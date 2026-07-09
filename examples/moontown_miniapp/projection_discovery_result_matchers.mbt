///|
fn mini_town_discovery_visible_for(
  projection : MiniTownProjection,
  item : MiniTownDiscoveryItem,
) -> Bool {
  item.visibility == "published" ||
  item.visibility == "system_public" ||
  item.visibility == "personal" ||
  (item.visibility == "shared_private" && projection.organization_id != "")
}

///|
fn mini_town_discovery_match(
  query : String,
  item : MiniTownDiscoveryItem,
) -> Bool {
  query == "" ||
  item.kind.contains(query) ||
  item.title.contains(query) ||
  item.summary.contains(query)
}

///|
fn mini_town_book_match(query : String, book : MiniTownBook) -> Bool {
  query == "" ||
  book.title.contains(query) ||
  book.summary.contains(query) ||
  book.status.contains(query)
}
