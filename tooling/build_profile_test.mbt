///|
fn fixture_project() -> @wechat.WechatProject {
  let root = fixture_root()
  let runtime = @wechat.runtime(initial_data_json="{\"active\":false}", event_patches=[
    @wechat.event_patch("open", [@core.set_string("state.active", "open")]),
    @wechat.event_patch("close", [@core.set_string("state.active", "close")]),
  ])
  @wechat.generate_project_with_runtime(
    name="Profile Fixture",
    route="pages/profile/index",
    root~,
    runtime~,
  )
}

///|
test "build profile includes route initial-data render-budget diagnostics" {
  let runtime = @wechat.runtime(
    initial_data_json="{\"agentDraft\":\"large payload\"}",
  )
  let project = @wechat.generate_project_with_runtime_and_budget(
    name="Profile Initial Data",
    route="pages/profile-initial/index",
    root=@core.page([@core.text("Profile")]),
    runtime~,
    render_budget=@core.render_budget(
      max_nodes=16,
      max_depth=4,
      max_events=4,
      max_initial_data_bytes=8,
    ),
  )
  let profile = profile_wechat_project(project, @core.plan_patches([]))
  assert_eq(profile.route_diagnostic_route_count, 1)
  assert_eq(profile.route_diagnostic_count, 1)
  assert_true(
    profile.diagnostics.contains(
      "wechat:wechat-route-initial-data-over-render-budget:pages/profile-initial/index:30/8",
    ),
  )
}

///|
test "build profile derives route diagnostics from manifest pages once" {
  let route = "pages/profile-route/index"
  let project = @wechat.generate_project_with_runtime_and_budget(
    name="Profile Route Diagnostics",
    route~,
    root=@core.page([@core.view([@core.button("Open", "open")])]),
    runtime=@wechat.runtime(initial_data_json="{\"draft\":\"large\"}", event_patches=[
      @wechat.event_patch("close", [@core.set_string("state.active", "close")]),
    ]),
    render_budget=@core.render_budget(
      max_nodes=16,
      max_depth=4,
      max_events=0,
      max_initial_data_bytes=8,
    ),
  )
  let profile = profile_wechat_project(project, @core.plan_patches([]))
  let render_diagnostic = "render:\{route}:event-count-over-budget:1/0"
  let missing_patch_diagnostic = "wechat:wechat-event-without-patch:\{route}:open"
  let orphan_patch_diagnostic = "wechat:wechat-patch-without-event:\{route}:close"
  assert_eq(profile.route_diagnostic_route_count, 1)
  assert_eq(profile.route_diagnostic_count, 4)
  assert_eq(count_occurrence(profile.diagnostics, render_diagnostic), 1)
  assert_eq(count_occurrence(profile.diagnostics, missing_patch_diagnostic), 1)
  assert_eq(count_occurrence(profile.diagnostics, orphan_patch_diagnostic), 1)
  assert_true(
    contains_prefix(
      profile.diagnostics,
      "wechat:wechat-route-initial-data-over-render-budget:\{route}:",
    ),
  )
  assert_eq(
    count_prefix(
      profile.diagnostics,
      "wechat:wechat-route-initial-data-over-render-budget:\{route}:",
    ),
    1,
  )
  assert_true(
    !profile.diagnostics.contains(
      "wechat:wechat-render:\{route}:event-count-over-budget:1/0",
    ),
  )
}

