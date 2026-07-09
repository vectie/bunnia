///|
fn book_shelf_meta_copy(item : MiniTownBookShelfItem) -> String {
  let memory_label = count_label(
    item.accepted_memory_count,
    "memory",
    "memories",
  )
  let review_label = optional_count_label(
    item.pending_review_count,
    "review",
    "reviews",
  )
  "\{memory_label} - \{review_label} - \{town_status_label(item.status)}"
}
