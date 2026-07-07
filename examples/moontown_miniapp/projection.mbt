///|
pub struct MiniTownUser {
  id : String
  name : String
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
pub struct MiniTownProjection {
  id : String
  active_user_id : String
  organization_id : String
  selected_building_id : String
  search_query : String
  users : Array[MiniTownUser]
  buildings : Array[MiniTownBuilding]
  agents : Array[MiniTownAgent]
  messages : Array[MiniTownMessage]
} derive(Debug, Eq)

///|
pub fn mini_town_user(id~ : String, name~ : String) -> MiniTownUser {
  { id, name }
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
pub fn demo_projection() -> MiniTownProjection {
  {
    id: "moontown-miniapp",
    active_user_id: "user-a",
    organization_id: "org-a",
    selected_building_id: "policy-hall",
    search_query: "agent",
    users: [
      mini_town_user(id="user-a", name="Ada"),
      mini_town_user(id="user-b", name="Bo"),
    ],
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
  }
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
