///|
fn building_context_section(projection : MiniTownProjection) -> @bunnia.Node {
  let building = selected_building(projection)
  let messages = selected_building_messages(projection)
  let runs = selected_building_runs(projection)
  let cards = building_context_cards(projection, messages, runs)
  object_section(
    section_id="communication",
    title="Communication Context",
    note="Latest message, agent work, and review needs stay tied to this place.",
    extra_class="moontown-chat-drawer",
    children=[
      @bunnia.windowed_list(
        cards,
        total_count=cards.length(),
        render=building_context_card_entry,
      ),
      @bunnia.form("send-building-message", [
        @bunnia.input(
          name="chatDraft.body",
          value="Can it publish an agent?",
          input_message="edit-chat-draft",
        ),
        @bunnia.button("Send", "send-building-message"),
      ]),
      @bunnia.view_with_attrs([@bunnia.data("building-id", building.id)], [
        @bunnia.text("Open Messages to continue the building thread."),
      ]),
    ],
  )
}

///|
priv struct BuildingContextCard {
  id : String
  title : String
  summary : String
  meta : String
  status : String
  action_label : String
  action_message : String
}

///|
fn building_context_card(
  id~ : String,
  title~ : String,
  summary~ : String,
  meta~ : String,
  status~ : String,
  action_label~ : String,
  action_message~ : String,
) -> BuildingContextCard {
  { id, title, summary, meta, status, action_label, action_message }
}

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

///|
fn building_pending_review(
  projection : MiniTownProjection,
  building_id : String,
) -> MiniTownReviewItem {
  for review in pending_reviews(projection) {
    if review.building_id == building_id {
      return review
    }
  }
  mini_town_review_item(
    id="",
    run_id="",
    building_id="",
    book_id="",
    title="",
    summary="",
    artifact_ref="",
    reviewer_id="",
    status="stable",
  )
}

///|
fn message_actor_label(
  projection : MiniTownProjection,
  actor_id : String,
) -> String {
  if actor_id == projection.active_user_id {
    projection.profile.display_name
  } else if actor_id == "system" {
    "Town notice"
  } else {
    agent_name(projection, actor_id)
  }
}

///|
fn selected_building_latest_run(projection : MiniTownProjection) -> MiniTownRun {
  let runs = selected_building_runs(projection)
  if runs.length() > 0 {
    runs[0]
  } else {
    projection.runs[0]
  }
}
