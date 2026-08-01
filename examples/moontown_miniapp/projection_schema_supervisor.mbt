///|
pub struct MiniTownSetupChoice {
  id : String
  label : String
  summary : String
  selected : Bool
} derive(Debug, Eq)

///|
pub struct MiniTownSupervisorDraft {
  profile_id : String
  version : Int
  name : String
  avatar_ref : String
  archetype_id : String
  mission : String
  tone_id : String
  capability_ids : Array[String]
  workspace_id : String
  building_id : String
  book_id : String
  consent_agent_control : Bool
  consent_bookkeeper_review : Bool
  consent_terms : Bool
  terms_version : String
} derive(Debug, Eq)

///|
pub struct MiniTownSupervisorSetup {
  state : String
  current_step : String
  draft : MiniTownSupervisorDraft
  archetypes : Array[MiniTownSetupChoice]
  tones : Array[MiniTownSetupChoice]
  capabilities : Array[MiniTownSetupChoice]
  ready : Bool
  activated : Bool
  runtime_status : String
  bookkeeper_status : String
} derive(Debug, Eq)

///|
pub struct MiniTownSupervisorControl {
  agent_id : String
  profile_id : String
  name : String
  avatar_ref : String
  status : String
  controllable : Bool
  child_count : Int
  child_limit : Int
} derive(Debug, Eq)

///|
pub struct MiniTownChildWorker {
  agent_id : String
  supervisor_agent_id : String
  name : String
  task_id : String
  task_title : String
  run_id : String
  status : String
} derive(Debug, Eq)

///|
pub struct MiniTownAcceptanceReceipt {
  id : String
  submission_id : String
  evidence_digest : String
  run_id : String
  artifact_ref : String
  reviewer_name : String
  title : String
  summary : String
  status : String
  deep_link : String
} derive(Debug, Eq)

///|
pub fn mini_town_setup_choice(
  id~ : String,
  label~ : String,
  summary~ : String,
  selected? : Bool = false,
) -> MiniTownSetupChoice {
  { id, label, summary, selected }
}

///|
pub fn mini_town_supervisor_draft(
  profile_id~ : String,
  version~ : Int,
  name~ : String,
  avatar_ref~ : String,
  archetype_id~ : String,
  mission~ : String,
  tone_id~ : String,
  capability_ids~ : Array[String],
  workspace_id~ : String,
  building_id~ : String,
  book_id~ : String,
  consent_agent_control? : Bool = false,
  consent_bookkeeper_review? : Bool = false,
  consent_terms? : Bool = false,
  terms_version? : String = "2026-08",
) -> MiniTownSupervisorDraft {
  {
    profile_id,
    version,
    name,
    avatar_ref,
    archetype_id,
    mission,
    tone_id,
    capability_ids,
    workspace_id,
    building_id,
    book_id,
    consent_agent_control,
    consent_bookkeeper_review,
    consent_terms,
    terms_version,
  }
}

///|
pub fn mini_town_supervisor_setup(
  state~ : String,
  current_step~ : String,
  draft~ : MiniTownSupervisorDraft,
  archetypes~ : Array[MiniTownSetupChoice],
  tones~ : Array[MiniTownSetupChoice],
  capabilities~ : Array[MiniTownSetupChoice],
  ready? : Bool = false,
  activated? : Bool = false,
  runtime_status? : String = "not_started",
  bookkeeper_status? : String = "not_requested",
) -> MiniTownSupervisorSetup {
  {
    state,
    current_step,
    draft,
    archetypes,
    tones,
    capabilities,
    ready,
    activated,
    runtime_status,
    bookkeeper_status,
  }
}

///|
pub fn mini_town_supervisor_control(
  agent_id~ : String,
  profile_id~ : String,
  name~ : String,
  avatar_ref~ : String,
  status~ : String,
  controllable? : Bool = true,
  child_count? : Int = 0,
  child_limit? : Int = 3,
) -> MiniTownSupervisorControl {
  {
    agent_id,
    profile_id,
    name,
    avatar_ref,
    status,
    controllable,
    child_count,
    child_limit,
  }
}

///|
pub fn mini_town_child_worker(
  agent_id~ : String,
  supervisor_agent_id~ : String,
  name~ : String,
  task_id~ : String,
  task_title~ : String,
  run_id~ : String,
  status~ : String,
) -> MiniTownChildWorker {
  { agent_id, supervisor_agent_id, name, task_id, task_title, run_id, status }
}

///|
pub fn mini_town_acceptance_receipt(
  id~ : String,
  submission_id~ : String,
  evidence_digest~ : String,
  run_id~ : String,
  artifact_ref~ : String,
  reviewer_name~ : String,
  title~ : String,
  summary~ : String,
  status~ : String,
  deep_link~ : String,
) -> MiniTownAcceptanceReceipt {
  {
    id,
    submission_id,
    evidence_digest,
    run_id,
    artifact_ref,
    reviewer_name,
    title,
    summary,
    status,
    deep_link,
  }
}
