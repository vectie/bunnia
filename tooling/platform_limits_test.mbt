///|
test "platform limits report documents active WeChat mapping" {
  let support = platform_target_support(target="wechat")
  assert_eq(support.target, "wechat")
  assert_eq(support.known, true)
  assert_eq(support.generator_status_id, "available")
  assert_eq(support.generator_available, true)
  assert_eq(support.diagnostics.length(), 0)
  assert_true(support.summary.contains("target=wechat"))
  assert_true(support.summary.contains("generator_status=available"))
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
  assert_eq(report.lifecycle_mappings.length(), 3)
  assert_eq(report.request_mappings.length(), 1)
  assert_true(has_component_mapping(report, "page", "page"))
  assert_true(has_component_mapping(report, "view", "view"))
  assert_true(has_component_mapping(report, "canvas", "canvas"))
  assert_eq(report.event_mappings[0].bunnia_event, "tap")
  assert_eq(report.event_mappings[0].platform_event, "bindtap")
  assert_true(has_lifecycle_mapping(report, "app-launch", "onLaunch"))
  assert_true(has_lifecycle_mapping(report, "page-load", "onLoad"))
  assert_true(has_lifecycle_mapping(report, "page-ready", "onReady"))
  assert_true(has_request_mapping(report, "http-request", "wx.request"))
  assert_eq(report.diagnostics.length(), 0)
  assert_true(report.summary.contains("target=wechat"))
  assert_true(report.summary.contains("generator=true"))
  assert_true(report.summary.contains("generator_status=available"))
  assert_true(report.summary.contains("lifecycles=3"))
  assert_true(report.summary.contains("requests=1"))
  assert_true(report.summary.contains("request_api=wx.request"))
}

///|
test "platform limits expose generic Alipay generator support" {
  let support = platform_target_support(target="alipay")
  assert_eq(support.target, "alipay")
  assert_eq(support.known, true)
  assert_eq(support.generator_status_id, "available")
  assert_eq(support.generator_available, true)
  assert_eq(support.diagnostics.length(), 0)
  let report = platform_limits(target="alipay")
  assert_eq(report.target, "alipay")
  assert_eq(report.generator_status_id, "available")
  assert_eq(platform_generator_status_id(report.generator_status), "available")
  assert_eq(platform_generator_available(report.generator_status), true)
  assert_eq(report.generator_available, true)
  assert_true(has_component_mapping(report, "view", "a:view"))
  assert_eq(report.event_mappings[0].platform_event, "onTap")
  assert_true(has_lifecycle_mapping(report, "page-load", "onLoad"))
  assert_true(has_request_mapping(report, "http-request", "my.request"))
  assert_eq(report.diagnostics.length(), 0)
}

///|
test "platform limits expose generic TikTok request mapping" {
  let report = platform_limits(target="tiktok")
  assert_eq(report.target, "tiktok")
  assert_eq(report.generator_status_id, "available")
  assert_true(has_component_mapping(report, "view", "tt:view"))
  assert_eq(report.event_mappings[0].platform_event, "bindtap")
  assert_true(has_request_mapping(report, "http-request", "tt.request"))
}

///|
test "platform limits diagnose unknown target" {
  let support = platform_target_support(target="unknown")
  assert_eq(support.target, "unknown")
  assert_eq(support.known, false)
  assert_eq(support.generator_status_id, "unknown")
  assert_eq(support.generator_available, false)
  assert_true(support.diagnostics.contains("platform-target-unknown:unknown"))
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
    request_api="custom.request",
    supports_canvas=false,
    supports_cloud=false,
    supports_stream=false,
  )
  let support = platform_target_support_for_adapter(adapter)
  assert_eq(support.target, "wechat-lite")
  assert_eq(support.generator_status_id, "deferred")
  assert_eq(support.generator_available, false)
  let report = platform_limits_for_adapter(adapter)
  assert_eq(report.target, "wechat-lite")
  assert_eq(report.generator_status_id, "deferred")
  assert_eq(report.generator_available, false)
  assert_eq(report.supports_canvas, false)
  assert_true(has_request_mapping(report, "http-request", "custom.request"))
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
  let support = platform_target_support_for_adapter(
    adapter,
    generator_available=true,
  )
  assert_eq(support.target, "wechat-custom")
  assert_eq(support.generator_status_id, "available")
  assert_eq(support.generator_available, true)
  assert_eq(support.diagnostics.length(), 0)
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

///|
fn has_lifecycle_mapping(
  report : PlatformLimitsReport,
  bunnia_lifecycle : String,
  platform_lifecycle : String,
) -> Bool {
  for item in report.lifecycle_mappings {
    if item.bunnia_lifecycle == bunnia_lifecycle &&
      item.platform_lifecycle == platform_lifecycle {
      return true
    }
  }
  false
}

///|
fn has_request_mapping(
  report : PlatformLimitsReport,
  bunnia_request : String,
  platform_api : String,
) -> Bool {
  for item in report.request_mappings {
    if item.bunnia_request == bunnia_request &&
      item.platform_api == platform_api {
      return true
    }
  }
  false
}
