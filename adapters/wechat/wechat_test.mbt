///|
fn test_backend_contract() -> @effects.BackendContract {
  @effects.backend_contract(id="agent-backend", endpoints=[
    @effects.agent_message_endpoint(
      "send-message", "/agent/message", "draftMessage", "messageResult",
    ),
    @effects.status_load_endpoint("load-status", "/status", "status"),
  ])
}

///|
test "wechat request adapter records replayable request data" {
  let js = generate_request_adapter(test_backend_contract())
  assert_true(js.contains("const requestPayload"))
  assert_true(js.contains("endpoint.p ? page.data[endpoint.p]"))
  assert_true(js.contains("replayKey"))
  assert_true(js.contains("backend.' + endpointId + '.request"))
  assert_true(js.contains("backendStatus.' + String(endpointId).replace"))
  assert_true(js.contains("__bs(loading, endpointId, 'loading', '')"))
}

///|
test "wechat request adapter carries session headers and response keys" {
  let js = generate_request_adapter(test_backend_contract())
  assert_true(js.contains("s:\"bunniaSessionId\""))
  assert_true(js.contains("h:\"x-miniapp-session\""))
  assert_true(js.contains("header: __bunniaRequestHeaders(page)"))
  assert_true(js.contains("if (endpoint.r) update[endpoint.r] = res.data"))
  assert_true(js.contains("__bunniaSessionIdFromResponse(res.data)"))
}

///|
test "wechat request adapter maps backend result states" {
  let js = generate_request_adapter(test_backend_contract())
  assert_true(js.contains("state'] = 'ready'"))
  assert_true(js.contains("state'] = 'failed'"))
  assert_true(js.contains("message.indexOf('timeout')"))
  assert_true(js.contains("state'] = 'malformed'"))
  assert_true(js.contains("state'] = 'cancelled'"))
  assert_true(js.contains("__bs(update, endpointId, 'ready', '')"))
  assert_true(js.contains("__bs(update, endpointId, 'cancelled', '')"))
  assert_true(js.contains("__bunniaRetryRequest"))
  assert_true(js.contains("__bunniaCancelRequest"))
  assert_true(
    js.contains(
      "module.exports = { __bunniaBackend, __bunniaRequest, __bunniaCancelRequest, __bunniaRetryRequest }",
    ),
  )
}

///|
test "wechat backend dispatch handles agent cancel and retry endpoint kinds" {
  let contract = @effects.backend_contract(id="agent-ops", endpoints=[
    @effects.agent_cancel_endpoint(
      "cancel-agent-run", "/agent/run/cancel", "runCancel", "cancelResult",
    ),
    @effects.agent_retry_endpoint(
      "retry-agent-run", "/agent/run/retry", "runRetry", "retryResult",
    ),
  ])
  let project = generate_project_with_runtime_and_backend(
    name="Agent Ops",
    route="pages/ops/index",
    root=@core.page([
      @core.button("Cancel", "cancel-agent-run"),
      @core.button("Retry", "retry-agent-run"),
    ]),
    runtime=runtime(event_patches=[
      event_patch("cancel-agent-run", [
        @core.set_string("backend.cancel-agent-run.state", "cancelled"),
      ]),
      event_patch("retry-agent-run", [
        @core.set_string("backend.retry-agent-run.state", "loading"),
      ]),
    ]),
    backend_contract=contract,
  )
  let js = project.page.js
  let backend_js = file_content(project.files, "bunnia.backend.js")
  assert_true(
    js.contains(
      "__bunniaMaybeRequest(this,message,event.currentTarget.dataset||{})",
    ),
  )
  assert_true(
    js.contains(
      "['runId','reviewId','decision','buildingId','bookId','agentId','targetUserId','noticeId','noticeKind','targetRef']",
    ),
  )
  assert_true(js.contains("h=b[k]=d[k]"))
  assert_true(js.contains("e.k==='agent-operation-cancel'"))
  assert_true(js.contains("e.k==='agent-operation-retry'"))
  assert_true(
    js.contains("pl?__bunniaRequest(p,id,pl):__bunniaRetryRequest(p,id)"),
  )
  assert_true(js.contains("return __bunniaRequest(p,id,pl)"))
  assert_true(backend_js.contains("k:\"agent-operation-cancel\""))
  assert_true(backend_js.contains("k:\"agent-operation-retry\""))
}

