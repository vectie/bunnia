///|
test "moontown projection handles building creation publishing placement and restore" {
  let projection = demo_projection()
  let switched = switch_mock_user(projection, "user-b")
  assert_eq(switched.active_user_id, "user-b")
  assert_true(visible_buildings(switched).length() >= 8)
  assert_eq(community_presence(switched).length(), 3)
  assert_eq(visible_notifications(switched).length(), 6)
  assert_eq(unread_notifications(switched).length(), 4)
  let created = create_private_building(
    projection, "created-agent-lab", "Created Agent Lab",
  )
  assert_eq(created.buildings.length(), 11)
  assert_eq(created.books.length(), 9)
  assert_eq(created.audit_events.length(), 5)
  assert_eq(created.selected_building_id, "created-agent-lab")
  assert_eq(selected_building_book(created).id, "book-created-agent-lab")
  assert_eq(selected_building_audit_events(created).length(), 1)
  let edited = edit_selected_building(
    created,
    "Edited Agent Lab",
    "Edited private building profile.",
    "Edited Agent Lab Book",
    "Edited safe memory summary.",
    ["agent", "edited"],
  )
  assert_eq(selected_building(edited).title, "Edited Agent Lab")
  assert_eq(
    selected_building(edited).summary,
    "Edited private building profile.",
  )
  assert_eq(selected_building(edited).tags[1], "edited")
  assert_eq(selected_building_book(edited).title, "Edited Agent Lab Book")
  assert_eq(
    selected_building_book(edited).summary,
    "Edited safe memory summary.",
  )
  assert_eq(selected_building_audit_events(edited).length(), 2)
  let blocked_edit = edit_selected_building(
    projection,
    "Published Edit",
    "Should not change published building.",
    "Published Edit Book",
    "Blocked book summary.",
    ["blocked"],
  )
  assert_eq(selected_building(blocked_edit).title, "Policy Hall")
  assert_eq(selected_building_audit_events(blocked_edit).length(), 1)
  let shared = share_selected_building(created)
  assert_eq(selected_building(shared).visibility, "shared_private")
  assert_eq(selected_building_book(shared).visibility, "shared_private")
  assert_eq(selected_building_audit_events(shared).length(), 2)
  let shared_steps = publication_steps(shared)
  assert_true(shared_steps[1].current)
  assert_eq(shared_steps[2].summary, "Finish profile first")
  let shared_unread_count = unread_notifications(shared).length()
  let submitted = submit_selected_building(shared)
  assert_eq(selected_building(submitted).visibility, "submitted")
  assert_eq(selected_building_book(submitted).visibility, "submitted")
  assert_eq(selected_building_book(submitted).pending_review_count, 1)
  assert_eq(pending_reviews(submitted).length(), 2)
  assert_eq(
    pending_reviews(submitted)[1].artifact_ref,
    "building://created-agent-lab",
  )
  assert_eq(pending_reviews(submitted)[1].accepted_memory_delta, 0)
  assert_eq(unread_notifications(submitted).length(), shared_unread_count + 1)
  let submitted_steps = publication_steps(submitted)
  assert_true(submitted_steps[2].current)
  assert_true(submitted_steps[3].current)
  let submitted_actions = selected_building_lifecycle_actions(submitted)
  assert_eq(submitted_actions[5].id, "publish")
  assert_true(!submitted_actions[5].allowed)
  let rejected_publication = reject_review(
    submitted, "review-publish-created-agent-lab",
  )
  assert_eq(selected_building(rejected_publication).visibility, "private_draft")
  assert_eq(
    selected_building_book(rejected_publication).visibility,
    "private_draft",
  )
  assert_eq(
    selected_building_book(rejected_publication).pending_review_count,
    0,
  )
  assert_eq(pending_reviews(rejected_publication).length(), 1)
  let resubmitted = submit_selected_building(rejected_publication)
  let published = accept_review(resubmitted, "review-publish-created-agent-lab")
  assert_eq(selected_building(published).visibility, "published")
  assert_eq(selected_building_book(published).visibility, "published")
  assert_eq(selected_building_book(published).pending_review_count, 0)
  assert_eq(pending_reviews(published).length(), 1)
  assert_eq(search_results(published).length(), 2)
  let published_steps = publication_steps(published)
  assert_true(published_steps[4].current)
  assert_true(published_steps[4].complete)
  let placeable_before_pin = switch_discovery_filter(published, "placeable")
  let placed = place_published_building(published, "published-agent-lab")
  assert_eq(placed.selected_building_id, "published-agent-lab")
  assert_eq(placed.buildings.length(), published.buildings.length())
  assert_eq(placed.placements.length(), published.placements.length() + 1)
  assert_eq(visible_placements(placed).length(), 2)
  assert_eq(placed_buildings(placed).length(), 2)
  assert_true(placement_for_building(placed, "published-agent-lab") is Some(_))
  assert_eq(selected_building_audit_events(placed).length(), 2)
  let placed_placeable = switch_discovery_filter(placed, "placeable")
  assert_eq(
    filtered_discovery_results(placed_placeable).length(),
    filtered_discovery_results(placeable_before_pin).length() - 1,
  )
  for item in filtered_discovery_results(placed_placeable) {
    assert_true(item.target_ref != "building:published-agent-lab")
  }
  let placed_discover = tab_page(placed, "discover")
  assert_true(placed_discover.wxml.contains("Pinned On Map"))
  assert_true(placed_discover.wxml.contains("Already placed"))
  assert_true(!placed_discover.wxml.contains("data-placement-state="))
  let duplicate_placed = place_published_building(placed, "published-agent-lab")
  assert_eq(duplicate_placed.placements.length(), placed.placements.length())
  let archived = archive_selected_building(published)
  assert_eq(selected_building(archived).visibility, "archived")
  assert_eq(visible_buildings(archived).length(), 9)
  let archived_steps = publication_steps(archived)
  assert_true(archived_steps[5].current)
  assert_true(!archived_steps[5].blocked)
  let archived_actions = selected_building_lifecycle_actions(archived)
  assert_eq(archived_actions[7].id, "restore")
  assert_true(archived_actions[7].allowed)
  let restored = restore_selected_building(archived)
  assert_eq(selected_building(restored).visibility, "private_draft")
  assert_eq(selected_building_book(restored).visibility, "private_draft")
  assert_eq(selected_building(restored).status, "draft")
  assert_eq(selected_building_audit_events(restored).length(), 8)
}
