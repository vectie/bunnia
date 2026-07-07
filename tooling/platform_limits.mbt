///|
pub struct PlatformComponentMapping {
  bunnia_kind : String
  platform_component : String
} derive(Debug, Eq)

///|
pub struct PlatformEventMapping {
  bunnia_event : String
  platform_event : String
} derive(Debug, Eq)

///|
pub struct PlatformLifecycleMapping {
  bunnia_lifecycle : String
  platform_lifecycle : String
} derive(Debug, Eq)

///|
pub struct PlatformRequestMapping {
  bunnia_request : String
  platform_api : String
} derive(Debug, Eq)

///|
pub(all) enum PlatformGeneratorStatus {
  GeneratorAvailable
  GeneratorDeferred
  TargetUnknown
} derive(Debug, Eq)

///|
pub struct PlatformTargetSupport {
  target : String
  label : String
  adapter : @core.PlatformAdapter
  known : Bool
  generator_status : PlatformGeneratorStatus
  generator_status_id : String
  generator_available : Bool
  diagnostics : Array[String]
  summary : String
} derive(Debug, Eq)

///|
pub fn platform_generator_status_id(status : PlatformGeneratorStatus) -> String {
  match status {
    GeneratorAvailable => "available"
    GeneratorDeferred => "deferred"
    TargetUnknown => "unknown"
  }
}

///|
pub fn platform_generator_available(status : PlatformGeneratorStatus) -> Bool {
  status is GeneratorAvailable
}

///|
pub fn platform_target_support(
  target? : String = "wechat",
) -> PlatformTargetSupport {
  let (adapter, label, known) = adapter_for_target(target)
  let generator_status = generator_status_for_target(known, known)
  platform_target_support_from_parts(
    target, label, adapter, known, generator_status,
  )
}

///|
pub fn platform_target_support_for_adapter(
  adapter : @core.PlatformAdapter,
  generator_available? : Bool = false,
) -> PlatformTargetSupport {
  let target = adapter.id
  let label = @core.platform_label(adapter.platform)
  let generator_status = if generator_available {
    GeneratorAvailable
  } else {
    GeneratorDeferred
  }
  platform_target_support_from_parts(
    target, label, adapter, true, generator_status,
  )
}

///|
fn platform_target_support_from_parts(
  target : String,
  label : String,
  adapter : @core.PlatformAdapter,
  known : Bool,
  generator_status : PlatformGeneratorStatus,
) -> PlatformTargetSupport {
  let generator_status_id = platform_generator_status_id(generator_status)
  let generator_available = platform_generator_available(generator_status)
  let diagnostics : Array[String] = []
  if !known {
    diagnostics.push("platform-target-unknown:\{target}")
  } else if !generator_available {
    diagnostics.push("platform-generator-deferred:\{target}")
  }
  {
    target,
    label,
    adapter,
    known,
    generator_status,
    generator_status_id,
    generator_available,
    diagnostics,
    summary: "Bunnia platform target: target=\{target} label=\{label} known=\{known} generator=\{generator_available} generator_status=\{generator_status_id} diagnostics=\{diagnostics.length()}",
  }
}

///|
pub struct PlatformLimitsReport {
  target : String
  label : String
  adapter : @core.PlatformAdapter
  generator_status : PlatformGeneratorStatus
  generator_status_id : String
  generator_available : Bool
  component_mappings : Array[PlatformComponentMapping]
  event_mappings : Array[PlatformEventMapping]
  lifecycle_mappings : Array[PlatformLifecycleMapping]
  request_mappings : Array[PlatformRequestMapping]
  supports_canvas : Bool
  supports_cloud : Bool
  supports_stream : Bool
  diagnostics : Array[String]
  summary : String
} derive(Debug, Eq)

///|
pub fn platform_limits(target? : String = "wechat") -> PlatformLimitsReport {
  platform_limits_from_support(platform_target_support(target~))
}

