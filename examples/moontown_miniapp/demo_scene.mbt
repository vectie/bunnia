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

///|
pub fn demo_scene() -> @bunnia.Scene {
  let projection = demo_projection()
  @bunnia.scene(
    "moontown-map",
    @bunnia.scene_size(moontown_map_width(), moontown_map_height()),
    [
      @bunnia.layer("districts", 1, [], regions=[
        @bunnia.region(
          id="central",
          label="Central",
          x=430,
          y=250,
          width=420,
          height=270,
          status="stable",
          tap_message="select-policy-hall",
        ),
        @bunnia.region(
          id="east-market",
          label="East Market",
          x=820,
          y=420,
          width=360,
          height=260,
          status="running",
          tap_message="select-market-square",
        ),
      ]),
      @bunnia.layer(
        "buildings",
        2,
        markers_from_buildings(visible_buildings(projection)),
      ),
    ],
    assets=demo_scene_assets(),
  )
}

///|
pub fn demo_camera() -> @bunnia.SceneCamera {
  @bunnia.scene_camera(
    scene_id="moontown-map",
    x=360,
    y=160,
    width=720,
    height=720,
  )
}

///|
pub fn demo_scene_render_plan() -> @bunnia.SceneRenderPlan {
  @bunnia.plan_scene_render_viewport(
    demo_scene(),
    @bunnia.scene_viewport(x=360, y=160, width=640, height=480),
    @bunnia.default_scene_render_budget(),
  )
}

///|
pub fn demo_scene_surface_plan() -> @bunnia.SceneSurfacePlan {
  @bunnia.plan_scene_surface_for_platform(
    demo_scene(),
    @bunnia.wechat(),
    preference=@bunnia.prefer_static_surface(),
  )
}

///|
pub fn demo_scene_thread_plan() -> @bunnia.SceneThreadPlan {
  let scene = demo_scene()
  let camera = demo_camera()
  let camera_plan = @bunnia.plan_scene_camera(scene, camera)
  @bunnia.plan_scene_threads_viewport_with_budget(
    scene,
    camera_plan.viewport,
    demo_scene_thread_links(demo_projection()),
    @bunnia.scene_thread_budget(max_visible_links=9, max_unread_total=12),
  )
}

///|
pub fn demo_asset_plan() -> @bunnia.SceneAssetPlan {
  @bunnia.plan_scene_assets_with_budget(
    demo_scene_assets(),
    moontown_scene_asset_budget(),
  )
}

///|
pub fn demo_scene_visual_quality_plan() -> @bunnia.SceneVisualQualityPlan {
  @bunnia.plan_scene_visual_quality_viewport(
    demo_scene(),
    @bunnia.scene_viewport(x=360, y=160, width=640, height=480),
    @bunnia.default_scene_render_budget(),
    moontown_scene_asset_budget(),
    @bunnia.default_scene_visual_quality_budget(),
  )
}

///|
pub fn demo_project_inspection() -> @bunnia.ProjectInspection {
  let project = demo_wechat_project_with_render_budget(
    @bunnia.render_budget_for_profile("large"),
  )
  let report = @bunnia.report_wechat_project_with_budget(
    project,
    @bunnia.default_wechat_runtime(),
    @bunnia.wechat_build_budget_for_profile("large"),
  )
  @bunnia.inspect_wechat_project(
    target="wechat",
    example="moontown_miniapp",
    project,
    report,
  )
}

///|
