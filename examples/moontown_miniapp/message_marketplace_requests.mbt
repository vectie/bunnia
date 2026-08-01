///| One queue answers a single question: which published-agent requests need

///|
/// my decision, and what happened to the requests I made?
fn marketplace_action_request_panel() -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("mt-panel moontown-marketplace-request-board"),
      @bunnia.attr(
        "wx:if", "{{messages.mode == 'work' && messages.channel == 'requests'}}",
      ),
    ],
    [
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-request-board-head")],
        [
          @bunnia.view_with_attrs(
            [@bunnia.class_name("moontown-request-board-title")],
            [
              town_icon("agent"),
              @bunnia.view_with_attrs(
                [@bunnia.class_name("moontown-market-state-copy")],
                [
                  @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
                    @bunnia.text("Marketplace work requests"),
                  ]),
                  @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
                    @bunnia.text(
                      "Approve the task and its ceiling here. MoonTown queues the existing MoonClaw runtime and brings the receipt back to both people.",
                    ),
                  ]),
                ],
              ),
            ],
          ),
          @bunnia.form("load-marketplace-action-requests", [
            marketplace_submit_button("Refresh", "refresh"),
          ]),
        ],
      ),
      @bunnia.view_with_attrs(
        [
          @bunnia.class_name("moontown-market-state empty"),
          @bunnia.attr(
            "wx:if", "{{marketplaceActionRequests.remote && marketplaceActionRequests.items.length == 0}}",
          ),
        ],
        [
          town_icon("inbox"),
          @bunnia.view_with_attrs(
            [@bunnia.class_name("moontown-market-state-copy")],
            [
              @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
                @bunnia.text("No marketplace requests"),
              ]),
              @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
                @bunnia.text(
                  "Try or invite a published agent in Discover, or wait for someone to request yours.",
                ),
              ]),
            ],
          ),
        ],
      ),
      marketplace_action_request_rows(),
      backend_feedback(
        "marketplace-action-requests", "Updating the governed request…", "Request and runtime handoff updated.",
        "The decision is saved when possible. Activate your supervisor, refresh, and retry the handoff.",
      ),
    ],
  )
}

///|
fn marketplace_action_request_rows() -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-marketplace-request-list"),
      @bunnia.attr("wx:for", "{{marketplaceActionRequests.items}}"),
      @bunnia.attr("wx:for-item", "item"),
      @bunnia.attr("wx:key", "id"),
    ],
    [marketplace_action_request_row()],
  )
}

///|
fn marketplace_action_request_row() -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name(
        "moontown-marketplace-request bunnia-status-{{item.state}}",
      ),
      @bunnia.data("request-id", "{{item.requestId}}"),
    ],
    [
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-child-task-head")],
        [
          @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
            @bunnia.text("{{item.actionId}} · {{item.listingId}}"),
          ]),
          @bunnia.view_with_attrs(
            [@bunnia.class_name("moontown-receipt-stamp {{item.state}}")],
            [@bunnia.text("{{item.state}}")],
          ),
        ],
      ),
      @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
        @bunnia.text(
          "{{item.viewerRole == 'publisher' ? 'From ' + item.requesterId : 'With ' + item.publisherId}}",
        ),
      ]),
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-request-message")],
        [@bunnia.text("{{item.requestMessage}}")],
      ),
      marketplace_action_decision_controls(),
      marketplace_action_runtime_receipt(),
    ],
  )
}

///|
fn marketplace_action_decision_controls() -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-request-decision"),
      @bunnia.attr("wx:if", "{{item.canDecide}}"),
    ],
    [
      @bunnia.view_with_attrs([@bunnia.class_name("moontown-policy-ceiling")], [
        town_icon("shield"),
        @bunnia.text(
          "Reviewable output · gpt-5.6-sol · 5 min · 12k tokens · 3 artifacts · web off",
        ),
      ]),
      @bunnia.form("decide-marketplace-action-request", [
        marketplace_hidden_input("requestId", "{{item.requestId}}"),
        marketplace_hidden_input("expectedVersion", "{{item.version}}"),
        marketplace_hidden_input("decision", "accept"),
        marketplace_hidden_input("requestMessage", "{{item.requestMessage}}"),
        @bunnia.node(
          kind="input",
          attrs=[
            @bunnia.attr("name", "instruction"),
            @bunnia.attr("value", "{{item.requestMessage}}"),
            @bunnia.attr(
              "placeholder", "Describe the exact bounded result to produce",
            ),
            @bunnia.attr("aria-label", "Approved worker instruction"),
          ],
          children=[],
        ),
        marketplace_submit_button(
          "Approve & queue",
          "check",
          emphasis="primary",
        ),
      ]),
      @bunnia.form("decide-marketplace-action-request", [
        marketplace_hidden_input("requestId", "{{item.requestId}}"),
        marketplace_hidden_input("expectedVersion", "{{item.version}}"),
        marketplace_hidden_input("decision", "reject"),
        marketplace_submit_button("Decline", "close"),
      ]),
    ],
  )
}

///|
fn marketplace_action_runtime_receipt() -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-marketplace-runtime-receipt"),
      @bunnia.attr("wx:if", "{{!item.canDecide}}"),
    ],
    [
      @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
        @bunnia.text(
          "{{item.runtimeStatus || item.state}}{{item.workerRunId ? ' · worker ' + item.workerRunId : ''}}",
        ),
      ]),
      @bunnia.view_with_attrs(
        [
          @bunnia.class_name("moontown-request-result"),
          @bunnia.attr("wx:if", "{{item.resultSummary}}"),
        ],
        [@bunnia.text("{{item.resultSummary}}")],
      ),
      @bunnia.form("retry-marketplace-action-handoff", [
        marketplace_hidden_input("requestId", "{{item.requestId}}"),
        marketplace_hidden_input("expectedVersion", "{{item.version}}"),
        @bunnia.node(
          kind="button",
          attrs=[
            @bunnia.attr("wx:if", "{{item.canRetryHandoff}}"),
            @bunnia.attr("form-type", "submit"),
            @bunnia.class_name("moontown-market-action action-primary"),
            @bunnia.attr("aria-label", "Retry MoonClaw handoff"),
          ],
          children=town_icon_label("retry", "Retry handoff"),
        ),
      ]),
    ],
  )
}
