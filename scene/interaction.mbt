///|
pub struct SceneThreadLink {
  id : String
  scene_id : String
  subject_kind : String
  subject_id : String
  thread_id : String
  subject_ref : String
  status : String
  unread_count : Int
  open_message : String
} derive(Debug, Eq)

///|
pub fn scene_thread_link(
  id~ : String,
  scene_id~ : String,
  subject_kind~ : String,
  subject_id~ : String,
  thread_id~ : String,
  subject_ref? : String = "",
  status? : String = "",
  unread_count? : Int = 0,
  open_message? : String = "",
) -> SceneThreadLink {
  {
    id,
    scene_id,
    subject_kind,
    subject_id,
    thread_id,
    subject_ref,
    status,
    unread_count,
    open_message,
  }
}

///|
pub fn scene_marker_thread_link(
  id~ : String,
  scene_id~ : String,
  marker_id~ : String,
  thread_id~ : String,
  subject_ref? : String = "",
  status? : String = "",
  unread_count? : Int = 0,
  open_message? : String = "",
) -> SceneThreadLink {
  scene_thread_link(
    id~,
    scene_id~,
    subject_kind="marker",
    subject_id=marker_id,
    thread_id~,
    subject_ref~,
    status~,
    unread_count~,
    open_message~,
  )
}

///|
pub fn scene_region_thread_link(
  id~ : String,
  scene_id~ : String,
  region_id~ : String,
  thread_id~ : String,
  subject_ref? : String = "",
  status? : String = "",
  unread_count? : Int = 0,
  open_message? : String = "",
) -> SceneThreadLink {
  scene_thread_link(
    id~,
    scene_id~,
    subject_kind="region",
    subject_id=region_id,
    thread_id~,
    subject_ref~,
    status~,
    unread_count~,
    open_message~,
  )
}

///|
pub fn scene_thread_overlay(links : Array[SceneThreadLink]) -> @core.Node {
  windowed_scene_thread_overlay(links, total_count=links.length())
}

///|
pub fn windowed_scene_thread_overlay(
  links : Array[SceneThreadLink],
  total_count~ : Int,
  offset? : Int = 0,
) -> @core.Node {
  let rows : Array[@core.Node] = []
  for item in links {
    rows.push(scene_thread_badge(item, None))
  }
  scene_thread_overlay_node(rows, total_count, offset, false)
}

///|
pub fn anchored_scene_thread_overlay(
  input : Scene,
  links : Array[SceneThreadLink],
) -> @core.Node {
  windowed_anchored_scene_thread_overlay(
    input,
    links,
    total_count=links.length(),
  )
}

///|
pub fn windowed_anchored_scene_thread_overlay(
  input : Scene,
  links : Array[SceneThreadLink],
  total_count~ : Int,
  offset? : Int = 0,
) -> @core.Node {
  let rows : Array[@core.Node] = []
  for item in links {
    rows.push(scene_thread_badge(item, scene_thread_anchor(input, item)))
  }
  scene_thread_overlay_node(rows, total_count, offset, true)
}

///|
pub fn static_scene_with_threads(
  input : Scene,
  links : Array[SceneThreadLink],
) -> @core.Node {
  @core.view_with_attrs([@core.class_name("bunnia-scene-with-threads")], [
    static_scene_view(input),
    anchored_scene_thread_overlay(input, links),
  ])
}

///|
pub fn static_scene_with_windowed_threads(
  input : Scene,
  links : Array[SceneThreadLink],
  total_count~ : Int,
  offset? : Int = 0,
) -> @core.Node {
  @core.view_with_attrs([@core.class_name("bunnia-scene-with-threads")], [
    static_scene_view(input),
    windowed_anchored_scene_thread_overlay(input, links, total_count~, offset~),
  ])
}

///|
pub fn select_scene_thread(
  scene_id : String,
  subject_kind : String,
  subject_id : String,
  thread_id : String,
) -> @core.Patch {
  @core.set_json(
    "scenes.\{scene_id}.selectedThread",
    "{\"subjectKind\":\"\{escape_json(subject_kind)}\",\"subjectId\":\"\{escape_json(subject_id)}\",\"threadId\":\"\{escape_json(thread_id)}\"}",
  )
}

///|
pub fn select_scene_marker_thread(
  scene_id : String,
  marker_id : String,
  thread_id : String,
) -> @core.Patch {
  select_scene_thread(scene_id, "marker", marker_id, thread_id)
}

///|
pub fn select_scene_region_thread(
  scene_id : String,
  region_id : String,
  thread_id : String,
) -> @core.Patch {
  select_scene_thread(scene_id, "region", region_id, thread_id)
}

///|
pub fn set_scene_thread_status(
  scene_id : String,
  thread_id : String,
  status : String,
) -> @core.Patch {
  @core.set_string("scenes.\{scene_id}.threads.\{thread_id}.status", status)
}

///|
pub fn set_scene_thread_unread(
  scene_id : String,
  thread_id : String,
  unread_count : Int,
) -> @core.Patch {
  @core.set_json(
    "scenes.\{scene_id}.threads.\{thread_id}.unreadCount",
    unread_count.to_string(),
  )
}

