///|
pub(all) enum SceneAssetKind {
  Image
  Sprite
  Tile
  RemoteImage
} derive(Debug, Eq)

///|
pub struct SceneAsset {
  id : String
  kind : SceneAssetKind
  src : String
  estimated_bytes : Int
  remote : Bool
} derive(Debug, Eq)

///|
pub struct SceneAssetBudget {
  max_assets : Int
  max_package_bytes : Int
  max_remote_assets : Int
} derive(Debug, Eq)

///|
pub struct SceneAssetPlan {
  assets : Array[SceneAsset]
  package_bytes : Int
  remote_assets : Int
  deferred_asset_count : Int
  deferred_asset_ids : Array[String]
  diagnostics : Array[String]
  summary : String
} derive(Debug, Eq)

///|
pub fn scene_asset(
  id~ : String,
  kind~ : SceneAssetKind,
  src~ : String,
  estimated_bytes? : Int = 0,
  remote? : Bool = false,
) -> SceneAsset {
  { id, kind, src, estimated_bytes, remote }
}

///|
pub fn image_asset(
  id : String,
  src : String,
  estimated_bytes : Int,
) -> SceneAsset {
  scene_asset(id~, kind=Image, src~, estimated_bytes~)
}

///|
pub fn sprite_asset(
  id : String,
  src : String,
  estimated_bytes : Int,
) -> SceneAsset {
  scene_asset(id~, kind=Sprite, src~, estimated_bytes~)
}

///|
pub fn tile_asset(
  id : String,
  src : String,
  estimated_bytes : Int,
) -> SceneAsset {
  scene_asset(id~, kind=Tile, src~, estimated_bytes~)
}

///|
pub fn remote_image_asset(id : String, src : String) -> SceneAsset {
  scene_asset(id~, kind=RemoteImage, src~, remote=true)
}

///|
pub fn scene_asset_budget(
  max_assets~ : Int,
  max_package_bytes~ : Int,
  max_remote_assets~ : Int,
) -> SceneAssetBudget {
  { max_assets, max_package_bytes, max_remote_assets }
}

///|
pub fn default_scene_asset_budget() -> SceneAssetBudget {
  { max_assets: 64, max_package_bytes: 1024 * 1024, max_remote_assets: 16 }
}

///|
pub fn plan_scene_assets(assets : Array[SceneAsset]) -> SceneAssetPlan {
  plan_scene_assets_with_budget(assets, default_scene_asset_budget())
}

///|
pub fn plan_scene_assets_with_budget(
  assets : Array[SceneAsset],
  budget : SceneAssetBudget,
) -> SceneAssetPlan {
  let diagnostics : Array[String] = []
  let deferred_asset_ids : Array[String] = []
  let mut package_bytes = 0
  let mut remote_assets = 0
  let mut planned_package_bytes = 0
  for item in assets {
    if item.remote {
      remote_assets += 1
    } else {
      package_bytes += item.estimated_bytes
      if planned_package_bytes + item.estimated_bytes <=
        budget.max_package_bytes {
        planned_package_bytes += item.estimated_bytes
      } else {
        deferred_asset_ids.push(item.id)
      }
    }
  }
  if assets.length() > budget.max_assets {
    diagnostics.push(
      "scene-asset-count-over-budget:\{assets.length()}/\{budget.max_assets}",
    )
  }
  if package_bytes > budget.max_package_bytes {
    diagnostics.push(
      "scene-package-bytes-over-budget:\{package_bytes}/\{budget.max_package_bytes}",
    )
  }
  if remote_assets > budget.max_remote_assets {
    diagnostics.push(
      "scene-remote-assets-over-budget:\{remote_assets}/\{budget.max_remote_assets}",
    )
  }
  if deferred_asset_ids.length() > 0 {
    diagnostics.push("scene-deferred-assets:\{deferred_asset_ids.length()}")
  }
  {
    assets,
    package_bytes,
    remote_assets,
    deferred_asset_count: deferred_asset_ids.length(),
    deferred_asset_ids,
    diagnostics,
    summary: "Bunnia scene asset plan: assets=\{assets.length()} package_bytes=\{package_bytes} remote=\{remote_assets} deferred=\{deferred_asset_ids.length()} diagnostics=\{diagnostics.length()}",
  }
}

///|
pub fn scene_asset_kind_id(kind : SceneAssetKind) -> String {
  match kind {
    Image => "image"
    Sprite => "sprite"
    Tile => "tile"
    RemoteImage => "remote-image"
  }
}
