///|
fn book_shelf_actions(item : MiniTownBookShelfItem) -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-run-actions")], [
    if item.pending_review_count > 0 {
      @bunnia.button("Review", "tab-messages")
    } else {
      @bunnia.view([])
    },
  ])
}
