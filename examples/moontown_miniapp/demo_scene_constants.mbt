///|
fn moontown_map_width() -> Int {
  1280
}

///|
fn moontown_map_height() -> Int {
  720
}

///|
fn moontown_map_display_scale() -> Int {
  2
}

///|
fn moontown_map_display_width() -> Int {
  moontown_map_width() * moontown_map_display_scale()
}

///|
fn moontown_map_display_height() -> Int {
  moontown_map_height() * moontown_map_display_scale()
}

///|
fn moontown_map_asset_src() -> String {
  "/assets/moontown_wenyu_energy_valley_20260727.jpg"
}

///|
fn moontown_map_asset_source() -> String {
  "examples/moontown_miniapp/assets/moontown_wenyu_energy_valley_20260727.jpg"
}

///|
fn moontown_map_asset_bytes() -> Int {
  219912
}

///|
fn supervisor_avatar_asset_src() -> String {
  "/assets/mobi-sea-otter-icon-concept-v1.jpg"
}

///|
fn supervisor_avatar_asset_source() -> String {
  "examples/moontown_miniapp/assets/mobi-sea-otter-icon-concept-v1.jpg"
}

///|
fn supervisor_avatar_asset_bytes() -> Int {
  26008
}

///|
fn moontown_scene_asset_budget() -> @bunnia.SceneAssetBudget {
  @bunnia.scene_asset_budget(
    max_assets=64,
    max_package_bytes=2 * 1024 * 1024,
    max_remote_assets=16,
  )
}
