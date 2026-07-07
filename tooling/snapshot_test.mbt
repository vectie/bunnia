///|
test "generated snapshots record deterministic file pressure" {
  let project = @wechat.generate_project_with_runtime(
    name="Snapshot Fixture",
    route="pages/snapshot/index",
    root=@core.page([@core.button("Open", "open")]),
    runtime=@wechat.runtime(event_patches=[
      @wechat.event_patch("open", [@core.set_string("state.open", "yes")]),
    ]),
  )
  let patches = @core.plan_patches([@core.set_string("state.open", "yes")])
  let profile = profile_wechat_project(project, patches)
  let snapshot = snapshot_wechat_project(
    target="wechat",
    example="snapshot_fixture",
    project,
    profile,
  )
  assert_eq(snapshot.target, "wechat")
  assert_eq(snapshot.example, "snapshot_fixture")
  assert_eq(snapshot.budget_profile, "default")
  assert_eq(snapshot.render_budget_profile, "default")
  assert_eq(snapshot.route, "pages/snapshot/index")
  assert_eq(snapshot.file_count, project.files.length())
  assert_eq(snapshot.total_bytes, project.total_bytes)
  assert_eq(snapshot.max_update_operation_count, 1)
  assert_eq(snapshot.route_diagnostic_route_count, 0)
  assert_eq(snapshot.route_diagnostic_count, 0)
  assert_eq(snapshot.unwindowed_list_child_count, 0)
  assert_eq(snapshot.unkeyed_list_child_count, 0)
  assert_eq(snapshot.duplicate_list_key_count, 0)
  assert_eq(snapshot.communication_unresolved_review_count, 0)
  assert_eq(snapshot.tool_result_missing_ack_count, 0)
  assert_eq(snapshot.agent_duplicate_stream_chunk_count, 0)
  assert_eq(snapshot.snapshot_full_replace_count, 0)
  assert_eq(snapshot.scene_asset_count, 0)
  assert_eq(snapshot.scene_remote_asset_count, 0)
  assert_eq(snapshot.scene_thread_orphan_link_count, 0)
  assert_eq(snapshot.scene_camera_clamped_count, 0)
  assert_eq(snapshot.scene_surface_fallback_count, 0)
  assert_eq(snapshot.scene_quality_issue_count, 0)
  assert_eq(snapshot.degraded_scene_count, 0)
  assert_eq(snapshot.top_route, "pages/snapshot/index")
  assert_true(snapshot.route_risk_score > 0)
  assert_eq(snapshot.profile_gate_diagnostic_count, 0)
  assert_eq(snapshot.inspection_gate_diagnostic_count, 0)
  assert_eq(snapshot.diagnostic_count, 0)
  assert_true(snapshot.summary.contains("files=10"))
  assert_true(snapshot.summary.contains("risk_route=pages/snapshot/index"))
  assert_true(snapshot.summary.contains("risk_score="))
  assert_true(snapshot.summary.contains("route_diagnostic_routes=0"))
  assert_true(snapshot.summary.contains("route_diagnostics=0"))
  assert_true(snapshot.summary.contains("unwindowed_list_children=0"))
  assert_true(snapshot.summary.contains("unkeyed_list_children=0"))
  assert_true(snapshot.summary.contains("duplicate_list_keys=0"))
  assert_true(snapshot.summary.contains("communication_unresolved_reviews=0"))
  assert_true(snapshot.summary.contains("tool_result_missing_acks=0"))
  assert_true(snapshot.summary.contains("agent_duplicate_stream_chunks=0"))
  assert_true(snapshot.summary.contains("snapshot_full_replaces=0"))
  assert_true(snapshot.summary.contains("scene_assets=0"))
  assert_true(snapshot.summary.contains("scene_remote_assets=0"))
  assert_true(snapshot.summary.contains("scene_thread_orphans=0"))
  assert_true(snapshot.summary.contains("scene_camera_clamped=0"))
  assert_true(snapshot.summary.contains("scene_surface_fallbacks=0"))
  assert_true(snapshot.summary.contains("scene_quality_issues=0"))
  assert_true(snapshot.summary.contains("degraded_scenes=0"))
  assert_true(snapshot.summary.contains("profile_gate_diagnostics=0"))
  assert_true(snapshot.summary.contains("inspection_gate_diagnostics=0"))
  assert_true(snapshot.content.contains("bunnia-generated-snapshot-v1"))
  assert_true(snapshot.content.contains("budget_profile=default"))
  assert_true(snapshot.content.contains("render_budget_profile=default"))
  assert_true(snapshot.content.contains("route=pages/snapshot/index"))
  assert_true(snapshot.content.contains("risk_route=pages/snapshot/index"))
  assert_true(snapshot.content.contains("max_update_ops=1"))
  assert_true(snapshot.content.contains("risk_score="))
  assert_true(snapshot.content.contains("route_diagnostic_routes=0"))
  assert_true(snapshot.content.contains("route_diagnostics=0"))
  assert_true(snapshot.content.contains("unwindowed_list_children=0"))
  assert_true(snapshot.content.contains("unkeyed_list_children=0"))
  assert_true(snapshot.content.contains("duplicate_list_keys=0"))
  assert_true(snapshot.content.contains("communication_unresolved_reviews=0"))
  assert_true(snapshot.content.contains("tool_result_missing_acks=0"))
  assert_true(snapshot.content.contains("agent_duplicate_stream_chunks=0"))
  assert_true(snapshot.content.contains("snapshot_full_replaces=0"))
  assert_true(snapshot.content.contains("scene_assets=0"))
  assert_true(snapshot.content.contains("scene_remote_assets=0"))
  assert_true(snapshot.content.contains("scene_thread_orphans=0"))
  assert_true(snapshot.content.contains("scene_camera_clamped=0"))
  assert_true(snapshot.content.contains("scene_surface_fallbacks=0"))
  assert_true(snapshot.content.contains("scene_quality_issues=0"))
  assert_true(snapshot.content.contains("degraded_scenes=0"))
  assert_true(snapshot.content.contains("profile_gate_diagnostics=0"))
  assert_true(snapshot.content.contains("inspection_gate_diagnostics=0"))
  assert_true(snapshot.content.contains("report=Bunnia WeChat build report:"))
  assert_true(snapshot.content.contains("profile=Bunnia build profile:"))
  assert_true(
    snapshot.content.contains(
      "profile_gate=Bunnia build profile gate: budget=default",
    ),
  )
  assert_true(
    snapshot.content.contains("inspection=Bunnia project inspection:"),
  )
  assert_true(
    snapshot.content.contains(
      "inspection_gate=Bunnia inspection gate: budget=default",
    ),
  )
  assert_true(
    snapshot.content.contains(
      "route_inspections:\n- pages/snapshot/index status=ok",
    ),
  )
  assert_true(snapshot.content.contains("update_ops=1"))
  assert_true(snapshot.content.contains("scene_remote_assets=0"))
  assert_true(snapshot.content.contains("scene_assets:\nroute_diagnostics:"))
  assert_true(
    snapshot.content.contains(
      "route_diagnostics:\nreport_diagnostics:\nprofile_diagnostics:",
    ),
  )
  assert_true(
    snapshot.content.contains(
      "profile_gate_diagnostics:\ninspection_gate_diagnostics:\nfiles:",
    ),
  )
  assert_true(snapshot.content.contains("- app.json kind=json bytes="))
  assert_true(snapshot.content.contains("- bunnia.runtime.js kind=js bytes="))
  assert_true(snapshot.content.contains("- app.wxss kind=wxss bytes="))
  assert_true(snapshot.content.contains("pages/snapshot/index.wxml kind=wxml"))
  assert_true(
    snapshot.content.contains("pages/snapshot/index.data.js kind=page-data"),
  )
  assert_true(snapshot.content.contains("checksum="))
  assert_true(!snapshot.content.contains("checksum=-"))
}

