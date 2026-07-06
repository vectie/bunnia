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
