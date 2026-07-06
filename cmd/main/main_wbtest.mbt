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
  assert_eq(project.route, "pages/wenyu/index")
  assert_eq(patches.patches.length(), 2)
}

///|
test "join path keeps generated routes stable" {
  assert_eq(
    join_path("_build/demo", "pages/index/index.wxml"),
    "_build/demo/pages/index/index.wxml",
  )
  assert_eq(join_path("_build/demo/", "app.json"), "_build/demo/app.json")
}
