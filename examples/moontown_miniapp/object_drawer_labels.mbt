///|
fn building_owner_label(
  projection : MiniTownProjection,
  building : MiniTownBuilding,
) -> String {
  if building.owner_id == projection.active_user_id {
    "Owner"
  } else if building.visibility == "shared_private" {
    "Team member"
  } else {
    "Visitor"
  }
}
