///|
fn town_screen_title(tab_id : String) -> String {
  if tab_id == "home" {
    "Town Pulse"
  } else if tab_id == "discover" {
    "Discover"
  } else if tab_id == "messages" {
    "Messages"
  } else if tab_id == "my" {
    "My Town"
  } else {
    "Realm"
  }
}

///|
fn town_screen_subtitle(tab_id : String) -> String {
  if tab_id == "home" {
    "What changed and where to go next"
  } else if tab_id == "discover" {
    "Find people, places, books, and work"
  } else if tab_id == "messages" {
    "Replies, reviews, and work needing you"
  } else if tab_id == "my" {
    "Your passport, work, and publishing"
  } else {
    "Places and agents across the tile town"
  }
}

///|
fn town_page_grid_class(tab_id : String, panel_count : Int) -> String {
  if tab_id == "my" {
    "moontown-page-grid moontown-my-layout"
  } else if panel_count == 1 {
    "moontown-page-grid single"
  } else if panel_count > 2 {
    "moontown-page-grid three"
  } else {
    "moontown-page-grid"
  }
}
