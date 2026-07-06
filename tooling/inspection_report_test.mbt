///|
test "project inspection identifies the heaviest clean route" {
  let project = @wechat.generate_project_from_pages(name="Inspection Fixture", pages=[
    @wechat.project_page(
      name="Home",
      route="pages/home/index",
      root=@core.page([@core.text("Home")]),
    ),
    @wechat.project_page(
      name="Ops",
      route="pages/ops/index",
      root=@core.page([
        @core.view([
          @core.text("Operations"),
          @core.button("Open", "open"),
          @core.button("Acknowledge", "ack"),
        ]),
      ]),
      runtime=@wechat.runtime(event_patches=[
        @wechat.event_patch("open", [@core.set_string("state.open", "yes")]),
        @wechat.event_patch("ack", [@core.set_string("state.ack", "yes")]),
      ]),
    ),
  ])
  let report = project.report
  let inspection = inspect_wechat_project(
    target="wechat",
    example="inspection_fixture",
    project,
    report,
  )
  assert_eq(inspection.route_count, 2)
  assert_eq(inspection.top_route, "pages/ops/index")
  assert_eq(inspection.total_diagnostics, 0)
  assert_eq(inspection.max_backend_event_count, 0)
  assert_eq(inspection.max_backend_cancel_count, 0)
  assert_eq(inspection.max_backend_retry_count, 0)
  assert_eq(inspection.max_scene_asset_count, 0)
  assert_eq(inspection.max_scene_remote_asset_count, 0)
  assert_eq(inspection.max_scene_package_bytes, 0)
  assert_eq(inspection.routes[1].diagnostics, 0)
  assert_eq(inspection.routes[1].scene_remote_asset_count, 0)
  assert_eq(inspection.routes[1].backend_event_count, 0)
  assert_eq(inspection.routes[1].backend_cancel_count, 0)
  assert_eq(inspection.routes[1].backend_retry_count, 0)
  assert_true(inspection.routes[1].risk_score > inspection.routes[0].risk_score)
  assert_true(inspection.summary.contains("top_route=pages/ops/index"))
  assert_true(inspection.summary.contains("max_backend_cancels=0"))
  assert_true(inspection.summary.contains("max_scene_assets=0"))
  assert_true(inspection.summary.contains("max_scene_remote_assets=0"))
  assert_true(inspection.summary.contains("max_scene_package_bytes=0"))
  assert_true(inspection.routes[1].summary.contains("risk_score="))
  assert_true(inspection.routes[1].summary.contains("backend_cancels=0"))
}

