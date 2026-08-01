///|
test "moontown miniapp renders the supervisor control inbox" {
  let messages = tab_page(demo_projection(), "messages")
  assert_true(has_no_forbidden_ordinary_copy(messages.wxml))
  assert_true(messages.wxml.contains("data-active-tab=\"messages\""))
  assert_true(messages.wxml.contains("<text>Inbox</text>"))
  assert_true(messages.wxml.contains("Updates and requests from your town"))
  assert_true(messages.wxml.contains("moontown-message-notices"))
  assert_true(messages.wxml.contains("moontown-notice-list"))
  assert_true(messages.wxml.contains("moontown-message-inbox"))
  assert_true(messages.wxml.contains("moontown-message-lead"))
  assert_true(messages.wxml.contains("moontown-message-review"))
  assert_true(messages.wxml.contains("moontown-message-work"))
  assert_true(messages.wxml.contains("Needs Review"))
  assert_true(messages.wxml.contains("Agent Work"))

  assert_true(messages.wxml.contains("<text>All</text>"))
  assert_true(messages.wxml.contains("<text>Supervisor</text>"))
  assert_true(messages.wxml.contains("<text>Tasks</text>"))
  assert_true(messages.wxml.contains("<text>Reviews</text>"))
  assert_true(messages.wxml.contains("<text>Receipts</text>"))
  assert_true(!messages.wxml.contains("<text>Activity</text>"))
  assert_true(!messages.wxml.contains("<text>Replies</text>"))
  assert_true(!messages.wxml.contains("<text>Notices</text>"))
  assert_true(
    messages.wxml.contains("messages.channel == 'all' ? 'active' : ''"),
  )
  assert_true(
    messages.wxml.contains("messages.channel == 'tasks' ? 'active' : ''"),
  )
  assert_true(messages.wxml.contains("aria-label=\"Refresh chats\""))
  assert_true(
    messages.wxml.contains("data-bunnia-message=\"load-message-center\""),
  )

  assert_true(messages.wxml.contains("moontown-chat-row unread"))
  assert_true(messages.wxml.contains("moontown-chat-row read"))
  assert_true(messages.wxml.contains("data-chat-unread=\"true\""))
  assert_true(messages.wxml.contains("data-chat-unread=\"false\""))
  assert_true(messages.wxml.contains("moontown-chat-avatar kind-agent-run"))
  assert_true(messages.wxml.contains("moontown-chat-preview"))
  assert_true(messages.wxml.contains("moontown-chat-unread-dot"))
  assert_true(messages.wxml.contains("Memory review needed"))
  assert_true(messages.wxml.contains("Draft ready to publish"))
  assert_true(messages.wxml.contains("Agent work completed"))
  assert_true(messages.wxml.contains("Enterprise Club replied"))
  assert_true(messages.wxml.contains("data-notice-action=\"open\""))
  assert_true(
    messages.wxml.contains("data-bunnia-message=\"open-place-policy-hall\""),
  )
  assert_true(
    messages.wxml.contains("data-bunnia-route=\"pages/moontown/index\""),
  )
  assert_true(
    messages.wxml.contains("data-bunnia-message=\"request-subscription\""),
  )
  assert_true(!messages.wxml.contains("data-backend-"))
  assert_true(!messages.wxml.contains("data-notice-id="))
  assert_true(!messages.wxml.contains("data-notice-kind="))
  assert_true(messages.wxml.contains("data-run-id="))
  assert_true(!messages.wxml.contains("data-review-id="))
  assert_true(!messages.wxml.contains("moontown-chat-drawer"))
  assert_true(!messages.wxml.contains("moontown-bottom-hud"))
}

///|
test "moontown Messages exposes recovery controls when work fails" {
  let projection = reject_review(demo_projection(), "review-policy-memory")
  let messages = tab_page(projection, "messages")
  assert_true(messages.wxml.contains("<text>Inbox</text>"))
  assert_true(messages.wxml.contains("moontown-message-notices"))
  assert_true(messages.wxml.contains("data-attention-id=\"failed-work\""))
  assert_true(messages.wxml.contains("Work needs attention"))
  assert_true(messages.wxml.contains("data-run-action=\"retry\""))
  assert_true(messages.wxml.contains("<text>Try Again</text>"))
}
