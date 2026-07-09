///|
pub fn demo_projection() -> MiniTownProjection {
  {
    id: "moontown-miniapp",
    active_user_id: "user-a",
    organization_id: "org-a",
    active_tab_id: "realm",
    onboarding_completed: false,
    role_id: "builder",
    selected_building_id: "policy-hall",
    search_query: "agent",
    active_discovery_filter_id: "all",
    active_notification_channel_id: "all",
    active_ownership_filter_id: "all",
    reviewer_tools_open: false,
    users: [
      mini_town_user(id="user-a", name="Ada"),
      mini_town_user(id="user-b", name="Bo"),
    ],
    profile: mini_town_profile(
      user_id="user-a",
      display_name="Ada Builder",
      role_id="builder",
      avatar_ref="avatar://ada",
      consent_accepted=false,
      setup_completed=false,
    ),
    roles: demo_roles(),
    tabs: demo_tabs(),
    onboarding_steps: demo_onboarding_steps(),
    districts: demo_districts(),
    presence: demo_presence(),
    buildings: demo_buildings(),
    placements: demo_placements(),
    books: demo_books(),
    agents: [
      mini_town_agent(
        id="agent-policy-guide",
        name="Policy Guide",
        building_id="policy-hall",
        status="waiting-review",
      ),
      mini_town_agent(
        id="agent-map-curator",
        name="Map Curator",
        building_id="market-square",
        status="running",
      ),
      mini_town_agent(
        id="agent-builder",
        name="Builder",
        building_id="private-agent-lab",
        status="idle",
      ),
    ],
    messages: [
      mini_town_message(
        id="msg-welcome",
        actor_id="agent-policy-guide",
        thread_id="thread-policy-hall",
        text="Policy Hall can answer public review questions.",
      ),
      mini_town_message(
        id="msg-review",
        actor_id="agent-policy-guide",
        thread_id="thread-policy-hall",
        text="One accepted answer is waiting for book review.",
        status=@bunnia.run_waiting_review(),
      ),
      mini_town_message(
        id="msg-builder",
        actor_id="agent-builder",
        thread_id="thread-private-agent-lab",
        text="Create a private building, then publish it when ready.",
        status=@bunnia.run_running(),
      ),
    ],
    runs: demo_runs(),
    tool_results: demo_tool_results(),
    reviews: demo_reviews(),
    notifications: demo_notifications(),
    notification_channels: demo_notification_channels(),
    watches: demo_watches(),
    discovery_items: demo_discovery_items(),
    discovery_filters: demo_discovery_filters(),
    ownership_filters: demo_ownership_filters(),
    backend_steps: demo_backend_steps(),
    backend_cache_states: demo_backend_cache_states(),
    activity_items: demo_activity_items(),
    audit_events: demo_audit_events(),
    moderation_cases: demo_moderation_cases(),
  }
}

///|
fn demo_moderation_cases() -> Array[MiniTownModerationCase] {
  [
    mini_town_moderation_case(
      id="mod-policy-hall",
      building_id="policy-hall",
      reporter_id="user-a",
      target_ref="building:policy-hall",
      title="Policy Hall safety watch",
      summary="Reports and appeals stay reviewed.",
      status="watch",
      action_label="Appeal",
      action_message="appeal-moderation-case",
    ),
  ]
}

///|
fn demo_audit_events() -> Array[MiniTownAuditEvent] {
  [
    mini_town_audit_event(
      id="audit-policy-review",
      kind="review",
      title="Policy answer entered review",
      summary="Agent output is held until a reviewer accepts it into the book.",
      actor_id="agent-policy-guide",
      target_ref="run:run-policy-review",
      building_id="policy-hall",
      status="review",
      visibility="published",
      timestamp="2026-07-08T10:00:00Z",
    ),
    mini_town_audit_event(
      id="audit-team-share",
      kind="share",
      title="Team Studio shared with team",
      summary="Organization members can inspect this building before publication.",
      actor_id="user-a",
      target_ref="building:team-studio",
      building_id="team-studio",
      status="shared",
      visibility="shared_private",
      timestamp="2026-07-08T09:24:00Z",
    ),
    mini_town_audit_event(
      id="audit-private-draft",
      kind="create",
      title="Private Agent Lab drafted",
      summary="Private work stays owner-scoped until shared or published.",
      actor_id="user-a",
      target_ref="building:private-agent-lab",
      building_id="private-agent-lab",
      status="draft",
      visibility="private_draft",
      timestamp="2026-07-08T08:48:00Z",
    ),
    mini_town_audit_event(
      id="audit-published-agent-lab",
      kind="publish",
      title="Published Agent Lab approved",
      summary="This building is searchable and placeable from public town search.",
      actor_id="user-b",
      target_ref="building:published-agent-lab",
      building_id="published-agent-lab",
      status="stable",
      visibility="published",
      timestamp="2026-07-08T08:12:00Z",
    ),
  ]
}

