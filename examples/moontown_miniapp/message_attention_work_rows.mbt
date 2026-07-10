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
        title="Work needs attention",
        summary="\{message_count_text(failed)} can be retried or stopped from Agent Work.",
        status="failed",
        action_label="Review Work",
        action_message="notification-channel-unread",
        building_id="",
      ),
    )
  }
}
