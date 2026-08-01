///|
fn marketplace_message_mode_bar() -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-message-mode-bar"),
      @bunnia.attr("aria-label", "Inbox sections"),
    ],
    [
      message_mode_button("chats", "Chats", "messages"),
      message_mode_button("notifications", "Notifications", "notification"),
      message_mode_button("work", "Agent work", "agent"),
      @bunnia.form("load-marketplace-channels", [
        @bunnia.node(
          kind="button",
          attrs=[
            @bunnia.attr("form-type", "submit"),
            @bunnia.class_name("moontown-chat-refresh moontown-icon-button"),
            @bunnia.attr("aria-label", "Refresh conversations"),
          ],
          children=[town_icon("refresh")],
        ),
      ]),
    ],
  )
}

///|
fn message_mode_button(
  id : String,
  label : String,
  icon : String,
) -> @bunnia.Node {
  @bunnia.node(
    kind="button",
    attrs=[
      @bunnia.class_name(
        "moontown-message-mode {{messages.mode == '\{id}' ? 'active' : ''}}",
      ),
      @bunnia.attr("aria-label", "Open \{label}"),
    ],
    events=[@bunnia.tap("message-mode-\{id}")],
    children=town_icon_label(icon, label),
  )
}

///|
fn marketplace_chat_directory(projection : MiniTownProjection) -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-channel-directory"),
      @bunnia.attr("wx:if", "{{messages.mode == 'chats'}}"),
    ],
    [
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-channel-kind-filters")],
        [
          channel_kind_button("all", "All", "inbox"),
          channel_kind_button("direct", "DMs", "direct"),
          channel_kind_button("team", "Teams", "team"),
          channel_kind_button("building", "Buildings", "building"),
          channel_kind_button("agent", "Agents", "agent"),
        ],
      ),
      marketplace_create_channel_form(),
      marketplace_channel_state_rows(),
      @bunnia.view_with_attrs(
        [
          @bunnia.class_name("moontown-conversation-list remote"),
          @bunnia.attr("wx:if", "{{channels.remote}}"),
        ],
        [dynamic_channel_rows()],
      ),
      @bunnia.view_with_attrs(
        [
          @bunnia.class_name("moontown-conversation-list fixture"),
          @bunnia.attr("wx:if", "{{!channels.remote}}"),
        ],
        [
          @bunnia.windowed_list(
            projection.conversation_channels,
            total_count=projection.conversation_channels.length(),
            render=marketplace_channel_row,
          ),
        ],
      ),
      marketplace_open_conversation(),
    ],
  )
}

///|
fn marketplace_create_channel_form() -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-create-channel")], [
    @bunnia.view_with_attrs(
      [@bunnia.class_name("moontown-create-channel-heading")],
      [
        town_icon("team"),
        @bunnia.view_with_attrs(
          [@bunnia.class_name("moontown-market-state-copy")],
          [
            @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
              @bunnia.text("Start a private room"),
            ]),
            @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
              @bunnia.text(
                "Only the named Town principals can join. The room starts as private and internal.",
              ),
            ]),
          ],
        ),
      ],
    ),
    @bunnia.form("create-marketplace-channel", [
      @bunnia.node(
        kind="input",
        attrs=[
          @bunnia.attr("name", "title"),
          @bunnia.attr("value", "{{channelDraft.title}}"),
          @bunnia.attr("placeholder", "Room title"),
          @bunnia.attr("aria-label", "Private room title"),
          @bunnia.data("bunnia-input-path", "channelDraft.title"),
        ],
        events=[@bunnia.event("input", "edit-channel-title")],
        children=[],
      ),
      @bunnia.node(
        kind="input",
        attrs=[
          @bunnia.attr("name", "memberPrincipalIds"),
          @bunnia.attr("value", "{{channelDraft.memberPrincipalIds}}"),
          @bunnia.attr("placeholder", "Principal IDs, separated by commas"),
          @bunnia.attr("aria-label", "Room member principal IDs"),
          @bunnia.data("bunnia-input-path", "channelDraft.memberPrincipalIds"),
        ],
        events=[@bunnia.event("input", "edit-channel-members")],
        children=[],
      ),
      marketplace_submit_button("Create room", "messages", emphasis="primary"),
    ]),
    backend_feedback(
      "channel-create", "Creating the private room...", "Room created. Refresh conversations to open it.",
      "Room not created. Check the title and participant IDs.",
    ),
  ])
}