///|
test "build profile reports generated scene asset references from manifests" {
  let project = @wechat.generate_project(
    name="Generated Scene Assets",
    route="pages/generated-assets/index",
    root=@core.page([
      @core.node(kind="image", attrs=[
        @core.class_name("bunnia-scene-sprite"),
        @core.attr("src", "/assets/local-marker.png"),
        @core.attr("alt", "Local marker"),
        @core.data("asset-id", "local-marker"),
        @core.data("asset-kind", "sprite"),
        @core.data("asset-remote", "false"),
      ]),
      @core.node(kind="image", attrs=[
        @core.class_name("bunnia-scene-tile"),
        @core.attr("src", "https://cdn.example.test/tile.png"),
        @core.attr("alt", "Remote tile"),
        @core.data("asset-id", "remote-tile"),
        @core.data("asset-kind", "remote-image"),
        @core.data("asset-remote", "true"),
      ]),
    ]),
  )
  let profile = profile_wechat_project(project, @core.plan_patches([]))
  assert_eq(profile.scene_asset_count, 0)
  assert_eq(profile.scene_remote_asset_count, 0)
  assert_eq(profile.generated_scene_asset_count, 2)
  assert_eq(profile.generated_scene_remote_asset_count, 1)
  assert_true(profile.summary.contains("scene_assets=0"))
  assert_true(profile.summary.contains("scene_remote_assets=0"))
  assert_true(profile.summary.contains("generated_scene_assets=2"))
  assert_true(profile.summary.contains("generated_scene_remote_assets=1"))
}