///|
fn demo_reviews() -> Array[MiniTownReviewItem] {
  [
    mini_town_review_item(
      id="review-policy-memory",
      run_id="run-policy-review",
      building_id="policy-hall",
      book_id="book-policy-hall",
      title="Review policy answer",
      summary="Accept this answer into Policy Hall Book or reject it for more work.",
      artifact_ref="artifact://book-policy-hall",
      reviewer_id="user-a",
      status="pending",
      accepted_memory_delta=1,
      accept_message="accept-memory-review",
      reject_message="reject-memory-review",
    ),
  ]
}

///|
fn demo_runs() -> Array[MiniTownRun] {
  [
    mini_town_run(
      id="run-policy-review",
      agent_id="agent-policy-guide",
      building_id="policy-hall",
      book_id="book-policy-hall",
      thread_id="thread-policy-hall",
      title="Policy answer review",
      summary="Agent answer is waiting before it becomes public book memory.",
      status="review",
      review_required=true,
      artifact_ref="artifact://book-policy-hall",
    ),
    mini_town_run(
      id="run-market-scan",
      agent_id="agent-map-curator",
      building_id="market-square",
      book_id="book-market-square",
      thread_id="thread-market-square",
      title="Market placement scan",
      summary="Map Curator is finding published buildings that can be placed.",
      status="running",
      artifact_ref="artifact://market-square",
    ),
    mini_town_run(
      id="run-private-lab-draft",
      agent_id="agent-builder",
      building_id="private-agent-lab",
      book_id="book-private-agent-lab",
      thread_id="thread-private-agent-lab",
      title="Private lab setup",
      summary="Builder is preparing the private agent lab before publishing.",
      status="running",
      artifact_ref="artifact://book-private-agent-lab",
    ),
    mini_town_run(
      id="run-knowledge-sync",
      agent_id="agent-policy-guide",
      building_id="knowledge-house",
      book_id="book-knowledge-house",
      thread_id="thread-knowledge-house",
      title="Knowledge memory sync",
      summary="Accepted memories were synchronized into Knowledge House.",
      status="done",
      artifact_ref="artifact://book-knowledge-house",
    ),
  ]
}

///|
fn demo_tool_results() -> Array[MiniTownToolResult] {
  [
    mini_town_tool_result(
      id="tool-policy-summary",
      tool_name="book-summarizer",
      building_id="policy-hall",
      thread_id="thread-policy-hall",
      title="Policy source summary",
      summary="Summarized 9 public source notes for the pending policy answer.",
      artifact_ref="artifact://book-policy-hall-sources",
      status=@bunnia.run_waiting_review(),
      open_message="open-tool-policy-summary",
      acknowledge_message="ack-tool-result",
    ),
    mini_town_tool_result(
      id="tool-market-scan",
      tool_name="placement-scanner",
      building_id="market-square",
      thread_id="thread-market-square",
      title="Placement scan artifact",
      summary="Found reusable public buildings that can be pinned into the town map.",
      artifact_ref="artifact://market-square",
      status=@bunnia.run_running(),
      open_message="open-tool-market-scan",
      acknowledge_message="ack-tool-result",
    ),
  ]
}

