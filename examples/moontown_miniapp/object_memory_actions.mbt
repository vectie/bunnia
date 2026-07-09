///|
fn book_shelf_actions(item : MiniTownBookShelfItem) -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-run-actions")], [
    @bunnia.button("Read", "select-\{item.building_id}"),
    if item.pending_review_count > 0 {
      @bunnia.button("Review", "tab-messages")
    } else {
      @bunnia.button("Open Place", "select-\{item.building_id}")
    },
  ])
}