///|
fn channel_kind_button(
  id : String,
  label : String,
  icon : String,
) -> @bunnia.Node {
  @bunnia.node(
    kind="button",
    attrs=[
      @bunnia.class_name(
        "moontown-channel-kind {{messages.channelKind == '\{id}' ? 'active' : ''}}",
      ),
      @bunnia.attr("aria-label", "Show \{label} channels"),
    ],
    events=[@bunnia.tap("channel-kind-\{id}")],
    children=town_icon_label(icon, label),
  )
}

///|
fn marketplace_channel_state_rows() -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [@bunnia.class_name("moontown-channel-state-stack")],
    [
      marketplace_state(
        "loading", "Loading conversations", "Only channels you are allowed to join will appear.",
        "{{ui.feedback == 'channels' && requestState.state == 'loading'}}",
      ),
      @bunnia.view_with_attrs(
        [
          @bunnia.class_name("moontown-market-state error"),
          @bunnia.attr("role", "alert"),
          @bunnia.attr(
            "wx:if", "{{ui.feedback == 'channels' && requestState.state == 'failed'}}",
          ),
        ],
        [
          town_icon("warning"),
          @bunnia.view_with_attrs(
            [@bunnia.class_name("moontown-market-state-copy")],
            [
              @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
                @bunnia.text("Conversations could not refresh"),
              ]),
              @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
                @bunnia.text(
                  "Your drafts are preserved. Try again when the connection returns.",
                ),
              ]),
            ],
          ),
          @bunnia.form("load-marketplace-channels", [
            marketplace_submit_button("Try again", "retry", emphasis="primary"),
          ]),
        ],
      ),
      @bunnia.view_with_attrs(
        [
          @bunnia.class_name("moontown-market-state empty"),
          @bunnia.attr(
            "wx:if", "{{channels.remote && requestState.state == 'ready' && channels.items.length == 0}}",
          ),
        ],
        [
          town_icon("messages"),
          @bunnia.view_with_attrs(
            [@bunnia.class_name("moontown-market-state-copy")],
            [
              @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
                @bunnia.text("No conversation here yet"),
              ]),
              @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
                @bunnia.text(
                  "Message a publisher from Discover or ask to join a building room.",
                ),
              ]),
            ],
          ),
        ],
      ),
    ],
  )
}

///|
fn marketplace_channel_row(
  channel : MiniTownConversationChannel,
) -> @bunnia.Node {
  let unread_class = if channel.unread_count > 0 { "unread" } else { "read" }
  @bunnia.keyed(
    "channel-\{channel.id}",
    @bunnia.form("load-channel-messages", [
      marketplace_hidden_input("channelId", channel.id),
      @bunnia.node(
        kind="button",
        attrs=[
          @bunnia.attr("form-type", "submit"),
          @bunnia.class_name("moontown-conversation-row \{unread_class}"),
          @bunnia.attr(
            "wx:if",
            "{{messages.channelKind == 'all' || messages.channelKind == '\{channel.kind}'}}",
          ),
          @bunnia.data("channel-kind", channel.kind),
          @bunnia.attr("aria-label", "Open \{channel.title} conversation"),
        ],
        children=[
          @bunnia.view_with_attrs(
            [@bunnia.class_name("moontown-channel-icon kind-\{channel.kind}")],
            [town_icon(channel.kind)],
          ),
          @bunnia.view_with_attrs([@bunnia.class_name("moontown-chat-copy")], [
            @bunnia.view_with_attrs(
              [@bunnia.class_name("moontown-chat-title-row")],
              [
                @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
                  @bunnia.text(channel.title),
                ]),
                if channel.unread_count > 0 {
                  @bunnia.view_with_attrs(
                    [
                      @bunnia.class_name("moontown-channel-unread-count"),
                      @bunnia.attr(
                        "aria-label",
                        "\{channel.unread_count} unread",
                      ),
                    ],
                    [@bunnia.text("\{channel.unread_count}")],
                  )
                } else {
                  @bunnia.view([])
                },
              ],
            ),
            @bunnia.view_with_attrs(
              [@bunnia.class_name("moontown-chat-preview")],
              [@bunnia.text(channel.preview)],
            ),
            @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
              @bunnia.text(channel.context_label),
            ]),
          ]),
          town_icon("open"),
        ],
      ),
    ]),
  )
}

