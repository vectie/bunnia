///|
pub fn demo_patch_plan() -> @bunnia.PatchPlan {
  @bunnia.plan_patches([
    @bunnia.set_string("town.selectedBuildingId", "published-agent-lab"),
    @bunnia.select_scene_marker("moontown-map", "published-agent-lab"),
    @bunnia.append_json(
      "chat.messages", "{\"id\":\"msg-mock-answer\",\"text\":\"Mock answer.\"}",
    ),
  ])
}

///|
pub fn demo_snapshot_delta_plan() -> @bunnia.SnapshotDeltaPlan {
  @bunnia.plan_snapshot_deltas([
    @bunnia.set_snapshot_section_delta(
      "moontown-miniapp", "selectedBuildingId", "\"policy-hall\"",
    ),
    @bunnia.append_snapshot_item_delta(
      "moontown-miniapp", "buildings", "created-agent-lab", "{\"id\":\"created-agent-lab\",\"visibility\":\"private_draft\"}",
    ),
    @bunnia.append_snapshot_item_delta(
      "moontown-miniapp", "messages", "msg-mock-answer", "{\"id\":\"msg-mock-answer\",\"status\":\"waiting-review\"}",
    ),
  ])
}

///|
pub fn demo_agent_delta_plan() -> @bunnia.AgentDeltaPlan {
  @bunnia.plan_agent_deltas([
    @bunnia.append_message_delta(
      "chat.messages",
      @bunnia.message(
        id="msg-mock-answer",
        actor_id="agent-policy-guide",
        thread_id="thread-policy-hall",
        text="Mock answer recorded as a run waiting for review.",
        status=@bunnia.run_waiting_review(),
      ),
    ),
    @bunnia.set_run_status_delta(
      "runs.activeRunStatus",
      @bunnia.run_waiting_review(),
    ),
  ])
}

///|
pub fn demo_communication_plan() -> @bunnia.CommunicationPlan {
  @bunnia.plan_communications_with_budget(
    demo_communications(demo_projection()),
    @bunnia.communication_budget(max_visible_count=8),
  )
}

