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
pub struct PlatformLimitsReport {
  target : String
  label : String
  adapter : @core.PlatformAdapter
  generator_available : Bool
  component_mappings : Array[PlatformComponentMapping]
  event_mappings : Array[PlatformEventMapping]
  supports_canvas : Bool
  supports_cloud : Bool
  supports_stream : Bool
  diagnostics : Array[String]
  summary : String
} derive(Debug, Eq)

///|
pub fn platform_limits(target? : String = "wechat") -> PlatformLimitsReport {
  let (adapter, label, known) = adapter_for_target(target)
  let generator_available = target == "wechat"
  let diagnostics : Array[String] = []
  if !known {
    diagnostics.push("platform-target-unknown:\{target}")
  } else if !generator_available {
    diagnostics.push("platform-generator-deferred:\{target}")
  }
  let component_mappings = platform_component_mappings(adapter)
  let event_mappings = [
    { bunnia_event: "tap", platform_event: adapter.tap_event },
  ]
  {
    target,
    label,
    adapter,
    generator_available,
    component_mappings,
    event_mappings,
    supports_canvas: adapter.supports_canvas,
    supports_cloud: adapter.supports_cloud,
    supports_stream: adapter.supports_stream,
    diagnostics,
    summary: "Bunnia platform limits: target=\{target} label=\{label} generator=\{generator_available} components=\{component_mappings.length()} events=\{event_mappings.length()} canvas=\{adapter.supports_canvas} cloud=\{adapter.supports_cloud} stream=\{adapter.supports_stream} diagnostics=\{diagnostics.length()}",
  }
}

///|
pub fn platform_limits_for_adapter(
  adapter : @core.PlatformAdapter,
  generator_available? : Bool = false,
) -> PlatformLimitsReport {
  let target = adapter.id
  let label = @core.platform_label(adapter.platform)
  let diagnostics : Array[String] = []
  if !generator_available {
    diagnostics.push("platform-generator-deferred:\{target}")
  }
  let component_mappings = platform_component_mappings(adapter)
  let event_mappings = [
    { bunnia_event: "tap", platform_event: adapter.tap_event },
  ]
  {
    target,
    label,
    adapter,
    generator_available,
    component_mappings,
    event_mappings,
    supports_canvas: adapter.supports_canvas,
    supports_cloud: adapter.supports_cloud,
    supports_stream: adapter.supports_stream,
    diagnostics,
    summary: "Bunnia platform limits: target=\{target} label=\{label} generator=\{generator_available} components=\{component_mappings.length()} events=\{event_mappings.length()} canvas=\{adapter.supports_canvas} cloud=\{adapter.supports_cloud} stream=\{adapter.supports_stream} diagnostics=\{diagnostics.length()}",
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
