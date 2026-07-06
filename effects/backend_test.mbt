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
