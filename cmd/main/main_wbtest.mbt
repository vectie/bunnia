///|
test "build output dir defaults to ignored build folder" {
  assert_eq(default_command(), "build")
  assert_eq(default_target(), "wechat")
  assert_eq(default_example(), "agent_map")
  assert_eq(
    output_dir_from_args(
      ["node", "main.js"],
      default_target(),
      default_example(),
    ),
    "_build/bunnia/wechat/agent_map",
  )
}

///|
test "build output dir accepts out flag" {
  assert_eq(
    output_dir_from_args(
      ["node", "main.js", "--out", "/tmp/bunnia-demo"],
      default_target(),
      default_example(),
    ),
    "/tmp/bunnia-demo",
  )
}

///|
test "build command and target parse explicitly" {
  let args = ["node", "main.js", "build", "--target", "wechat"]
  assert_eq(command_from_args(args), "build")
  assert_eq(target_from_args(args), "wechat")
  assert_eq(strict_from_args(args), false)
  assert_eq(strict_from_args(["node", "main.js", "--strict"]), true)
  assert_eq(
    strict_from_args(["node", "main.js", "--fail-on-diagnostics"]),
    true,
  )
}

///|
test "init command builds a scaffold plan" {
  let args = [
    "node", "main.js", "init", "--name", "agent_demo", "--module", "local/agent_demo",
  ]
  let name = scaffold_name_from_args(args)
  let scaffold = scaffold_from_args(args, name)
  assert_eq(command_from_args(args), "init")
  assert_eq(name, "agent_demo")
  assert_eq(scaffold.module_name, "local/agent_demo")
  assert_eq(scaffold.files.length(), 4)
  assert_eq(
    scaffold_output_dir_from_args(args, name),
    "_build/bunnia/scaffold/agent_demo",
  )
  assert_true(scaffold.summary.contains("files=4"))
}

///|
test "init command accepts output override and module default" {
  let args = ["node", "main.js", "init", "--out", "/tmp/bunnia-init"]
  let name = scaffold_name_from_args(args)
  let scaffold = scaffold_from_args(args, name)
  assert_eq(name, default_scaffold_name())
  assert_eq(scaffold.module_name, "local/bunnia_starter")
  assert_eq(scaffold_output_dir_from_args(args, name), "/tmp/bunnia-init")
}

///|
test "build example flag selects Wenyu proof output folder" {
  let example = example_from_args([
    "node", "main.js", "--example", "wenyu_overview",
  ])
  assert_eq(example, "wenyu_overview")
  assert_eq(
    output_dir_from_args(["node", "main.js"], default_target(), example),
    "_build/bunnia/wechat/wenyu_overview",
  )
}

///|
test "build example flag selects Wenyu project" {
  let project = project_for_build("wechat", "wenyu_overview")
  let patches = patches_for_build("wechat", "wenyu_overview")
  let profile = profile_for_build("wechat", "wenyu_overview", project, patches)
  assert_eq(project.route, "pages/wenyu/index")
  assert_eq(patches.patches.length(), 2)
  assert_eq(profile.backend_endpoint_count, 4)
  assert_eq(profile.scene_marker_count, 4)
  assert_eq(profile.scene_asset_count, 1)
  assert_true(profile.summary.contains("scene_package_bytes=4096"))
  assert_eq(should_fail_build(false, project, patches, profile), false)
  assert_eq(should_fail_build(true, project, patches, profile), false)
}

///|
test "build profile keeps agent map diagnostics visible" {
  let project = project_for_build("wechat", "agent_map")
  let patches = patches_for_build("wechat", "agent_map")
  let profile = profile_for_build("wechat", "agent_map", project, patches)
  let bad_patches = @bunnia.plan_patches_with_budget(
    patches.patches,
    @bunnia.patch_budget(max_patches=0, max_patch_bytes=1),
  )
  assert_eq(profile.route, "pages/index/index")
  assert_eq(profile.scene_marker_count, 2)
  assert_eq(profile.backend_endpoint_count, 0)
  assert_eq(profile.diagnostics.length(), 0)
  assert_eq(should_fail_build(false, project, bad_patches, profile), false)
  assert_eq(should_fail_build(true, project, bad_patches, profile), true)
}

///|
test "join path keeps generated routes stable" {
  assert_eq(
    join_path("_build/demo", "pages/index/index.wxml"),
    "_build/demo/pages/index/index.wxml",
  )
  assert_eq(join_path("_build/demo/", "app.json"), "_build/demo/app.json")
}
