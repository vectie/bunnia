///|
test "scaffold project creates a small standalone starter" {
  let plan = scaffold_project(name="starter", module_name="local/starter")
  assert_eq(plan.name, "starter")
  assert_eq(plan.module_name, "local/starter")
  assert_eq(plan.files.length(), 12)
  assert_true(has_file(plan.files, "moon.mod"))
  assert_true(has_file(plan.files, "moon.pkg"))
  assert_true(has_file(plan.files, "cmd/main/moon.pkg"))
  assert_true(has_file(plan.files, "cmd/main/main.mbt"))
  assert_true(has_file(plan.files, "app.mbt"))
  assert_true(has_file(plan.files, "agent_feed.mbt"))
  assert_true(has_file(plan.files, "scene.mbt"))
  assert_true(has_file(plan.files, "updates.mbt"))
  assert_true(has_file(plan.files, "quality.mbt"))
  assert_true(has_file(plan.files, "wechat.mbt"))
  assert_true(has_file(plan.files, "app_test.mbt"))
  assert_true(has_file(plan.files, "README.mbt.md"))
  assert_true(
    file_content(plan.files, "moon.mod").contains("name = \"local/starter\""),
  )
  assert_true(
    file_content(plan.files, "moon.mod").contains("\"vectie/bunnia@0.1.0\""),
  )
  assert_true(
    file_content(plan.files, "moon.pkg").contains("\"vectie/bunnia\""),
  )
  assert_true(
    file_content(plan.files, "cmd/main/moon.pkg").contains(
      "\"local/starter\" @app",
    ),
  )
  assert_true(
    file_content(plan.files, "cmd/main/main.mbt").contains(
      "starter_wechat_project",
    ),
  )
  assert_true(
    file_content(plan.files, "cmd/main/main.mbt").contains("write_text_file"),
  )
  assert_true(file_content(plan.files, "app.mbt").contains("pub fn view()"))
  assert_true(
    file_content(plan.files, "app.mbt").contains("starter_agent_feed"),
  )
  assert_true(
    file_content(plan.files, "agent_feed.mbt").contains("windowed_message_feed"),
  )
  assert_true(
    file_content(plan.files, "app.mbt").contains("surface_status_overlay"),
  )
  assert_true(file_content(plan.files, "scene.mbt").contains("starter_scene"))
  assert_true(file_content(plan.files, "app.mbt").contains("static_scene_view"))
  assert_true(
    file_content(plan.files, "scene.mbt").contains("pub fn scene_render_plan()"),
  )
  assert_true(
    file_content(plan.files, "updates.mbt").contains("select_scene_marker"),
  )
  assert_true(
    file_content(plan.files, "quality.mbt").contains("pub fn render_plan()"),
  )
  assert_true(
    file_content(plan.files, "quality.mbt").contains("strict_render_plan"),
  )
  assert_true(
    file_content(plan.files, "quality.mbt").contains(
      "render_budget_for_profile",
    ),
  )
  assert_true(
    file_content(plan.files, "wechat.mbt").contains("starter_wechat_project"),
  )
  assert_true(
    file_content(plan.files, "wechat.mbt").contains(
      "generate_wechat_project_with_runtime_and_budget",
    ),
  )
  assert_true(
    file_content(plan.files, "app_test.mbt").contains("strict_render_plan"),
  )
  assert_true(
    file_content(plan.files, "app_test.mbt").contains("starter updates"),
  )
  assert_true(
    file_content(plan.files, "app_test.mbt").contains("clean wechat output"),
  )
  assert_true(
    file_content(plan.files, "updates.mbt").contains(
      "append_stream_chunk_delta",
    ),
  )
  assert_true(
    file_content(plan.files, "README.mbt.md").contains("starter tests"),
  )
  assert_true(plan.summary.contains("files=12"))
}

///|
test "scaffold project defaults module name from app name" {
  let plan = scaffold_project(name="demo_app")
  assert_eq(plan.module_name, "local/demo_app")
}

///|
fn has_file(files : Array[ScaffoldFile], path : String) -> Bool {
  for item in files {
    if item.path == path {
      return true
    }
  }
  false
}

///|
fn file_content(files : Array[ScaffoldFile], path : String) -> String {
  for item in files {
    if item.path == path {
      return item.content
    }
  }
  ""
}
