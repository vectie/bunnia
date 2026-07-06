///|
pub(all) enum AgentDeltaKind {
  AppendMessage
  AppendCommunication
  AppendStreamChunk
  SetRunStatus
  SetReviewState
} derive(Debug, Eq)

///|
pub struct AgentDelta {
  id : String
  kind : AgentDeltaKind
  target_path : String
  patches : Array[@core.Patch]
} derive(Debug, Eq)

///|
pub struct AgentDeltaPlan {
  deltas : Array[AgentDelta]
  patch_plan : @core.PatchPlan
  diagnostics : Array[String]
  summary : String
} derive(Debug, Eq)

///|
pub fn append_message_delta(target_path : String, item : Message) -> AgentDelta {
  agent_delta(
    id="append-message:\{item.id}",
    kind=AppendMessage,
    target_path~,
    patches=[@core.append_json(target_path, message_json(item))],
  )
}

///|
pub fn append_communication_delta(
  target_path : String,
  item : Communication,
) -> AgentDelta {
  agent_delta(
    id="append-communication:\{item.id}",
    kind=AppendCommunication,
    target_path~,
    patches=[@core.append_json(target_path, communication_json(item))],
  )
}

///|
pub fn append_stream_chunk_delta(
  target_path : String,
  chunk_id : String,
  text : String,
  status? : RunStatus = Running,
) -> AgentDelta {
  agent_delta(
    id="append-stream-chunk:\{chunk_id}",
    kind=AppendStreamChunk,
    target_path~,
    patches=[
      @core.append_json(
        target_path,
        "{\"id\":\"\{escape_json(chunk_id)}\",\"text\":\"\{escape_json(text)}\",\"status\":\"\{run_status_id(status)}\"}",
      ),
    ],
  )
}

///|
pub fn set_run_status_delta(
  target_path : String,
  status : RunStatus,
) -> AgentDelta {
  agent_delta(
    id="set-run-status:\{target_path}",
    kind=SetRunStatus,
    target_path~,
    patches=[@core.set_string(target_path, run_status_id(status))],
  )
}

///|
pub fn set_review_state_delta(
  target_path : String,
  state : ReviewState,
) -> AgentDelta {
  agent_delta(
    id="set-review-state:\{target_path}",
    kind=SetReviewState,
    target_path~,
    patches=[@core.set_string(target_path, review_state_id(state))],
  )
}

///|
pub fn plan_agent_deltas(deltas : Array[AgentDelta]) -> AgentDeltaPlan {
  plan_agent_deltas_with_budget(deltas, @core.default_patch_budget())
}

///|
pub fn plan_agent_deltas_with_budget(
  deltas : Array[AgentDelta],
  budget : @core.PatchBudget,
) -> AgentDeltaPlan {
  let patches : Array[@core.Patch] = []
  for delta in deltas {
    for patch in delta.patches {
      patches.push(patch)
    }
  }
  let patch_plan = @core.plan_patches_with_budget(patches, budget)
  {
    deltas,
    patch_plan,
    diagnostics: patch_plan.diagnostics,
    summary: "Bunnia agent delta plan: deltas=\{deltas.length()} patches=\{patch_plan.patches.length()} bytes=\{patch_plan.total_estimated_bytes} diagnostics=\{patch_plan.diagnostics.length()}",
  }
}

///|
pub fn agent_delta_kind_id(kind : AgentDeltaKind) -> String {
  match kind {
    AppendMessage => "append-message"
    AppendCommunication => "append-communication"
    AppendStreamChunk => "append-stream-chunk"
    SetRunStatus => "set-run-status"
    SetReviewState => "set-review-state"
  }
}

///|
fn agent_delta(
  id~ : String,
  kind~ : AgentDeltaKind,
  target_path~ : String,
  patches~ : Array[@core.Patch],
) -> AgentDelta {
  { id, kind, target_path, patches }
}

///|
fn message_json(item : Message) -> String {
  "{" +
  "\"id\":\"\{escape_json(item.id)}\"," +
  "\"actorId\":\"\{escape_json(item.actor_id)}\"," +
  "\"threadId\":\"\{escape_json(item.thread_id)}\"," +
  "\"text\":\"\{escape_json(item.text)}\"," +
  "\"artifactRef\":\"\{escape_json(item.artifact_ref)}\"," +
  "\"status\":\"\{run_status_id(item.status)}\"" +
  "}"
}

///|
fn communication_json(item : Communication) -> String {
  "{" +
  "\"id\":\"\{escape_json(item.id)}\"," +
  "\"threadId\":\"\{escape_json(item.thread_id)}\"," +
  "\"kind\":\"\{communication_kind_id(item.kind)}\"," +
  "\"fromActorId\":\"\{escape_json(item.from_actor_id)}\"," +
  "\"toActorId\":\"\{escape_json(item.to_actor_id)}\"," +
  "\"text\":\"\{escape_json(item.text)}\"," +
  "\"artifactRef\":\"\{escape_json(item.artifact_ref)}\"," +
  "\"timestamp\":\"\{escape_json(item.timestamp)}\"," +
  "\"status\":\"\{run_status_id(item.status)}\"," +
  "\"openMessage\":\"\{escape_json(item.open_message)}\"" +
  "}"
}

///|
fn escape_json(value : String) -> String {
  value
  .replace(old="\\", new="\\\\")
  .replace(old="\"", new="\\\"")
  .replace(old="\n", new="\\n")
  .to_string()
}
