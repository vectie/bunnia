///|
pub fn publication_steps(
  projection : MiniTownProjection,
) -> Array[MiniTownPublicationStep] {
  let building = publication_subject_building(projection)
  let private_ready = building.visibility == "private_draft" &&
    is_owned_by_active_user(projection, building)
  let shared_ready = building.visibility == "shared_private" &&
    is_owned_by_active_user(projection, building) &&
    profile_ready_to_publish(projection)
  let submitted = building.visibility == "submitted"
  [
    mini_town_publication_step(
      id="draft",
      label="Private Draft",
      summary=if building.visibility == "private_draft" {
        "Owner can edit and prepare the building book."
      } else {
        "Initial private owner workspace is complete."
      },
      current=building.visibility == "private_draft",
      complete=building.visibility != "private_draft",
      blocked=!is_owned_by_active_user(projection, building),
    ),
    mini_town_publication_step(
      id="share",
      label="Team Share",
      summary=if private_ready {
        "Share privately with invited or organization members."
      } else if building.visibility == "shared_private" {
        "Visible to the team before public publication."
      } else {
        lifecycle_share_reason(projection, building)
      },
      current=building.visibility == "shared_private",
      complete=building.visibility == "submitted" ||
        building.visibility == "published" ||
        building.visibility == "archived",
      blocked=!private_ready && building.visibility == "private_draft",
    ),
    mini_town_publication_step(
      id="review",
      label="Publish Review",
      summary=if shared_ready {
        "Ready to submit into town publication review."
      } else if submitted {
        "Submitted and waiting for publication decision."
      } else {
        lifecycle_publish_reason(projection, building)
      },
      current=submitted,
      complete=building.visibility == "published" ||
        building.visibility == "archived",
      blocked=building.visibility == "shared_private" &&
        !profile_ready_to_publish(projection),
    ),
    mini_town_publication_step(
      id="approve",
      label="Review Decision",
      summary=if submitted {
        "A reviewer can publish or reject before public discovery."
      } else if building.visibility == "published" {
        "Publication review accepted."
      } else {
        "Submit before a reviewer can decide."
      },
      current=submitted,
      complete=building.visibility == "published" ||
        building.visibility == "archived",
      blocked=!submitted && building.visibility != "published",
    ),
    mini_town_publication_step(
      id="published",
      label="Town Published",
      summary=if building.visibility == "published" {
        "Searchable and placeable by allowed users."
      } else {
        "Not yet visible in public discovery."
      },
      current=building.visibility == "published",
      complete=building.visibility == "published" ||
        building.visibility == "archived",
      blocked=false,
    ),
    mini_town_publication_step(
      id="archive",
      label="Archive",
      summary=if building.visibility == "archived" {
        "Hidden from normal map and discovery surfaces; owner can restore to draft."
      } else {
        lifecycle_archive_reason(projection, building)
      },
      current=building.visibility == "archived",
      complete=building.visibility == "archived",
      blocked=building.visibility == "archived" &&
        !is_owned_by_active_user(projection, building),
    ),
  ]
}

///|
fn publication_subject_building(
  projection : MiniTownProjection,
) -> MiniTownBuilding {
  let selected = selected_building(projection)
  if is_owned_by_active_user(projection, selected) {
    selected
  } else {
    let owned = owned_buildings(projection)
    if owned.length() > 0 {
      owned[0]
    } else {
      selected
    }
  }
}

///|
fn is_owned_by_active_user(
  projection : MiniTownProjection,
  building : MiniTownBuilding,
) -> Bool {
  building.owner_id == projection.active_user_id
}