///|
test "generic miniapp snapshots record route and file pressure" {
  let project = @miniapp.generate_project_with_budget(
    name="Generic Snapshot",
    route="pages/generic/index",
    root=@core.page([
      @core.view([@core.button("Open", "open"), @core.text("Generic")]),
    ]),
    platform=@core.TikTok,
    render_budget=@core.render_budget(
      max_nodes=32,
      max_depth=8,
      max_events=8,
      max_initial_data_bytes=2048,
      max_scene_markers=8,
      max_scene_regions=8,
      max_scene_assets=8,
    ),
  )
  let inspection = inspect_miniapp_project(
    target="tiktok",
    example="generic_snapshot",
    project,
  )
  let inspection_gate = gate_miniapp_inspection(
    inspection,
    miniapp_inspection_budget_for_profile("tight"),
    budget_profile="tight",
  )
  let release = miniapp_release_readiness_report(
    target="tiktok",
    example="generic_snapshot",
    budget_profile="tight",
    project,
    inspection,
    inspection_gate,
  )
  let snapshot = snapshot_miniapp_project(
    target="tiktok",
    example="generic_snapshot",
    project,
    inspection,
    inspection_gate,
    release,
    budget_profile="tight",
    render_budget_profile="tight",
  )
  assert_eq(snapshot.target, "tiktok")
  assert_eq(snapshot.example, "generic_snapshot")
  assert_eq(snapshot.route, "pages/generic/index")
  assert_eq(snapshot.file_count, project.files.length())
  assert_eq(snapshot.total_bytes, project.total_bytes)
  assert_eq(snapshot.max_update_payload_bytes, 0)
  assert_eq(snapshot.max_update_operation_count, 0)
  assert_eq(snapshot.route_diagnostic_count, 0)
  assert_eq(snapshot.inspection_gate_diagnostic_count, 0)
  assert_eq(snapshot.diagnostic_count, 0)
  assert_eq(snapshot.top_route, "pages/generic/index")
  assert_true(snapshot.route_risk_score > 0)
  assert_true(snapshot.summary.contains("generic miniapp snapshot"))
  assert_true(snapshot.summary.contains("release_status=ready"))
  assert_true(snapshot.content.contains("bunnia-generated-snapshot-v1"))
  assert_true(snapshot.content.contains("target=tiktok"))
  assert_true(snapshot.content.contains("render_budget_profile=tight"))
  assert_true(
    snapshot.content.contains(
      "release=Bunnia generic miniapp release readiness:",
    ),
  )
  assert_true(
    snapshot.content.contains(
      "route_inspections:\n- pages/generic/index status=ok",
    ),
  )
  assert_true(snapshot.content.contains("update_payload=0"))
  assert_true(snapshot.content.contains("route_diagnostics:"))
  assert_true(
    snapshot.content.contains(
      "inspection_gate_diagnostics:\nrelease_diagnostics:",
    ),
  )
  assert_true(snapshot.content.contains("pages/generic/index.ttml kind=ttml"))
  assert_true(snapshot.content.contains("pages/generic/index.ttss kind=ttss"))
  assert_true(snapshot.content.contains("checksum="))
}