///|
test "build profile aggregates normal project signals" {
  let project = fixture_project()
  let patches = @core.plan_patches([@core.set_string("state.active", "open")])
  let backend = @effects.plan_backend_contract(
    @effects.backend_contract(id="profile-backend", endpoints=[
      @effects.agent_message_endpoint(
        "send-message", "/agent/message", "draft", "message",
      ),
    ]),
  )
  let assets = @scene.plan_scene_assets([
    @scene.sprite_asset("pin", "/assets/pin.png", 1024),
  ])
  let scene_input = @scene.scene(
    "map",
    @scene.scene_size(320, 240),
    [
      @scene.layer("markers", 1, [
        @scene.marker(
          id="a",
          label="A",
          x=20,
          y=20,
          status="stable",
          tap_message="select-a",
          asset_ref="pin",
        ),
      ]),
    ],
    assets=[@scene.sprite_asset("pin", "/assets/pin.png", 1024)],
  )
  let scene = @scene.plan_scene_render(scene_input)
  let surface = @scene.plan_scene_surface_for_platform(
    scene_input,
    @core.Wechat,
  )
  let quality = @scene.plan_scene_visual_quality(scene_input)
  let threads = @scene.plan_scene_threads(scene_input, [
    @scene.scene_marker_thread_link(
      id="thread-a",
      scene_id="map",
      marker_id="a",
      thread_id="comm-thread-a",
      unread_count=2,
      open_message="open-thread-a",
    ),
  ])
  let camera = @scene.plan_scene_camera(
    scene_input,
    @scene.scene_camera(scene_id="map", x=0, y=0, width=320, height=240),
  )
  let profile = profile_wechat_project(
    project,
    patches,
    communication_plans=[
      @agent.plan_communications([
        @agent.message_event(
          id="comm-open",
          thread_id="thread-profile",
          from_actor_id="agent-a",
          text="Opened.",
        ),
        @agent.review_request(
          id="comm-review",
          thread_id="thread-profile",
          from_actor_id="agent-a",
          to_actor_id="operator",
          text="Approve?",
          artifact_ref="artifact://profile",
        ),
      ]),
    ],
    agent_delta_plans=[
      @agent.plan_agent_deltas([
        @agent.append_stream_chunk_delta(
          "agent.streamChunks", "chunk-1", "loading",
        ),
        @agent.set_stream_chunk_delta(
          "agent.streamChunks",
          "chunk-1",
          "loaded",
          status=@agent.Done,
        ),
      ]),
    ],
    backend_plans=[backend],
    snapshot_plans=[
      @effects.plan_snapshot_deltas([
        @effects.set_snapshot_section_delta(
          "profile", "summary", "{\"ready\":true}",
        ),
        @effects.append_snapshot_item_delta(
          "profile", "messages", "msg-1", "{\"id\":\"msg-1\"}",
        ),
      ]),
    ],
    asset_plans=[assets],
    thread_plans=[threads],
    camera_plans=[camera],
    scene_plans=[scene],
    surface_plans=[surface],
    quality_plans=[quality],
  )
  assert_eq(profile.name, "Profile Fixture")
  assert_eq(profile.route, "pages/profile/index")
  assert_eq(profile.page_count, 1)
  assert_eq(profile.windowed_list_count, 0)
  assert_eq(profile.list_total_count, 0)
  assert_eq(profile.list_visible_count, 0)
  assert_eq(profile.unwindowed_list_child_count, 0)
  assert_eq(profile.unkeyed_list_child_count, 0)
  assert_eq(profile.duplicate_list_key_count, 0)
  assert_eq(profile.file_count, 10)
  assert_eq(profile.event_patch_operation_count, 2)
  assert_eq(
    profile.max_page_first_screen_bytes,
    project.report.max_page_first_screen_bytes,
  )
  assert_eq(
    profile.max_page_update_payload_bytes,
    project.report.max_page_update_payload_bytes,
  )
  assert_eq(
    profile.max_page_update_operation_count,
    project.report.max_page_update_operation_count,
  )
  assert_eq(profile.backend_endpoint_count, 1)
  assert_eq(profile.backend_streaming_count, 0)
  assert_eq(profile.backend_review_required_count, 0)
  assert_eq(profile.backend_cancel_count, 0)
  assert_eq(profile.backend_retry_count, 0)
  assert_eq(profile.scene_marker_count, 1)
  assert_eq(profile.scene_visible_marker_count, 1)
  assert_eq(profile.scene_asset_count, 1)
  assert_eq(profile.scene_package_bytes, 1024)
  assert_eq(profile.scene_remote_asset_count, 0)
  assert_eq(profile.generated_scene_asset_count, 0)
  assert_eq(profile.generated_scene_remote_asset_count, 0)
  assert_eq(profile.scene_insecure_remote_asset_count, 0)
  assert_eq(profile.scene_unapproved_remote_asset_count, 0)
  assert_eq(profile.scene_deferred_asset_count, 0)
  assert_eq(profile.scene_thread_link_count, 1)
  assert_eq(profile.scene_thread_visible_link_count, 1)
  assert_eq(profile.scene_thread_unread_total, 2)
  assert_eq(profile.scene_thread_orphan_link_count, 0)
  assert_eq(profile.scene_camera_count, 1)
  assert_eq(profile.scene_camera_clamped_count, 0)
  assert_eq(profile.scene_static_surface_count, 1)
  assert_eq(profile.scene_canvas_surface_count, 0)
  assert_eq(profile.scene_lightweight_surface_count, 0)
  assert_eq(profile.scene_surface_fallback_count, 0)
  assert_eq(profile.scene_quality_issue_count, 0)
  assert_eq(profile.degraded_scene_count, 0)
  assert_eq(profile.route_diagnostic_route_count, 0)
  assert_eq(profile.route_diagnostic_count, 0)
  assert_eq(profile.effect_count, 0)
  assert_eq(profile.cloud_function_count, 0)
  assert_eq(profile.stream_effect_count, 0)
  assert_eq(profile.communication_count, 2)
  assert_eq(profile.communication_visible_count, 2)
  assert_eq(profile.communication_unresolved_review_count, 1)
  assert_eq(profile.communication_artifact_ref_count, 1)
  assert_eq(profile.tool_result_count, 0)
  assert_eq(profile.tool_result_visible_count, 0)
  assert_eq(profile.tool_result_pending_ack_count, 0)
  assert_eq(profile.tool_result_missing_ack_count, 0)
  assert_eq(profile.tool_result_artifact_ref_count, 0)
  assert_eq(profile.agent_delta_count, 2)
  assert_eq(profile.agent_duplicate_stream_chunk_count, 0)
  assert_eq(profile.snapshot_delta_count, 2)
  assert_eq(profile.snapshot_section_update_count, 1)
  assert_eq(profile.snapshot_append_item_count, 1)
  assert_eq(profile.snapshot_full_replace_count, 0)
  assert_eq(profile.diagnostics.length(), 0)
  assert_true(profile.summary.contains("backend_endpoints=1"))
  assert_true(profile.summary.contains("backend_streams=0"))
  assert_true(profile.summary.contains("backend_reviews=0"))
  assert_true(profile.summary.contains("backend_cancels=0"))
  assert_true(profile.summary.contains("backend_retries=0"))
  assert_true(profile.summary.contains("pages=1"))
  assert_true(profile.summary.contains("list_items=0/0"))
  assert_true(profile.summary.contains("unwindowed_list_children=0"))
  assert_true(profile.summary.contains("unkeyed_list_children=0"))
  assert_true(profile.summary.contains("duplicate_list_keys=0"))
  assert_true(profile.summary.contains("max_first_screen="))
  assert_true(profile.summary.contains("max_update_payload="))
  assert_true(profile.summary.contains("event_patch_ops=2"))
  assert_true(profile.summary.contains("max_update_ops=2"))
  assert_true(profile.summary.contains("effects=0"))
  assert_true(profile.summary.contains("communications=2/2"))
  assert_true(profile.summary.contains("communication_unresolved_reviews=1"))
  assert_true(profile.summary.contains("communication_artifacts=1"))
  assert_true(profile.summary.contains("tool_results=0/0"))
  assert_true(profile.summary.contains("tool_result_pending_acks=0"))
  assert_true(profile.summary.contains("agent_deltas=2"))
  assert_true(profile.summary.contains("agent_duplicate_stream_chunks=0"))
  assert_true(profile.summary.contains("snapshot_deltas=2"))
  assert_true(profile.summary.contains("snapshot_sections=1"))
  assert_true(profile.summary.contains("snapshot_appends=1"))
  assert_true(profile.summary.contains("snapshot_full_replaces=0"))
  assert_true(profile.summary.contains("scene_markers=1/1"))
  assert_true(profile.summary.contains("scene_remote_assets=0"))
  assert_true(profile.summary.contains("generated_scene_assets=0"))
  assert_true(profile.summary.contains("generated_scene_remote_assets=0"))
  assert_true(profile.summary.contains("scene_unapproved_remote_assets=0"))
  assert_true(profile.summary.contains("scene_deferred_assets=0"))
  assert_true(profile.summary.contains("scene_threads=1/1"))
  assert_true(profile.summary.contains("scene_thread_unread=2"))
  assert_true(profile.summary.contains("scene_thread_orphans=0"))
  assert_true(profile.summary.contains("scene_cameras=1"))
  assert_true(profile.summary.contains("scene_camera_clamped=0"))
  assert_true(
    profile.summary.contains("scene_surfaces=static:1,canvas:0,lightweight:0"),
  )
  assert_true(profile.summary.contains("scene_surface_fallbacks=0"))
  assert_true(profile.summary.contains("scene_quality_issues=0"))
  assert_true(profile.summary.contains("route_diagnostic_routes=0"))
  assert_true(profile.summary.contains("route_diagnostics=0"))
}

