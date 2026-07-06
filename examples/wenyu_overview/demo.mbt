///|
pub fn demo_view() -> @bunnia.Node {
  overview_view(demo_projection())
}

///|
pub fn overview_view(input : WenyuProjection) -> @bunnia.Node {
  @bunnia.page([
    @bunnia.view_with_attrs([@bunnia.class_name("demo-shell wenyu-shell")], [
      header_view(input),
      metric_strip(input.metrics),
      building_list(input.buildings),
      review_panel(input),
      map_view(input),
      trace_view(input),
    ]),
  ])
}

///|
pub fn demo_wechat_page() -> @bunnia.WechatPage {
  @bunnia.generate_wechat_page_with_runtime(
    "Wenyu Overview",
    demo_view(),
    demo_runtime(),
  )
}

///|
pub fn demo_wechat_project() -> @bunnia.WechatProject {
  @bunnia.generate_wechat_project_with_runtime_and_backend(
    name="Wenyu Overview",
    route="pages/wenyu/index",
    root=demo_view(),
    runtime=demo_runtime(),
    backend_contract=demo_backend_contract(),
  )
}

///|
pub fn demo_runtime() -> @bunnia.WechatRuntime {
  let projection = demo_projection()
  let event_patches : Array[@bunnia.WechatEventPatch] = []
  for item in projection.buildings {
    event_patches.push(select_building_event_patch(item))
  }
  event_patches.push(
    @bunnia.wechat_event_patch("submit-operator-request", [
      @bunnia.backend_state_patch(
        "submit-operator",
        @bunnia.backend_state_loading(),
      ),
    ]),
  )
  event_patches.push(
    @bunnia.wechat_event_patch("approve-wenyu-review", [
      @bunnia.set_string("review.wenyuOverview", "approved"),
    ]),
  )
  @bunnia.wechat_runtime(
    initial_data_json=demo_initial_data_json(),
    event_patches~,
  )
}

///|
fn select_building_event_patch(
  input : CivicBuilding,
) -> @bunnia.WechatEventPatch {
  @bunnia.wechat_event_patch("select-\{input.id}", [
    @bunnia.set_string("projection.selectedBuilding", input.id),
    @bunnia.set_scene_marker_status("wenyu-map", input.id, "selected"),
  ])
}

///|
pub fn demo_patch_plan() -> @bunnia.PatchPlan {
  @bunnia.plan_patches([
    @bunnia.set_string("projection.selectedBuilding", "building-dock"),
    @bunnia.set_scene_marker_status("wenyu-map", "building-dock", "selected"),
  ])
}

///|
pub fn demo_snapshot_delta_plan() -> @bunnia.SnapshotDeltaPlan {
  @bunnia.plan_snapshot_deltas([
    @bunnia.set_snapshot_section_delta(
      "wenyu-overview", "selectedBuilding", "\"building-dock\"",
    ),
    @bunnia.set_snapshot_section_delta("wenyu-overview", "status", "\"review\""),
    @bunnia.append_snapshot_item_delta(
      "wenyu-overview", "communications", "trace-review", "{\"id\":\"trace-review\",\"kind\":\"review-request\"}",
    ),
  ])
}

///|
pub fn demo_backend_contract() -> @bunnia.BackendContract {
  @bunnia.backend_contract(id="wenyu-backend", endpoints=[
    @bunnia.snapshot_load_endpoint("load-snapshot", "/snapshot", "projection"),
    @bunnia.status_load_endpoint(
      "load-building-status", "/building/status", "buildingStatus",
    ),
    @bunnia.operator_submit_endpoint(
      "submit-operator", "/operator/request", "operatorRequest", "operatorResult",
    ),
    @bunnia.review_decision_endpoint(
      "review-wenyu-overview", "/review/wenyu", "review", "reviewResult",
    ),
  ])
}

///|
pub fn demo_effect_plan() -> @bunnia.EffectPlan {
  @bunnia.plan_backend_effects_for_platform(
    demo_backend_contract(),
    @bunnia.wechat(),
  )
}

///|
pub fn demo_asset_plan() -> @bunnia.SceneAssetPlan {
  @bunnia.plan_scene_assets(scene_assets())
}

///|
pub fn demo_scene_render_plan() -> @bunnia.SceneRenderPlan {
  @bunnia.plan_scene_render_viewport(
    demo_scene(demo_projection()),
    demo_viewport(),
    @bunnia.default_scene_render_budget(),
  )
}

///|
pub fn demo_scene_surface_plan() -> @bunnia.SceneSurfacePlan {
  @bunnia.plan_scene_surface_for_platform(
    demo_scene(demo_projection()),
    @bunnia.wechat(),
    preference=@bunnia.prefer_static_surface(),
    budget=@bunnia.default_scene_render_budget(),
  )
}

///|
pub fn demo_scene_thread_plan() -> @bunnia.SceneThreadPlan {
  @bunnia.plan_scene_threads_with_budget(
    demo_scene(demo_projection()),
    demo_scene_thread_links(demo_projection()),
    @bunnia.scene_thread_budget(max_visible_links=8, max_unread_total=16),
  )
}

///|
pub fn demo_scene_visual_quality_plan() -> @bunnia.SceneVisualQualityPlan {
  @bunnia.plan_scene_visual_quality_viewport(
    demo_scene(demo_projection()),
    demo_viewport(),
    @bunnia.default_scene_render_budget(),
    @bunnia.default_scene_asset_budget(),
    @bunnia.default_scene_visual_quality_budget(),
  )
}

///|
pub fn demo_communication_plan() -> @bunnia.CommunicationPlan {
  @bunnia.plan_communications_with_budget(
    demo_communications(demo_projection()),
    @bunnia.communication_budget(max_visible_count=8),
  )
}

