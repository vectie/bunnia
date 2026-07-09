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
    demo_scene_review_viewport(),
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
  let camera_plan = @bunnia.plan_scene_camera(scene, demo_camera())
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
    demo_scene_review_viewport(),
    @bunnia.default_scene_render_budget(),
    moontown_scene_asset_budget(),
    @bunnia.default_scene_visual_quality_budget(),
  )
}

///|
fn demo_scene_review_viewport() -> @bunnia.SceneViewport {
  @bunnia.scene_viewport(x=360, y=160, width=640, height=480)
}
