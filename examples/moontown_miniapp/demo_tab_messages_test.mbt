///|
test "moontown miniapp renders Messages attention center tab surface" {
  let projection = demo_projection()
  let messages = tab_page(projection, "messages")
  assert_true(has_no_forbidden_ordinary_copy(messages.wxml))
  assert_true(messages.wxml.contains("data-active-tab=\"messages\""))
  assert_true(messages.wxml.contains("Attention Center"))
  assert_true(
    !messages.wxml.contains("runtime channel: {{messages.channel || 'all'}}"),
  )
  assert_true(messages.wxml.contains("moontown-message-bucket"))
  assert_true(!messages.wxml.contains("moontown-message-sync"))
  assert_true(!messages.wxml.contains("data-backend-sync="))
  assert_true(!messages.wxml.contains("data-backend-endpoint="))
  assert_true(!messages.wxml.contains("data-backend-path="))
  assert_true(messages.wxml.contains("Latest Messages"))
  assert_true(messages.wxml.contains("More"))
  assert_true(messages.wxml.contains("moontown-attention-row"))
  assert_true(messages.wxml.contains("Review waiting answer"))
  assert_true(
    messages.wxml.contains(
      "Policy Hall needs a decision before memory is saved.",
    ),
  )
  assert_true(messages.wxml.contains("Agent work in progress"))
  assert_true(
    messages.wxml.contains("Policy Hall is working from Policy Hall Book."),
  )
  assert_true(messages.wxml.contains("Town signals are available"))
  assert_true(messages.wxml.contains("Mark Read"))
  assert_true(messages.wxml.contains("Review Result"))
  assert_true(!messages.wxml.contains("Ack Sync"))
  assert_true(!messages.wxml.contains("Tool Ack"))
  assert_true(
    !messages.wxml.contains(
      "{{backendStatus.load_message_center.state || 'idle'}}",
    ),
  )
  assert_true(
    messages.wxml.contains("data-bunnia-message=\"load-message-center\""),
  )
  assert_true(
    !messages.wxml.contains(
      "{{backendStatus.ack_notification.state || 'idle'}}",
    ),
  )
  assert_true(
    !messages.wxml.contains(
      "{{backendStatus.request_subscription.state || 'idle'}}",
    ),
  )
  assert_true(messages.wxml.contains("Needs Review"))
  assert_true(messages.wxml.contains("Agent Replies"))
  assert_true(messages.wxml.contains("Interactions"))
  assert_true(messages.wxml.contains("Town Notices"))
  assert_true(messages.wxml.contains("Failed Actions"))
  assert_true(!messages.wxml.contains("New Follows"))
  assert_true(!messages.wxml.contains("data-channel-id="))
  assert_true(!messages.wxml.contains("data-channel-kind="))
  assert_true(messages.wxml.contains("moontown-message-channel active"))
  assert_true(messages.wxml.contains("Deep Cultivator followed your town"))
  assert_true(messages.wxml.contains("Enterprise Club replied"))
  assert_true(messages.wxml.contains("team place"))
  assert_true(!messages.wxml.contains("shared private"))
  assert_true(!messages.wxml.contains("shared privately"))
  assert_true(messages.wxml.contains("Memory review needed"))
  assert_true(messages.wxml.contains("Agent work completed"))
  assert_true(!messages.wxml.contains("Agent run completed"))
  assert_true(!messages.wxml.contains("data-notice-kind="))
  assert_true(messages.wxml.contains("Agent Work"))
  assert_true(
    messages.wxml.contains(
      "Agent work stays attached to places, books, and review decisions.",
    ),
  )
  assert_true(messages.wxml.contains("Market placement scan"))
  assert_true(!messages.wxml.contains("data-run-id="))
  assert_true(!messages.wxml.contains("moontown-chat-drawer"))
  assert_true(!messages.wxml.contains("data-thread-id=\"thread-market-scan\""))
  assert_true(!messages.wxml.contains("data-artifact-ref="))
  assert_true(!messages.wxml.contains("data-review-required="))
  assert_true(
    messages.wxml.contains("In progress - Market Square - Market Square Ledger"),
  )
  assert_true(messages.wxml.contains("moontown-run-actions"))
  assert_true(messages.wxml.contains("data-run-action=\"open-building\""))
  assert_true(messages.wxml.contains("data-run-action=\"review-accept\""))
  assert_true(messages.wxml.contains("data-run-action=\"review-reject\""))
  assert_true(messages.wxml.contains("data-run-action=\"cancel\""))
  assert_true(messages.wxml.contains("data-run-action=\"retry\""))
  assert_true(!messages.wxml.contains("data-target-ref=\"run:"))
  assert_true(
    messages.wxml.contains("data-bunnia-message=\"select-policy-hall\""),
  )
  assert_true(
    messages.wxml.contains("data-bunnia-message=\"accept-memory-review\""),
  )
  assert_true(
    messages.wxml.contains("data-bunnia-message=\"reject-memory-review\""),
  )
  assert_true(messages.wxml.contains("data-bunnia-message=\"cancel-run\""))
  assert_true(messages.wxml.contains("data-bunnia-message=\"retry-run\""))
  assert_true(messages.wxml.contains("Stop Work"))
  assert_true(messages.wxml.contains("Try Again"))
  assert_true(messages.wxml.contains("data-blocked-reason=\"wait for status\""))
  assert_true(messages.wxml.contains("Agent Results"))
  assert_true(!messages.wxml.contains("Review Results"))
  assert_true(!messages.wxml.contains("Tool Results"))
  assert_true(!messages.wxml.contains("bunnia-tool-result-card"))
  assert_true(!messages.wxml.contains("data-tool-result-id="))
  assert_true(!messages.wxml.contains("data-tool-name="))
  assert_true(messages.wxml.contains("moontown-agent-result"))
  assert_true(messages.wxml.contains("Policy source summary"))
  assert_true(messages.wxml.contains("Open Place"))
  assert_true(messages.wxml.contains("data-bunnia-message=\"ack-tool-result\""))
  assert_true(messages.wxml.contains("Needs Review"))
  assert_true(
    messages.wxml.contains(
      "Approve useful memory or reject work before it enters town books.",
    ),
  )
  assert_true(messages.wxml.contains("Waiting for review - +1 memory"))
  assert_true(!messages.wxml.contains("pending - +1 memory"))
  assert_true(!messages.wxml.contains("data-review-id="))
  assert_true(messages.wxml.contains("data-decision=\"accept\""))
  assert_true(messages.wxml.contains("data-decision=\"reject\""))
  assert_true(!messages.wxml.contains("Moderation Desk"))
  assert_true(!messages.wxml.contains("data-moderation-case="))
  assert_true(!messages.wxml.contains("data-moderation-action="))
  assert_true(
    !messages.wxml.contains("data-bunnia-message=\"hide-public-building\""),
  )
  assert_true(
    !messages.wxml.contains("data-bunnia-message=\"takedown-public-building\""),
  )
  assert_true(
    !messages.wxml.contains("data-bunnia-message=\"appeal-moderation-case\""),
  )
  assert_true(messages.wxml.contains("Subscribe to town signals"))
  assert_true(messages.wxml.contains("data-notice-action=\"open\""))
  assert_true(messages.wxml.contains("data-notice-action=\"ack\""))
  assert_true(messages.wxml.contains("data-place-destination=\"Realm\""))
  assert_true(
    messages.wxml.contains("data-bunnia-message=\"open-place-policy-hall\""),
  )
  assert_true(!messages.wxml.contains("data-notice-id="))
  assert_true(!messages.wxml.contains("data-notice-kind="))
  assert_true(
    !messages.wxml.contains("data-target-ref=\"subscription:wechat\""),
  )
  assert_true(!messages.wxml.contains("data-action-message="))
  assert_true(
    messages.wxml.contains("data-bunnia-message=\"open-notice-review\""),
  )
  assert_true(
    messages.wxml.contains("data-bunnia-message=\"request-subscription\""),
  )
  assert_true(
    messages.wxml.contains("data-bunnia-message=\"ack-notification\""),
  )
  assert_true(
    messages.wxml.contains("data-bunnia-message=\"request-subscription\""),
  )
  assert_true(!messages.wxml.contains("data-requires-subscription="))
  assert_true(messages.wxml.contains("data-building-id=\"policy-hall\""))
  assert_true(!messages.wxml.contains("moontown-chat-drawer"))
  assert_true(!messages.wxml.contains("moontown-bottom-hud"))
}