///|
fn dynamic_channel_rows() -> @bunnia.Node {
  @bunnia.node(
    kind="form",
    attrs=[
      @bunnia.attr("wx:for", "{{channels.items}}"),
      @bunnia.attr("wx:key", "id"),
      @bunnia.attr(
        "wx:if", "{{messages.channelKind == 'all' || messages.channelKind == item.kind}}",
      ),
    ],
    events=[@bunnia.event("submit", "load-channel-messages")],
    children=[
      marketplace_hidden_input("channelId", "{{item.id}}"),
      @bunnia.node(
        kind="button",
        attrs=[
          @bunnia.attr("form-type", "submit"),
          @bunnia.class_name(
            "moontown-conversation-row {{item.unreadCount > 0 ? 'unread' : 'read'}}",
          ),
          @bunnia.attr("aria-label", "Open conversation"),
        ],
        children=[
          @bunnia.view_with_attrs(
            [@bunnia.class_name("moontown-channel-icon kind-{{item.kind}}")],
            [
              @bunnia.view_with_attrs(
                [@bunnia.class_name("moontown-line-icon icon-{{item.kind}}")],
                [],
              ),
            ],
          ),
          @bunnia.view_with_attrs([@bunnia.class_name("moontown-chat-copy")], [
            @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
              @bunnia.text("{{item.title}}"),
            ]),
            @bunnia.view_with_attrs(
              [@bunnia.class_name("moontown-chat-preview")],
              [@bunnia.text("{{item.preview}}")],
            ),
            @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
              @bunnia.text("{{item.contextLabel}}"),
            ]),
          ]),
          @bunnia.view_with_attrs(
            [
              @bunnia.class_name("moontown-channel-unread-count"),
              @bunnia.attr("wx:if", "{{item.unreadCount > 0}}"),
            ],
            [@bunnia.text("{{item.unreadCount}}")],
          ),
        ],
      ),
    ],
  )
}

///|
fn marketplace_open_conversation() -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-open-conversation"),
      @bunnia.attr("wx:if", "{{messages.channelOpen}}"),
      @bunnia.attr("aria-label", "Open conversation"),
    ],
    [
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-open-conversation-head")],
        [
          @bunnia.node(
            kind="button",
            attrs=[
              @bunnia.class_name("moontown-icon-button"),
              @bunnia.attr("bindtap", "onMarketplaceChannelClose"),
              @bunnia.attr("aria-label", "Back to conversations"),
            ],
            children=[town_icon("back")],
          ),
          @bunnia.view_with_attrs(
            [@bunnia.class_name("moontown-market-details-title")],
            [
              @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
                @bunnia.text("{{channels.selected.title}}"),
              ]),
              @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
                @bunnia.text("{{channels.selected.contextLabel}}"),
              ]),
            ],
          ),
          @bunnia.view_with_attrs(
            [@bunnia.class_name("moontown-channel-scope")],
            [town_icon("private"), @bunnia.text("Participants only")],
          ),
        ],
      ),
      @bunnia.view_with_attrs(
        [
          @bunnia.class_name("moontown-channel-message-list"),
          @bunnia.attr("aria-live", "polite"),
        ],
        [
          @bunnia.view_with_attrs(
            [
              @bunnia.attr("wx:for", "{{channels.messages}}"),
              @bunnia.attr("wx:key", "id"),
              @bunnia.class_name("moontown-channel-message role-{{item.role}}"),
            ],
            [
              @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
                @bunnia.text("{{item.sender}}"),
              ]),
              @bunnia.text("{{item.body}}"),
            ],
          ),
        ],
      ),
      @bunnia.form("send-channel-message", [
        marketplace_hidden_input("channelId", "{{channels.selected.id}}"),
        @bunnia.node(
          kind="input",
          attrs=[
            @bunnia.attr("name", "message"),
            @bunnia.attr("value", "{{channelMessageDraft.body}}"),
            @bunnia.attr("placeholder", "Message participants"),
            @bunnia.attr("aria-label", "Message participants"),
            @bunnia.data("bunnia-input-path", "channelMessageDraft.body"),
          ],
          events=[@bunnia.event("input", "edit-channel-message")],
          children=[],
        ),
        marketplace_submit_button("Send", "send", emphasis="primary"),
      ]),
      backend_feedback(
        "channel-message", "Sending message...", "Message delivered to the named participants.",
        "Message not sent. Your draft is preserved.",
      ),
    ],
  )
}

