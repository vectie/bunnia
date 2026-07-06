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
  max_regions : Int
  max_static_assets : Int
} derive(Debug, Eq)

///|
pub struct SceneRenderPlan {
  mode : SceneRenderMode
  quality : SceneQualityLevel
  layer_count : Int
  marker_count : Int
  visible_marker_count : Int
  region_count : Int
  visible_region_count : Int
  asset_count : Int
  diagnostics : Array[String]
  summary : String
} derive(Debug, Eq)

///|
pub fn scene_render_budget(
  max_layers~ : Int,
  max_markers~ : Int,
  max_static_assets~ : Int,
  max_regions? : Int = 128,
) -> SceneRenderBudget {
  { max_layers, max_markers, max_regions, max_static_assets }
}

///|
pub fn default_scene_render_budget() -> SceneRenderBudget {
  { max_layers: 8, max_markers: 256, max_regions: 128, max_static_assets: 32 }
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
  let region_count = scene_region_count(input)
  plan_scene_render_counts(
    marker_count,
    marker_count,
    region_count,
    region_count,
    input.layers.length(),
    input.assets.length(),
    budget,
    "scene-marker-count-over-budget",
    "scene-region-count-over-budget",
  )
}

///|
pub fn plan_scene_render_viewport(
  input : Scene,
  viewport : SceneViewport,
  budget : SceneRenderBudget,
) -> SceneRenderPlan {
  let marker_count = scene_marker_count(input)
  let visible_marker_count = scene_visible_marker_count(input, viewport)
  let region_count = scene_region_count(input)
  let visible_region_count = scene_visible_region_count(input, viewport)
  plan_scene_render_counts(
    marker_count,
    visible_marker_count,
    region_count,
    visible_region_count,
    input.layers.length(),
    input.assets.length(),
    budget,
    "scene-visible-marker-count-over-budget",
    "scene-visible-region-count-over-budget",
  )
}

///|
fn plan_scene_render_counts(
  marker_count : Int,
  visible_marker_count : Int,
  region_count : Int,
  visible_region_count : Int,
  layer_count : Int,
  asset_count : Int,
  budget : SceneRenderBudget,
  marker_diagnostic : String,
  region_diagnostic : String,
) -> SceneRenderPlan {
  let diagnostics : Array[String] = []
  if layer_count > budget.max_layers {
    diagnostics.push(
      "scene-layer-count-over-budget:\{layer_count}/\{budget.max_layers}",
    )
  }
  if visible_marker_count > budget.max_markers {
    diagnostics.push(
      "\{marker_diagnostic}:\{visible_marker_count}/\{budget.max_markers}",
    )
  }
  if visible_region_count > budget.max_regions {
    diagnostics.push(
      "\{region_diagnostic}:\{visible_region_count}/\{budget.max_regions}",
    )
  }
  if asset_count > budget.max_static_assets {
    diagnostics.push(
      "scene-static-assets-over-budget:\{asset_count}/\{budget.max_static_assets}",
    )
  }
  let quality = if visible_marker_count > budget.max_markers ||
    visible_region_count > budget.max_regions {
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
    visible_marker_count,
    region_count,
    visible_region_count,
    asset_count,
    diagnostics,
    summary: "Bunnia scene render plan: mode=\{scene_render_mode_id(mode)} quality=\{scene_quality_id(quality)} layers=\{layer_count} markers=\{visible_marker_count}/\{marker_count} regions=\{visible_region_count}/\{region_count} assets=\{asset_count} diagnostics=\{diagnostics.length()}",
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
pub fn scene_region_count(input : Scene) -> Int {
  let mut total = 0
  for item in input.layers {
    total += item.regions.length()
  }
  total
}

///|
pub fn scene_visible_marker_count(
  input : Scene,
  viewport : SceneViewport,
) -> Int {
  let mut total = 0
  for item in input.layers {
    for scene_marker in item.markers {
      if marker_in_viewport(scene_marker, viewport) {
        total += 1
      }
    }
  }
  total
}

///|
pub fn scene_visible_region_count(
  input : Scene,
  viewport : SceneViewport,
) -> Int {
  let mut total = 0
  for item in input.layers {
    for scene_region in item.regions {
      if region_in_viewport(scene_region, viewport) {
        total += 1
      }
    }
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
    layers.push(layer(item.id, item.z_index, markers, regions=item.regions))
  }
  scene(input.id, input.size, layers, assets=input.assets)
}

///|
fn limit_scene_regions(input : Scene, max_regions : Int) -> Scene {
  let layers : Array[SceneLayer] = []
  let mut remaining = max_regions
  for item in input.layers {
    let regions : Array[SceneRegion] = []
    if remaining > 0 {
      for scene_region in item.regions {
        if remaining > 0 {
          regions.push(scene_region)
          remaining -= 1
        }
      }
    }
    layers.push(layer(item.id, item.z_index, item.markers, regions~))
  }
  scene(input.id, input.size, layers, assets=input.assets)
}

///|
fn limit_scene_geometry(input : Scene, budget : SceneRenderBudget) -> Scene {
  limit_scene_regions(
    limit_scene_markers(input, budget.max_markers),
    budget.max_regions,
  )
}
