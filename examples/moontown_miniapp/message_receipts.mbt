///|
fn acceptance_receipts_panel(projection : MiniTownProjection) -> @bunnia.Node {
  let receipts = projection.acceptance_receipts
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("mt-panel moontown-acceptance-ledger"),
      @bunnia.attr(
        "wx:if", "{{messages.mode == 'work' && messages.channel == 'receipts'}}",
      ),
    ],
    [
      @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-title")], [
        @bunnia.text("Bookkeeper Receipts"),
      ]),
      @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-note")], [
        @bunnia.text(
          "Pending is not accepted. Every proposal keeps a visible decision trail.",
        ),
      ]),
      @bunnia.windowed_list(receipts, total_count=receipts.length(), render=receipt => {
        acceptance_receipt_row(receipt)
      }),
    ],
  )
}

///|
fn acceptance_receipt_row(receipt : MiniTownAcceptanceReceipt) -> @bunnia.Node {
  @bunnia.keyed(
    "acceptance-receipt-\{receipt.id}",
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("moontown-acceptance-receipt \{receipt.status}"),
        @bunnia.data("receipt-id", receipt.id),
        @bunnia.data("submission-id", receipt.submission_id),
        @bunnia.data("evidence-digest", receipt.evidence_digest),
        @bunnia.data("artifact-ref", receipt.artifact_ref),
        @bunnia.data("run-id", receipt.run_id),
      ],
      [
        @bunnia.view_with_attrs(
          [@bunnia.class_name("moontown-child-task-head")],
          [
            @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
              @bunnia.text(receipt.title),
            ]),
            @bunnia.view_with_attrs(
              [@bunnia.class_name("moontown-receipt-stamp \{receipt.status}")],
              [@bunnia.text(receipt_status_label(receipt.status))],
            ),
          ],
        ),
        @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
          @bunnia.text(receipt.summary),
        ]),
        @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
          @bunnia.text(
            if receipt.status == "pending" {
              "Awaiting named-human review · \{receipt.reviewer_name}"
            } else {
              "Reviewed by \{receipt.reviewer_name}"
            },
          ),
        ]),
        @bunnia.node(
          kind="button",
          attrs=[
            @bunnia.class_name("moontown-secondary-action"),
            @bunnia.data("run-id", receipt.run_id),
            @bunnia.data("target-ref", receipt.deep_link),
          ],
          events=[@bunnia.tap(receipt_deep_link_message(receipt))],
          children=[@bunnia.text("Open Receipt")],
        ),
      ],
    ),
  )
}

///|
fn receipt_status_label(status : String) -> String {
  if status == "accepted" {
    "ACCEPTED"
  } else if status == "rejected" {
    "REJECTED"
  } else {
    "PENDING · NOT ACCEPTED"
  }
}

///|
fn receipt_deep_link_message(receipt : MiniTownAcceptanceReceipt) -> String {
  if receipt.status == "pending" {
    "notification-channel-reviews"
  } else if receipt.status == "rejected" {
    "retry-run"
  } else {
    "open-place-market-square"
  }
}
