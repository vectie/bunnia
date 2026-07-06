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
  assert_true(
    js.contains("endpoint.payloadKey ? page.data[endpoint.payloadKey]"),
  )
  assert_true(js.contains("replayKey"))
  assert_true(js.contains("backend.' + endpointId + '.request"))
}

///|
test "wechat request adapter maps backend result states" {
  let js = generate_request_adapter(test_backend_contract())
  assert_true(js.contains("state'] = 'ready'"))
  assert_true(js.contains("state'] = 'failed'"))
  assert_true(js.contains("message.indexOf('timeout')"))
  assert_true(js.contains("state'] = 'malformed'"))
  assert_true(js.contains("state'] = 'cancelled'"))
  assert_true(js.contains("__bunniaRetryRequest"))
  assert_true(js.contains("__bunniaCancelRequest"))
  assert_true(
    js.contains(
      "module.exports = { __bunniaBackend, __bunniaRequest, __bunniaCancelRequest, __bunniaRetryRequest }",
    ),
  )
}

///|
test "wechat runtime preserves patch operation kinds" {
  let js = generate_set_data_call([
    @core.set_string("review.state", "approved"),
    @core.append_json("threads.thread-a.messages", "{\"id\":\"msg-1\"}"),
    @core.remove_path("draft.message"),
  ])
  assert_true(js.contains("__bunniaApplyPatches(this"))
  assert_true(
    js.contains("{kind:\"set\",path:\"review.state\",value:\"approved\"}"),
  )
  assert_true(
    js.contains(
      "{kind:\"append\",path:\"threads.thread-a.messages\",value:{\"id\":\"msg-1\"}}",
    ),
  )
  assert_true(
    js.contains("{kind:\"remove\",path:\"draft.message\",value:null}"),
  )
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
      "const eventPatches = {\"open\":[{kind:\"set\",path:\"state.open\",value:\"yes\"}]}",
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
  assert_true(project.page.js.contains("__bunniaMaybeRequest(this, message)"))
  assert_true(project.page.js.contains("__bunniaRequest(page, endpointId)"))
  assert_true(
    file_content(project.files, "bunnia.backend.js").contains(
      "const __bunniaBackend = {baseUrlKey:\"backendBaseUrl\"",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.backend.js").contains(
      "\"send-message\":{kind:\"agent-message-send\"",
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
  assert_true(
    file_content(project.files, "pages/index/index.data.js").contains(
      "\"open\":[{kind:\"set\",path:\"state.open\",value:\"yes\"}]",
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
