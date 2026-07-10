///|
test "moontown miniapp generated page keeps lifecycle and private ids safe" {
  let page = demo_wechat_page()
  assert_true(page.wxml.contains("Lifecycle Stamps"))
  assert_true(page.wxml.contains("data-object-section=\"lifecycle\""))
  assert_true(page.wxml.contains("moontown-lifecycle-stages"))
  assert_true(page.wxml.contains("data-lifecycle-stage=\"private-draft\""))
  assert_true(page.wxml.contains("data-lifecycle-stage=\"team-shared\""))
  assert_true(page.wxml.contains("data-lifecycle-stage=\"submitted\""))
  assert_true(page.wxml.contains("data-lifecycle-stage=\"published\""))
  assert_true(page.wxml.contains("data-lifecycle-stage=\"hidden\""))
  assert_true(page.wxml.contains("data-lifecycle-stage=\"archived\""))
  assert_true(page.wxml.contains("moontown-lifecycle-actions"))
  assert_true(page.wxml.contains("data-lifecycle-action=\"place\""))
  assert_true(!page.wxml.contains("data-lifecycle-action=\"ask\""))
  assert_true(!page.wxml.contains("data-lifecycle-action=\"edit\""))
  assert_true(!page.wxml.contains("data-lifecycle-action=\"submit\""))
  assert_true(!page.wxml.contains("data-lifecycle-action=\"publish\""))
  assert_true(
    page.wxml.contains("data-bunnia-message=\"place-published-building\""),
  )
  assert_true(
    !page.wxml.contains("data-bunnia-message=\"update-private-building\""),
  )
  assert_true(!page.js.contains("\"update-private-building\""))
  assert_true(!page.js.contains("\"publish-private-building\""))
  assert_true(!page.wxml.contains("data-target-ref=\"building:policy-hall\""))
  assert_true(!page.wxml.contains("data-book-id=\"book-policy-hall\""))
  assert_true(!page.wxml.contains("moontown-lifecycle-action blocked"))
  assert_true(!page.wxml.contains("data-allowed="))
  assert_true(!page.wxml.contains("data-blocked-reason=\"owner only\""))
  assert_true(!page.wxml.contains("Owner only"))
  assert_true(page.wxml.contains("moontown-lifecycle-stamp"))
  assert_true(!page.wxml.contains("disabled=\"true\""))
  assert_true(!page.wxml.contains("moontown-object-message"))
  assert_true(!page.wxml.contains("Place message - Policy Hall"))
  assert_true(page.wxml.contains("Policy Guide - Policy Hall"))
  assert_true(!page.wxml.contains("moontown-run-entry"))
  assert_true(page.wxml.contains("Policy answer review"))
  assert_true(!page.wxml.contains("data-run-id=\"run-policy-review\""))
  assert_true(
    !page.wxml.contains("data-artifact-ref=\"artifact://book-policy-hall\""),
  )
  assert_true(!page.wxml.contains("data-actor-id="))
  assert_true(!page.wxml.contains("artifact://book-policy-hall"))
  assert_true(!page.wxml.contains("moontown-audit-entry"))
  assert_true(!page.wxml.contains("Policy answer entered review"))
  assert_true(!page.wxml.contains("data-audit-id=\"audit-policy-review\""))
  assert_true(page.wxml.contains("Report Concern"))
  assert_true(!page.wxml.contains("Safety Desk"))
  assert_true(!page.wxml.contains("data-moderation-"))
  assert_true(page.wxml.contains("data-safety-report-building=\"policy-hall\""))
  assert_true(page.wxml.contains("data-safety-report-count=\"1\""))
  assert_true(
    page.wxml.contains("data-bunnia-message=\"report-public-building\""),
  )
}

///|
test "moontown Realm shows only available owner actions for a private place" {
  let projection = create_private_building(
    demo_projection(),
    "owner-drawer-test",
    "Private Agent Lab",
  )
  let realm = tab_page(projection, "realm")
  assert_true(
    realm.wxml.contains("moontown-map-marker selected bunnia-status-draft"),
  )
  assert_true(realm.wxml.contains("Private Agent Lab"))
  assert_true(realm.wxml.contains("data-lifecycle-action=\"edit\""))
  assert_true(realm.wxml.contains("data-lifecycle-action=\"share\""))
  assert_true(realm.wxml.contains("data-lifecycle-action=\"archive\""))
  assert_true(!realm.wxml.contains("data-lifecycle-action=\"submit\""))
  assert_true(!realm.wxml.contains("data-lifecycle-action=\"publish\""))
  assert_true(!realm.wxml.contains("data-lifecycle-action=\"restore\""))
  assert_true(
    realm.wxml.contains("data-bunnia-message=\"update-private-building\""),
  )
  assert_true(
    realm.wxml.contains("data-bunnia-message=\"share-private-building\""),
  )
  assert_true(
    realm.wxml.contains("data-bunnia-message=\"archive-private-building\""),
  )
  assert_true(realm.wxml.contains("moontown-danger-action"))
  assert_true(!realm.wxml.contains("data-allowed="))
  assert_true(!realm.wxml.contains("disabled=\"true\""))
}
