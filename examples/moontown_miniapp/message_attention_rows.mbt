///|
fn message_attention_rows(
  projection : MiniTownProjection,
) -> Array[MessageAttentionRow] {
  let rows : Array[MessageAttentionRow] = []
  push_attention_row(message_attention_review_row(projection), rows)
  push_attention_row(message_attention_agent_work_row(projection), rows)
  push_attention_row(message_attention_failed_work_row(projection), rows)
  push_attention_row(message_attention_signal_row(projection), rows)
  if rows.length() == 0 {
    rows.push(message_attention_quiet_row())
  }
  rows
}

///|
fn push_attention_row(
  row : MessageAttentionRow?,
  rows : Array[MessageAttentionRow],
) -> Unit {
  if row is Some(row) {
    rows.push(row)
  }
}

///|
fn message_attention_review_row(
  projection : MiniTownProjection,
) -> MessageAttentionRow? {
  let reviews = pending_reviews(projection)
  if reviews.length() == 0 {
    None
  } else {
    let review = reviews[0]
    Some(
      message_attention_row(
        id="review",
        title="Review waiting answer",
        summary="\{building_title_by_id(projection, review.building_id)} needs a decision before memory is saved.",
        status="review",
        action_label="Review",
        action_message="open-notice-review",
        building_id=review.building_id,
      ),
    )
  }
}

///|
fn message_attention_agent_work_row(
  projection : MiniTownProjection,
) -> MessageAttentionRow? {
  let runs = active_runs(projection)
  if runs.length() == 0 {
    None
  } else {
    let run = runs[0]
    Some(
      message_attention_row(
        id="agent-work",
        title="Agent work in progress",
        summary="\{building_title_by_id(projection, run.building_id)} is working from \{book_title_by_id(projection, run.book_id)}.",
        status=run.status,
        action_label="Open Place",
        action_message="open-place-\{run.building_id}",
        building_id=run.building_id,
      ),
    )
  }
}

///|
fn message_attention_failed_work_row(
  projection : MiniTownProjection,
) -> MessageAttentionRow? {
  let failed = failed_run_count(projection)
  if failed == 0 {
    None
  } else {
    Some(
      message_attention_row(
        id="failed-work",
        title="Work needs recovery",
        summary="\{message_count_text(failed)} can be retried or stopped from Agent Work.",
        status="failed",
        action_label="Review Work",
        action_message="notification-channel-unread",
        building_id="",
      ),
    )
  }
}

///|
fn message_attention_signal_row(
  projection : MiniTownProjection,
) -> MessageAttentionRow? {
  let subscriptions = subscription_notifications(projection)
  if subscriptions.length() == 0 {
    None
  } else {
    let notice = subscriptions[0]
    Some(
      message_attention_row(
        id="signals",
        title="Town signals are available",
        summary=notice.body,
        status="stable",
        action_label=notice.action_label,
        action_message=notice.action_message,
        building_id=notice.building_id,
      ),
    )
  }
}

///|
fn message_attention_quiet_row() -> MessageAttentionRow {
  message_attention_row(
    id="quiet",
    title="No urgent messages",
    summary="Agent replies, reviews, and town notices will appear here.",
    status="stable",
    action_label="Latest Messages",
    action_message="load-message-center",
    building_id="",
  )
}
