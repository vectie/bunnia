///|
pub struct RenderBudget {
  max_nodes : Int
  max_depth : Int
  max_events : Int
  max_initial_data_bytes : Int
} derive(Debug, Eq)

///|
pub fn default_render_budget() -> RenderBudget {
  {
    max_nodes: 800,
    max_depth: 18,
    max_events: 160,
    max_initial_data_bytes: 65536,
  }
}

///|
pub fn render_budget(
  max_nodes~ : Int,
  max_depth~ : Int,
  max_events~ : Int,
  max_initial_data_bytes~ : Int,
) -> RenderBudget {
  { max_nodes, max_depth, max_events, max_initial_data_bytes }
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
pub fn plan_with_budget(
  root : Node,
  platform : Platform,
  budget : RenderBudget,
) -> RenderPlan {
  let components : Array[String] = []
  let messages : Array[String] = []
  collect_node(root, components, messages)
  let adapter = adapter(platform)
  let count = node_count(root)
  let depth = max_depth(root)
  let windowed_lists = windowed_list_count(root)
  let total_items = list_total_count(root)
  let visible_items = list_visible_count(root)
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
  let summary = "Bunnia render plan: \{platform_id(platform)} root=\{root.kind} nodes=\{count} depth=\{depth} components=\{components.length()} events=\{messages.length()} windowed_lists=\{windowed_lists} list_items=\{visible_items}/\{total_items} diagnostics=\{diagnostics.length()}"
  {
    platform,
    adapter,
    root_kind: root.kind,
    node_count: count,
    depth,
    windowed_list_count: windowed_lists,
    list_total_count: total_items,
    list_visible_count: visible_items,
    component_kinds: components,
    event_messages: messages,
    diagnostics,
    summary,
  }
}

///|
fn windowed_list_count(root : Node) -> Int {
  let mut total = if root.kind == "windowed-list" { 1 } else { 0 }
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
