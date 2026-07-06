///|
pub type Attr = @core.Attr

///|
pub type EventBinding = @core.EventBinding

///|
pub type Node = @core.Node

///|
pub type SurfaceStatusKind = @core.SurfaceStatusKind

///|
pub type SurfaceStatus = @core.SurfaceStatus

///|
pub type Platform = @core.Platform

///|
pub type PlatformAdapter = @core.PlatformAdapter

///|
pub type RenderBudget = @core.RenderBudget

///|
pub type RenderPlan = @core.RenderPlan

///|
pub type PatchKind = @core.PatchKind

///|
pub type Patch = @core.Patch

///|
pub type PatchBudget = @core.PatchBudget

///|
pub type PatchPlan = @core.PatchPlan

///|
pub type Program[Model, Msg] = @program.Program[Model, Msg]

///|
pub type Step[Model] = @program.Step[Model]

///|
pub type ActorKind = @agent.ActorKind

///|
pub type RunStatus = @agent.RunStatus

///|
pub type ReviewState = @agent.ReviewState

///|
pub type CommunicationKind = @agent.CommunicationKind

///|
pub type Actor = @agent.Actor

///|
pub type Thread = @agent.Thread

///|
pub type Message = @agent.Message

///|
pub type Communication = @agent.Communication

///|
pub type CommunicationFilter = @agent.CommunicationFilter

///|
pub type CommunicationBudget = @agent.CommunicationBudget

///|
pub type CommunicationPlan = @agent.CommunicationPlan

///|
pub type ReviewAction = @agent.ReviewAction

///|
pub type ToolResultCard = @agent.ToolResultCard

///|
pub type ToolResultBudget = @agent.ToolResultBudget

///|
pub type ToolResultPlan = @agent.ToolResultPlan

///|
pub type AgentDeltaKind = @agent.AgentDeltaKind

///|
pub type AgentDelta = @agent.AgentDelta

///|
pub type AgentDeltaPlan = @agent.AgentDeltaPlan

///|
pub type SceneSize = @scene.SceneSize

///|
pub type SceneViewport = @scene.SceneViewport

///|
pub type SceneCamera = @scene.SceneCamera

///|
pub type SceneCameraBudget = @scene.SceneCameraBudget

///|
pub type SceneCameraPlan = @scene.SceneCameraPlan

///|
pub type SceneAssetKind = @scene.SceneAssetKind

///|
pub type SceneAsset = @scene.SceneAsset

///|
pub type SceneAssetBudget = @scene.SceneAssetBudget

///|
pub type SceneAssetPolicy = @scene.SceneAssetPolicy

///|
pub type SceneAssetPlan = @scene.SceneAssetPlan

///|
pub type SceneMarker = @scene.SceneMarker

///|
pub type SceneRegion = @scene.SceneRegion

///|
pub type SceneThreadLink = @scene.SceneThreadLink

///|
pub type SceneThreadBudget = @scene.SceneThreadBudget

///|
pub type SceneThreadPlan = @scene.SceneThreadPlan

///|
pub type SceneLayer = @scene.SceneLayer

///|
pub type Scene = @scene.Scene

///|
pub type SceneRenderMode = @scene.SceneRenderMode

///|
pub type SceneQualityLevel = @scene.SceneQualityLevel

///|
pub type SceneRenderBudget = @scene.SceneRenderBudget

///|
pub type SceneRenderPlan = @scene.SceneRenderPlan

///|
pub type SceneSurfacePreference = @scene.SceneSurfacePreference

///|
pub type SceneSurfacePlan = @scene.SceneSurfacePlan

///|
pub type SceneVisualQualityBudget = @scene.SceneVisualQualityBudget

///|
pub type SceneVisualQualityPlan = @scene.SceneVisualQualityPlan

///|
pub type EffectKind = @effects.EffectKind

///|
pub type BackendEndpointKind = @effects.BackendEndpointKind

///|
pub type HttpMethod = @effects.HttpMethod

///|
pub type BackendState = @effects.BackendState

///|
pub type Effect = @effects.Effect

///|
pub type EffectPlan = @effects.EffectPlan

///|
pub type BackendEndpoint = @effects.BackendEndpoint

///|
pub type BackendContract = @effects.BackendContract

///|
pub type BackendBudget = @effects.BackendBudget

///|
pub type BackendPlan = @effects.BackendPlan

///|
pub type BackendResultKind = @effects.BackendResultKind

///|
pub type BackendRequest = @effects.BackendRequest

///|
pub type BackendResult = @effects.BackendResult

///|
pub type SnapshotDeltaKind = @effects.SnapshotDeltaKind

///|
pub type SnapshotDelta = @effects.SnapshotDelta

///|
pub type SnapshotDeltaPlan = @effects.SnapshotDeltaPlan

///|
pub type WechatPage = @wechat.WechatPage

///|
pub type WechatEventPatch = @wechat.WechatEventPatch

///|
pub type WechatRuntime = @wechat.WechatRuntime

///|
pub type WechatBuildBudget = @wechat.WechatBuildBudget

///|
pub type WechatBuildReport = @wechat.WechatBuildReport

///|
pub type WechatFile = @wechat.WechatFile

///|
pub type WechatSceneAsset = @wechat.WechatSceneAsset

///|
pub type WechatManifestFile = @wechat.WechatManifestFile

///|
pub type WechatManifestSceneAsset = @wechat.WechatManifestSceneAsset

///|
pub type WechatManifestPage = @wechat.WechatManifestPage

///|
pub type WechatProjectManifest = @wechat.WechatProjectManifest

///|
pub type WechatProjectPage = @wechat.WechatProjectPage

///|
pub type WechatProject = @wechat.WechatProject

///|
pub type BuildProfile = @tooling.BuildProfile

///|
pub type BuildProfileBudget = @tooling.BuildProfileBudget

///|
pub type BuildProfileGate = @tooling.BuildProfileGate

///|
pub type PlatformComponentMapping = @tooling.PlatformComponentMapping

///|
pub type PlatformEventMapping = @tooling.PlatformEventMapping

///|
pub type PlatformGeneratorStatus = @tooling.PlatformGeneratorStatus

///|
pub type PlatformTargetSupport = @tooling.PlatformTargetSupport

///|
pub type PlatformLimitsReport = @tooling.PlatformLimitsReport

///|
pub type CiPlanStep = @tooling.CiPlanStep

///|
pub type CiPlan = @tooling.CiPlan

///|
pub type GeneratedSnapshotFile = @tooling.GeneratedSnapshotFile

///|
pub type GeneratedSnapshot = @tooling.GeneratedSnapshot

///|
pub type RouteInspection = @tooling.RouteInspection

///|
pub type ProjectInspection = @tooling.ProjectInspection

///|
pub type ProjectInspectionBudget = @tooling.ProjectInspectionBudget

///|
pub type ProjectInspectionGate = @tooling.ProjectInspectionGate

///|
pub type ScaffoldFile = @tooling.ScaffoldFile

///|
pub type ScaffoldPlan = @tooling.ScaffoldPlan

///|
pub fn attr(name : String, value : String) -> Attr {
  @core.attr(name, value)
}

///|
pub fn class_name(value : String) -> Attr {
  @core.class_name(value)
}

///|
pub fn id(value : String) -> Attr {
  @core.id(value)
}

///|
pub fn data(name : String, value : String) -> Attr {
  @core.data(name, value)
}

///|
pub fn event(event : String, message : String) -> EventBinding {
  @core.event(event, message)
}

///|
pub fn tap(message : String) -> EventBinding {
  @core.tap(message)
}

///|
pub fn node(
  kind~ : String,
  key? : String = "",
  attrs? : Array[Attr] = [],
  events? : Array[EventBinding] = [],
  children? : Array[Node] = [],
  text? : String = "",
) -> Node {
  @core.node(kind~, key~, attrs~, events~, children~, text~)
}

///|
pub fn keyed(key : String, child : Node) -> Node {
  @core.keyed(key, child)
}

///|
pub fn page(children : Array[Node]) -> Node {
  @core.page(children)
}

///|
pub fn view(children : Array[Node]) -> Node {
  @core.view(children)
}

///|
pub fn view_with_attrs(attrs : Array[Attr], children : Array[Node]) -> Node {
  @core.view_with_attrs(attrs, children)
}

///|
pub fn scroll_view(children : Array[Node]) -> Node {
  @core.scroll_view(children)
}

///|
pub fn text(value : String) -> Node {
  @core.text(value)
}

///|
pub fn input(
  name~ : String,
  value? : String = "",
  input_message? : String = "",
) -> Node {
  @core.input(name~, value~, input_message~)
}

///|
pub fn form(submit_message : String, children : Array[Node]) -> Node {
  @core.form(submit_message, children)
}

///|
pub fn[Item] list(items : Array[Item], render : (Item) -> Node) -> Node {
  @core.list(items, render)
}

///|
pub fn[Item] windowed_list(
  items : Array[Item],
  total_count~ : Int,
  offset? : Int = 0,
  render~ : (Item) -> Node,
) -> Node {
  @core.windowed_list(items, total_count~, offset~, render~)
}

///|
pub fn when(condition : Bool, child : Node) -> Node {
  @core.when(condition, child)
}

///|
pub fn image(src : String, alt : String) -> Node {
  @core.image(src, alt)
}

///|
pub fn button(label : String, message : String) -> Node {
  @core.button(label, message)
}

///|
pub fn surface_status(
  kind~ : SurfaceStatusKind,
  label~ : String,
  detail? : String = "",
  action_message? : String = "",
) -> SurfaceStatus {
  @core.surface_status(kind~, label~, detail~, action_message~)
}

