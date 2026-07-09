///|
fn building_context_cards(
  projection : MiniTownProjection,
  messages : Array[MiniTownMessage],
  runs : Array[MiniTownRun],
) -> Array[BuildingContextCard] {
  let output : Array[BuildingContextCard] = []
  let building = selected_building(projection)
  if messages.length() > 0 {
    let message = messages[0]
    output.push(
      building_context_card(
        id="latest-message",
        title="Latest message",
        summary=message.text,
        meta="\{message_actor_label(projection, message.actor_id)} - \{building.title}",
        status="ready",
        action_label="Reply",
        action_message="tab-messages",
      ),
    )
  }
  if runs.length() > 0 {
    let run = runs[0]
    output.push(
      building_context_card(
        id="latest-work",
        title=run.title,
        summary=run.summary,
        meta="\{town_status_label(run.status)} - \{message_actor_label(projection, run.agent_id)} - \{book_title_by_id(projection, run.book_id)}",
        status=run.status,
        action_label=if run.review_required {
          "Review Work"
        } else {
          "Open Work"
        },
        action_message="tab-messages",
      ),
    )
  }
  let review = building_pending_review(projection, building.id)
  if review.id != "" {
    output.push(
      building_context_card(
        id="review-need",
        title="Review needed",
        summary=review.summary,
        meta="\{building.title} - \{book_title_by_id(projection, review.book_id)}",
        status=review.status,
        action_label="Review",
        action_message="tab-messages",
      ),
    )
  }
  if output.length() == 0 {
    output.push(
      building_context_card(
        id="quiet",
        title="No current thread",
        summary="Messages, runs, and review needs will appear here.",
        meta=building.title,
        status="stable",
        action_label="Messages",
        action_message="tab-messages",
      ),
    )
  }
  output
}

///|
fn building_context_card_entry(item : BuildingContextCard) -> @bunnia.Node {
  @bunnia.keyed(
    "building-context-\{item.id}",
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name(
          "moontown-object-context-card bunnia-status-\{item.status}",
        ),
        @bunnia.data("object-context", item.id),
      ],
      [
        @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
          @bunnia.text(item.title),
        ]),
        @bunnia.text(item.summary),
        @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
          @bunnia.text(item.meta),
        ]),
        @bunnia.view_with_attrs([@bunnia.class_name("moontown-run-actions")], [
          @bunnia.button(item.action_label, item.action_message),
        ]),
      ],
    ),
  )
}
