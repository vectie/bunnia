///|
pub struct ReleaseReadinessReport {
  target : String
  example : String
  budget_profile : String
  status : String
  checklist_count : Int
  passed_count : Int
  diagnostic_count : Int
  diagnostics : Array[String]
  summary : String
} derive(Debug, Eq)

///|
pub fn release_readiness_report(
  target~ : String,
  example~ : String,
  budget_profile~ : String,
  project : @wechat.WechatProject,
  profile : BuildProfile,
  profile_gate : BuildProfileGate,
  inspection : ProjectInspection,
  inspection_gate : ProjectInspectionGate,
) -> ReleaseReadinessReport {
  let diagnostics : Array[String] = []
  collect_release_diagnostics(
    diagnostics, project, profile, profile_gate, inspection, inspection_gate,
  )
  let checklist_count = 8
  let passed_count = release_passed_count(checklist_count, diagnostics.length())
  let status = if diagnostics.length() == 0 { "ready" } else { "blocked" }
  {
    target,
    example,
    budget_profile,
    status,
    checklist_count,
    passed_count,
    diagnostic_count: diagnostics.length(),
    diagnostics,
    summary: "Bunnia release readiness: target=\{target} example=\{example} budget=\{budget_profile} status=\{status} checks=\{passed_count}/\{checklist_count} diagnostics=\{diagnostics.length()}",
  }
}

///|
pub fn miniapp_release_readiness_report(
  target~ : String,
  example~ : String,
  budget_profile~ : String,
  project : @miniapp.MiniappProject,
  inspection : MiniappInspection,
  inspection_gate : MiniappInspectionGate,
) -> ReleaseReadinessReport {
  let diagnostics : Array[String] = []
  collect_miniapp_release_diagnostics(
    diagnostics, target, project, inspection, inspection_gate,
  )
  let checklist_count = 7
  let passed_count = release_passed_count(checklist_count, diagnostics.length())
  let status = if diagnostics.length() == 0 { "ready" } else { "blocked" }
  {
    target,
    example,
    budget_profile,
    status,
    checklist_count,
    passed_count,
    diagnostic_count: diagnostics.length(),
    diagnostics,
    summary: "Bunnia generic miniapp release readiness: target=\{target} example=\{example} budget=\{budget_profile} status=\{status} checks=\{passed_count}/\{checklist_count} diagnostics=\{diagnostics.length()}",
  }
}

///|
fn release_passed_count(checklist_count : Int, diagnostic_count : Int) -> Int {
  let count = checklist_count - diagnostic_count
  if count < 0 {
    0
  } else {
    count
  }
}

///|
fn collect_miniapp_release_diagnostics(
  diagnostics : Array[String],
  target : String,
  project : @miniapp.MiniappProject,
  inspection : MiniappInspection,
  inspection_gate : MiniappInspectionGate,
) -> Unit {
  if project.manifest.platform_id != target {
    diagnostics.push(
      "release-miniapp-target-mismatch:\{project.manifest.platform_id}/\{target}",
    )
  }
  if project.manifest.page_count != project.pages.length() {
    diagnostics.push(
      "release-miniapp-manifest-page-count-mismatch:\{project.manifest.page_count}/\{project.pages.length()}",
    )
  }
  if project.manifest.file_count + 1 != project.files.length() {
    diagnostics.push(
      "release-miniapp-manifest-file-count-mismatch:\{project.manifest.file_count + 1}/\{project.files.length()}",
    )
  }
  if !miniapp_project_has_file(project, "bunnia.manifest.json") {
    diagnostics.push("release-miniapp-manifest-missing:bunnia.manifest.json")
  }
  if !miniapp_project_has_file(project, "app.json") {
    diagnostics.push("release-miniapp-app-config-missing:app.json")
  }
  if miniapp_project_contains_secret_marker(project) {
    diagnostics.push("release-miniapp-frontend-secret-marker-found")
  }
  if miniapp_project_contains_literal_app_id(project) {
    diagnostics.push("release-miniapp-frontend-app-id-found")
  }
  if project.manifest.diagnostic_count > 0 {
    diagnostics.push(
      "release-miniapp-route-diagnostics:\{project.manifest.diagnostic_count}",
    )
  }
  if inspection.diagnostic_count > 0 {
    diagnostics.push(
      "release-miniapp-inspection-diagnostics:\{inspection.diagnostic_count}",
    )
  }
  if inspection_gate.diagnostics.length() > 0 {
    diagnostics.push(
      "release-miniapp-inspection-gate-diagnostics:\{inspection_gate.diagnostics.length()}",
    )
  }
}