///|
pub fn surface_loading(
  label? : String = "Loading",
  detail? : String = "",
) -> SurfaceStatus {
  @core.surface_loading(label~, detail~)
}

///|
pub fn surface_ready(
  label? : String = "Ready",
  detail? : String = "",
) -> SurfaceStatus {
  @core.surface_ready(label~, detail~)
}

///|
pub fn surface_stale(
  label? : String = "Stale",
  detail? : String = "",
  action_message? : String = "",
) -> SurfaceStatus {
  @core.surface_stale(label~, detail~, action_message~)
}

///|
pub fn surface_error(
  label? : String = "Error",
  detail? : String = "",
  action_message? : String = "",
) -> SurfaceStatus {
  @core.surface_error(label~, detail~, action_message~)
}

///|
pub fn surface_retry(
  label? : String = "Retry",
  detail? : String = "",
  action_message? : String = "",
) -> SurfaceStatus {
  @core.surface_retry(label~, detail~, action_message~)
}

///|
pub fn surface_cancelled(
  label? : String = "Cancelled",
  detail? : String = "",
  action_message? : String = "",
) -> SurfaceStatus {
  @core.surface_cancelled(label~, detail~, action_message~)
}

///|
pub fn surface_degraded(
  label? : String = "Degraded",
  detail? : String = "",
  action_message? : String = "",
) -> SurfaceStatus {
  @core.surface_degraded(label~, detail~, action_message~)
}

///|
pub fn surface_status_kind_id(kind : SurfaceStatusKind) -> String {
  @core.surface_status_kind_id(kind)
}

///|
pub fn surface_status_badge(status : SurfaceStatus) -> Node {
  @core.surface_status_badge(status)
}

///|
pub fn surface_status_overlay(status : SurfaceStatus, child : Node) -> Node {
  @core.surface_status_overlay(status, child)
}

///|
pub fn surface_status_loading() -> SurfaceStatusKind {
  @core.SurfaceLoading
}

///|
pub fn surface_status_ready() -> SurfaceStatusKind {
  @core.SurfaceReady
}

///|
pub fn surface_status_stale() -> SurfaceStatusKind {
  @core.SurfaceStale
}

///|
pub fn surface_status_error() -> SurfaceStatusKind {
  @core.SurfaceError
}

///|
pub fn surface_status_retry() -> SurfaceStatusKind {
  @core.SurfaceRetry
}

///|
pub fn surface_status_cancelled() -> SurfaceStatusKind {
  @core.SurfaceCancelled
}

///|
pub fn surface_status_degraded() -> SurfaceStatusKind {
  @core.SurfaceDegraded
}

///|
pub fn canvas(canvas_id : String) -> Node {
  @core.canvas(canvas_id)
}

///|
pub fn custom(
  kind : String,
  attrs : Array[Attr],
  children : Array[Node],
) -> Node {
  @core.custom(kind, attrs, children)
}

///|
pub fn node_count(root : Node) -> Int {
  @core.node_count(root)
}

///|
pub fn max_depth(root : Node) -> Int {
  @core.max_depth(root)
}

///|
pub fn platform_id(platform : Platform) -> String {
  @core.platform_id(platform)
}

///|
pub fn platform_label(platform : Platform) -> String {
  @core.platform_label(platform)
}

///|
pub fn adapter(platform : Platform) -> PlatformAdapter {
  @core.adapter(platform)
}

///|
pub fn platform_adapter(
  platform~ : Platform,
  id~ : String,
  page_component~ : String,
  tap_event~ : String,
  component_prefix? : String = "",
  supports_canvas? : Bool = true,
  supports_cloud? : Bool = false,
  supports_stream? : Bool = true,
) -> PlatformAdapter {
  @core.platform_adapter(
    platform~,
    id~,
    page_component~,
    tap_event~,
    component_prefix~,
    supports_canvas~,
    supports_cloud~,
    supports_stream~,
  )
}

///|
pub fn supported_platforms() -> Array[Platform] {
  @core.supported_platforms()
}

///|
pub fn wechat() -> Platform {
  @core.Wechat
}

///|
pub fn alipay() -> Platform {
  @core.Alipay
}

///|
pub fn tiktok() -> Platform {
  @core.TikTok
}

///|
pub fn default_render_budget() -> RenderBudget {
  @core.default_render_budget()
}

///|
pub fn render_budget(
  max_nodes~ : Int,
  max_depth~ : Int,
  max_events~ : Int,
  max_initial_data_bytes~ : Int,
  max_unwindowed_list_children? : Int = 64,
  max_scene_markers? : Int = 600,
  max_scene_regions? : Int = 300,
  max_scene_assets? : Int = 64,
  max_degraded_scenes? : Int = 0,
) -> RenderBudget {
  @core.render_budget(
    max_nodes~,
    max_depth~,
    max_events~,
    max_initial_data_bytes~,
    max_unwindowed_list_children~,
    max_scene_markers~,
    max_scene_regions~,
    max_scene_assets~,
    max_degraded_scenes~,
  )
}

///|
pub fn plan(root : Node, platform : Platform) -> RenderPlan {
  @core.plan(root, platform)
}

///|
pub fn plan_for_adapter(root : Node, adapter : PlatformAdapter) -> RenderPlan {
  @core.plan_for_adapter(root, adapter)
}

///|
pub fn plan_with_budget(
  root : Node,
  platform : Platform,
  budget : RenderBudget,
) -> RenderPlan {
  @core.plan_with_budget(root, platform, budget)
}

///|
pub fn plan_for_adapter_with_budget(
  root : Node,
  adapter : PlatformAdapter,
  budget : RenderBudget,
) -> RenderPlan {
  @core.plan_for_adapter_with_budget(root, adapter, budget)
}

///|
pub fn[Model] step(
  model~ : Model,
  effects? : Array[Effect] = [],
  patches? : Array[Patch] = [],
) -> Step[Model] {
  @program.step(model~, effects~, patches~)
}

///|
pub fn[Model, Msg] program(
  id~ : String,
  model~ : Model,
  view~ : (Model) -> Node,
  update~ : (Model, Msg) -> Step[Model],
  init_effects? : Array[Effect] = [],
) -> Program[Model, Msg] {
  @program.program(id~, model~, view~, update~, init_effects~)
}

///|
pub fn[Model, Msg] current_view(input : Program[Model, Msg]) -> Node {
  @program.current_view(input)
}

///|
pub fn[Model, Msg] apply(
  input : Program[Model, Msg],
  message : Msg,
) -> Program[Model, Msg] {
  @program.apply(input, message)
}

///|
pub fn[Model] step_patches(input : Step[Model]) -> PatchPlan {
  @program.step_patches(input)
}

///|
pub fn patch_budget(max_patches~ : Int, max_patch_bytes~ : Int) -> PatchBudget {
  @core.patch_budget(max_patches~, max_patch_bytes~)
}

///|
pub fn default_patch_budget() -> PatchBudget {
  @core.default_patch_budget()
}

///|
pub fn set_json(path : String, value_json : String) -> Patch {
  @core.set_json(path, value_json)
}

///|
pub fn set_string(path : String, value : String) -> Patch {
  @core.set_string(path, value)
}

///|
pub fn append_json(path : String, value_json : String) -> Patch {
  @core.append_json(path, value_json)
}

///|
pub fn remove_path(path : String) -> Patch {
  @core.remove_path(path)
}

///|
pub fn plan_patches(patches : Array[Patch]) -> PatchPlan {
  @core.plan_patches(patches)
}

///|
pub fn plan_patches_with_budget(
  patches : Array[Patch],
  budget : PatchBudget,
) -> PatchPlan {
  @core.plan_patches_with_budget(patches, budget)
}

///|
pub fn actor(
  id~ : String,
  label~ : String,
  kind? : ActorKind = @agent.Agent,
) -> Actor {
  @agent.actor(id~, label~, kind~)
}

///|
pub fn message(
  id~ : String,
  actor_id~ : String,
  thread_id~ : String,
  text~ : String,
  artifact_ref? : String = "",
  status? : RunStatus = @agent.Done,
) -> Message {
  @agent.message(id~, actor_id~, thread_id~, text~, artifact_ref~, status~)
}

///|
pub fn review_action(
  id~ : String,
  label~ : String,
  approve_message~ : String,
  reject_message~ : String,
  state? : ReviewState = @agent.Pending,
) -> ReviewAction {
  @agent.review_action(id~, label~, approve_message~, reject_message~, state~)
}

///|
pub fn tool_result_card(
  id~ : String,
  tool_name~ : String,
  title~ : String,
  summary~ : String,
  artifact_ref? : String = "",
  status? : RunStatus = @agent.Done,
  open_message? : String = "",
  acknowledge_message? : String = "",
) -> ToolResultCard {
  @agent.tool_result_card(
    id~,
    tool_name~,
    title~,
    summary~,
    artifact_ref~,
    status~,
    open_message~,
    acknowledge_message~,
  )
}

///|
pub fn review_action_enabled(action : ReviewAction) -> Bool {
  @agent.review_action_enabled(action)
}

///|
pub fn thread(
  id~ : String,
  title~ : String,
  owner_actor_id~ : String,
  subject_ref? : String = "",
  status? : RunStatus = @agent.Running,
) -> Thread {
  @agent.thread(id~, title~, owner_actor_id~, subject_ref~, status~)
}