///|
fn demo_books() -> Array[MiniTownBook] {
  [
    mini_town_book(
      id="book-policy-hall",
      building_id="policy-hall",
      title="Policy Hall Book",
      owner_id="system",
      visibility="published",
      summary="Accepted policy answers and public review records.",
      accepted_memory_count=12,
      pending_review_count=1,
      status="review",
    ),
    mini_town_book(
      id="book-policy-hall-sources",
      building_id="policy-hall",
      title="Policy Source Shelf",
      owner_id="system",
      visibility="published",
      summary="Public support sources used by Policy Hall answers.",
      accepted_memory_count=9,
      pending_review_count=0,
      status="stable",
    ),
    mini_town_book(
      id="book-private-agent-lab",
      building_id="private-agent-lab",
      title="Private Agent Lab Book",
      owner_id="user-a",
      visibility="private_draft",
      summary="Draft prompts, agent setup notes, and private memory.",
      accepted_memory_count=3,
      pending_review_count=2,
      status="draft",
    ),
    mini_town_book(
      id="book-team-studio",
      building_id="team-studio",
      title="Team Studio Book",
      owner_id="org-a",
      visibility="shared_private",
      summary="Organization planning notes and accepted team decisions.",
      accepted_memory_count=8,
      pending_review_count=0,
      status="shared",
    ),
    mini_town_book(
      id="book-market-square",
      building_id="market-square",
      title="Market Square Ledger",
      owner_id="system",
      visibility="published",
      summary="Published placement results, market scans, and public listings.",
      accepted_memory_count=20,
      pending_review_count=0,
      status="running",
    ),
    mini_town_book(
      id="book-knowledge-house",
      building_id="knowledge-house",
      title="Knowledge House Book",
      owner_id="system",
      visibility="published",
      summary="Public memory behind reusable building answers.",
      accepted_memory_count=36,
      pending_review_count=0,
      status="stable",
    ),
    mini_town_book(
      id="book-workshop-book",
      building_id="book-workshop",
      title="Book Workshop Ledger",
      owner_id="org-a",
      visibility="shared_private",
      summary="Team review queue for accepted memories before publication.",
      accepted_memory_count=14,
      pending_review_count=4,
      status="review",
    ),
    mini_town_book(
      id="book-published-agent-lab",
      building_id="published-agent-lab",
      title="Published Agent Lab Book",
      owner_id="user-b",
      visibility="published",
      summary="Public setup memory for a reusable agent lab.",
      accepted_memory_count=7,
      pending_review_count=0,
      status="stable",
    ),
  ]
}

///|
fn demo_activity_items() -> Array[MiniTownActivityItem] {
  [
    mini_town_activity_item(
      id="activity-review-policy",
      kind="run",
      title="Policy answer waiting for review",
      summary="Policy Guide produced an answer that can enter book memory.",
      actor_id="agent-policy-guide",
      target_ref="thread-policy-hall",
      building_id="policy-hall",
      status="review",
    ),
    mini_town_activity_item(
      id="activity-market-curator",
      kind="agent",
      title="Map Curator scanning published buildings",
      summary="Market Square is refreshing placeable agent buildings.",
      actor_id="agent-map-curator",
      target_ref="agent:agent-map-curator",
      building_id="market-square",
      status="running",
    ),
    mini_town_activity_item(
      id="activity-team-share",
      kind="share",
      title="Team Studio shared to the organization",
      summary="Shared private planning is visible to members only.",
      actor_id="user-a",
      target_ref="building:team-studio",
      building_id="team-studio",
      status="shared",
    ),
    mini_town_activity_item(
      id="activity-book-memory",
      kind="book",
      title="Knowledge House memory updated",
      summary="Accepted building answers are backed by durable books.",
      actor_id="system",
      target_ref="book:knowledge-house",
      building_id="knowledge-house",
      status="stable",
    ),
    mini_town_activity_item(
      id="activity-publish-agent-lab",
      kind="publish",
      title="Published Agent Lab is placeable",
      summary="A public agent lab can now be placed by other users.",
      actor_id="user-b",
      target_ref="building:published-agent-lab",
      building_id="published-agent-lab",
      status="stable",
    ),
  ]
}

