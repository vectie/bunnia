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
  assert_eq(inspection.routes[1].diagnostics, 0)
  assert_true(inspection.routes[1].risk_score > inspection.routes[0].risk_score)
  assert_true(inspection.summary.contains("top_route=pages/ops/index"))
  assert_true(inspection.routes[1].summary.contains("risk_score="))
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
