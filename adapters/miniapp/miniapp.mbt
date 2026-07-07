///|
pub struct MiniappPage {
  platform : @core.Platform
  adapter : @core.PlatformAdapter
  markup : String
  style : String
  js : String
  json : String
  plan : @core.RenderPlan
  render_budget : @core.RenderBudget
  markup_extension : String
  style_extension : String
} derive(Debug, Eq)

///|
pub struct MiniappProjectPage {
  name : String
  route : String
  page : MiniappPage
} derive(Debug, Eq)

///|
pub struct MiniappFile {
  path : String
  content : String
} derive(Debug, Eq)

///|
pub struct MiniappProject {
  platform : @core.Platform
  adapter : @core.PlatformAdapter
  name : String
  route : String
  page : MiniappPage
  pages : Array[MiniappProjectPage]
  files : Array[MiniappFile]
  total_bytes : Int
  summary : String
} derive(Debug, Eq)

///|
pub fn generate_alipay_page(name : String, root : @core.Node) -> MiniappPage {
  generate_page(name, root, platform=@core.Alipay)
}

///|
pub fn generate_tiktok_page(name : String, root : @core.Node) -> MiniappPage {
  generate_page(name, root, platform=@core.TikTok)
}

///|
pub fn generate_page(
  name : String,
  root : @core.Node,
  platform~ : @core.Platform,
) -> MiniappPage {
  generate_page_with_budget(
    name,
    root,
    platform~,
    render_budget=@core.default_render_budget(),
  )
}

///|
pub fn generate_page_with_budget(
  name : String,
  root : @core.Node,
  platform~ : @core.Platform,
  render_budget~ : @core.RenderBudget,
) -> MiniappPage {
  let adapter = @core.adapter(platform)
  let plan = @core.plan_for_adapter_with_budget(root, adapter, render_budget)
  {
    platform,
    adapter,
    markup: render_node(root, adapter),
    style: default_style(),
    js: page_js(name, plan),
    json: page_json(name),
    plan,
    render_budget,
    markup_extension: markup_extension(platform),
    style_extension: style_extension(platform),
  }
}

///|
pub fn generate_alipay_project(
  name~ : String,
  route? : String = "pages/index/index",
  root~ : @core.Node,
) -> MiniappProject {
  generate_project(name~, route~, root~, platform=@core.Alipay)
}

///|
pub fn generate_tiktok_project(
  name~ : String,
  route? : String = "pages/index/index",
  root~ : @core.Node,
) -> MiniappProject {
  generate_project(name~, route~, root~, platform=@core.TikTok)
}

///|
pub fn generate_project(
  name~ : String,
  route? : String = "pages/index/index",
  root~ : @core.Node,
  platform~ : @core.Platform,
) -> MiniappProject {
  generate_project_with_budget(
    name~,
    route~,
    root~,
    platform~,
    render_budget=@core.default_render_budget(),
  )
}

///|
pub fn generate_project_with_budget(
  name~ : String,
  route? : String = "pages/index/index",
  root~ : @core.Node,
  platform~ : @core.Platform,
  render_budget~ : @core.RenderBudget,
) -> MiniappProject {
  let page = generate_page_with_budget(name, root, platform~, render_budget~)
  generate_project_from_pages(name~, pages=[{ name, route, page }])
}

///|
pub fn generate_project_from_pages(
  name~ : String,
  pages~ : Array[MiniappProjectPage],
) -> MiniappProject {
  if pages.length() == 0 {
    panic()
  }
  let entry = pages[0]
  let platform = entry.page.platform
  let adapter = entry.page.adapter
  let files : Array[MiniappFile] = [
    miniapp_file("app.json", app_json(pages)),
    miniapp_file("app.\{entry.page.style_extension}", entry.page.style),
  ]
  for item in pages {
    files.push(
      miniapp_file(
        "\{item.route}.\{item.page.markup_extension}",
        item.page.markup,
      ),
    )
    files.push(
      miniapp_file(
        "\{item.route}.\{item.page.style_extension}",
        item.page.style,
      ),
    )
    files.push(miniapp_file("\{item.route}.js", item.page.js))
    files.push(miniapp_file("\{item.route}.json", item.page.json))
  }
  let total = total_file_bytes(files)
  {
    platform,
    adapter,
    name,
    route: entry.route,
    page: entry.page,
    pages,
    files,
    total_bytes: total,
    summary: "Bunnia \{@core.platform_id(platform)} project: pages=\{pages.length()} files=\{files.length()} bytes=\{total} route=\{entry.route}",
  }
}

///|
fn miniapp_file(path : String, content : String) -> MiniappFile {
  { path, content }
}

///|
fn total_file_bytes(files : Array[MiniappFile]) -> Int {
  let mut total = 0
  for item in files {
    total += item.content.length()
  }
  total
}

