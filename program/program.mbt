///|
pub struct Step[Model] {
  model : Model
  effects : Array[@effects.Effect]
  patches : Array[@core.Patch]
}

///|
pub struct Program[Model, Msg] {
  id : String
  model : Model
  effects : Array[@effects.Effect]
  view : (Model) -> @core.Node
  update : (Model, Msg) -> Step[Model]
}

///|
pub fn[Model] step(
  model~ : Model,
  effects? : Array[@effects.Effect] = [],
  patches? : Array[@core.Patch] = [],
) -> Step[Model] {
  { model, effects, patches }
}

///|
pub fn[Model, Msg] program(
  id~ : String,
  model~ : Model,
  view~ : (Model) -> @core.Node,
  update~ : (Model, Msg) -> Step[Model],
  init_effects? : Array[@effects.Effect] = [],
) -> Program[Model, Msg] {
  { id, model, effects: init_effects, view, update }
}

///|
pub fn[Model, Msg] current_view(input : Program[Model, Msg]) -> @core.Node {
  (input.view)(input.model)
}

///|
pub fn[Model, Msg] apply(
  input : Program[Model, Msg],
  message : Msg,
) -> Program[Model, Msg] {
  let next = (input.update)(input.model, message)
  {
    id: input.id,
    model: next.model,
    effects: next.effects,
    view: input.view,
    update: input.update,
  }
}

///|
pub fn[Model] step_patches(input : Step[Model]) -> @core.PatchPlan {
  @core.plan_patches(input.patches)
}
