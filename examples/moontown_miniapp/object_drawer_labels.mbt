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

///|
fn building_capability_label(
  projection : MiniTownProjection,
  building : MiniTownBuilding,
) -> String {
  if building.visibility == "archived" {
    "Archived; owner can restore"
  } else if building.owner_id == projection.active_user_id &&
    (
      building.visibility == "private_draft" ||
      building.visibility == "shared_private"
    ) {
    "Owner can edit, share, and submit"
  } else if building.visibility == "published" {
    "Public place can be opened and placed"
  } else if building.visibility == "submitted" {
    "Waiting for review decision"
  } else {
    "Open for safe reading"
  }
}
