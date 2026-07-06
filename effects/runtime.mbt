///|
pub(all) enum BackendResultKind {
  BackendSuccess
  BackendFailure
  BackendTimeout
  BackendMalformed
  BackendCancelled
} derive(Debug, Eq)

///|
pub struct BackendRequest {
  id : String
  endpoint_id : String
  payload_json : String
  replay_key : String
} derive(Debug, Eq)

///|
pub struct BackendResult {
  request : BackendRequest
  kind : BackendResultKind
  response_json : String
  error_message : String
} derive(Debug, Eq)

///|
pub fn backend_request(
  id~ : String,
  endpoint~ : BackendEndpoint,
  payload_json? : String = "{}",
  replay_key? : String = "",
) -> BackendRequest {
  { id, endpoint_id: endpoint.id, payload_json, replay_key }
}

///|
pub fn backend_request_patches(input : BackendRequest) -> Array[@core.Patch] {
  [
    @core.set_json("backend.\{input.endpoint_id}.request", input.payload_json),
    @core.set_string("backend.\{input.endpoint_id}.replayKey", input.replay_key),
    backend_state_patch(input.endpoint_id, Loading),
    backend_error_patch(input.endpoint_id, ""),
  ]
}

///|
pub fn backend_success(
  request : BackendRequest,
  response_json : String,
) -> BackendResult {
  backend_result(request~, kind=BackendSuccess, response_json~)
}

///|
pub fn backend_failure(
  request : BackendRequest,
  error_message : String,
) -> BackendResult {
  backend_result(request~, kind=BackendFailure, error_message~)
}

///|
pub fn backend_timeout(
  request : BackendRequest,
  error_message? : String = "request timeout",
) -> BackendResult {
  backend_result(request~, kind=BackendTimeout, error_message~)
}

///|
pub fn backend_malformed(
  request : BackendRequest,
  error_message? : String = "malformed response",
) -> BackendResult {
  backend_result(request~, kind=BackendMalformed, error_message~)
}

///|
pub fn backend_cancelled(request : BackendRequest) -> BackendResult {
  backend_result(request~, kind=BackendCancelled)
}

///|
pub fn backend_result_patches(input : BackendResult) -> Array[@core.Patch] {
  let scope = input.request.endpoint_id
  match input.kind {
    BackendSuccess =>
      [
        backend_state_patch(scope, Ready),
        backend_response_patch(scope, input.response_json),
        backend_error_patch(scope, ""),
      ]
    BackendFailure =>
      [
        backend_state_patch(scope, Failed),
        backend_error_patch(scope, input.error_message),
      ]
    BackendTimeout =>
      [
        backend_state_patch(scope, Timeout),
        backend_error_patch(scope, input.error_message),
      ]
    BackendMalformed =>
      [
        backend_state_patch(scope, Malformed),
        backend_error_patch(scope, input.error_message),
      ]
    BackendCancelled =>
      [
        backend_state_patch(scope, CancelledState),
        backend_error_patch(scope, ""),
      ]
  }
}

///|
pub fn backend_result_kind_id(kind : BackendResultKind) -> String {
  match kind {
    BackendSuccess => "success"
    BackendFailure => "failure"
    BackendTimeout => "timeout"
    BackendMalformed => "malformed"
    BackendCancelled => "cancelled"
  }
}

///|
fn backend_result(
  request~ : BackendRequest,
  kind~ : BackendResultKind,
  response_json? : String = "null",
  error_message? : String = "",
) -> BackendResult {
  { request, kind, response_json, error_message }
}
