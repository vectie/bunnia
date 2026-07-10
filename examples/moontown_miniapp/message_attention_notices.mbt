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
