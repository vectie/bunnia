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
  project_name : String
  route : String
  page_count : Int
  file_count : Int
  total_bytes : Int
  max_first_screen_bytes : Int
  max_update_payload_bytes : Int
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
  )
}

///|
pub fn snapshot_wechat_project_with_report(
  target~ : String,
  example~ : String,
  project : @wechat.WechatProject,
  report : @wechat.WechatBuildReport,
  profile : BuildProfile,
) -> GeneratedSnapshot {
  let files : Array[GeneratedSnapshotFile] = []
  for item in project.files {
    files.push(snapshot_file(item))
  }
  let diagnostic_count = report.diagnostics.length() +
    profile.diagnostics.length()
  let summary = "Bunnia generated snapshot: target=\{target} example=\{example} route=\{project.route} files=\{project.files.length()} bytes=\{project.total_bytes} diagnostics=\{diagnostic_count}"
  let content = snapshot_content(
    target, example, project, report, profile, files, summary,
  )
  {
    target,
    example,
    project_name: project.name,
    route: project.route,
    page_count: project.page_count,
    file_count: project.files.length(),
    total_bytes: project.total_bytes,
    max_first_screen_bytes: report.max_page_first_screen_bytes,
    max_update_payload_bytes: report.max_page_update_payload_bytes,
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
  write_snapshot_field(out, "report", report.summary)
  write_snapshot_field(out, "profile", profile.summary)
  write_snapshot_field(out, "summary", summary)
  out.write_string("files:\n")
  for item in files {
    out.write_string(
      "- \{item.path} kind=\{item.kind} bytes=\{item.bytes} checksum=\{item.checksum}\n",
    )
  }
  out.to_string()
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
  if path.has_suffix(".wxml") {
    "wxml"
  } else if path.has_suffix(".wxss") {
    "wxss"
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