///|
test "generated snapshots expose agent and map pressure counters" {
  let scene = @scene.scene("map", @scene.scene_size(120, 80), [
    @scene.layer("markers", 1, [@scene.marker(id="a", label="A", x=20, y=20)]),
  ])
  let project = @wechat.generate_project(
    name="Snapshot Pressure",
    route="pages/pressure/index",
    root=@core.page([
      @core.list(["agent", "map"], value => @core.view([@core.text(value)])),
      @core.list(["one", "two"], value => {
        @core.keyed("duplicate-row", @core.view([@core.text(value)]))
      }),
    ]),
  )
  let profile = profile_wechat_project(
    project,
    @core.plan_patches([]),
    communication_plans=[
      @agent.plan_communications([
        @agent.review_request(
          id="review",
          thread_id="thread",
          from_actor_id="agent",
          to_actor_id="human",
          text="Review needed",
        ),
      ]),
    ],
    tool_result_plans=[
      @agent.plan_tool_result_cards([
        @agent.tool_result_card(
          id="tool",
          tool_name="search",
          title="Search",
          summary="Waiting for acknowledgment",
          status=@agent.WaitingReview,
        ),
      ]),
    ],
    agent_delta_plans=[
      @agent.plan_agent_deltas([
        @agent.append_stream_chunk_delta("agent.stream", "chunk", "first"),
        @agent.append_stream_chunk_delta("agent.stream", "chunk", "second"),
      ]),
    ],
    snapshot_plans=[
      @effects.plan_snapshot_deltas([
        @effects.replace_snapshot_delta("projection", "{\"all\":true}"),
      ]),
    ],
    thread_plans=[
      @scene.plan_scene_threads(scene, [
        @scene.scene_marker_thread_link(
          id="thread-link",
          scene_id="map",
          marker_id="missing",
          thread_id="thread",
        ),
      ]),
    ],
    camera_plans=[
      @scene.plan_scene_camera(
        scene,
        @scene.scene_camera(
          scene_id="wrong-map",
          x=999,
          y=999,
          width=40,
          height=40,
          zoom_percent=600,
        ),
      ),
    ],
    surface_plans=[
      @scene.plan_scene_surface(
        scene,
        @core.platform_adapter(
          platform=@core.Wechat,
          id="wechat-lite",
          page_component="page",
          tap_event="bindtap",
          supports_canvas=false,
        ),
        preference=@scene.PreferCanvasSurface,
      ),
    ],
    quality_plans=[@scene.plan_scene_visual_quality(scene)],
  )
  let snapshot = snapshot_wechat_project(
    target="wechat",
    example="snapshot_pressure",
    project,
    profile,
  )
  assert_eq(snapshot.unwindowed_list_child_count, 4)
  assert_eq(snapshot.unkeyed_list_child_count, 2)
  assert_eq(snapshot.duplicate_list_key_count, 1)
  assert_eq(snapshot.communication_unresolved_review_count, 1)
  assert_eq(snapshot.tool_result_missing_ack_count, 1)
  assert_eq(snapshot.agent_duplicate_stream_chunk_count, 1)
  assert_eq(snapshot.snapshot_full_replace_count, 1)
  assert_eq(snapshot.scene_thread_orphan_link_count, 1)
  assert_eq(snapshot.scene_camera_clamped_count, 1)
  assert_eq(snapshot.scene_surface_fallback_count, 1)
  assert_eq(snapshot.scene_quality_issue_count, 5)
  assert_eq(snapshot.degraded_scene_count, 1)
  assert_true(snapshot.summary.contains("unwindowed_list_children=4"))
  assert_true(snapshot.summary.contains("unkeyed_list_children=2"))
  assert_true(snapshot.summary.contains("duplicate_list_keys=1"))
  assert_true(snapshot.summary.contains("communication_unresolved_reviews=1"))
  assert_true(snapshot.summary.contains("tool_result_missing_acks=1"))
  assert_true(snapshot.summary.contains("agent_duplicate_stream_chunks=1"))
  assert_true(snapshot.summary.contains("snapshot_full_replaces=1"))
  assert_true(snapshot.summary.contains("scene_thread_orphans=1"))
  assert_true(snapshot.summary.contains("scene_camera_clamped=1"))
  assert_true(snapshot.summary.contains("scene_surface_fallbacks=1"))
  assert_true(snapshot.summary.contains("scene_quality_issues=5"))
  assert_true(snapshot.summary.contains("degraded_scenes=1"))
  assert_true(snapshot.content.contains("unwindowed_list_children=4"))
  assert_true(snapshot.content.contains("unkeyed_list_children=2"))
  assert_true(snapshot.content.contains("duplicate_list_keys=1"))
  assert_true(snapshot.content.contains("communication_unresolved_reviews=1"))
  assert_true(snapshot.content.contains("tool_result_missing_acks=1"))
  assert_true(snapshot.content.contains("agent_duplicate_stream_chunks=1"))
  assert_true(snapshot.content.contains("snapshot_full_replaces=1"))
  assert_true(snapshot.content.contains("scene_thread_orphans=1"))
  assert_true(snapshot.content.contains("scene_camera_clamped=1"))
  assert_true(snapshot.content.contains("scene_surface_fallbacks=1"))
  assert_true(snapshot.content.contains("scene_quality_issues=5"))
  assert_true(snapshot.content.contains("degraded_scenes=1"))
}

