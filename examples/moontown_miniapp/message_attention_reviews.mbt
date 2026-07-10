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
