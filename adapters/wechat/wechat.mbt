///|
pub struct WechatPage {
  wxml : String
  wxss : String
  js : String
  json : String
  plan : @core.RenderPlan
} derive(Debug, Eq)

///|
pub struct WechatEventPatch {
  message : String
  patches : Array[@core.Patch]
} derive(Debug, Eq)

///|
pub struct WechatRuntime {
  initial_data_json : String
  event_patches : Array[WechatEventPatch]
} derive(Debug, Eq)

///|
pub struct WechatFile {
  path : String
  content : String
} derive(Debug, Eq)

///|
pub struct WechatProject {
  name : String
  route : String
  page : WechatPage
  files : Array[WechatFile]
  total_bytes : Int
  summary : String
} derive(Debug, Eq)

///|
pub fn generate_page(name : String, root : @core.Node) -> WechatPage {
  generate_page_with_runtime(name, root, default_runtime())
}

///|
pub fn generate_page_with_runtime(
  name : String,
  root : @core.Node,
  runtime : WechatRuntime,
) -> WechatPage {
  let plan = @core.plan(root, @core.Wechat)
  {
    wxml: render_node(root, @core.adapter(@core.Wechat)),
    wxss: default_wxss(),
    js: page_js(name, plan, runtime),
    json: "{ \"navigationBarTitleText\": \"\{escape_json(name)}\" }",
    plan,
  }
}

///|
pub fn generate_project(
  name~ : String,
  route? : String = "pages/index/index",
  root~ : @core.Node,
) -> WechatProject {
  generate_project_with_runtime(name~, route~, root~, runtime=default_runtime())
}

///|
pub fn generate_project_with_runtime(
  name~ : String,
  route? : String = "pages/index/index",
  root~ : @core.Node,
  runtime~ : WechatRuntime,
) -> WechatProject {
  let page = generate_page_with_runtime(name, root, runtime)
  let files = [
    wechat_file("app.json", app_json(route)),
    wechat_file("project.config.json", project_config_json(name)),
    wechat_file("sitemap.json", sitemap_json()),
    wechat_file("\{route}.wxml", page.wxml),
    wechat_file("\{route}.wxss", page.wxss),
    wechat_file("\{route}.js", page.js),
    wechat_file("\{route}.json", page.json),
  ]
  let total = total_file_bytes(files)
  {
    name,
    route,
    page,
    files,
    total_bytes: total,
    summary: "Bunnia WeChat project: files=\{files.length()} bytes=\{total} route=\{route}",
  }
}

///|
pub fn default_runtime() -> WechatRuntime {
  { initial_data_json: "{}", event_patches: [] }
}

///|
pub fn runtime(
  initial_data_json? : String = "{}",
  event_patches? : Array[WechatEventPatch] = [],
) -> WechatRuntime {
  { initial_data_json, event_patches }
}

///|
pub fn event_patch(
  message : String,
  patches : Array[@core.Patch],
) -> WechatEventPatch {
  { message, patches }
}

///|
pub fn generate_set_data_call(patches : Array[@core.Patch]) -> String {
  "this.setData(\{patches_to_object(patches)})"
}

///|
fn wechat_file(path : String, content : String) -> WechatFile {
  { path, content }
}

///|
fn total_file_bytes(files : Array[WechatFile]) -> Int {
  let mut total = 0
  for item in files {
    total += item.content.length()
  }
  total
}

///|
fn app_json(route : String) -> String {
  "{\n" +
  "  \"pages\": [\"\{escape_json(route)}\"],\n" +
  "  \"window\": {\n" +
  "    \"navigationBarTitleText\": \"Bunnia\",\n" +
  "    \"navigationBarBackgroundColor\": \"#ffffff\",\n" +
  "    \"navigationBarTextStyle\": \"black\"\n" +
  "  }\n" +
  "}\n"
}

///|
fn project_config_json(name : String) -> String {
  "{\n" +
  "  \"appid\": \"touristappid\",\n" +
  "  \"projectname\": \"\{escape_json(name)}\",\n" +
  "  \"compileType\": \"miniprogram\",\n" +
  "  \"setting\": {\n" +
  "    \"es6\": true,\n" +
  "    \"minified\": false\n" +
  "  }\n" +
  "}\n"
}

///|
fn sitemap_json() -> String {
  "{\n" +
  "  \"rules\": [\n" +
  "    { \"action\": \"allow\", \"page\": \"*\" }\n" +
  "  ]\n" +
  "}\n"
}

