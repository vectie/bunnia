///|
test "moontown miniapp renders a prioritized Messages inbox" {
  let projection = demo_projection()
  let messages = tab_page(projection, "messages")
  assert_true(has_no_forbidden_ordinary_copy(messages.wxml))
  assert_true(messages.wxml.contains("data-active-tab=\"messages\""))
  assert_true(messages.wxml.contains("moontown-messages-layout"))
  assert_true(messages.wxml.contains("moontown-message-inbox"))
  assert_true(!messages.wxml.contains("Message Inbox"))
  assert_true(!messages.wxml.contains("1 decisions, 0 failed items"))
  assert_true(messages.wxml.contains("moontown-message-lead"))
  assert_true(messages.wxml.contains("data-attention-id=\"review\""))
  assert_true(messages.wxml.contains("Review waiting answer"))
  assert_true(
    messages.wxml.contains(
      "Policy Hall needs a decision before memory is saved.",
    ),
  )
  assert_true(!messages.wxml.contains("moontown-attention-row"))
  assert_true(!messages.wxml.contains("Agent work in progress"))
  assert_true(!messages.wxml.contains("Town signals are available"))
  assert_true(!messages.wxml.contains("moontown-message-bucket"))

  assert_true(messages.wxml.contains("Needs Review"))
  assert_true(messages.wxml.contains("moontown-message-review"))
  assert_true(
    !messages.wxml.contains(
      "Approve useful memory or reject work before it enters town books.",
    ),
  )
  assert_true(messages.wxml.contains("Waiting for review - +1 memory"))
  assert_true(!messages.wxml.contains("pending - +1 memory"))
  assert_true(messages.wxml.contains("data-decision=\"accept\""))
  assert_true(messages.wxml.contains("data-decision=\"reject\""))

  assert_true(messages.wxml.contains("Agent Work"))
  assert_true(messages.wxml.contains("moontown-message-work"))
  assert_true(
    !messages.wxml.contains(
      "Active work, failed work, and completed results by place.",
    ),
  )
  assert_true(messages.wxml.contains("Market placement scan"))
  assert_true(
    messages.wxml.contains("In progress - Market Square - Market Square Ledger"),
  )
  assert_true(messages.wxml.contains("data-run-action=\"open-building\""))
  assert_true(messages.wxml.contains("data-run-action=\"review-accept\""))
  assert_true(messages.wxml.contains("data-run-action=\"review-reject\""))
  assert_true(messages.wxml.contains("data-run-action=\"cancel\""))
  assert_true(!messages.wxml.contains("data-run-action=\"retry\""))
  assert_true(messages.wxml.contains("Stop Work"))
  assert_true(!messages.wxml.contains("Try Again"))
  assert_true(!messages.wxml.contains("data-blocked-reason="))
  assert_true(!messages.wxml.contains("data-allowed="))
  assert_true(messages.wxml.contains("Completed Results"))
  assert_true(!messages.wxml.contains("Agent Results"))
  assert_true(messages.wxml.contains("moontown-agent-results"))
  assert_true(messages.wxml.contains("moontown-agent-result"))
  assert_true(messages.wxml.contains("Policy source summary"))
  assert_true(messages.wxml.contains("Open Place"))
  assert_true(messages.wxml.contains("Review Result"))
  assert_true(messages.wxml.contains("data-bunnia-message=\"ack-tool-result\""))

  assert_true(messages.wxml.contains("Latest Messages"))
  assert_true(messages.wxml.contains("moontown-message-notices"))
  assert_true(messages.wxml.contains("moontown-notice-list"))
  assert_true(messages.wxml.contains("Refresh Inbox"))
  assert_true(
    messages.wxml.contains("data-bunnia-message=\"load-message-center\""),
  )
  assert_true(messages.wxml.contains("Agent Replies"))
  assert_true(messages.wxml.contains("Interactions"))
  assert_true(messages.wxml.contains("Town Notices"))
  assert_true(!messages.wxml.contains("Failed Actions"))
  assert_true(!messages.wxml.contains("New Follows"))
  assert_true(messages.wxml.contains("moontown-message-channel active"))
  assert_true(messages.wxml.contains("Deep Cultivator followed your town"))
  assert_true(messages.wxml.contains("Enterprise Club replied"))
  assert_true(messages.wxml.contains("Memory review needed"))
  assert_true(messages.wxml.contains("Agent work completed"))
  assert_true(messages.wxml.contains("Mark Read"))
  assert_true(messages.wxml.contains("data-notice-action=\"open\""))
  assert_true(messages.wxml.contains("data-notice-action=\"ack\""))
  assert_true(
    messages.wxml.contains("data-bunnia-message=\"open-notice-review\""),
  )
  assert_true(
    messages.wxml.contains("data-bunnia-message=\"request-subscription\""),
  )
  assert_true(
    messages.wxml.contains("data-bunnia-message=\"ack-notification\""),
  )

  assert_true(messages.wxml.contains("moontown-primary-action"))
  assert_true(messages.wxml.contains("moontown-secondary-action"))
  assert_true(messages.wxml.contains("moontown-danger-action"))
  assert_true(!messages.wxml.contains("runtime channel:"))
  assert_true(!messages.wxml.contains("data-backend-"))
  assert_true(!messages.wxml.contains("data-channel-id="))
  assert_true(!messages.wxml.contains("data-channel-kind="))
  assert_true(!messages.wxml.contains("data-notice-id="))
  assert_true(!messages.wxml.contains("data-notice-kind="))
  assert_true(!messages.wxml.contains("data-run-id="))
  assert_true(!messages.wxml.contains("data-review-id="))
  assert_true(!messages.wxml.contains("data-tool-result-id="))
  assert_true(!messages.wxml.contains("data-target-ref="))
  assert_true(!messages.wxml.contains("data-action-message="))
  assert_true(!messages.wxml.contains("data-requires-subscription="))
  assert_true(!messages.wxml.contains("moontown-chat-drawer"))
  assert_true(!messages.wxml.contains("moontown-bottom-hud"))
}

///|
test "moontown Messages promotes failed work and exposes recovery only when available" {
  let projection = reject_review(demo_projection(), "review-policy-memory")
  let messages = tab_page(projection, "messages")
  assert_true(messages.wxml.contains("data-attention-id=\"failed-work\""))
  assert_true(messages.wxml.contains("Work needs attention"))
  assert_true(messages.wxml.contains("data-run-action=\"retry\""))
  assert_true(messages.wxml.contains("data-bunnia-message=\"retry-run\""))
  assert_true(messages.wxml.contains("Try Again"))
  assert_true(!messages.wxml.contains("data-blocked-reason="))
}