///|
fn demo_discovery_items() -> Array[MiniTownDiscoveryItem] {
  [
    mini_town_discovery_item(
      id="discover-user-ada",
      kind="user",
      title="Ada Builder",
      summary="Creates private agent labs and publishes stable buildings.",
      target_ref="user:user-a",
      visibility="personal",
      status="stable",
    ),
    mini_town_discovery_item(
      id="discover-user-deep-cultivator",
      kind="user",
      title="Deep Cultivator",
      summary="Shares applied agent notes and building experiments.",
      target_ref="user:user-deep-cultivator",
      visibility="published",
      status="stable",
    ),
    mini_town_discovery_item(
      id="discover-user-gabriel",
      kind="user",
      title="Gabriel",
      summary="Follows market buildings and agent work reports.",
      target_ref="user:user-gabriel",
      visibility="published",
      status="stable",
    ),
    mini_town_discovery_item(
      id="discover-circle-ai-camp",
      kind="circle",
      title="AI Exploration Camp",
      summary="Public agent circle for AI walkers, demands, and product notes.",
      target_ref="circle:ai-exploration-camp",
      visibility="published",
      status="running",
    ),
    mini_town_discovery_item(
      id="discover-circle-enterprise-club",
      kind="circle",
      title="Enterprise Club",
      summary="Small shared agent circle for builders validating real use cases.",
      target_ref="circle:enterprise-club",
      visibility="published",
      status="shared",
    ),
    mini_town_discovery_item(
      id="discover-agent-policy",
      kind="agent",
      title="Policy Guide",
      summary="Agent for public review, policy answers, and book memory.",
      target_ref="agent:agent-policy-guide",
      visibility="published",
      status="review",
    ),
    mini_town_discovery_item(
      id="discover-book-knowledge",
      kind="book",
      title="Knowledge House Book",
      summary="Accepted memory behind public building answers.",
      target_ref="book:knowledge-house",
      visibility="published",
      status="stable",
    ),
    mini_town_discovery_item(
      id="discover-demand-review",
      kind="demand",
      title="Review Demand",
      summary="Human approval needed before agent output becomes memory.",
      target_ref="demand:review-council",
      visibility="published",
      status="review",
    ),
    mini_town_discovery_item(
      id="discover-product-agent-kit",
      kind="product",
      title="Agent Publishing Kit",
      summary="Reusable workflow kit for publishing reviewed agent buildings.",
      target_ref="product:agent-publishing-kit",
      visibility="published",
      status="stable",
    ),
    mini_town_discovery_item(
      id="discover-event-studio",
      kind="event",
      title="Team Studio Session",
      summary="Shared organization agent session for map and book planning.",
      target_ref="event:team-studio",
      visibility="published",
      status="shared",
    ),
    mini_town_discovery_item(
      id="discover-post-agent",
      kind="post",
      title="Agent Lab Field Note",
      summary="A public note about placing published agent buildings.",
      target_ref="post:published-agent-lab",
      visibility="published",
      status="stable",
    ),
  ]
}

///|
fn demo_discovery_filters() -> Array[MiniTownDiscoveryFilter] {
  [
    mini_town_discovery_filter(id="all", label="All", kind="all"),
    mini_town_discovery_filter(id="user", label="People", kind="user"),
    mini_town_discovery_filter(id="circle", label="Circles", kind="circle"),
    mini_town_discovery_filter(id="product", label="Products", kind="product"),
    mini_town_discovery_filter(id="demand", label="Demands", kind="demand"),
    mini_town_discovery_filter(id="event", label="Events", kind="event"),
    mini_town_discovery_filter(id="post", label="Posts", kind="post"),
    mini_town_discovery_filter(
      id="building",
      label="Buildings",
      kind="building",
    ),
    mini_town_discovery_filter(id="agent", label="Agents", kind="agent"),
    mini_town_discovery_filter(id="book", label="Books", kind="book"),
    mini_town_discovery_filter(
      id="placeable",
      label="Placeable",
      kind="building",
      placeable_only=true,
    ),
  ]
}

///|
fn demo_roles() -> Array[MiniTownRole] {
  [
    mini_town_role(
      id="builder",
      title="Town Builder",
      summary="Create buildings, agents, and private workspaces.",
      building_id="private-agent-lab",
    ),
    mini_town_role(
      id="creator",
      title="Creative Operator",
      summary="Publish useful products, prompts, and agent experiences.",
      building_id="market-square",
    ),
    mini_town_role(
      id="explorer",
      title="Knowledge Explorer",
      summary="Search public buildings and learn from shared books.",
      building_id="knowledge-house",
    ),
    mini_town_role(
      id="practitioner",
      title="AI Practitioner",
      summary="Route real demands through reviewable agent workflows.",
      building_id="review-council",
    ),
    mini_town_role(
      id="wanderer",
      title="Town Wanderer",
      summary="Browse the town before committing to a public role.",
      building_id="gateway",
    ),
  ]
}