///|
test "wechat event handler can navigate from route data" {
  let project = generate_project(
    name="Route Navigation",
    route="pages/nav/index",
    root=@core.page([
      @core.node(
        kind="button",
        attrs=[@core.data("bunnia-route", "pages/nav/messages")],
        events=[@core.event("tap", "tab-messages")],
        children=[@core.text("Messages")],
      ),
    ]),
  )
  assert_true(
    project.page.wxml.contains("data-bunnia-route=\"pages/nav/messages\""),
  )
  assert_true(
    project.page.js.contains("event.currentTarget.dataset.bunniaRoute"),
  )
  assert_true(project.page.js.contains("wx.redirectTo"))
  assert_true(
    project.page.js.contains("url: route[0] === '/' ? route : '/' + route"),
  )
}

///|
test "wechat project backend module emits only route reachable endpoints" {
  let contract = @effects.backend_contract(id="route-filter", endpoints=[
    @effects.operator_submit_endpoint(
      "visible-submit", "/visible", "visibleDraft", "visibleResult",
    ),
    @effects.operator_submit_endpoint(
      "hidden-submit", "/hidden", "hiddenDraft", "hiddenResult",
    ),
  ])
  let project = generate_project_with_runtime_and_backend(
    name="Route Filter",
    route="pages/filter/index",
    root=@core.page([@core.button("Visible", "visible-submit")]),
    runtime=runtime(),
    backend_contract=contract,
  )
  let backend_js = file_content(project.files, "bunnia.backend.js")
  assert_true(backend_js.contains("/visible"))
  assert_true(!backend_js.contains("/hidden"))
  assert_true(project.page.js.contains("\"visible-submit\":\"visible-submit\""))
  assert_true(!project.page.js.contains("hidden-submit"))
}

///|
test "wechat runtime preserves patch operation kinds" {
  let js = generate_set_data_call([
    @core.set_string("review.state", "approved"),
    @core.append_json("threads.thread-a.messages", "{\"id\":\"msg-1\"}"),
    @core.remove_path("draft.message"),
  ])
  assert_true(js.contains("__bunniaApplyPatches(this"))
  assert_true(js.contains("{k:\"set\",p:\"review.state\",v:\"approved\"}"))
  assert_true(
    js.contains(
      "{k:\"append\",p:\"threads.thread-a.messages\",v:{\"id\":\"msg-1\"}}",
    ),
  )
  assert_true(js.contains("{k:\"remove\",p:\"draft.message\",v:null}"))
}

///|
test "wechat projects share generated patch runtime" {
  let project = generate_project_with_runtime(
    name="Runtime Split",
    route="pages/runtime/index",
    root=@core.page([@core.button("Open", "open")]),
    runtime=runtime(event_patches=[
      event_patch("open", [@core.set_string("state.open", "yes")]),
    ]),
  )
  assert_true(has_file(project.files, "bunnia.runtime.js"))
  assert_true(has_file(project.files, "pages/runtime/index.data.js"))
  assert_true(project.page.js.contains("require('../../bunnia.runtime.js')"))
  assert_true(project.page.js.contains("require('./index.data.js')"))
  assert_true(project.page.js.contains("__bunniaInitialData"))
  assert_true(!project.page.js.contains("const __bunniaEventPatches = {"))
  assert_true(!project.page.js.contains("__bunniaMaybeRequest"))
  assert_true(!project.page.js.contains("function __bunniaReadPath"))
  assert_true(
    file_content(project.files, "pages/runtime/index.data.js").contains(
      "const eventPatches = {\"open\":[{k:\"set\",p:\"state.open\",v:\"yes\"}]}",
    ),
  )
  assert_true(
    file_content(project.files, "pages/runtime/index.data.js").contains(
      "module.exports = { initialData, eventPatches }",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.runtime.js").contains(
      "module.exports = { __bunniaReadPath, __bunniaApplyPatches }",
    ),
  )
}

