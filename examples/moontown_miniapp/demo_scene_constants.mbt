///|
fn moontown_map_width() -> Int {
  1400
}

///|
fn moontown_map_height() -> Int {
  880
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
  "/assets/wenyu_reference_tilemap_iso_mobile.png"
}

///|
fn moontown_map_asset_source() -> String {
  "examples/moontown_miniapp/assets/wenyu_reference_tilemap_iso_mobile.png"
}

///|
fn moontown_map_asset_bytes() -> Int {
  2077418
}

///|
fn moontown_scene_asset_budget() -> @bunnia.SceneAssetBudget {
  @bunnia.scene_asset_budget(
    max_assets=64,
    max_package_bytes=2 * 1024 * 1024,
    max_remote_assets=16,
  )
}
