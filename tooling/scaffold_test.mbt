///|
test "scaffold project creates a small standalone starter" {
  let plan = scaffold_project(name="starter", module_name="local/starter")
  assert_eq(plan.name, "starter")
  assert_eq(plan.module_name, "local/starter")
  assert_eq(plan.files.length(), 4)
  assert_true(has_file(plan.files, "moon.mod"))
  assert_true(has_file(plan.files, "moon.pkg"))
  assert_true(has_file(plan.files, "app.mbt"))
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
  assert_true(file_content(plan.files, "app.mbt").contains("pub fn view()"))
  assert_true(
    file_content(plan.files, "app.mbt").contains("windowed_message_feed"),
  )
  assert_true(
    file_content(plan.files, "app.mbt").contains("surface_status_overlay"),
  )
  assert_true(
    file_content(plan.files, "app.mbt").contains("pub fn render_plan()"),
  )
  assert_true(
    file_content(plan.files, "app.mbt").contains("append_stream_chunk_delta"),
  )
  assert_true(plan.summary.contains("files=4"))
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