///|
pub fn large_scene_render_plan(building_count : Int) -> @bunnia.SceneRenderPlan {
  @bunnia.plan_scene_render_viewport(
    large_scene(building_count),
    demo_viewport(),
    @bunnia.default_scene_render_budget(),
  )
}

///|
fn header_view(input : WenyuProjection) -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("wenyu-header bunnia-status-\{input.status}"),
      @bunnia.data("projection-id", input.id),
      @bunnia.data("selected-building", input.selected_building),
    ],
    [
      @bunnia.text(input.title),
      @bunnia.view_with_attrs(
        [
          @bunnia.class_name("wenyu-status"),
          @bunnia.data("status", input.status),
        ],
        [@bunnia.text(input.status)],
      ),
    ],
  )
}

///|
fn metric_strip(metrics : Array[DashboardMetric]) -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("wenyu-metrics")], [
    @bunnia.list(metrics, metric_card),
  ])
}

///|
fn metric_card(input : DashboardMetric) -> @bunnia.Node {
  @bunnia.keyed(
    input.id,
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("wenyu-metric bunnia-status-\{input.status}"),
        @bunnia.data("metric-id", input.id),
      ],
      [@bunnia.text("\{input.label}: \{input.value}")],
    ),
  )
}

///|
fn building_list(buildings : Array[CivicBuilding]) -> @bunnia.Node {
  let visible = visible_buildings(buildings, 12)
  @bunnia.view_with_attrs([@bunnia.class_name("wenyu-building-list")], [
    @bunnia.windowed_list(
      visible,
      total_count=buildings.length(),
      render=building_card,
    ),
  ])
}

///|
fn visible_buildings(
  buildings : Array[CivicBuilding],
  limit : Int,
) -> Array[CivicBuilding] {
  let output : Array[CivicBuilding] = []
  let stop = if buildings.length() < limit { buildings.length() } else { limit }
  for i in 0..<stop {
    output.push(buildings[i])
  }
  output
}

///|
fn building_card(input : CivicBuilding) -> @bunnia.Node {
  @bunnia.keyed(
    input.id,
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("wenyu-building bunnia-status-\{input.status}"),
        @bunnia.data("building-id", input.id),
        @bunnia.data("status", input.status),
      ],
      [
        @bunnia.text(input.name),
        @bunnia.text(input.summary),
        @bunnia.button("Select", "select-\{input.id}"),
      ],
    ),
  )
}

///|
fn review_panel(_input : WenyuProjection) -> @bunnia.Node {
  @bunnia.review_controls(
    @bunnia.review_action(
      id="wenyu-overview-review",
      label="Overview review",
      approve_message="approve-wenyu-review",
      reject_message="submit-operator-request",
    ),
  )
}

///|
fn map_view(input : WenyuProjection) -> @bunnia.Node {
  @bunnia.static_scene_view_with_viewport(demo_scene(input), demo_viewport())
}

///|
fn demo_viewport() -> @bunnia.SceneViewport {
  @bunnia.scene_viewport(x=0, y=0, width=640, height=460)
}

///|
fn demo_scene(input : WenyuProjection) -> @bunnia.Scene {
  @bunnia.scene(
    "wenyu-map",
    @bunnia.scene_size(640, 460),
    [@bunnia.layer("buildings", 1, markers_from_buildings(input.buildings))],
    assets=scene_assets(),
  )
}

///|
fn large_scene(building_count : Int) -> @bunnia.Scene {
  demo_scene(large_projection(building_count))
}

///|
fn markers_from_buildings(
  buildings : Array[CivicBuilding],
) -> Array[@bunnia.SceneMarker] {
  let markers : Array[@bunnia.SceneMarker] = []
  for item in buildings {
    markers.push(
      @bunnia.marker(
        id=item.id,
        label=item.name,
        x=item.x,
        y=item.y,
        status=item.status,
        tap_message="select-\{item.id}",
        asset_ref=item.asset_ref,
      ),
    )
  }
  markers
}

///|
fn trace_view(input : WenyuProjection) -> @bunnia.Node {
  @bunnia.communication_trace(demo_communications(input))
}

///|
fn demo_scene_thread_links(
  input : WenyuProjection,
) -> Array[@bunnia.SceneThreadLink] {
  [
    @bunnia.scene_thread_link(
      id="thread-\{input.selected_building}",
      scene_id="wenyu-map",
      marker_id=input.selected_building,
      thread_id=input.id,
      subject_ref="scene://wenyu-map/\{input.selected_building}",
      status=input.status,
      unread_count=1,
      open_message="open-wenyu-thread",
    ),
  ]
}

///|
fn demo_communications(input : WenyuProjection) -> Array[@bunnia.Communication] {
  [
    @bunnia.message_event(
      id="trace-snapshot",
      thread_id=input.id,
      from_actor_id="agent-planner",
      text="Snapshot loaded for overview review.",
    ),
    @bunnia.review_request(
      id="trace-review",
      thread_id=input.id,
      from_actor_id="agent-planner",
      to_actor_id="operator",
      text="Review suggested building state before dispatch.",
      artifact_ref="artifact://wenyu-overview",
    ),
  ]
}

///|
fn scene_assets() -> Array[@bunnia.SceneAsset] {
  [@bunnia.sprite_asset("building-sprite", "/assets/wenyu-building.png", 4096)]
}

///|
fn demo_initial_data_json() -> String {
  "{\"backendBaseUrl\":\"\",\"projection\":{\"selectedBuilding\":\"building-dock\"},\"review\":{\"wenyuOverview\":\"pending\"}}"
}
