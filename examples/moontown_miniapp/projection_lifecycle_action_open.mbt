///|
fn lifecycle_ask_action(
  building : MiniTownBuilding,
  book : MiniTownBook,
) -> MiniTownLifecycleAction {
  mini_town_lifecycle_action(
    id="ask",
    label="Ask",
    message="ask-selected-building",
    target_ref="building:\{building.id}",
    book_id=book.id,
    allowed=building.visibility != "archived",
    reason=if building.visibility == "archived" {
      "archived building"
    } else {
      "book linked"
    },
    status=if building.visibility == "archived" { "blocked" } else { "ready" },
  )
}

///|
fn lifecycle_place_action(
  projection : MiniTownProjection,
  building : MiniTownBuilding,
  book : MiniTownBook,
) -> MiniTownLifecycleAction {
  let can_place = building.visibility == "published" &&
    placement_for_building(projection, building.id) is None
  mini_town_lifecycle_action(
    id="place",
    label="Place",
    message="place-published-building",
    target_ref="building:\{building.id}",
    book_id=book.id,
    allowed=can_place,
    reason=if placement_for_building(projection, building.id) is Some(_) {
      "already placed"
    } else if building.visibility == "published" {
      "published building"
    } else {
      "publish first"
    },
    status=if can_place { "ready" } else { "blocked" },
  )
}
