///|
fn placement_source_label(source : String) -> String {
  if source == "starter-map" {
    "already on your map"
  } else if source == "discover" {
    "placed from Discover"
  } else {
    "saved to your map"
  }
}

///|
fn town_tab_label(tab : String) -> String {
  if tab == "home" {
    "Home"
  } else if tab == "discover" {
    "Discover"
  } else if tab == "messages" {
    "Messages"
  } else if tab == "my" {
    "My"
  } else {
    "Realm"
  }
}
