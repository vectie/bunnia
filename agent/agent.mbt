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
  FailedReview
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
pub struct ToolResultCard {
  id : String
  tool_name : String
  title : String
  summary : String
  artifact_ref : String
  status : RunStatus
  open_message : String
  acknowledge_message : String
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
pub fn tool_result_card(
  id~ : String,
  tool_name~ : String,
  title~ : String,
  summary~ : String,
  artifact_ref? : String = "",
  status? : RunStatus = Done,
  open_message? : String = "",
  acknowledge_message? : String = "",
) -> ToolResultCard {
  {
    id,
    tool_name,
    title,
    summary,
    artifact_ref,
    status,
    open_message,
    acknowledge_message,
  }
}

///|
pub fn review_action_enabled(action : ReviewAction) -> Bool {
  action.state is Pending
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
  @core.node(
    kind="scroll-view",
    attrs=[@core.class_name("bunnia-message-feed")],
    children=rows,
  )
}

///|
pub fn windowed_message_feed(
  messages : Array[Message],
  total_count~ : Int,
  offset? : Int = 0,
) -> @core.Node {
  let rows : Array[@core.Node] = []
  for item in messages {
    rows.push(message_row(item))
  }
  @core.node(
    kind="scroll-view",
    attrs=[
      @core.class_name("bunnia-message-feed bunnia-message-feed-windowed"),
      @core.data("bunnia-list-mode", "windowed"),
      @core.data("total-count", total_count.to_string()),
      @core.data("visible-start", offset.to_string()),
      @core.data("visible-count", messages.length().to_string()),
    ],
    children=rows,
    list_total_count=total_count,
    list_visible_count=messages.length(),
  )
}

///|
pub fn tool_result_card_view(card : ToolResultCard) -> @core.Node {
  @core.keyed(
    card.id,
    @core.view_with_attrs(
      [
        @core.class_name(
          "bunnia-tool-result-card \{run_status_class(card.status)}",
        ),
        @core.data("tool-result-id", card.id),
        @core.data("tool-name", card.tool_name),
        @core.data("artifact-ref", card.artifact_ref),
        @core.data("run-status", run_status_id(card.status)),
      ],
      [
        @core.text(card.title),
        @core.text(card.summary),
        artifact_badge(card.artifact_ref),
        tool_result_action("Open", card.open_message),
        tool_result_action("Acknowledge", card.acknowledge_message),
      ],
    ),
  )
}

///|
pub fn tool_result_card_list(cards : Array[ToolResultCard]) -> @core.Node {
  let rows : Array[@core.Node] = []
  for card in cards {
    rows.push(tool_result_card_view(card))
  }
  @core.view_with_attrs([@core.class_name("bunnia-tool-result-list")], rows)
}

///|
pub fn windowed_tool_result_card_list(
  cards : Array[ToolResultCard],
  total_count~ : Int,
  offset? : Int = 0,
) -> @core.Node {
  let rows : Array[@core.Node] = []
  for card in cards {
    rows.push(tool_result_card_view(card))
  }
  @core.node(
    kind="view",
    attrs=[
      @core.class_name(
        "bunnia-tool-result-list bunnia-tool-result-list-windowed",
      ),
      @core.data("bunnia-list-mode", "windowed"),
      @core.data("total-count", total_count.to_string()),
      @core.data("visible-start", offset.to_string()),
      @core.data("visible-count", cards.length().to_string()),
    ],
    children=rows,
    list_total_count=total_count,
    list_visible_count=cards.length(),
  )
}

///|
pub fn review_controls(action : ReviewAction) -> @core.Node {
  let enabled = review_action_enabled(action)
  @core.view_with_attrs(
    [
      @core.class_name("bunnia-review \{review_state_class(action.state)}"),
      @core.data("review-id", action.id),
      @core.data("review-state", review_state_id(action.state)),
      @core.data("review-enabled", enabled.to_string()),
    ],
    [
      @core.text(action.label),
      review_button("Approve", action.approve_message, enabled),
      review_button("Reject", action.reject_message, enabled),
    ],
  )
}

///|
fn tool_result_action(label : String, message : String) -> @core.Node {
  if message == "" {
    @core.view([])
  } else {
    @core.node(
      kind="button",
      attrs=[@core.class_name("bunnia-tool-result-action")],
      events=[@core.tap(message)],
      children=[@core.text(label)],
    )
  }
}

///|
fn review_button(
  label : String,
  message : String,
  enabled : Bool,
) -> @core.Node {
  let attrs = [
    @core.class_name(
      "bunnia-review-button \{review_button_disabled_class(enabled)}",
    ),
  ]
  if !enabled {
    attrs.push(@core.attr("disabled", "true"))
    attrs.push(@core.data("disabled", "true"))
  }
  let events = if enabled { [@core.tap(message)] } else { [] }
  @core.node(kind="button", attrs~, events~, children=[@core.text(label)])
}

///|
fn review_button_disabled_class(enabled : Bool) -> String {
  if enabled {
    "bunnia-review-button-enabled"
  } else {
    "bunnia-review-button-disabled"
  }
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
    FailedReview => "failed"
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