///|
pub fn communication(
  id~ : String,
  thread_id~ : String,
  kind~ : CommunicationKind,
  from_actor_id~ : String,
  to_actor_id? : String = "",
  text~ : String,
  artifact_ref? : String = "",
  timestamp? : String = "",
  status? : RunStatus = @agent.Done,
  open_message? : String = "",
) -> Communication {
  @agent.communication(
    id~,
    thread_id~,
    kind~,
    from_actor_id~,
    to_actor_id~,
    text~,
    artifact_ref~,
    timestamp~,
    status~,
    open_message~,
  )
}

///|
pub fn message_event(
  id~ : String,
  thread_id~ : String,
  from_actor_id~ : String,
  text~ : String,
  artifact_ref? : String = "",
  open_message? : String = "",
) -> Communication {
  @agent.message_event(
    id~,
    thread_id~,
    from_actor_id~,
    text~,
    artifact_ref~,
    open_message~,
  )
}

///|
pub fn handoff(
  id~ : String,
  thread_id~ : String,
  from_actor_id~ : String,
  to_actor_id~ : String,
  text~ : String,
  open_message? : String = "",
) -> Communication {
  @agent.handoff(
    id~,
    thread_id~,
    from_actor_id~,
    to_actor_id~,
    text~,
    open_message~,
  )
}

///|
pub fn broadcast(
  id~ : String,
  thread_id~ : String,
  from_actor_id~ : String,
  text~ : String,
  open_message? : String = "",
) -> Communication {
  @agent.broadcast(id~, thread_id~, from_actor_id~, text~, open_message~)
}

///|
pub fn review_request(
  id~ : String,
  thread_id~ : String,
  from_actor_id~ : String,
  to_actor_id~ : String,
  text~ : String,
  artifact_ref? : String = "",
  open_message? : String = "",
) -> Communication {
  @agent.review_request(
    id~,
    thread_id~,
    from_actor_id~,
    to_actor_id~,
    text~,
    artifact_ref~,
    open_message~,
  )
}

///|
pub fn approval(
  id~ : String,
  thread_id~ : String,
  from_actor_id~ : String,
  to_actor_id~ : String,
  text~ : String,
  artifact_ref? : String = "",
  open_message? : String = "",
) -> Communication {
  @agent.approval(
    id~,
    thread_id~,
    from_actor_id~,
    to_actor_id~,
    text~,
    artifact_ref~,
    open_message~,
  )
}

///|
pub fn tool_result(
  id~ : String,
  thread_id~ : String,
  from_actor_id~ : String,
  text~ : String,
  artifact_ref~ : String,
  open_message? : String = "",
) -> Communication {
  @agent.tool_result(
    id~,
    thread_id~,
    from_actor_id~,
    text~,
    artifact_ref~,
    open_message~,
  )
}

///|
pub fn recovery_notice(
  id~ : String,
  thread_id~ : String,
  from_actor_id~ : String,
  text~ : String,
  open_message? : String = "",
) -> Communication {
  @agent.recovery_notice(id~, thread_id~, from_actor_id~, text~, open_message~)
}

///|
pub fn communication_kind_id(kind : CommunicationKind) -> String {
  @agent.communication_kind_id(kind)
}

///|
pub fn communication_message() -> CommunicationKind {
  @agent.MessageEvent
}

///|
pub fn communication_handoff() -> CommunicationKind {
  @agent.Handoff
}

///|
pub fn communication_broadcast() -> CommunicationKind {
  @agent.Broadcast
}

///|
pub fn communication_review_request() -> CommunicationKind {
  @agent.ReviewRequest
}

///|
pub fn communication_approval() -> CommunicationKind {
  @agent.Approval
}

///|
pub fn communication_tool_result() -> CommunicationKind {
  @agent.ToolResult
}

///|
pub fn communication_recovery_notice() -> CommunicationKind {
  @agent.RecoveryNotice
}

///|
pub fn thread_card(input : Thread) -> Node {
  @agent.thread_card(input)
}

///|
pub fn communication_row(input : Communication) -> Node {
  @agent.communication_row(input)
}

///|
pub fn communication_trace(items : Array[Communication]) -> Node {
  @agent.communication_trace(items)
}

///|
pub fn windowed_communication_trace(
  items : Array[Communication],
  total_count~ : Int,
  offset? : Int = 0,
) -> Node {
  @agent.windowed_communication_trace(items, total_count~, offset~)
}

///|
pub fn communication_filter(
  thread_id? : String = "",
  actor_id? : String = "",
  kind_id? : String = "",
  include_resolved_reviews? : Bool = true,
) -> CommunicationFilter {
  @agent.communication_filter(
    thread_id~,
    actor_id~,
    kind_id~,
    include_resolved_reviews~,
  )
}

///|
pub fn all_communication_filter() -> CommunicationFilter {
  @agent.all_communication_filter()
}

///|
pub fn communication_budget(
  max_visible_count? : Int = 80,
  max_review_request_count? : Int = 32,
  max_unresolved_review_count? : Int = 16,
  max_artifact_ref_count? : Int = 32,
) -> CommunicationBudget {
  @agent.communication_budget(
    max_visible_count~,
    max_review_request_count~,
    max_unresolved_review_count~,
    max_artifact_ref_count~,
  )
}

///|
pub fn default_communication_budget() -> CommunicationBudget {
  @agent.default_communication_budget()
}

///|
pub fn filter_communications(
  items : Array[Communication],
  filter : CommunicationFilter,
) -> Array[Communication] {
  @agent.filter_communications(items, filter)
}

///|
pub fn plan_communications(items : Array[Communication]) -> CommunicationPlan {
  @agent.plan_communications(items)
}

///|
pub fn plan_communications_with_budget(
  items : Array[Communication],
  budget : CommunicationBudget,
) -> CommunicationPlan {
  @agent.plan_communications_with_budget(items, budget)
}

///|
pub fn plan_filtered_communications(
  items : Array[Communication],
  filter : CommunicationFilter,
  budget? : CommunicationBudget = @agent.default_communication_budget(),
) -> CommunicationPlan {
  @agent.plan_filtered_communications(items, filter, budget~)
}

///|
pub fn message_row(item : Message) -> Node {
  @agent.message_row(item)
}

///|
pub fn message_feed(messages : Array[Message]) -> Node {
  @agent.message_feed(messages)
}

///|
pub fn windowed_message_feed(
  messages : Array[Message],
  total_count~ : Int,
  offset? : Int = 0,
) -> Node {
  @agent.windowed_message_feed(messages, total_count~, offset~)
}

///|
pub fn tool_result_card_view(card : ToolResultCard) -> Node {
  @agent.tool_result_card_view(card)
}

///|
pub fn tool_result_card_list(cards : Array[ToolResultCard]) -> Node {
  @agent.tool_result_card_list(cards)
}

///|
pub fn windowed_tool_result_card_list(
  cards : Array[ToolResultCard],
  total_count~ : Int,
  offset? : Int = 0,
) -> Node {
  @agent.windowed_tool_result_card_list(cards, total_count~, offset~)
}

///|
pub fn tool_result_budget(
  max_visible_count? : Int = 32,
  max_pending_ack_count? : Int = 16,
  max_missing_ack_count? : Int = 0,
  max_artifact_ref_count? : Int = 32,
) -> ToolResultBudget {
  @agent.tool_result_budget(
    max_visible_count~,
    max_pending_ack_count~,
    max_missing_ack_count~,
    max_artifact_ref_count~,
  )
}

///|
pub fn default_tool_result_budget() -> ToolResultBudget {
  @agent.default_tool_result_budget()
}

///|
pub fn plan_tool_result_cards(cards : Array[ToolResultCard]) -> ToolResultPlan {
  @agent.plan_tool_result_cards(cards)
}

///|
pub fn plan_tool_result_cards_with_budget(
  cards : Array[ToolResultCard],
  budget : ToolResultBudget,
) -> ToolResultPlan {
  @agent.plan_tool_result_cards_with_budget(cards, budget)
}

///|
pub fn review_controls(action : ReviewAction) -> Node {
  @agent.review_controls(action)
}

///|
pub fn append_message_delta(target_path : String, item : Message) -> AgentDelta {
  @agent.append_message_delta(target_path, item)
}

///|
pub fn append_communication_delta(
  target_path : String,
  item : Communication,
) -> AgentDelta {
  @agent.append_communication_delta(target_path, item)
}

///|
pub fn append_stream_chunk_delta(
  target_path : String,
  chunk_id : String,
  text : String,
  status? : RunStatus = @agent.Running,
) -> AgentDelta {
  @agent.append_stream_chunk_delta(target_path, chunk_id, text, status~)
}

///|
pub fn set_stream_chunk_delta(
  target_path : String,
  chunk_id : String,
  text : String,
  status? : RunStatus = @agent.Running,
) -> AgentDelta {
  @agent.set_stream_chunk_delta(target_path, chunk_id, text, status~)
}

///|
pub fn set_run_status_delta(
  target_path : String,
  status : RunStatus,
) -> AgentDelta {
  @agent.set_run_status_delta(target_path, status)
}

///|
pub fn set_review_state_delta(
  target_path : String,
  state : ReviewState,
) -> AgentDelta {
  @agent.set_review_state_delta(target_path, state)
}

///|
pub fn plan_agent_deltas(deltas : Array[AgentDelta]) -> AgentDeltaPlan {
  @agent.plan_agent_deltas(deltas)
}

///|
pub fn plan_agent_deltas_with_budget(
  deltas : Array[AgentDelta],
  budget : PatchBudget,
) -> AgentDeltaPlan {
  @agent.plan_agent_deltas_with_budget(deltas, budget)
}

///|
pub fn agent_delta_kind_id(kind : AgentDeltaKind) -> String {
  @agent.agent_delta_kind_id(kind)
}

