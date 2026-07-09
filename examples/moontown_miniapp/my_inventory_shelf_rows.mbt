///|
fn inventory_shelf_rows(
  projection : MiniTownProjection,
) -> Array[MiniTownInventoryShelf] {
  let owned = owned_buildings(projection)
  let placements = visible_placements(projection)
  let books = owned_books(projection)
  let agents = owned_agents(projection)
  let watches = visible_watches(projection)
  let drafts = count_owned_buildings_by_visibility(projection, "private_draft")
  let submitted = count_owned_buildings_by_visibility(projection, "submitted")
  let published = count_owned_buildings_by_visibility(projection, "published")
  let archived = count_owned_buildings_by_visibility(projection, "archived")
  [
    inventory_buildings_shelf(owned.length()),
    inventory_placements_shelf(placements),
    inventory_drafts_shelf(drafts),
    inventory_submitted_shelf(submitted),
    inventory_published_shelf(published),
    inventory_archived_shelf(archived),
    inventory_books_shelf(books.length()),
    inventory_agents_shelf(agents.length()),
    inventory_watched_shelf(watches),
  ]
}