///|
fn patches_to_object(patches : Array[@core.Patch]) -> String {
  let out = StringBuilder::new()
  out.write_string("{")
  for i in 0..<patches.length() {
    let item = patches[i]
    if i > 0 {
      out.write_string(",")
    }
    out.write_string("\"")
    out.write_string(escape_json(item.path))
    out.write_string("\":")
    out.write_string(item.value_json)
  }
  out.write_string("}")
  out.to_string()
}

///|
fn render_node(root : @core.Node, adapter : @core.PlatformAdapter) -> String {
  let kind = component_name(root.kind, adapter)
  if kind == "page" {
    render_children(root.children, adapter)
  } else {
    let attrs = render_attrs(root, adapter)
    if root.children.length() == 0 && root.text == "" {
      "<\{kind}\{attrs}></\{kind}>"
    } else {
      "<\{kind}\{attrs}>\{escape_xml(root.text)}\{render_children(root.children, adapter)}</\{kind}>"
    }
  }
}

///|
fn render_children(
  children : Array[@core.Node],
  adapter : @core.PlatformAdapter,
) -> String {
  let out = StringBuilder::new()
  for child in children {
    out.write_string(render_node(child, adapter))
  }
  out.to_string()
}

///|
fn render_attrs(root : @core.Node, adapter : @core.PlatformAdapter) -> String {
  let out = StringBuilder::new()
  if root.key != "" {
    out.write_string(" data-bunnia-key=\"\{escape_xml(root.key)}\"")
  }
  for attr in root.attrs {
    out.write_string(" \{attr.name}=\"\{escape_xml(attr.value)}\"")
  }
  for binding in root.events {
    let event_name = if binding.event == "tap" {
      adapter.tap_event
    } else {
      binding.event
    }
    out.write_string(" \{event_name}=\"__bunniaEvent\"")
    out.write_string(" data-bunnia-message=\"\{escape_xml(binding.message)}\"")
  }
  out.to_string()
}

///|
fn component_name(kind : String, adapter : @core.PlatformAdapter) -> String {
  if kind == "page" {
    adapter.page_component
  } else {
    "\{adapter.component_prefix}\{kind}"
  }
}

///|
fn page_js(
  name : String,
  plan : @core.RenderPlan,
  runtime : WechatRuntime,
) -> String {
  "const __bunniaEventPatches = \{event_patches_object(runtime.event_patches)}\n" +
  "\n" +
  "Page({\n" +
  "  data: {\n" +
  "    __bunnia: {\n" +
  "      name: \"\{escape_json(name)}\",\n" +
  "      nodes: \{plan.node_count},\n" +
  "      depth: \{plan.depth},\n" +
  "      lastMessage: \"\",\n" +
  "      handledEvents: 0\n" +
  "    },\n" +
  "    ...(\{runtime.initial_data_json})\n" +
  "  },\n" +
  "  __bunniaEvent(event) {\n" +
  "    const message = event.currentTarget.dataset.bunniaMessage\n" +
  "    const patches = __bunniaEventPatches[message] || {}\n" +
  "    this.setData({\n" +
  "      \"__bunnia.lastMessage\": message,\n" +
  "      \"__bunnia.handledEvents\": (this.data.__bunnia.handledEvents || 0) + 1,\n" +
  "      ...patches\n" +
  "    })\n" +
  "  }\n" +
  "})"
}

///|
fn event_patches_object(items : Array[WechatEventPatch]) -> String {
  let out = StringBuilder::new()
  out.write_string("{")
  for i in 0..<items.length() {
    let item = items[i]
    if i > 0 {
      out.write_string(",")
    }
    out.write_string("\"")
    out.write_string(escape_json(item.message))
    out.write_string("\":")
    out.write_string(patches_to_object(item.patches))
  }
  out.write_string("}")
  out.to_string()
}

///|
fn default_wxss() -> String {
  ".bunnia-message { padding: 16rpx 20rpx; border-bottom: 1rpx solid #e5e7eb; }\n" +
  ".bunnia-review { display: flex; gap: 12rpx; align-items: center; }\n" +
  ".bunnia-scene { position: relative; overflow: hidden; }\n" +
  ".bunnia-scene-layer { position: absolute; inset: 0; }\n" +
  ".bunnia-scene-marker { position: absolute; min-width: 88rpx; min-height: 56rpx; }"
}

///|
fn escape_xml(value : String) -> String {
  value
  .replace(old="&", new="&amp;")
  .replace(old="<", new="&lt;")
  .replace(old=">", new="&gt;")
  .replace(old="\"", new="&quot;")
  .to_string()
}

///|
fn escape_json(value : String) -> String {
  value
  .replace(old="\\", new="\\\\")
  .replace(old="\"", new="\\\"")
  .replace(old="\n", new="\\n")
  .to_string()
}
