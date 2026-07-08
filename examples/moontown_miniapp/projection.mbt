///|
pub struct MiniTownUser {
  id : String
  name : String
} derive(Debug, Eq)

///|
pub struct MiniTownProfile {
  user_id : String
  display_name : String
  role_id : String
  avatar_ref : String
  consent_accepted : Bool
  setup_completed : Bool
} derive(Debug, Eq)

///|
pub struct MiniTownRole {
  id : String
  title : String
  summary : String
  building_id : String
} derive(Debug, Eq)

///|
pub struct MiniTownBuilding {
  id : String
  title : String
  kind : String
  visibility : String
  owner_id : String
  summary : String
  tags : Array[String]
  x : Int
  y : Int
  status : String
  asset_ref : String
} derive(Debug, Eq)

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
pub struct MiniTownTab {
  id : String
  label : String
  map_surface : Bool
} derive(Debug, Eq)

///|
pub struct MiniTownOnboardingStep {
  id : String
  title : String
  body : String
  building_id : String
} derive(Debug, Eq)

///|
pub struct MiniTownDistrict {
  id : String
  title : String
  building_id : String
  summary : String
  stat_label : String
  stat_value : String
  status : String
} derive(Debug, Eq)

///|
pub struct MiniTownNotification {
  id : String
  kind : String
  title : String
  body : String
  target_ref : String
  unread : Bool
} derive(Debug, Eq)

///|
pub struct MiniTownDiscoveryItem {
  id : String
  kind : String
  title : String
  summary : String
  target_ref : String
  visibility : String
  status : String
} derive(Debug, Eq)

///|
pub struct MiniTownProjection {
  id : String
  active_user_id : String
  organization_id : String
  active_tab_id : String
  onboarding_completed : Bool
  role_id : String
  selected_building_id : String
  search_query : String
  users : Array[MiniTownUser]
  profile : MiniTownProfile
  roles : Array[MiniTownRole]
  tabs : Array[MiniTownTab]
  onboarding_steps : Array[MiniTownOnboardingStep]
  districts : Array[MiniTownDistrict]
  buildings : Array[MiniTownBuilding]
  agents : Array[MiniTownAgent]
  messages : Array[MiniTownMessage]
  notifications : Array[MiniTownNotification]
  discovery_items : Array[MiniTownDiscoveryItem]
} derive(Debug, Eq)

///|
pub fn mini_town_user(id~ : String, name~ : String) -> MiniTownUser {
  { id, name }
}

///|
pub fn mini_town_profile(
  user_id~ : String,
  display_name~ : String,
  role_id~ : String,
  avatar_ref~ : String,
  consent_accepted? : Bool = false,
  setup_completed? : Bool = false,
) -> MiniTownProfile {
  {
    user_id,
    display_name,
    role_id,
    avatar_ref,
    consent_accepted,
    setup_completed,
  }
}

///|
pub fn mini_town_role(
  id~ : String,
  title~ : String,
  summary~ : String,
  building_id~ : String,
) -> MiniTownRole {
  { id, title, summary, building_id }
}

///|
pub fn mini_town_building(
  id~ : String,
  title~ : String,
  kind~ : String,
  visibility~ : String,
  owner_id~ : String,
  summary~ : String,
  tags~ : Array[String],
  x~ : Int,
  y~ : Int,
  status~ : String,
  asset_ref? : String = "moontown-building",
) -> MiniTownBuilding {
  {
    id,
    title,
    kind,
    visibility,
    owner_id,
    summary,
    tags,
    x,
    y,
    status,
    asset_ref,
  }
}

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
pub fn mini_town_tab(
  id~ : String,
  label~ : String,
  map_surface? : Bool = false,
) -> MiniTownTab {
  { id, label, map_surface }
}

///|
pub fn mini_town_onboarding_step(
  id~ : String,
  title~ : String,
  body~ : String,
  building_id~ : String,
) -> MiniTownOnboardingStep {
  { id, title, body, building_id }
}

///|
pub fn mini_town_district(
  id~ : String,
  title~ : String,
  building_id~ : String,
  summary~ : String,
  stat_label~ : String,
  stat_value~ : String,
  status~ : String,
) -> MiniTownDistrict {
  { id, title, building_id, summary, stat_label, stat_value, status }
}

