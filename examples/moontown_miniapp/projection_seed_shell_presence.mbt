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
