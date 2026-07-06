///|
test "platform limits report documents active WeChat mapping" {
  let report = platform_limits(target="wechat")
  assert_eq(report.target, "wechat")
  assert_eq(report.generator_status_id, "available")
  assert_eq(platform_generator_status_id(report.generator_status), "available")
  assert_eq(platform_generator_available(report.generator_status), true)
  assert_eq(report.generator_available, true)
  assert_eq(report.supports_canvas, true)
  assert_eq(report.supports_cloud, true)
  assert_eq(report.supports_stream, true)
  assert_eq(report.component_mappings.length(), 9)
  assert_true(has_component_mapping(report, "page", "page"))
  assert_true(has_component_mapping(report, "view", "view"))
  assert_true(has_component_mapping(report, "canvas", "canvas"))
  assert_eq(report.event_mappings[0].bunnia_event, "tap")
  assert_eq(report.event_mappings[0].platform_event, "bindtap")
  assert_eq(report.diagnostics.length(), 0)
  assert_true(report.summary.contains("target=wechat"))
  assert_true(report.summary.contains("generator=true"))
  assert_true(report.summary.contains("generator_status=available"))
}

///|
test "platform limits keep deferred targets explicit" {
  let report = platform_limits(target="alipay")
  assert_eq(report.target, "alipay")
  assert_eq(report.generator_status_id, "deferred")
  assert_eq(platform_generator_status_id(report.generator_status), "deferred")
  assert_eq(platform_generator_available(report.generator_status), false)
  assert_eq(report.generator_available, false)
  assert_true(has_component_mapping(report, "view", "a:view"))
  assert_eq(report.event_mappings[0].platform_event, "onTap")
  assert_true(report.diagnostics.contains("platform-generator-deferred:alipay"))
}

///|
test "platform limits diagnose unknown target" {
  let report = platform_limits(target="unknown")
  assert_eq(report.target, "unknown")
  assert_eq(report.generator_status_id, "unknown")
  assert_eq(platform_generator_status_id(report.generator_status), "unknown")
  assert_eq(platform_generator_available(report.generator_status), false)
  assert_eq(report.generator_available, false)
  assert_eq(report.supports_canvas, false)
  assert_true(report.diagnostics.contains("platform-target-unknown:unknown"))
}

///|
test "platform limits can be derived from custom adapter" {
  let adapter = @core.platform_adapter(
    platform=@core.Wechat,
    id="wechat-lite",
    page_component="page",
    tap_event="bindtap",
    supports_canvas=false,
    supports_cloud=false,
    supports_stream=false,
  )
  let report = platform_limits_for_adapter(adapter)
  assert_eq(report.target, "wechat-lite")
  assert_eq(report.generator_status_id, "deferred")
  assert_eq(report.generator_available, false)
  assert_eq(report.supports_canvas, false)
  assert_true(
    report.diagnostics.contains("platform-generator-deferred:wechat-lite"),
  )
}

///|
test "platform limits can mark custom adapters as generator backed" {
  let adapter = @core.platform_adapter(
    platform=@core.Wechat,
    id="wechat-custom",
    page_component="page",
    tap_event="bindtap",
  )
  let report = platform_limits_for_adapter(adapter, generator_available=true)
  assert_eq(report.target, "wechat-custom")
  assert_eq(report.generator_status_id, "available")
  assert_eq(report.generator_available, true)
  assert_eq(report.diagnostics.length(), 0)
}

///|
fn has_component_mapping(
  report : PlatformLimitsReport,
  bunnia_kind : String,
  platform_component : String,
) -> Bool {
  for item in report.component_mappings {
    if item.bunnia_kind == bunnia_kind &&
      item.platform_component == platform_component {
      return true
    }
  }
  false
}
