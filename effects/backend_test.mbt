///|
fn test_operator_endpoint() -> BackendEndpoint {
  operator_submit_endpoint(
    "submit-operator", "/operator/request", "operatorRequest", "operatorResult",
  )
}

///|
fn test_backend_request() -> BackendRequest {
  backend_request(
    id="request-1",
    endpoint=test_operator_endpoint(),
    payload_json="{\"text\":\"approve\"}",
    replay_key="replay-1",
  )
}

///|
test "backend request patches capture replayable loading state" {
  let patches = backend_request_patches(test_backend_request())
  let plan = @core.plan_patches(patches)
  assert_eq(patches.length(), 4)
  assert_eq(patches[0].path, "backend.submit-operator.request")
  assert_eq(patches[1].path, "backend.submit-operator.replayKey")
  assert_eq(patches[2].value_json, "\"loading\"")
  assert_eq(plan.diagnostics.length(), 0)
  assert_true(plan.total_estimated_bytes < 256)
}

///|
test "backend result patches cover success failure timeout malformed and cancel" {
  let request = test_backend_request()
  let success = backend_result_patches(
    backend_success(request, "{\"ok\":true}"),
  )
  let failure = backend_result_patches(backend_failure(request, "denied"))
  let timeout = backend_result_patches(backend_timeout(request))
  let malformed = backend_result_patches(backend_malformed(request))
  let cancelled = backend_result_patches(backend_cancelled(request))
  assert_eq(success.length(), 3)
  assert_eq(success[0].value_json, "\"ready\"")
  assert_eq(success[1].path, "backend.submit-operator.response")
  assert_eq(failure[0].value_json, "\"failed\"")
  assert_eq(timeout[0].value_json, "\"timeout\"")
  assert_eq(malformed[0].value_json, "\"malformed\"")
  assert_eq(cancelled[0].value_json, "\"cancelled\"")
}

///|
test "backend result kind ids stay stable for generated runtimes" {
  assert_eq(backend_result_kind_id(BackendSuccess), "success")
  assert_eq(backend_result_kind_id(BackendFailure), "failure")
  assert_eq(backend_result_kind_id(BackendTimeout), "timeout")
  assert_eq(backend_result_kind_id(BackendMalformed), "malformed")
  assert_eq(backend_result_kind_id(BackendCancelled), "cancelled")
}

///|
test "agent cancel and retry endpoints lower to explicit effects" {
  let cancel = agent_cancel_endpoint(
    "cancel-agent-run", "/agent/run/cancel", "runCancel", "cancelResult",
  )
  let retry = agent_retry_endpoint(
    "retry-agent-run", "/agent/run/retry", "runRetry", "retryResult",
  )
  let plan = plan_backend_contract(
    backend_contract(id="agent-operations", endpoints=[cancel, retry]),
  )
  let cancel_effect = endpoint_effect(cancel)
  let retry_effect = endpoint_effect(retry)
  assert_eq(backend_endpoint_kind_id(cancel.kind), "agent-operation-cancel")
  assert_eq(backend_endpoint_kind_id(retry.kind), "agent-operation-retry")
  assert_eq(plan.cancel_count, 1)
  assert_eq(plan.retry_count, 1)
  assert_eq(effect_kind_id(cancel_effect.kind), "cancel")
  assert_eq(effect_kind_id(retry_effect.kind), "retry")
  assert_eq(cancel_effect.target, "/agent/run/cancel")
  assert_eq(retry_effect.target, "/agent/run/retry")
  assert_true(plan.summary.contains("cancel=1 retry=1"))
}
