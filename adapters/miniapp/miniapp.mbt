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
pub struct MiniappManifestFile {
  path : String
  kind : String
  route : String
  bytes : Int
} derive(Debug, Eq)

///|
pub struct MiniappManifestPage {
  name : String
  route : String
  node_count : Int
  depth : Int
  component_count : Int
  event_count : Int
  windowed_list_count : Int
  list_total_count : Int
  list_visible_count : Int
  scene_count : Int
  scene_marker_count : Int
  scene_visible_marker_count : Int
  scene_region_count : Int
  scene_visible_region_count : Int
  scene_asset_count : Int
  file_bytes : Int
  diagnostics : Array[String]
  diagnostic_count : Int
  status : String
} derive(Debug, Eq)

///|
pub struct MiniappProjectManifest {
  name : String
  platform_id : String
  entry_route : String
  page_count : Int
  file_count : Int
  total_bytes : Int
  diagnostic_route_count : Int
  diagnostic_count : Int
  pages : Array[MiniappManifestPage]
  files : Array[MiniappManifestFile]
  summary : String
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
  manifest : MiniappProjectManifest
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
  let manifest = project_manifest(name, platform, entry.route, pages, files)
  files.push(miniapp_file("bunnia.manifest.json", manifest_json(manifest)))
  let total = total_file_bytes(files)
  {
    platform,
    adapter,
    name,
    route: entry.route,
    page: entry.page,
    pages,
    files,
    manifest,
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
fn project_manifest(
  name : String,
  platform : @core.Platform,
  entry_route : String,
  pages : Array[MiniappProjectPage],
  files : Array[MiniappFile],
) -> MiniappProjectManifest {
  let manifest_files = manifest_files(files)
  let manifest_pages = manifest_pages(pages, files)
  let total = total_file_bytes(files)
  let diagnostic_route_count = manifest_diagnostic_route_count(manifest_pages)
  let diagnostic_count = manifest_diagnostic_count(manifest_pages)
  {
    name,
    platform_id: @core.platform_id(platform),
    entry_route,
    page_count: pages.length(),
    file_count: files.length(),
    total_bytes: total,
    diagnostic_route_count,
    diagnostic_count,
    pages: manifest_pages,
    files: manifest_files,
    summary: "Bunnia generic miniapp manifest: platform=\{@core.platform_id(platform)} pages=\{pages.length()} files=\{files.length()} bytes=\{total} diagnostic_routes=\{diagnostic_route_count} diagnostics=\{diagnostic_count} entry=\{entry_route}",
  }
}

///|
fn manifest_files(files : Array[MiniappFile]) -> Array[MiniappManifestFile] {
  let output : Array[MiniappManifestFile] = []
  for file in files {
    output.push({
      path: file.path,
      kind: manifest_file_kind(file.path),
      route: manifest_file_route(file.path),
      bytes: file.content.length(),
    })
  }
  output
}

///|
fn manifest_pages(
  pages : Array[MiniappProjectPage],
  files : Array[MiniappFile],
) -> Array[MiniappManifestPage] {
  let output : Array[MiniappManifestPage] = []
  for item in pages {
    let diagnostics = item.page.plan.diagnostics
    output.push({
      name: item.name,
      route: item.route,
      node_count: item.page.plan.node_count,
      depth: item.page.plan.depth,
      component_count: item.page.plan.component_kinds.length(),
      event_count: item.page.plan.event_messages.length(),
      windowed_list_count: item.page.plan.windowed_list_count,
      list_total_count: item.page.plan.list_total_count,
      list_visible_count: item.page.plan.list_visible_count,
      scene_count: item.page.plan.scene_count,
      scene_marker_count: item.page.plan.scene_marker_count,
      scene_visible_marker_count: item.page.plan.scene_visible_marker_count,
      scene_region_count: item.page.plan.scene_region_count,
      scene_visible_region_count: item.page.plan.scene_visible_region_count,
      scene_asset_count: item.page.plan.scene_asset_count,
      file_bytes: route_file_bytes(item.route, files),
      diagnostics,
      diagnostic_count: diagnostics.length(),
      status: if diagnostics.length() == 0 {
        "ok"
      } else {
        "diagnostic"
      },
    })
  }
  output
}

///|
fn manifest_diagnostic_route_count(pages : Array[MiniappManifestPage]) -> Int {
  let mut total = 0
  for page in pages {
    if page.diagnostic_count > 0 {
      total += 1
    }
  }
  total
}

///|
fn manifest_diagnostic_count(pages : Array[MiniappManifestPage]) -> Int {
  let mut total = 0
  for page in pages {
    total += page.diagnostic_count
  }
  total
}

///|
fn route_file_bytes(route : String, files : Array[MiniappFile]) -> Int {
  let mut total = 0
  for file in files {
    if manifest_file_route(file.path) == route {
      total += file.content.length()
    }
  }
  total
}

///|
fn manifest_file_kind(path : String) -> String {
  if path == "app.json" {
    "app"
  } else if path == "bunnia.manifest.json" {
    "manifest"
  } else if path.has_suffix(".axml") ||
    path.has_suffix(".ttml") ||
    path.has_suffix(".wxml") {
    "markup"
  } else if path.has_suffix(".acss") ||
    path.has_suffix(".ttss") ||
    path.has_suffix(".wxss") {
    "style"
  } else if path.has_suffix(".js") {
    "js"
  } else if path.has_suffix(".json") {
    "json"
  } else {
    "asset"
  }
}

///|
fn manifest_file_route(path : String) -> String {
  if !path.has_prefix("pages/") {
    ""
  } else if path.has_suffix(".axml") {
    trim_suffix(path, ".axml")
  } else if path.has_suffix(".ttml") {
    trim_suffix(path, ".ttml")
  } else if path.has_suffix(".wxml") {
    trim_suffix(path, ".wxml")
  } else if path.has_suffix(".acss") {
    trim_suffix(path, ".acss")
  } else if path.has_suffix(".ttss") {
    trim_suffix(path, ".ttss")
  } else if path.has_suffix(".wxss") {
    trim_suffix(path, ".wxss")
  } else if path.has_suffix(".js") {
    trim_suffix(path, ".js")
  } else if path.has_suffix(".json") {
    trim_suffix(path, ".json")
  } else {
    ""
  }
}

///|
fn trim_suffix(value : String, suffix : String) -> String {
  value.sub(start=0, end=value.length() - suffix.length()).to_owned()
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
fn manifest_json(input : MiniappProjectManifest) -> String {
  "{\n" +
  "  \"name\": \"\{escape_json(input.name)}\",\n" +
  "  \"platform\": \"\{escape_json(input.platform_id)}\",\n" +
  "  \"entryRoute\": \"\{escape_json(input.entry_route)}\",\n" +
  "  \"pageCount\": \{input.page_count},\n" +
  "  \"fileCount\": \{input.file_count},\n" +
  "  \"totalBytes\": \{input.total_bytes},\n" +
  "  \"diagnosticRouteCount\": \{input.diagnostic_route_count},\n" +
  "  \"diagnosticCount\": \{input.diagnostic_count},\n" +
  "  \"pages\": \{manifest_pages_json(input.pages)},\n" +
  "  \"files\": \{manifest_files_json(input.files)}\n" +
  "}\n"
}

///|
fn manifest_pages_json(items : Array[MiniappManifestPage]) -> String {
  let out = StringBuilder::new()
  out.write_string("[")
  for i in 0..<items.length() {
    if i > 0 {
      out.write_string(", ")
    }
    out.write_string(manifest_page_json(items[i]))
  }
  out.write_string("]")
  out.to_string()
}

///|
fn manifest_page_json(item : MiniappManifestPage) -> String {
  "{" +
  "\"name\":\"\{escape_json(item.name)}\"," +
  "\"route\":\"\{escape_json(item.route)}\"," +
  "\"status\":\"\{escape_json(item.status)}\"," +
  "\"nodes\":\{item.node_count}," +
  "\"depth\":\{item.depth}," +
  "\"components\":\{item.component_count}," +
  "\"events\":\{item.event_count}," +
  "\"windowedLists\":\{item.windowed_list_count}," +
  "\"listItems\":\"\{item.list_visible_count}/\{item.list_total_count}\"," +
  "\"scenes\":\{item.scene_count}," +
  "\"sceneMarkers\":\"\{item.scene_visible_marker_count}/\{item.scene_marker_count}\"," +
  "\"sceneRegions\":\"\{item.scene_visible_region_count}/\{item.scene_region_count}\"," +
  "\"sceneAssets\":\{item.scene_asset_count}," +
  "\"fileBytes\":\{item.file_bytes}," +
  "\"diagnostics\":\{string_array_json(item.diagnostics)}" +
  "}"
}

///|
fn manifest_files_json(items : Array[MiniappManifestFile]) -> String {
  let out = StringBuilder::new()
  out.write_string("[")
  for i in 0..<items.length() {
    if i > 0 {
      out.write_string(", ")
    }
    out.write_string(manifest_file_json(items[i]))
  }
  out.write_string("]")
  out.to_string()
}

///|
fn manifest_file_json(item : MiniappManifestFile) -> String {
  "{" +
  "\"path\":\"\{escape_json(item.path)}\"," +
  "\"kind\":\"\{escape_json(item.kind)}\"," +
  "\"route\":\"\{escape_json(item.route)}\"," +
  "\"bytes\":\{item.bytes}" +
  "}"
}

///|
fn string_array_json(items : Array[String]) -> String {
  let out = StringBuilder::new()
  out.write_string("[")
  for i in 0..<items.length() {
    if i > 0 {
      out.write_string(", ")
    }
    out.write_string("\"")
    out.write_string(escape_json(items[i]))
    out.write_string("\"")
  }
  out.write_string("]")
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
  ".bunnia-scene-marker { position: absolute; transform: translate(-50%, -50%); min-width: 120rpx; min-height: 88rpx; padding: 10rpx 14rpx; border: 2rpx solid #64748b; border-radius: 8rpx; background: #ffffff; box-sizing: border-box; font-size: 24rpx; line-height: 1.4; text-align: center; }\n" +
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
