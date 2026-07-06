///|
pub struct SceneVisualQualityBudget {
  min_width : Int
  min_height : Int
  max_markers_without_status : Int
  max_markers_without_tap : Int
  max_markers_without_asset_ref : Int
  max_unresolved_asset_refs : Int
  min_hit_width : Int
  min_hit_height : Int
  max_small_hit_targets : Int
} derive(Debug, Eq)

///|
pub struct SceneVisualQualityPlan {
  render_plan : SceneRenderPlan
  asset_plan : SceneAssetPlan
  marker_count : Int
  markers_without_status_count : Int
  markers_without_tap_count : Int
  markers_without_asset_ref_count : Int
  unresolved_asset_ref_count : Int
  small_hit_target_count : Int
  degraded : Bool
  diagnostics : Array[String]
  summary : String
} derive(Debug, Eq)

///|
pub fn scene_visual_quality_budget(
  min_width~ : Int,
  min_height~ : Int,
  max_markers_without_status~ : Int,
  max_markers_without_tap~ : Int,
  max_markers_without_asset_ref~ : Int,
  max_unresolved_asset_refs~ : Int,
  min_hit_width? : Int = 44,
  min_hit_height? : Int = 44,
  max_small_hit_targets? : Int = 0,
) -> SceneVisualQualityBudget {
  {
    min_width,
    min_height,
    max_markers_without_status,
    max_markers_without_tap,
    max_markers_without_asset_ref,
    max_unresolved_asset_refs,
    min_hit_width,
    min_hit_height,
    max_small_hit_targets,
  }
}

///|
pub fn default_scene_visual_quality_budget() -> SceneVisualQualityBudget {
  {
    min_width: 320,
    min_height: 240,
    max_markers_without_status: 0,
    max_markers_without_tap: 0,
    max_markers_without_asset_ref: 0,
    max_unresolved_asset_refs: 0,
    min_hit_width: 44,
    min_hit_height: 44,
    max_small_hit_targets: 0,
  }
}

///|
pub fn plan_scene_visual_quality(input : Scene) -> SceneVisualQualityPlan {
  plan_scene_visual_quality_with_budget(
    input,
    default_scene_render_budget(),
    default_scene_asset_budget(),
    default_scene_visual_quality_budget(),
  )
}

///|
pub fn plan_scene_visual_quality_with_budget(
  input : Scene,
  render_budget : SceneRenderBudget,
  asset_budget : SceneAssetBudget,
  quality_budget : SceneVisualQualityBudget,
) -> SceneVisualQualityPlan {
  plan_scene_visual_quality_from_plans(
    input,
    plan_scene_render_with_budget(input, render_budget),
    plan_scene_assets_with_budget(input.assets, asset_budget),
    quality_budget,
  )
}

///|
pub fn plan_scene_visual_quality_viewport(
  input : Scene,
  viewport : SceneViewport,
  render_budget : SceneRenderBudget,
  asset_budget : SceneAssetBudget,
  quality_budget : SceneVisualQualityBudget,
) -> SceneVisualQualityPlan {
  plan_scene_visual_quality_from_plans(
    input,
    plan_scene_render_viewport(input, viewport, render_budget),
    plan_scene_assets_with_budget(input.assets, asset_budget),
    quality_budget,
  )
}

///|
fn plan_scene_visual_quality_from_plans(
  input : Scene,
  render_plan : SceneRenderPlan,
  asset_plan : SceneAssetPlan,
  quality_budget : SceneVisualQualityBudget,
) -> SceneVisualQualityPlan {
  let diagnostics : Array[String] = []
  let (
    markers_without_status_count,
    markers_without_tap_count,
    markers_without_asset_ref_count,
    unresolved_asset_ref_count,
    small_hit_target_count,
  ) = marker_quality_counts(input, quality_budget)
  push_scene_size_diagnostics(input, quality_budget, diagnostics)
  push_marker_quality_diagnostics(
    markers_without_status_count, markers_without_tap_count, markers_without_asset_ref_count,
    unresolved_asset_ref_count, small_hit_target_count, quality_budget, diagnostics,
  )
  push_prefixed_quality_diagnostics(
    "render",
    render_plan.diagnostics,
    diagnostics,
  )
  push_prefixed_quality_diagnostics(
    "assets",
    asset_plan.diagnostics,
    diagnostics,
  )
  let degraded = diagnostics.length() > 0 ||
    !(render_plan.quality is FullQuality)
  {
    render_plan,
    asset_plan,
    marker_count: scene_marker_count(input),
    markers_without_status_count,
    markers_without_tap_count,
    markers_without_asset_ref_count,
    unresolved_asset_ref_count,
    small_hit_target_count,
    degraded,
    diagnostics,
    summary: "Bunnia scene visual quality plan: markers=\{scene_marker_count(input)} missing_status=\{markers_without_status_count} missing_tap=\{markers_without_tap_count} missing_assets=\{markers_without_asset_ref_count} unresolved_assets=\{unresolved_asset_ref_count} small_hit_targets=\{small_hit_target_count} degraded=\{degraded} diagnostics=\{diagnostics.length()}",
  }
}

