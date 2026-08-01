///|
fn demo_supervisor_setup() -> MiniTownSupervisorSetup {
  mini_town_supervisor_setup(
    state="draft",
    current_step="identity",
    draft=mini_town_supervisor_draft(
      profile_id="supervisor-profile-user-a",
      version=3,
      name="Ada's Steward",
      avatar_ref="avatar://otter-steward",
      archetype_id="operator",
      mission="Turn town signals into reviewed, useful work.",
      tone_id="clear",
      capability_ids=["research", "planning"],
      workspace_id="workspace-user-a",
      building_id="private-agent-lab",
      book_id="book-private-agent-lab",
    ),
    archetypes=[
      mini_town_setup_choice(
        id="operator",
        label="Operator",
        summary="Turns goals into bounded tasks.",
        selected=true,
      ),
      mini_town_setup_choice(
        id="researcher",
        label="Researcher",
        summary="Finds and compares evidence.",
      ),
      mini_town_setup_choice(
        id="maker",
        label="Maker",
        summary="Builds concrete deliverables.",
      ),
    ],
    tones=[
      mini_town_setup_choice(
        id="clear",
        label="Clear",
        summary="Direct, calm, and concise.",
        selected=true,
      ),
      mini_town_setup_choice(
        id="warm",
        label="Warm",
        summary="Friendly and encouraging.",
      ),
    ],
    capabilities=[
      mini_town_setup_choice(
        id="research",
        label="Research",
        summary="Gather evidence and sources.",
        selected=true,
      ),
      mini_town_setup_choice(
        id="planning",
        label="Planning",
        summary="Break missions into tasks.",
        selected=true,
      ),
      mini_town_setup_choice(
        id="drafting",
        label="Drafting",
        summary="Prepare reviewable artifacts.",
      ),
    ],
  )
}

///|
fn demo_supervisor_control() -> MiniTownSupervisorControl {
  mini_town_supervisor_control(
    agent_id="agent-supervisor-user-a",
    profile_id="supervisor-profile-user-a",
    name="Ada's Steward",
    avatar_ref="avatar://otter-steward",
    status="ready",
    child_count=3,
    child_limit=3,
  )
}

///|
fn demo_child_workers() -> Array[MiniTownChildWorker] {
  [
    mini_town_child_worker(
      agent_id="agent-worker-scout",
      supervisor_agent_id="agent-supervisor-user-a",
      name="Town Scout",
      task_id="task-market-scan",
      task_title="Compare public agent labs",
      run_id="run-market-scan",
      status="pending_provider",
    ),
    mini_town_child_worker(
      agent_id="agent-worker-editor",
      supervisor_agent_id="agent-supervisor-user-a",
      name="Book Editor",
      task_id="task-policy-review",
      task_title="Prepare policy answer for review",
      run_id="run-policy-review",
      status="running",
    ),
    mini_town_child_worker(
      agent_id="agent-worker-drafter",
      supervisor_agent_id="agent-supervisor-user-a",
      name="Draft Builder",
      task_id="task-private-lab-draft",
      task_title="Revise the private lab brief",
      run_id="run-private-lab-draft",
      status="failed",
    ),
  ]
}

///|
fn demo_acceptance_receipts() -> Array[MiniTownAcceptanceReceipt] {
  [
    mini_town_acceptance_receipt(
      id="receipt-policy-pending",
      submission_id="submission-policy-answer-v1",
      evidence_digest="sha256:policy-answer-v1",
      run_id="run-policy-review",
      artifact_ref="artifact://book-policy-hall",
      reviewer_name="Ada Builder",
      title="Policy answer proposal",
      summary="Bookkeeper is reviewing this proposal; it is not accepted memory yet.",
      status="pending",
      deep_link="review:review-policy-memory",
    ),
    mini_town_acceptance_receipt(
      id="receipt-market-accepted",
      submission_id="submission-market-scan-v1",
      evidence_digest="sha256:market-scan-v1",
      run_id="run-market-scan",
      artifact_ref="artifact://market-square",
      reviewer_name="Ada Builder",
      title="Market scan receipt",
      summary="Bookkeeper accepted the reviewed scan.",
      status="accepted",
      deep_link="run:run-market-scan",
    ),
    mini_town_acceptance_receipt(
      id="receipt-draft-rejected",
      submission_id="submission-private-lab-v1",
      evidence_digest="sha256:private-lab-v1",
      run_id="run-private-lab-draft",
      artifact_ref="artifact://book-private-agent-lab",
      reviewer_name="Ada Builder",
      title="Draft setup receipt",
      summary="Bookkeeper rejected this version; revise and retry the run.",
      status="rejected",
      deep_link="run:run-private-lab-draft",
    ),
  ]
}
