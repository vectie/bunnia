///|
pub struct WechatBuildBudget {
  max_pages : Int
  max_files : Int
  max_total_bytes : Int
  max_wxml_bytes : Int
  max_wxss_bytes : Int
  max_js_bytes : Int
  max_initial_data_bytes : Int
  max_event_patch_bytes : Int
  max_page_first_screen_bytes : Int
  max_page_update_payload_bytes : Int
} derive(Debug, Eq)

///|
pub struct WechatBuildReport {
  page_count : Int
  file_count : Int
  total_bytes : Int
  wxml_bytes : Int
  wxss_bytes : Int
  js_bytes : Int
  initial_data_bytes : Int
  event_patch_bytes : Int
  missing_event_patch_count : Int
  orphan_event_patch_count : Int
  max_page_first_screen_bytes : Int
  max_page_update_payload_bytes : Int
  diagnostics : Array[String]
  summary : String
} derive(Debug, Eq)

///|
pub fn default_build_budget() -> WechatBuildBudget {
  {
    max_pages: 32,
    max_files: 16,
    max_total_bytes: 262144,
    max_wxml_bytes: 65536,
    max_wxss_bytes: 65536,
    max_js_bytes: 65536,
    max_initial_data_bytes: 65536,
    max_event_patch_bytes: 8192,
    max_page_first_screen_bytes: 98304,
    max_page_update_payload_bytes: 8192,
  }
}

///|
pub fn build_budget(
  max_pages~ : Int,
  max_files~ : Int,
  max_total_bytes~ : Int,
  max_wxml_bytes~ : Int,
  max_wxss_bytes~ : Int,
  max_js_bytes~ : Int,
  max_initial_data_bytes~ : Int,
  max_event_patch_bytes~ : Int,
  max_page_first_screen_bytes~ : Int,
  max_page_update_payload_bytes~ : Int,
) -> WechatBuildBudget {
  {
    max_pages,
    max_files,
    max_total_bytes,
    max_wxml_bytes,
    max_wxss_bytes,
    max_js_bytes,
    max_initial_data_bytes,
    max_event_patch_bytes,
    max_page_first_screen_bytes,
    max_page_update_payload_bytes,
  }
}

///|
pub fn report_project(
  project : WechatProject,
  _runtime : WechatRuntime,
) -> WechatBuildReport {
  report_project_pages(project.files, project.pages, default_build_budget())
}

///|
pub fn report_project_with_budget(
  project : WechatProject,
  _runtime : WechatRuntime,
  budget : WechatBuildBudget,
) -> WechatBuildReport {
  report_project_pages(project.files, project.pages, budget)
}

///|
pub fn report_project_pages(
  files : Array[WechatFile],
  pages : Array[WechatProjectPage],
  budget : WechatBuildBudget,
) -> WechatBuildReport {
  let runtimes : Array[WechatRuntime] = []
  for item in pages {
    runtimes.push(item.runtime)
  }
  report_files(files, pages, runtimes, budget)
}

///|
fn report_files(
  files : Array[WechatFile],
  pages : Array[WechatProjectPage],
  runtimes : Array[WechatRuntime],
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
  let initial = initial_data_bytes(runtimes)
  let event_patch = event_patch_bytes(runtimes)
  let (max_first_screen, max_update_payload) = push_page_performance_diagnostics(
    diagnostics, files, pages, budget,
  )
  let (missing_event_patch_count, orphan_event_patch_count) = push_runtime_event_diagnostics(
    diagnostics, pages,
  )
  push_over_budget(
    diagnostics,
    "wechat-page-count-over-budget",
    pages.length(),
    budget.max_pages,
  )
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
    page_count: pages.length(),
    file_count: files.length(),
    total_bytes: total,
    wxml_bytes: wxml,
    wxss_bytes: wxss,
    js_bytes: js,
    initial_data_bytes: initial,
    event_patch_bytes: event_patch,
    missing_event_patch_count,
    orphan_event_patch_count,
    max_page_first_screen_bytes: max_first_screen,
    max_page_update_payload_bytes: max_update_payload,
    diagnostics,
    summary: "Bunnia WeChat build report: pages=\{pages.length()} files=\{files.length()} total=\{total} wxml=\{wxml} wxss=\{wxss} js=\{js} initial_data=\{initial} event_patches=\{event_patch} missing_event_patches=\{missing_event_patch_count} orphan_event_patches=\{orphan_event_patch_count} max_first_screen=\{max_first_screen} max_update_payload=\{max_update_payload} diagnostics=\{diagnostics.length()}",
  }
}

