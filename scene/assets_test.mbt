///|
test "scene asset plan identifies deferred bundled assets" {
  let plan = plan_scene_assets_with_budget(
    [
      sprite_asset("pin", "/assets/pin.png", 1024),
      tile_asset("district", "/assets/district.png", 4096),
      remote_image_asset("remote", "https://cdn.example.test/tile.png"),
    ],
    scene_asset_budget(
      max_assets=4,
      max_package_bytes=2048,
      max_remote_assets=2,
    ),
  )
  assert_eq(plan.package_bytes, 5120)
  assert_eq(plan.remote_assets, 1)
  assert_eq(plan.deferred_asset_count, 1)
  assert_true(plan.deferred_asset_ids.contains("district"))
  assert_true(
    plan.diagnostics.contains("scene-package-bytes-over-budget:5120/2048"),
  )
  assert_true(plan.diagnostics.contains("scene-deferred-assets:1"))
  assert_true(plan.summary.contains("deferred=1"))
}

///|
test "scene asset plan keeps fitting bundled assets in package" {
  let plan = plan_scene_assets_with_budget(
    [
      sprite_asset("pin", "/assets/pin.png", 1024),
      tile_asset("district", "/assets/district.png", 2048),
    ],
    scene_asset_budget(
      max_assets=4,
      max_package_bytes=4096,
      max_remote_assets=2,
    ),
  )
  assert_eq(plan.package_bytes, 3072)
  assert_eq(plan.deferred_asset_count, 0)
  assert_eq(plan.deferred_asset_ids.length(), 0)
  assert_eq(plan.diagnostics.length(), 0)
}
