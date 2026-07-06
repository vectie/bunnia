///|
pub type Attr = @core.Attr

///|
pub type EventBinding = @core.EventBinding

///|
pub type Node = @core.Node

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
pub type ReviewAction = @agent.ReviewAction

///|
pub type SceneSize = @scene.SceneSize

///|
pub type SceneMarker = @scene.SceneMarker

///|
pub type SceneLayer = @scene.SceneLayer

///|
pub type Scene = @scene.Scene

///|
pub type EffectKind = @effects.EffectKind

///|
pub type Effect = @effects.Effect

///|
pub type WechatPage = @wechat.WechatPage

///|
pub type WechatEventPatch = @wechat.WechatEventPatch

///|
pub type WechatRuntime = @wechat.WechatRuntime

///|
pub type WechatFile = @wechat.WechatFile

///|
pub type WechatProject = @wechat.WechatProject

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
) -> RenderBudget {
  @core.render_budget(
    max_nodes~,
    max_depth~,
    max_events~,
    max_initial_data_bytes~,
  )
}

///|
pub fn plan(root : Node, platform : Platform) -> RenderPlan {
  @core.plan(root, platform)
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
pub fn message_row(item : Message) -> Node {
  @agent.message_row(item)
}

///|
pub fn message_feed(messages : Array[Message]) -> Node {
  @agent.message_feed(messages)
}

///|
pub fn review_controls(action : ReviewAction) -> Node {
  @agent.review_controls(action)
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
pub fn scene_size(width : Int, height : Int) -> SceneSize {
  @scene.scene_size(width, height)
}

///|
pub fn marker(
  id~ : String,
  label~ : String,
  x~ : Int,
  y~ : Int,
  status? : String = "",
  tap_message? : String = "",
) -> SceneMarker {
  @scene.marker(id~, label~, x~, y~, status~, tap_message~)
}

///|
pub fn layer(
  id : String,
  z_index : Int,
  markers : Array[SceneMarker],
) -> SceneLayer {
  @scene.layer(id, z_index, markers)
}

///|
pub fn scene(
  id : String,
  size : SceneSize,
  layers : Array[SceneLayer],
) -> Scene {
  @scene.scene(id, size, layers)
}

///|
pub fn static_scene_view(input : Scene) -> Node {
  @scene.static_scene_view(input)
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
