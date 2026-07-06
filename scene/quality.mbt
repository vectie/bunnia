///|
pub(all) enum SceneRenderMode {
  StaticMarkup
  CanvasSurface
  LightweightMarkup
} derive(Debug, Eq)

///|
pub(all) enum SceneQualityLevel {
  FullQuality
  BalancedQuality
  LightweightQuality
} derive(Debug, Eq)

///|
pub struct SceneRenderBudget {
  max_layers : Int
  max_markers : Int
  max_static_assets : Int
} derive(Debug, Eq)

///|
pub struct SceneRenderPlan {
  mode : SceneRenderMode
  quality : SceneQualityLevel
  layer_count : Int
  marker_count : Int
  asset_count : Int
  diagnostics : Array[String]
  summary : String
} derive(Debug, Eq)

///|
pub fn scene_render_budget(
  max_layers~ : Int,
  max_markers~ : Int,
  max_static_assets~ : Int,
) -> SceneRenderBudget {
  { max_layers, max_markers, max_static_assets }
}

///|
pub fn default_scene_render_budget() -> SceneRenderBudget {
  { max_layers: 8, max_markers: 256, max_static_assets: 32 }
}

///|
pub fn plan_scene_render(input : Scene) -> SceneRenderPlan {
  plan_scene_render_with_budget(input, default_scene_render_budget())
}

///|
pub fn plan_scene_render_with_budget(
  input : Scene,
  budget : SceneRenderBudget,
) -> SceneRenderPlan {
  let marker_count = scene_marker_count(input)
  let layer_count = input.layers.length()
  let asset_count = input.assets.length()
  let diagnostics : Array[String] = []
  if layer_count > budget.max_layers {
    diagnostics.push(
      "scene-layer-count-over-budget:\{layer_count}/\{budget.max_layers}",
    )
  }
  if marker_count > budget.max_markers {
    diagnostics.push(
      "scene-marker-count-over-budget:\{marker_count}/\{budget.max_markers}",
    )
  }
  if asset_count > budget.max_static_assets {
    diagnostics.push(
      "scene-static-assets-over-budget:\{asset_count}/\{budget.max_static_assets}",
    )
  }
  let quality = if marker_count > budget.max_markers {
    LightweightQuality
  } else if layer_count > budget.max_layers ||
    asset_count > budget.max_static_assets {
    BalancedQuality
  } else {
    FullQuality
  }
  let mode = match quality {
    FullQuality => StaticMarkup
    BalancedQuality => StaticMarkup
    LightweightQuality => LightweightMarkup
  }
  {
    mode,
    quality,
    layer_count,
    marker_count,
    asset_count,
    diagnostics,
    summary: "Bunnia scene render plan: mode=\{scene_render_mode_id(mode)} quality=\{scene_quality_id(quality)} layers=\{layer_count} markers=\{marker_count} assets=\{asset_count} diagnostics=\{diagnostics.length()}",
  }
}

///|
pub fn scene_marker_count(input : Scene) -> Int {
  let mut total = 0
  for item in input.layers {
    total += item.markers.length()
  }
  total
}

///|
pub fn scene_render_mode_id(mode : SceneRenderMode) -> String {
  match mode {
    StaticMarkup => "static-markup"
    CanvasSurface => "canvas-surface"
    LightweightMarkup => "lightweight-markup"
  }
}

///|
pub fn scene_quality_id(quality : SceneQualityLevel) -> String {
  match quality {
    FullQuality => "full"
    BalancedQuality => "balanced"
    LightweightQuality => "lightweight"
  }
}

///|
fn limit_scene_markers(input : Scene, max_markers : Int) -> Scene {
  let layers : Array[SceneLayer] = []
  let mut remaining = max_markers
  for item in input.layers {
    let markers : Array[SceneMarker] = []
    if remaining > 0 {
      for marker in item.markers {
        if remaining > 0 {
          markers.push(marker)
          remaining -= 1
        }
      }
    }
    layers.push(layer(item.id, item.z_index, markers))
  }
  scene(input.id, input.size, layers, assets=input.assets)
}
