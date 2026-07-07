///|
pub(all) enum BackendEndpointKind {
  SnapshotLoad
  StatusLoad
  OperatorSubmit
  AgentMessageSend
  AgentRunStatus
  ThreadLoad
  HandoffSubmit
  ReviewDecision
  ToolAck
  AgentOperationCancel
  AgentOperationRetry
  GenericEndpoint
} derive(Debug, Eq)

///|
pub(all) enum HttpMethod {
  Get
  Post
  Put
  Patch
  Delete
} derive(Debug, Eq)

///|
pub(all) enum BackendState {
  IdleState
  Loading
  Ready
  Stale
  Failed
  Timeout
  Malformed
  CancelledState
} derive(Debug, Eq)

///|
pub struct BackendEndpoint {
  id : String
  kind : BackendEndpointKind
  http_method : HttpMethod
  path : String
  payload_key : String
  response_key : String
  timeout_ms : Int
  streaming : Bool
  requires_review : Bool
} derive(Debug, Eq)

///|
pub struct BackendContract {
  id : String
  base_url_key : String
  session_token_key : String
  session_header_key : String
  endpoints : Array[BackendEndpoint]
} derive(Debug, Eq)

///|
pub struct BackendBudget {
  max_endpoints : Int
  max_streaming : Int
  max_review_required : Int
} derive(Debug, Eq)

///|
pub struct BackendPlan {
  contract : BackendContract
  endpoint_count : Int
  streaming_count : Int
  review_required_count : Int
  cancel_count : Int
  retry_count : Int
  diagnostics : Array[String]
  summary : String
} derive(Debug, Eq)

///|
pub fn backend_endpoint(
  id~ : String,
  kind~ : BackendEndpointKind,
  http_method~ : HttpMethod,
  path~ : String,
  payload_key? : String = "",
  response_key? : String = "",
  timeout_ms? : Int = 10000,
  streaming? : Bool = false,
  requires_review? : Bool = false,
) -> BackendEndpoint {
  {
    id,
    kind,
    http_method,
    path,
    payload_key,
    response_key,
    timeout_ms,
    streaming,
    requires_review,
  }
}

///|
pub fn backend_contract(
  id~ : String,
  base_url_key? : String = "backendBaseUrl",
  session_token_key? : String = "bunniaSessionId",
  session_header_key? : String = "x-miniapp-session",
  endpoints~ : Array[BackendEndpoint],
) -> BackendContract {
  { id, base_url_key, session_token_key, session_header_key, endpoints }
}

///|
pub fn backend_budget(
  max_endpoints~ : Int,
  max_streaming~ : Int,
  max_review_required~ : Int,
) -> BackendBudget {
  { max_endpoints, max_streaming, max_review_required }
}

///|
pub fn default_backend_budget() -> BackendBudget {
  { max_endpoints: 32, max_streaming: 4, max_review_required: 12 }
}

///|
pub fn plan_backend_contract(contract : BackendContract) -> BackendPlan {
  plan_backend_contract_with_budget(contract, default_backend_budget())
}

///|
pub fn plan_backend_contract_with_budget(
  contract : BackendContract,
  budget : BackendBudget,
) -> BackendPlan {
  let diagnostics : Array[String] = []
  let mut streaming_count = 0
  let mut review_required_count = 0
  let mut cancel_count = 0
  let mut retry_count = 0
  for endpoint in contract.endpoints {
    if endpoint.streaming {
      streaming_count += 1
    }
    if endpoint.requires_review {
      review_required_count += 1
    }
    if endpoint.kind is AgentOperationCancel {
      cancel_count += 1
    }
    if endpoint.kind is AgentOperationRetry {
      retry_count += 1
    }
  }
  if contract.endpoints.length() > budget.max_endpoints {
    diagnostics.push(
      "backend-endpoint-count-over-budget:\{contract.endpoints.length()}/\{budget.max_endpoints}",
    )
  }
  if streaming_count > budget.max_streaming {
    diagnostics.push(
      "backend-streaming-count-over-budget:\{streaming_count}/\{budget.max_streaming}",
    )
  }
  if review_required_count > budget.max_review_required {
    diagnostics.push(
      "backend-review-count-over-budget:\{review_required_count}/\{budget.max_review_required}",
    )
  }
  {
    contract,
    endpoint_count: contract.endpoints.length(),
    streaming_count,
    review_required_count,
    cancel_count,
    retry_count,
    diagnostics,
    summary: "Bunnia backend plan: contract=\{contract.id} endpoints=\{contract.endpoints.length()} streaming=\{streaming_count} review=\{review_required_count} cancel=\{cancel_count} retry=\{retry_count} diagnostics=\{diagnostics.length()}",
  }
}

///|
pub fn endpoint_effect(endpoint : BackendEndpoint, id? : String = "") -> Effect {
  let effect_id = if id == "" { endpoint.id } else { id }
  effect(
    id=effect_id,
    kind=backend_endpoint_effect_kind(endpoint),
    target=endpoint.path,
    payload_key=endpoint.payload_key,
    message=endpoint.id,
  )
}

///|
fn backend_endpoint_effect_kind(endpoint : BackendEndpoint) -> EffectKind {
  match endpoint.kind {
    AgentOperationCancel => Cancel
    AgentOperationRetry => Retry
    _ => if endpoint.streaming { Stream } else { Request }
  }
}

///|
pub fn backend_contract_effects(contract : BackendContract) -> Array[Effect] {
  let output : Array[Effect] = []
  for endpoint in contract.endpoints {
    output.push(endpoint_effect(endpoint))
  }
  output
}

