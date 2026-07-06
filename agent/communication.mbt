///|
pub(all) enum CommunicationKind {
  MessageEvent
  Handoff
  Broadcast
  ReviewRequest
  Approval
  ToolResult
  RecoveryNotice
} derive(Debug, Eq)

///|
pub struct Thread {
  id : String
  title : String
  owner_actor_id : String
  subject_ref : String
  status : RunStatus
} derive(Debug, Eq)

///|
pub struct Communication {
  id : String
  thread_id : String
  kind : CommunicationKind
  from_actor_id : String
  to_actor_id : String
  text : String
  artifact_ref : String
  timestamp : String
  status : RunStatus
  open_message : String
} derive(Debug, Eq)

///|
pub fn thread(
  id~ : String,
  title~ : String,
  owner_actor_id~ : String,
  subject_ref? : String = "",
  status? : RunStatus = Running,
) -> Thread {
  { id, title, owner_actor_id, subject_ref, status }
}

///|
pub fn communication(
  id~ : String,
  thread_id~ : String,
  kind~ : CommunicationKind,
  from_actor_id~ : String,
  to_actor_id? : String = "",
  text~ : String,
  artifact_ref? : String = "",
  timestamp? : String = "",
  status? : RunStatus = Done,
  open_message? : String = "",
) -> Communication {
  {
    id,
    thread_id,
    kind,
    from_actor_id,
    to_actor_id,
    text,
    artifact_ref,
    timestamp,
    status,
    open_message,
  }
}

///|
pub fn message_event(
  id~ : String,
  thread_id~ : String,
  from_actor_id~ : String,
  text~ : String,
  artifact_ref? : String = "",
  open_message? : String = "",
) -> Communication {
  communication(
    id~,
    thread_id~,
    kind=MessageEvent,
    from_actor_id~,
    text~,
    artifact_ref~,
    open_message~,
  )
}

///|
pub fn handoff(
  id~ : String,
  thread_id~ : String,
  from_actor_id~ : String,
  to_actor_id~ : String,
  text~ : String,
  open_message? : String = "",
) -> Communication {
  communication(
    id~,
    thread_id~,
    kind=Handoff,
    from_actor_id~,
    to_actor_id~,
    text~,
    open_message~,
  )
}

///|
pub fn broadcast(
  id~ : String,
  thread_id~ : String,
  from_actor_id~ : String,
  text~ : String,
  open_message? : String = "",
) -> Communication {
  communication(
    id~,
    thread_id~,
    kind=Broadcast,
    from_actor_id~,
    text~,
    open_message~,
  )
}

///|
pub fn review_request(
  id~ : String,
  thread_id~ : String,
  from_actor_id~ : String,
  to_actor_id~ : String,
  text~ : String,
  artifact_ref? : String = "",
  open_message? : String = "",
) -> Communication {
  communication(
    id~,
    thread_id~,
    kind=ReviewRequest,
    from_actor_id~,
    to_actor_id~,
    text~,
    artifact_ref~,
    status=WaitingReview,
    open_message~,
  )
}

///|
pub fn approval(
  id~ : String,
  thread_id~ : String,
  from_actor_id~ : String,
  to_actor_id~ : String,
  text~ : String,
  artifact_ref? : String = "",
  open_message? : String = "",
) -> Communication {
  communication(
    id~,
    thread_id~,
    kind=Approval,
    from_actor_id~,
    to_actor_id~,
    text~,
    artifact_ref~,
    status=Done,
    open_message~,
  )
}

///|
pub fn tool_result(
  id~ : String,
  thread_id~ : String,
  from_actor_id~ : String,
  text~ : String,
  artifact_ref~ : String,
  open_message? : String = "",
) -> Communication {
  communication(
    id~,
    thread_id~,
    kind=ToolResult,
    from_actor_id~,
    text~,
    artifact_ref~,
    open_message~,
  )
}

///|
pub fn recovery_notice(
  id~ : String,
  thread_id~ : String,
  from_actor_id~ : String,
  text~ : String,
  open_message? : String = "",
) -> Communication {
  communication(
    id~,
    thread_id~,
    kind=RecoveryNotice,
    from_actor_id~,
    text~,
    status=Failed,
    open_message~,
  )
}

///|
pub fn communication_kind_id(kind : CommunicationKind) -> String {
  match kind {
    MessageEvent => "message"
    Handoff => "handoff"
    Broadcast => "broadcast"
    ReviewRequest => "review-request"
    Approval => "approval"
    ToolResult => "tool-result"
    RecoveryNotice => "recovery-notice"
  }
}

///|
pub fn thread_card(input : Thread) -> @core.Node {
  @core.keyed(
    input.id,
    @core.view_with_attrs(
      [
        @core.class_name("bunnia-thread \{run_status_class(input.status)}"),
        @core.data("thread-id", input.id),
        @core.data("owner-actor-id", input.owner_actor_id),
        @core.data("subject-ref", input.subject_ref),
        @core.data("run-status", run_status_id(input.status)),
      ],
      [@core.text(input.title), subject_badge(input.subject_ref)],
    ),
  )
}

///|
pub fn communication_row(input : Communication) -> @core.Node {
  let events = if input.open_message == "" {
    []
  } else {
    [@core.tap(input.open_message)]
  }
  @core.keyed(
    input.id,
    @core.node(
      kind="view",
      attrs=[
        @core.class_name(
          "bunnia-communication bunnia-communication-\{communication_kind_id(input.kind)} \{run_status_class(input.status)}",
        ),
        @core.data("communication-id", input.id),
        @core.data("thread-id", input.thread_id),
        @core.data("communication-kind", communication_kind_id(input.kind)),
        @core.data("from-actor-id", input.from_actor_id),
        @core.data("to-actor-id", input.to_actor_id),
        @core.data("artifact-ref", input.artifact_ref),
        @core.data("timestamp", input.timestamp),
        @core.data("run-status", run_status_id(input.status)),
      ],
      events~,
      children=[@core.text(input.text), artifact_badge(input.artifact_ref)],
    ),
  )
}

///|
pub fn communication_trace(items : Array[Communication]) -> @core.Node {
  let rows : Array[@core.Node] = []
  for item in items {
    rows.push(communication_row(item))
  }
  @core.view_with_attrs([@core.class_name("bunnia-communication-trace")], rows)
}

///|
pub fn windowed_communication_trace(
  items : Array[Communication],
  total_count~ : Int,
  offset? : Int = 0,
) -> @core.Node {
  let rows : Array[@core.Node] = []
  for item in items {
    rows.push(communication_row(item))
  }
  @core.node(
    kind="view",
    attrs=[
      @core.class_name(
        "bunnia-communication-trace bunnia-communication-trace-windowed",
      ),
      @core.data("bunnia-list-mode", "windowed"),
      @core.data("total-count", total_count.to_string()),
      @core.data("visible-start", offset.to_string()),
      @core.data("visible-count", items.length().to_string()),
    ],
    children=rows,
    list_total_count=total_count,
    list_visible_count=items.length(),
  )
}

///|
fn subject_badge(subject_ref : String) -> @core.Node {
  if subject_ref == "" {
    @core.view([])
  } else {
    @core.view_with_attrs(
      [
        @core.class_name("bunnia-subject-link"),
        @core.data("subject-ref", subject_ref),
      ],
      [@core.text("subject")],
    )
  }
}
