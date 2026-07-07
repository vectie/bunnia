///|
fn miniapp_fixture_project() -> @miniapp.MiniappProject {
  @miniapp.generate_project_with_budget(
    name="Miniapp Inspection",
    route="pages/inspect/index",
    root=@core.page([
      @core.view([@core.button("Open", "open"), @core.text("Generic miniapp")]),
    ]),
    platform=@core.Alipay,
    render_budget=@core.render_budget(
      max_nodes=32,
      max_depth=8,
      max_events=8,
      max_initial_data_bytes=1024,
      max_scene_markers=8,
      max_scene_regions=8,
      max_scene_assets=8,
    ),
  )
}

///|
test "miniapp inspection summarizes generic project pressure" {
  let project = miniapp_fixture_project()
  let inspection = inspect_miniapp_project(
    target="alipay",
    example="miniapp_fixture",
    project,
  )
  assert_eq(inspection.target, "alipay")
  assert_eq(inspection.example, "miniapp_fixture")
  assert_eq(inspection.status, "ok")
  assert_eq(inspection.page_count, 1)
  assert_eq(inspection.file_count, 7)
  assert_eq(inspection.diagnostic_count, 0)
  assert_eq(inspection.max_event_count, 1)
  assert_true(inspection.total_bytes > 0)
  assert_true(inspection.summary.contains("target=alipay"))
  assert_true(inspection.summary.contains("max_events=1"))
}

///|
test "miniapp inspection gate budgets files bytes and route pressure" {
  let project = miniapp_fixture_project()
  let inspection = inspect_miniapp_project(
    target="alipay",
    example="miniapp_fixture",
    project,
  )
  let relaxed = gate_miniapp_inspection(
    inspection,
    miniapp_inspection_budget_for_profile("tight"),
    budget_profile="tight",
  )
  let strict = gate_miniapp_inspection(
    inspection,
    miniapp_inspection_budget(
      max_pages=1,
      max_files=1,
      max_total_bytes=128,
      max_route_diagnostic_routes=0,
      max_route_diagnostics=0,
      max_nodes=1,
      max_depth=1,
      max_events=0,
      max_scene_markers=0,
      max_scene_regions=0,
      max_scene_assets=0,
    ),
    budget_profile="tiny-custom",
  )
  assert_eq(relaxed.diagnostics.length(), 0)
  assert_true(relaxed.summary.contains("diagnostics=0"))
  assert_true(strict.diagnostics.contains("miniapp-files-over-budget:7/1"))
  assert_true(
    contains_diagnostic_prefix(
      strict.diagnostics,
      "miniapp-total-bytes-over-budget:",
    ),
  )
  assert_true(
    contains_diagnostic_prefix(strict.diagnostics, "miniapp-nodes-over-budget:"),
  )
  assert_true(
    contains_diagnostic_prefix(strict.diagnostics, "miniapp-depth-over-budget:"),
  )
  assert_true(strict.diagnostics.contains("miniapp-events-over-budget:1/0"))
}

///|
fn contains_diagnostic_prefix(items : Array[String], prefix : String) -> Bool {
  for item in items {
    if item.has_prefix(prefix) {
      return true
    }
  }
  false
}
