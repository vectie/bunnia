///|
fn home_changed_places_count(activity : Array[MiniTownActivityItem]) -> Int {
  let ids : Array[String] = []
  for item in activity {
    if !home_contains_id(ids, item.building_id) {
      ids.push(item.building_id)
      if ids.length() == 3 {
        return 3
      }
    }
  }
  ids.length()
}

///|
fn home_contains_id(ids : Array[String], id : String) -> Bool {
  for item in ids {
    if item == id {
      return true
    }
  }
  false
}

///|
fn home_activity_summary(activity : Array[MiniTownActivityItem]) -> String {
  if activity.length() > 0 {
    activity[0].title
  } else {
    "Open Realm to see what changed around the map."
  }
}

///|
fn home_attention_summary(
  reviews : Array[MiniTownReviewItem],
  unread : Array[MiniTownNotification],
) -> String {
  if reviews.length() > 0 {
    reviews[0].title
  } else if unread.length() > 0 {
    unread[0].title
  } else {
    "No agent handoff is waiting right now."
  }
}

///|
fn home_refresh_count(projection : MiniTownProjection) -> Int {
  let mut count = 0
  for item in projection.backend_cache_states {
    if item.state.has_prefix("stale") || item.state == "failed" {
      count += 1
    }
  }
  count
}