///|
fn marker_quality_counts(
  input : Scene,
  budget : SceneVisualQualityBudget,
) -> (Int, Int, Int, Int, Int) {
  let mut markers_without_status_count = 0
  let mut markers_without_tap_count = 0
  let mut markers_without_asset_ref_count = 0
  let mut unresolved_asset_ref_count = 0
  let mut small_hit_target_count = 0
  for scene_layer in input.layers {
    for scene_marker in scene_layer.markers {
      if scene_marker.status == "" {
        markers_without_status_count += 1
      }
      if scene_marker.tap_message == "" {
        markers_without_tap_count += 1
      }
      if scene_marker.asset_ref == "" {
        markers_without_asset_ref_count += 1
      } else if !has_asset(input.assets, scene_marker.asset_ref) {
        unresolved_asset_ref_count += 1
      }
      if scene_marker.tap_message != "" &&
        (
          scene_marker.hit_width < budget.min_hit_width ||
          scene_marker.hit_height < budget.min_hit_height
        ) {
        small_hit_target_count += 1
      }
    }
  }
  (
    markers_without_status_count, markers_without_tap_count, markers_without_asset_ref_count,
    unresolved_asset_ref_count, small_hit_target_count,
  )
}

///|
fn push_scene_size_diagnostics(
  input : Scene,
  budget : SceneVisualQualityBudget,
  diagnostics : Array[String],
) -> Unit {
  if input.size.width < budget.min_width {
    diagnostics.push(
      "scene-width-under-min:\{input.size.width}/\{budget.min_width}",
    )
  }
  if input.size.height < budget.min_height {
    diagnostics.push(
      "scene-height-under-min:\{input.size.height}/\{budget.min_height}",
    )
  }
}

///|
fn push_marker_quality_diagnostics(
  markers_without_status_count : Int,
  markers_without_tap_count : Int,
  markers_without_asset_ref_count : Int,
  unresolved_asset_ref_count : Int,
  small_hit_target_count : Int,
  budget : SceneVisualQualityBudget,
  diagnostics : Array[String],
) -> Unit {
  if markers_without_status_count > budget.max_markers_without_status {
    diagnostics.push(
      "scene-markers-without-status:\{markers_without_status_count}/\{budget.max_markers_without_status}",
    )
  }
  if markers_without_tap_count > budget.max_markers_without_tap {
    diagnostics.push(
      "scene-markers-without-tap:\{markers_without_tap_count}/\{budget.max_markers_without_tap}",
    )
  }
  if markers_without_asset_ref_count > budget.max_markers_without_asset_ref {
    diagnostics.push(
      "scene-markers-without-asset-ref:\{markers_without_asset_ref_count}/\{budget.max_markers_without_asset_ref}",
    )
  }
  if unresolved_asset_ref_count > budget.max_unresolved_asset_refs {
    diagnostics.push(
      "scene-unresolved-asset-refs:\{unresolved_asset_ref_count}/\{budget.max_unresolved_asset_refs}",
    )
  }
  if small_hit_target_count > budget.max_small_hit_targets {
    diagnostics.push(
      "scene-small-hit-targets:\{small_hit_target_count}/\{budget.max_small_hit_targets}",
    )
  }
}

///|
fn push_prefixed_quality_diagnostics(
  prefix : String,
  input : Array[String],
  output : Array[String],
) -> Unit {
  for item in input {
    output.push("\{prefix}:\{item}")
  }
}

///|
fn has_asset(assets : Array[SceneAsset], asset_ref : String) -> Bool {
  for item in assets {
    if item.id == asset_ref {
      return true
    }
  }
  false
}