///|
pub fn run_status_id(status : RunStatus) -> String {
  @agent.run_status_id(status)
}

///|
pub fn review_state_id(state : ReviewState) -> String {
  @agent.review_state_id(state)
}

///|
pub fn run_idle() -> RunStatus {
  @agent.Idle
}

///|
pub fn run_running() -> RunStatus {
  @agent.Running
}

///|
pub fn run_waiting_review() -> RunStatus {
  @agent.WaitingReview
}

///|
pub fn run_done() -> RunStatus {
  @agent.Done
}

///|
pub fn run_failed() -> RunStatus {
  @agent.Failed
}

///|
pub fn run_cancelled() -> RunStatus {
  @agent.Cancelled
}

///|
pub fn review_not_required() -> ReviewState {
  @agent.NotRequired
}

///|
pub fn review_pending() -> ReviewState {
  @agent.Pending
}

///|
pub fn review_approved() -> ReviewState {
  @agent.Approved
}

///|
pub fn review_rejected() -> ReviewState {
  @agent.Rejected
}

///|
pub fn review_cancelled() -> ReviewState {
  @agent.CancelledReview
}

///|
pub fn review_failed() -> ReviewState {
  @agent.FailedReview
}

///|
pub fn scene_size(width : Int, height : Int) -> SceneSize {
  @scene.scene_size(width, height)
}

///|
pub fn scene_viewport(
  x~ : Int,
  y~ : Int,
  width~ : Int,
  height~ : Int,
) -> SceneViewport {
  @scene.scene_viewport(x~, y~, width~, height~)
}

///|
pub fn scene_camera(
  scene_id~ : String,
  x~ : Int,
  y~ : Int,
  width~ : Int,
  height~ : Int,
  zoom_percent? : Int = 100,
) -> SceneCamera {
  @scene.scene_camera(scene_id~, x~, y~, width~, height~, zoom_percent~)
}

///|
pub fn scene_camera_from_viewport(
  scene_id : String,
  viewport : SceneViewport,
  zoom_percent? : Int = 100,
) -> SceneCamera {
  @scene.scene_camera_from_viewport(scene_id, viewport, zoom_percent~)
}

///|
pub fn scene_camera_budget(
  min_zoom_percent? : Int = 50,
  max_zoom_percent? : Int = 300,
  min_viewport_width? : Int = 64,
  min_viewport_height? : Int = 64,
) -> SceneCameraBudget {
  @scene.scene_camera_budget(
    min_zoom_percent~,
    max_zoom_percent~,
    min_viewport_width~,
    min_viewport_height~,
  )
}

///|
pub fn default_scene_camera_budget() -> SceneCameraBudget {
  @scene.default_scene_camera_budget()
}

///|
pub fn plan_scene_camera(
  input : Scene,
  camera : SceneCamera,
) -> SceneCameraPlan {
  @scene.plan_scene_camera(input, camera)
}

///|
pub fn plan_scene_camera_with_budget(
  input : Scene,
  camera : SceneCamera,
  budget : SceneCameraBudget,
) -> SceneCameraPlan {
  @scene.plan_scene_camera_with_budget(input, camera, budget)
}

///|
pub fn scene_asset(
  id~ : String,
  kind~ : SceneAssetKind,
  src~ : String,
  estimated_bytes? : Int = 0,
  remote? : Bool = false,
) -> SceneAsset {
  @scene.scene_asset(id~, kind~, src~, estimated_bytes~, remote~)
}

///|
pub fn image_asset(
  id : String,
  src : String,
  estimated_bytes : Int,
) -> SceneAsset {
  @scene.image_asset(id, src, estimated_bytes)
}

///|
pub fn sprite_asset(
  id : String,
  src : String,
  estimated_bytes : Int,
) -> SceneAsset {
  @scene.sprite_asset(id, src, estimated_bytes)
}

///|
pub fn tile_asset(
  id : String,
  src : String,
  estimated_bytes : Int,
) -> SceneAsset {
  @scene.tile_asset(id, src, estimated_bytes)
}

///|
pub fn remote_image_asset(id : String, src : String) -> SceneAsset {
  @scene.remote_image_asset(id, src)
}

///|
pub fn scene_asset_budget(
  max_assets~ : Int,
  max_package_bytes~ : Int,
  max_remote_assets~ : Int,
) -> SceneAssetBudget {
  @scene.scene_asset_budget(max_assets~, max_package_bytes~, max_remote_assets~)
}

///|
pub fn default_scene_asset_budget() -> SceneAssetBudget {
  @scene.default_scene_asset_budget()
}

///|
pub fn scene_asset_policy(
  approved_remote_domains~ : Array[String],
  require_https? : Bool = true,
) -> SceneAssetPolicy {
  @scene.scene_asset_policy(approved_remote_domains~, require_https~)
}

///|
pub fn default_scene_asset_policy() -> SceneAssetPolicy {
  @scene.default_scene_asset_policy()
}

///|
pub fn plan_scene_assets(assets : Array[SceneAsset]) -> SceneAssetPlan {
  @scene.plan_scene_assets(assets)
}

///|
pub fn plan_scene_assets_with_budget(
  assets : Array[SceneAsset],
  budget : SceneAssetBudget,
) -> SceneAssetPlan {
  @scene.plan_scene_assets_with_budget(assets, budget)
}

///|
pub fn plan_scene_assets_with_budget_and_policy(
  assets : Array[SceneAsset],
  budget : SceneAssetBudget,
  policy : SceneAssetPolicy,
) -> SceneAssetPlan {
  @scene.plan_scene_assets_with_budget_and_policy(assets, budget, policy)
}

///|
pub fn scene_asset_kind_id(kind : SceneAssetKind) -> String {
  @scene.scene_asset_kind_id(kind)
}

///|
pub fn scene_asset_image() -> SceneAssetKind {
  @scene.Image
}

///|
pub fn scene_asset_sprite() -> SceneAssetKind {
  @scene.Sprite
}

///|
pub fn scene_asset_tile() -> SceneAssetKind {
  @scene.Tile
}

///|
pub fn scene_asset_remote_image() -> SceneAssetKind {
  @scene.RemoteImage
}

///|
pub fn marker(
  id~ : String,
  label~ : String,
  x~ : Int,
  y~ : Int,
  status? : String = "",
  tap_message? : String = "",
  asset_ref? : String = "",
  hit_width? : Int = 44,
  hit_height? : Int = 44,
) -> SceneMarker {
  @scene.marker(
    id~,
    label~,
    x~,
    y~,
    status~,
    tap_message~,
    asset_ref~,
    hit_width~,
    hit_height~,
  )
}

///|
pub fn region(
  id~ : String,
  label~ : String,
  x~ : Int,
  y~ : Int,
  width~ : Int,
  height~ : Int,
  status? : String = "",
  tap_message? : String = "",
) -> SceneRegion {
  @scene.region(id~, label~, x~, y~, width~, height~, status~, tap_message~)
}

///|
pub fn layer(
  id : String,
  z_index : Int,
  markers : Array[SceneMarker],
  regions? : Array[SceneRegion] = [],
) -> SceneLayer {
  @scene.layer(id, z_index, markers, regions~)
}

///|
pub fn scene(
  id : String,
  size : SceneSize,
  layers : Array[SceneLayer],
  assets? : Array[SceneAsset] = [],
) -> Scene {
  @scene.scene(id, size, layers, assets~)
}

///|
pub fn static_scene_view(input : Scene) -> Node {
  @scene.static_scene_view(input)
}

///|
pub fn static_scene_view_with_budget(
  input : Scene,
  budget : SceneRenderBudget,
) -> Node {
  @scene.static_scene_view_with_budget(input, budget)
}

///|
pub fn static_scene_view_with_viewport(
  input : Scene,
  viewport : SceneViewport,
  budget? : SceneRenderBudget = @scene.default_scene_render_budget(),
) -> Node {
  @scene.static_scene_view_with_viewport(input, viewport, budget~)
}

///|
pub fn static_scene_view_with_camera(
  input : Scene,
  camera : SceneCamera,
  budget? : SceneRenderBudget = @scene.default_scene_render_budget(),
  camera_budget? : SceneCameraBudget = @scene.default_scene_camera_budget(),
) -> Node {
  @scene.static_scene_view_with_camera(input, camera, budget~, camera_budget~)
}

///|
pub fn scene_thread_link(
  id~ : String,
  scene_id~ : String,
  subject_kind~ : String,
  subject_id~ : String,
  thread_id~ : String,
  subject_ref? : String = "",
  status? : String = "",
  unread_count? : Int = 0,
  open_message? : String = "",
) -> SceneThreadLink {
  @scene.scene_thread_link(
    id~,
    scene_id~,
    subject_kind~,
    subject_id~,
    thread_id~,
    subject_ref~,
    status~,
    unread_count~,
    open_message~,
  )
}

///|
pub fn scene_marker_thread_link(
  id~ : String,
  scene_id~ : String,
  marker_id~ : String,
  thread_id~ : String,
  subject_ref? : String = "",
  status? : String = "",
  unread_count? : Int = 0,
  open_message? : String = "",
) -> SceneThreadLink {
  @scene.scene_marker_thread_link(
    id~,
    scene_id~,
    marker_id~,
    thread_id~,
    subject_ref~,
    status~,
    unread_count~,
    open_message~,
  )
}