///|
test "project inspection reports backend recovery pressure" {
  let page = @wechat.project_page(
    name="Agent Ops",
    route="pages/agent/index",
    root=@core.page([
      @core.button("Cancel", "cancel-agent"),
      @core.button("Retry", "retry-agent"),
    ]),
    runtime=@wechat.runtime(event_patches=[
      @wechat.event_patch("cancel-agent", [
        @core.set_string("backend.cancel-agent.state", "loading"),
      ]),
      @wechat.event_patch("retry-agent", [
        @core.set_string("backend.retry-agent.state", "loading"),
      ]),
    ]),
  )
  let contract = @effects.backend_contract(id="agent-ops", endpoints=[
    @effects.agent_cancel_endpoint(
      "cancel-agent", "/agent/cancel", "runCancel", "cancelResult",
    ),
    @effects.agent_retry_endpoint(
      "retry-agent", "/agent/retry", "runRetry", "retryResult",
    ),
  ])
  let project = @wechat.generate_project_from_pages_with_backend(
    name="Inspection Backend Ops",
    pages=[page],
    backend_contract=contract,
  )
  let inspection = inspect_wechat_project(
    target="wechat",
    example="inspection_backend_ops",
    project,
    project.report,
  )
  assert_eq(inspection.routes[0].backend_event_count, 2)
  assert_eq(inspection.routes[0].backend_stream_count, 0)
  assert_eq(inspection.routes[0].backend_review_count, 0)
  assert_eq(inspection.routes[0].backend_cancel_count, 1)
  assert_eq(inspection.routes[0].backend_retry_count, 1)
  assert_eq(inspection.max_backend_event_count, 2)
  assert_eq(inspection.max_backend_stream_count, 0)
  assert_eq(inspection.max_backend_review_count, 0)
  assert_eq(inspection.max_backend_cancel_count, 1)
  assert_eq(inspection.max_backend_retry_count, 1)
  let route = inspection.routes[0]
  let base_risk_score = route.diagnostics * 1000000 +
    route.first_screen_bytes +
    route.update_payload_bytes * 4 +
    route.update_operation_count * 96 +
    route.node_count * 16 +
    route.event_count * 64
  assert_eq(route.risk_score, base_risk_score + 448)
  assert_eq(route.update_operation_count, 2)
  assert_true(inspection.routes[0].summary.contains("backend_events=2"))
  assert_true(inspection.routes[0].summary.contains("update_ops=2"))
  assert_true(inspection.routes[0].summary.contains("backend_cancels=1"))
  assert_true(inspection.routes[0].summary.contains("backend_retries=1"))
  assert_true(inspection.summary.contains("max_backend_events=2"))
  assert_true(inspection.summary.contains("max_update_ops=2"))
  assert_true(inspection.summary.contains("max_backend_cancels=1"))
  assert_true(inspection.summary.contains("max_backend_retries=1"))
  let relaxed = gate_project_inspection(
    inspection,
    inspection_budget(
      max_route_risk_score=100000,
      max_backend_events=4,
      max_backend_streams=1,
      max_backend_reviews=1,
      max_backend_cancels=2,
      max_backend_retries=2,
      max_scene_assets=1,
      max_scene_remote_assets=1,
      max_scene_package_bytes=1024,
    ),
    budget_profile="agent-relaxed",
  )
  let strict = gate_project_inspection(
    inspection,
    inspection_budget(
      max_route_risk_score=100000,
      max_backend_events=1,
      max_backend_streams=0,
      max_backend_reviews=0,
      max_backend_cancels=0,
      max_backend_retries=0,
      max_scene_assets=1,
      max_scene_remote_assets=1,
      max_scene_package_bytes=1024,
    ),
    budget_profile="agent-tiny",
  )
  assert_eq(relaxed.diagnostics.length(), 0)
  assert_true(relaxed.summary.contains("max_backend_events=4"))
  assert_true(
    strict.diagnostics.contains("inspection-backend-events-over-budget:2/1"),
  )
  assert_true(
    strict.diagnostics.contains("inspection-backend-cancels-over-budget:1/0"),
  )
  assert_true(
    strict.diagnostics.contains("inspection-backend-retries-over-budget:1/0"),
  )
  assert_true(strict.summary.contains("max_backend_cancels=0"))
}

