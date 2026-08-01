///|
test "moontown miniapp renders Discover market board tab surface" {
  let projection = demo_projection()
  let discover = tab_page(projection, "discover")
  assert_true(has_no_forbidden_ordinary_copy(discover.wxml))
  assert_true(discover.wxml.contains("moontown-map-fullscreen"))
  assert_true(discover.wxml.contains("moontown-page-surface"))
  assert_true(discover.wxml.contains("data-active-tab=\"discover\""))
  assert_true(discover.wxml.contains("moontown-page-grid single"))
  assert_true(discover.wxml.contains("Market board - find something useful"))
  assert_true(discover.wxml.contains("moontown-marketplace-toolbar"))
  assert_true(discover.wxml.contains("moontown-market-action"))
  assert_true(discover.wxml.contains("aria-label=\"Search\""))
  assert_true(
    discover.wxml.contains("aria-label=\"Preview a safe public listing\""),
  )
  assert_true(discover.wxml.contains("moontown-discovery-primary-filters"))
  assert_true(discover.wxml.contains("<text>All</text>"))
  assert_true(discover.wxml.contains("<text>Agents</text>"))
  assert_true(discover.wxml.contains("<text>Buildings</text>"))
  assert_true(
    discover.wxml.contains("data-bunnia-message=\"marketplace-search\""),
  )
  assert_true(
    discover.wxml.contains(
      "data-bunnia-message=\"load-marketplace-recommendations\"",
    ),
  )
  assert_true(
    discover.wxml.contains("data-bunnia-message=\"load-marketplace-feed\""),
  )
  assert_true(discover.wxml.contains("Recommended for you"))
  assert_true(discover.wxml.contains("Organic results"))
  assert_true(discover.wxml.contains("Sponsored"))
  assert_true(discover.wxml.contains("Paid placements are labeled"))
  assert_true(discover.wxml.contains("Policy Guide"))
  assert_true(discover.wxml.contains("Robotics Workshop"))
  assert_true(discover.wxml.contains("Deep Cultivator"))
  assert_true(discover.wxml.contains("Safe share preview"))
  assert_true(discover.wxml.contains("Withheld by policy"))
  assert_true(discover.wxml.contains("moontown-market-publisher"))
  assert_true(
    discover.wxml.contains("data-bunnia-message=\"publish-agent-listing\""),
  )
  assert_true(
    discover.wxml.contains("data-bunnia-message=\"publish-building-listing\""),
  )
  assert_true(
    discover.wxml.contains(
      "data-bunnia-message=\"load-marketplace-review-queue\"",
    ),
  )
  assert_true(discover.wxml.contains("moontown-review-queue"))
  assert_true(!discover.wxml.contains("moontown-right-hud"))
}
