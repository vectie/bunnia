///|
fn moontown_tab_page_name(tab_id : String) -> String {
  if tab_id == "home" {
    "Home"
  } else if tab_id == "discover" {
    "Discover"
  } else if tab_id == "messages" {
    "Messages"
  } else if tab_id == "my" {
    "My"
  } else if tab_id == "reviewer" {
    "Reviewer"
  } else {
    "Realm"
  }
}

///|
fn moontown_tab_route(tab_id : String) -> String {
  if tab_id == "home" {
    "pages/moontown/home"
  } else if tab_id == "discover" {
    "pages/moontown/discover"
  } else if tab_id == "messages" {
    "pages/moontown/messages"
  } else if tab_id == "my" {
    "pages/moontown/my"
  } else if tab_id == "reviewer" {
    "pages/moontown/reviewer"
  } else {
    "pages/moontown/index"
  }
}