///|
pub fn mini_town_notification(
  id~ : String,
  kind~ : String,
  title~ : String,
  body~ : String,
  target_ref~ : String,
  unread? : Bool = true,
) -> MiniTownNotification {
  { id, kind, title, body, target_ref, unread }
}

///|
pub fn mini_town_discovery_item(
  id~ : String,
  kind~ : String,
  title~ : String,
  summary~ : String,
  target_ref~ : String,
  visibility~ : String,
  status~ : String,
) -> MiniTownDiscoveryItem {
  { id, kind, title, summary, target_ref, visibility, status }
}

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
    buildings: demo_buildings(),
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
    notifications: demo_notifications(),
    discovery_items: demo_discovery_items(),
  }
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
      id="discover-event-studio",
      kind="event",
      title="Team Studio Session",
      summary="Shared organization session for map and book planning.",
      target_ref="event:team-studio",
      visibility="shared_private",
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
      building_id="market-square",
      summary="Published building and product showcase.",
      stat_label="products",
      stat_value="20",
      status="running",
    ),
    mini_town_district(
      id="demand-hall",
      title="Demand Hall",
      building_id="review-council",
      summary="Requests, reviews, and agent jobs.",
      stat_label="demands",
      stat_value="34",
      status="review",
    ),
    mini_town_district(
      id="event-calendar",
      title="Event Calendar",
      building_id="team-studio",
      summary="Team and public town activities.",
      stat_label="events",
      stat_value="6",
      status="shared",
    ),
    mini_town_district(
      id="city-guide",
      title="City Guide",
      building_id="gateway",
      summary="Search, onboarding, and safe routing.",
      stat_label="guides",
      stat_value="4",
      status="stable",
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
    ),
    mini_town_notification(
      id="notice-publish",
      kind="publish",
      title="Draft ready to publish",
      body="Private Agent Lab can be submitted after profile consent.",
      target_ref="building-private-agent-lab",
    ),
    mini_town_notification(
      id="notice-share",
      kind="share",
      title="Team building shared",
      body="Team Studio is visible to organization members.",
      target_ref="building-team-studio",
      unread=false,
    ),
  ]
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
      title="System Gateway",
      kind="system_gateway",
      visibility="published",
      owner_id="system",
      summary="Login, session, and safe backend handoff.",
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
pub fn visible_buildings(
  projection : MiniTownProjection,
) -> Array[MiniTownBuilding] {
  let output : Array[MiniTownBuilding] = []
  for building in projection.buildings {
    if mini_town_building_visible_for(projection, building) {
      output.push(building)
    }
  }
  output
}

///|
fn mini_town_building_visible_for(
  projection : MiniTownProjection,
  building : MiniTownBuilding,
) -> Bool {
  building.visibility == "published" ||
  building.owner_id == projection.active_user_id ||
  building.owner_id == projection.organization_id
}

///|
pub fn selected_building(projection : MiniTownProjection) -> MiniTownBuilding {
  for building in projection.buildings {
    if building.id == projection.selected_building_id {
      return building
    }
  }
  projection.buildings[0]
}

///|
pub fn selected_agent(projection : MiniTownProjection) -> MiniTownAgent {
  let selected = selected_building(projection)
  for agent in projection.agents {
    if agent.building_id == selected.id {
      return agent
    }
  }
  projection.agents[0]
}

///|
pub fn search_results(
  projection : MiniTownProjection,
) -> Array[MiniTownBuilding] {
  let visible = visible_buildings(projection)
  let output : Array[MiniTownBuilding] = []
  for building in visible {
    if building.visibility == "published" &&
      mini_town_search_match(projection.search_query, building) {
      output.push(building)
    }
  }
  output
}

