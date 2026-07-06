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
) -> SceneMarker {
  { id, label, x, y, status, tap_message }
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
) -> Scene {
  { id, size, layers }
}

///|
pub fn static_scene_view(input : Scene) -> @core.Node {
  let children : Array[@core.Node] = []
  for item in input.layers {
    children.push(layer_view(item))
  }
  @core.view_with_attrs(
    [
      @core.class_name("bunnia-scene"),
      @core.data("scene-id", input.id),
      @core.data("scene-width", input.size.width.to_string()),
      @core.data("scene-height", input.size.height.to_string()),
    ],
    children,
  )
}

///|
fn layer_view(input : SceneLayer) -> @core.Node {
  let children : Array[@core.Node] = []
  for item in input.markers {
    children.push(marker_view(item))
  }
  @core.view_with_attrs(
    [
      @core.class_name("bunnia-scene-layer"),
      @core.data("layer-id", input.id),
      @core.data("z-index", input.z_index.to_string()),
    ],
    children,
  )
}

///|
fn marker_view(input : SceneMarker) -> @core.Node {
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
        @core.class_name("bunnia-scene-marker"),
        @core.data("marker-id", input.id),
        @core.data("x", input.x.to_string()),
        @core.data("y", input.y.to_string()),
        @core.data("status", input.status),
      ],
      events~,
      children=[@core.text(input.label)],
    ),
  )
}
