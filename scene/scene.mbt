///|
pub struct SceneSize {
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
} derive(Debug, Eq)

///|
pub struct SceneLayer {
  id : String
  z_index : Int
  markers : Array[SceneMarker]
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
pub fn marker(
  id~ : String,
  label~ : String,
  x~ : Int,
  y~ : Int,
  status? : String = "",
  tap_message? : String = "",
  asset_ref? : String = "",
) -> SceneMarker {
  { id, label, x, y, status, tap_message, asset_ref }
}

///|
pub fn layer(
  id : String,
  z_index : Int,
  markers : Array[SceneMarker],
) -> SceneLayer {
  { id, z_index, markers }
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
  let rendered = if plan.marker_count > budget.max_markers {
    limit_scene_markers(input, budget.max_markers)
  } else {
    input
  }
  scene_view(rendered, [
    @core.data("scene-mode", scene_render_mode_id(plan.mode)),
    @core.data("scene-quality", scene_quality_id(plan.quality)),
    @core.data("markers-total", plan.marker_count.to_string()),
    @core.data("markers-visible", scene_marker_count(rendered).to_string()),
    @core.data(
      "scene-degraded",
      (plan.marker_count > scene_marker_count(rendered)).to_string(),
    ),
  ])
}

///|
fn scene_view(input : Scene, extra_attrs : Array[@core.Attr]) -> @core.Node {
  let children : Array[@core.Node] = []
  for item in input.layers {
    children.push(layer_view(item, input.assets))
  }
  let attrs = [
    @core.class_name("bunnia-scene"),
    @core.attr("style", scene_style(input.size)),
    @core.data("scene-id", input.id),
    @core.data("scene-width", input.size.width.to_string()),
    @core.data("scene-height", input.size.height.to_string()),
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
  "left: \{input.x}rpx; top: \{input.y}rpx;"
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
