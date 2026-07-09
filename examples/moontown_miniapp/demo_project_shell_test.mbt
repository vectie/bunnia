///|
test "moontown generated project keeps shell files pages assets and ordinary guards" {
  let project = demo_wechat_project()
  assert_true(has_no_forbidden_generated_ordinary_wxml(project.files))
  assert_true(has_reviewer_diagnostics_allowlist(project.files))
  assert_true(generated_contract_data_stays_out_of_ordinary_wxml(project.files))
  assert_true(generated_wxss_has_tile_visual_system(project.files))
  assert_true(
    backend_contract_contains(
      demo_backend_contract(),
      "update-private-building",
      "/miniapp/buildings/update",
    ),
  )
  assert_eq(project.route, "pages/moontown/index")
  assert_eq(project.page_count, 6)
  assert_true(project.report.event_patch_operation_count <= 160)
  assert_true(has_file(project.files, "bunnia.runtime.js"))
  assert_true(has_file(project.files, "bunnia.backend.js"))
  assert_true(has_file(project.files, "pages/moontown/home.wxml"))
  assert_true(has_file(project.files, "pages/moontown/discover.wxml"))
  assert_true(has_file(project.files, "pages/moontown/messages.wxml"))
  assert_true(has_file(project.files, "pages/moontown/my.wxml"))
  assert_true(has_file(project.files, "pages/moontown/reviewer.wxml"))
  assert_true(
    has_file(project.files, "assets/wenyu_reference_tilemap_iso_mobile.png"),
  )
  assert_true(
    file_content(project.files, "assets/wenyu_reference_tilemap_iso_mobile.png").contains(
      "copy-file:examples/moontown_miniapp/assets/wenyu_reference_tilemap_iso_mobile.png",
    ),
  )
  assert_true(project.page.js.contains("require('../../bunnia.runtime.js')"))
  assert_true(project.page.js.contains("require('../../bunnia.backend.js')"))
  assert_true(project.page.js.contains("wx.redirectTo"))
  assert_true(
    file_content(project.files, "app.json").contains(
      "\"pages/moontown/index\", \"pages/moontown/home\", \"pages/moontown/discover\", \"pages/moontown/messages\", \"pages/moontown/my\"",
    ),
  )
}
