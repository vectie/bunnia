///|
pub struct WechatBuildBudget {
  max_files : Int
  max_total_bytes : Int
  max_wxml_bytes : Int
  max_wxss_bytes : Int
  max_js_bytes : Int
  max_initial_data_bytes : Int
  max_event_patch_bytes : Int
} derive(Debug, Eq)

///|
pub struct WechatBuildReport {
  file_count : Int
  total_bytes : Int
  wxml_bytes : Int
  wxss_bytes : Int
  js_bytes : Int
  initial_data_bytes : Int
  event_patch_bytes : Int
  diagnostics : Array[String]
  summary : String
} derive(Debug, Eq)

///|
pub fn default_build_budget() -> WechatBuildBudget {
  {
    max_files: 16,
    max_total_bytes: 262144,
    max_wxml_bytes: 65536,
    max_wxss_bytes: 65536,
    max_js_bytes: 65536,
    max_initial_data_bytes: 65536,
    max_event_patch_bytes: 8192,
  }
}

///|
pub fn build_budget(
  max_files~ : Int,
  max_total_bytes~ : Int,
  max_wxml_bytes~ : Int,
  max_wxss_bytes~ : Int,
  max_js_bytes~ : Int,
  max_initial_data_bytes~ : Int,
  max_event_patch_bytes~ : Int,
) -> WechatBuildBudget {
  {
    max_files,
    max_total_bytes,
    max_wxml_bytes,
    max_wxss_bytes,
    max_js_bytes,
    max_initial_data_bytes,
    max_event_patch_bytes,
  }
}

///|
pub fn report_project(
  project : WechatProject,
  runtime : WechatRuntime,
) -> WechatBuildReport {
  report_files(project.files, runtime, default_build_budget())
}

///|
pub fn report_project_with_budget(
  project : WechatProject,
  runtime : WechatRuntime,
  budget : WechatBuildBudget,
) -> WechatBuildReport {
  report_files(project.files, runtime, budget)
}

///|
fn report_files(
  files : Array[WechatFile],
  runtime : WechatRuntime,
  budget : WechatBuildBudget,
) -> WechatBuildReport {
  let diagnostics : Array[String] = []
  let mut total = 0
  let mut wxml = 0
  let mut wxss = 0
  let mut js = 0
  for file in files {
    let bytes = file.content.length()
    total += bytes
    if file.path.has_suffix(".wxml") {
      wxml += bytes
    } else if file.path.has_suffix(".wxss") {
      wxss += bytes
    } else if file.path.has_suffix(".js") {
      js += bytes
    }
  }
  let initial = runtime.initial_data_json.length()
  let event_patch = event_patch_bytes(runtime.event_patches)
  push_over_budget(
    diagnostics,
    "wechat-file-count-over-budget",
    files.length(),
    budget.max_files,
  )
  push_over_budget(
    diagnostics,
    "wechat-total-bytes-over-budget",
    total,
    budget.max_total_bytes,
  )
  push_over_budget(
    diagnostics,
    "wechat-wxml-bytes-over-budget",
    wxml,
    budget.max_wxml_bytes,
  )
  push_over_budget(
    diagnostics,
    "wechat-wxss-bytes-over-budget",
    wxss,
    budget.max_wxss_bytes,
  )
  push_over_budget(
    diagnostics,
    "wechat-js-bytes-over-budget",
    js,
    budget.max_js_bytes,
  )
  push_over_budget(
    diagnostics,
    "wechat-initial-data-bytes-over-budget",
    initial,
    budget.max_initial_data_bytes,
  )
  push_over_budget(
    diagnostics,
    "wechat-event-patch-bytes-over-budget",
    event_patch,
    budget.max_event_patch_bytes,
  )
  {
    file_count: files.length(),
    total_bytes: total,
    wxml_bytes: wxml,
    wxss_bytes: wxss,
    js_bytes: js,
    initial_data_bytes: initial,
    event_patch_bytes: event_patch,
    diagnostics,
    summary: "Bunnia WeChat build report: files=\{files.length()} total=\{total} wxml=\{wxml} wxss=\{wxss} js=\{js} initial_data=\{initial} event_patches=\{event_patch} diagnostics=\{diagnostics.length()}",
  }
}

///|
fn event_patch_bytes(items : Array[WechatEventPatch]) -> Int {
  let mut total = 0
  for item in items {
    total += item.message.length()
    for patch in item.patches {
      total += patch.estimated_bytes
    }
  }
  total
}

///|
fn push_over_budget(
  diagnostics : Array[String],
  label : String,
  actual : Int,
  limit : Int,
) -> Unit {
  if actual > limit {
    diagnostics.push("\{label}:\{actual}/\{limit}")
  }
}
