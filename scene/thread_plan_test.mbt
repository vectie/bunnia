///|
fn thread_plan_scene() -> Scene {
  scene("thread-map", scene_size(320, 240), [
    layer("subjects", 1, [marker(id="agent-a", label="A", x=20, y=30)], regions=[
      region(id="zone-b", label="B", x=60, y=70, width=120, height=80),
    ]),
  ])
}

///|
test "scene thread plans summarize map communication links" {
  let plan = plan_scene_threads(thread_plan_scene(), [
    scene_marker_thread_link(
      id="link-a",
      scene_id="thread-map",
      marker_id="agent-a",
      thread_id="thread-a",
      unread_count=0,
      open_message="open-thread-a",
    ),
    scene_region_thread_link(
      id="link-b",
      scene_id="thread-map",
      region_id="zone-b",
      thread_id="thread-b",
      unread_count=3,
      open_message="open-thread-b",
    ),
  ])
  assert_eq(plan.scene_id, "thread-map")
  assert_eq(plan.total_link_count, 2)
  assert_eq(plan.visible_link_count, 2)
  assert_eq(plan.hidden_link_count, 0)
  assert_eq(plan.unread_total, 3)
  assert_eq(plan.links_with_unread_count, 1)
  assert_eq(plan.orphan_link_count, 0)
  assert_eq(plan.links_without_open_message_count, 0)
  assert_eq(plan.diagnostics.length(), 0)
  assert_true(plan.summary.contains("links=2/2"))
  assert_true(plan.summary.contains("unread_total=3"))
}

///|
test "scene thread plans report visibility unread and orphan pressure" {
  let plan = plan_scene_threads_with_budget(
    thread_plan_scene(),
    [
      scene_marker_thread_link(
        id="link-a",
        scene_id="thread-map",
        marker_id="agent-a",
        thread_id="thread-a",
        unread_count=7,
        open_message="open-thread-a",
      ),
      scene_region_thread_link(
        id="link-orphan",
        scene_id="thread-map",
        region_id="missing-zone",
        thread_id="thread-missing",
        unread_count=5,
      ),
    ],
    scene_thread_budget(
      max_visible_links=1,
      max_unread_total=8,
      max_orphan_links=0,
      max_links_without_open_message=0,
    ),
  )
  assert_eq(plan.visible_link_count, 1)
  assert_eq(plan.hidden_link_count, 1)
  assert_eq(plan.unread_total, 12)
  assert_eq(plan.links_with_unread_count, 2)
  assert_eq(plan.orphan_link_count, 1)
  assert_eq(plan.links_without_open_message_count, 1)
  assert_true(plan.diagnostics.contains("scene-thread-links-over-budget:2/1"))
  assert_true(plan.diagnostics.contains("scene-thread-unread-over-budget:12/8"))
  assert_true(plan.diagnostics.contains("scene-thread-orphan-links:1/0"))
  assert_true(
    plan.diagnostics.contains("scene-thread-links-without-open-message:1/0"),
  )
}

///|
test "viewported scene thread plans budget only visible anchors" {
  let scene = scene("thread-map", scene_size(640, 480), [
    layer("subjects", 1, [marker(id="agent-far", label="Far", x=500, y=320)], regions=[
      region(
        id="zone-visible",
        label="Visible",
        x=40,
        y=40,
        width=80,
        height=80,
      ),
    ]),
  ])
  let plan = plan_scene_threads_viewport_with_budget(
    scene,
    scene_viewport(x=0, y=0, width=180, height=180),
    [
      scene_region_thread_link(
        id="link-visible",
        scene_id="thread-map",
        region_id="zone-visible",
        thread_id="thread-visible",
        unread_count=1,
        open_message="open-visible",
      ),
      scene_marker_thread_link(
        id="link-far",
        scene_id="thread-map",
        marker_id="agent-far",
        thread_id="thread-far",
        unread_count=5,
        open_message="open-far",
      ),
    ],
    scene_thread_budget(max_visible_links=1, max_unread_total=8),
  )
  assert_eq(plan.total_link_count, 2)
  assert_eq(plan.visible_link_count, 1)
  assert_eq(plan.hidden_link_count, 1)
  assert_eq(plan.unread_total, 6)
  assert_eq(plan.orphan_link_count, 0)
  assert_eq(plan.diagnostics.length(), 0)
  assert_true(plan.summary.contains("links=1/2"))
  assert_true(plan.summary.contains("hidden=1"))
}

///|
test "viewported scene thread plans still report offscreen orphan pressure" {
  let plan = plan_scene_threads_viewport_with_budget(
    thread_plan_scene(),
    scene_viewport(x=0, y=0, width=80, height=80),
    [
      scene_marker_thread_link(
        id="link-a",
        scene_id="thread-map",
        marker_id="agent-a",
        thread_id="thread-a",
        unread_count=1,
        open_message="open-thread-a",
      ),
      scene_region_thread_link(
        id="link-orphan",
        scene_id="thread-map",
        region_id="missing-zone",
        thread_id="thread-missing",
        unread_count=2,
      ),
    ],
    scene_thread_budget(
      max_visible_links=1,
      max_unread_total=8,
      max_orphan_links=0,
      max_links_without_open_message=0,
    ),
  )
  assert_eq(plan.total_link_count, 2)
  assert_eq(plan.visible_link_count, 1)
  assert_eq(plan.hidden_link_count, 1)
  assert_eq(plan.orphan_link_count, 1)
  assert_eq(plan.links_without_open_message_count, 1)
  assert_true(plan.diagnostics.contains("scene-thread-orphan-links:1/0"))
  assert_true(
    plan.diagnostics.contains("scene-thread-links-without-open-message:1/0"),
  )
  assert_true(!plan.diagnostics.contains("scene-thread-links-over-budget:2/1"))
}
