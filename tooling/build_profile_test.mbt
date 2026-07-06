///|
fn fixture_project() -> @wechat.WechatProject {
  let root = fixture_root()
  let runtime = @wechat.runtime(initial_data_json="{\"active\":false}", event_patches=[
    @wechat.event_patch("open", [@core.set_string("state.active", "open")]),
  ])
  @wechat.generate_project_with_runtime(
    name="Profile Fixture",
    route="pages/profile/index",
    root~,
    runtime~,
  )
}

///|
test "build profile aggregates normal project signals" {
  let project = fixture_project()
  let patches = @core.plan_patches([@core.set_string("state.active", "open")])
  let backend = @effects.plan_backend_contract(
    @effects.backend_contract(id="profile-backend", endpoints=[
      @effects.agent_message_endpoint(
        "send-message", "/agent/message", "draft", "message",
      ),
    ]),
  )
  let assets = @scene.plan_scene_assets([
    @scene.sprite_asset("pin", "/assets/pin.png", 1024),
  ])
  let scene_input = @scene.scene(
    "map",
    @scene.scene_size(320, 240),
    [
      @scene.layer("markers", 1, [
        @scene.marker(
          id="a",
          label="A",
          x=20,
          y=20,
          status="stable",
          tap_message="select-a",
          asset_ref="pin",
        ),
      ]),
    ],
    assets=[@scene.sprite_asset("pin", "/assets/pin.png", 1024)],
  )
  let scene = @scene.plan_scene_render(scene_input)
  let quality = @scene.plan_scene_visual_quality(scene_input)
  let profile = profile_wechat_project(
    project,
    patches,
    backend_plans=[backend],
    asset_plans=[assets],
    scene_plans=[scene],
    quality_plans=[quality],
  )
  assert_eq(profile.name, "Profile Fixture")
  assert_eq(profile.route, "pages/profile/index")
  assert_eq(profile.page_count, 1)
  assert_eq(profile.windowed_list_count, 0)
  assert_eq(profile.list_total_count, 0)
  assert_eq(profile.list_visible_count, 0)
  assert_eq(profile.unkeyed_list_child_count, 0)
  assert_eq(profile.duplicate_list_key_count, 0)
  assert_eq(profile.file_count, 8)
  assert_eq(
    profile.max_page_first_screen_bytes,
    project.report.max_page_first_screen_bytes,
  )
  assert_eq(
    profile.max_page_update_payload_bytes,
    project.report.max_page_update_payload_bytes,
  )
  assert_eq(profile.backend_endpoint_count, 1)
  assert_eq(profile.scene_marker_count, 1)
  assert_eq(profile.scene_visible_marker_count, 1)
  assert_eq(profile.scene_asset_count, 1)
  assert_eq(profile.scene_package_bytes, 1024)
  assert_eq(profile.scene_quality_issue_count, 0)
  assert_eq(profile.degraded_scene_count, 0)
  assert_eq(profile.effect_count, 0)
  assert_eq(profile.cloud_function_count, 0)
  assert_eq(profile.stream_effect_count, 0)
  assert_eq(profile.diagnostics.length(), 0)
  assert_true(profile.summary.contains("backend_endpoints=1"))
  assert_true(profile.summary.contains("pages=1"))
  assert_true(profile.summary.contains("list_items=0/0"))
  assert_true(profile.summary.contains("unkeyed_list_children=0"))
  assert_true(profile.summary.contains("duplicate_list_keys=0"))
  assert_true(profile.summary.contains("max_first_screen="))
  assert_true(profile.summary.contains("max_update_payload="))
  assert_true(profile.summary.contains("effects=0"))
  assert_true(profile.summary.contains("scene_markers=1/1"))
  assert_true(profile.summary.contains("scene_quality_issues=0"))
}

