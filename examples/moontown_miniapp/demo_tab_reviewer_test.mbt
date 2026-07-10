///|
test "moontown miniapp gates reviewer diagnostics from My tab" {
  let projection = demo_projection()
  let reviewer_mine = tab_page(open_reviewer_tools(projection), "my")
  assert_true(reviewer_mine.wxml.contains("Reviewer Tools"))
  assert_true(reviewer_mine.wxml.contains("Reviewer Mode"))
  assert_true(reviewer_mine.wxml.contains("data-diagnostics-mode=\"reviewer\""))
  assert_true(
    reviewer_mine.wxml.contains("data-diagnostics-source=\"reviewer-route\""),
  )
  assert_true(reviewer_mine.wxml.contains("Source: reviewer route"))
  assert_true(!reviewer_mine.wxml.contains("Ops Desk"))
  assert_true(reviewer_mine.wxml.contains("data-ops-desk=\"admin\""))
  assert_true(reviewer_mine.wxml.contains("data-backend-step=\"admin-ops\""))
  assert_true(
    reviewer_mine.wxml.contains("data-backend-endpoint=\"load-admin-ops\""),
  )
  assert_true(
    reviewer_mine.wxml.contains(
      "data-backend-readiness-endpoint=\"load-admin-readiness\"",
    ),
  )
  assert_true(
    reviewer_mine.wxml.contains("data-backend-path=\"/miniapp/admin/ops\""),
  )
  assert_true(
    reviewer_mine.wxml.contains(
      "data-backend-readiness-path=\"/miniapp/admin/readiness\"",
    ),
  )
  assert_true(
    reviewer_mine.wxml.contains("data-diagnostic-section=\"Town Safety\""),
  )
  assert_true(
    reviewer_mine.wxml.contains("data-diagnostic-section=\"Launch Checks\""),
  )
  assert_true(reviewer_mine.wxml.contains("health"))
  assert_true(reviewer_mine.wxml.contains("incidents"))
  assert_true(reviewer_mine.wxml.contains("audit retention"))
  assert_true(reviewer_mine.wxml.contains("recovery"))
  assert_true(reviewer_mine.wxml.contains("rate-limit bucket"))
  assert_true(reviewer_mine.wxml.contains("secrets"))
  assert_true(reviewer_mine.wxml.contains("Reviewer Actions"))
  assert_true(
    reviewer_mine.wxml.contains(
      "Review, hide, takedown, release hold, resolve incident, and check readiness.",
    ),
  )
  assert_true(reviewer_mine.wxml.contains("Moderation Desk"))
  assert_true(
    reviewer_mine.wxml.contains("data-moderation-case=\"mod-policy-hall\""),
  )
  assert_true(reviewer_mine.wxml.contains("data-moderation-action=\"hide\""))
  assert_true(
    reviewer_mine.wxml.contains("data-moderation-action=\"takedown\""),
  )
  assert_true(reviewer_mine.wxml.contains("data-moderation-action=\"appeal\""))
  assert_true(
    reviewer_mine.wxml.contains("data-bunnia-message=\"hide-public-building\""),
  )
  assert_true(
    reviewer_mine.wxml.contains(
      "data-bunnia-message=\"takedown-public-building\"",
    ),
  )
  assert_true(
    reviewer_mine.wxml.contains(
      "data-bunnia-message=\"appeal-moderation-case\"",
    ),
  )
  assert_true(reviewer_mine.wxml.contains("Developer Diagnostics"))
  assert_true(
    reviewer_mine.wxml.contains("data-developer-diagnostics=\"local-explicit\""),
  )
  assert_true(reviewer_mine.wxml.contains("data-payload-key=\"adminOpsQuery\""))
  assert_true(
    reviewer_mine.wxml.contains("data-response-key=\"adminOpsResult\""),
  )
  assert_true(
    reviewer_mine.wxml.contains("data-payload-key=\"adminReadinessQuery\""),
  )
  assert_true(
    reviewer_mine.wxml.contains("data-response-key=\"adminReadinessResult\""),
  )
  assert_true(reviewer_mine.wxml.contains("package diagnostics"))
  assert_true(reviewer_mine.wxml.contains("render diagnostics"))
  assert_true(reviewer_mine.wxml.contains("Check Town Safety"))
  assert_true(reviewer_mine.wxml.contains("Launch Checks"))
  assert_true(!reviewer_mine.wxml.contains("Ops Check"))
  assert_true(
    reviewer_mine.wxml.contains("data-bunnia-message=\"load-admin-ops\""),
  )
  assert_true(
    reviewer_mine.wxml.contains("data-bunnia-message=\"load-admin-readiness\""),
  )
}

///|
test "moontown reviewer route shares the town visual identity" {
  let project = demo_wechat_project()
  let wxss = file_content(project.files, "pages/moontown/reviewer.wxss")
  assert_true(wxss.contains("background:#eef2f7"))
  assert_true(
    wxss.contains(
      ".moontown-page-surface{position:relative;left:auto;right:auto;top:auto;bottom:auto;min-height:100vh;margin:0",
    ),
  )
  assert_true(wxss.contains("border:2rpx solid #2563eb"))
  assert_true(wxss.contains("background:#f8fafc"))
  assert_true(wxss.contains("border-top:3rpx solid #e11d48"))
  assert_true(wxss.contains("border-left:4rpx solid #2563eb"))
  assert_true(wxss.contains("background:#203124;color:#ffffff"))
  assert_true(!wxss.contains("#f8f3df"))
  assert_true(!wxss.contains("#fffaf0"))
  assert_true(!wxss.contains("#8a6d3b"))
}