///|
test "generated snapshots expose route scene asset references" {
  let project = @wechat.generate_project(
    name="Snapshot Scene Assets",
    route="pages/assets/index",
    root=@core.page([
      @core.node(kind="image", attrs=[
        @core.class_name("bunnia-scene-sprite"),
        @core.attr("src", "/assets/agent.png"),
        @core.attr("alt", "Agent"),
        @core.data("asset-id", "agent"),
        @core.data("asset-kind", "sprite"),
        @core.data("asset-remote", "false"),
      ]),
      @core.node(kind="image", attrs=[
        @core.class_name("bunnia-scene-pin"),
        @core.attr("src", "https://cdn.example.test/pin.png"),
        @core.attr("alt", "Pin"),
        @core.data("asset-id", "pin"),
        @core.data("asset-kind", "remote-image"),
        @core.data("asset-remote", "true"),
      ]),
    ]),
  )
  let snapshot = snapshot_wechat_project(
    target="wechat",
    example="snapshot_scene_assets",
    project,
    profile_wechat_project(project, @core.plan_patches([])),
  )
  assert_eq(snapshot.scene_asset_count, 2)
  assert_eq(snapshot.scene_remote_asset_count, 1)
  assert_true(snapshot.summary.contains("scene_assets=2"))
  assert_true(snapshot.summary.contains("scene_remote_assets=1"))
  assert_true(snapshot.content.contains("scene_assets=2"))
  assert_true(snapshot.content.contains("scene_remote_assets=1"))
  assert_true(
    snapshot.content.contains(
      "scene_assets:\n- pages/assets/index:agent kind=sprite src=/assets/agent.png remote=false",
    ),
  )
  assert_true(
    snapshot.content.contains(
      "route_inspections:\n- pages/assets/index status=ok",
    ),
  )
  assert_true(snapshot.content.contains("scene_remote_assets=1"))
  assert_true(
    snapshot.content.contains(
      "- pages/assets/index:pin kind=remote-image src=https://cdn.example.test/pin.png remote=true",
    ),
  )
}