///|
test "project inspection scores viewported maps by visible geometry" {
  let offscreen_markers : Array[@scene.SceneMarker] = []
  for i in 0..<80 {
    offscreen_markers.push(
      @scene.marker(id="offscreen-\{i}", label="Offscreen \{i}", x=i * 32, y=24),
    )
  }
  let visible_markers : Array[@scene.SceneMarker] = []
  for i in 0..<6 {
    visible_markers.push(
      @scene.marker(id="visible-\{i}", label="Visible \{i}", x=i * 24, y=32),
    )
  }
  let project = @wechat.generate_project_from_pages(
    name="Inspection Scene Visibility",
    pages=[
      @wechat.project_page(
        name="Large Offscreen",
        route="pages/large-offscreen/index",
        root=@core.page([
          @scene.static_scene_view_with_viewport(
            @scene.scene("large-offscreen", @scene.scene_size(3200, 640), [
              @scene.layer("markers", 1, offscreen_markers),
            ]),
            @scene.scene_viewport(x=0, y=0, width=40, height=120),
          ),
        ]),
      ),
      @wechat.project_page(
        name="Visible Work",
        route="pages/visible-work/index",
        root=@core.page([
          @scene.static_scene_view(
            @scene.scene("visible-work", @scene.scene_size(360, 240), [
              @scene.layer("markers", 1, visible_markers),
            ]),
          ),
        ]),
      ),
    ],
  )
  let inspection = inspect_wechat_project(
    target="wechat",
    example="inspection_scene_visibility",
    project,
    project.report,
  )
  assert_eq(inspection.routes[0].scene_marker_count, 80)
  assert_eq(inspection.routes[0].scene_visible_marker_count, 2)
  assert_eq(inspection.routes[1].scene_marker_count, 6)
  assert_eq(inspection.routes[1].scene_visible_marker_count, 6)
  assert_eq(inspection.max_scene_marker_count, 6)
  let large_route = inspection.routes[0]
  let visible_risk_score = large_route.diagnostics * 1000000 +
    large_route.first_screen_bytes +
    large_route.update_payload_bytes * 4 +
    large_route.node_count * 16 +
    large_route.event_count * 64 +
    large_route.scene_visible_marker_count * 32
  let total_risk_score = large_route.diagnostics * 1000000 +
    large_route.first_screen_bytes +
    large_route.update_payload_bytes * 4 +
    large_route.node_count * 16 +
    large_route.event_count * 64 +
    large_route.scene_marker_count * 32
  assert_eq(large_route.risk_score, visible_risk_score)
  assert_true(large_route.risk_score < total_risk_score)
  assert_true(inspection.summary.contains("max_scene_markers=6"))
  assert_true(inspection.routes[0].summary.contains("scene_markers=2/80"))
}

///|
test "project inspection reports route scene asset pressure" {
  let project = @wechat.generate_project_from_pages(
    name="Inspection Scene Assets",
    pages=[
      @wechat.project_page(
        name="Local Assets",
        route="pages/local-assets/index",
        root=@core.page([
          @core.node(kind="image", attrs=[
            @core.class_name("bunnia-scene-sprite"),
            @core.attr("src", "/assets/local.png"),
            @core.attr("alt", "Local"),
            @core.data("asset-id", "local"),
            @core.data("asset-kind", "sprite"),
            @core.data("asset-remote", "false"),
            @core.data("asset-bytes", "4096"),
          ]),
        ]),
      ),
      @wechat.project_page(
        name="Remote Assets",
        route="pages/remote-assets/index",
        root=@core.page([
          @core.node(kind="image", attrs=[
            @core.class_name("bunnia-scene-pin"),
            @core.attr("src", "https://cdn.example.test/pin-a.png"),
            @core.attr("alt", "Pin A"),
            @core.data("asset-id", "pin-a"),
            @core.data("asset-kind", "remote-image"),
            @core.data("asset-remote", "true"),
          ]),
          @core.node(kind="image", attrs=[
            @core.class_name("bunnia-scene-pin"),
            @core.attr("src", "https://cdn.example.test/pin-b.png"),
            @core.attr("alt", "Pin B"),
            @core.data("asset-id", "pin-b"),
            @core.data("asset-kind", "remote-image"),
            @core.data("asset-remote", "true"),
          ]),
        ]),
      ),
    ],
  )
  let inspection = inspect_wechat_project(
    target="wechat",
    example="inspection_scene_assets",
    project,
    project.report,
  )
  assert_eq(inspection.top_route, "pages/remote-assets/index")
  assert_eq(inspection.max_scene_asset_count, 2)
  assert_eq(inspection.max_scene_remote_asset_count, 2)
  assert_eq(inspection.max_scene_package_bytes, 4096)
  assert_eq(inspection.routes[0].scene_asset_count, 1)
  assert_eq(inspection.routes[0].scene_remote_asset_count, 0)
  assert_eq(inspection.routes[0].scene_package_bytes, 4096)
  assert_eq(inspection.routes[1].scene_asset_count, 2)
  assert_eq(inspection.routes[1].scene_remote_asset_count, 2)
  assert_eq(inspection.routes[1].scene_package_bytes, 0)
  assert_true(inspection.routes[1].risk_score > inspection.routes[0].risk_score)
  assert_true(inspection.summary.contains("max_scene_assets=2"))
  assert_true(inspection.summary.contains("max_scene_remote_assets=2"))
  assert_true(inspection.summary.contains("max_scene_package_bytes=4096"))
  assert_true(inspection.routes[1].summary.contains("scene_remote_assets=2"))
  assert_true(inspection.routes[0].summary.contains("scene_package_bytes=4096"))
  let relaxed = gate_project_inspection(
    inspection,
    inspection_budget(
      max_route_risk_score=100000,
      max_backend_events=1,
      max_backend_streams=1,
      max_backend_reviews=1,
      max_backend_cancels=1,
      max_backend_retries=1,
      max_scene_assets=4,
      max_scene_remote_assets=4,
      max_scene_package_bytes=8192,
    ),
    budget_profile="relaxed",
  )
  let strict = gate_project_inspection(
    inspection,
    inspection_budget(
      max_route_risk_score=1,
      max_backend_events=1,
      max_backend_streams=1,
      max_backend_reviews=1,
      max_backend_cancels=1,
      max_backend_retries=1,
      max_scene_assets=1,
      max_scene_remote_assets=1,
      max_scene_package_bytes=1024,
    ),
    budget_profile="tiny",
  )
  assert_eq(relaxed.diagnostics.length(), 0)
  assert_true(relaxed.summary.contains("budget=relaxed"))
  assert_true(
    strict.diagnostics.contains(
      "inspection-route-risk-over-budget:pages/remote-assets/index:\{inspection.risk_score}/1",
    ),
  )
  assert_true(
    strict.diagnostics.contains("inspection-scene-assets-over-budget:2/1"),
  )
  assert_true(
    strict.diagnostics.contains(
      "inspection-remote-scene-assets-over-budget:2/1",
    ),
  )
  assert_true(
    strict.diagnostics.contains(
      "inspection-scene-package-bytes-over-budget:4096/1024",
    ),
  )
}

