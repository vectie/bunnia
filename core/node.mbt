///|
pub struct Attr {
  name : String
  value : String
} derive(Debug, Eq)

///|
pub impl Show for Attr with fn output(self : Attr, logger : &Logger) -> Unit {
  logger.write_string("Attr(\{self.name}=\{self.value})")
}

///|
pub struct EventBinding {
  event : String
  message : String
} derive(Debug, Eq)

///|
pub impl Show for EventBinding with fn output(
  self : EventBinding,
  logger : &Logger,
) -> Unit {
  logger.write_string("EventBinding(\{self.event}->\{self.message})")
}

///|
pub struct Node {
  kind : String
  key : String
  attrs : Array[Attr]
  events : Array[EventBinding]
  children : Array[Node]
  text : String
} derive(Debug, Eq)

///|
pub impl Show for Node with fn output(self : Node, logger : &Logger) -> Unit {
  logger.write_string(
    "Node(kind=\{self.kind}, key=\{self.key}, attrs=\{self.attrs.length()}, events=\{self.events.length()}, children=\{self.children.length()}, text=\{self.text.length()})",
  )
}

///|
pub fn attr(name : String, value : String) -> Attr {
  { name, value }
}

///|
pub fn class_name(value : String) -> Attr {
  attr("class", value)
}

///|
pub fn id(value : String) -> Attr {
  attr("id", value)
}

///|
pub fn data(name : String, value : String) -> Attr {
  attr("data-\{name}", value)
}

///|
pub fn event(event : String, message : String) -> EventBinding {
  { event, message }
}

///|
pub fn tap(message : String) -> EventBinding {
  event("tap", message)
}

///|
pub fn node(
  kind~ : String,
  key? : String = "",
  attrs? : Array[Attr] = [],
  events? : Array[EventBinding] = [],
  children? : Array[Node] = [],
  text? : String = "",
) -> Node {
  { kind, key, attrs, events, children, text }
}

///|
pub fn keyed(key : String, child : Node) -> Node {
  {
    kind: child.kind,
    key,
    attrs: child.attrs,
    events: child.events,
    children: child.children,
    text: child.text,
  }
}

///|
pub fn page(children : Array[Node]) -> Node {
  node(kind="page", children~)
}

///|
pub fn view(children : Array[Node]) -> Node {
  node(kind="view", children~)
}

///|
pub fn view_with_attrs(attrs : Array[Attr], children : Array[Node]) -> Node {
  node(kind="view", attrs~, children~)
}

///|
pub fn scroll_view(children : Array[Node]) -> Node {
  node(kind="scroll-view", children~)
}

///|
pub fn text(value : String) -> Node {
  node(kind="text", text=value)
}

///|
pub fn input(
  name~ : String,
  value? : String = "",
  input_message? : String = "",
) -> Node {
  let events = if input_message == "" {
    []
  } else {
    [event("input", input_message)]
  }
  node(kind="input", attrs=[attr("name", name), attr("value", value)], events~)
}

///|
pub fn form(submit_message : String, children : Array[Node]) -> Node {
  node(kind="form", events=[event("submit", submit_message)], children~)
}

///|
pub fn[Item] list(items : Array[Item], render : (Item) -> Node) -> Node {
  let children : Array[Node] = []
  for item in items {
    children.push(render(item))
  }
  node(kind="view", attrs=[class_name("bunnia-list")], children~)
}

///|
pub fn when(condition : Bool, child : Node) -> Node {
  if condition {
    child
  } else {
    view([])
  }
}

///|
pub fn image(src : String, alt : String) -> Node {
  node(kind="image", attrs=[attr("src", src), attr("alt", alt)])
}

///|
pub fn button(label : String, message : String) -> Node {
  node(kind="button", events=[tap(message)], children=[text(label)])
}

///|
pub fn canvas(canvas_id : String) -> Node {
  node(kind="canvas", attrs=[id(canvas_id)])
}

///|
pub fn custom(
  kind : String,
  attrs : Array[Attr],
  children : Array[Node],
) -> Node {
  node(kind~, attrs~, children~)
}

///|
pub fn node_count(root : Node) -> Int {
  let mut count = 1
  for child in root.children {
    count += node_count(child)
  }
  count
}

///|
pub fn max_depth(root : Node) -> Int {
  let mut depth = 1
  for child in root.children {
    let child_depth = max_depth(child) + 1
    if child_depth > depth {
      depth = child_depth
    }
  }
  depth
}
