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
