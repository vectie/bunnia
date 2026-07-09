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
