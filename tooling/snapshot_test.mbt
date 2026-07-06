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
  assert_eq(snapshot.route, "pages/snapshot/index")
  assert_eq(snapshot.file_count, project.files.length())
  assert_eq(snapshot.total_bytes, project.total_bytes)
  assert_eq(snapshot.diagnostic_count, 0)
  assert_true(snapshot.summary.contains("files=8"))
  assert_true(snapshot.content.contains("bunnia-generated-snapshot-v1"))
  assert_true(snapshot.content.contains("route=pages/snapshot/index"))
  assert_true(snapshot.content.contains("report=Bunnia WeChat build report:"))
  assert_true(snapshot.content.contains("profile=Bunnia build profile:"))
  assert_true(snapshot.content.contains("- app.json kind=json bytes="))
  assert_true(snapshot.content.contains("pages/snapshot/index.wxml kind=wxml"))
  assert_true(snapshot.content.contains("checksum="))
  assert_true(!snapshot.content.contains("checksum=-"))
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
      max_page_first_screen_bytes=4,
      max_page_update_payload_bytes=4,
    ),
  )
  let snapshot = snapshot_wechat_project_with_report(
    target="wechat",
    example="snapshot_budget_fixture",
    project,
    report,
    profile,
  )
  assert_eq(snapshot.diagnostic_count, report.diagnostics.length())
  assert_true(snapshot.diagnostic_count > 0)
  assert_true(snapshot.summary.contains("diagnostics="))
  assert_true(
    snapshot.content.contains("diagnostics=\{report.diagnostics.length()}"),
  )
  assert_true(snapshot.content.contains("report=Bunnia WeChat build report:"))
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