///|
fn app_json(pages : Array[MiniappProjectPage]) -> String {
  "{\n" +
  "  \"pages\": \{page_routes_json(pages)},\n" +
  "  \"window\": { \"defaultTitle\": \"Bunnia\" }\n" +
  "}\n"
}

///|
fn page_routes_json(pages : Array[MiniappProjectPage]) -> String {
  let out = StringBuilder::new()
  out.write_string("[")
  for i in 0..<pages.length() {
    if i > 0 {
      out.write_string(", ")
    }
    out.write_string("\"")
    out.write_string(escape_json(pages[i].route))
    out.write_string("\"")
  }
  out.write_string("]")
  out.to_string()
}

///|
fn page_json(name : String) -> String {
  "{ \"defaultTitle\": \"\{escape_json(name)}\" }"
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
    out.write_string(" \{event_name(binding.event, adapter)}=\"__bunniaEvent\"")
    out.write_string(" data-bunnia-message=\"\{escape_xml(binding.message)}\"")
  }
  out.to_string()
}

///|
fn component_name(kind : String, adapter : @core.PlatformAdapter) -> String {
  if kind == "page" {
    adapter.page_component
  } else if kind == "windowed-list" {
    "\{adapter.component_prefix}view"
  } else {
    "\{adapter.component_prefix}\{kind}"
  }
}

///|
fn event_name(event : String, adapter : @core.PlatformAdapter) -> String {
  match adapter.platform {
    @core.Alipay =>
      if event == "tap" {
        adapter.tap_event
      } else if event == "input" {
        "onInput"
      } else if event == "submit" {
        "onSubmit"
      } else {
        event
      }
    @core.Wechat | @core.TikTok =>
      if event == "tap" {
        adapter.tap_event
      } else if event == "input" {
        "bindinput"
      } else if event == "submit" {
        "bindsubmit"
      } else {
        event
      }
  }
}

///|
fn markup_extension(platform : @core.Platform) -> String {
  match platform {
    @core.Alipay => "axml"
    @core.TikTok => "ttml"
    @core.Wechat => "wxml"
  }
}

///|
fn style_extension(platform : @core.Platform) -> String {
  match platform {
    @core.Alipay => "acss"
    @core.TikTok => "ttss"
    @core.Wechat => "wxss"
  }
}

///|
fn page_js(name : String, plan : @core.RenderPlan) -> String {
  "Page({\n" +
  "  data: { __bunnia: { name: \"\{escape_json(name)}\", nodes: \{plan.node_count}, depth: \{plan.depth}, lastMessage: \"\", handledEvents: 0 } },\n" +
  "  __bunniaEvent(event) {\n" +
  "    const message = event.currentTarget && event.currentTarget.dataset ? event.currentTarget.dataset.bunniaMessage : ''\n" +
  "    this.setData({ '__bunnia.lastMessage': message, '__bunnia.handledEvents': (this.data.__bunnia.handledEvents || 0) + 1 })\n" +
  "  }\n" +
  "})"
}

///|
fn default_style() -> String {
  ".demo-shell { min-height: 100vh; padding: 24rpx; box-sizing: border-box; display: flex; flex-direction: column; gap: 20rpx; background: #f7f8fa; color: #111827; }\n" +
  ".bunnia-list-windowed { display: flex; flex-direction: column; gap: 12rpx; }\n" +
  ".bunnia-scene { position: relative; overflow: hidden; max-width: 100%; border: 1rpx solid #d1d5db; border-radius: 8rpx; background: #eef6f3; box-sizing: border-box; }\n" +
  ".bunnia-scene-layer { position: absolute; left: 0; top: 0; right: 0; bottom: 0; }\n" +
  ".bunnia-scene-marker { position: absolute; transform: translate(-50%, -50%); min-width: 120rpx; min-height: 56rpx; padding: 10rpx 14rpx; border: 2rpx solid #64748b; border-radius: 8rpx; background: #ffffff; box-sizing: border-box; font-size: 24rpx; line-height: 1.4; text-align: center; }\n" +
  ".bunnia-scene-region { position: absolute; box-sizing: border-box; border: 2rpx solid #94a3b8; border-radius: 8rpx; background: rgba(255,255,255,0.64); }\n" +
  ".bunnia-scene-thread-overlay-anchored { position: absolute; left: 0; top: 0; right: 0; bottom: 0; display: block; pointer-events: none; }\n" +
  ".bunnia-scene-thread-anchored { position: absolute; transform: translate(-50%, -50%); pointer-events: auto; }\n" +
  ".bunnia-status-selected { border-color: #0891b2; background: #ecfeff; }\n" +
  ".bunnia-status-running { border-color: #2563eb; }\n" +
  ".bunnia-status-review { border-color: #d97706; }\n" +
  ".bunnia-status-stable { border-color: #16a34a; }"
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