///|
pub fn scene_region_thread_link(
  id~ : String,
  scene_id~ : String,
  region_id~ : String,
  thread_id~ : String,
  subject_ref? : String = "",
  status? : String = "",
  unread_count? : Int = 0,
  open_message? : String = "",
) -> SceneThreadLink {
  @scene.scene_region_thread_link(
    id~,
    scene_id~,
    region_id~,
    thread_id~,
    subject_ref~,
    status~,
    unread_count~,
    open_message~,
  )
}

///|
pub fn scene_thread_overlay(links : Array[SceneThreadLink]) -> Node {
  @scene.scene_thread_overlay(links)
}

///|
pub fn windowed_scene_thread_overlay(
  links : Array[SceneThreadLink],
  total_count~ : Int,
  offset? : Int = 0,
) -> Node {
  @scene.windowed_scene_thread_overlay(links, total_count~, offset~)
}

///|
pub fn anchored_scene_thread_overlay(
  input : Scene,
  links : Array[SceneThreadLink],
) -> Node {
  @scene.anchored_scene_thread_overlay(input, links)
}

///|
pub fn windowed_anchored_scene_thread_overlay(
  input : Scene,
  links : Array[SceneThreadLink],
  total_count~ : Int,
  offset? : Int = 0,
) -> Node {
  @scene.windowed_anchored_scene_thread_overlay(
    input,
    links,
    total_count~,
    offset~,
  )
}

///|
pub fn anchored_scene_thread_overlay_with_viewport(
  input : Scene,
  viewport : SceneViewport,
  links : Array[SceneThreadLink],
) -> Node {
  @scene.anchored_scene_thread_overlay_with_viewport(input, viewport, links)
}

///|
pub fn windowed_anchored_scene_thread_overlay_with_viewport(
  input : Scene,
  viewport : SceneViewport,
  links : Array[SceneThreadLink],
  total_count~ : Int,
  offset? : Int = 0,
) -> Node {
  @scene.windowed_anchored_scene_thread_overlay_with_viewport(
    input,
    viewport,
    links,
    total_count~,
    offset~,
  )
}

///|
pub fn static_scene_with_threads(
  input : Scene,
  links : Array[SceneThreadLink],
) -> Node {
  @scene.static_scene_with_threads(input, links)
}

///|
pub fn static_scene_with_windowed_threads(
  input : Scene,
  links : Array[SceneThreadLink],
  total_count~ : Int,
  offset? : Int = 0,
) -> Node {
  @scene.static_scene_with_windowed_threads(input, links, total_count~, offset~)
}

///|
pub fn scene_thread_budget(
  max_visible_links? : Int = 80,
  max_unread_total? : Int = 999,
  max_orphan_links? : Int = 0,
  max_links_without_open_message? : Int = 0,
) -> SceneThreadBudget {
  @scene.scene_thread_budget(
    max_visible_links~,
    max_unread_total~,
    max_orphan_links~,
    max_links_without_open_message~,
  )
}

///|
pub fn default_scene_thread_budget() -> SceneThreadBudget {
  @scene.default_scene_thread_budget()
}

///|
pub fn plan_scene_threads(
  input : Scene,
  links : Array[SceneThreadLink],
) -> SceneThreadPlan {
  @scene.plan_scene_threads(input, links)
}

///|
pub fn plan_scene_threads_with_budget(
  input : Scene,
  links : Array[SceneThreadLink],
  budget : SceneThreadBudget,
) -> SceneThreadPlan {
  @scene.plan_scene_threads_with_budget(input, links, budget)
}

///|
pub fn plan_scene_threads_viewport(
  input : Scene,
  viewport : SceneViewport,
  links : Array[SceneThreadLink],
) -> SceneThreadPlan {
  @scene.plan_scene_threads_viewport(input, viewport, links)
}

///|
pub fn plan_scene_threads_viewport_with_budget(
  input : Scene,
  viewport : SceneViewport,
  links : Array[SceneThreadLink],
  budget : SceneThreadBudget,
) -> SceneThreadPlan {
  @scene.plan_scene_threads_viewport_with_budget(input, viewport, links, budget)
}

///|
pub fn scene_render_budget(
  max_layers~ : Int,
  max_markers~ : Int,
  max_static_assets~ : Int,
  max_regions? : Int = 128,
) -> SceneRenderBudget {
  @scene.scene_render_budget(
    max_layers~,
    max_markers~,
    max_static_assets~,
    max_regions~,
  )
}

///|
pub fn default_scene_render_budget() -> SceneRenderBudget {
  @scene.default_scene_render_budget()
}

///|
pub fn plan_scene_render(input : Scene) -> SceneRenderPlan {
  @scene.plan_scene_render(input)
}

///|
pub fn plan_scene_render_with_budget(
  input : Scene,
  budget : SceneRenderBudget,
) -> SceneRenderPlan {
  @scene.plan_scene_render_with_budget(input, budget)
}

///|
pub fn plan_scene_render_viewport(
  input : Scene,
  viewport : SceneViewport,
  budget : SceneRenderBudget,
) -> SceneRenderPlan {
  @scene.plan_scene_render_viewport(input, viewport, budget)
}

///|
pub fn plan_scene_surface_for_platform(
  input : Scene,
  platform : Platform,
  preference? : SceneSurfacePreference = @scene.PreferStaticSurface,
  budget? : SceneRenderBudget = @scene.default_scene_render_budget(),
) -> SceneSurfacePlan {
  @scene.plan_scene_surface_for_platform(input, platform, preference~, budget~)
}

///|
pub fn plan_scene_surface(
  input : Scene,
  adapter : PlatformAdapter,
  preference? : SceneSurfacePreference = @scene.PreferStaticSurface,
  budget? : SceneRenderBudget = @scene.default_scene_render_budget(),
) -> SceneSurfacePlan {
  @scene.plan_scene_surface(input, adapter, preference~, budget~)
}

///|
pub fn scene_visual_quality_budget(
  min_width~ : Int,
  min_height~ : Int,
  max_markers_without_status~ : Int,
  max_markers_without_tap~ : Int,
  max_markers_without_asset_ref~ : Int,
  max_unresolved_asset_refs~ : Int,
  max_regions_without_status? : Int = 0,
  max_regions_without_tap? : Int = 0,
  min_hit_width? : Int = 44,
  min_hit_height? : Int = 44,
  max_small_hit_targets? : Int = 0,
) -> SceneVisualQualityBudget {
  @scene.scene_visual_quality_budget(
    min_width~,
    min_height~,
    max_markers_without_status~,
    max_markers_without_tap~,
    max_markers_without_asset_ref~,
    max_unresolved_asset_refs~,
    max_regions_without_status~,
    max_regions_without_tap~,
    min_hit_width~,
    min_hit_height~,
    max_small_hit_targets~,
  )
}

///|
pub fn default_scene_visual_quality_budget() -> SceneVisualQualityBudget {
  @scene.default_scene_visual_quality_budget()
}

///|
pub fn plan_scene_visual_quality(input : Scene) -> SceneVisualQualityPlan {
  @scene.plan_scene_visual_quality(input)
}

///|
pub fn plan_scene_visual_quality_with_budget(
  input : Scene,
  render_budget : SceneRenderBudget,
  asset_budget : SceneAssetBudget,
  quality_budget : SceneVisualQualityBudget,
) -> SceneVisualQualityPlan {
  @scene.plan_scene_visual_quality_with_budget(
    input, render_budget, asset_budget, quality_budget,
  )
}

///|
pub fn plan_scene_visual_quality_viewport(
  input : Scene,
  viewport : SceneViewport,
  render_budget : SceneRenderBudget,
  asset_budget : SceneAssetBudget,
  quality_budget : SceneVisualQualityBudget,
) -> SceneVisualQualityPlan {
  @scene.plan_scene_visual_quality_viewport(
    input, viewport, render_budget, asset_budget, quality_budget,
  )
}

///|
pub fn scene_marker_count(input : Scene) -> Int {
  @scene.scene_marker_count(input)
}

///|
pub fn scene_region_count(input : Scene) -> Int {
  @scene.scene_region_count(input)
}

///|
pub fn scene_visible_marker_count(
  input : Scene,
  viewport : SceneViewport,
) -> Int {
  @scene.scene_visible_marker_count(input, viewport)
}

///|
pub fn scene_visible_region_count(
  input : Scene,
  viewport : SceneViewport,
) -> Int {
  @scene.scene_visible_region_count(input, viewport)
}

///|
pub fn scene_render_mode_id(mode : SceneRenderMode) -> String {
  @scene.scene_render_mode_id(mode)
}

///|
pub fn scene_quality_id(quality : SceneQualityLevel) -> String {
  @scene.scene_quality_id(quality)
}

///|
pub fn scene_surface_preference_id(
  preference : SceneSurfacePreference,
) -> String {
  @scene.scene_surface_preference_id(preference)
}

///|
pub fn scene_mode_static_markup() -> SceneRenderMode {
  @scene.StaticMarkup
}

///|
pub fn scene_mode_canvas_surface() -> SceneRenderMode {
  @scene.CanvasSurface
}

///|
pub fn scene_mode_lightweight_markup() -> SceneRenderMode {
  @scene.LightweightMarkup
}

///|
pub fn scene_quality_full() -> SceneQualityLevel {
  @scene.FullQuality
}

///|
pub fn scene_quality_balanced() -> SceneQualityLevel {
  @scene.BalancedQuality
}

///|
pub fn scene_quality_lightweight() -> SceneQualityLevel {
  @scene.LightweightQuality
}

///|
pub fn prefer_static_surface() -> SceneSurfacePreference {
  @scene.PreferStaticSurface
}

///|
pub fn prefer_canvas_surface() -> SceneSurfacePreference {
  @scene.PreferCanvasSurface
}

