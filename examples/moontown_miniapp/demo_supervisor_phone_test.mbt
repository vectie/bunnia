///|
test "first supervisor kiosk is resumable and backend-bound" {
  let projection = demo_projection()
  let home = tab_page(projection, "home")
  assert_eq(projection.supervisor_setup.current_step, "identity")
  assert_eq(projection.supervisor.child_limit, 3)
  assert_eq(projection.child_workers.length(), 3)
  assert_true(home.wxml.contains("FIRST VISIT · REGISTRATION KIOSK"))
  assert_true(home.wxml.contains("Create your town supervisor"))
  for
    copy in [
      "1 · Identity", "Mission &amp; manner", "3 · Bind a home", "Consent &amp; readiness",
      "5 · Activate",
    ] {
    assert_true(home.wxml.contains(copy))
  }
  assert_true(
    home.wxml.contains("data-bunnia-input-path=\"supervisorDraft.name\""),
  )
  assert_true(
    home.wxml.contains("data-bunnia-input-path=\"supervisorDraft.mission\""),
  )
  assert_true(
    home.wxml.contains("data-bunnia-message=\"load-supervisor-setup\""),
  )
  assert_true(
    home.wxml.contains("data-bunnia-message=\"save-supervisor-draft\""),
  )
  assert_true(home.wxml.contains("data-bunnia-message=\"activate-supervisor\""))
  assert_true(home.wxml.contains("requestState.statusCode == 409"))
  assert_true(home.wxml.contains("No saved draft yet"))
  assert_true(home.wxml.contains("Your local entries are still here"))
  assert_true(home.wxml.contains("Draft saved"))
  assert_true(home.wxml.contains("pending_transport"))
  assert_true(home.wxml.contains("runtime_acknowledged"))
  assert_true(home.wxml.contains("Bookkeeper reviews acceptance separately"))
  assert_true(
    home.wxml.contains("accept the current terms and authority ceiling"),
  )
}

///|
test "messages controls supervisor child work reviews and receipts" {
  let messages = tab_page(demo_projection(), "messages")
  for
    copy in [
      "Supervisor", "Tasks", "Reviews", "Receipts", "Child Task Board", "Bookkeeper Receipts",
      "PENDING · NOT ACCEPTED", "ACCEPTED", "REJECTED", "Queued · waiting for the runtime provider",
    ] {
    assert_true(messages.wxml.contains(copy))
  }
  assert_true(
    messages.wxml.contains("data-bunnia-message=\"send-supervisor-message\""),
  )
  assert_true(messages.wxml.contains("SUPERVISOR LODGE · NOT OPEN"))
  assert_true(messages.wxml.contains("data-bunnia-message=\"tab-home\""))
  assert_true(messages.wxml.contains("runtimeCursor &gt; 0"))
  assert_true(messages.wxml.contains("data-bunnia-message=\"assign-worker\""))
  assert_true(messages.wxml.contains("data-bunnia-message=\"steer-run\""))
  assert_true(messages.wxml.contains("data-bunnia-message=\"steer-child-run\""))
  assert_true(messages.wxml.contains("data-bunnia-message=\"cancel-run\""))
  assert_true(messages.wxml.contains("data-bunnia-message=\"retry-run\""))
  assert_true(messages.wxml.contains("data-bunnia-message=\"wake-supervisor\""))
  assert_true(messages.wxml.contains("data-bunnia-message=\"stop-supervisor\""))
  assert_true(
    messages.wxml.contains("data-bunnia-message=\"resume-supervisor\""),
  )
  assert_true(messages.wxml.contains("receipt-backed parent supervisor run"))
  assert_true(
    messages.wxml.contains("wx:for=\"{{onboardingSnapshot.executionLineage}}\""),
  )
  assert_true(messages.wxml.contains("Request Bookkeeper review"))
  assert_true(messages.wxml.contains("Outcome evidence still required"))
  assert_true(messages.wxml.contains("no outcome was auto-accepted"))
  assert_true(messages.wxml.contains("messages.channel == 'receipts'"))
  assert_true(messages.wxml.contains("bunnia-list-windowed"))
}

///|
test "generated project exposes supervisor command contracts and bound input runtime" {
  let project = demo_wechat_project()
  let backend = file_content(project.files, "bunnia.backend.js")
  let home_js = file_content(project.files, "pages/moontown/home.js")
  let home_data = file_content(project.files, "pages/moontown/home.data.js")
  let messages_js = file_content(project.files, "pages/moontown/messages.js")
  let messages_data = file_content(
    project.files,
    "pages/moontown/messages.data.js",
  )
  for
    route in [
      "/miniapp/onboarding/supervisor", "/miniapp/onboarding/supervisor/draft", "/miniapp/onboarding/supervisor/activate",
      "/miniapp/messages", "/miniapp/runs/steer", "/miniapp/runs/delegate", "/miniapp/runs/child/steer",
      "/miniapp/runs/supervisor/wake", "/miniapp/runs/supervisor/stop", "/miniapp/runs/supervisor/resume",
      "/miniapp/reviews/decision",
    ] {
    assert_true(backend.contains(route))
  }
  assert_true(backend.contains("\"save-supervisor-draft\""))
  assert_true(backend.contains("m:\"PUT\""))
  assert_true(home_data.contains("\"profile_digest\":\"\""))
  assert_true(home_data.contains("\"expected_cursor\":0"))
  assert_true(messages_data.contains("\"runCancel\":{}"))
  assert_false(messages_data.contains("\"runId\":\"run-market-scan\""))
  assert_true(messages_js.contains("__moontownRuntimeProjection"))
  assert_true(messages_js.contains("activeRunId"))
  assert_true(messages_js.contains("runtimeCursor"))
  assert_true(messages_js.contains("runtimeExecutionStatus"))
  assert_true(messages_js.contains("parentRunId:live.activeRunId"))
  assert_true(messages_js.contains("action:'message'"))
  assert_true(messages_js.contains("action:'delegate'"))
  assert_true(messages_js.contains("'child_steer'"))
  assert_true(messages_js.contains("'wake'"))
  assert_true(messages_js.contains("'supervisor_stop'"))
  assert_true(messages_js.contains("'supervisor_resume'"))
  assert_true(messages_js.contains("targetRunId:selected"))
  assert_true(messages_js.contains("runtimeExpectedCursor:live.runtimeCursor"))
  assert_true(messages_js.contains("__bunniaBeforeRequest"))
  assert_true(messages_js.contains("__moontownRefreshSupervisor"))
  assert_true(
    messages_js.contains("__bunniaRequest(this,'load-supervisor-setup',{},"),
  )
  assert_true(home_js.contains("dataset.bunniaInputPath"))
  assert_true(home_js.contains("event.detail.value"))
}
