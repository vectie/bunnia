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
  report : WechatBuildReport
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
  let report = report_files(files, runtime, default_build_budget())
  {
    name,
    route,
    page,
    files,
    total_bytes: total,
    report,
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
pub fn generate_request_adapter(contract : @effects.BackendContract) -> String {
  "const __bunniaBackend = \{backend_contract_object(contract)}\n" +
  "\n" +
  "function __bunniaRequest(page, endpointId, payload) {\n" +
  "  const endpoint = __bunniaBackend.endpoints[endpointId]\n" +
  "  if (!endpoint) throw new Error('Unknown Bunnia endpoint: ' + endpointId)\n" +
  "  const baseUrl = page.data[__bunniaBackend.baseUrlKey] || ''\n" +
  "  const loading = {}\n" +
  "  loading['backend.' + endpointId + '.state'] = 'loading'\n" +
  "  loading['backend.' + endpointId + '.error'] = ''\n" +
  "  page.setData(loading)\n" +
  "  return wx.request({\n" +
  "    url: baseUrl + endpoint.path,\n" +
  "    method: endpoint.method,\n" +
  "    data: payload || {},\n" +
  "    timeout: endpoint.timeoutMs,\n" +
  "    success(res) {\n" +
  "      const update = {}\n" +
  "      update['backend.' + endpointId + '.state'] = 'ready'\n" +
  "      update['backend.' + endpointId + '.response'] = res.data\n" +
  "      page.setData(update)\n" +
  "    },\n" +
  "    fail(err) {\n" +
  "      const update = {}\n" +
  "      update['backend.' + endpointId + '.state'] = 'failed'\n" +
  "      update['backend.' + endpointId + '.error'] = String(err.errMsg || err)\n" +
  "      page.setData(update)\n" +
  "    }\n" +
  "  })\n" +
  "}"
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
    let rendered_event = event_name(binding.event, adapter)
    out.write_string(" \{rendered_event}=\"__bunniaEvent\"")
    out.write_string(" data-bunnia-message=\"\{escape_xml(binding.message)}\"")
  }
  out.to_string()
}

///|
fn event_name(event : String, adapter : @core.PlatformAdapter) -> String {
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
fn backend_contract_object(contract : @effects.BackendContract) -> String {
  "{baseUrlKey:\"" +
  escape_json(contract.base_url_key) +
  "\",endpoints:" +
  backend_endpoints_object(contract.endpoints) +
  "}"
}

///|
fn backend_endpoints_object(items : Array[@effects.BackendEndpoint]) -> String {
  let out = StringBuilder::new()
  out.write_string("{")
  for i in 0..<items.length() {
    let item = items[i]
    if i > 0 {
      out.write_string(",")
    }
    out.write_string("\"")
    out.write_string(escape_json(item.id))
    out.write_string("\":")
    out.write_string(backend_endpoint_object(item))
  }
  out.write_string("}")
  out.to_string()
}

///|
fn backend_endpoint_object(item : @effects.BackendEndpoint) -> String {
  "{" +
  "kind:\"" +
  escape_json(@effects.backend_endpoint_kind_id(item.kind)) +
  "\"," +
  "method:\"" +
  escape_json(@effects.http_method_id(item.http_method)) +
  "\"," +
  "path:\"" +
  escape_json(item.path) +
  "\"," +
  "payloadKey:\"" +
  escape_json(item.payload_key) +
  "\"," +
  "responseKey:\"" +
  escape_json(item.response_key) +
  "\"," +
  "timeoutMs:" +
  item.timeout_ms.to_string() +
  "," +
  "streaming:" +
  item.streaming.to_string() +
  "," +
  "requiresReview:" +
  item.requires_review.to_string() +
  "}"
}

///|
fn default_wxss() -> String {
  ".demo-shell { min-height: 100vh; padding: 24rpx; box-sizing: border-box; display: flex; flex-direction: column; gap: 20rpx; background: #f7f8fa; color: #111827; }\n" +
  ".bunnia-message { padding: 16rpx 20rpx; border: 1rpx solid #e5e7eb; border-radius: 8rpx; background: #ffffff; box-sizing: border-box; font-size: 28rpx; line-height: 1.5; }\n" +
  ".bunnia-run-running { border-color: #2563eb; box-shadow: 0 0 0 2rpx rgba(37, 99, 235, 0.10); }\n" +
  ".bunnia-run-waiting-review { border-color: #d97706; }\n" +
  ".bunnia-run-failed { border-color: #dc2626; }\n" +
  ".bunnia-artifact-link { margin-top: 8rpx; color: #2563eb; font-size: 24rpx; }\n" +
  ".bunnia-thread { padding: 16rpx 20rpx; border: 1rpx solid #d1d5db; border-radius: 8rpx; background: #ffffff; box-sizing: border-box; font-size: 28rpx; line-height: 1.5; }\n" +
  ".bunnia-subject-link { margin-top: 8rpx; color: #0891b2; font-size: 24rpx; }\n" +
  ".bunnia-communication-trace { display: flex; flex-direction: column; gap: 12rpx; }\n" +
  ".bunnia-communication { padding: 14rpx 18rpx; border-left: 6rpx solid #64748b; border-radius: 8rpx; background: #ffffff; box-sizing: border-box; font-size: 26rpx; line-height: 1.45; }\n" +
  ".bunnia-communication-message { border-left-color: #64748b; }\n" +
  ".bunnia-communication-handoff { border-left-color: #0891b2; }\n" +
  ".bunnia-communication-broadcast { border-left-color: #2563eb; }\n" +
  ".bunnia-communication-review-request { border-left-color: #d97706; }\n" +
  ".bunnia-communication-approval { border-left-color: #16a34a; }\n" +
  ".bunnia-communication-tool-result { border-left-color: #7c3aed; }\n" +
  ".bunnia-communication-recovery-notice { border-left-color: #dc2626; }\n" +
  ".bunnia-review { display: flex; gap: 12rpx; align-items: center; padding: 16rpx; border: 1rpx solid #e5e7eb; border-radius: 8rpx; background: #ffffff; box-sizing: border-box; }\n" +
  ".bunnia-review-pending { border-color: #d97706; }\n" +
  ".bunnia-review-approved { border-color: #16a34a; }\n" +
  ".bunnia-review-rejected { border-color: #dc2626; }\n" +
  ".bunnia-scene { position: relative; overflow: hidden; max-width: 100%; border: 1rpx solid #d1d5db; border-radius: 8rpx; background: #eef6f3; box-sizing: border-box; }\n" +
  ".bunnia-scene-layer { position: absolute; left: 0; top: 0; right: 0; bottom: 0; }\n" +
  ".bunnia-scene-marker { position: absolute; transform: translate(-50%, -50%); min-width: 120rpx; min-height: 56rpx; padding: 10rpx 14rpx; border: 2rpx solid #64748b; border-radius: 8rpx; background: #ffffff; box-sizing: border-box; font-size: 24rpx; line-height: 1.4; text-align: center; }\n" +
  ".bunnia-scene-sprite { display: block; width: 48rpx; height: 48rpx; margin: 0 auto 4rpx; }\n" +
  ".bunnia-status-stable { border-color: #16a34a; }\n" +
  ".bunnia-status-review { border-color: #d97706; }\n" +
  ".bunnia-status-running { border-color: #2563eb; }\n" +
  ".bunnia-status-selected { border-color: #0891b2; background: #ecfeff; }\n" +
  ".bunnia-status-default { border-color: #64748b; }"
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