///|
fn demo_tabs() -> Array[MiniTownTab] {
  [
    mini_town_tab(id="home", label="Home"),
    mini_town_tab(id="discover", label="Discover"),
    mini_town_tab(id="realm", label="Realm", map_surface=true),
    mini_town_tab(id="messages", label="Messages"),
    mini_town_tab(id="my", label="My"),
  ]
}

///|
fn demo_onboarding_steps() -> Array[MiniTownOnboardingStep] {
  [
    mini_town_onboarding_step(
      id="welcome",
      title="Enter Moontown",
      body="Start from the tile town map and let agents guide each building.",
      building_id="gateway",
    ),
    mini_town_onboarding_step(
      id="inspiration",
      title="Read the town pulse",
      body="Shared discoveries appear as activity around buildings and books.",
      building_id="knowledge-house",
    ),
    mini_town_onboarding_step(
      id="districts",
      title="Use feature districts",
      body="Markets, demands, events, and guides are real places on the map.",
      building_id="market-square",
    ),
    mini_town_onboarding_step(
      id="navigation",
      title="Realm is the map",
      body="The Realm tab always returns to this same full-screen town.",
      building_id="policy-hall",
    ),
  ]
}

///|
fn demo_districts() -> Array[MiniTownDistrict] {
  [
    mini_town_district(
      id="product-market",
      title="Product Market",
      feature_kind="market",
      building_id="market-square",
      summary="Published building and product showcase.",
      stat_label="products",
      stat_value="20",
      action_label="Browse",
      action_message="tab-discover",
      discovery_filter_id="product",
      search_query="product",
      accent="blue",
      status="running",
    ),
    mini_town_district(
      id="demand-hall",
      title="Demand Hall",
      feature_kind="demand",
      building_id="review-council",
      summary="Requests, reviews, and agent jobs.",
      stat_label="demands",
      stat_value="34",
      action_label="Review",
      action_message="tab-messages",
      discovery_filter_id="demand",
      search_query="review demand",
      accent="orange",
      status="review",
    ),
    mini_town_district(
      id="event-calendar",
      title="Event Calendar",
      feature_kind="event",
      building_id="team-studio",
      summary="Team and public town activities.",
      stat_label="events",
      stat_value="6",
      action_label="Join",
      action_message="tab-messages",
      discovery_filter_id="event",
      search_query="team event",
      accent="purple",
      status="shared",
    ),
    mini_town_district(
      id="city-guide",
      title="City Guide",
      feature_kind="guide",
      building_id="gateway",
      summary="Search, onboarding, and safe routing.",
      stat_label="guides",
      stat_value="4",
      action_label="Open",
      action_message="tab-home",
      discovery_filter_id="post",
      search_query="guide",
      accent="pink",
      status="stable",
    ),
    mini_town_district(
      id="opc-hub",
      title="Town Trust",
      feature_kind="credential",
      building_id="policy-hall",
      summary="Registration, policy, and public trust checks.",
      stat_label="checks",
      stat_value="8",
      action_label="Verify",
      action_message="tab-my",
      discovery_filter_id="all",
      search_query="trust policy",
      accent="green",
      status="stable",
    ),
  ]
}

///|
fn demo_presence() -> Array[MiniTownPresence] {
  [
    mini_town_presence(
      id="presence-ada",
      title="Ada Builder",
      subtitle="publishing a private lab",
      actor_kind="user",
      building_id="private-agent-lab",
      status="draft",
    ),
    mini_town_presence(
      id="presence-policy-guide",
      title="Policy Guide",
      subtitle="reviewing public memory",
      actor_kind="agent",
      building_id="policy-hall",
      status="review",
    ),
    mini_town_presence(
      id="presence-map-curator",
      title="Map Curator",
      subtitle="placing market signals",
      actor_kind="agent",
      building_id="market-square",
      status="running",
    ),
    mini_town_presence(
      id="presence-team-studio",
      title="Team Studio",
      subtitle="shared with org members",
      actor_kind="building",
      building_id="team-studio",
      status="shared",
    ),
  ]
}