///|
test "project inspection prioritizes diagnostic routes before clean payload pressure" {
  let diagnostic_route = "pages/diagnostic/index"
  let project = @wechat.generate_project_from_pages(
    name="Inspection Diagnostics",
    pages=[
      @wechat.project_page(
        name="Payload",
        route="pages/payload/index",
        root=@core.page([
          @core.view([
            @core.text("A large clean route"),
            @core.button("Open", "open"),
            @core.button("Close", "close"),
            @core.button("Retry", "retry"),
          ]),
        ]),
        runtime=@wechat.runtime(event_patches=[
          @wechat.event_patch("open", [@core.set_string("state.open", "yes")]),
          @wechat.event_patch("close", [@core.set_string("state.open", "no")]),
          @wechat.event_patch("retry", [@core.set_string("state.retry", "yes")]),
        ]),
      ),
      @wechat.project_page(
        name="Diagnostic",
        route=diagnostic_route,
        root=@core.page([@core.button("Missing", "missing")]),
        runtime=@wechat.runtime(
          initial_data_json="{\"agentDraft\":\"large payload\"}",
        ),
        render_budget=@core.render_budget(
          max_nodes=16,
          max_depth=4,
          max_events=4,
          max_initial_data_bytes=8,
        ),
      ),
    ],
  )
  let inspection = inspect_wechat_project(
    target="wechat",
    example="inspection_diagnostics",
    project,
    project.report,
  )
  assert_eq(inspection.top_route, diagnostic_route)
  assert_eq(inspection.total_diagnostics, 2)
  assert_eq(inspection.routes[1].status, "diagnostic")
  assert_eq(inspection.routes[1].diagnostics, 2)
  assert_true(inspection.routes[1].risk_score > inspection.routes[0].risk_score)
  assert_true(inspection.summary.contains("diagnostics=2"))
}
