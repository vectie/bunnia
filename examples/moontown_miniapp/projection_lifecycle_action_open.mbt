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
  building : MiniTownBuilding,
  book : MiniTownBook,
) -> MiniTownLifecycleAction {
  mini_town_lifecycle_action(
    id="place",
    label="Place",
    message="place-published-building",
    target_ref="building:\{building.id}",
    book_id=book.id,
    allowed=building.visibility == "published",
    reason=if building.visibility == "published" {
      "published building"
    } else {
      "publish first"
    },
    status=if building.visibility == "published" { "ready" } else { "blocked" },
  )
}