///|
pub fn plan_backend_effects_for_platform(
  contract : BackendContract,
  platform : @core.Platform,
) -> EffectPlan {
  plan_effects_for_platform(backend_contract_effects(contract), platform)
}

///|
pub fn plan_backend_effects_for_adapter(
  contract : BackendContract,
  adapter : @core.PlatformAdapter,
) -> EffectPlan {
  plan_effects_for_adapter(backend_contract_effects(contract), adapter)
}

///|
pub fn snapshot_load_endpoint(
  id : String,
  path : String,
  response_key : String,
) -> BackendEndpoint {
  backend_endpoint(
    id~,
    kind=SnapshotLoad,
    http_method=Get,
    path~,
    response_key~,
  )
}

///|
pub fn status_load_endpoint(
  id : String,
  path : String,
  response_key : String,
) -> BackendEndpoint {
  backend_endpoint(id~, kind=StatusLoad, http_method=Get, path~, response_key~)
}

///|
pub fn operator_submit_endpoint(
  id : String,
  path : String,
  payload_key : String,
  response_key : String,
) -> BackendEndpoint {
  backend_endpoint(
    id~,
    kind=OperatorSubmit,
    http_method=Post,
    path~,
    payload_key~,
    response_key~,
    requires_review=true,
  )
}

///|
pub fn agent_message_endpoint(
  id : String,
  path : String,
  payload_key : String,
  response_key : String,
) -> BackendEndpoint {
  backend_endpoint(
    id~,
    kind=AgentMessageSend,
    http_method=Post,
    path~,
    payload_key~,
    response_key~,
  )
}

///|
pub fn agent_stream_endpoint(
  id : String,
  path : String,
  payload_key : String,
  response_key : String,
) -> BackendEndpoint {
  backend_endpoint(
    id~,
    kind=AgentRunStatus,
    http_method=Get,
    path~,
    payload_key~,
    response_key~,
    streaming=true,
  )
}

///|
pub fn thread_load_endpoint(
  id : String,
  path : String,
  response_key : String,
) -> BackendEndpoint {
  backend_endpoint(id~, kind=ThreadLoad, http_method=Get, path~, response_key~)
}

///|
pub fn handoff_submit_endpoint(
  id : String,
  path : String,
  payload_key : String,
  response_key : String,
) -> BackendEndpoint {
  backend_endpoint(
    id~,
    kind=HandoffSubmit,
    http_method=Post,
    path~,
    payload_key~,
    response_key~,
    requires_review=true,
  )
}

///|
pub fn review_decision_endpoint(
  id : String,
  path : String,
  payload_key : String,
  response_key : String,
) -> BackendEndpoint {
  backend_endpoint(
    id~,
    kind=ReviewDecision,
    http_method=Post,
    path~,
    payload_key~,
    response_key~,
    requires_review=true,
  )
}

///|
pub fn tool_ack_endpoint(
  id : String,
  path : String,
  payload_key : String,
) -> BackendEndpoint {
  backend_endpoint(id~, kind=ToolAck, http_method=Post, path~, payload_key~)
}

///|
pub fn agent_cancel_endpoint(
  id : String,
  path : String,
  payload_key : String,
  response_key : String,
) -> BackendEndpoint {
  backend_endpoint(
    id~,
    kind=AgentOperationCancel,
    http_method=Post,
    path~,
    payload_key~,
    response_key~,
  )
}

///|
pub fn agent_retry_endpoint(
  id : String,
  path : String,
  payload_key : String,
  response_key : String,
) -> BackendEndpoint {
  backend_endpoint(
    id~,
    kind=AgentOperationRetry,
    http_method=Post,
    path~,
    payload_key~,
    response_key~,
  )
}

///|
pub fn generic_endpoint(
  id : String,
  path : String,
  http_method : HttpMethod,
  payload_key? : String = "",
  response_key? : String = "",
) -> BackendEndpoint {
  backend_endpoint(
    id~,
    kind=GenericEndpoint,
    http_method~,
    path~,
    payload_key~,
    response_key~,
  )
}

///|
pub fn backend_state_patch(scope : String, state : BackendState) -> @core.Patch {
  @core.set_string("backend.\{scope}.state", backend_state_id(state))
}

///|
pub fn backend_error_patch(scope : String, message : String) -> @core.Patch {
  @core.set_string("backend.\{scope}.error", message)
}

///|
pub fn backend_response_patch(
  scope : String,
  value_json : String,
) -> @core.Patch {
  @core.set_json("backend.\{scope}.response", value_json)
}

///|
pub fn backend_state_id(state : BackendState) -> String {
  match state {
    IdleState => "idle"
    Loading => "loading"
    Ready => "ready"
    Stale => "stale"
    Failed => "failed"
    Timeout => "timeout"
    Malformed => "malformed"
    CancelledState => "cancelled"
  }
}

///|
pub fn backend_endpoint_kind_id(kind : BackendEndpointKind) -> String {
  match kind {
    SnapshotLoad => "snapshot-load"
    StatusLoad => "status-load"
    OperatorSubmit => "operator-submit"
    AgentMessageSend => "agent-message-send"
    AgentRunStatus => "agent-run-status"
    ThreadLoad => "thread-load"
    HandoffSubmit => "handoff-submit"
    ReviewDecision => "review-decision"
    ToolAck => "tool-ack"
    AgentOperationCancel => "agent-operation-cancel"
    AgentOperationRetry => "agent-operation-retry"
    GenericEndpoint => "generic"
  }
}

///|
pub fn http_method_id(input : HttpMethod) -> String {
  match input {
    Get => "GET"
    Post => "POST"
    Put => "PUT"
    Patch => "PATCH"
    Delete => "DELETE"
  }
}