///|
fn push_runtime_event_diagnostics(
  diagnostics : Array[String],
  pages : Array[WechatProjectPage],
) -> (Int, Int) {
  let mut missing_count = 0
  let mut orphan_count = 0
  for page in pages {
    for message in page.page.plan.event_messages {
      if !runtime_has_patch(page.runtime, message) {
        missing_count += 1
        diagnostics.push("wechat-event-without-patch:\{page.route}:\{message}")
      }
    }
    for patch in page.runtime.event_patches {
      if !plan_has_event(page.page.plan, patch.message) {
        orphan_count += 1
        diagnostics.push(
          "wechat-patch-without-event:\{page.route}:\{patch.message}",
        )
      }
    }
  }
  (missing_count, orphan_count)
}

///|
fn runtime_has_patch(runtime : WechatRuntime, message : String) -> Bool {
  for item in runtime.event_patches {
    if item.message == message {
      return true
    }
  }
  false
}

///|
fn plan_has_event(plan : @core.RenderPlan, message : String) -> Bool {
  for item in plan.event_messages {
    if item == message {
      return true
    }
  }
  false
}

///|
fn push_page_performance_diagnostics(
  diagnostics : Array[String],
  files : Array[WechatFile],
  pages : Array[WechatProjectPage],
  budget : WechatBuildBudget,
) -> (Int, Int) {
  let mut max_first_screen = 0
  let mut max_update_payload = 0
  for page in pages {
    let first_screen = page_first_screen_bytes(page, files)
    let update_payload = page_update_payload_bytes(page)
    if first_screen > max_first_screen {
      max_first_screen = first_screen
    }
    if update_payload > max_update_payload {
      max_update_payload = update_payload
    }
    push_page_over_budget(
      diagnostics,
      "wechat-page-first-screen-bytes-over-budget",
      page.route,
      first_screen,
      budget.max_page_first_screen_bytes,
    )
    push_page_over_budget(
      diagnostics,
      "wechat-page-update-payload-bytes-over-budget",
      page.route,
      update_payload,
      budget.max_page_update_payload_bytes,
    )
  }
  (max_first_screen, max_update_payload)
}

///|
fn page_first_screen_bytes(
  page : WechatProjectPage,
  files : Array[WechatFile],
) -> Int {
  route_file_bytes(page.route, files) +
  shared_first_screen_bytes(files) +
  page.runtime.initial_data_json.length()
}

///|
fn shared_first_screen_bytes(files : Array[WechatFile]) -> Int {
  let mut total = 0
  for file in files {
    if file.path == "app.wxss" ||
      file.path == "bunnia.runtime.js" ||
      file.path == "bunnia.backend.js" {
      total += file.content.length()
    }
  }
  total
}

///|
fn page_update_payload_bytes(page : WechatProjectPage) -> Int {
  page_event_patch_bytes(page.runtime)
}

///|
fn initial_data_bytes(items : Array[WechatRuntime]) -> Int {
  let mut total = 0
  for item in items {
    total += item.initial_data_json.length()
  }
  total
}

///|
fn event_patch_bytes(runtimes : Array[WechatRuntime]) -> Int {
  let mut total = 0
  for runtime in runtimes {
    for item in runtime.event_patches {
      total += item.message.length()
      for patch in item.patches {
        total += patch.estimated_bytes
      }
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

///|
fn push_page_over_budget(
  diagnostics : Array[String],
  label : String,
  route : String,
  actual : Int,
  limit : Int,
) -> Unit {
  if actual > limit {
    diagnostics.push("\{label}:\{route}:\{actual}/\{limit}")
  }
}