///|
test "generated snapshots classify backend adapter files" {
  let project = @wechat.generate_project_with_runtime_and_backend(
    name="Snapshot Backend Fixture",
    route="pages/snapshot/index",
    root=@core.page([@core.button("Send", "send-message")]),
    runtime=@wechat.runtime(event_patches=[
      @wechat.event_patch("send-message", [
        @core.set_string("backend.send-message.state", "loading"),
      ]),
    ]),
    backend_contract=@effects.backend_contract(id="snapshot-backend", endpoints=[
      @effects.agent_message_endpoint(
        "send-message", "/agent/message", "draftMessage", "messageResult",
      ),
    ]),
  )
  let snapshot = snapshot_wechat_project(
    target="wechat",
    example="snapshot_backend_fixture",
    project,
    profile_wechat_project(project, @core.plan_patches([])),
  )
  assert_true(snapshot.summary.contains("files=11"))
  assert_true(
    snapshot.content.contains("- bunnia.backend.js kind=backend-js bytes="),
  )
}

///|
test "generated snapshots record profile gate diagnostics" {
  let project = @wechat.generate_project(
    name="Snapshot Profile Gate",
    route="pages/profile-gate/index",
    root=@core.page([@core.text("Profile gate")]),
  )
  let profile = profile_wechat_project(
    project,
    @core.plan_patches([]),
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
    snapshot_plans=[
      @effects.plan_snapshot_deltas([
        @effects.replace_snapshot_delta("profile", "{\"all\":true}"),
      ]),
    ],
  )
  let snapshot = snapshot_wechat_project_with_report(
    target="wechat",
    example="snapshot_profile_gate",
    project,
    project.report,
    profile,
    budget_profile="tight",
    render_budget_profile="tight",
  )
  assert_eq(snapshot.profile_gate_diagnostic_count, 2)
  assert_true(snapshot.summary.contains("profile_gate_diagnostics=2"))
  assert_true(snapshot.content.contains("profile_gate_diagnostics=2"))
  assert_true(
    snapshot.content.contains(
      "profile_gate=Bunnia build profile gate: budget=tight",
    ),
  )
  assert_true(
    snapshot.content.contains(
      "profile_gate_diagnostics:\n- profile-agent-duplicate-stream-chunks-over-budget:1/0",
    ),
  )
  assert_true(
    snapshot.content.contains(
      "- profile-snapshot-full-replaces-over-budget:1/0",
    ),
  )
  assert_eq(
    snapshot.diagnostic_count,
    profile.diagnostics.length() + snapshot.profile_gate_diagnostic_count,
  )
}

