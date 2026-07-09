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
