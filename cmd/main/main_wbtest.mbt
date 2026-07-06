///|
test "build output dir defaults to ignored build folder" {
  assert_eq(default_example(), "agent_map")
  assert_eq(
    output_dir_from_args(["node", "main.js"], default_example()),
    "_build/bunnia/wechat/agent_map",
  )
}

///|
test "build output dir accepts out flag" {
  assert_eq(
    output_dir_from_args(
      ["node", "main.js", "--out", "/tmp/bunnia-demo"],
      default_example(),
    ),
    "/tmp/bunnia-demo",
  )
}

///|
test "build example flag selects Wenyu proof output folder" {
  let example = example_from_args([
    "node", "main.js", "--example", "wenyu_overview",
  ])
  assert_eq(example, "wenyu_overview")
  assert_eq(
    output_dir_from_args(["node", "main.js"], example),
    "_build/bunnia/wechat/wenyu_overview",
  )
}

///|
test "build example flag selects Wenyu project" {
  let project = project_for_example("wenyu_overview")
  let patches = patches_for_example("wenyu_overview")
  let profile = profile_for_example("wenyu_overview", project, patches)
  assert_eq(project.route, "pages/wenyu/index")
  assert_eq(patches.patches.length(), 2)
  assert_eq(profile.backend_endpoint_count, 4)
  assert_eq(profile.scene_marker_count, 4)
  assert_eq(profile.scene_asset_count, 1)
  assert_true(profile.summary.contains("scene_package_bytes=4096"))
}

///|
test "build profile keeps agent map diagnostics visible" {
  let project = project_for_example("agent_map")
  let patches = patches_for_example("agent_map")
  let profile = profile_for_example("agent_map", project, patches)
  assert_eq(profile.route, "pages/index/index")
  assert_eq(profile.scene_marker_count, 2)
  assert_eq(profile.backend_endpoint_count, 0)
  assert_eq(profile.diagnostics.length(), 0)
}

///|
test "join path keeps generated routes stable" {
  assert_eq(
    join_path("_build/demo", "pages/index/index.wxml"),
    "_build/demo/pages/index/index.wxml",
  )
  assert_eq(join_path("_build/demo/", "app.json"), "_build/demo/app.json")
}