///|
test "wechat projects share default styles at app level" {
  let project = generate_project_with_runtime(
    name="Style Split",
    route="pages/style/index",
    root=@core.page([@core.view([@core.text("Styled")])]),
    runtime=default_runtime(),
  )
  assert_true(has_file(project.files, "app.wxss"))
  assert_true(!has_file(project.files, "pages/style/index.wxss"))
  assert_eq(project.page.wxss, "")
  assert_true(file_content(project.files, "app.wxss").contains(".bunnia-scene"))
  assert_eq(project.manifest.files[4].path, "app.wxss")
  assert_eq(project.manifest.files[4].route, "")
  assert_true(has_file(project.files, "pages/style/index.data.js"))
  assert_eq(project.manifest.files[6].path, "pages/style/index.data.js")
  assert_eq(project.manifest.files[6].kind, "page-data")
  assert_eq(project.manifest.files[6].route, "pages/style/index")
}

///|
test "wechat manifests expose route scene asset references" {
  let scene_asset = @core.node(kind="image", attrs=[
    @core.class_name("bunnia-scene-sprite"),
    @core.attr("src", "https://cdn.example.test/agent.png"),
    @core.attr("alt", "Agent"),
    @core.data("asset-id", "agent"),
    @core.data("asset-kind", "remote-image"),
    @core.data("asset-remote", "true"),
  ])
  let duplicate = @core.node(kind="image", attrs=[
    @core.class_name("bunnia-scene-sprite"),
    @core.attr("src", "https://cdn.example.test/agent.png"),
    @core.attr("alt", "Agent duplicate"),
    @core.data("asset-id", "agent"),
    @core.data("asset-kind", "remote-image"),
    @core.data("asset-remote", "true"),
  ])
  let project = generate_project(
    name="Scene Asset Manifest",
    route="pages/assets/index",
    root=@core.page([
      @core.view([
        scene_asset,
        duplicate,
        @core.image("/assets/general.png", "general image"),
      ]),
    ]),
  )
  assert_eq(project.page.scene_assets.length(), 1)
  assert_eq(project.page.scene_assets[0].id, "agent")
  assert_eq(project.page.scene_assets[0].kind, "remote-image")
  assert_eq(
    project.page.scene_assets[0].src,
    "https://cdn.example.test/agent.png",
  )
  assert_eq(project.page.scene_assets[0].remote, true)
  assert_eq(project.manifest.scene_asset_count, 1)
  assert_eq(project.manifest.scene_remote_asset_count, 1)
  assert_eq(project.manifest.scene_package_bytes, 0)
  assert_eq(project.manifest.scene_assets.length(), 1)
  assert_eq(project.manifest.pages[0].scene_assets.length(), 1)
  assert_eq(project.manifest.pages[0].scene_remote_asset_count, 1)
  assert_eq(project.manifest.pages[0].scene_package_bytes, 0)
  assert_eq(
    project.manifest.pages[0].scene_assets[0].route,
    "pages/assets/index",
  )
  assert_true(project.manifest.summary.contains("scene_assets=1"))
  assert_true(project.manifest.summary.contains("scene_remote_assets=1"))
  assert_true(project.manifest.summary.contains("scene_package_bytes=0"))
  assert_true(
    file_content(project.files, "bunnia.manifest.json").contains(
      "\"sceneAssetRefs\":[{\"route\":\"pages/assets/index\",\"id\":\"agent\",\"kind\":\"remote-image\",\"src\":\"https://cdn.example.test/agent.png\",\"remote\":true,\"estimatedBytes\":0}]",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.manifest.json").contains(
      "\"sceneAssets\": [{\"route\":\"pages/assets/index\",\"id\":\"agent\",\"kind\":\"remote-image\",\"src\":\"https://cdn.example.test/agent.png\",\"remote\":true,\"estimatedBytes\":0}]",
    ),
  )
}

