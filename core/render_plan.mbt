///|
pub struct RenderBudget {
  max_nodes : Int
  max_depth : Int
  max_events : Int
  max_initial_data_bytes : Int
  max_unwindowed_list_children : Int
  max_scene_markers : Int
  max_scene_assets : Int
  max_degraded_scenes : Int
} derive(Debug, Eq)

///|
pub fn default_render_budget() -> RenderBudget {
  {
    max_nodes: 800,
    max_depth: 18,
    max_events: 160,
    max_initial_data_bytes: 65536,
    max_unwindowed_list_children: 64,
    max_scene_markers: 600,
    max_scene_assets: 64,
    max_degraded_scenes: 0,
  }
}

///|
pub fn render_budget(
  max_nodes~ : Int,
  max_depth~ : Int,
  max_events~ : Int,
  max_initial_data_bytes~ : Int,
  max_unwindowed_list_children? : Int = 64,
  max_scene_markers? : Int = 600,
  max_scene_assets? : Int = 64,
  max_degraded_scenes? : Int = 0,
) -> RenderBudget {
  {
    max_nodes,
    max_depth,
    max_events,
    max_initial_data_bytes,
    max_unwindowed_list_children,
    max_scene_markers,
    max_scene_assets,
    max_degraded_scenes,
  }
}

///|
pub struct RenderPlan {
  platform : Platform
  adapter : PlatformAdapter
  root_kind : String
  node_count : Int
  depth : Int
  windowed_list_count : Int
  list_total_count : Int
  list_visible_count : Int
  unwindowed_list_child_count : Int
  unkeyed_list_child_count : Int
  duplicate_list_key_count : Int
  canvas_count : Int
  unsupported_canvas_count : Int
  scene_count : Int
  scene_marker_count : Int
  scene_visible_marker_count : Int
  scene_asset_count : Int
  degraded_scene_count : Int
  component_kinds : Array[String]
  event_messages : Array[String]
  diagnostics : Array[String]
  summary : String
} derive(Debug, Eq)

///|
pub impl Show for RenderPlan with fn output(self : RenderPlan, logger : &Logger) -> Unit {
  logger.write_string(self.summary)
}

///|
pub fn plan(root : Node, platform : Platform) -> RenderPlan {
  plan_with_budget(root, platform, default_render_budget())
}

///|
pub fn plan_for_adapter(root : Node, adapter : PlatformAdapter) -> RenderPlan {
  plan_for_adapter_with_budget(root, adapter, default_render_budget())
}

///|
pub fn plan_with_budget(
  root : Node,
  platform : Platform,
  budget : RenderBudget,
) -> RenderPlan {
  plan_for_adapter_with_budget(root, adapter(platform), budget)
}

