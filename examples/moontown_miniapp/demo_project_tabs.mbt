///|
fn moontown_tab_page_name(tab_id : String) -> String {
  if tab_id == "home" {
    "Moontown Home"
  } else if tab_id == "discover" {
    "Moontown Discover"
  } else if tab_id == "messages" {
    "Moontown Messages"
  } else if tab_id == "my" {
    "Moontown My"
  } else if tab_id == "reviewer" {
    "Moontown Reviewer"
  } else {
    "Moontown Realm"
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
