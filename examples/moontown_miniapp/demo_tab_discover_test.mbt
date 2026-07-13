///|
test "moontown miniapp renders Discover market board tab surface" {
  let projection = demo_projection()
  let discover = tab_page(projection, "discover")
  assert_true(has_no_forbidden_ordinary_copy(discover.wxml))
  assert_true(discover.wxml.contains("moontown-map-fullscreen"))
  assert_true(discover.wxml.contains("moontown-page-surface"))
  assert_true(discover.wxml.contains("data-active-tab=\"discover\""))
  assert_true(!discover.wxml.contains("Market Board"))
  assert_true(discover.wxml.contains("Search the public town"))
  assert_true(discover.wxml.contains("moontown-page-grid single"))
  assert_true(discover.wxml.contains("moontown-discovery-search"))
  assert_true(discover.wxml.contains("moontown-primary-action"))
  assert_true(discover.wxml.contains("matches"))
  assert_true(!discover.wxml.contains("All in the public town market."))
  assert_true(!discover.wxml.contains("Browse Town"))
  assert_true(
    !discover.wxml.contains("runtime filter: {{discover.filter || 'all'}}"),
  )
  assert_true(discover.wxml.contains("moontown-discover-entry"))
  assert_true(discover.wxml.contains("People"))
  assert_true(discover.wxml.contains("Circles"))
  assert_true(discover.wxml.contains("Market"))
  assert_true(!discover.wxml.contains("moontown-discovery-chip"))
  assert_true(discover.wxml.contains("data-discovery-action=\"open\""))
  assert_true(discover.wxml.contains("Deep Cultivator"))
  assert_true(discover.wxml.contains("AI Exploration Camp"))
  assert_true(discover.wxml.contains("Agent Publishing Kit"))
  assert_true(discover.wxml.contains("data-discovery-kind=\"product\""))
  assert_true(
    discover.wxml.contains("data-target-ref=\"product:agent-publishing-kit\""),
  )
  assert_true(discover.wxml.contains("Open Product"))
  assert_true(discover.wxml.contains("data-discovery-action=\"open\""))
  assert_true(discover.wxml.contains("data-bunnia-message=\"discover-action\""))
  assert_true(discover.wxml.contains("Answer Demand"))
  assert_true(discover.wxml.contains("data-discovery-action=\"request\""))
  assert_true(discover.wxml.contains("data-bunnia-message=\"discover-action\""))
  assert_true(discover.wxml.contains("Team Studio Session"))
  assert_true(discover.wxml.contains("data-discovery-kind=\"event\""))
  assert_true(discover.wxml.contains("Join Event"))
  assert_true(discover.wxml.contains("data-discovery-action=\"join\""))
  assert_true(discover.wxml.contains("data-bunnia-message=\"discover-action\""))
  assert_true(discover.wxml.contains("Read Note"))
  assert_true(discover.wxml.contains("data-discovery-action=\"read\""))
  assert_true(discover.wxml.contains("data-bunnia-message=\"discover-action\""))
  assert_true(discover.wxml.contains("discover-search"))
  assert_true(
    discover.wxml.contains("discover.filter == 'all' ? 'active' : ''"),
  )
  assert_true(
    discover.wxml.contains(
      "discover.filter == 'all' || discover.filter == 'building' || discover.filter == 'placeable'",
    ),
  )
  assert_true(discover.wxml.contains("data-filter-id=\"user\""))
  assert_true(discover.wxml.contains("data-filter-id=\"circle\""))
  assert_true(discover.wxml.contains("data-filter-id=\"product\""))
  assert_true(discover.wxml.contains("data-filter-id=\"demand\""))
  assert_true(discover.wxml.contains("data-filter-id=\"event\""))
  assert_true(discover.wxml.contains("data-filter-id=\"post\""))
  assert_true(discover.wxml.contains("data-filter-id=\"placeable\""))
  assert_true(!discover.wxml.contains("data-filter-kind="))
  assert_true(discover.wxml.contains("moontown-discovery-badges"))
  assert_true(!discover.wxml.contains("moontown-discovery-badge kind-access"))
  assert_true(
    discover.wxml.contains("moontown-discovery-badge kind-eligibility"),
  )
  assert_true(discover.wxml.contains("Can open"))
  assert_true(discover.wxml.contains("Published Agent Lab"))
  assert_true(discover.wxml.contains("data-discovery-kind=\"building\""))
  assert_true(discover.wxml.contains("Open Place"))
  assert_true(
    discover.wxml.contains(
      "data-bunnia-message=\"open-place-published-agent-lab\"",
    ),
  )
  assert_true(discover.wxml.contains("data-place-destination=\"Realm\""))
  assert_true(!discover.wxml.contains("Place On Map"))
  assert_true(!discover.wxml.contains("moontown-secondary-action"))
  assert_true(
    discover.wxml.contains("data-building-id=\"published-agent-lab\""),
  )
  assert_true(discover.wxml.contains("Can place"))
  assert_true(!discover.wxml.contains("data-placement-state="))
  assert_true(!discover.wxml.contains("data-placement-layer="))
  assert_true(!discover.wxml.contains("data-placement-source="))
  assert_true(!discover.wxml.contains("data-placement-x="))
  assert_true(!discover.wxml.contains("data-placement-y="))
  assert_true(!discover.wxml.contains("Watch"))
  assert_true(
    !discover.wxml.contains("data-bunnia-message=\"request-subscription\""),
  )
  assert_true(!discover.wxml.contains("data-notice-kind=\"subscription\""))
  assert_true(!discover.wxml.contains("data-notice-id=\"notice-subscribe\""))
  assert_true(discover.wxml.contains("data-discovery-kind=\"agent\""))
  assert_true(discover.wxml.contains("data-discovery-kind=\"book\""))
  assert_true(
    discover.wxml.contains("data-target-ref=\"agent:agent-policy-guide\""),
  )
  assert_true(
    discover.wxml.contains("data-target-ref=\"book:book-published-agent-lab\""),
  )
  assert_true(discover.wxml.contains("Agent Lab Field Note"))
  assert_true(!discover.wxml.contains("Map Districts"))
  assert_true(!discover.wxml.contains("moontown-right-hud"))

  let empty_discover_projection = search_discovery(
    projection, "no public market result matches this",
  )
  let empty_discover = tab_page(empty_discover_projection, "discover")
  assert_true(has_no_forbidden_ordinary_copy(empty_discover.wxml))
  assert_true(empty_discover.wxml.contains("moontown-discover-empty"))
  assert_true(empty_discover.wxml.contains("No public match"))
  assert_true(empty_discover.wxml.contains("Change the search or filter."))
}