///|
test "build profile prefixes diagnostics by budget source" {
  let project = @wechat.generate_project(
    name="Large Profile Fixture",
    route="pages/large/index",
    root=large_fixture_root(900),
  )
  let patches = @core.plan_patches_with_budget(
    [@core.set_string("state.active", "open")],
    @core.patch_budget(max_patches=0, max_patch_bytes=1),
  )
  let backend = @effects.plan_backend_contract_with_budget(
    @effects.backend_contract(id="profile-backend", endpoints=[
      @effects.operator_submit_endpoint(
        "submit", "/submit", "payload", "result",
      ),
      @effects.agent_cancel_endpoint(
        "cancel-run", "/agent/run/cancel", "cancel", "cancelResult",
      ),
      @effects.agent_retry_endpoint(
        "retry-run", "/agent/run/retry", "retry", "retryResult",
      ),
    ]),
    @effects.backend_budget(
      max_endpoints=0,
      max_streaming=0,
      max_review_required=0,
    ),
  )
  let assets = @scene.plan_scene_assets_with_budget_and_policy(
    [
      @scene.sprite_asset("pin", "/assets/pin.png", 2048),
      @scene.remote_image_asset(
        "remote", "https://assets.example.test/tile.png",
      ),
    ],
    @scene.scene_asset_budget(
      max_assets=0,
      max_package_bytes=1,
      max_remote_assets=0,
    ),
    @scene.scene_asset_policy(approved_remote_domains=["cdn.example.test"]),
  )
  let scene = @scene.plan_scene_render_with_budget(
    @scene.scene("map", @scene.scene_size(320, 240), [
      @scene.layer("markers", 1, [
        @scene.marker(id="a", label="A", x=20, y=20),
        @scene.marker(id="b", label="B", x=40, y=40),
      ]),
    ]),
    @scene.scene_render_budget(max_layers=1, max_markers=1, max_static_assets=1),
  )
  let constrained_surface = @scene.plan_scene_surface(
    @scene.scene("surface-map", @scene.scene_size(320, 240), [
      @scene.layer("markers", 1, [
        @scene.marker(
          id="a",
          label="A",
          x=20,
          y=20,
          status="stable",
          tap_message="select-a",
        ),
      ]),
    ]),
    @core.platform_adapter(
      platform=@core.Wechat,
      id="wechat-lite",
      page_component="page",
      tap_event="bindtap",
      supports_canvas=false,
    ),
    preference=@scene.PreferCanvasSurface,
  )
  let quality = @scene.plan_scene_visual_quality_with_budget(
    @scene.scene("map", @scene.scene_size(120, 80), [
      @scene.layer("markers", 1, [@scene.marker(id="a", label="A", x=20, y=20)]),
    ]),
    @scene.scene_render_budget(max_layers=1, max_markers=1, max_static_assets=1),
    @scene.scene_asset_budget(
      max_assets=0,
      max_package_bytes=1,
      max_remote_assets=0,
    ),
    @scene.default_scene_visual_quality_budget(),
  )
  let thread_plan = @scene.plan_scene_threads_with_budget(
    @scene.scene("map", @scene.scene_size(320, 240), [
      @scene.layer("markers", 1, [@scene.marker(id="a", label="A", x=20, y=20)]),
    ]),
    [
      @scene.scene_marker_thread_link(
        id="thread-a",
        scene_id="map",
        marker_id="a",
        thread_id="comm-thread-a",
        unread_count=9,
        open_message="open-thread-a",
      ),
      @scene.scene_marker_thread_link(
        id="thread-orphan",
        scene_id="map",
        marker_id="missing",
        thread_id="comm-thread-missing",
        unread_count=3,
      ),
    ],
    @scene.scene_thread_budget(
      max_visible_links=1,
      max_unread_total=8,
      max_orphan_links=0,
      max_links_without_open_message=0,
    ),
  )
  let camera_plan = @scene.plan_scene_camera_with_budget(
    @scene.scene("map", @scene.scene_size(320, 240), [
      @scene.layer("markers", 1, [@scene.marker(id="a", label="A", x=20, y=20)]),
    ]),
    @scene.scene_camera(
      scene_id="wrong-map",
      x=999,
      y=999,
      width=80,
      height=80,
      zoom_percent=600,
    ),
    @scene.scene_camera_budget(
      min_zoom_percent=50,
      max_zoom_percent=300,
      min_viewport_width=64,
      min_viewport_height=64,
    ),
  )
  let profile = profile_wechat_project(
    project,
    patches,
    effect_plans=[
      @effects.plan_effects_for_platform(
        [
          @effects.cloud_function("refresh", "refreshSnapshot", "snapshot"),
          @effects.stream("agent-stream", "/agent/stream", "thread"),
        ],
        @core.TikTok,
      ),
    ],
    communication_plans=[
      @agent.plan_communications_with_budget(
        [
          @agent.review_request(
            id="comm-review",
            thread_id="thread-profile",
            from_actor_id="agent-a",
            to_actor_id="operator",
            text="Approve?",
            artifact_ref="artifact://profile",
          ),
          @agent.tool_result(
            id="comm-tool",
            thread_id="thread-profile",
            from_actor_id="agent-a",
            text="Ready.",
            artifact_ref="artifact://profile",
          ),
        ],
        @agent.communication_budget(
          max_visible_count=1,
          max_review_request_count=0,
          max_unresolved_review_count=0,
          max_artifact_ref_count=1,
        ),
      ),
    ],
    tool_result_plans=[
      @agent.plan_tool_result_cards_with_budget(
        [
          @agent.tool_result_card(
            id="tool-a",
            tool_name="profile-tool",
            title="Profile result",
            summary="Needs review.",
            artifact_ref="artifact://profile",
            status=@agent.WaitingReview,
            acknowledge_message="ack-profile",
          ),
          @agent.tool_result_card(
            id="tool-b",
            tool_name="profile-tool",
            title="Profile result two",
            summary="Missing acknowledgment.",
            artifact_ref="artifact://profile-two",
            status=@agent.WaitingReview,
          ),
        ],
        @agent.tool_result_budget(
          max_visible_count=1,
          max_pending_ack_count=0,
          max_missing_ack_count=0,
          max_artifact_ref_count=1,
        ),
      ),
    ],
    agent_delta_plans=[
      @agent.plan_agent_deltas([
        @agent.append_stream_chunk_delta(
          "agent.streamChunks", "chunk-1", "first",
        ),
        @agent.append_stream_chunk_delta(
          "agent.streamChunks", "chunk-1", "second",
        ),
      ]),
    ],
    backend_plans=[backend],
    snapshot_plans=[
      @effects.plan_snapshot_deltas_with_budget(
        [
          @effects.replace_snapshot_delta("profile", "{\"all\":true}"),
          @effects.append_snapshot_item_delta(
            "profile", "messages", "msg-1", "{\"id\":\"msg-1\"}",
          ),
          @effects.append_snapshot_item_delta(
            "profile", "messages", "msg-1", "{\"id\":\"msg-1\"}",
          ),
        ],
        @core.patch_budget(max_patches=2, max_patch_bytes=64),
      ),
    ],
    asset_plans=[assets],
    thread_plans=[thread_plan],
    camera_plans=[camera_plan],
    scene_plans=[scene],
    surface_plans=[constrained_surface],
    quality_plans=[quality],
  )
  assert_eq(profile.effect_count, 2)
  assert_eq(profile.cloud_function_count, 1)
  assert_eq(profile.stream_effect_count, 1)
  assert_eq(profile.backend_endpoint_count, 3)
  assert_eq(profile.backend_streaming_count, 0)
  assert_eq(profile.backend_review_required_count, 1)
  assert_eq(profile.backend_cancel_count, 1)
  assert_eq(profile.backend_retry_count, 1)
  assert_true(profile.summary.contains("backend_cancels=1"))
  assert_true(profile.summary.contains("backend_retries=1"))
  assert_eq(profile.communication_count, 2)
  assert_eq(profile.communication_visible_count, 1)
  assert_eq(profile.communication_unresolved_review_count, 1)
  assert_eq(profile.communication_artifact_ref_count, 2)
  assert_eq(profile.tool_result_count, 2)
  assert_eq(profile.tool_result_visible_count, 1)
  assert_eq(profile.tool_result_pending_ack_count, 1)
  assert_eq(profile.tool_result_missing_ack_count, 1)
  assert_eq(profile.tool_result_artifact_ref_count, 2)
  assert_eq(profile.agent_delta_count, 2)
  assert_eq(profile.agent_duplicate_stream_chunk_count, 1)
  assert_eq(profile.scene_thread_link_count, 2)
  assert_eq(profile.scene_thread_visible_link_count, 1)
  assert_eq(profile.scene_thread_unread_total, 12)
  assert_eq(profile.scene_thread_orphan_link_count, 1)
  assert_eq(profile.scene_camera_count, 1)
  assert_eq(profile.scene_camera_clamped_count, 1)
  assert_eq(profile.snapshot_delta_count, 3)
  assert_eq(profile.snapshot_section_update_count, 0)
  assert_eq(profile.snapshot_append_item_count, 2)
  assert_eq(profile.snapshot_full_replace_count, 1)
  assert_true(
    profile.diagnostics.contains(
      "effect:effect-cloud-function-unsupported:tiktok:1",
    ),
  )
  assert_true(
    profile.diagnostics.contains("agent-delta:agent-stream-chunk-duplicate:1"),
  )
  assert_true(
    profile.diagnostics.contains(
      "communication:communication-visible-over-budget:2/1",
    ),
  )
  assert_true(
    profile.diagnostics.contains(
      "communication:communication-unresolved-reviews-over-budget:1/0",
    ),
  )
  assert_true(
    profile.diagnostics.contains(
      "tool-result:tool-results-visible-over-budget:2/1",
    ),
  )
  assert_true(
    profile.diagnostics.contains(
      "tool-result:tool-results-pending-acks-over-budget:1/0",
    ),
  )
  assert_true(
    profile.diagnostics.contains("tool-result:tool-results-missing-acks:1/0"),
  )
  assert_true(
    profile.diagnostics.contains(
      "tool-result:tool-results-artifacts-over-budget:2/1",
    ),
  )
  assert_true(
    profile.diagnostics.contains(
      "scene-threads:scene-thread-links-over-budget:2/1",
    ),
  )
  assert_true(
    profile.diagnostics.contains(
      "scene-threads:scene-thread-unread-over-budget:12/8",
    ),
  )
  assert_true(
    profile.diagnostics.contains("scene-threads:scene-thread-orphan-links:1/0"),
  )
  assert_true(
    profile.diagnostics.contains(
      "scene-camera:scene-camera-scene-mismatch:wrong-map/map",
    ),
  )
  assert_true(
    profile.diagnostics.contains(
      "scene-camera:scene-camera-zoom-over-max:600/300",
    ),
  )
  assert_true(
    profile.diagnostics.contains(
      "scene-camera:scene-camera-clamped:999,999/256,176",
    ),
  )
  assert_true(
    profile.diagnostics.contains("snapshot:snapshot-delta-full-replace:profile"),
  )
  assert_true(
    profile.diagnostics.contains(
      "snapshot:snapshot-delta-duplicate-item:profile.messages:msg-1",
    ),
  )
  assert_true(
    profile.diagnostics.contains("snapshot:patch-count-over-budget:3/2"),
  )
  assert_true(
    profile.diagnostics.contains(
      "render:pages/large/index:node-count-over-budget:1802/800",
    ),
  )
  assert_true(
    profile.diagnostics.contains(
      "render:pages/large/index:event-count-over-budget:900/160",
    ),
  )
  assert_true(
    !profile.diagnostics.contains(
      "wechat:wechat-render:pages/large/index:node-count-over-budget:1802/800",
    ),
  )
  assert_true(
    contains_prefix(
      profile.diagnostics,
      "wechat:wechat-wxml-bytes-over-budget:",
    ),
  )
  assert_true(profile.diagnostics.contains("patch:patch-count-over-budget:1/0"))
  assert_true(
    profile.diagnostics.contains(
      "backend:backend-endpoint-count-over-budget:3/0",
    ),
  )
  assert_true(
    profile.diagnostics.contains(
      "scene-assets:scene-package-bytes-over-budget:2048/1",
    ),
  )
  assert_true(
    profile.diagnostics.contains("scene-assets:scene-deferred-assets:1"),
  )
  assert_true(
    profile.diagnostics.contains(
      "scene-assets:scene-remote-assets-over-budget:1/0",
    ),
  )
  assert_true(
    profile.diagnostics.contains(
      "scene-assets:scene-remote-asset-domain-unapproved:remote:assets.example.test",
    ),
  )
  assert_true(
    profile.diagnostics.contains(
      "scene-assets:scene-unapproved-remote-assets:1",
    ),
  )
  assert_true(
    profile.diagnostics.contains(
      "scene-render:scene-marker-count-over-budget:2/1",
    ),
  )
  assert_true(
    profile.diagnostics.contains(
      "scene-surface:scene-canvas-unsupported:wechat-lite",
    ),
  )
  assert_true(
    profile.diagnostics.contains(
      "scene-quality:scene-markers-without-status:1/0",
    ),
  )
  assert_eq(profile.scene_static_surface_count, 1)
  assert_eq(profile.scene_canvas_surface_count, 0)
  assert_eq(profile.scene_lightweight_surface_count, 0)
  assert_eq(profile.scene_surface_fallback_count, 1)
  assert_eq(profile.scene_remote_asset_count, 1)
  assert_eq(profile.scene_insecure_remote_asset_count, 0)
  assert_eq(profile.scene_unapproved_remote_asset_count, 1)
  assert_eq(profile.scene_deferred_asset_count, 1)
  assert_true(profile.scene_quality_issue_count > 0)
  assert_eq(profile.degraded_scene_count, 1)
  let relaxed_gate = gate_build_profile(
    profile,
    build_profile_budget(
      max_agent_duplicate_stream_chunks=1,
      max_snapshot_full_replaces=1,
      max_scene_thread_orphans=1,
      max_scene_camera_clamped=1,
      max_scene_surface_fallbacks=1,
      max_scene_quality_issues=profile.scene_quality_issue_count,
      max_degraded_scenes=1,
    ),
    budget_profile="relaxed",
  )
  let strict_gate = gate_build_profile(
    profile,
    build_profile_budget_for_profile("tight"),
    budget_profile="tight",
  )
  assert_eq(relaxed_gate.diagnostics.length(), 0)
  assert_true(relaxed_gate.summary.contains("budget=relaxed"))
  assert_true(
    strict_gate.diagnostics.contains(
      "profile-agent-duplicate-stream-chunks-over-budget:1/0",
    ),
  )
  assert_true(
    strict_gate.diagnostics.contains(
      "profile-snapshot-full-replaces-over-budget:1/0",
    ),
  )
  assert_true(
    strict_gate.diagnostics.contains(
      "profile-scene-thread-orphans-over-budget:1/0",
    ),
  )
  assert_true(
    strict_gate.diagnostics.contains(
      "profile-scene-camera-clamped-over-budget:1/0",
    ),
  )
  assert_true(
    strict_gate.diagnostics.contains(
      "profile-scene-surface-fallbacks-over-budget:1/0",
    ),
  )
  assert_true(
    contains_prefix(
      strict_gate.diagnostics,
      "profile-scene-quality-issues-over-budget:",
    ),
  )
  assert_true(
    strict_gate.diagnostics.contains("profile-degraded-scenes-over-budget:1/0"),
  )
  assert_true(strict_gate.summary.contains("max_scene_surface_fallbacks=0"))
  assert_true(profile.summary.contains("diagnostics="))
}

///|
fn fixture_root() -> @core.Node {
  @core.page([
    @core.view([
      @core.view([@core.button("Open", "open"), @core.button("Close", "close")]),
    ]),
  ])
}

///|
fn large_fixture_root(count : Int) -> @core.Node {
  let buttons : Array[@core.Node] = []
  for i in 0..<count {
    buttons.push(@core.button("Open \{i}", "open-\{i}"))
  }
  @core.page([@core.view(buttons)])
}

///|
fn contains_prefix(items : Array[String], prefix : String) -> Bool {
  for item in items {
    if item.has_prefix(prefix) {
      return true
    }
  }
  false
}

///|
fn count_occurrence(items : Array[String], expected : String) -> Int {
  let mut count = 0
  for item in items {
    if item == expected {
      count += 1
    }
  }
  count
}

///|
fn count_prefix(items : Array[String], prefix : String) -> Int {
  let mut count = 0
  for item in items {
    if item.has_prefix(prefix) {
      count += 1
    }
  }
  count
}