///|
test "wechat projects can package backend request adapter" {
  let project = generate_project_with_runtime_and_backend(
    name="Backend Split",
    route="pages/backend/index",
    root=@core.page([@core.button("Send", "send-message")]),
    runtime=runtime(event_patches=[
      event_patch("send-message", [
        @core.set_string("backend.send-message.state", "loading"),
      ]),
    ]),
    backend_contract=test_backend_contract(),
  )
  assert_true(has_file(project.files, "bunnia.backend.js"))
  assert_eq(project.files.length(), 11)
  assert_eq(project.manifest.app_file_count, 10)
  assert_true(project.page.js.contains("require('../../bunnia.backend.js')"))
  assert_true(project.page.js.contains("\"send-message\":\"send-message\""))
  assert_true(!project.page.js.contains("\"load-status\""))
  assert_true(
    project.page.js.contains(
      "__bunniaMaybeRequest(this,message,event.currentTarget.dataset||{})",
    ),
  )
  assert_true(project.page.js.contains("__bunniaRequest(p,id,pl)"))
  assert_true(
    file_content(project.files, "bunnia.backend.js").contains(
      "const __bunniaBackend = {b:\"backendBaseUrl\"",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.backend.js").contains(
      "\"send-message\":{k:\"agent-message-send\"",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.manifest.json").contains(
      "\"path\":\"bunnia.backend.js\",\"kind\":\"backend-js\",\"route\":\"\"",
    ),
  )
}

///|
test "backend-aware projects keep local-only routes backend-free" {
  let local_page = project_page(
    name="Local",
    route="pages/local/index",
    root=@core.page([@core.button("Local", "local-only")]),
    runtime=runtime(event_patches=[
      event_patch("local-only", [@core.set_string("state.local", "yes")]),
    ]),
  )
  let backend_page = project_page(
    name="Backend",
    route="pages/backend/index",
    root=@core.page([@core.button("Send", "send-message")]),
    runtime=runtime(event_patches=[
      event_patch("send-message", [
        @core.set_string("backend.send-message.state", "loading"),
      ]),
    ]),
  )
  let project = generate_project_from_pages_with_backend(
    name="Mixed Backend",
    pages=[local_page, backend_page],
    backend_contract=test_backend_contract(),
  )
  let local_js = file_content(project.files, "pages/local/index.js")
  let backend_js = file_content(project.files, "pages/backend/index.js")
  assert_true(has_file(project.files, "bunnia.backend.js"))
  assert_true(!local_js.contains("bunnia.backend.js"))
  assert_true(!local_js.contains("__bunniaBackendEvents"))
  assert_true(backend_js.contains("bunnia.backend.js"))
  assert_true(backend_js.contains("\"send-message\":\"send-message\""))
  assert_true(!backend_js.contains("\"load-status\""))
  assert_true(
    project.manifest.pages[0].first_screen_bytes <
    project.manifest.pages[1].first_screen_bytes,
  )
}

///|
test "wechat manifests attribute reachable backend pressure per route" {
  let local_page = project_page(
    name="Local",
    route="pages/local/index",
    root=@core.page([@core.button("Local", "local-only")]),
    runtime=runtime(event_patches=[
      event_patch("local-only", [@core.set_string("state.local", "yes")]),
    ]),
  )
  let backend_page = project_page(
    name="Agent Backend",
    route="pages/agent/index",
    root=@core.page([
      @core.button("Send", "send-agent"),
      @core.button("Stream", "stream-agent"),
      @core.button("Review", "review-agent"),
      @core.button("Cancel", "cancel-agent"),
      @core.button("Retry", "retry-agent"),
    ]),
    runtime=runtime(event_patches=[
      event_patch("send-agent", [
        @core.set_string("backend.send-agent.state", "loading"),
      ]),
      event_patch("stream-agent", [
        @core.set_string("backend.stream-agent.state", "loading"),
      ]),
      event_patch("review-agent", [
        @core.set_string("backend.review-agent.state", "loading"),
      ]),
      event_patch("cancel-agent", [
        @core.set_string("backend.cancel-agent.state", "loading"),
      ]),
      event_patch("retry-agent", [
        @core.set_string("backend.retry-agent.state", "loading"),
      ]),
    ]),
  )
  let contract = @effects.backend_contract(id="agent-pressure", endpoints=[
    @effects.agent_message_endpoint(
      "send-agent", "/agent/message", "draft", "messageResult",
    ),
    @effects.agent_stream_endpoint(
      "stream-agent", "/agent/stream", "streamCursor", "streamResult",
    ),
    @effects.review_decision_endpoint(
      "review-agent", "/agent/review", "reviewDecision", "reviewResult",
    ),
    @effects.agent_cancel_endpoint(
      "cancel-agent", "/agent/cancel", "runCancel", "cancelResult",
    ),
    @effects.agent_retry_endpoint(
      "retry-agent", "/agent/retry", "runRetry", "retryResult",
    ),
    @effects.status_load_endpoint("unused-status", "/status", "status"),
  ])
  let project = generate_project_from_pages_with_backend(
    name="Backend Pressure",
    pages=[local_page, backend_page],
    backend_contract=contract,
  )
  assert_eq(project.manifest.pages[0].backend_event_count, 0)
  assert_eq(project.manifest.pages[0].backend_stream_count, 0)
  assert_eq(project.manifest.pages[0].backend_review_count, 0)
  assert_eq(project.manifest.pages[0].backend_cancel_count, 0)
  assert_eq(project.manifest.pages[0].backend_retry_count, 0)
  assert_eq(project.manifest.pages[1].backend_event_count, 5)
  assert_eq(project.manifest.pages[1].backend_stream_count, 1)
  assert_eq(project.manifest.pages[1].backend_review_count, 1)
  assert_eq(project.manifest.pages[1].backend_cancel_count, 1)
  assert_eq(project.manifest.pages[1].backend_retry_count, 1)
  assert_true(
    file_content(project.files, "bunnia.manifest.json").contains(
      "\"backendEvents\":5,\"backendStreams\":1,\"backendReviews\":1,\"backendCancels\":1,\"backendRetries\":1",
    ),
  )
}

