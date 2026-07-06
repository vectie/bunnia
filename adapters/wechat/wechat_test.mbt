///|
fn test_backend_contract() -> @effects.BackendContract {
  @effects.backend_contract(id="agent-backend", endpoints=[
    @effects.agent_message_endpoint(
      "send-message", "/agent/message", "draftMessage", "messageResult",
    ),
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
  assert_true(project.report.summary.contains("missing_event_patches=1"))
  assert_true(project.report.summary.contains("orphan_event_patches=1"))
}