///|
pub fn append_scene_thread_link(
  target_path : String,
  link : SceneThreadLink,
) -> @core.Patch {
  @core.append_json(target_path, scene_thread_link_json(link))
}

///|
fn scene_thread_overlay_node(
  rows : Array[@core.Node],
  total_count : Int,
  offset : Int,
  anchored : Bool,
) -> @core.Node {
  let class_name = if anchored {
    "bunnia-scene-thread-overlay bunnia-scene-thread-overlay-anchored"
  } else {
    "bunnia-scene-thread-overlay"
  }
  @core.node(
    kind="view",
    attrs=[
      @core.class_name(class_name),
      @core.data("bunnia-list-mode", "windowed"),
      @core.data("thread-overlay-anchored", anchored.to_string()),
      @core.data("total-count", total_count.to_string()),
      @core.data("visible-start", offset.to_string()),
      @core.data("visible-count", rows.length().to_string()),
    ],
    children=rows,
    list_total_count=total_count,
    list_visible_count=rows.length(),
  )
}

///|
fn scene_thread_badge(
  input : SceneThreadLink,
  anchor : (Int, Int)?,
) -> @core.Node {
  let events = if input.open_message == "" {
    []
  } else {
    [@core.tap(input.open_message)]
  }
  let anchor_class = match anchor {
    Some(_) => "bunnia-scene-thread-anchored"
    None => "bunnia-scene-thread-missing-anchor"
  }
  let attrs = [
    @core.class_name(
      "bunnia-scene-thread \{anchor_class} \{scene_thread_status_class(input.status)}",
    ),
    @core.data("scene-thread-id", input.id),
    @core.data("scene-id", input.scene_id),
    @core.data("subject-kind", input.subject_kind),
    @core.data("subject-id", input.subject_id),
    @core.data("thread-id", input.thread_id),
    @core.data("subject-ref", input.subject_ref),
    @core.data("thread-status", input.status),
    @core.data("unread-count", input.unread_count.to_string()),
  ]
  match anchor {
    Some((x, y)) => {
      attrs.push(@core.attr("style", scene_thread_anchor_style(x, y)))
      attrs.push(@core.data("anchor-x", x.to_string()))
      attrs.push(@core.data("anchor-y", y.to_string()))
      attrs.push(@core.data("anchor-state", "anchored"))
    }
    None => {
      attrs.push(@core.data("anchor-x", ""))
      attrs.push(@core.data("anchor-y", ""))
      attrs.push(@core.data("anchor-state", "missing"))
    }
  }
  @core.keyed(
    input.id,
    @core.node(kind="view", attrs~, events~, children=[
      @core.text(input.unread_count.to_string()),
    ]),
  )
}

///|
fn scene_thread_anchor(input : Scene, link : SceneThreadLink) -> (Int, Int)? {
  if link.scene_id != input.id {
    None
  } else {
    match link.subject_kind {
      "marker" => scene_thread_marker_anchor(input, link.subject_id)
      "region" => scene_thread_region_anchor(input, link.subject_id)
      _ => None
    }
  }
}

///|
fn scene_thread_marker_anchor(input : Scene, marker_id : String) -> (Int, Int)? {
  for scene_layer in input.layers {
    for scene_marker in scene_layer.markers {
      if scene_marker.id == marker_id {
        return Some(
          (
            scene_marker.x + scene_marker.hit_width / 2,
            scene_marker.y + scene_marker.hit_height / 2,
          ),
        )
      }
    }
  }
  None
}

///|
fn scene_thread_region_anchor(input : Scene, region_id : String) -> (Int, Int)? {
  for scene_layer in input.layers {
    for scene_region in scene_layer.regions {
      if scene_region.id == region_id {
        return Some(
          (
            scene_region.x + scene_region.width / 2,
            scene_region.y + scene_region.height / 2,
          ),
        )
      }
    }
  }
  None
}

///|
fn scene_thread_anchor_style(x : Int, y : Int) -> String {
  "left: \{x}rpx; top: \{y}rpx;"
}

///|
fn scene_thread_link_json(input : SceneThreadLink) -> String {
  "{" +
  "\"id\":\"\{escape_json(input.id)}\"," +
  "\"sceneId\":\"\{escape_json(input.scene_id)}\"," +
  "\"subjectKind\":\"\{escape_json(input.subject_kind)}\"," +
  "\"subjectId\":\"\{escape_json(input.subject_id)}\"," +
  "\"threadId\":\"\{escape_json(input.thread_id)}\"," +
  "\"subjectRef\":\"\{escape_json(input.subject_ref)}\"," +
  "\"status\":\"\{escape_json(input.status)}\"," +
  "\"unreadCount\":\{input.unread_count}," +
  "\"openMessage\":\"\{escape_json(input.open_message)}\"" +
  "}"
}

///|
fn scene_thread_status_class(status : String) -> String {
  if status == "" {
    "bunnia-scene-thread-default"
  } else {
    "bunnia-scene-thread-\{status}"
  }
}

///|
fn escape_json(value : String) -> String {
  value
  .replace(old="\\", new="\\\\")
  .replace(old="\"", new="\\\"")
  .replace(old="\n", new="\\n")
  .to_string()
}
