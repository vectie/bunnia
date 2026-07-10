///|
fn review_queue_panel(projection : MiniTownProjection) -> @bunnia.Node {
  let reviews = pending_reviews(projection)
  @bunnia.view_with_attrs(
    [@bunnia.class_name("mt-panel moontown-message-review")],
    [
      @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-title")], [
        @bunnia.text("Needs Review"),
      ]),
      @bunnia.windowed_list(reviews, total_count=reviews.length(), render=item => {
        review_entry(projection, item)
      }),
    ],
  )
}

///|
fn review_entry(
  projection : MiniTownProjection,
  item : MiniTownReviewItem,
) -> @bunnia.Node {
  @bunnia.keyed(
    "review-\{item.id}",
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("moontown-review-entry bunnia-status-\{item.status}"),
        @bunnia.attr("wx:if", review_entry_visibility(item)),
        @bunnia.data("building-id", item.building_id),
        @bunnia.data("book-id", item.book_id),
      ],
      [
        @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
          @bunnia.text(item.title),
        ]),
        @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
          @bunnia.text(
            "\{building_title_by_id(projection, item.building_id)} - \{book_title_by_id(projection, item.book_id)} - \{review_meta_text(item)}",
          ),
        ]),
        review_controls_entry(item),
      ],
    ),
  )
}

///|
fn review_entry_visibility(item : MiniTownReviewItem) -> String {
  if item.accept_message == "accept-memory-review" ||
    item.reject_message == "reject-memory-review" {
    "{{reviews.memoryReview == 'pending'}}"
  } else {
    "{{true}}"
  }
}

///|
fn review_controls_entry(item : MiniTownReviewItem) -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("bunnia-review bunnia-review-pending"),
      @bunnia.data("review-enabled", "true"),
    ],
    [
      @bunnia.text(review_kind_label(item)),
      review_decision_button("Approve", "accept", item.accept_message),
      review_decision_button("Reject", "reject", item.reject_message),
    ],
  )
}

///|
fn review_kind_label(item : MiniTownReviewItem) -> String {
  if item.artifact_ref.has_prefix("building://") {
    "Publication review"
  } else {
    "Memory review"
  }
}

///|
fn review_meta_text(item : MiniTownReviewItem) -> String {
  if item.artifact_ref.has_prefix("building://") {
    "\{town_status_label(item.status)} - publication review"
  } else {
    "\{town_status_label(item.status)} - +\{item.accepted_memory_delta} memory"
  }
}

///|
fn review_decision_button(
  label : String,
  decision : String,
  message : String,
) -> @bunnia.Node {
  @bunnia.node(
    kind="button",
    attrs=[
      @bunnia.class_name(
        if decision == "accept" {
          "bunnia-review-button bunnia-review-button-enabled moontown-primary-action"
        } else {
          "bunnia-review-button bunnia-review-button-enabled moontown-danger-action"
        },
      ),
      @bunnia.data("decision", decision),
    ],
    events=[@bunnia.tap(message)],
    children=[@bunnia.text(label)],
  )
}