///|
pub fn prefer_lightweight_surface() -> SceneSurfacePreference {
  @scene.PreferLightweightSurface
}

///|
pub fn set_scene_marker_status(
  scene_id : String,
  marker_id : String,
  status : String,
) -> Patch {
  @scene.set_scene_marker_status(scene_id, marker_id, status)
}

///|
pub fn select_scene_marker(scene_id : String, marker_id : String) -> Patch {
  @scene.select_scene_marker(scene_id, marker_id)
}

///|
pub fn set_scene_region_status(
  scene_id : String,
  region_id : String,
  status : String,
) -> Patch {
  @scene.set_scene_region_status(scene_id, region_id, status)
}

///|
pub fn select_scene_region(scene_id : String, region_id : String) -> Patch {
  @scene.select_scene_region(scene_id, region_id)
}

///|
pub fn set_scene_camera(scene_id : String, camera : SceneCamera) -> Patch {
  @scene.set_scene_camera(scene_id, camera)
}

///|
pub fn set_scene_camera_position(scene_id : String, x : Int, y : Int) -> Patch {
  @scene.set_scene_camera_position(scene_id, x, y)
}

///|
pub fn set_scene_camera_zoom(scene_id : String, zoom_percent : Int) -> Patch {
  @scene.set_scene_camera_zoom(scene_id, zoom_percent)
}

///|
pub fn set_scene_camera_viewport(
  scene_id : String,
  viewport : SceneViewport,
) -> Patch {
  @scene.set_scene_camera_viewport(scene_id, viewport)
}

///|
pub fn select_scene_thread(
  scene_id : String,
  subject_kind : String,
  subject_id : String,
  thread_id : String,
) -> Patch {
  @scene.select_scene_thread(scene_id, subject_kind, subject_id, thread_id)
}

///|
pub fn select_scene_marker_thread(
  scene_id : String,
  marker_id : String,
  thread_id : String,
) -> Patch {
  @scene.select_scene_marker_thread(scene_id, marker_id, thread_id)
}

///|
pub fn select_scene_region_thread(
  scene_id : String,
  region_id : String,
  thread_id : String,
) -> Patch {
  @scene.select_scene_region_thread(scene_id, region_id, thread_id)
}

///|
pub fn set_scene_thread_status(
  scene_id : String,
  thread_id : String,
  status : String,
) -> Patch {
  @scene.set_scene_thread_status(scene_id, thread_id, status)
}

///|
pub fn set_scene_thread_unread(
  scene_id : String,
  thread_id : String,
  unread_count : Int,
) -> Patch {
  @scene.set_scene_thread_unread(scene_id, thread_id, unread_count)
}

///|
pub fn append_scene_thread_link(
  target_path : String,
  link : SceneThreadLink,
) -> Patch {
  @scene.append_scene_thread_link(target_path, link)
}

///|
pub fn effect(
  id~ : String,
  kind~ : EffectKind,
  target~ : String,
  payload_key? : String = "",
  message? : String = "",
) -> Effect {
  @effects.effect(id~, kind~, target~, payload_key~, message~)
}

///|
pub fn effect_kind_id(kind : EffectKind) -> String {
  @effects.effect_kind_id(kind)
}

///|
pub fn plan_effects_for_platform(
  effects : Array[Effect],
  platform : Platform,
) -> EffectPlan {
  @effects.plan_effects_for_platform(effects, platform)
}

///|
pub fn plan_effects_for_adapter(
  effects : Array[Effect],
  adapter : PlatformAdapter,
) -> EffectPlan {
  @effects.plan_effects_for_adapter(effects, adapter)
}

///|
pub fn backend_endpoint(
  id~ : String,
  kind~ : BackendEndpointKind,
  http_method~ : HttpMethod,
  path~ : String,
  payload_key? : String = "",
  response_key? : String = "",
  timeout_ms? : Int = 10000,
  streaming? : Bool = false,
  requires_review? : Bool = false,
) -> BackendEndpoint {
  @effects.backend_endpoint(
    id~,
    kind~,
    http_method~,
    path~,
    payload_key~,
    response_key~,
    timeout_ms~,
    streaming~,
    requires_review~,
  )
}

///|
pub fn backend_contract(
  id~ : String,
  base_url_key? : String = "backendBaseUrl",
  endpoints~ : Array[BackendEndpoint],
) -> BackendContract {
  @effects.backend_contract(id~, base_url_key~, endpoints~)
}

///|
pub fn backend_budget(
  max_endpoints~ : Int,
  max_streaming~ : Int,
  max_review_required~ : Int,
) -> BackendBudget {
  @effects.backend_budget(max_endpoints~, max_streaming~, max_review_required~)
}

///|
pub fn default_backend_budget() -> BackendBudget {
  @effects.default_backend_budget()
}

///|
pub fn plan_backend_contract(contract : BackendContract) -> BackendPlan {
  @effects.plan_backend_contract(contract)
}

///|
pub fn plan_backend_contract_with_budget(
  contract : BackendContract,
  budget : BackendBudget,
) -> BackendPlan {
  @effects.plan_backend_contract_with_budget(contract, budget)
}

///|
pub fn endpoint_effect(endpoint : BackendEndpoint, id? : String = "") -> Effect {
  @effects.endpoint_effect(endpoint, id~)
}

///|
pub fn backend_contract_effects(contract : BackendContract) -> Array[Effect] {
  @effects.backend_contract_effects(contract)
}

///|
pub fn plan_backend_effects_for_platform(
  contract : BackendContract,
  platform : Platform,
) -> EffectPlan {
  @effects.plan_backend_effects_for_platform(contract, platform)
}

///|
pub fn plan_backend_effects_for_adapter(
  contract : BackendContract,
  adapter : PlatformAdapter,
) -> EffectPlan {
  @effects.plan_backend_effects_for_adapter(contract, adapter)
}

///|
pub fn snapshot_load_endpoint(
  id : String,
  path : String,
  response_key : String,
) -> BackendEndpoint {
  @effects.snapshot_load_endpoint(id, path, response_key)
}

///|
pub fn status_load_endpoint(
  id : String,
  path : String,
  response_key : String,
) -> BackendEndpoint {
  @effects.status_load_endpoint(id, path, response_key)
}

///|
pub fn operator_submit_endpoint(
  id : String,
  path : String,
  payload_key : String,
  response_key : String,
) -> BackendEndpoint {
  @effects.operator_submit_endpoint(id, path, payload_key, response_key)
}

///|
pub fn agent_message_endpoint(
  id : String,
  path : String,
  payload_key : String,
  response_key : String,
) -> BackendEndpoint {
  @effects.agent_message_endpoint(id, path, payload_key, response_key)
}

///|
pub fn agent_stream_endpoint(
  id : String,
  path : String,
  payload_key : String,
  response_key : String,
) -> BackendEndpoint {
  @effects.agent_stream_endpoint(id, path, payload_key, response_key)
}

///|
pub fn thread_load_endpoint(
  id : String,
  path : String,
  response_key : String,
) -> BackendEndpoint {
  @effects.thread_load_endpoint(id, path, response_key)
}

///|
pub fn handoff_submit_endpoint(
  id : String,
  path : String,
  payload_key : String,
  response_key : String,
) -> BackendEndpoint {
  @effects.handoff_submit_endpoint(id, path, payload_key, response_key)
}

///|
pub fn review_decision_endpoint(
  id : String,
  path : String,
  payload_key : String,
  response_key : String,
) -> BackendEndpoint {
  @effects.review_decision_endpoint(id, path, payload_key, response_key)
}

///|
pub fn tool_ack_endpoint(
  id : String,
  path : String,
  payload_key : String,
) -> BackendEndpoint {
  @effects.tool_ack_endpoint(id, path, payload_key)
}

///|
pub fn agent_cancel_endpoint(
  id : String,
  path : String,
  payload_key : String,
  response_key : String,
) -> BackendEndpoint {
  @effects.agent_cancel_endpoint(id, path, payload_key, response_key)
}

///|
pub fn agent_retry_endpoint(
  id : String,
  path : String,
  payload_key : String,
  response_key : String,
) -> BackendEndpoint {
  @effects.agent_retry_endpoint(id, path, payload_key, response_key)
}

///|
pub fn generic_endpoint(
  id : String,
  path : String,
  http_method : HttpMethod,
  payload_key? : String = "",
  response_key? : String = "",
) -> BackendEndpoint {
  @effects.generic_endpoint(id, path, http_method, payload_key~, response_key~)
}

///|
pub fn backend_state_patch(scope : String, state : BackendState) -> Patch {
  @effects.backend_state_patch(scope, state)
}

///|
pub fn backend_request(
  id~ : String,
  endpoint~ : BackendEndpoint,
  payload_json? : String = "{}",
  replay_key? : String = "",
) -> BackendRequest {
  @effects.backend_request(id~, endpoint~, payload_json~, replay_key~)
}

///|
pub fn backend_request_patches(input : BackendRequest) -> Array[Patch] {
  @effects.backend_request_patches(input)
}

///|
pub fn backend_success(
  request : BackendRequest,
  response_json : String,
) -> BackendResult {
  @effects.backend_success(request, response_json)
}

///|
pub fn backend_failure(
  request : BackendRequest,
  error_message : String,
) -> BackendResult {
  @effects.backend_failure(request, error_message)
}

///|
pub fn backend_timeout(
  request : BackendRequest,
  error_message? : String = "request timeout",
) -> BackendResult {
  @effects.backend_timeout(request, error_message~)
}

///|
pub fn backend_malformed(
  request : BackendRequest,
  error_message? : String = "malformed response",
) -> BackendResult {
  @effects.backend_malformed(request, error_message~)
}