///|
fn demo_notifications() -> Array[MiniTownNotification] {
  [
    mini_town_notification(
      id="notice-review",
      kind="review",
      title="Memory review needed",
      body="Policy Hall has an accepted answer waiting for book review.",
      target_ref="thread-policy-hall",
      building_id="policy-hall",
      action_label="Review",
      action_message="open-notice-review",
    ),
    mini_town_notification(
      id="notice-publish",
      kind="publish",
      title="Draft ready to publish",
      body="Private Agent Lab can be submitted after profile consent.",
      target_ref="building-private-agent-lab",
      building_id="private-agent-lab",
      action_label="Open Draft",
      action_message="open-notice-publish",
    ),
    mini_town_notification(
      id="notice-share",
      kind="share",
      title="Team building shared",
      body="Team Studio is visible to organization members.",
      target_ref="building-team-studio",
      building_id="team-studio",
      action_label="Open Team",
      action_message="open-notice-share",
      unread=false,
    ),
    mini_town_notification(
      id="notice-run",
      kind="agent-run",
      title="Agent work completed",
      body="Market placement scan finished with a placeable building suggestion.",
      target_ref="run-market-scan",
      building_id="market-square",
      action_label="Open Work",
      action_message="open-notice-run",
    ),
    mini_town_notification(
      id="notice-follow",
      kind="follow",
      title="Deep Cultivator followed your town",
      body="A new AI walker is watching your public building updates.",
      target_ref="user:user-deep-cultivator",
      building_id="",
      action_label="Open Walker",
      action_message="open-notice-follow",
    ),
    mini_town_notification(
      id="notice-interaction",
      kind="interaction",
      title="Enterprise Club replied",
      body="The circle left feedback on your team place.",
      target_ref="circle:enterprise-club",
      building_id="team-studio",
      action_label="Open Circle",
      action_message="open-notice-interaction",
    ),
    mini_town_notification(
      id="notice-subscribe",
      kind="subscription",
      title="Subscribe to town signals",
      body="Receive agent work, review, publish, and share notices through WeChat.",
      target_ref="subscription:wechat",
      building_id="gateway",
      action_label="Subscribe",
      action_message="request-subscription",
      requires_subscription=true,
      unread=false,
    ),
  ]
}

///|
fn demo_notification_channels() -> Array[MiniTownNotificationChannel] {
  [
    mini_town_notification_channel(id="all", label="All", kind="all"),
    mini_town_notification_channel(
      id="unread",
      label="Needs Review",
      kind="all",
      unread_only=true,
    ),
    mini_town_notification_channel(
      id="follow",
      label="Town Notices",
      kind="follow",
    ),
    mini_town_notification_channel(
      id="interaction",
      label="Interactions",
      kind="interaction",
    ),
    mini_town_notification_channel(
      id="agent",
      label="Agent Replies",
      kind="agent-run",
    ),
    mini_town_notification_channel(
      id="review",
      label="Needs Review",
      kind="review",
    ),
    mini_town_notification_channel(
      id="system",
      label="Town Notices",
      kind="subscription",
    ),
  ]
}

///|
fn demo_watches() -> Array[MiniTownWatch] {
  [
    mini_town_watch(
      id="watch-policy-hall",
      user_id="user-a",
      target_ref="building:policy-hall",
      title="Policy Hall",
      summary="Public review and book-memory updates are watched.",
      action_message="select-policy-hall",
    ),
  ]
}

///|
fn demo_ownership_filters() -> Array[MiniTownOwnershipFilter] {
  [
    mini_town_ownership_filter(id="all", label="All"),
    mini_town_ownership_filter(
      id="placements",
      label="Placed",
      kind="placement",
    ),
    mini_town_ownership_filter(
      id="drafts",
      label="Drafts",
      visibility="private_draft",
    ),
    mini_town_ownership_filter(
      id="published",
      label="Published",
      visibility="published",
    ),
    mini_town_ownership_filter(id="books", label="Books", kind="book"),
    mini_town_ownership_filter(id="agents", label="Agents", kind="agent"),
    mini_town_ownership_filter(id="watches", label="Watches", kind="watch"),
  ]
}

