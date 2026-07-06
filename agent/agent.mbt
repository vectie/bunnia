///|
pub(all) enum ActorKind {
  Human
  Agent
  System
} derive(Debug, Eq)

///|
pub(all) enum RunStatus {
  Idle
  Running
  WaitingReview
  Done
  Failed
  Cancelled
} derive(Debug, Eq)

///|
pub(all) enum ReviewState {
  NotRequired
  Pending
  Approved
  Rejected
  CancelledReview
} derive(Debug, Eq)

///|
pub struct Actor {
  id : String
  label : String
  kind : ActorKind
} derive(Debug, Eq)

///|
pub struct Message {
  id : String
  actor_id : String
  thread_id : String
  text : String
  artifact_ref : String
  status : RunStatus
} derive(Debug, Eq)

///|
pub struct ReviewAction {
  id : String
  label : String
  state : ReviewState
  approve_message : String
  reject_message : String
} derive(Debug, Eq)

///|
pub fn actor(id~ : String, label~ : String, kind? : ActorKind = Agent) -> Actor {
  { id, label, kind }
}

///|
pub fn message(
  id~ : String,
  actor_id~ : String,
  thread_id~ : String,
  text~ : String,
  artifact_ref? : String = "",
  status? : RunStatus = Done,
) -> Message {
  { id, actor_id, thread_id, text, artifact_ref, status }
}

///|
pub fn review_action(
  id~ : String,
  label~ : String,
  approve_message~ : String,
  reject_message~ : String,
  state? : ReviewState = Pending,
) -> ReviewAction {
  { id, label, state, approve_message, reject_message }
}

///|
pub fn message_row(item : Message) -> @core.Node {
  let attrs = [
    @core.class_name("bunnia-message \{run_status_class(item.status)}"),
    @core.data("message-id", item.id),
    @core.data("thread-id", item.thread_id),
    @core.data("actor-id", item.actor_id),
    @core.data("run-status", run_status_id(item.status)),
  ]
  @core.keyed(
    item.id,
    @core.view_with_attrs(attrs, [
      @core.text(item.text),
      artifact_badge(item.artifact_ref),
    ]),
  )
}

///|
pub fn message_feed(messages : Array[Message]) -> @core.Node {
  let rows : Array[@core.Node] = []
  for item in messages {
    rows.push(message_row(item))
  }
  @core.scroll_view(rows)
}

///|
pub fn review_controls(action : ReviewAction) -> @core.Node {
  @core.view_with_attrs(
    [
      @core.class_name("bunnia-review \{review_state_class(action.state)}"),
      @core.data("review-id", action.id),
      @core.data("review-state", review_state_id(action.state)),
    ],
    [
      @core.text(action.label),
      @core.button("Approve", action.approve_message),
      @core.button("Reject", action.reject_message),
    ],
  )
}

///|
fn artifact_badge(artifact_ref : String) -> @core.Node {
  if artifact_ref == "" {
    @core.view([])
  } else {
    @core.view_with_attrs(
      [
        @core.class_name("bunnia-artifact-link"),
        @core.data("artifact-ref", artifact_ref),
      ],
      [@core.text("artifact")],
    )
  }
}

///|
pub fn run_status_id(status : RunStatus) -> String {
  match status {
    Idle => "idle"
    Running => "running"
    WaitingReview => "waiting-review"
    Done => "done"
    Failed => "failed"
    Cancelled => "cancelled"
  }
}

///|
pub fn review_state_id(state : ReviewState) -> String {
  match state {
    NotRequired => "not-required"
    Pending => "pending"
    Approved => "approved"
    Rejected => "rejected"
    CancelledReview => "cancelled"
  }
}

///|
fn run_status_class(status : RunStatus) -> String {
  "bunnia-run-\{run_status_id(status)}"
}

///|
fn review_state_class(state : ReviewState) -> String {
  "bunnia-review-\{review_state_id(state)}"
}
