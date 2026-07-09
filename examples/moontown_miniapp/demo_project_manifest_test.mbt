///|
test "moontown generated project keeps onboarding routes manifest and diagnostics clear" {
  let project = demo_wechat_project()
  assert_true(
    file_content(project.files, "pages/moontown/index.wxml").contains(
      "data-bunnia-message=\"enter-town\"",
    ),
  )
  assert_true(
    !file_content(project.files, "pages/moontown/index.wxml").contains(
      "data-bunnia-message=\"dev-login\"",
    ),
  )
  assert_true(
    !file_content(project.files, "pages/moontown/index.wxml").contains(
      "data-guide-step=\"agent-mail\"",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/home.wxml").contains(
      "data-guide-step=\"agent-mail\"",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/index.wxml").contains(
      "data-bunnia-route=\"pages/moontown/messages\"",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/home.wxml").contains(
      "data-guide-step=\"passport\"",
    ),
  )
  assert_eq(project.manifest.pages[0].route, "pages/moontown/index")
  assert_eq(project.manifest.pages[1].route, "pages/moontown/home")
  assert_eq(project.manifest.pages[2].route, "pages/moontown/discover")
  assert_eq(project.manifest.pages[3].route, "pages/moontown/messages")
  assert_eq(project.manifest.pages[4].route, "pages/moontown/my")
  assert_eq(project.manifest.pages[5].route, "pages/moontown/reviewer")
  assert_true(project.manifest.pages[0].backend_event_count >= 3)
  assert_true(project.manifest.pages[3].backend_event_count >= 2)
  assert_true(project.manifest.pages[0].scene_marker_count >= 8)
  assert_true(project.manifest.pages[0].scene_region_count == 2)
  assert_eq(project.manifest.diagnostic_count, 0)
  assert_true(project.manifest.summary.contains("app_files="))
}