///|
pub fn demo_backend_contract() -> @bunnia.BackendContract {
  @bunnia.backend_contract(
    id="moontown-miniapp-backend",
    session_token_key="bunniaSessionId",
    session_header_key="x-miniapp-session",
    endpoints=[
      @bunnia.snapshot_load_endpoint(
        "load-town-snapshot", "/miniapp/town/snapshot", "townSnapshot",
      ),
      @bunnia.generic_endpoint(
        "load-ownership-snapshot",
        "/miniapp/me/ownership",
        @bunnia.http_get(),
        payload_key="ownershipQuery",
        response_key="ownershipSnapshot",
      ),
      @bunnia.generic_endpoint(
        "load-message-center",
        "/miniapp/messages/center",
        @bunnia.http_get(),
        payload_key="messageCenterQuery",
        response_key="messageCenterSnapshot",
      ),
      @bunnia.generic_endpoint(
        "dev-login",
        "/miniapp/auth/dev-login",
        @bunnia.http_post(),
        payload_key="login",
        response_key="loginResult",
      ),
      @bunnia.operator_submit_endpoint(
        "save-profile", "/miniapp/me/profile", "profileDraft", "profileResult",
      ),
      @bunnia.generic_endpoint(
        "discover-search",
        "/miniapp/discover/search",
        @bunnia.http_get(),
        payload_key="discoverSearch",
        response_key="discoverSearchResult",
      ),
      @bunnia.generic_endpoint(
        "discover-action",
        "/miniapp/discover/action",
        @bunnia.http_post(),
        payload_key="discoverAction",
        response_key="discoveryActionResult",
      ),
      @bunnia.operator_submit_endpoint(
        "create-private-building", "/miniapp/buildings", "buildingDraft", "buildingResult",
      ),
      @bunnia.generic_endpoint(
        "update-private-building",
        "/miniapp/buildings/update",
        @bunnia.http_post(),
        payload_key="buildingEditDraft",
        response_key="buildingEditResult",
      ),
      @bunnia.operator_submit_endpoint(
        "place-published-building", "/miniapp/buildings/place", "placementDraft",
        "placementResult",
      ),
      @bunnia.operator_submit_endpoint(
        "share-private-building", "/miniapp/buildings/share", "shareDraft", "shareResult",
      ),
      @bunnia.operator_submit_endpoint(
        "submit-private-building", "/miniapp/buildings/submit", "submitDraft", "submitResult",
      ),
      @bunnia.operator_submit_endpoint(
        "publish-private-building", "/miniapp/buildings/publish", "publishDraft",
        "publishResult",
      ),
      @bunnia.operator_submit_endpoint(
        "archive-private-building", "/miniapp/buildings/archive", "archiveDraft",
        "archiveResult",
      ),
      @bunnia.operator_submit_endpoint(
        "restore-archived-building", "/miniapp/buildings/restore", "restoreDraft",
        "restoreResult",
      ),
      @bunnia.agent_message_endpoint(
        "ask-selected-building", "/miniapp/buildings/query", "buildingQuestion",
        "queryResult",
      ),
      @bunnia.agent_message_endpoint(
        "send-building-message", "/miniapp/messages/send", "chatDraft", "chatResult",
      ),
      @bunnia.handoff_submit_endpoint(
        "handoff-agent-work", "/miniapp/agents/handoff", "handoffDraft", "handoffResult",
      ),
      @bunnia.agent_cancel_endpoint(
        "cancel-run", "/miniapp/runs/cancel", "runCancel", "cancelResult",
      ),
      @bunnia.agent_retry_endpoint(
        "retry-run", "/miniapp/runs/retry", "runRetry", "retryResult",
      ),
      @bunnia.review_decision_endpoint(
        "accept-memory-review", "/miniapp/reviews/accept", "reviewDecision", "reviewResult",
      ),
      @bunnia.review_decision_endpoint(
        "reject-memory-review", "/miniapp/reviews/reject", "reviewDecision", "reviewResult",
      ),
      @bunnia.operator_submit_endpoint(
        "ack-notification", "/miniapp/messages/ack", "notificationAck", "notificationAckResult",
      ),
      @bunnia.operator_submit_endpoint(
        "ack-tool-result", "/miniapp/tool-results/ack", "toolResultAck", "toolResultAckResult",
      ),
      @bunnia.operator_submit_endpoint(
        "request-subscription", "/miniapp/messages/subscribe", "subscriptionRequest",
        "subscriptionResult",
      ),
      @bunnia.operator_submit_endpoint(
        "create-agent", "/miniapp/agents", "agentDraft", "agentResult",
      ),
      @bunnia.generic_endpoint(
        "report-public-building",
        "/miniapp/moderation/report",
        @bunnia.http_post(),
        payload_key="reportDraft",
        response_key="reportResult",
      ),
      @bunnia.generic_endpoint(
        "hide-public-building",
        "/miniapp/moderation/hide",
        @bunnia.http_post(),
        payload_key="moderationHide",
        response_key="moderationHideResult",
      ),
      @bunnia.generic_endpoint(
        "takedown-public-building",
        "/miniapp/moderation/takedown",
        @bunnia.http_post(),
        payload_key="moderationTakedown",
        response_key="moderationTakedownResult",
      ),
      @bunnia.generic_endpoint(
        "appeal-moderation-case",
        "/miniapp/moderation/appeal",
        @bunnia.http_post(),
        payload_key="moderationAppeal",
        response_key="moderationAppealResult",
      ),
      @bunnia.generic_endpoint(
        "load-admin-ops",
        "/miniapp/admin/ops",
        @bunnia.http_get(),
        payload_key="adminOpsQuery",
        response_key="adminOpsResult",
      ),
      @bunnia.generic_endpoint(
        "load-admin-readiness",
        "/miniapp/admin/readiness",
        @bunnia.http_get(),
        payload_key="adminReadinessQuery",
        response_key="adminReadinessResult",
      ),
    ],
  )
}

///|
pub fn demo_backend_budget() -> @bunnia.BackendBudget {
  @bunnia.backend_budget(
    max_endpoints=32,
    max_streaming=4,
    max_review_required=18,
  )
}

///|
pub fn demo_backend_plan() -> @bunnia.BackendPlan {
  @bunnia.plan_backend_contract_with_budget(
    demo_backend_contract(),
    demo_backend_budget(),
  )
}

///|
pub fn demo_effect_plan() -> @bunnia.EffectPlan {
  @bunnia.plan_backend_effects_for_platform(
    demo_backend_contract(),
    @bunnia.wechat(),
  )
}

///|
pub fn demo_tool_result_plan() -> @bunnia.ToolResultPlan {
  @bunnia.plan_tool_result_cards_with_budget(
    tool_result_cards(demo_projection()),
    @bunnia.tool_result_budget(max_visible_count=8),
  )
}

///|
