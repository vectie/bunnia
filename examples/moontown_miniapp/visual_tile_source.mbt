///|
fn moontown_wxss_source() -> String {
  tile_base_wxss() +
  tile_map_wxss() +
  tile_shell_wxss() +
  tile_primitives_wxss() +
  tile_state_wxss() +
  tile_content_wxss() +
  tile_messages_wxss() +
  tile_my_wxss() +
  tile_drawer_wxss() +
  tile_identity_wxss() +
  tile_responsive_wxss()
}

///|
fn moontown_wxss_source_for_tab(tab_id : String) -> String {
  let shared = tile_base_wxss() +
    tile_shell_wxss() +
    tile_primitives_wxss() +
    tile_state_wxss() +
    tile_content_wxss() +
    tile_identity_wxss()
  if tab_id == "realm" {
    shared + tile_map_wxss() + tile_drawer_wxss() + tile_responsive_wxss()
  } else if tab_id == "messages" {
    shared +
    tile_messages_wxss() +
    tile_responsive_wxss() +
    ".moontown-page-surface.tab-messages { background: #fbf7ee; }\n"
  } else if tab_id == "my" {
    shared +
    tile_my_wxss() +
    tile_drawer_wxss() +
    tile_responsive_wxss() +
    ".moontown-page-surface.tab-my { background: #fbf7ee; }\n"
  } else if tab_id == "discover" {
    shared +
    tile_responsive_wxss() +
    ".moontown-page-surface.tab-discover { background: #fbf7ee; }\n"
  } else {
    shared +
    tile_responsive_wxss() +
    ".moontown-page-surface.tab-home { background: #fbf7ee; }\n"
  }
}
