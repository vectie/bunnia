///|
fn tab_page(
  projection : MiniTownProjection,
  tab_id : String,
) -> @bunnia.WechatPage {
  @bunnia.generate_wechat_page(
    "Moontown Miniapp",
    mini_town_view(switch_tab(projection, tab_id)),
  )
}

///|
fn ordinary_wxml_paths() -> Array[String] {
  [
    "pages/moontown/index.wxml", "pages/moontown/home.wxml", "pages/moontown/discover.wxml",
    "pages/moontown/messages.wxml", "pages/moontown/my.wxml",
  ]
}

///|
fn has_no_forbidden_generated_ordinary_wxml(
  files : Array[@bunnia.WechatFile],
) -> Bool {
  for path in ordinary_wxml_paths() {
    let wxml = file_content(files, path)
    if wxml == "" || !has_no_forbidden_ordinary_copy(wxml) {
      return false
    }
    for raw in ordinary_generated_forbidden_tokens() {
      if wxml.contains(raw) {
        return false
      }
    }
    for label in ordinary_visible_technical_labels() {
      if wxml.contains(">\{label}</text>") {
        return false
      }
    }
  }
  true
}

///|
fn has_reviewer_diagnostics_allowlist(
  files : Array[@bunnia.WechatFile],
) -> Bool {
  let reviewer = file_content(files, "pages/moontown/reviewer.wxml")
  contains_all(reviewer, reviewer_diagnostics_allowlist_tokens())
}

///|
fn contains_all(text : String, tokens : Array[String]) -> Bool {
  for token in tokens {
    if !text.contains(token) {
      return false
    }
  }
  true
}

///|
fn string_appears_before(
  text : String,
  first : String,
  second : String,
) -> Bool {
  match (text.find(first), text.find(second)) {
    (Some(first_index), Some(second_index)) => first_index < second_index
    _ => false
  }
}

///|
fn generated_contract_data_stays_out_of_ordinary_wxml(
  files : Array[@bunnia.WechatFile],
) -> Bool {
  let data_js = file_content(files, "pages/moontown/index.data.js")
  let backend_js = file_content(files, "bunnia.backend.js")
  if !data_js.contains("adminOpsQuery") ||
    !data_js.contains("messageCenterQuery") ||
    !backend_js.contains("/miniapp/admin/ops") ||
    !backend_js.contains("/miniapp/marketplace/channels") {
    return false
  }
  for path in ordinary_wxml_paths() {
    let wxml = file_content(files, path)
    for key in ordinary_contract_data_tokens() {
      if wxml.contains(key) {
        return false
      }
    }
  }
  true
}

///|
fn generated_wxss_has_tile_visual_system(
  files : Array[@bunnia.WechatFile],
) -> Bool {
  let wxss = ordinary_wxss_bundle(files)
  wxss.contains("button{min-width:88rpx;min-height:88rpx") &&
  wxss.contains("background:#f3f7f4;color:#26342e;font-size:26rpx") &&
  wxss.contains(".bunnia-review-button{min-height:88rpx") &&
  wxss.contains(
    ".bunnia-scene-marker{position:absolute;transform:translate(-50%,-50%);min-width:120rpx;min-height:88rpx",
  ) &&
  wxss.contains(".bunnia-scene-thread{min-width:88rpx;min-height:88rpx") &&
  wxss.contains(
    ".moontown-map-marker{position:absolute;z-index:900;width:32rpx;min-width:32rpx;max-width:32rpx",
  ) &&
  wxss.contains(
    "button[disabled],.bunnia-status-disabled{opacity:0.52;pointer-events:none",
  ) &&
  wxss.contains(".mt-panel input{width:100%;min-height:88rpx") &&
  wxss.contains(
    ".moontown-page-surface button text,.moontown-right-hud button text,.moontown-topbar button text,.moontown-tabbar button text{color:inherit",
  ) &&
  wxss.contains("touch-action:manipulation") &&
  wxss.contains("overscroll-behavior:contain") &&
  wxss.contains(".moontown-page-surface{position:absolute;z-index:7") &&
  wxss.contains("bottom:0;margin:0;padding:0 24rpx 184rpx") &&
  wxss.contains("background:#f3f7f4") &&
  wxss.contains("-webkit-overflow-scrolling:touch") &&
  wxss.contains(".moontown-page-header{") &&
  wxss.contains(".moontown-page-title{color:#26342e") &&
  wxss.contains(".moontown-page-grid{min-height:0;display:grid") &&
  wxss.contains(
    ".moontown-page-grid.single{grid-template-columns:minmax(0,1fr)",
  ) &&
  wxss.contains("align-content:start;overflow:visible;padding-bottom:12rpx") &&
  wxss.contains(".moontown-home-lead{") &&
  wxss.contains(".moontown-home-stats{") &&
  wxss.contains(".moontown-district-grid .bunnia-list-windowed{") &&
  wxss.contains(".moontown-discovery-search{") &&
  wxss.contains(".moontown-discovery-primary-filters{") &&
  wxss.contains("grid-template-columns:repeat(4,minmax(0,1fr))") &&
  wxss.contains(".moontown-discovery-results .bunnia-list-windowed{") &&
  wxss.contains(".moontown-message-inbox,.moontown-message-notices{") &&
  wxss.contains(".moontown-discover-board{border-top:0") &&
  wxss.contains(
    ".moontown-message-inbox,.moontown-message-review,.moontown-message-work,.moontown-my-inventory{border-top:0",
  ) &&
  wxss.contains(
    ".moontown-chat-row{min-width:0;min-height:104rpx;margin:0;display:grid;grid-template-columns:56rpx minmax(0,1fr)",
  ) &&
  wxss.contains(
    ".moontown-chat-avatar.kind-agent-run{background:#e2f1eb;color:#1f5a48",
  ) &&
  wxss.contains(".moontown-chat-preview,.moontown-chat-preview text{") &&
  wxss.contains(".moontown-tabbar{box-shadow:0 -10rpx 28rpx") &&
  wxss.contains(
    ".moontown-tabbar>.bunnia-list{display:flex;flex-direction:row;align-items:flex-end",
  ) &&
  wxss.contains(
    ".moontown-tab-button{position:relative;flex:1 1 0;display:flex",
  ) &&
  wxss.contains(
    ".moontown-tab-button.map-surface{top:-26rpx;min-width:112rpx;min-height:112rpx",
  ) &&
  wxss.contains(".moontown-primary-action{") &&
  wxss.contains("border-color:#1f6a54;background:#1f6a54") &&
  wxss.contains(".moontown-danger-action{") &&
  generated_wxss_has_broad_tile_palette(wxss) &&
  wxss.contains(".moontown-discovery-badges,.moontown-object-badges") &&
  wxss.contains(".moontown-object-section{") &&
  wxss.contains(".moontown-building-drawer.details-open{max-height:72vh") &&
  wxss.contains(".moontown-worker-entry{") &&
  wxss.contains(
    ".moontown-community-actions,.moontown-discovery-action,.moontown-profile-actions,.moontown-run-actions,.moontown-object-primary-actions{display:flex;flex-direction:row;gap:8rpx;flex-wrap:wrap",
  ) &&
  wxss.contains(
    ".moontown-community-actions button,.moontown-discovery-action button",
  ) &&
  wxss.contains(
    ".moontown-community-actions>.bunnia-list,.moontown-discovery-action>.bunnia-list,.moontown-profile-actions>.bunnia-list,.moontown-run-actions>.bunnia-list,.moontown-object-primary-actions>.bunnia-list{display:flex;flex:1 1 100%;flex-direction:row",
  ) &&
  !wxss.contains(".moontown-guide-strip") &&
  !wxss.contains(".moontown-guide-step") &&
  wxss.contains(
    ".moontown-my-layout{grid-template-columns:minmax(0,1fr);align-items:start",
  ) &&
  !wxss.contains(">*{") &&
  !wxss.contains("letter-spacing:-") &&
  ordinary_pages_scope_route_wxss(files)
}

