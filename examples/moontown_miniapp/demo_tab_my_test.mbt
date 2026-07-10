///|
test "moontown miniapp renders My inventory workbench tab surface" {
  let projection = demo_projection()
  let mine = tab_page(projection, "my")
  assert_true(has_no_forbidden_ordinary_copy(mine.wxml))
  assert_true(mine.wxml.contains("data-active-tab=\"my\""))
  assert_true(mine.wxml.contains("moontown-my-layout"))
  assert_true(mine.wxml.contains("data-attention-count=\"1\""))
  assert_true(
    !mine.wxml.contains("Identity first, then the work that needs you."),
  )
  assert_true(mine.wxml.contains("Town Passport"))
  assert_true(!mine.wxml.contains("Identity Setup"))
  assert_true(
    !mine.wxml.contains("runtime role: {{profile.roleId || 'builder'}}"),
  )
  assert_true(!mine.wxml.contains("own: {{ownership.filter || 'all'}}"))
  assert_true(mine.wxml.contains("My Inventory"))
  assert_true(
    !mine.wxml.contains(
      "Browse 5 owned items by shelf, then open the work you need.",
    ),
  )
  assert_true(!mine.wxml.contains("Town passport, setup stamps"))
  assert_eq(
    string_occurrence_count(mine.wxml, "data-setup-gate=\"session\""),
    0,
  )
  assert_eq(
    string_occurrence_count(mine.wxml, "data-setup-gate=\"publish-ready\""),
    0,
  )
  assert_true(!mine.wxml.contains("Town Entry"))
  assert_true(!mine.wxml.contains("Entered as Ada Builder."))
  assert_true(!mine.wxml.contains("Logged in as user-a"))
  assert_true(!mine.wxml.contains("Town Role"))
  assert_true(!mine.wxml.contains("Role selected: Builder."))
  assert_true(!mine.wxml.contains("Role selected: builder."))
  assert_true(!mine.wxml.contains("moontown-role-entry"))
  assert_true(!mine.wxml.contains("Ready to Publish"))
  assert_true(
    !mine.wxml.contains(
      "Publishing stays blocked until role, consent, and profile are ready.",
    ),
  )
  assert_true(mine.wxml.contains("data-complete=\"false\""))
  assert_true(
    mine.wxml.contains("data-bunnia-message=\"accept-profile-consent\""),
  )
  assert_true(mine.wxml.contains("moontown-profile-card"))
  assert_true(!mine.wxml.contains("data-profile-user-id="))
  assert_true(!mine.wxml.contains("data-profile-role="))
  assert_true(!mine.wxml.contains("data-profile-ready="))
  assert_true(mine.wxml.contains("data-passport-ready=\"true\""))
  assert_true(mine.wxml.contains("Town passport - ready"))
  assert_true(mine.wxml.contains("moontown-profile-metric"))
  assert_true(mine.wxml.contains("Reviews"))
  assert_true(!mine.wxml.contains("Followers"))
  assert_true(mine.wxml.contains("Published"))
  assert_true(mine.wxml.contains("data-bunnia-message=\"save-profile\""))
  assert_true(mine.wxml.contains("Public Passport"))
  assert_true(!mine.wxml.contains("data-public-passport="))
  assert_true(!mine.wxml.contains("data-public-passport-items="))
  assert_true(!mine.wxml.contains("data-public-passport-item="))
  assert_true(mine.wxml.contains("data-passport-section=\"public\""))
  assert_true(mine.wxml.contains("data-passport-count=\"4\""))
  assert_true(
    !mine.wxml.contains("Public-facing identity without private work."),
  )
  assert_true(mine.wxml.contains("No published places - 1 watch - 1 review"))
  assert_true(mine.wxml.contains("data-passport-kind=\"profile\""))
  assert_true(mine.wxml.contains("data-passport-kind=\"building\""))
  assert_true(mine.wxml.contains("data-passport-kind=\"watch\""))
  assert_true(mine.wxml.contains("data-passport-kind=\"review\""))
  assert_true(!mine.wxml.contains("Profile incomplete"))
  assert_true(mine.wxml.contains("No published places"))
  assert_true(mine.wxml.contains("1 watched town link"))
  assert_true(!mine.wxml.contains("1 watched town links"))
  assert_true(mine.wxml.contains("1 review signal"))
  assert_true(!mine.wxml.contains("1 review signals"))
  assert_true(!mine.wxml.contains("data-target-ref=\"review:pending\""))
  assert_true(mine.wxml.contains("data-bunnia-message=\"tab-discover\""))
  assert_true(mine.wxml.contains("data-bunnia-message=\"tab-messages\""))
  assert_true(!mine.wxml.contains("Inventory Shelves"))
  assert_true(!mine.wxml.contains("moontown-inventory-shelf"))
  assert_true(!mine.wxml.contains("data-inventory-shelf="))
  assert_true(mine.wxml.contains("Open in Realm"))
  assert_true(!mine.wxml.contains("data-inventory-target-ref="))
  assert_true(mine.wxml.contains("moontown-credential-plaque"))
  assert_true(!mine.wxml.contains("Town Credential"))
  assert_true(
    !mine.wxml.contains(
      "Town Trust: Registration, policy, and public trust checks.",
    ),
  )
  assert_true(!mine.wxml.contains("OPC Credential"))
  assert_true(!mine.wxml.contains("OPC Hub"))
  assert_true(!mine.wxml.contains("data-feature-kind=\"credential\""))
  assert_true(!mine.wxml.contains("data-target-building-id=\"policy-hall\""))
  assert_true(mine.wxml.contains("data-bunnia-message=\"select-policy-hall\""))
  assert_true(!mine.wxml.contains("starter-map"))
  assert_true(!mine.wxml.contains("placed from starter-map"))
  assert_true(mine.wxml.contains("Inventory Refresh"))
  assert_true(mine.wxml.contains("Refresh My Stuff"))
  assert_true(
    !mine.wxml.contains(
      "Bring in owned places, books, agents, pins, and alerts.",
    ),
  )
  assert_true(!mine.wxml.contains("<text>More</text>"))
  assert_true(mine.wxml.contains("My Inventory - Waiting"))
  assert_true(!mine.wxml.contains("Own Sync"))
  assert_true(!mine.wxml.contains("data-backend-step=\"ownership\""))
  assert_true(
    !mine.wxml.contains("data-backend-endpoint=\"load-ownership-snapshot\""),
  )
  assert_true(
    !mine.wxml.contains("data-backend-path=\"/miniapp/me/ownership\""),
  )
  assert_true(!mine.wxml.contains("data-backend-method="))
  assert_true(!mine.wxml.contains("data-backend-cache="))
  assert_true(!mine.wxml.contains("data-cursor="))
  assert_true(!mine.wxml.contains("data-limit="))
  assert_true(
    mine.wxml.contains("data-bunnia-message=\"load-ownership-snapshot\""),
  )
  assert_true(mine.wxml.contains("Reviewer Tools"))
  assert_true(mine.wxml.contains("data-reviewer-tools-gate=\"closed\""))
  assert_true(mine.wxml.contains("Open Reviewer Tools"))
  assert_true(
    !mine.wxml.contains(
      "Safety checks and launch tools stay behind a deliberate reviewer entry.",
    ),
  )
  assert_true(!mine.wxml.contains("Open Reviewer Mode"))
  assert_true(!mine.wxml.contains("Ops Desk"))
  assert_true(!mine.wxml.contains("data-ops-desk=\"admin\""))
  assert_true(!mine.wxml.contains("data-backend-step=\"admin-ops\""))
  assert_true(!mine.wxml.contains("data-backend-endpoint=\"load-admin-ops\""))
  assert_true(!mine.wxml.contains("data-backend-path=\"/miniapp/admin/ops\""))
  assert_true(!mine.wxml.contains("data-target-ref=\"backend:"))
  assert_true(!mine.wxml.contains("data-target-ref=\"profile:"))
  assert_true(!mine.wxml.contains("data-target-ref=\"building:"))
  assert_true(!mine.wxml.contains("data-target-ref=\"book:"))
  assert_true(!mine.wxml.contains("data-target-ref=\"agent:"))
  assert_true(!mine.wxml.contains("data-target-ref=\"run:"))
  assert_true(!mine.wxml.contains("data-action-message="))
  assert_true(!mine.wxml.contains("Local cache"))
  assert_true(mine.wxml.contains("moontown-workbench-alert"))
  assert_true(!mine.wxml.contains("data-workbench-alert=\"profile-setup\""))
  assert_true(
    !mine.wxml.contains("data-workbench-alert=\"blocked-publication\""),
  )
  assert_true(mine.wxml.contains("data-workbench-alert=\"stale-backend\""))
  assert_true(!mine.wxml.contains("Town passport incomplete"))
  assert_true(!mine.wxml.contains("1 draft blocked from town"))
  assert_true(
    !mine.wxml.contains(
      "Owned drafts and shared places need profile setup before publishing.",
    ),
  )
  assert_true(!mine.wxml.contains("shared-private buildings"))
  assert_true(!mine.wxml.contains("profile readiness"))
  assert_true(mine.wxml.contains("1 update needs refresh"))
  assert_true(!mine.wxml.contains("backend state needs sync"))
  assert_true(!mine.wxml.contains("Sync Town"))
  assert_true(!mine.wxml.contains("Refresh Town"))
  assert_true(mine.wxml.contains("data-bunnia-message=\"load-town-snapshot\""))
  assert_true(mine.wxml.contains("Publishing Shelf"))
  assert_true(!mine.wxml.contains("My Lifecycle"))
  assert_true(mine.wxml.contains("data-publication-step=\"draft\""))
  assert_true(mine.wxml.contains("data-publication-step=\"approve\""))
  assert_true(!mine.wxml.contains("data-publication-step=\"review\""))
  assert_true(mine.wxml.contains("Private Draft"))
  assert_true(!mine.wxml.contains("Town Published"))
  assert_true(
    !mine.wxml.contains(
      "Drafts, shares, review steps, published places, and archives stay visible here.",
    ),
  )
  assert_true(mine.wxml.contains("Private Agent Lab drafted"))
  assert_true(!mine.wxml.contains("data-audit-kind="))
  assert_true(!mine.wxml.contains("data-audit-id="))
  assert_true(!mine.wxml.contains("data-actor-id="))
  assert_true(mine.wxml.contains("Created - Private draft - Draft"))
  assert_true(!mine.wxml.contains("needs setup"))
  assert_true(!mine.wxml.contains("data-ownership-stat="))
  assert_true(mine.wxml.contains("ownership.filter == 'all' ? 'active' : ''"))
  assert_true(mine.wxml.contains("data-ownership-filter-id=\"placements\""))
  assert_true(mine.wxml.contains("data-ownership-filter-id=\"drafts\""))
  assert_true(mine.wxml.contains("data-ownership-filter-id=\"books\""))
  assert_true(mine.wxml.contains("data-ownership-filter-id=\"watches\""))
  assert_true(mine.wxml.contains("data-ownership-kind=\"building\""))
  assert_true(
    !mine.wxml.contains("data-action-message=\"submit-private-building\""),
  )
  assert_true(mine.wxml.contains("Place - Private draft - Submit in My"))
  assert_true(
    !mine.wxml.contains("Draft agent creation space visible only to Ada."),
  )
  assert_true(mine.wxml.contains("data-ownership-kind=\"placement\""))
  assert_true(!mine.wxml.contains("data-action-message=\"select-policy-hall\""))
  assert_true(
    !mine.wxml.contains(
      "data-target-ref=\"placement:placement-user-a-policy-hall\"",
    ),
  )
  assert_true(mine.wxml.contains("data-ownership-kind=\"book\""))
  assert_true(mine.wxml.contains("Book - Private draft - Review in Messages"))
  assert_true(mine.wxml.contains("data-ownership-kind=\"agent\""))
  assert_true(mine.wxml.contains("Agent - Private draft - Chat in Messages"))
  assert_true(mine.wxml.contains("data-ownership-kind=\"watch\""))
  assert_true(mine.wxml.contains("Watch - Watching - Open in Realm"))
  assert_true(mine.wxml.contains("data-place-destination=\"Realm\""))
  assert_true(
    mine.wxml.contains("data-bunnia-message=\"open-place-private-agent-lab\""),
  )
  assert_true(
    mine.wxml.contains("data-bunnia-message=\"open-place-policy-hall\""),
  )
  assert_true(mine.wxml.contains("Private Agent Lab Book"))
  assert_true(mine.wxml.contains("moontown-owned-entry"))
  assert_true(mine.wxml.contains("moontown-create-drawer"))
}
