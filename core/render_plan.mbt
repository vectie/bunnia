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
  let summary = "Bunnia render plan: \{platform_id(platform)} root=\{root.kind} nodes=\{count} depth=\{depth} components=\{components.length()} events=\{messages.length()} diagnostics=\{diagnostics.length()}"
  {
    platform,
    adapter,
    root_kind: root.kind,
    node_count: count,
    depth,
    component_kinds: components,
    event_messages: messages,
    diagnostics,
    summary,
  }
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
