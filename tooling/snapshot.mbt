///|
pub struct GeneratedSnapshotFile {
  path : String
  kind : String
  bytes : Int
  checksum : Int
} derive(Debug, Eq)

///|
pub struct GeneratedSnapshot {
  target : String
  example : String
  budget_profile : String
  render_budget_profile : String
  project_name : String
  route : String
  page_count : Int
  file_count : Int
  total_bytes : Int
  max_first_screen_bytes : Int
  max_update_payload_bytes : Int
  route_diagnostic_route_count : Int
  route_diagnostic_count : Int
  diagnostic_count : Int
  files : Array[GeneratedSnapshotFile]
  summary : String
  content : String
} derive(Debug, Eq)

///|
pub fn snapshot_wechat_project(
  target~ : String,
  example~ : String,
  project : @wechat.WechatProject,
  profile : BuildProfile,
) -> GeneratedSnapshot {
  snapshot_wechat_project_with_report(
    target~,
    example~,
    project,
    project.report,
    profile,
    budget_profile="default",
    render_budget_profile="default",
  )
}

///|
pub fn snapshot_wechat_project_with_report(
  target~ : String,
  example~ : String,
  project : @wechat.WechatProject,
  report : @wechat.WechatBuildReport,
  profile : BuildProfile,
  budget_profile? : String = "default",
  render_budget_profile? : String = "default",
) -> GeneratedSnapshot {
  let files : Array[GeneratedSnapshotFile] = []
  for item in project.files {
    files.push(snapshot_file(item))
  }
  let route_diagnostic_route_count = project.manifest.diagnostic_route_count
  let route_diagnostic_count = project.manifest.diagnostic_count
  let diagnostic_count = report.diagnostics.length() +
    profile.diagnostics.length()
  let summary = "Bunnia generated snapshot: target=\{target} example=\{example} budget=\{budget_profile} render_budget=\{render_budget_profile} route=\{project.route} files=\{project.files.length()} bytes=\{project.total_bytes} route_diagnostic_routes=\{route_diagnostic_route_count} route_diagnostics=\{route_diagnostic_count} diagnostics=\{diagnostic_count}"
  let content = snapshot_content(
    target, example, budget_profile, render_budget_profile, project, report, profile,
    files, summary,
  )
  {
    target,
    example,
    budget_profile,
    render_budget_profile,
    project_name: project.name,
    route: project.route,
    page_count: project.page_count,
    file_count: project.files.length(),
    total_bytes: project.total_bytes,
    max_first_screen_bytes: report.max_page_first_screen_bytes,
    max_update_payload_bytes: report.max_page_update_payload_bytes,
    route_diagnostic_route_count,
    route_diagnostic_count,
    diagnostic_count,
    files,
    summary,
    content,
  }
}

///|
fn snapshot_file(input : @wechat.WechatFile) -> GeneratedSnapshotFile {
  {
    path: input.path,
    kind: file_kind(input.path),
    bytes: input.content.length(),
    checksum: checksum_string(input.content),
  }
}

///|
fn snapshot_content(
  target : String,
  example : String,
  budget_profile : String,
  render_budget_profile : String,
  project : @wechat.WechatProject,
  report : @wechat.WechatBuildReport,
  profile : BuildProfile,
  files : Array[GeneratedSnapshotFile],
  summary : String,
) -> String {
  let out = StringBuilder()
  out.write_string("bunnia-generated-snapshot-v1\n")
  write_snapshot_field(out, "target", target)
  write_snapshot_field(out, "example", example)
  write_snapshot_field(out, "budget_profile", budget_profile)
  write_snapshot_field(out, "render_budget_profile", render_budget_profile)
  write_snapshot_field(out, "project", project.name)
  write_snapshot_field(out, "route", project.route)
  write_snapshot_field(out, "pages", project.page_count.to_string())
  write_snapshot_field(out, "files", project.files.length().to_string())
  write_snapshot_field(out, "total_bytes", project.total_bytes.to_string())
  write_snapshot_field(
    out,
    "max_first_screen",
    report.max_page_first_screen_bytes.to_string(),
  )
  write_snapshot_field(
    out,
    "max_update_payload",
    report.max_page_update_payload_bytes.to_string(),
  )
  write_snapshot_field(
    out,
    "diagnostics",
    (report.diagnostics.length() + profile.diagnostics.length()).to_string(),
  )
  write_snapshot_field(
    out,
    "route_diagnostic_routes",
    project.manifest.diagnostic_route_count.to_string(),
  )
  write_snapshot_field(
    out,
    "route_diagnostics",
    project.manifest.diagnostic_count.to_string(),
  )
  write_snapshot_field(out, "report", report.summary)
  write_snapshot_field(out, "profile", profile.summary)
  write_snapshot_field(out, "summary", summary)
  write_snapshot_route_diagnostics(out, project.manifest.pages)
  write_snapshot_diagnostics(out, "report_diagnostics", report.diagnostics)
  write_snapshot_diagnostics(out, "profile_diagnostics", profile.diagnostics)
  out.write_string("files:\n")
  for item in files {
    out.write_string(
      "- \{item.path} kind=\{item.kind} bytes=\{item.bytes} checksum=\{item.checksum}\n",
    )
  }
  out.to_string()
}

///|
fn write_snapshot_route_diagnostics(
  out : StringBuilder,
  pages : Array[@wechat.WechatManifestPage],
) -> Unit {
  out.write_string("route_diagnostics:\n")
  for page in pages {
    if page.diagnostics.length() > 0 {
      out.write_string("- \{page.route}\n")
      for item in page.diagnostics {
        out.write_string("  - \{item}\n")
      }
    }
  }
}

///|
fn write_snapshot_diagnostics(
  out : StringBuilder,
  name : String,
  items : Array[String],
) -> Unit {
  out.write_string("\{name}:\n")
  for item in items {
    out.write_string("- \{item}\n")
  }
}

///|
fn write_snapshot_field(
  out : StringBuilder,
  name : String,
  value : String,
) -> Unit {
  out.write_string("\{name}=\{value}\n")
}

///|
fn file_kind(path : String) -> String {
  if path == "bunnia.backend.js" {
    "backend-js"
  } else if path.has_suffix(".wxml") {
    "wxml"
  } else if path.has_suffix(".wxss") {
    "wxss"
  } else if path.has_suffix(".data.js") {
    "page-data"
  } else if path.has_suffix(".js") {
    "js"
  } else if path.has_suffix(".json") {
    "json"
  } else {
    "asset"
  }
}

///|
fn checksum_string(value : String) -> Int {
  let mut checksum = 5381
  for i in 0..<value.length() {
    let weighted = value[i].to_int() % 4096 * (i % 251 + 1)
    checksum = (checksum + weighted) % 1000000007
  }
  checksum
}