///|
fn marketplace_notification_center(
  projection : MiniTownProjection,
) -> @bunnia.Node {
  let notices = filtered_notifications(projection)
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-notification-center"),
      @bunnia.attr("wx:if", "{{messages.mode == 'notifications'}}"),
    ],
    [
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-notification-toolbar")],
        [
          notification_filter_button("all", "All"),
          notification_filter_button("unread", "Unread"),
          @bunnia.form("load-marketplace-notifications", [
            marketplace_submit_button("Refresh notifications", "refresh"),
          ]),
          @bunnia.form("update-marketplace-subscription", [
            marketplace_hidden_input("subscriptionId", "town-important-signals"),
            marketplace_hidden_input("topicKind", "town"),
            marketplace_hidden_input("topicId", "important-signals"),
            marketplace_hidden_input("enabled", "true"),
            marketplace_submit_button("Subscribe", "notification"),
          ]),
        ],
      ),
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-notification-explainer")],
        [
          town_icon("notification"),
          @bunnia.view_with_attrs(
            [@bunnia.class_name("moontown-market-state-copy")],
            [
              @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
                @bunnia.text("Important Town signals"),
              ]),
              @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
                @bunnia.text(
                  "Replies, invitations, review decisions, and followed-building updates. Ads never become notifications without a subscription.",
                ),
              ]),
            ],
          ),
        ],
      ),
      @bunnia.view_with_attrs(
        [
          @bunnia.class_name("moontown-notice-list remote"),
          @bunnia.attr("wx:if", "{{notifications.remote}}"),
        ],
        [dynamic_notification_rows()],
      ),
      @bunnia.view_with_attrs(
        [
          @bunnia.class_name("moontown-notice-list fixture"),
          @bunnia.attr("wx:if", "{{!notifications.remote}}"),
        ],
        [
          @bunnia.windowed_list(notices, total_count=notices.length(), render=notice => {
            notification_entry(projection, notice)
          }),
        ],
      ),
      backend_feedback(
        "notifications", "Updating notification preference...", "Notification preference updated.",
        "Preference was not changed. Try again.",
      ),
    ],
  )
}

///|
fn dynamic_notification_rows() -> @bunnia.Node {
  @bunnia.node(
    kind="form",
    attrs=[
      @bunnia.attr("wx:for", "{{notifications.items}}"),
      @bunnia.attr("wx:key", "id"),
      @bunnia.attr(
        "wx:if", "{{messages.channel == 'all' || (messages.channel == 'unread' && item.unread)}}",
      ),
      @bunnia.class_name(
        "moontown-notice-entry moontown-chat-row {{item.unread ? 'unread' : 'read'}}",
      ),
    ],
    events=[@bunnia.event("submit", "read-marketplace-notification")],
    children=[
      marketplace_hidden_input("notificationId", "{{item.id}}"),
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-chat-avatar kind-{{item.kind}}")],
        [
          @bunnia.view_with_attrs(
            [@bunnia.class_name("moontown-line-icon icon-notification")],
            [],
          ),
        ],
      ),
      @bunnia.view_with_attrs([@bunnia.class_name("moontown-chat-copy")], [
        @bunnia.view_with_attrs(
          [@bunnia.class_name("moontown-chat-title-row")],
          [
            @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
              @bunnia.text("{{item.title}}"),
            ]),
            @bunnia.view_with_attrs(
              [
                @bunnia.class_name("moontown-chat-unread-dot"),
                @bunnia.attr("wx:if", "{{item.unread}}"),
              ],
              [],
            ),
          ],
        ),
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-chat-preview")], [
          @bunnia.text("{{item.body}}"),
        ]),
        @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
          @bunnia.text("{{item.topicLabel}}"),
        ]),
      ]),
      @bunnia.node(
        kind="button",
        attrs=[
          @bunnia.attr("wx:if", "{{item.unread}}"),
          @bunnia.attr("form-type", "submit"),
          @bunnia.class_name("moontown-market-action"),
          @bunnia.attr("aria-label", "Mark notification read"),
        ],
        children=town_icon_label("read", "Mark read"),
      ),
    ],
  )
}

///|
fn notification_filter_button(id : String, label : String) -> @bunnia.Node {
  @bunnia.node(
    kind="button",
    attrs=[
      @bunnia.class_name(
        "moontown-message-channel {{messages.channel == '\{id}' ? 'active' : ''}}",
      ),
      @bunnia.attr("aria-label", "Show \{label} notifications"),
    ],
    events=[@bunnia.tap("notification-channel-\{id}")],
    children=town_icon_label(
      if id == "unread" {
        "unread"
      } else {
        "inbox"
      },
      label,
    ),
  )
}

///|
fn marketplace_work_channels() -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-work-channel-bar"),
      @bunnia.attr("wx:if", "{{messages.mode == 'work'}}"),
    ],
    [
      simple_message_channel("requests", "Requests"),
      simple_message_channel("supervisor", "Supervisor"),
      simple_message_channel("tasks", "Tasks"),
      simple_message_channel("reviews", "Reviews"),
      simple_message_channel("receipts", "Receipts"),
    ],
  )
}
