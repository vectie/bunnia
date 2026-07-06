///|
pub struct SceneSize {
  width : Int
  height : Int
} derive(Debug, Eq)

///|
pub struct SceneViewport {
  x : Int
  y : Int
  width : Int
  height : Int
} derive(Debug, Eq)

///|
pub struct SceneMarker {
  id : String
  label : String
  x : Int
  y : Int
  status : String
  tap_message : String
  asset_ref : String
  hit_width : Int
  hit_height : Int
} derive(Debug, Eq)

///|
pub struct SceneRegion {
  id : String
  label : String
  x : Int
  y : Int
  width : Int
  height : Int
  status : String
  tap_message : String
} derive(Debug, Eq)

///|
pub struct SceneLayer {
  id : String
  z_index : Int
  markers : Array[SceneMarker]
  regions : Array[SceneRegion]
} derive(Debug, Eq)

///|
pub struct Scene {
  id : String
  size : SceneSize
  layers : Array[SceneLayer]
  assets : Array[SceneAsset]
} derive(Debug, Eq)

///|
pub fn scene_size(width : Int, height : Int) -> SceneSize {
  { width, height }
}

///|
pub fn scene_viewport(
  x~ : Int,
  y~ : Int,
  width~ : Int,
  height~ : Int,
) -> SceneViewport {
  { x, y, width, height }
}

///|
pub fn marker(
  id~ : String,
  label~ : String,
  x~ : Int,
  y~ : Int,
  status? : String = "",
  tap_message? : String = "",
  asset_ref? : String = "",
  hit_width? : Int = 44,
  hit_height? : Int = 44,
) -> SceneMarker {
  { id, label, x, y, status, tap_message, asset_ref, hit_width, hit_height }
}

///|
pub fn region(
  id~ : String,
  label~ : String,
  x~ : Int,
  y~ : Int,
  width~ : Int,
  height~ : Int,
  status? : String = "",
  tap_message? : String = "",
) -> SceneRegion {
  { id, label, x, y, width, height, status, tap_message }
}

///|
pub fn layer(
  id : String,
  z_index : Int,
  markers : Array[SceneMarker],
  regions? : Array[SceneRegion] = [],
) -> SceneLayer {
  { id, z_index, markers, regions }
}

///|
pub fn scene(
  id : String,
  size : SceneSize,
  layers : Array[SceneLayer],
  assets? : Array[SceneAsset] = [],
) -> Scene {
  { id, size, layers, assets }
}

///|
pub fn static_scene_view(input : Scene) -> @core.Node {
  scene_view(input, [])
}

///|
pub fn static_scene_view_with_budget(
  input : Scene,
  budget : SceneRenderBudget,
) -> @core.Node {
  let plan = plan_scene_render_with_budget(input, budget)
  let rendered = if plan.marker_count > budget.max_markers ||
    plan.region_count > budget.max_regions {
    limit_scene_geometry(input, budget)
  } else {
    input
  }
  scene_view(rendered, [
    @core.data("scene-mode", scene_render_mode_id(plan.mode)),
    @core.data("scene-quality", scene_quality_id(plan.quality)),
    @core.data("markers-total", plan.marker_count.to_string()),
    @core.data("markers-visible", scene_marker_count(rendered).to_string()),
    @core.data("regions-total", plan.region_count.to_string()),
    @core.data("regions-visible", scene_region_count(rendered).to_string()),
    @core.data(
      "scene-degraded",
      (plan.marker_count > scene_marker_count(rendered) ||
      plan.region_count > scene_region_count(rendered)).to_string(),
    ),
  ])
}