///|
test "generated snapshots can record active build report diagnostics" {
  let project = @wechat.generate_project_with_runtime(
    name="Snapshot Budget Fixture",
    route="pages/snapshot/index",
    root=@core.page([@core.button("Open", "open")]),
    runtime=@wechat.runtime(event_patches=[
      @wechat.event_patch("open", [@core.set_string("state.open", "yes")]),
    ]),
  )
  let profile = profile_wechat_project(
    project,
    @core.plan_patches([@core.set_string("state.open", "yes")]),
  )
  let report = @wechat.report_project_with_budget(
    project,
    @wechat.default_runtime(),
    @wechat.build_budget(
      max_pages=1,
      max_files=1,
      max_total_bytes=128,
      max_wxml_bytes=128,
      max_wxss_bytes=128,
      max_js_bytes=128,
      max_initial_data_bytes=4,
      max_event_patch_bytes=4,
      max_event_patch_operations=0,
      max_page_first_screen_bytes=4,
      max_page_update_payload_bytes=4,
      max_page_update_operations=0,
    ),
  )
  let snapshot = snapshot_wechat_project_with_report(
    target="wechat",
    example="snapshot_budget_fixture",
    project,
    report,
    profile,
    budget_profile="tiny",
    render_budget_profile="tiny-render",
  )
  assert_eq(snapshot.budget_profile, "tiny")
  assert_eq(snapshot.render_budget_profile, "tiny-render")
  assert_eq(snapshot.route_diagnostic_route_count, 0)
  assert_eq(snapshot.route_diagnostic_count, 0)
  assert_eq(snapshot.top_route, "pages/snapshot/index")
  assert_true(snapshot.route_risk_score > 0)
  assert_eq(snapshot.profile_gate_diagnostic_count, 0)
  assert_true(snapshot.inspection_gate_diagnostic_count > 0)
  assert_eq(
    snapshot.diagnostic_count,
    report.diagnostics.length() +
    snapshot.profile_gate_diagnostic_count +
    snapshot.inspection_gate_diagnostic_count,
  )
  assert_true(snapshot.diagnostic_count > 0)
  assert_true(snapshot.summary.contains("diagnostics="))
  assert_true(snapshot.summary.contains("profile_gate_diagnostics=0"))
  assert_true(snapshot.summary.contains("inspection_gate_diagnostics="))
  assert_true(snapshot.summary.contains("budget=tiny"))
  assert_true(snapshot.summary.contains("render_budget=tiny-render"))
  assert_true(
    snapshot.content.contains("diagnostics=\{snapshot.diagnostic_count}"),
  )
  assert_true(
    snapshot.content.contains(
      "profile_gate_diagnostics=\{snapshot.profile_gate_diagnostic_count}",
    ),
  )
  assert_true(
    snapshot.content.contains(
      "inspection_gate_diagnostics=\{snapshot.inspection_gate_diagnostic_count}",
    ),
  )
  assert_true(snapshot.content.contains("budget_profile=tiny"))
  assert_true(snapshot.content.contains("render_budget_profile=tiny-render"))
  assert_true(snapshot.content.contains("risk_route=pages/snapshot/index"))
  assert_true(snapshot.content.contains("max_update_ops=1"))
  assert_true(snapshot.content.contains("route_inspections:"))
  assert_true(snapshot.content.contains("report=Bunnia WeChat build report:"))
  assert_true(
    snapshot.content.contains("profile_gate=Bunnia build profile gate:"),
  )
  assert_true(snapshot.content.contains("route_diagnostics:"))
  assert_true(snapshot.content.contains("report_diagnostics:\n- wechat-"))
  assert_true(
    snapshot.content.contains("wechat-page-update-operations-over-budget"),
  )
  assert_true(snapshot.content.contains("profile_diagnostics:"))
  assert_true(snapshot.content.contains("profile_gate_diagnostics:"))
  assert_true(
    snapshot.content.contains(
      "inspection_gate_diagnostics:\n- inspection-route-risk-over-budget:pages/snapshot/index:",
    ),
  )
}

