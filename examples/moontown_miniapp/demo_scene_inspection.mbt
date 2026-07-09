///|
pub fn demo_project_inspection() -> @bunnia.ProjectInspection {
  let project = demo_wechat_project_with_render_budget(
    @bunnia.render_budget_for_profile("large"),
  )
  let report = @bunnia.report_wechat_project_with_budget(
    project,
    @bunnia.default_wechat_runtime(),
    @bunnia.wechat_build_budget_for_profile("large"),
  )
  @bunnia.inspect_wechat_project(
    target="wechat",
    example="moontown_miniapp",
    project,
    report,
  )
}