///|
pub fn static_scene_view_with_viewport(
  input : Scene,
  viewport : SceneViewport,
  budget? : SceneRenderBudget = default_scene_render_budget(),
) -> @core.Node {
  let visible = viewport_scene(input, viewport)
  let plan = plan_scene_render_viewport(input, viewport, budget)
  let rendered = if scene_marker_count(visible) > budget.max_markers ||
    scene_region_count(visible) > budget.max_regions {
    limit_scene_geometry(visible, budget)
  } else {
    visible
  }
  scene_view_with_render_size(
    rendered,
    scene_size(viewport.width, viewport.height),
    [
      @core.data("scene-mode", scene_render_mode_id(plan.mode)),
      @core.data("scene-quality", scene_quality_id(plan.quality)),
      @core.data("viewport-x", viewport.x.to_string()),
      @core.data("viewport-y", viewport.y.to_string()),
      @core.data("viewport-width", viewport.width.to_string()),
      @core.data("viewport-height", viewport.height.to_string()),
      @core.data("markers-total", plan.marker_count.to_string()),
      @core.data("markers-visible", scene_marker_count(rendered).to_string()),
      @core.data("regions-total", plan.region_count.to_string()),
      @core.data("regions-visible", scene_region_count(rendered).to_string()),
      @core.data(
        "scene-degraded",
        (plan.marker_count > scene_marker_count(rendered) ||
        plan.region_count > scene_region_count(rendered)).to_string(),
      ),
    ],
  )
}

///|
fn scene_view(input : Scene, extra_attrs : Array[@core.Attr]) -> @core.Node {
  scene_view_with_render_size(input, input.size, extra_attrs)
}

///|
fn scene_view_with_render_size(
  input : Scene,
  render_size : SceneSize,
  extra_attrs : Array[@core.Attr],
) -> @core.Node {
  let children : Array[@core.Node] = []
  for item in input.layers {
    children.push(layer_view(item, input.assets))
  }
  let attrs = [
    @core.class_name("bunnia-scene"),
    @core.attr("style", scene_style(render_size)),
    @core.data("scene-id", input.id),
    @core.data("scene-width", input.size.width.to_string()),
    @core.data("scene-height", input.size.height.to_string()),
    @core.data("render-width", render_size.width.to_string()),
    @core.data("render-height", render_size.height.to_string()),
    @core.data("scene-assets", input.assets.length().to_string()),
  ]
  for item in extra_attrs {
    attrs.push(item)
  }
  @core.view_with_attrs(attrs, children)
}

///|
fn layer_view(input : SceneLayer, assets : Array[SceneAsset]) -> @core.Node {
  let children : Array[@core.Node] = []
  for item in input.regions {
    children.push(region_view(item))
  }
  for item in input.markers {
    children.push(marker_view(item, assets))
  }
  @core.view_with_attrs(
    [
      @core.class_name("bunnia-scene-layer"),
      @core.attr("style", "z-index: \{input.z_index};"),
      @core.data("layer-id", input.id),
      @core.data("z-index", input.z_index.to_string()),
    ],
    children,
  )
}

///|
fn region_view(input : SceneRegion) -> @core.Node {
  let events = if input.tap_message == "" {
    []
  } else {
    [@core.tap(input.tap_message)]
  }
  @core.keyed(
    input.id,
    @core.node(
      kind="view",
      attrs=[
        @core.class_name("bunnia-scene-region \{status_class(input.status)}"),
        @core.attr("style", region_style(input)),
        @core.data("region-id", input.id),
        @core.data("x", input.x.to_string()),
        @core.data("y", input.y.to_string()),
        @core.data("width", input.width.to_string()),
        @core.data("height", input.height.to_string()),
        @core.data("status", input.status),
      ],
      events~,
      children=[@core.text(input.label)],
    ),
  )
}

///|
fn marker_view(input : SceneMarker, assets : Array[SceneAsset]) -> @core.Node {
  let events = if input.tap_message == "" {
    []
  } else {
    [@core.tap(input.tap_message)]
  }
  let children : Array[@core.Node] = []
  match find_asset(assets, input.asset_ref) {
    Some(asset) => children.push(asset_image(asset, input.label))
    None => ()
  }
  children.push(@core.text(input.label))
  @core.keyed(
    input.id,
    @core.node(
      kind="view",
      attrs=[
        @core.class_name("bunnia-scene-marker \{status_class(input.status)}"),
        @core.attr("style", marker_style(input)),
        @core.data("marker-id", input.id),
        @core.data("x", input.x.to_string()),
        @core.data("y", input.y.to_string()),
        @core.data("status", input.status),
        @core.data("asset-ref", input.asset_ref),
        @core.data("hit-width", input.hit_width.to_string()),
        @core.data("hit-height", input.hit_height.to_string()),
      ],
      events~,
      children~,
    ),
  )
}

///|
pub fn set_scene_marker_status(
  scene_id : String,
  marker_id : String,
  status : String,
) -> @core.Patch {
  @core.set_string("scenes.\{scene_id}.markers.\{marker_id}.status", status)
}