///|
test "generated snapshots include route-scoped manifest diagnostics" {
  let runtime = @wechat.runtime(
    initial_data_json="{\"agentDraft\":\"large payload\"}",
  )
  let project = @wechat.generate_project_with_runtime_and_budget(
    name="Snapshot Route Diagnostics",
    route="pages/route-diagnostics/index",
    root=@core.page([@core.button("Missing", "missing")]),
    runtime~,
    render_budget=@core.render_budget(
      max_nodes=16,
      max_depth=4,
      max_events=4,
      max_initial_data_bytes=8,
    ),
  )
  let snapshot = snapshot_wechat_project(
    target="wechat",
    example="snapshot_route_diagnostics",
    project,
    profile_wechat_project(project, @core.plan_patches([])),
  )
  assert_eq(snapshot.route_diagnostic_route_count, 1)
  assert_eq(snapshot.route_diagnostic_count, 2)
  assert_eq(snapshot.top_route, "pages/route-diagnostics/index")
  assert_true(snapshot.route_risk_score > 2000000)
  assert_true(snapshot.summary.contains("route_diagnostic_routes=1"))
  assert_true(
    snapshot.summary.contains("risk_route=pages/route-diagnostics/index"),
  )
  assert_true(snapshot.summary.contains("route_diagnostics=2"))
  assert_true(snapshot.content.contains("route_diagnostic_routes=1"))
  assert_true(
    snapshot.content.contains("risk_route=pages/route-diagnostics/index"),
  )
  assert_true(snapshot.content.contains("route_diagnostics=2"))
  assert_true(
    snapshot.content.contains(
      "route_inspections:\n- pages/route-diagnostics/index status=diagnostic",
    ),
  )
  assert_true(
    snapshot.content.contains(
      "route_diagnostics:\n- pages/route-diagnostics/index",
    ),
  )
  assert_true(
    snapshot.content.contains(
      "  - wechat-route-initial-data-over-render-budget:pages/route-diagnostics/index:30/8",
    ),
  )
  assert_true(
    snapshot.content.contains(
      "  - wechat-event-without-patch:pages/route-diagnostics/index:missing",
    ),
  )
}

///|
test "generated snapshots change checksums when generated file content changes" {
  let runtime = @wechat.runtime(event_patches=[
    @wechat.event_patch("open", [@core.set_string("state.open", "yes")]),
  ])
  let first = @wechat.generate_project_with_runtime(
    name="Snapshot Fixture",
    route="pages/snapshot/index",
    root=@core.page([@core.button("Open", "open")]),
    runtime~,
  )
  let second = @wechat.generate_project_with_runtime(
    name="Snapshot Fixture",
    route="pages/snapshot/index",
    root=@core.page([@core.button("Open now", "open")]),
    runtime~,
  )
  let first_snapshot = snapshot_wechat_project(
    target="wechat",
    example="snapshot_fixture",
    first,
    profile_wechat_project(first, @core.plan_patches([])),
  )
  let second_snapshot = snapshot_wechat_project(
    target="wechat",
    example="snapshot_fixture",
    second,
    profile_wechat_project(second, @core.plan_patches([])),
  )
  assert_true(first_snapshot.content != second_snapshot.content)
  assert_eq(first_snapshot.files.length(), second_snapshot.files.length())
}