///|
fn collect_release_diagnostics(
  diagnostics : Array[String],
  project : @wechat.WechatProject,
  profile : BuildProfile,
  profile_gate : BuildProfileGate,
  inspection : ProjectInspection,
  inspection_gate : ProjectInspectionGate,
) -> Unit {
  if project.manifest.page_count != project.page_count {
    diagnostics.push(
      "release-manifest-page-count-mismatch:\{project.manifest.page_count}/\{project.page_count}",
    )
  }
  if project.manifest.app_file_count + 1 != project.files.length() {
    diagnostics.push(
      "release-manifest-file-count-mismatch:\{project.manifest.app_file_count + 1}/\{project.files.length()}",
    )
  }
  if !project_has_file(project, "bunnia.manifest.json") {
    diagnostics.push("release-manifest-missing:bunnia.manifest.json")
  }
  if project_contains_secret_marker(project) {
    diagnostics.push("release-frontend-secret-marker-found")
  }
  if project_contains_literal_app_id(project) {
    diagnostics.push("release-frontend-app-id-found")
  }
  if profile.scene_insecure_remote_asset_count > 0 {
    diagnostics.push(
      "release-insecure-remote-scene-assets:\{profile.scene_insecure_remote_asset_count}",
    )
  }
  if profile.scene_unapproved_remote_asset_count > 0 {
    diagnostics.push(
      "release-unapproved-remote-scene-assets:\{profile.scene_unapproved_remote_asset_count}",
    )
  }
  if profile.backend_endpoint_count > 0 &&
    !project_has_file(project, "bunnia.backend.js") {
    diagnostics.push("release-backend-contract-without-adapter")
  }
  if profile.backend_endpoint_count > 0 &&
    !backend_adapter_has_audit_hooks(project) {
    diagnostics.push("release-backend-adapter-missing-audit-hooks")
  }
  if profile.route_diagnostic_count > 0 {
    diagnostics.push(
      "release-route-diagnostics:\{profile.route_diagnostic_count}",
    )
  }
  if profile.diagnostics.length() > 0 {
    diagnostics.push(
      "release-profile-diagnostics:\{profile.diagnostics.length()}",
    )
  }
  if profile_gate.diagnostics.length() > 0 {
    diagnostics.push(
      "release-profile-gate-diagnostics:\{profile_gate.diagnostics.length()}",
    )
  }
  if inspection.total_diagnostics > 0 {
    diagnostics.push(
      "release-inspection-diagnostics:\{inspection.total_diagnostics}",
    )
  }
  if inspection_gate.diagnostics.length() > 0 {
    diagnostics.push(
      "release-inspection-gate-diagnostics:\{inspection_gate.diagnostics.length()}",
    )
  }
}

///|
fn miniapp_project_has_file(
  project : @miniapp.MiniappProject,
  path : String,
) -> Bool {
  for file in project.files {
    if file.path == path {
      return true
    }
  }
  false
}

///|
fn project_has_file(project : @wechat.WechatProject, path : String) -> Bool {
  for file in project.files {
    if file.path == path {
      return true
    }
  }
  false
}

///|
fn project_file_content(
  project : @wechat.WechatProject,
  path : String,
) -> String {
  for file in project.files {
    if file.path == path {
      return file.content
    }
  }
  ""
}

///|
fn miniapp_project_contains_secret_marker(
  project : @miniapp.MiniappProject,
) -> Bool {
  for file in project.files {
    if generated_file_is_frontend(file.path) &&
      (
        file.content.contains("appSecret") ||
        file.content.contains("APP_SECRET") ||
        file.content.contains("secretKey") ||
        file.content.contains("privateKey")
      ) {
      return true
    }
  }
  false
}

///|
fn project_contains_secret_marker(project : @wechat.WechatProject) -> Bool {
  for file in project.files {
    if generated_file_is_frontend(file.path) &&
      (
        file.content.contains("appSecret") ||
        file.content.contains("APP_SECRET") ||
        file.content.contains("secretKey") ||
        file.content.contains("privateKey")
      ) {
      return true
    }
  }
  false
}

///|
fn miniapp_project_contains_literal_app_id(
  project : @miniapp.MiniappProject,
) -> Bool {
  for file in project.files {
    if file.path == "app.json" &&
      file.content.contains("\"appid\"") &&
      !file.content.contains("\"appid\": \"\"") &&
      !file.content.contains("\"appid\": \"touristappid\"") {
      return true
    }
  }
  false
}

///|
fn project_contains_literal_app_id(project : @wechat.WechatProject) -> Bool {
  for file in project.files {
    if file.path == "project.config.json" &&
      file.content.contains("\"appid\"") &&
      !file.content.contains("\"appid\": \"\"") &&
      !file.content.contains("\"appid\": \"touristappid\"") {
      return true
    }
  }
  false
}

///|
fn generated_file_is_frontend(path : String) -> Bool {
  path.has_suffix(".js") ||
  path.has_suffix(".json") ||
  path.has_suffix(".axml") ||
  path.has_suffix(".acss") ||
  path.has_suffix(".ttml") ||
  path.has_suffix(".ttss") ||
  path.has_suffix(".wxml") ||
  path.has_suffix(".wxss")
}

///|
fn backend_adapter_has_audit_hooks(project : @wechat.WechatProject) -> Bool {
  let content = project_file_content(project, "bunnia.backend.js")
  content.contains("replayKey") &&
  content.contains("bunniaSessionId") &&
  content.contains("x-miniapp-session") &&
  content.contains("backend.' + endpointId + '.request")
}
