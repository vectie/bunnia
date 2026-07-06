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
pub struct SceneAssetPolicy {
  approved_remote_domains : Array[String]
  require_https : Bool
} derive(Debug, Eq)

///|
pub struct SceneAssetPlan {
  assets : Array[SceneAsset]
  package_bytes : Int
  remote_assets : Int
  insecure_remote_asset_count : Int
  unapproved_remote_asset_count : Int
  unapproved_remote_asset_ids : Array[String]
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
pub fn scene_asset_policy(
  approved_remote_domains~ : Array[String],
  require_https? : Bool = true,
) -> SceneAssetPolicy {
  { approved_remote_domains, require_https }
}

///|
pub fn default_scene_asset_policy() -> SceneAssetPolicy {
  { approved_remote_domains: [], require_https: true }
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
  plan_scene_assets_with_budget_and_policy(
    assets,
    budget,
    default_scene_asset_policy(),
  )
}

///|
pub fn plan_scene_assets_with_budget_and_policy(
  assets : Array[SceneAsset],
  budget : SceneAssetBudget,
  policy : SceneAssetPolicy,
) -> SceneAssetPlan {
  let diagnostics : Array[String] = []
  let deferred_asset_ids : Array[String] = []
  let unapproved_remote_asset_ids : Array[String] = []
  let mut package_bytes = 0
  let mut remote_assets = 0
  let mut insecure_remote_asset_count = 0
  let mut planned_package_bytes = 0
  for item in assets {
    if item.remote {
      remote_assets += 1
      if policy.require_https && !item.src.has_prefix("https://") {
        insecure_remote_asset_count += 1
        diagnostics.push("scene-remote-asset-not-https:\{item.id}")
      }
      let domain = remote_asset_domain(item.src)
      if !remote_domain_approved(domain, policy.approved_remote_domains) {
        unapproved_remote_asset_ids.push(item.id)
        diagnostics.push(
          "scene-remote-asset-domain-unapproved:\{item.id}:\{domain}",
        )
      }
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
  if insecure_remote_asset_count > 0 {
    diagnostics.push(
      "scene-insecure-remote-assets:\{insecure_remote_asset_count}",
    )
  }
  if unapproved_remote_asset_ids.length() > 0 {
    diagnostics.push(
      "scene-unapproved-remote-assets:\{unapproved_remote_asset_ids.length()}",
    )
  }
  if deferred_asset_ids.length() > 0 {
    diagnostics.push("scene-deferred-assets:\{deferred_asset_ids.length()}")
  }
  {
    assets,
    package_bytes,
    remote_assets,
    insecure_remote_asset_count,
    unapproved_remote_asset_count: unapproved_remote_asset_ids.length(),
    unapproved_remote_asset_ids,
    deferred_asset_count: deferred_asset_ids.length(),
    deferred_asset_ids,
    diagnostics,
    summary: "Bunnia scene asset plan: assets=\{assets.length()} package_bytes=\{package_bytes} remote=\{remote_assets} insecure_remote=\{insecure_remote_asset_count} unapproved_remote=\{unapproved_remote_asset_ids.length()} deferred=\{deferred_asset_ids.length()} diagnostics=\{diagnostics.length()}",
  }
}

///|
fn remote_domain_approved(
  domain : String,
  approved_domains : Array[String],
) -> Bool {
  if approved_domains.length() == 0 {
    true
  } else {
    approved_domains.contains(domain)
  }
}

///|
fn remote_asset_domain(src : String) -> String {
  let start = if src.has_prefix("https://") {
    8
  } else if src.has_prefix("http://") {
    7
  } else {
    0
  }
  let mut end = src.length()
  for i in start..<src.length() {
    let code = src[i].to_int()
    if code == 47 || code == 58 || code == 63 {
      end = i
      break
    }
  }
  src.sub(start~, end~).to_owned()
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