///|
fn demo_backend_steps() -> Array[MiniTownBackendStep] {
  [
    mini_town_backend_step(
      id="login",
      label="Dev Login",
      endpoint_id="dev-login",
      http_method="POST",
      path="/miniapp/auth/dev-login",
      summary="Create or reuse a local user profile and session.",
      status="ready",
    ),
    mini_town_backend_step(
      id="snapshot",
      label="Load Snapshot",
      endpoint_id="load-town-snapshot",
      http_method="GET",
      path="/miniapp/town/snapshot",
      summary="Pull scoped buildings, books, agents, runs, and reviews.",
      status="ready",
    ),
    mini_town_backend_step(
      id="ownership",
      label="Sync Ownership",
      endpoint_id="load-ownership-snapshot",
      http_method="GET",
      path="/miniapp/me/ownership",
      summary="Pull owned buildings, books, agents, placements, and alerts for My.",
      status="ready",
    ),
    mini_town_backend_step(
      id="message-center",
      label="Sync Messages",
      endpoint_id="load-message-center",
      http_method="GET",
      path="/miniapp/messages/center",
      summary="Pull a filtered, cursor-windowed mail stream for Messages.",
      status="ready",
    ),
    mini_town_backend_step(
      id="publish",
      label="Publish",
      endpoint_id="publish-private-building",
      http_method="POST",
      path="/miniapp/buildings/publish",
      summary="Move an owned draft into public discovery.",
      status="guarded",
    ),
    mini_town_backend_step(
      id="chat",
      label="Ask Agent",
      endpoint_id="ask-selected-building",
      http_method="POST",
      path="/miniapp/buildings/query",
      summary="Send a building question and record a reviewable run.",
      status="guarded",
    ),
    mini_town_backend_step(
      id="cancel-run",
      label="Cancel Run",
      endpoint_id="cancel-run",
      http_method="POST",
      path="/miniapp/runs/cancel",
      summary="Stop a running agent task without accepting output as memory.",
      status="guarded",
    ),
    mini_town_backend_step(
      id="retry-run",
      label="Retry Run",
      endpoint_id="retry-run",
      http_method="POST",
      path="/miniapp/runs/retry",
      summary="Restart a failed, rejected, or cancelled run with the same context.",
      status="guarded",
    ),
    mini_town_backend_step(
      id="ack-notification",
      label="Ack Notice",
      endpoint_id="ack-notification",
      http_method="POST",
      path="/miniapp/messages/ack",
      summary="Mark a follow, interaction, review, or run notice as handled.",
      status="ready",
    ),
    mini_town_backend_step(
      id="request-subscription",
      label="Subscribe",
      endpoint_id="request-subscription",
      http_method="POST",
      path="/miniapp/messages/subscribe",
      summary="Request WeChat subscription delivery for important town signals.",
      status="platform",
    ),
    mini_town_backend_step(
      id="discover-action",
      label="Discover Action",
      endpoint_id="discover-action",
      http_method="POST",
      path="/miniapp/discover/action",
      summary="Open, answer, join, or read a public discovery target with viewer-scoped audit.",
      status="ready",
    ),
    mini_town_backend_step(
      id="handoff-agent-work",
      label="Handoff",
      endpoint_id="handoff-agent-work",
      http_method="POST",
      path="/miniapp/agents/handoff",
      summary="Move work from one town agent to another while preserving building context.",
      status="guarded",
    ),
    mini_town_backend_step(
      id="admin-ops",
      label="Ops",
      endpoint_id="load-admin-ops",
      http_method="GET",
      path="/miniapp/admin/ops",
      summary="Reviewer-only town counts, checks, incidents, holds, retention, and recovery status.",
      status="review",
    ),
    mini_town_backend_step(
      id="admin-readiness",
      label="Readiness",
      endpoint_id="load-admin-readiness",
      http_method="GET",
      path="/miniapp/admin/readiness",
      summary="Production checklist for WeChat login, domain, storage, monitoring, reviewers, and secrets.",
      status="guarded",
    ),
  ]
}