///|
pub fn plan_for_adapter_with_budget(
  root : Node,
  adapter : PlatformAdapter,
  budget : RenderBudget,
) -> RenderPlan {
  let components : Array[String] = []
  let messages : Array[String] = []
  collect_node(root, components, messages)
  let count = node_count(root)
  let depth = max_depth(root)
  let windowed_lists = windowed_list_count(root)
  let total_items = list_total_count(root)
  let visible_items = list_visible_count(root)
  let unwindowed_list_children = unwindowed_list_child_count(root)
  let unkeyed_list_children = unkeyed_list_child_count(root)
  let duplicate_list_keys = duplicate_list_key_count(root)
  let canvas_count = component_kind_count(root, "canvas")
  let scenes = scene_count(root)
  let scene_markers = scene_marker_count(root)
  let scene_visible_markers = scene_visible_marker_count(root)
  let scene_assets = scene_asset_count(root)
  let degraded_scenes = degraded_scene_count(root)
  let unsupported_canvas_count = if canvas_count > 0 && !adapter.supports_canvas {
    canvas_count
  } else {
    0
  }
  let diagnostics : Array[String] = []
  if count > budget.max_nodes {
    diagnostics.push("node-count-over-budget:\{count}/\{budget.max_nodes}")
  }
  if depth > budget.max_depth {
    diagnostics.push("depth-over-budget:\{depth}/\{budget.max_depth}")
  }
  if messages.length() > budget.max_events {
    diagnostics.push(
      "event-count-over-budget:\{messages.length()}/\{budget.max_events}",
    )
  }
  if unwindowed_list_children > budget.max_unwindowed_list_children {
    diagnostics.push(
      "unwindowed-list-children-over-budget:\{unwindowed_list_children}/\{budget.max_unwindowed_list_children}",
    )
  }
  if unkeyed_list_children > 0 {
    diagnostics.push("list-child-missing-key:\{unkeyed_list_children}")
  }
  if duplicate_list_keys > 0 {
    diagnostics.push("list-child-duplicate-key:\{duplicate_list_keys}")
  }
  if unsupported_canvas_count > 0 {
    diagnostics.push(
      "canvas-unsupported:\{adapter.id}:\{unsupported_canvas_count}",
    )
  }
  if scene_markers > budget.max_scene_markers {
    diagnostics.push(
      "scene-marker-count-over-budget:\{scene_markers}/\{budget.max_scene_markers}",
    )
  }
  if scene_assets > budget.max_scene_assets {
    diagnostics.push(
      "scene-asset-count-over-budget:\{scene_assets}/\{budget.max_scene_assets}",
    )
  }
  if degraded_scenes > budget.max_degraded_scenes {
    diagnostics.push(
      "scene-degraded-count-over-budget:\{degraded_scenes}/\{budget.max_degraded_scenes}",
    )
  }
  let summary = "Bunnia render plan: \{adapter.id} root=\{root.kind} nodes=\{count} depth=\{depth} components=\{components.length()} events=\{messages.length()} windowed_lists=\{windowed_lists} list_items=\{visible_items}/\{total_items} unwindowed_list_children=\{unwindowed_list_children} unkeyed_list_children=\{unkeyed_list_children} duplicate_list_keys=\{duplicate_list_keys} canvas=\{canvas_count} unsupported_canvas=\{unsupported_canvas_count} scenes=\{scenes} scene_markers=\{scene_visible_markers}/\{scene_markers} scene_assets=\{scene_assets} degraded_scenes=\{degraded_scenes} diagnostics=\{diagnostics.length()}"
  {
    platform: adapter.platform,
    adapter,
    root_kind: root.kind,
    node_count: count,
    depth,
    windowed_list_count: windowed_lists,
    list_total_count: total_items,
    list_visible_count: visible_items,
    unwindowed_list_child_count: unwindowed_list_children,
    unkeyed_list_child_count: unkeyed_list_children,
    duplicate_list_key_count: duplicate_list_keys,
    canvas_count,
    unsupported_canvas_count,
    scene_count: scenes,
    scene_marker_count: scene_markers,
    scene_visible_marker_count: scene_visible_markers,
    scene_asset_count: scene_assets,
    degraded_scene_count: degraded_scenes,
    component_kinds: components,
    event_messages: messages,
    diagnostics,
    summary,
  }
}

///|
fn component_kind_count(root : Node, kind : String) -> Int {
  let mut total = if root.kind == kind { 1 } else { 0 }
  for child in root.children {
    total += component_kind_count(child, kind)
  }
  total
}

///|
fn duplicate_list_key_count(root : Node) -> Int {
  let mut total = if is_repeated_surface(root) {
    immediate_duplicate_key_count(root)
  } else {
    0
  }
  for child in root.children {
    total += duplicate_list_key_count(child)
  }
  total
}

///|
fn immediate_duplicate_key_count(root : Node) -> Int {
  let mut total = 0
  for i in 0..<root.children.length() {
    let child = root.children[i]
    if child.key != "" && child.kind != "text" {
      let mut seen = false
      for j in 0..<i {
        if root.children[j].key == child.key {
          seen = true
        }
      }
      if seen {
        total += 1
      }
    }
  }
  total
}

///|
fn unkeyed_list_child_count(root : Node) -> Int {
  let mut total = if is_repeated_surface(root) {
    immediate_unkeyed_child_count(root)
  } else {
    0
  }
  for child in root.children {
    total += unkeyed_list_child_count(child)
  }
  total
}

///|
fn unwindowed_list_child_count(root : Node) -> Int {
  let mut total = if is_repeated_surface(root) && !is_windowed_surface(root) {
    immediate_repeated_child_count(root)
  } else {
    0
  }
  for child in root.children {
    total += unwindowed_list_child_count(child)
  }
  total
}

///|
fn immediate_repeated_child_count(root : Node) -> Int {
  let mut total = 0
  for child in root.children {
    if child.kind != "text" {
      total += 1
    }
  }
  total
}

///|
fn immediate_unkeyed_child_count(root : Node) -> Int {
  let mut total = 0
  for child in root.children {
    if child.key == "" && child.kind != "text" {
      total += 1
    }
  }
  total
}

