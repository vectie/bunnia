///|
pub struct MiniTownAgent {
  id : String
  name : String
  building_id : String
  status : String
} derive(Debug, Eq)

///|
pub struct MiniTownMessage {
  id : String
  actor_id : String
  thread_id : String
  text : String
  status : @bunnia.RunStatus
} derive(Debug, Eq)

///|
pub struct MiniTownRun {
  id : String
  agent_id : String
  building_id : String
  book_id : String
  thread_id : String
  title : String
  summary : String
  status : String
  review_required : Bool
  artifact_ref : String
} derive(Debug, Eq)

///|
pub struct MiniTownToolResult {
  id : String
  tool_name : String
  building_id : String
  thread_id : String
  title : String
  summary : String
  artifact_ref : String
  status : @bunnia.RunStatus
  open_message : String
  acknowledge_message : String
} derive(Debug, Eq)

///|
pub struct MiniTownReviewItem {
  id : String
  run_id : String
  building_id : String
  book_id : String
  title : String
  summary : String
  artifact_ref : String
  reviewer_id : String
  status : String
  accepted_memory_delta : Int
  accept_message : String
  reject_message : String
} derive(Debug, Eq)

///|
pub fn mini_town_agent(
  id~ : String,
  name~ : String,
  building_id~ : String,
  status~ : String,
) -> MiniTownAgent {
  { id, name, building_id, status }
}

///|
pub fn mini_town_message(
  id~ : String,
  actor_id~ : String,
  thread_id~ : String,
  text~ : String,
  status? : @bunnia.RunStatus = @bunnia.run_done(),
) -> MiniTownMessage {
  { id, actor_id, thread_id, text, status }
}

///|
pub fn mini_town_run(
  id~ : String,
  agent_id~ : String,
  building_id~ : String,
  book_id~ : String,
  thread_id~ : String,
  title~ : String,
  summary~ : String,
  status~ : String,
  review_required? : Bool = false,
  artifact_ref? : String = "",
) -> MiniTownRun {
  {
    id,
    agent_id,
    building_id,
    book_id,
    thread_id,
    title,
    summary,
    status,
    review_required,
    artifact_ref,
  }
}

///|
pub fn mini_town_tool_result(
  id~ : String,
  tool_name~ : String,
  building_id~ : String,
  thread_id~ : String,
  title~ : String,
  summary~ : String,
  artifact_ref~ : String,
  status? : @bunnia.RunStatus = @bunnia.run_done(),
  open_message? : String = "",
  acknowledge_message? : String = "",
) -> MiniTownToolResult {
  {
    id,
    tool_name,
    building_id,
    thread_id,
    title,
    summary,
    artifact_ref,
    status,
    open_message,
    acknowledge_message,
  }
}

///|
pub fn mini_town_review_item(
  id~ : String,
  run_id~ : String,
  building_id~ : String,
  book_id~ : String,
  title~ : String,
  summary~ : String,
  artifact_ref~ : String,
  reviewer_id~ : String,
  status~ : String,
  accepted_memory_delta? : Int = 1,
  accept_message? : String = "accept-memory-review",
  reject_message? : String = "reject-memory-review",
) -> MiniTownReviewItem {
  {
    id,
    run_id,
    building_id,
    book_id,
    title,
    summary,
    artifact_ref,
    reviewer_id,
    status,
    accepted_memory_delta,
    accept_message,
    reject_message,
  }
}
