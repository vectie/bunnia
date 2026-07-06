///|
test "build output dir defaults to ignored build folder" {
  assert_eq(output_dir_from_args(["node", "main.js"]), default_output_dir())
}

///|
test "build output dir accepts out flag" {
  assert_eq(
    output_dir_from_args(["node", "main.js", "--out", "/tmp/bunnia-demo"]),
    "/tmp/bunnia-demo",
  )
}

///|
test "join path keeps generated routes stable" {
  assert_eq(
    join_path("_build/demo", "pages/index/index.wxml"),
    "_build/demo/pages/index/index.wxml",
  )
  assert_eq(join_path("_build/demo/", "app.json"), "_build/demo/app.json")
}
