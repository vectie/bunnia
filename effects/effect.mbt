///|
pub(all) enum EffectKind {
  Request
  Navigate
  Storage
  Login
  Share
  CloudFunction
  Stream
  Cancel
  Retry
} derive(Debug, Eq)

///|
pub struct Effect {
  id : String
  kind : EffectKind
  target : String
  payload_key : String
  message : String
} derive(Debug, Eq)

///|
pub fn effect(
  id~ : String,
  kind~ : EffectKind,
  target~ : String,
  payload_key? : String = "",
  message? : String = "",
) -> Effect {
  { id, kind, target, payload_key, message }
}

///|
pub fn request(id : String, target : String, payload_key : String) -> Effect {
  effect(id~, kind=Request, target~, payload_key~)
}

///|
pub fn navigate(id : String, target : String) -> Effect {
  effect(id~, kind=Navigate, target~)
}

///|
pub fn cancel(id : String, target : String) -> Effect {
  effect(id~, kind=Cancel, target~)
}

///|
pub fn retry(id : String, target : String) -> Effect {
  effect(id~, kind=Retry, target~)
}

///|
pub fn effect_chip(item : Effect) -> @core.Node {
  @core.view_with_attrs(
    [
      @core.class_name("bunnia-effect-chip"),
      @core.data("effect-id", item.id),
      @core.data("effect-target", item.target),
    ],
    [@core.text(item.target)],
  )
}
