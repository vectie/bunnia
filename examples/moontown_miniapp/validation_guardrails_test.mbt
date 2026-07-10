///|
fn ordinary_copy_forbidden_labels() -> Array[String] {
  [
    "Backend Loop", "DevTools target", "runtime filter", "runtime channel", "runtime role",
    "backendStatus.load_town_snapshot", "backendStatus.load_message_center", "Ack Sync",
    "Tool Ack", "Ops Desk", "Own Sync", "Tool Results", "Identity Setup", "UID:user-a / avatar://ada",
    "GET /miniapp/town/snapshot / ready", "POST /miniapp/runs/cancel / guarded",
    "POST /miniapp/runs/retry / guarded", "POST /miniapp/messages/ack / ready", "POST /miniapp/messages/subscribe / platform",
    "Developer Diagnostics", "Endpoint id", "HTTP path", "payload key", "response key",
    "package diagnostics", "render diagnostics", "data-ops-desk=\"admin\"", "data-diagnostics-mode=\"reviewer\"",
    "data-backend-step=\"admin-ops\"", "data-backend-step=\"admin-readiness\"", "data-backend-endpoint=\"load-admin-ops\"",
    "data-backend-readiness-endpoint", "data-backend-path=\"/miniapp/admin/ops\"",
    "data-backend-readiness-path", "adminOpsQuery", "adminReadinessQuery", "adminOpsResult",
    "adminReadinessResult", "rate-limit bucket", "audit retention", "recovery", "secrets",
  ]
}

///|
fn ordinary_generated_forbidden_tokens() -> Array[String] {
  [
    "GET /miniapp", "POST /miniapp", "payload_key", "response_key", "backendStatus",
    "DevTools", "runtime filter", "runtime channel", "data-backend-", "data-diagnostic-",
    "data-diagnostics-", "data-developer-diagnostics", "data-payload-key", "data-response-key",
    "moontown-diagnostic-", "Developer Diagnostics", "adminOpsQuery", "adminReadinessQuery",
    "Moderation Desk", "Safety Desk", "OPC Hub", "System Gateway", "system notices",
    "data-moderation-", "hide-public-building", "takedown-public-building", "appeal-moderation-case",
    " is needs setup", "12 memories - 1 reviews", "9 memories - 0 reviews", "0 published place",
    "placement - personal", "Agent run completed", "agent run", "Messages collects runs",
    "Receive run,", "Identity Setup", "profile readiness", "shared-private buildings",
    "shared private", "shared privately", "Reference feature pages", "mini-app",
    "starter-map", "placed from starter-map", "data-bunnia-message=\"switch-user-a\"",
    "data-bunnia-message=\"switch-user-b\"",
  ]
}

///|
fn ordinary_visible_technical_labels() -> Array[String] {
  [
    "endpoint", "payload", "response_key", "cursor", "offset", "load-message-center",
    "load-ownership-snapshot", "load-admin-ops", "load-admin-readiness", "developer diagnostics",
    "reviewer diagnostics", "package diagnostics", "render diagnostics",
  ]
}

///|
fn ordinary_contract_data_tokens() -> Array[String] {
  [
    "adminOpsQuery", "adminReadinessQuery", "messageCenterQuery", "ownershipQuery",
    "/miniapp/admin/ops", "/miniapp/messages/center", "/miniapp/me/ownership",
  ]
}

///|
fn reviewer_diagnostics_allowlist_tokens() -> Array[String] {
  [
    "data-reviewer-route=\"true\"", "Developer Diagnostics", "data-diagnostics-mode=\"reviewer\"",
    "data-http-path=\"/miniapp/admin/ops\"", "data-http-path=\"/miniapp/admin/readiness\"",
    "data-payload-key=\"adminOpsQuery\"", "data-response-key=\"adminReadinessResult\"",
  ]
}

///|
fn has_no_forbidden_ordinary_copy(wxml : String) -> Bool {
  for label in ordinary_copy_forbidden_labels() {
    if wxml.contains(label) {
      return false
    }
  }
  true
}

///|
test "moontown validation guardrails cover required ordinary tokens" {
  assert_true(array_has(ordinary_visible_technical_labels(), "endpoint"))
  assert_true(array_has(ordinary_visible_technical_labels(), "payload"))
  assert_true(array_has(ordinary_visible_technical_labels(), "cursor"))
  assert_true(
    array_has(ordinary_visible_technical_labels(), "load-message-center"),
  )
  assert_true(array_has(ordinary_copy_forbidden_labels(), "Ack Sync"))
  assert_true(array_has(ordinary_copy_forbidden_labels(), "Tool Ack"))
  assert_true(array_has(ordinary_copy_forbidden_labels(), "Ops Desk"))
  assert_true(array_has(ordinary_generated_forbidden_tokens(), "data-backend-"))
  assert_true(
    array_has(ordinary_generated_forbidden_tokens(), "Reference feature pages"),
  )
  assert_true(
    array_has(
      ordinary_generated_forbidden_tokens(),
      "data-bunnia-message=\"switch-user-a\"",
    ),
  )
  assert_true(
    array_has(
      ordinary_generated_forbidden_tokens(),
      "data-bunnia-message=\"switch-user-b\"",
    ),
  )
  assert_true(array_has(ordinary_generated_forbidden_tokens(), "mini-app"))
  assert_true(array_has(ordinary_generated_forbidden_tokens(), "starter-map"))
  assert_true(array_has(ordinary_contract_data_tokens(), "/miniapp/admin/ops"))
  assert_true(
    array_has(
      reviewer_diagnostics_allowlist_tokens(),
      "data-payload-key=\"adminOpsQuery\"",
    ),
  )
}

///|
test "moontown generated labels translate backend state" {
  let project = demo_wechat_project()
  let home = guardrail_file_content(project.files, "pages/moontown/home.wxml")
  let messages = guardrail_file_content(
    project.files,
    "pages/moontown/messages.wxml",
  )
  let mine = guardrail_file_content(project.files, "pages/moontown/my.wxml")
  assert_true(!mine.contains("Refresh Town"))
  assert_true(!home.contains("Needs refresh"))
  assert_true(!messages.contains("Try Again"))
  assert_true(messages.contains("Stop Work"))
  assert_true(!messages.contains("Failed Actions"))
  assert_true(messages.contains("Needs Review"))
  assert_true(mine.contains("Refresh My Stuff"))
  assert_true(!home.contains("Load Snapshot"))
  assert_true(home.contains("Decide what needs you"))
  assert_true(!mine.contains("already on your map"))
  assert_true(!home.contains("mini-app"))
  assert_true(!mine.contains("starter-map"))
  assert_true(!messages.contains("Retry Run"))
  assert_true(!messages.contains("Cancel Run"))
  assert_true(!mine.contains("Sync Ownership"))
}

///|
fn array_has(items : Array[String], expected : String) -> Bool {
  for item in items {
    if item == expected {
      return true
    }
  }
  false
}

///|
fn guardrail_file_content(
  files : Array[@bunnia.WechatFile],
  path : String,
) -> String {
  for file in files {
    if file.path == path {
      return file.content
    }
  }
  ""
}