///|
fn platform_limits_from_support(
  support : PlatformTargetSupport,
) -> PlatformLimitsReport {
  let adapter = support.adapter
  let component_mappings = platform_component_mappings(adapter)
  let event_mappings = [
    { bunnia_event: "tap", platform_event: adapter.tap_event },
  ]
  let lifecycle_mappings = [
    {
      bunnia_lifecycle: "app-launch",
      platform_lifecycle: adapter.app_launch_lifecycle,
    },
    {
      bunnia_lifecycle: "page-load",
      platform_lifecycle: adapter.page_load_lifecycle,
    },
    {
      bunnia_lifecycle: "page-ready",
      platform_lifecycle: adapter.page_ready_lifecycle,
    },
  ]
  let request_mappings = [
    { bunnia_request: "http-request", platform_api: adapter.request_api },
  ]
  {
    target: support.target,
    label: support.label,
    adapter,
    generator_status: support.generator_status,
    generator_status_id: support.generator_status_id,
    generator_available: support.generator_available,
    component_mappings,
    event_mappings,
    lifecycle_mappings,
    request_mappings,
    supports_canvas: adapter.supports_canvas,
    supports_cloud: adapter.supports_cloud,
    supports_stream: adapter.supports_stream,
    diagnostics: support.diagnostics,
    summary: "Bunnia platform limits: target=\{support.target} label=\{support.label} generator=\{support.generator_available} generator_status=\{support.generator_status_id} components=\{component_mappings.length()} events=\{event_mappings.length()} lifecycles=\{lifecycle_mappings.length()} requests=\{request_mappings.length()} request_api=\{adapter.request_api} canvas=\{adapter.supports_canvas} cloud=\{adapter.supports_cloud} stream=\{adapter.supports_stream} diagnostics=\{support.diagnostics.length()}",
  }
}

///|
pub fn platform_limits_for_adapter(
  adapter : @core.PlatformAdapter,
  generator_available? : Bool = false,
) -> PlatformLimitsReport {
  platform_limits_from_support(
    platform_target_support_for_adapter(adapter, generator_available~),
  )
}

///|
fn generator_status_for_target(
  known : Bool,
  generator_available : Bool,
) -> PlatformGeneratorStatus {
  if !known {
    TargetUnknown
  } else if generator_available {
    GeneratorAvailable
  } else {
    GeneratorDeferred
  }
}

///|
fn adapter_for_target(target : String) -> (@core.PlatformAdapter, String, Bool) {
  if target == "wechat" {
    let adapter = @core.adapter(@core.Wechat)
    (adapter, @core.platform_label(adapter.platform), true)
  } else if target == "alipay" {
    let adapter = @core.adapter(@core.Alipay)
    (adapter, @core.platform_label(adapter.platform), true)
  } else if target == "tiktok" {
    let adapter = @core.adapter(@core.TikTok)
    (adapter, @core.platform_label(adapter.platform), true)
  } else {
    let adapter = @core.platform_adapter(
      platform=@core.Wechat,
      id=target,
      page_component="page",
      tap_event="tap",
      supports_canvas=false,
      supports_cloud=false,
      supports_stream=false,
    )
    (adapter, "Unsupported Mini App Target", false)
  }
}

///|
fn platform_component_mappings(
  adapter : @core.PlatformAdapter,
) -> Array[PlatformComponentMapping] {
  [
    component_mapping("page", adapter.page_component),
    component_mapping("view", prefixed_component(adapter, "view")),
    component_mapping("text", prefixed_component(adapter, "text")),
    component_mapping("image", prefixed_component(adapter, "image")),
    component_mapping("button", prefixed_component(adapter, "button")),
    component_mapping("scroll-view", prefixed_component(adapter, "scroll-view")),
    component_mapping("input", prefixed_component(adapter, "input")),
    component_mapping("form", prefixed_component(adapter, "form")),
    component_mapping("canvas", prefixed_component(adapter, "canvas")),
  ]
}

///|
fn component_mapping(
  bunnia_kind : String,
  platform_component : String,
) -> PlatformComponentMapping {
  { bunnia_kind, platform_component }
}

///|
fn prefixed_component(adapter : @core.PlatformAdapter, kind : String) -> String {
  "\{adapter.component_prefix}\{kind}"
}
