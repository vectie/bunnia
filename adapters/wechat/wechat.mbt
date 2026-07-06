///|
pub struct WechatPage {
  wxml : String
  wxss : String
  js : String
  json : String
  plan : @core.RenderPlan
  render_budget : @core.RenderBudget
  scene_assets : Array[WechatSceneAsset]
} derive(Debug, Eq)

///|
pub struct WechatSceneAsset {
  id : String
  kind : String
  src : String
  remote : Bool
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
pub struct WechatProjectPage {
  name : String
  route : String
  page : WechatPage
  runtime : WechatRuntime
} derive(Debug, Eq)

///|
pub struct WechatFile {
  path : String
  content : String
} derive(Debug, Eq)

///|
pub struct WechatManifestFile {
  path : String
  kind : String
  route : String
  bytes : Int
} derive(Debug, Eq)

///|
pub struct WechatManifestSceneAsset {
  route : String
  id : String
  kind : String
  src : String
  remote : Bool
} derive(Debug, Eq)

///|
pub struct WechatManifestPage {
  name : String
  route : String
  node_count : Int
  depth : Int
  windowed_list_count : Int
  list_total_count : Int
  list_visible_count : Int
  unwindowed_list_child_count : Int
  unkeyed_list_child_count : Int
  duplicate_list_key_count : Int
  component_count : Int
  event_count : Int
  backend_event_count : Int
  backend_stream_count : Int
  backend_review_count : Int
  scene_count : Int
  scene_marker_count : Int
  scene_visible_marker_count : Int
  scene_region_count : Int
  scene_visible_region_count : Int
  scene_asset_count : Int
  scene_assets : Array[WechatManifestSceneAsset]
  degraded_scene_count : Int
  missing_event_patch_count : Int
  orphan_event_patch_count : Int
  initial_data_bytes : Int
  event_patch_bytes : Int
  first_screen_bytes : Int
  update_payload_bytes : Int
  file_bytes : Int
  render_budget : @core.RenderBudget
  render_diagnostics : Array[String]
  diagnostics : Array[String]
  diagnostic_count : Int
  status : String
} derive(Debug, Eq)

///|
pub struct WechatProjectManifest {
  name : String
  entry_route : String
  page_count : Int
  app_file_count : Int
  app_total_bytes : Int
  scene_asset_count : Int
  scene_remote_asset_count : Int
  diagnostic_route_count : Int
  diagnostic_count : Int
  pages : Array[WechatManifestPage]
  files : Array[WechatManifestFile]
  scene_assets : Array[WechatManifestSceneAsset]
  summary : String
} derive(Debug, Eq)

///|
pub struct WechatProject {
  name : String
  route : String
  page : WechatPage
  pages : Array[WechatProjectPage]
  page_count : Int
  manifest : WechatProjectManifest
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
  generate_page_with_runtime_and_budget(
    name,
    root,
    runtime,
    @core.default_render_budget(),
  )
}

///|
pub fn generate_page_with_runtime_and_budget(
  name : String,
  root : @core.Node,
  runtime : WechatRuntime,
  render_budget : @core.RenderBudget,
) -> WechatPage {
  let plan = @core.plan_with_budget(root, Wechat, render_budget)
  {
    wxml: render_node(root, @core.adapter(Wechat)),
    wxss: default_wxss(),
    js: page_js(name, plan, runtime),
    json: "{ \"navigationBarTitleText\": \"\{escape_json(name)}\" }",
    plan,
    render_budget,
    scene_assets: collect_scene_assets(root),
  }
}

///|
fn generate_project_page_with_runtime(
  name : String,
  route : String,
  root : @core.Node,
  render_budget : @core.RenderBudget,
) -> WechatPage {
  let plan = @core.plan_with_budget(root, Wechat, render_budget)
  {
    wxml: render_node(root, @core.adapter(Wechat)),
    wxss: "",
    js: project_page_js(name, route, plan),
    json: "{ \"navigationBarTitleText\": \"\{escape_json(name)}\" }",
    plan,
    render_budget,
    scene_assets: collect_scene_assets(root),
  }
}

///|
pub fn generate_project(
  name~ : String,
  route? : String = "pages/index/index",
  root~ : @core.Node,
) -> WechatProject {
  generate_project_with_runtime_and_budget(
    name~,
    route~,
    root~,
    runtime=default_runtime(),
    render_budget=@core.default_render_budget(),
  )
}

///|
pub fn generate_project_with_runtime(
  name~ : String,
  route? : String = "pages/index/index",
  root~ : @core.Node,
  runtime~ : WechatRuntime,
) -> WechatProject {
  generate_project_with_runtime_and_budget(
    name~,
    route~,
    root~,
    runtime~,
    render_budget=@core.default_render_budget(),
  )
}

///|
pub fn generate_project_with_runtime_and_budget(
  name~ : String,
  route? : String = "pages/index/index",
  root~ : @core.Node,
  runtime~ : WechatRuntime,
  render_budget~ : @core.RenderBudget,
) -> WechatProject {
  generate_project_from_pages(name~, pages=[
    project_page(name~, route~, root~, runtime~, render_budget~),
  ])
}

///|
pub fn generate_project_with_runtime_and_backend(
  name~ : String,
  route? : String = "pages/index/index",
  root~ : @core.Node,
  runtime~ : WechatRuntime,
  backend_contract~ : @effects.BackendContract,
) -> WechatProject {
  generate_project_with_runtime_and_budget_and_backend(
    name~,
    route~,
    root~,
    runtime~,
    render_budget=@core.default_render_budget(),
    backend_contract~,
  )
}

///|
pub fn generate_project_with_runtime_and_budget_and_backend(
  name~ : String,
  route? : String = "pages/index/index",
  root~ : @core.Node,
  runtime~ : WechatRuntime,
  render_budget~ : @core.RenderBudget,
  backend_contract~ : @effects.BackendContract,
) -> WechatProject {
  generate_project_from_pages_with_backend(
    name~,
    pages=[project_page(name~, route~, root~, runtime~, render_budget~)],
    backend_contract~,
  )
}

///|
pub fn project_page(
  name~ : String,
  route~ : String,
  root~ : @core.Node,
  runtime? : WechatRuntime = default_runtime(),
  render_budget? : @core.RenderBudget = @core.default_render_budget(),
) -> WechatProjectPage {
  {
    name,
    route,
    page: generate_project_page_with_runtime(name, route, root, render_budget),
    runtime,
  }
}

///|
pub fn generate_project_from_pages(
  name~ : String,
  pages~ : Array[WechatProjectPage],
) -> WechatProject {
  generate_project_from_pages_internal(name~, pages~, backend_contract=None)
}

///|
pub fn generate_project_from_pages_with_backend(
  name~ : String,
  pages~ : Array[WechatProjectPage],
  backend_contract~ : @effects.BackendContract,
) -> WechatProject {
  generate_project_from_pages_internal(
    name~,
    pages~,
    backend_contract=Some(backend_contract),
  )
}

///|
fn generate_project_from_pages_internal(
  name~ : String,
  pages~ : Array[WechatProjectPage],
  backend_contract~ : @effects.BackendContract?,
) -> WechatProject {
  if pages.length() == 0 {
    panic()
  }
  let generated_pages = project_pages_for_backend(pages, backend_contract)
  let entry = generated_pages[0]
  let files : Array[WechatFile] = [
    wechat_file("app.json", app_json(generated_pages)),
    wechat_file("project.config.json", project_config_json(name)),
    wechat_file("sitemap.json", sitemap_json()),
    wechat_file("bunnia.runtime.js", runtime_js()),
    wechat_file("app.wxss", default_wxss()),
  ]
  match backend_contract {
    Some(contract) =>
      files.push(
        wechat_file("bunnia.backend.js", generate_request_adapter(contract)),
      )
    None => ()
  }
  for item in generated_pages {
    files.push(wechat_file("\{item.route}.wxml", item.page.wxml))
    if item.page.wxss != "" {
      files.push(wechat_file("\{item.route}.wxss", item.page.wxss))
    }
    files.push(
      wechat_file(
        page_payload_file_path(item.route),
        page_payload_js(item.runtime, item.page.plan),
      ),
    )
    files.push(wechat_file("\{item.route}.js", item.page.js))
    files.push(wechat_file("\{item.route}.json", item.page.json))
  }
  let manifest = project_manifest(
    name,
    entry.route,
    generated_pages,
    files,
    backend_contract,
  )
  files.push(wechat_file("bunnia.manifest.json", manifest_json(manifest)))
  let total = total_file_bytes(files)
  let report = report_project_pages(
    files,
    generated_pages,
    default_build_budget(),
  )
  {
    name,
    route: entry.route,
    page: entry.page,
    pages: generated_pages,
    page_count: generated_pages.length(),
    manifest,
    files,
    total_bytes: total,
    report,
    summary: "Bunnia WeChat project: pages=\{generated_pages.length()} files=\{files.length()} bytes=\{total} route=\{entry.route}",
  }
}

///|
fn project_pages_for_backend(
  pages : Array[WechatProjectPage],
  backend_contract : @effects.BackendContract?,
) -> Array[WechatProjectPage] {
  let output : Array[WechatProjectPage] = []
  for item in pages {
    match backend_contract {
      Some(contract) =>
        output.push(project_page_with_backend_js(item, contract))
      None => output.push(item)
    }
  }
  output
}

///|
fn project_page_with_backend_js(
  item : WechatProjectPage,
  contract : @effects.BackendContract,
) -> WechatProjectPage {
  let js = if backend_has_reachable_event(contract, item.page.plan) {
    project_page_js_with_backend(
      item.name,
      item.route,
      item.page.plan,
      contract,
    )
  } else {
    project_page_js(item.name, item.route, item.page.plan)
  }
  {
    name: item.name,
    route: item.route,
    page: {
      wxml: item.page.wxml,
      wxss: item.page.wxss,
      js,
      json: item.page.json,
      plan: item.page.plan,
      render_budget: item.page.render_budget,
      scene_assets: item.page.scene_assets,
    },
    runtime: item.runtime,
  }
}

///|
fn backend_has_reachable_event(
  contract : @effects.BackendContract,
  plan : @core.RenderPlan,
) -> Bool {
  for endpoint in contract.endpoints {
    if plan.event_messages.contains(endpoint.id) {
      return true
    }
  }
  false
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
  "__bunniaApplyPatches(this, \{patches_to_operations(patches)})"
}

///|
pub fn generate_runtime_js() -> String {
  runtime_js()
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
  "  const requestPayload = payload === undefined && endpoint.payloadKey ? page.data[endpoint.payloadKey] : (payload || {})\n" +
  "  loading['backend.' + endpointId + '.request'] = requestPayload\n" +
  "  loading['backend.' + endpointId + '.replayKey'] = endpointId + ':' + Date.now()\n" +
  "  page.setData(loading)\n" +
  "  return wx.request({\n" +
  "    url: baseUrl + endpoint.path,\n" +
  "    method: endpoint.method,\n" +
  "    data: requestPayload,\n" +
  "    timeout: endpoint.timeoutMs,\n" +
  "    success(res) {\n" +
  "      const update = {}\n" +
  "      if (res.statusCode && (res.statusCode < 200 || res.statusCode >= 300)) {\n" +
  "        update['backend.' + endpointId + '.state'] = 'failed'\n" +
  "        update['backend.' + endpointId + '.error'] = 'HTTP ' + res.statusCode\n" +
  "      } else if (res.data === undefined || res.data === null) {\n" +
  "        update['backend.' + endpointId + '.state'] = 'malformed'\n" +
  "        update['backend.' + endpointId + '.error'] = 'empty response'\n" +
  "      } else {\n" +
  "        update['backend.' + endpointId + '.state'] = 'ready'\n" +
  "        update['backend.' + endpointId + '.response'] = res.data\n" +
  "        update['backend.' + endpointId + '.error'] = ''\n" +
  "      }\n" +
  "      page.setData(update)\n" +
  "    },\n" +
  "    fail(err) {\n" +
  "      const update = {}\n" +
  "      const message = String(err.errMsg || err)\n" +
  "      update['backend.' + endpointId + '.state'] = message.indexOf('timeout') >= 0 ? 'timeout' : 'failed'\n" +
  "      update['backend.' + endpointId + '.error'] = message\n" +
  "      page.setData(update)\n" +
  "    }\n" +
  "  })\n" +
  "}\n" +
  "\n" +
  "function __bunniaCancelRequest(page, endpointId) {\n" +
  "  const update = {}\n" +
  "  update['backend.' + endpointId + '.state'] = 'cancelled'\n" +
  "  update['backend.' + endpointId + '.error'] = ''\n" +
  "  page.setData(update)\n" +
  "}\n" +
  "\n" +
  "function __bunniaRetryRequest(page, endpointId) {\n" +
  "  const current = page.data.backend && page.data.backend[endpointId]\n" +
  "  return __bunniaRequest(page, endpointId, current ? current.request : undefined)\n" +
  "}\n" +
  "\n" +
  "module.exports = { __bunniaBackend, __bunniaRequest, __bunniaCancelRequest, __bunniaRetryRequest }"
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
fn project_manifest(
  name : String,
  entry_route : String,
  pages : Array[WechatProjectPage],
  files : Array[WechatFile],
  backend_contract : @effects.BackendContract?,
) -> WechatProjectManifest {
  let app_total = total_file_bytes(files)
  let manifest_files = manifest_files(files)
  let manifest_pages = manifest_pages(pages, files, backend_contract)
  let scene_assets = manifest_scene_assets(manifest_pages)
  let scene_remote_asset_count = manifest_remote_scene_asset_count(scene_assets)
  let diagnostic_route_count = manifest_diagnostic_route_count(manifest_pages)
  let diagnostic_count = manifest_diagnostic_count(manifest_pages)
  {
    name,
    entry_route,
    page_count: pages.length(),
    app_file_count: files.length(),
    app_total_bytes: app_total,
    scene_asset_count: scene_assets.length(),
    scene_remote_asset_count,
    diagnostic_route_count,
    diagnostic_count,
    pages: manifest_pages,
    files: manifest_files,
    scene_assets,
    summary: "Bunnia WeChat manifest: pages=\{pages.length()} app_files=\{files.length()} app_bytes=\{app_total} scene_assets=\{scene_assets.length()} scene_remote_assets=\{scene_remote_asset_count} diagnostic_routes=\{diagnostic_route_count} diagnostics=\{diagnostic_count} entry=\{entry_route}",
  }
}

///|
fn manifest_files(files : Array[WechatFile]) -> Array[WechatManifestFile] {
  let output : Array[WechatManifestFile] = []
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
  pages : Array[WechatProjectPage],
  files : Array[WechatFile],
  backend_contract : @effects.BackendContract?,
) -> Array[WechatManifestPage] {
  let output : Array[WechatManifestPage] = []
  for item in pages {
    let (backend_events, backend_streams, backend_reviews) = page_backend_pressure(
      item, backend_contract,
    )
    let diagnostics = page_manifest_diagnostics(item)
    output.push({
      name: item.name,
      route: item.route,
      node_count: item.page.plan.node_count,
      depth: item.page.plan.depth,
      windowed_list_count: item.page.plan.windowed_list_count,
      list_total_count: item.page.plan.list_total_count,
      list_visible_count: item.page.plan.list_visible_count,
      unwindowed_list_child_count: item.page.plan.unwindowed_list_child_count,
      unkeyed_list_child_count: item.page.plan.unkeyed_list_child_count,
      duplicate_list_key_count: item.page.plan.duplicate_list_key_count,
      component_count: item.page.plan.component_kinds.length(),
      event_count: item.page.plan.event_messages.length(),
      backend_event_count: backend_events,
      backend_stream_count: backend_streams,
      backend_review_count: backend_reviews,
      scene_count: item.page.plan.scene_count,
      scene_marker_count: item.page.plan.scene_marker_count,
      scene_visible_marker_count: item.page.plan.scene_visible_marker_count,
      scene_region_count: item.page.plan.scene_region_count,
      scene_visible_region_count: item.page.plan.scene_visible_region_count,
      scene_asset_count: item.page.plan.scene_asset_count,
      scene_assets: page_manifest_scene_assets(item),
      degraded_scene_count: item.page.plan.degraded_scene_count,
      missing_event_patch_count: page_missing_event_patch_count(item),
      orphan_event_patch_count: page_orphan_event_patch_count(item),
      initial_data_bytes: item.runtime.initial_data_json.length(),
      event_patch_bytes: page_event_patch_bytes(item),
      first_screen_bytes: page_first_screen_bytes(item, files),
      update_payload_bytes: page_update_payload_bytes(item),
      file_bytes: route_file_bytes(item.route, files),
      render_budget: item.page.render_budget,
      render_diagnostics: item.page.plan.diagnostics,
      diagnostics,
      diagnostic_count: diagnostics.length(),
      status: route_manifest_status(diagnostics),
    })
  }
  output
}

///|
fn page_manifest_scene_assets(
  page : WechatProjectPage,
) -> Array[WechatManifestSceneAsset] {
  let output : Array[WechatManifestSceneAsset] = []
  for item in page.page.scene_assets {
    output.push({
      route: page.route,
      id: item.id,
      kind: item.kind,
      src: item.src,
      remote: item.remote,
    })
  }
  output
}

///|
fn manifest_scene_assets(
  pages : Array[WechatManifestPage],
) -> Array[WechatManifestSceneAsset] {
  let output : Array[WechatManifestSceneAsset] = []
  for page in pages {
    for item in page.scene_assets {
      output.push(item)
    }
  }
  output
}

///|
fn manifest_remote_scene_asset_count(
  items : Array[WechatManifestSceneAsset],
) -> Int {
  let mut total = 0
  for item in items {
    if item.remote {
      total += 1
    }
  }
  total
}

///|
fn route_manifest_status(diagnostics : Array[String]) -> String {
  if diagnostics.length() == 0 {
    "ok"
  } else {
    "diagnostic"
  }
}

///|
fn manifest_diagnostic_route_count(pages : Array[WechatManifestPage]) -> Int {
  let mut total = 0
  for page in pages {
    if page.diagnostic_count > 0 {
      total += 1
    }
  }
  total
}

///|
fn manifest_diagnostic_count(pages : Array[WechatManifestPage]) -> Int {
  let mut total = 0
  for page in pages {
    total += page.diagnostic_count
  }
  total
}

///|
fn manifest_file_kind(path : String) -> String {
  if path == "app.json" {
    "app"
  } else if path == "project.config.json" {
    "project-config"
  } else if path == "sitemap.json" {
    "sitemap"
  } else if path == "bunnia.backend.js" {
    "backend-js"
  } else if path.has_suffix(".wxml") {
    "wxml"
  } else if path.has_suffix(".wxss") {
    "wxss"
  } else if path.has_suffix(".data.js") {
    "page-data"
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
  if path.has_suffix(".wxml") && path.has_prefix("pages/") {
    trim_suffix(path, ".wxml")
  } else if path.has_suffix(".wxss") && path.has_prefix("pages/") {
    trim_suffix(path, ".wxss")
  } else if path.has_suffix(".data.js") && path.has_prefix("pages/") {
    trim_suffix(path, ".data.js")
  } else if path.has_suffix(".js") && path.has_prefix("pages/") {
    trim_suffix(path, ".js")
  } else if path.has_suffix(".json") && path.has_prefix("pages/") {
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
fn route_file_bytes(route : String, files : Array[WechatFile]) -> Int {
  let mut total = 0
  for file in files {
    if manifest_file_route(file.path) == route {
      total += file.content.length()
    }
  }
  total
}

///|
fn page_event_patch_bytes(page : WechatProjectPage) -> Int {
  let mut total = 0
  for item in page.runtime.event_patches {
    if page.page.plan.event_messages.contains(item.message) {
      total += item.message.length()
      for patch in item.patches {
        total += patch.estimated_bytes
      }
    }
  }
  total
}

///|
fn page_missing_event_patch_count(page : WechatProjectPage) -> Int {
  let mut total = 0
  for message in page.page.plan.event_messages {
    if !page_runtime_has_patch(page.runtime, message) {
      total += 1
    }
  }
  total
}

///|
fn page_orphan_event_patch_count(page : WechatProjectPage) -> Int {
  let mut total = 0
  for patch in page.runtime.event_patches {
    if !page.page.plan.event_messages.contains(patch.message) {
      total += 1
    }
  }
  total
}

///|
fn page_runtime_has_patch(runtime : WechatRuntime, message : String) -> Bool {
  for item in runtime.event_patches {
    if item.message == message {
      return true
    }
  }
  false
}

///|
fn page_manifest_diagnostics(page : WechatProjectPage) -> Array[String] {
  let output : Array[String] = []
  for item in page.page.plan.diagnostics {
    output.push("wechat-render:\{page.route}:\{item}")
  }
  let initial = page.runtime.initial_data_json.length()
  let initial_limit = page.page.render_budget.max_initial_data_bytes
  if initial > initial_limit {
    output.push(
      "wechat-route-initial-data-over-render-budget:\{page.route}:\{initial}/\{initial_limit}",
    )
  }
  for message in page.page.plan.event_messages {
    if !page_runtime_has_patch(page.runtime, message) {
      output.push("wechat-event-without-patch:\{page.route}:\{message}")
    }
  }
  for patch in page.runtime.event_patches {
    if !page.page.plan.event_messages.contains(patch.message) {
      output.push("wechat-patch-without-event:\{page.route}:\{patch.message}")
    }
  }
  output
}

///|
fn page_backend_pressure(
  page : WechatProjectPage,
  contract : @effects.BackendContract?,
) -> (Int, Int, Int) {
  match contract {
    Some(value) => {
      let mut event_count = 0
      let mut stream_count = 0
      let mut review_count = 0
      for endpoint in value.endpoints {
        if page.page.plan.event_messages.contains(endpoint.id) {
          event_count += 1
          if endpoint.streaming {
            stream_count += 1
          }
          if endpoint.requires_review {
            review_count += 1
          }
        }
      }
      (event_count, stream_count, review_count)
    }
    None => (0, 0, 0)
  }
}

///|
fn manifest_json(input : WechatProjectManifest) -> String {
  "{\n" +
  "  \"name\": \"\{escape_json(input.name)}\",\n" +
  "  \"entryRoute\": \"\{escape_json(input.entry_route)}\",\n" +
  "  \"pageCount\": \{input.page_count},\n" +
  "  \"appFileCount\": \{input.app_file_count},\n" +
  "  \"appTotalBytes\": \{input.app_total_bytes},\n" +
  "  \"sceneAssetCount\": \{input.scene_asset_count},\n" +
  "  \"sceneRemoteAssetCount\": \{input.scene_remote_asset_count},\n" +
  "  \"diagnosticRouteCount\": \{input.diagnostic_route_count},\n" +
  "  \"diagnosticCount\": \{input.diagnostic_count},\n" +
  "  \"pages\": \{manifest_pages_json(input.pages)},\n" +
  "  \"files\": \{manifest_files_json(input.files)},\n" +
  "  \"sceneAssets\": \{manifest_scene_assets_json(input.scene_assets)}\n" +
  "}\n"
}

///|
fn manifest_pages_json(items : Array[WechatManifestPage]) -> String {
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
fn manifest_page_json(item : WechatManifestPage) -> String {
  "{" +
  "\"name\":\"\{escape_json(item.name)}\"," +
  "\"route\":\"\{escape_json(item.route)}\"," +
  "\"nodes\":\{item.node_count}," +
  "\"depth\":\{item.depth}," +
  "\"windowedLists\":\{item.windowed_list_count}," +
  "\"listTotal\":\{item.list_total_count}," +
  "\"listVisible\":\{item.list_visible_count}," +
  "\"unwindowedListChildren\":\{item.unwindowed_list_child_count}," +
  "\"unkeyedListChildren\":\{item.unkeyed_list_child_count}," +
  "\"duplicateListKeys\":\{item.duplicate_list_key_count}," +
  "\"components\":\{item.component_count}," +
  "\"events\":\{item.event_count}," +
  "\"backendEvents\":\{item.backend_event_count}," +
  "\"backendStreams\":\{item.backend_stream_count}," +
  "\"backendReviews\":\{item.backend_review_count}," +
  "\"scenes\":\{item.scene_count}," +
  "\"sceneMarkers\":\{item.scene_marker_count}," +
  "\"sceneVisibleMarkers\":\{item.scene_visible_marker_count}," +
  "\"sceneRegions\":\{item.scene_region_count}," +
  "\"sceneVisibleRegions\":\{item.scene_visible_region_count}," +
  "\"sceneAssets\":\{item.scene_asset_count}," +
  "\"sceneAssetRefs\":\{manifest_scene_assets_json(item.scene_assets)}," +
  "\"degradedScenes\":\{item.degraded_scene_count}," +
  "\"missingEventPatches\":\{item.missing_event_patch_count}," +
  "\"orphanEventPatches\":\{item.orphan_event_patch_count}," +
  "\"initialDataBytes\":\{item.initial_data_bytes}," +
  "\"eventPatchBytes\":\{item.event_patch_bytes}," +
  "\"firstScreenBytes\":\{item.first_screen_bytes}," +
  "\"updatePayloadBytes\":\{item.update_payload_bytes}," +
  "\"fileBytes\":\{item.file_bytes}," +
  "\"renderBudget\":\{render_budget_json(item.render_budget)}," +
  "\"renderDiagnostics\":\{strings_json(item.render_diagnostics)}," +
  "\"diagnostics\":\{strings_json(item.diagnostics)}," +
  "\"diagnosticCount\":\{item.diagnostic_count}," +
  "\"status\":\"\{escape_json(item.status)}\"" +
  "}"
}

///|
fn manifest_scene_assets_json(
  items : Array[WechatManifestSceneAsset],
) -> String {
  let out = StringBuilder::new()
  out.write_string("[")
  for i in 0..<items.length() {
    if i > 0 {
      out.write_string(", ")
    }
    out.write_string(manifest_scene_asset_json(items[i]))
  }
  out.write_string("]")
  out.to_string()
}

///|
fn manifest_scene_asset_json(item : WechatManifestSceneAsset) -> String {
  "{" +
  "\"route\":\"\{escape_json(item.route)}\"," +
  "\"id\":\"\{escape_json(item.id)}\"," +
  "\"kind\":\"\{escape_json(item.kind)}\"," +
  "\"src\":\"\{escape_json(item.src)}\"," +
  "\"remote\":\{item.remote}" +
  "}"
}

///|
fn render_budget_json(input : @core.RenderBudget) -> String {
  "{" +
  "\"maxNodes\":\{input.max_nodes}," +
  "\"maxDepth\":\{input.max_depth}," +
  "\"maxEvents\":\{input.max_events}," +
  "\"maxInitialDataBytes\":\{input.max_initial_data_bytes}," +
  "\"maxUnwindowedListChildren\":\{input.max_unwindowed_list_children}," +
  "\"maxSceneMarkers\":\{input.max_scene_markers}," +
  "\"maxSceneRegions\":\{input.max_scene_regions}," +
  "\"maxSceneAssets\":\{input.max_scene_assets}," +
  "\"maxDegradedScenes\":\{input.max_degraded_scenes}" +
  "}"
}

///|
fn strings_json(items : Array[String]) -> String {
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
fn manifest_files_json(items : Array[WechatManifestFile]) -> String {
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
fn manifest_file_json(item : WechatManifestFile) -> String {
  "{" +
  "\"path\":\"\{escape_json(item.path)}\"," +
  "\"kind\":\"\{escape_json(item.kind)}\"," +
  "\"route\":\"\{escape_json(item.route)}\"," +
  "\"bytes\":\{item.bytes}" +
  "}"
}

///|
fn app_json(pages : Array[WechatProjectPage]) -> String {
  "{\n" +
  "  \"pages\": \{page_routes_json(pages)},\n" +
  "  \"window\": {\n" +
  "    \"navigationBarTitleText\": \"Bunnia\",\n" +
  "    \"navigationBarBackgroundColor\": \"#ffffff\",\n" +
  "    \"navigationBarTextStyle\": \"black\"\n" +
  "  }\n" +
  "}\n"
}

///|
fn page_routes_json(pages : Array[WechatProjectPage]) -> String {
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
fn patches_to_operations(patches : Array[@core.Patch]) -> String {
  let out = StringBuilder::new()
  out.write_string("[")
  for i in 0..<patches.length() {
    let item = patches[i]
    if i > 0 {
      out.write_string(",")
    }
    out.write_string("{kind:\"")
    out.write_string(patch_kind_id(item.kind))
    out.write_string("\",path:\"")
    out.write_string(escape_json(item.path))
    out.write_string("\",value:")
    out.write_string(item.value_json)
    out.write_string("}")
  }
  out.write_string("]")
  out.to_string()
}

///|
fn collect_scene_assets(root : @core.Node) -> Array[WechatSceneAsset] {
  let output : Array[WechatSceneAsset] = []
  collect_scene_assets_into(output, root)
  output
}

///|
fn collect_scene_assets_into(
  output : Array[WechatSceneAsset],
  root : @core.Node,
) -> Unit {
  let id = attr_value(root.attrs, "data-asset-id")
  if id != "" && !scene_asset_seen(output, id) {
    output.push({
      id,
      kind: attr_value(root.attrs, "data-asset-kind"),
      src: attr_value(root.attrs, "src"),
      remote: attr_value(root.attrs, "data-asset-remote") == "true",
    })
  }
  for child in root.children {
    collect_scene_assets_into(output, child)
  }
}

///|
fn scene_asset_seen(items : Array[WechatSceneAsset], id : String) -> Bool {
  for item in items {
    if item.id == id {
      return true
    }
  }
  false
}

///|
fn attr_value(attrs : Array[@core.Attr], name : String) -> String {
  for item in attrs {
    if item.name == name {
      return item.value
    }
  }
  ""
}

///|
fn patch_kind_id(kind : @core.PatchKind) -> String {
  match kind {
    Set => "set"
    Append => "append"
    Remove => "remove"
  }
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
  } else if kind == "windowed-list" {
    "\{adapter.component_prefix}view"
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
  "const __bunniaEventPatches = \{event_patches_object(runtime.event_patches, plan)}\n" +
  "\n" +
  runtime_helpers_js() +
  "\n" +
  page_definition_js(name, plan, runtime.initial_data_json, "")
}

///|
fn project_page_js(
  name : String,
  route : String,
  plan : @core.RenderPlan,
) -> String {
  "const { __bunniaApplyPatches } = require('\{runtime_require_path(route)}')\n" +
  "const { initialData: __bunniaInitialData, eventPatches: __bunniaEventPatches } = require('\{page_payload_require_path(route)}')\n" +
  "\n" +
  page_definition_js(name, plan, "__bunniaInitialData", "")
}

///|
fn project_page_js_with_backend(
  name : String,
  route : String,
  plan : @core.RenderPlan,
  contract : @effects.BackendContract,
) -> String {
  "const { __bunniaApplyPatches } = require('\{runtime_require_path(route)}')\n" +
  "const { initialData: __bunniaInitialData, eventPatches: __bunniaEventPatches } = require('\{page_payload_require_path(route)}')\n" +
  "const { __bunniaRequest } = require('\{backend_require_path(route)}')\n" +
  "const __bunniaBackendEvents = \{backend_event_object(contract, plan)}\n" +
  "\n" +
  backend_request_dispatch_js() +
  "\n" +
  page_definition_js(
    name, plan, "__bunniaInitialData", "    __bunniaMaybeRequest(this, message)\n",
  )
}

///|
fn page_payload_js(runtime : WechatRuntime, plan : @core.RenderPlan) -> String {
  "const initialData = (\{runtime.initial_data_json})\n" +
  "const eventPatches = \{event_patches_object(runtime.event_patches, plan)}\n" +
  "\n" +
  "module.exports = { initialData, eventPatches }\n"
}

///|
fn runtime_js() -> String {
  runtime_helpers_js() +
  "\n" +
  "module.exports = { __bunniaReadPath, __bunniaApplyPatches }\n"
}

///|
fn runtime_helpers_js() -> String {
  "function __bunniaReadPath(root, path) {\n" +
  "  return String(path).split('.').reduce((value, part) => value == null ? undefined : value[part], root)\n" +
  "}\n" +
  "\n" +
  "function __bunniaApplyPatches(page, operations) {\n" +
  "  const update = {}\n" +
  "  ;(operations || []).forEach((patch) => {\n" +
  "    if (patch.kind === 'append') {\n" +
  "      const current = __bunniaReadPath(page.data, patch.path)\n" +
  "      update[patch.path] = Array.isArray(current) ? current.concat([patch.value]) : [patch.value]\n" +
  "    } else if (patch.kind === 'remove') {\n" +
  "      update[patch.path] = null\n" +
  "    } else {\n" +
  "      update[patch.path] = patch.value\n" +
  "    }\n" +
  "  })\n" +
  "  page.setData(update)\n" +
  "}\n"
}

///|
fn page_definition_js(
  name : String,
  plan : @core.RenderPlan,
  initial_data_expr : String,
  after_event_js : String,
) -> String {
  "Page({\n" +
  "  data: {\n" +
  "    __bunnia: {\n" +
  "      name: \"\{escape_json(name)}\",\n" +
  "      nodes: \{plan.node_count},\n" +
  "      depth: \{plan.depth},\n" +
  "      lastMessage: \"\",\n" +
  "      handledEvents: 0\n" +
  "    },\n" +
  "    ...(\{initial_data_expr})\n" +
  "  },\n" +
  "  __bunniaEvent(event) {\n" +
  "    const message = event.currentTarget.dataset.bunniaMessage\n" +
  "    const patches = __bunniaEventPatches[message] || []\n" +
  "    __bunniaApplyPatches(this, [\n" +
  "      { kind: 'set', path: '__bunnia.lastMessage', value: message },\n" +
  "      { kind: 'set', path: '__bunnia.handledEvents', value: (this.data.__bunnia.handledEvents || 0) + 1 },\n" +
  "      ...patches\n" +
  "    ])\n" +
  after_event_js +
  "  }\n" +
  "})"
}

///|
fn backend_request_dispatch_js() -> String {
  "function __bunniaMaybeRequest(page, message) {\n" +
  "  const endpointId = __bunniaBackendEvents[message]\n" +
  "  if (endpointId) __bunniaRequest(page, endpointId)\n" +
  "}\n"
}

///|
fn page_payload_file_path(route : String) -> String {
  "\{route}.data.js"
}

///|
fn page_payload_require_path(route : String) -> String {
  "./\{route_basename(route)}.data.js"
}

///|
fn route_basename(route : String) -> String {
  let mut start = 0
  for i in 0..<route.length() {
    if route[i] == '/' {
      start = i + 1
    }
  }
  route.sub(start~, end=route.length()).to_owned()
}

///|
fn runtime_require_path(route : String) -> String {
  let depth = route_slash_count(route)
  if depth == 0 {
    "./bunnia.runtime.js"
  } else {
    let out = StringBuilder::new()
    for _ in 0..<depth {
      out.write_string("../")
    }
    out.write_string("bunnia.runtime.js")
    out.to_string()
  }
}

///|
fn backend_require_path(route : String) -> String {
  let depth = route_slash_count(route)
  if depth == 0 {
    "./bunnia.backend.js"
  } else {
    let out = StringBuilder::new()
    for _ in 0..<depth {
      out.write_string("../")
    }
    out.write_string("bunnia.backend.js")
    out.to_string()
  }
}

///|
fn route_slash_count(route : String) -> Int {
  let mut count = 0
  for i in 0..<route.length() {
    if route[i] == '/' {
      count += 1
    }
  }
  count
}

///|
fn event_patches_object(
  items : Array[WechatEventPatch],
  plan : @core.RenderPlan,
) -> String {
  let out = StringBuilder::new()
  out.write_string("{")
  let mut emitted = 0
  for item in items {
    if plan.event_messages.contains(item.message) {
      if emitted > 0 {
        out.write_string(",")
      }
      emitted += 1
      out.write_string("\"")
      out.write_string(escape_json(item.message))
      out.write_string("\":")
      out.write_string(patches_to_operations(item.patches))
    }
  }
  out.write_string("}")
  out.to_string()
}

///|
fn backend_event_object(
  contract : @effects.BackendContract,
  plan : @core.RenderPlan,
) -> String {
  let out = StringBuilder::new()
  out.write_string("{")
  let mut emitted = 0
  for endpoint in contract.endpoints {
    if plan.event_messages.contains(endpoint.id) {
      if emitted > 0 {
        out.write_string(",")
      }
      emitted += 1
      out.write_string("\"")
      out.write_string(escape_json(endpoint.id))
      out.write_string("\":\"")
      out.write_string(escape_json(endpoint.id))
      out.write_string("\"")
    }
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
  ".bunnia-message-feed { display: flex; flex-direction: column; gap: 12rpx; }\n" +
  ".bunnia-message-feed-windowed { max-height: 720rpx; }\n" +
  ".bunnia-message { padding: 16rpx 20rpx; border: 1rpx solid #e5e7eb; border-radius: 8rpx; background: #ffffff; box-sizing: border-box; font-size: 28rpx; line-height: 1.5; }\n" +
  ".bunnia-run-running { border-color: #2563eb; box-shadow: 0 0 0 2rpx rgba(37, 99, 235, 0.10); }\n" +
  ".bunnia-run-waiting-review { border-color: #d97706; }\n" +
  ".bunnia-run-failed { border-color: #dc2626; }\n" +
  ".bunnia-artifact-link { margin-top: 8rpx; color: #2563eb; font-size: 24rpx; }\n" +
  ".bunnia-thread { padding: 16rpx 20rpx; border: 1rpx solid #d1d5db; border-radius: 8rpx; background: #ffffff; box-sizing: border-box; font-size: 28rpx; line-height: 1.5; }\n" +
  ".bunnia-subject-link { margin-top: 8rpx; color: #0891b2; font-size: 24rpx; }\n" +
  ".bunnia-communication-trace { display: flex; flex-direction: column; gap: 12rpx; }\n" +
  ".bunnia-communication-trace-windowed { max-height: 720rpx; overflow: hidden; }\n" +
  ".bunnia-communication { padding: 14rpx 18rpx; border-left: 6rpx solid #64748b; border-radius: 8rpx; background: #ffffff; box-sizing: border-box; font-size: 26rpx; line-height: 1.45; }\n" +
  ".bunnia-communication-message { border-left-color: #64748b; }\n" +
  ".bunnia-communication-handoff { border-left-color: #0891b2; }\n" +
  ".bunnia-communication-broadcast { border-left-color: #2563eb; }\n" +
  ".bunnia-communication-review-request { border-left-color: #d97706; }\n" +
  ".bunnia-communication-approval { border-left-color: #16a34a; }\n" +
  ".bunnia-communication-tool-result { border-left-color: #7c3aed; }\n" +
  ".bunnia-communication-recovery-notice { border-left-color: #dc2626; }\n" +
  ".bunnia-list-windowed { display: flex; flex-direction: column; gap: 12rpx; }\n" +
  ".bunnia-status-surface { position: relative; display: flex; flex-direction: column; gap: 10rpx; }\n" +
  ".bunnia-status-badge { align-self: flex-start; padding: 8rpx 12rpx; border: 1rpx solid #94a3b8; border-radius: 8rpx; background: #ffffff; color: #111827; font-size: 24rpx; line-height: 1.35; box-sizing: border-box; }\n" +
  ".bunnia-status-detail { margin-top: 2rpx; color: #475569; font-size: 22rpx; }\n" +
  ".bunnia-surface-state-loading { border-color: #2563eb; }\n" +
  ".bunnia-surface-state-ready { border-color: #16a34a; }\n" +
  ".bunnia-surface-state-stale { border-color: #d97706; }\n" +
  ".bunnia-surface-state-error { border-color: #dc2626; }\n" +
  ".bunnia-surface-state-retry { border-color: #0891b2; }\n" +
  ".bunnia-surface-state-cancelled { border-color: #64748b; }\n" +
  ".bunnia-surface-state-degraded { border-color: #7c3aed; }\n" +
  ".bunnia-review { display: flex; gap: 12rpx; align-items: center; padding: 16rpx; border: 1rpx solid #e5e7eb; border-radius: 8rpx; background: #ffffff; box-sizing: border-box; }\n" +
  ".bunnia-review-button { min-height: 56rpx; padding: 8rpx 14rpx; border: 1rpx solid #94a3b8; border-radius: 8rpx; background: #ffffff; color: #111827; font-size: 24rpx; line-height: 1.35; }\n" +
  ".bunnia-review-button-disabled { color: #64748b; background: #f1f5f9; }\n" +
  ".bunnia-review-pending { border-color: #d97706; }\n" +
  ".bunnia-review-approved { border-color: #16a34a; }\n" +
  ".bunnia-review-rejected { border-color: #dc2626; }\n" +
  ".bunnia-review-cancelled { border-color: #64748b; }\n" +
  ".bunnia-review-failed { border-color: #dc2626; background: #fef2f2; }\n" +
  ".bunnia-scene { position: relative; overflow: hidden; max-width: 100%; border: 1rpx solid #d1d5db; border-radius: 8rpx; background: #eef6f3; box-sizing: border-box; }\n" +
  ".bunnia-scene-layer { position: absolute; left: 0; top: 0; right: 0; bottom: 0; }\n" +
  ".bunnia-scene-marker { position: absolute; transform: translate(-50%, -50%); min-width: 120rpx; min-height: 56rpx; padding: 10rpx 14rpx; border: 2rpx solid #64748b; border-radius: 8rpx; background: #ffffff; box-sizing: border-box; font-size: 24rpx; line-height: 1.4; text-align: center; }\n" +
  ".bunnia-scene-sprite { display: block; width: 48rpx; height: 48rpx; margin: 0 auto 4rpx; }\n" +
  ".bunnia-scene-with-threads { position: relative; display: flex; flex-direction: column; gap: 10rpx; }\n" +
  ".bunnia-scene-thread-overlay { display: flex; flex-wrap: wrap; gap: 8rpx; }\n" +
  ".bunnia-scene-thread { min-width: 44rpx; min-height: 44rpx; padding: 6rpx 10rpx; border: 1rpx solid #64748b; border-radius: 8rpx; background: #ffffff; color: #111827; font-size: 22rpx; line-height: 1.35; text-align: center; box-sizing: border-box; }\n" +
  ".bunnia-scene-thread-running { border-color: #2563eb; }\n" +
  ".bunnia-scene-thread-review { border-color: #d97706; }\n" +
  ".bunnia-scene-thread-failed { border-color: #dc2626; }\n" +
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
