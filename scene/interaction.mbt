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
    rows.push(scene_thread_badge(item))
  }
  @core.node(
    kind="view",
    attrs=[
      @core.class_name("bunnia-scene-thread-overlay"),
      @core.data("bunnia-list-mode", "windowed"),
      @core.data("total-count", total_count.to_string()),
      @core.data("visible-start", offset.to_string()),
      @core.data("visible-count", links.length().to_string()),
    ],
    children=rows,
    list_total_count=total_count,
    list_visible_count=links.length(),
  )
}

///|
pub fn static_scene_with_threads(
  input : Scene,
  links : Array[SceneThreadLink],
) -> @core.Node {
  @core.view_with_attrs([@core.class_name("bunnia-scene-with-threads")], [
    static_scene_view(input),
    scene_thread_overlay(links),
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
    windowed_scene_thread_overlay(links, total_count~, offset~),
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
fn scene_thread_badge(input : SceneThreadLink) -> @core.Node {
  let events = if input.open_message == "" {
    []
  } else {
    [@core.tap(input.open_message)]
  }
  @core.keyed(
    input.id,
    @core.node(
      kind="view",
      attrs=[
        @core.class_name(
          "bunnia-scene-thread \{scene_thread_status_class(input.status)}",
        ),
        @core.data("scene-thread-id", input.id),
        @core.data("scene-id", input.scene_id),
        @core.data("subject-kind", input.subject_kind),
        @core.data("subject-id", input.subject_id),
        @core.data("thread-id", input.thread_id),
        @core.data("subject-ref", input.subject_ref),
        @core.data("thread-status", input.status),
        @core.data("unread-count", input.unread_count.to_string()),
      ],
      events~,
      children=[@core.text(input.unread_count.to_string())],
    ),
  )
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