///|
pub fn backend_cancelled(request : BackendRequest) -> BackendResult {
  @effects.backend_cancelled(request)
}

///|
pub fn backend_result_patches(input : BackendResult) -> Array[Patch] {
  @effects.backend_result_patches(input)
}

///|
pub fn backend_result_kind_id(kind : BackendResultKind) -> String {
  @effects.backend_result_kind_id(kind)
}

///|
pub fn set_snapshot_section_delta(
  scope : String,
  section : String,
  value_json : String,
) -> SnapshotDelta {
  @effects.set_snapshot_section_delta(scope, section, value_json)
}

///|
pub fn append_snapshot_item_delta(
  scope : String,
  section : String,
  item_id : String,
  value_json : String,
) -> SnapshotDelta {
  @effects.append_snapshot_item_delta(scope, section, item_id, value_json)
}

///|
pub fn remove_snapshot_section_delta(
  scope : String,
  section : String,
) -> SnapshotDelta {
  @effects.remove_snapshot_section_delta(scope, section)
}

///|
pub fn replace_snapshot_delta(
  scope : String,
  value_json : String,
) -> SnapshotDelta {
  @effects.replace_snapshot_delta(scope, value_json)
}

///|
pub fn plan_snapshot_deltas(deltas : Array[SnapshotDelta]) -> SnapshotDeltaPlan {
  @effects.plan_snapshot_deltas(deltas)
}

///|
pub fn plan_snapshot_deltas_with_budget(
  deltas : Array[SnapshotDelta],
  budget : PatchBudget,
) -> SnapshotDeltaPlan {
  @effects.plan_snapshot_deltas_with_budget(deltas, budget)
}

///|
pub fn snapshot_delta_kind_id(kind : SnapshotDeltaKind) -> String {
  @effects.snapshot_delta_kind_id(kind)
}

///|
pub fn backend_error_patch(scope : String, message : String) -> Patch {
  @effects.backend_error_patch(scope, message)
}

///|
pub fn backend_response_patch(scope : String, value_json : String) -> Patch {
  @effects.backend_response_patch(scope, value_json)
}

///|
pub fn backend_state_id(state : BackendState) -> String {
  @effects.backend_state_id(state)
}

///|
pub fn backend_endpoint_kind_id(kind : BackendEndpointKind) -> String {
  @effects.backend_endpoint_kind_id(kind)
}

///|
pub fn http_method_id(input : HttpMethod) -> String {
  @effects.http_method_id(input)
}

///|
pub fn endpoint_snapshot_load() -> BackendEndpointKind {
  @effects.SnapshotLoad
}

///|
pub fn endpoint_status_load() -> BackendEndpointKind {
  @effects.StatusLoad
}

///|
pub fn endpoint_operator_submit() -> BackendEndpointKind {
  @effects.OperatorSubmit
}

///|
pub fn endpoint_agent_message_send() -> BackendEndpointKind {
  @effects.AgentMessageSend
}

///|
pub fn endpoint_agent_run_status() -> BackendEndpointKind {
  @effects.AgentRunStatus
}

///|
pub fn endpoint_thread_load() -> BackendEndpointKind {
  @effects.ThreadLoad
}

///|
pub fn endpoint_handoff_submit() -> BackendEndpointKind {
  @effects.HandoffSubmit
}

///|
pub fn endpoint_review_decision() -> BackendEndpointKind {
  @effects.ReviewDecision
}

///|
pub fn endpoint_tool_ack() -> BackendEndpointKind {
  @effects.ToolAck
}

///|
pub fn endpoint_agent_operation_cancel() -> BackendEndpointKind {
  @effects.AgentOperationCancel
}

///|
pub fn endpoint_agent_operation_retry() -> BackendEndpointKind {
  @effects.AgentOperationRetry
}

///|
pub fn endpoint_generic() -> BackendEndpointKind {
  @effects.GenericEndpoint
}

///|
pub fn backend_state_idle() -> BackendState {
  @effects.IdleState
}

///|
pub fn backend_state_loading() -> BackendState {
  @effects.Loading
}

///|
pub fn backend_state_ready() -> BackendState {
  @effects.Ready
}

///|
pub fn backend_state_stale() -> BackendState {
  @effects.Stale
}

///|
pub fn backend_state_failed() -> BackendState {
  @effects.Failed
}

///|
pub fn backend_state_timeout() -> BackendState {
  @effects.Timeout
}

///|
pub fn backend_state_malformed() -> BackendState {
  @effects.Malformed
}

///|
pub fn backend_state_cancelled() -> BackendState {
  @effects.CancelledState
}

///|
pub fn backend_result_success() -> BackendResultKind {
  @effects.BackendSuccess
}

///|
pub fn backend_result_failure() -> BackendResultKind {
  @effects.BackendFailure
}

///|
pub fn backend_result_timeout() -> BackendResultKind {
  @effects.BackendTimeout
}

///|
pub fn backend_result_malformed() -> BackendResultKind {
  @effects.BackendMalformed
}

///|
pub fn backend_result_cancelled() -> BackendResultKind {
  @effects.BackendCancelled
}

///|
pub fn http_get() -> HttpMethod {
  @effects.Get
}

///|
pub fn http_post() -> HttpMethod {
  @effects.Post
}

///|
pub fn http_put() -> HttpMethod {
  @effects.Put
}

///|
pub fn http_patch() -> HttpMethod {
  @effects.Patch
}

///|
pub fn http_delete() -> HttpMethod {
  @effects.Delete
}

///|
pub fn request(id : String, target : String, payload_key : String) -> Effect {
  @effects.request(id, target, payload_key)
}

///|
pub fn navigate(id : String, target : String) -> Effect {
  @effects.navigate(id, target)
}

///|
pub fn storage(id : String, target : String, payload_key : String) -> Effect {
  @effects.storage(id, target, payload_key)
}

///|
pub fn login(id : String, target : String) -> Effect {
  @effects.login(id, target)
}

///|
pub fn share(id : String, target : String) -> Effect {
  @effects.share(id, target)
}

///|
pub fn cloud_function(
  id : String,
  target : String,
  payload_key : String,
) -> Effect {
  @effects.cloud_function(id, target, payload_key)
}

///|
pub fn stream(id : String, target : String, payload_key : String) -> Effect {
  @effects.stream(id, target, payload_key)
}

///|
pub fn cancel(id : String, target : String) -> Effect {
  @effects.cancel(id, target)
}

///|
pub fn retry(id : String, target : String) -> Effect {
  @effects.retry(id, target)
}

///|
pub fn effect_chip(item : Effect) -> Node {
  @effects.effect_chip(item)
}

///|
pub fn generate_wechat_page(name : String, root : Node) -> WechatPage {
  @wechat.generate_page(name, root)
}

///|
pub fn generate_wechat_page_with_runtime(
  name : String,
  root : Node,
  runtime : WechatRuntime,
) -> WechatPage {
  @wechat.generate_page_with_runtime(name, root, runtime)
}

///|
pub fn generate_wechat_page_with_runtime_and_budget(
  name : String,
  root : Node,
  runtime : WechatRuntime,
  render_budget : RenderBudget,
) -> WechatPage {
  @wechat.generate_page_with_runtime_and_budget(
    name, root, runtime, render_budget,
  )
}

///|
pub fn generate_wechat_project(
  name~ : String,
  route? : String = "pages/index/index",
  root~ : Node,
) -> WechatProject {
  @wechat.generate_project(name~, route~, root~)
}

///|
pub fn generate_wechat_project_with_runtime(
  name~ : String,
  route? : String = "pages/index/index",
  root~ : Node,
  runtime~ : WechatRuntime,
) -> WechatProject {
  @wechat.generate_project_with_runtime(name~, route~, root~, runtime~)
}

///|
pub fn generate_wechat_project_with_runtime_and_budget(
  name~ : String,
  route? : String = "pages/index/index",
  root~ : Node,
  runtime~ : WechatRuntime,
  render_budget~ : RenderBudget,
) -> WechatProject {
  @wechat.generate_project_with_runtime_and_budget(
    name~,
    route~,
    root~,
    runtime~,
    render_budget~,
  )
}

///|
pub fn generate_wechat_project_with_runtime_and_backend(
  name~ : String,
  route? : String = "pages/index/index",
  root~ : Node,
  runtime~ : WechatRuntime,
  backend_contract~ : BackendContract,
) -> WechatProject {
  @wechat.generate_project_with_runtime_and_backend(
    name~,
    route~,
    root~,
    runtime~,
    backend_contract~,
  )
}

///|
pub fn generate_wechat_project_with_runtime_and_budget_and_backend(
  name~ : String,
  route? : String = "pages/index/index",
  root~ : Node,
  runtime~ : WechatRuntime,
  render_budget~ : RenderBudget,
  backend_contract~ : BackendContract,
) -> WechatProject {
  @wechat.generate_project_with_runtime_and_budget_and_backend(
    name~,
    route~,
    root~,
    runtime~,
    render_budget~,
    backend_contract~,
  )
}

///|
pub fn wechat_project_page(
  name~ : String,
  route~ : String,
  root~ : Node,
  runtime? : WechatRuntime = @wechat.default_runtime(),
  render_budget? : RenderBudget = @core.default_render_budget(),
) -> WechatProjectPage {
  @wechat.project_page(name~, route~, root~, runtime~, render_budget~)
}

///|
pub fn generate_wechat_project_from_pages(
  name~ : String,
  pages~ : Array[WechatProjectPage],
) -> WechatProject {
  @wechat.generate_project_from_pages(name~, pages~)
}