///|
fn generated_wxss_has_broad_tile_palette(wxss : String) -> Bool {
  wxss.contains("background:#a9cce2") &&
  wxss.contains("#f3f7f4") &&
  wxss.contains("#f7fbf8") &&
  wxss.contains("#fff") &&
  wxss.contains("#26342e") &&
  wxss.contains("#1f6a54") &&
  wxss.contains("#16a34a") &&
  wxss.contains("#2f7f68") &&
  wxss.contains("#dc2626") &&
  !wxss.contains("background:rgba(248,250,252,0.72)") &&
  !wxss.contains("#fff8dc") &&
  !wxss.contains("#f8f3df") &&
  !wxss.contains("rgba(252,249,226") &&
  !wxss.contains("rgba(255,250,240")
}

///|
fn ordinary_pages_scope_route_wxss(files : Array[@bunnia.WechatFile]) -> Bool {
  let app = file_content(files, "app.wxss")
  let realm = file_content(files, "pages/moontown/index.wxss")
  let messages = file_content(files, "pages/moontown/messages.wxss")
  let mine = file_content(files, "pages/moontown/my.wxss")
  app.contains(".moontown-miniapp{") &&
  has_file(files, "pages/moontown/home.wxss") &&
  has_file(files, "pages/moontown/discover.wxss") &&
  realm.contains(".moontown-map-touch-area{") &&
  !realm.contains(".moontown-miniapp{") &&
  messages.contains(".moontown-chat-row{") &&
  mine.contains(".moontown-my-overview>.moontown-profile-card{")
}

///|
fn ordinary_wxss_bundle(files : Array[@bunnia.WechatFile]) -> String {
  let out = StringBuilder::new()
  for
    path in [
      "app.wxss", "pages/moontown/index.wxss", "pages/moontown/home.wxss", "pages/moontown/discover.wxss",
      "pages/moontown/messages.wxss", "pages/moontown/my.wxss",
    ] {
    out.write_string(file_content(files, path))
  }
  out.to_string()
}

///|
fn has_file(files : Array[@bunnia.WechatFile], path : String) -> Bool {
  for item in files {
    if item.path == path {
      return true
    }
  }
  false
}

///|
fn backend_contract_contains(
  contract : @bunnia.BackendContract,
  id : String,
  path : String,
) -> Bool {
  for endpoint in contract.endpoints {
    if endpoint.id == id && endpoint.path == path {
      return true
    }
  }
  false
}

///|
fn string_occurrence_count(text : String, needle : String) -> Int {
  if needle == "" {
    0
  } else {
    string_occurrence_count_from(text, needle, 0)
  }
}

///|
fn string_occurrence_count_from(
  rest : String,
  needle : String,
  count : Int,
) -> Int {
  match rest.find(needle) {
    Some(index) =>
      string_occurrence_count_from(
        rest.sub(start=index + needle.length(), end=rest.length()).to_owned(),
        needle,
        count + 1,
      )
    None => count
  }
}

///|
fn file_content(files : Array[@bunnia.WechatFile], path : String) -> String {
  for item in files {
    if item.path == path {
      return item.content
    }
  }
  ""
}