///|
pub fn unified_discovery_results(
  projection : MiniTownProjection,
) -> Array[MiniTownDiscoveryItem] {
  let output : Array[MiniTownDiscoveryItem] = []
  for building in search_results(projection) {
    output.push(
      mini_town_discovery_item(
        id="building-\{building.id}",
        kind="building",
        title=building.title,
        summary=building.summary,
        target_ref="building:\{building.id}",
        visibility=building.visibility,
        status=building.status,
      ),
    )
  }
  for item in projection.discovery_items {
    if mini_town_discovery_visible_for(projection, item) &&
      mini_town_discovery_match(projection.search_query, item) {
      output.push(item)
    }
  }
  output
}

///|
fn mini_town_discovery_visible_for(
  projection : MiniTownProjection,
  item : MiniTownDiscoveryItem,
) -> Bool {
  item.visibility == "published" ||
  item.visibility == "system_public" ||
  item.visibility == "personal" ||
  (item.visibility == "shared_private" && projection.organization_id != "")
}

///|
fn mini_town_discovery_match(
  query : String,
  item : MiniTownDiscoveryItem,
) -> Bool {
  query == "" ||
  item.kind.contains(query) ||
  item.title.contains(query) ||
  item.summary.contains(query)
}

///|
fn mini_town_search_match(query : String, building : MiniTownBuilding) -> Bool {
  if query == "" {
    true
  } else if building.title.contains(query) || building.summary.contains(query) {
    true
  } else {
    building.tags.contains(query)
  }
}

///|
pub fn switch_mock_user(
  projection : MiniTownProjection,
  user_id : String,
) -> MiniTownProjection {
  let next = { ..projection, active_user_id: user_id }
  let visible = visible_buildings(next)
  if visible.length() == 0 {
    next
  } else {
    { ..next, selected_building_id: visible[0].id }
  }
}

///|
pub fn switch_tab(
  projection : MiniTownProjection,
  tab_id : String,
) -> MiniTownProjection {
  { ..projection, active_tab_id: tab_id }
}

///|
pub fn complete_onboarding(
  projection : MiniTownProjection,
) -> MiniTownProjection {
  { ..projection, onboarding_completed: true }
}

///|
pub fn select_role(
  projection : MiniTownProjection,
  role_id : String,
) -> MiniTownProjection {
  { ..projection, role_id, profile: { ..projection.profile, role_id, } }
}

///|
pub fn accept_profile_consent(
  projection : MiniTownProjection,
) -> MiniTownProjection {
  { ..projection, profile: { ..projection.profile, consent_accepted: true } }
}

///|
pub fn complete_profile_setup(
  projection : MiniTownProjection,
) -> MiniTownProjection {
  { ..projection, profile: { ..projection.profile, setup_completed: true } }
}

///|
pub fn profile_ready_to_publish(projection : MiniTownProjection) -> Bool {
  projection.profile.setup_completed &&
  projection.profile.consent_accepted &&
  projection.profile.role_id != ""
}

///|
pub fn create_private_building(
  projection : MiniTownProjection,
  id : String,
  title : String,
) -> MiniTownProjection {
  let created = mini_town_building(
    id~,
    title~,
    kind="agent_lab",
    visibility="private_draft",
    owner_id=projection.active_user_id,
    summary="New private building created from the mini-app form.",
    tags=["agent", "private", "created"],
    x=432,
    y=513,
    status="draft",
  )
  {
    ..projection,
    selected_building_id: id,
    buildings: projection.buildings + [created],
  }
}

///|
pub fn create_agent_for_selected(
  projection : MiniTownProjection,
  id : String,
  name : String,
) -> MiniTownProjection {
  let agent = mini_town_agent(
    id~,
    name~,
    building_id=projection.selected_building_id,
    status="idle",
  )
  { ..projection, agents: projection.agents + [agent] }
}

///|
pub fn owned_buildings(
  projection : MiniTownProjection,
) -> Array[MiniTownBuilding] {
  let output : Array[MiniTownBuilding] = []
  for building in projection.buildings {
    if building.owner_id == projection.active_user_id {
      output.push(building)
    }
  }
  output
}

///|
pub fn unread_notifications(
  projection : MiniTownProjection,
) -> Array[MiniTownNotification] {
  let output : Array[MiniTownNotification] = []
  for notice in projection.notifications {
    if notice.unread {
      output.push(notice)
    }
  }
  output
}