///|
fn is_repeated_surface(root : Node) -> Bool {
  is_windowed_surface(root) ||
  class_contains(root, "bunnia-list") ||
  class_contains(root, "bunnia-message-feed") ||
  class_contains(root, "bunnia-communication-trace")
}

///|
fn is_windowed_surface(root : Node) -> Bool {
  root.kind == "windowed-list" ||
  root.list_total_count > 0 ||
  root.list_visible_count > 0 ||
  attr_equals(root, "data-bunnia-list-mode", "windowed")
}

///|
fn attr_equals(root : Node, name : String, value : String) -> Bool {
  for item in root.attrs {
    if item.name == name && item.value == value {
      return true
    }
  }
  false
}

///|
fn attr_value(root : Node, name : String) -> String {
  for item in root.attrs {
    if item.name == name {
      return item.value
    }
  }
  ""
}

///|
fn attr_int(root : Node, name : String) -> Int? {
  let value = attr_value(root, name)
  if value == "" {
    None
  } else {
    parse_non_negative_int(value)
  }
}

///|
fn parse_non_negative_int(value : String) -> Int? {
  let mut total = 0
  if value.length() == 0 {
    return None
  }
  for i in 0..<value.length() {
    let code = value[i].to_int()
    if code < 48 || code > 57 {
      return None
    }
    total = total * 10 + (code - 48)
  }
  Some(total)
}

///|
fn class_contains(root : Node, value : String) -> Bool {
  for item in root.attrs {
    if item.name == "class" && item.value.contains(value) {
      return true
    }
  }
  false
}

///|
fn is_scene_root(root : Node) -> Bool {
  attr_value(root, "data-scene-id") != ""
}

///|
fn scene_count(root : Node) -> Int {
  let mut total = if is_scene_root(root) { 1 } else { 0 }
  for child in root.children {
    total += scene_count(child)
  }
  total
}

///|
fn scene_marker_count(root : Node) -> Int {
  if is_scene_root(root) {
    match attr_int(root, "data-markers-total") {
      Some(value) => value
      None => rendered_scene_marker_count(root)
    }
  } else {
    let mut total = 0
    for child in root.children {
      total += scene_marker_count(child)
    }
    total
  }
}

///|
fn scene_visible_marker_count(root : Node) -> Int {
  if is_scene_root(root) {
    match attr_int(root, "data-markers-visible") {
      Some(value) => value
      None => rendered_scene_marker_count(root)
    }
  } else {
    let mut total = 0
    for child in root.children {
      total += scene_visible_marker_count(child)
    }
    total
  }
}

///|
fn rendered_scene_marker_count(root : Node) -> Int {
  let mut total = if attr_value(root, "data-marker-id") != "" { 1 } else { 0 }
  for child in root.children {
    total += rendered_scene_marker_count(child)
  }
  total
}

///|
fn scene_asset_count(root : Node) -> Int {
  let mut total = if is_scene_root(root) {
    match attr_int(root, "data-scene-assets") {
      Some(value) => value
      None => 0
    }
  } else {
    0
  }
  for child in root.children {
    total += scene_asset_count(child)
  }
  total
}

///|
fn degraded_scene_count(root : Node) -> Int {
  let mut total = if attr_equals(root, "data-scene-degraded", "true") {
    1
  } else {
    0
  }
  for child in root.children {
    total += degraded_scene_count(child)
  }
  total
}

///|
fn windowed_list_count(root : Node) -> Int {
  let mut total = if root.list_total_count > 0 || root.list_visible_count > 0 {
    1
  } else {
    0
  }
  for child in root.children {
    total += windowed_list_count(child)
  }
  total
}

///|
fn list_total_count(root : Node) -> Int {
  let mut total = root.list_total_count
  for child in root.children {
    total += list_total_count(child)
  }
  total
}

///|
fn list_visible_count(root : Node) -> Int {
  let mut total = root.list_visible_count
  for child in root.children {
    total += list_visible_count(child)
  }
  total
}

///|
fn collect_node(
  root : Node,
  components : Array[String],
  messages : Array[String],
) -> Unit {
  push_unique(components, root.kind)
  for binding in root.events {
    push_unique(messages, binding.message)
  }
  for child in root.children {
    collect_node(child, components, messages)
  }
}

///|
fn push_unique(items : Array[String], value : String) -> Unit {
  if !items.contains(value) {
    items.push(value)
  }
}
