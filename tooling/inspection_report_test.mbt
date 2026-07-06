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
  assert_eq(inspection.max_scene_asset_count, 0)
  assert_eq(inspection.max_scene_remote_asset_count, 0)
  assert_eq(inspection.routes[1].diagnostics, 0)
  assert_eq(inspection.routes[1].scene_remote_asset_count, 0)
  assert_true(inspection.routes[1].risk_score > inspection.routes[0].risk_score)
  assert_true(inspection.summary.contains("top_route=pages/ops/index"))
  assert_true(inspection.summary.contains("max_scene_assets=0"))
  assert_true(inspection.summary.contains("max_scene_remote_assets=0"))
  assert_true(inspection.routes[1].summary.contains("risk_score="))
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
  assert_eq(inspection.routes[0].scene_asset_count, 1)
  assert_eq(inspection.routes[0].scene_remote_asset_count, 0)
  assert_eq(inspection.routes[1].scene_asset_count, 2)
  assert_eq(inspection.routes[1].scene_remote_asset_count, 2)
  assert_true(inspection.routes[1].risk_score > inspection.routes[0].risk_score)
  assert_true(inspection.summary.contains("max_scene_assets=2"))
  assert_true(inspection.summary.contains("max_scene_remote_assets=2"))
  assert_true(inspection.routes[1].summary.contains("scene_remote_assets=2"))
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