///|
test "build profile prefixes diagnostics by budget source" {
  let project = @wechat.generate_project(
    name="Large Profile Fixture",
    route="pages/large/index",
    root=large_fixture_root(900),
  )
  let patches = @core.plan_patches_with_budget(
    [@core.set_string("state.active", "open")],
    @core.patch_budget(max_patches=0, max_patch_bytes=1),
  )
  let backend = @effects.plan_backend_contract_with_budget(
    @effects.backend_contract(id="profile-backend", endpoints=[
      @effects.operator_submit_endpoint(
        "submit", "/submit", "payload", "result",
      ),
    ]),
    @effects.backend_budget(
      max_endpoints=0,
      max_streaming=0,
      max_review_required=0,
    ),
  )
  let assets = @scene.plan_scene_assets_with_budget(
    [@scene.sprite_asset("pin", "/assets/pin.png", 2048)],
    @scene.scene_asset_budget(
      max_assets=0,
      max_package_bytes=1,
      max_remote_assets=0,
    ),
  )
  let scene = @scene.plan_scene_render_with_budget(
    @scene.scene("map", @scene.scene_size(320, 240), [
      @scene.layer("markers", 1, [
        @scene.marker(id="a", label="A", x=20, y=20),
        @scene.marker(id="b", label="B", x=40, y=40),
      ]),
    ]),
    @scene.scene_render_budget(max_layers=1, max_markers=1, max_static_assets=1),
  )
  let quality = @scene.plan_scene_visual_quality_with_budget(
    @scene.scene("map", @scene.scene_size(120, 80), [
      @scene.layer("markers", 1, [@scene.marker(id="a", label="A", x=20, y=20)]),
    ]),
    @scene.scene_render_budget(max_layers=1, max_markers=1, max_static_assets=1),
    @scene.scene_asset_budget(
      max_assets=0,
      max_package_bytes=1,
      max_remote_assets=0,
    ),
    @scene.default_scene_visual_quality_budget(),
  )
  let profile = profile_wechat_project(
    project,
    patches,
    effect_plans=[
      @effects.plan_effects_for_platform(
        [
          @effects.cloud_function("refresh", "refreshSnapshot", "snapshot"),
          @effects.stream("agent-stream", "/agent/stream", "thread"),
        ],
        @core.TikTok,
      ),
    ],
    backend_plans=[backend],
    asset_plans=[assets],
    scene_plans=[scene],
    quality_plans=[quality],
  )
  assert_eq(profile.effect_count, 2)
  assert_eq(profile.cloud_function_count, 1)
  assert_eq(profile.stream_effect_count, 1)
  assert_true(
    profile.diagnostics.contains(
      "effect:effect-cloud-function-unsupported:tiktok:1",
    ),
  )
  assert_true(
    profile.diagnostics.contains(
      "render:pages/large/index:node-count-over-budget:1802/800",
    ),
  )
  assert_true(
    profile.diagnostics.contains(
      "render:pages/large/index:event-count-over-budget:900/160",
    ),
  )
  assert_true(
    contains_prefix(
      profile.diagnostics,
      "wechat:wechat-wxml-bytes-over-budget:",
    ),
  )
  assert_true(profile.diagnostics.contains("patch:patch-count-over-budget:1/0"))
  assert_true(
    profile.diagnostics.contains(
      "backend:backend-endpoint-count-over-budget:1/0",
    ),
  )
  assert_true(
    profile.diagnostics.contains(
      "scene-assets:scene-package-bytes-over-budget:2048/1",
    ),
  )
  assert_true(
    profile.diagnostics.contains(
      "scene-render:scene-marker-count-over-budget:2/1",
    ),
  )
  assert_true(
    profile.diagnostics.contains(
      "scene-quality:scene-markers-without-status:1/0",
    ),
  )
  assert_true(profile.scene_quality_issue_count > 0)
  assert_eq(profile.degraded_scene_count, 1)
  assert_true(profile.summary.contains("diagnostics="))
}

///|
fn fixture_root() -> @core.Node {
  @core.page([
    @core.view([
      @core.view([@core.button("Open", "open"), @core.button("Close", "close")]),
    ]),
  ])
}

///|
fn large_fixture_root(count : Int) -> @core.Node {
  let buttons : Array[@core.Node] = []
  for i in 0..<count {
    buttons.push(@core.button("Open \{i}", "open-\{i}"))
  }
  @core.page([@core.view(buttons)])
}

///|
fn contains_prefix(items : Array[String], prefix : String) -> Bool {
  for item in items {
    if item.has_prefix(prefix) {
      return true
    }
  }
  false
}