///|
test "wechat build reports missing and orphan event patches" {
  let project = generate_project_with_runtime(
    name="Runtime Coverage",
    root=@core.page([
      @core.button("Open", "open"),
      @core.button("Missing", "missing"),
    ]),
    runtime=runtime(event_patches=[
      event_patch("open", [@core.set_string("state.open", "yes")]),
      event_patch("orphan", [@core.set_string("state.orphan", "yes")]),
    ]),
  )
  assert_eq(project.report.missing_event_patch_count, 1)
  assert_eq(project.report.orphan_event_patch_count, 1)
  assert_true(
    project.report.diagnostics.contains(
      "wechat-event-without-patch:pages/index/index:missing",
    ),
  )
  assert_true(
    project.report.diagnostics.contains(
      "wechat-patch-without-event:pages/index/index:orphan",
    ),
  )
  assert_eq(project.manifest.pages[0].missing_event_patch_count, 1)
  assert_eq(project.manifest.pages[0].orphan_event_patch_count, 1)
  assert_eq(project.manifest.pages[0].diagnostic_count, 2)
  assert_eq(project.manifest.pages[0].status, "diagnostic")
  assert_eq(project.manifest.diagnostic_route_count, 1)
  assert_eq(project.manifest.diagnostic_count, 2)
  assert_true(
    project.manifest.pages[0].diagnostics.contains(
      "wechat-event-without-patch:pages/index/index:missing",
    ),
  )
  assert_true(
    project.manifest.pages[0].diagnostics.contains(
      "wechat-patch-without-event:pages/index/index:orphan",
    ),
  )
  assert_true(
    file_content(project.files, "pages/index/index.data.js").contains(
      "\"open\":[{k:\"set\",p:\"state.open\",v:\"yes\"}]",
    ),
  )
  assert_true(
    !file_content(project.files, "pages/index/index.data.js").contains("orphan"),
  )
  assert_eq(
    project.manifest.pages[0].event_patch_bytes,
    project.report.event_patch_bytes,
  )
  assert_eq(
    project.manifest.pages[0].update_payload_bytes,
    project.report.event_patch_bytes,
  )
  assert_true(
    file_content(project.files, "bunnia.manifest.json").contains(
      "\"missingEventPatches\":1,\"orphanEventPatches\":1",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.manifest.json").contains(
      "\"diagnostics\":[\"wechat-event-without-patch:pages/index/index:missing\", \"wechat-patch-without-event:pages/index/index:orphan\"]",
    ),
  )
  assert_true(project.report.summary.contains("missing_event_patches=1"))
  assert_true(project.report.summary.contains("orphan_event_patches=1"))
}

///|
fn has_file(files : Array[WechatFile], path : String) -> Bool {
  for item in files {
    if item.path == path {
      return true
    }
  }
  false
}

///|
fn file_content(files : Array[WechatFile], path : String) -> String {
  for item in files {
    if item.path == path {
      return item.content
    }
  }
  ""
}
