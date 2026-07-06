///|
pub(all) enum Platform {
  Wechat
  Alipay
  TikTok
} derive(Debug, Eq)

///|
pub impl Show for Platform with fn output(self : Platform, logger : &Logger) -> Unit {
  logger.write_string(platform_id(self))
}

///|
pub struct PlatformAdapter {
  platform : Platform
  id : String
  page_component : String
  tap_event : String
  component_prefix : String
  supports_canvas : Bool
  supports_cloud : Bool
  supports_stream : Bool
} derive(Debug, Eq)

///|
pub impl Show for PlatformAdapter with fn output(
  self : PlatformAdapter,
  logger : &Logger,
) -> Unit {
  logger.write_string(
    "PlatformAdapter(id=\{self.id}, page_component=\{self.page_component}, tap_event=\{self.tap_event}, canvas=\{self.supports_canvas}, cloud=\{self.supports_cloud}, stream=\{self.supports_stream})",
  )
}

///|
pub fn platform_id(platform : Platform) -> String {
  match platform {
    Wechat => "wechat"
    Alipay => "alipay"
    TikTok => "tiktok"
  }
}

///|
pub fn platform_label(platform : Platform) -> String {
  match platform {
    Wechat => "WeChat Mini Program"
    Alipay => "Alipay Mini Program"
    TikTok => "TikTok Mini App"
  }
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
  {
    platform,
    id,
    page_component,
    tap_event,
    component_prefix,
    supports_canvas,
    supports_cloud,
    supports_stream,
  }
}

///|
pub fn adapter(platform : Platform) -> PlatformAdapter {
  match platform {
    Wechat =>
      platform_adapter(
        platform~,
        id=platform_id(platform),
        page_component="page",
        tap_event="bindtap",
        supports_cloud=true,
      )
    Alipay =>
      platform_adapter(
        platform~,
        id=platform_id(platform),
        page_component="page",
        tap_event="onTap",
        component_prefix="a:",
        supports_cloud=true,
      )
    TikTok =>
      platform_adapter(
        platform~,
        id=platform_id(platform),
        page_component="page",
        tap_event="bindtap",
        component_prefix="tt:",
      )
  }
}

///|
pub fn supported_platforms() -> Array[Platform] {
  [Wechat, Alipay, TikTok]
}
