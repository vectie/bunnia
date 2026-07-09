///|
pub fn place_published_building(
  projection : MiniTownProjection,
  building_id : String,
) -> MiniTownProjection {
  let mut title = building_id
  let mut x = 0
  let mut y = 0
  for building in projection.buildings {
    if building.id == building_id {
      title = building.title
      x = building.x
      y = building.y
    }
  }
  let placement_id = "placement-\{projection.active_user_id}-\{building_id}"
  let placements = if placement_exists(projection, placement_id) {
    projection.placements
  } else {
    projection.placements +
    [
      mini_town_placement(
        id=placement_id,
        building_id~,
        owner_id=projection.active_user_id,
        layer="personal",
        x~,
        y~,
        status="pinned",
        source="discover",
      ),
    ]
  }
  {
    ..projection,
    selected_building_id: building_id,
    placements,
    audit_events: projection.audit_events +
    [
      lifecycle_event(
        id="audit-place-\{building_id}",
        kind="place",
        title="\{title} placed",
        summary="A public building was placed onto this user's map layer.",
        actor_id=projection.active_user_id,
        building_id~,
        status="stable",
        visibility="published",
      ),
    ],
  }
}

///|
fn placement_exists(
  projection : MiniTownProjection,
  placement_id : String,
) -> Bool {
  for placement in projection.placements {
    if placement.id == placement_id {
      return true
    }
  }
  false
}
