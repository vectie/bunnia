///|
pub(all) enum SceneSurfacePreference {
  PreferStaticSurface
  PreferCanvasSurface
  PreferLightweightSurface
} derive(Debug, Eq)

///|
pub struct SceneSurfacePlan {
  adapter : @core.PlatformAdapter
  render_plan : SceneRenderPlan
  preference : SceneSurfacePreference
  requested_mode : SceneRenderMode
  mode : SceneRenderMode
  fallback : Bool
  diagnostics : Array[String]
  summary : String
} derive(Debug, Eq)

///|
pub fn plan_scene_surface_for_platform(
  input : Scene,
  platform : @core.Platform,
  preference? : SceneSurfacePreference = PreferStaticSurface,
  budget? : SceneRenderBudget = default_scene_render_budget(),
) -> SceneSurfacePlan {
  plan_scene_surface(input, @core.adapter(platform), preference~, budget~)
}

///|
pub fn plan_scene_surface(
  input : Scene,
  adapter : @core.PlatformAdapter,
  preference? : SceneSurfacePreference = PreferStaticSurface,
  budget? : SceneRenderBudget = default_scene_render_budget(),
) -> SceneSurfacePlan {
  let render_plan = plan_scene_render_with_budget(input, budget)
  let requested_mode = preferred_surface_mode(preference)
  let diagnostics : Array[String] = []
  for item in render_plan.diagnostics {
    diagnostics.push("render:\{item}")
  }
  let mode = if render_plan.mode is LightweightMarkup {
    LightweightMarkup
  } else if requested_mode is CanvasSurface && !adapter.supports_canvas {
    diagnostics.push("scene-canvas-unsupported:\{adapter.id}")
    render_plan.mode
  } else {
    requested_mode
  }
  let fallback = mode != requested_mode
  {
    adapter,
    render_plan,
    preference,
    requested_mode,
    mode,
    fallback,
    diagnostics,
    summary: "Bunnia scene surface plan: platform=\{adapter.id} preference=\{scene_surface_preference_id(preference)} requested=\{scene_render_mode_id(requested_mode)} mode=\{scene_render_mode_id(mode)} fallback=\{fallback} diagnostics=\{diagnostics.length()}",
  }
}

///|
fn preferred_surface_mode(
  preference : SceneSurfacePreference,
) -> SceneRenderMode {
  match preference {
    PreferStaticSurface => StaticMarkup
    PreferCanvasSurface => CanvasSurface
    PreferLightweightSurface => LightweightMarkup
  }
}

///|
pub fn scene_surface_preference_id(
  preference : SceneSurfacePreference,
) -> String {
  match preference {
    PreferStaticSurface => "static"
    PreferCanvasSurface => "canvas"
    PreferLightweightSurface => "lightweight"
  }
}