///|
pub fn select_scene_marker(
  scene_id : String,
  marker_id : String,
) -> @core.Patch {
  @core.set_string("scenes.\{scene_id}.selectedMarker", marker_id)
}

///|
pub fn set_scene_region_status(
  scene_id : String,
  region_id : String,
  status : String,
) -> @core.Patch {
  @core.set_string("scenes.\{scene_id}.regions.\{region_id}.status", status)
}

///|
pub fn select_scene_region(
  scene_id : String,
  region_id : String,
) -> @core.Patch {
  @core.set_string("scenes.\{scene_id}.selectedRegion", region_id)
}

///|
fn find_asset(assets : Array[SceneAsset], asset_ref : String) -> SceneAsset? {
  if asset_ref == "" {
    None
  } else {
    for item in assets {
      if item.id == asset_ref {
        return Some(item)
      }
    }
    None
  }
}

///|
fn asset_image(asset : SceneAsset, alt : String) -> @core.Node {
  @core.node(kind="image", attrs=[
    @core.class_name("bunnia-scene-sprite"),
    @core.attr("src", asset.src),
    @core.attr("alt", alt),
    @core.data("asset-id", asset.id),
    @core.data("asset-kind", scene_asset_kind_id(asset.kind)),
    @core.data("asset-remote", asset.remote.to_string()),
  ])
}

///|
fn scene_style(size : SceneSize) -> String {
  "width: \{size.width}rpx; height: \{size.height}rpx;"
}

///|
fn marker_style(input : SceneMarker) -> String {
  "left: \{input.x}rpx; top: \{input.y}rpx; min-width: \{input.hit_width}rpx; min-height: \{input.hit_height}rpx;"
}

///|
fn region_style(input : SceneRegion) -> String {
  "left: \{input.x}rpx; top: \{input.y}rpx; width: \{input.width}rpx; height: \{input.height}rpx;"
}

///|
fn status_class(status : String) -> String {
  if status == "" {
    "bunnia-status-default"
  } else {
    "bunnia-status-\{status_slug(status)}"
  }
}

///|
fn status_slug(status : String) -> String {
  status
  .replace(old=" ", new="-")
  .replace(old="_", new="-")
  .replace(old="/", new="-")
  .to_string()
}

///|
fn viewport_scene(input : Scene, viewport : SceneViewport) -> Scene {
  let layers : Array[SceneLayer] = []
  for item in input.layers {
    let markers : Array[SceneMarker] = []
    let regions : Array[SceneRegion] = []
    for scene_marker in item.markers {
      if marker_in_viewport(scene_marker, viewport) {
        markers.push(translate_marker(scene_marker, viewport))
      }
    }
    for scene_region in item.regions {
      if region_in_viewport(scene_region, viewport) {
        regions.push(translate_region(scene_region, viewport))
      }
    }
    layers.push(layer(item.id, item.z_index, markers, regions~))
  }
  scene(input.id, input.size, layers, assets=input.assets)
}

///|
fn translate_marker(
  input : SceneMarker,
  viewport : SceneViewport,
) -> SceneMarker {
  {
    id: input.id,
    label: input.label,
    x: input.x - viewport.x,
    y: input.y - viewport.y,
    status: input.status,
    tap_message: input.tap_message,
    asset_ref: input.asset_ref,
    hit_width: input.hit_width,
    hit_height: input.hit_height,
  }
}

///|
fn translate_region(
  input : SceneRegion,
  viewport : SceneViewport,
) -> SceneRegion {
  {
    id: input.id,
    label: input.label,
    x: input.x - viewport.x,
    y: input.y - viewport.y,
    width: input.width,
    height: input.height,
    status: input.status,
    tap_message: input.tap_message,
  }
}

///|
fn marker_in_viewport(input : SceneMarker, viewport : SceneViewport) -> Bool {
  input.x >= viewport.x &&
  input.y >= viewport.y &&
  input.x < viewport.x + viewport.width &&
  input.y < viewport.y + viewport.height
}

///|
fn region_in_viewport(input : SceneRegion, viewport : SceneViewport) -> Bool {
  input.x + input.width > viewport.x &&
  input.y + input.height > viewport.y &&
  input.x < viewport.x + viewport.width &&
  input.y < viewport.y + viewport.height
}