///|
fn demo_backend_cache_states() -> Array[MiniTownBackendCacheState] {
  [
    mini_town_backend_cache_state(
      id="session",
      label="Session",
      source="local",
      state="empty",
      summary="Dev login sets local session headers.",
      target_ref="backend:dev-login",
      action_label="Login",
      action_message="dev-login",
    ),
    mini_town_backend_cache_state(
      id="snapshot",
      label="Town Snapshot",
      source="cache",
      state="stale-safe",
      summary="Stale town remains visible on reload failure.",
      target_ref="backend:load-town-snapshot",
      action_label="Reload",
      action_message="load-town-snapshot",
    ),
    mini_town_backend_cache_state(
      id="ownership",
      label="Ownership Snapshot",
      source="cache",
      state="idle",
      summary="My reloads owned places, books, agents, pins, and alerts.",
      target_ref="backend:load-ownership-snapshot",
      action_label="Sync",
      action_message="load-ownership-snapshot",
    ),
    mini_town_backend_cache_state(
      id="mutations",
      label="Mutation Queue",
      source="request-log",
      state="idle",
      summary="Town actions keep retry payloads.",
      target_ref="backend:mutations",
      action_label="Open My",
      action_message="tab-my",
    ),
    mini_town_backend_cache_state(
      id="reviews",
      label="Review Result",
      source="run-log",
      state="pending",
      summary="Agent answers wait for book-memory review.",
      target_ref="review:memory",
      action_label="Review",
      action_message="tab-messages",
    ),
  ]
}

///|
pub fn local_backend_base_url() -> String {
  "http://127.0.0.1:18191"
}

///|
fn demo_buildings() -> Array[MiniTownBuilding] {
  [
    mini_town_building(
      id="policy-hall",
      title="Policy Hall",
      kind="policy_hall",
      visibility="published",
      owner_id="system",
      summary="Public policy answers and review routing.",
      tags=["policy", "review", "public"],
      x=479,
      y=388,
      status="review",
    ),
    mini_town_building(
      id="private-agent-lab",
      title="Private Agent Lab",
      kind="agent_lab",
      visibility="private_draft",
      owner_id="user-a",
      summary="Draft agent creation space visible only to Ada.",
      tags=["agent", "private", "draft"],
      x=432,
      y=513,
      status="draft",
    ),
    mini_town_building(
      id="team-studio",
      title="Team Studio",
      kind="project_studio",
      visibility="shared_private",
      owner_id="org-a",
      summary="Organization planning room shared by members.",
      tags=["team", "project", "shared"],
      x=462,
      y=468,
      status="shared",
    ),
    mini_town_building(
      id="market-square",
      title="Market Square",
      kind="market_square",
      visibility="published",
      owner_id="system",
      summary="Published buildings can be searched and placed.",
      tags=["market", "public", "search"],
      x=530,
      y=592,
      status="running",
    ),
    mini_town_building(
      id="review-council",
      title="Review Council",
      kind="review_council",
      visibility="published",
      owner_id="system",
      summary="Moderation and publishing decisions happen here.",
      tags=["review", "publish", "moderation"],
      x=462,
      y=341,
      status="review",
    ),
    mini_town_building(
      id="knowledge-house",
      title="Knowledge House",
      kind="knowledge_house",
      visibility="published",
      owner_id="system",
      summary="Book-backed accepted memory for public queries.",
      tags=["book", "memory", "public"],
      x=518,
      y=430,
      status="stable",
    ),
    mini_town_building(
      id="gateway",
      title="Town Gate",
      kind="system_gateway",
      visibility="published",
      owner_id="system",
      summary="Sign-in and safe town handoff.",
      tags=["system", "login", "session"],
      x=696,
      y=556,
      status="stable",
    ),
    mini_town_building(
      id="book-workshop",
      title="Book Workshop",
      kind="knowledge_house",
      visibility="shared_private",
      owner_id="org-a",
      summary="Team book review queue for accepted memories.",
      tags=["book", "team", "review"],
      x=662,
      y=415,
      status="shared",
    ),
    mini_town_building(
      id="draft-observatory",
      title="Draft Observatory",
      kind="custom",
      visibility="private_draft",
      owner_id="user-b",
      summary="Bo's hidden draft should not appear for Ada.",
      tags=["hidden", "private"],
      x=535,
      y=347,
      status="hidden",
    ),
    mini_town_building(
      id="published-agent-lab",
      title="Published Agent Lab",
      kind="agent_lab",
      visibility="published",
      owner_id="user-b",
      summary="A public agent lab Ada can place on her map.",
      tags=["agent", "public", "place"],
      x=538,
      y=528,
      status="stable",
    ),
  ]
}

///|
fn demo_placements() -> Array[MiniTownPlacement] {
  [
    mini_town_placement(
      id="placement-user-a-policy-hall",
      building_id="policy-hall",
      owner_id="user-a",
      layer="personal",
      x=479,
      y=388,
      status="pinned",
      source="starter-map",
    ),
  ]
}
