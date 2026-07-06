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
pub struct EffectPlan {
  platform : @core.Platform
  adapter : @core.PlatformAdapter
  effect_count : Int
  cloud_function_count : Int
  stream_effect_count : Int
  diagnostics : Array[String]
  summary : String
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
pub fn storage(id : String, target : String, payload_key : String) -> Effect {
  effect(id~, kind=Storage, target~, payload_key~)
}

///|
pub fn login(id : String, target : String) -> Effect {
  effect(id~, kind=Login, target~)
}

///|
pub fn share(id : String, target : String) -> Effect {
  effect(id~, kind=Share, target~)
}

///|
pub fn cloud_function(
  id : String,
  target : String,
  payload_key : String,
) -> Effect {
  effect(id~, kind=CloudFunction, target~, payload_key~)
}

///|
pub fn stream(id : String, target : String, payload_key : String) -> Effect {
  effect(id~, kind=Stream, target~, payload_key~)
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
pub fn effect_kind_id(kind : EffectKind) -> String {
  match kind {
    Request => "request"
    Navigate => "navigate"
    Storage => "storage"
    Login => "login"
    Share => "share"
    CloudFunction => "cloud-function"
    Stream => "stream"
    Cancel => "cancel"
    Retry => "retry"
  }
}

///|
pub fn plan_effects_for_platform(
  effects : Array[Effect],
  platform : @core.Platform,
) -> EffectPlan {
  let adapter = @core.adapter(platform)
  plan_effects_for_adapter(effects, adapter)
}

///|
pub fn plan_effects_for_adapter(
  effects : Array[Effect],
  adapter : @core.PlatformAdapter,
) -> EffectPlan {
  let diagnostics : Array[String] = []
  let mut cloud_function_count = 0
  let mut stream_effect_count = 0
  for item in effects {
    if item.kind is CloudFunction {
      cloud_function_count += 1
    }
    if item.kind is Stream {
      stream_effect_count += 1
    }
  }
  if cloud_function_count > 0 && !adapter.supports_cloud {
    diagnostics.push(
      "effect-cloud-function-unsupported:\{adapter.id}:\{cloud_function_count}",
    )
  }
  if stream_effect_count > 0 && !adapter.supports_stream {
    diagnostics.push(
      "effect-stream-unsupported:\{adapter.id}:\{stream_effect_count}",
    )
  }
  {
    platform: adapter.platform,
    adapter,
    effect_count: effects.length(),
    cloud_function_count,
    stream_effect_count,
    diagnostics,
    summary: "Bunnia effect plan: platform=\{@core.platform_id(adapter.platform)} adapter=\{adapter.id} effects=\{effects.length()} cloud_functions=\{cloud_function_count} streams=\{stream_effect_count} diagnostics=\{diagnostics.length()}",
  }
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