///|
pub fn generate_wechat_project_from_pages_with_backend(
  name~ : String,
  pages~ : Array[WechatProjectPage],
  backend_contract~ : BackendContract,
) -> WechatProject {
  @wechat.generate_project_from_pages_with_backend(
    name~,
    pages~,
    backend_contract~,
  )
}

///|
pub fn default_wechat_runtime() -> WechatRuntime {
  @wechat.default_runtime()
}

///|
pub fn wechat_runtime(
  initial_data_json? : String = "{}",
  event_patches? : Array[WechatEventPatch] = [],
) -> WechatRuntime {
  @wechat.runtime(initial_data_json~, event_patches~)
}

///|
pub fn wechat_event_patch(
  message : String,
  patches : Array[Patch],
) -> WechatEventPatch {
  @wechat.event_patch(message, patches)
}

///|
pub fn generate_wechat_set_data_call(patches : Array[Patch]) -> String {
  @wechat.generate_set_data_call(patches)
}

///|
pub fn generate_wechat_runtime_js() -> String {
  @wechat.generate_runtime_js()
}

///|
pub fn generate_wechat_request_adapter(contract : BackendContract) -> String {
  @wechat.generate_request_adapter(contract)
}

///|
pub fn default_wechat_build_budget() -> WechatBuildBudget {
  @wechat.default_build_budget()
}

///|
pub fn wechat_build_budget(
  max_pages~ : Int,
  max_files~ : Int,
  max_total_bytes~ : Int,
  max_wxml_bytes~ : Int,
  max_wxss_bytes~ : Int,
  max_js_bytes~ : Int,
  max_initial_data_bytes~ : Int,
  max_event_patch_bytes~ : Int,
  max_event_patch_operations~ : Int,
  max_page_first_screen_bytes~ : Int,
  max_page_update_payload_bytes~ : Int,
  max_page_update_operations~ : Int,
) -> WechatBuildBudget {
  @wechat.build_budget(
    max_pages~,
    max_files~,
    max_total_bytes~,
    max_wxml_bytes~,
    max_wxss_bytes~,
    max_js_bytes~,
    max_initial_data_bytes~,
    max_event_patch_bytes~,
    max_event_patch_operations~,
    max_page_first_screen_bytes~,
    max_page_update_payload_bytes~,
    max_page_update_operations~,
  )
}

///|
pub fn is_named_budget_profile(name : String) -> Bool {
  @tooling.is_named_budget_profile(name)
}

///|
pub fn render_budget_for_profile(name : String) -> RenderBudget {
  @tooling.render_budget_for_profile(name)
}

///|
pub fn wechat_build_budget_for_profile(name : String) -> WechatBuildBudget {
  @tooling.wechat_build_budget_for_profile(name)
}

///|
pub fn inspection_budget_for_profile(name : String) -> ProjectInspectionBudget {
  @tooling.inspection_budget_for_profile(name)
}

///|
pub fn build_profile_budget_for_profile(name : String) -> BuildProfileBudget {
  @tooling.build_profile_budget_for_profile(name)
}

///|
pub fn inspection_budget(
  max_route_risk_score~ : Int,
  max_update_payload_bytes~ : Int,
  max_update_operations~ : Int,
  max_backend_events~ : Int,
  max_backend_streams~ : Int,
  max_backend_reviews~ : Int,
  max_backend_cancels~ : Int,
  max_backend_retries~ : Int,
  max_scene_assets~ : Int,
  max_scene_remote_assets~ : Int,
  max_scene_package_bytes~ : Int,
) -> ProjectInspectionBudget {
  @tooling.inspection_budget(
    max_route_risk_score~,
    max_update_payload_bytes~,
    max_update_operations~,
    max_backend_events~,
    max_backend_streams~,
    max_backend_reviews~,
    max_backend_cancels~,
    max_backend_retries~,
    max_scene_assets~,
    max_scene_remote_assets~,
    max_scene_package_bytes~,
  )
}

///|
pub fn build_profile_budget(
  max_agent_duplicate_stream_chunks~ : Int,
  max_snapshot_full_replaces~ : Int,
  max_scene_thread_orphans~ : Int,
  max_scene_camera_clamped~ : Int,
  max_scene_surface_fallbacks~ : Int,
  max_scene_quality_issues~ : Int,
  max_degraded_scenes~ : Int,
) -> BuildProfileBudget {
  @tooling.build_profile_budget(
    max_agent_duplicate_stream_chunks~,
    max_snapshot_full_replaces~,
    max_scene_thread_orphans~,
    max_scene_camera_clamped~,
    max_scene_surface_fallbacks~,
    max_scene_quality_issues~,
    max_degraded_scenes~,
  )
}

///|
pub fn gate_project_inspection(
  inspection : ProjectInspection,
  budget : ProjectInspectionBudget,
  budget_profile? : String = "custom",
) -> ProjectInspectionGate {
  @tooling.gate_project_inspection(inspection, budget, budget_profile~)
}

///|
pub fn gate_build_profile(
  profile : BuildProfile,
  budget : BuildProfileBudget,
  budget_profile? : String = "custom",
) -> BuildProfileGate {
  @tooling.gate_build_profile(profile, budget, budget_profile~)
}

///|
pub fn report_wechat_project(
  project : WechatProject,
  runtime : WechatRuntime,
) -> WechatBuildReport {
  @wechat.report_project(project, runtime)
}

///|
pub fn report_wechat_project_with_budget(
  project : WechatProject,
  runtime : WechatRuntime,
  budget : WechatBuildBudget,
) -> WechatBuildReport {
  @wechat.report_project_with_budget(project, runtime, budget)
}

///|
pub fn profile_wechat_project(
  project : WechatProject,
  patches : PatchPlan,
  effect_plans? : Array[EffectPlan] = [],
  communication_plans? : Array[CommunicationPlan] = [],
  tool_result_plans? : Array[ToolResultPlan] = [],
  agent_delta_plans? : Array[AgentDeltaPlan] = [],
  backend_plans? : Array[BackendPlan] = [],
  snapshot_plans? : Array[SnapshotDeltaPlan] = [],
  asset_plans? : Array[SceneAssetPlan] = [],
  thread_plans? : Array[SceneThreadPlan] = [],
  camera_plans? : Array[SceneCameraPlan] = [],
  scene_plans? : Array[SceneRenderPlan] = [],
  surface_plans? : Array[SceneSurfacePlan] = [],
  quality_plans? : Array[SceneVisualQualityPlan] = [],
) -> BuildProfile {
  @tooling.profile_wechat_project(
    project,
    patches,
    effect_plans~,
    communication_plans~,
    tool_result_plans~,
    agent_delta_plans~,
    backend_plans~,
    snapshot_plans~,
    asset_plans~,
    thread_plans~,
    camera_plans~,
    scene_plans~,
    surface_plans~,
    quality_plans~,
  )
}

///|
pub fn ci_plan(
  target? : String = "wechat",
  budget_profile? : String = "tight",
  render_budget_profile? : String = "",
  examples? : Array[String] = ["agent_map"],
  snapshot_dir? : String = "_build/bunnia/snapshots",
) -> CiPlan {
  @tooling.ci_plan(
    target~,
    budget_profile~,
    render_budget_profile~,
    examples~,
    snapshot_dir~,
  )
}

///|
pub fn ci_plan_shell_script(plan : CiPlan) -> String {
  @tooling.ci_plan_shell_script(plan)
}

///|
pub fn platform_limits(target? : String = "wechat") -> PlatformLimitsReport {
  @tooling.platform_limits(target~)
}

///|
pub fn platform_target_support(
  target? : String = "wechat",
) -> PlatformTargetSupport {
  @tooling.platform_target_support(target~)
}

///|
pub fn platform_target_support_for_adapter(
  adapter : PlatformAdapter,
  generator_available? : Bool = false,
) -> PlatformTargetSupport {
  @tooling.platform_target_support_for_adapter(adapter, generator_available~)
}

///|
pub fn platform_limits_for_adapter(
  adapter : PlatformAdapter,
  generator_available? : Bool = false,
) -> PlatformLimitsReport {
  @tooling.platform_limits_for_adapter(adapter, generator_available~)
}

///|
pub fn platform_generator_status_id(status : PlatformGeneratorStatus) -> String {
  @tooling.platform_generator_status_id(status)
}

///|
pub fn platform_generator_available(status : PlatformGeneratorStatus) -> Bool {
  @tooling.platform_generator_available(status)
}

///|
pub fn snapshot_wechat_project(
  target~ : String,
  example~ : String,
  project : WechatProject,
  profile : BuildProfile,
) -> GeneratedSnapshot {
  @tooling.snapshot_wechat_project(target~, example~, project, profile)
}

///|
pub fn snapshot_wechat_project_with_report(
  target~ : String,
  example~ : String,
  project : WechatProject,
  report : WechatBuildReport,
  profile : BuildProfile,
  budget_profile? : String = "default",
  render_budget_profile? : String = "default",
) -> GeneratedSnapshot {
  @tooling.snapshot_wechat_project_with_report(
    target~,
    example~,
    project,
    report,
    profile,
    budget_profile~,
    render_budget_profile~,
  )
}

///|
pub fn inspect_wechat_project(
  target~ : String,
  example~ : String,
  project : WechatProject,
  report : WechatBuildReport,
) -> ProjectInspection {
  @tooling.inspect_wechat_project(target~, example~, project, report)
}

///|
pub fn scaffold_project(
  name~ : String,
  module_name? : String = "",
) -> ScaffoldPlan {
  @tooling.scaffold_project(name~, module_name~)
}
