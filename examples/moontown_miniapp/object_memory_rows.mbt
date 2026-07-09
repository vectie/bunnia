///|
fn book_shelf_entry(item : MiniTownBookShelfItem) -> @bunnia.Node {
  @bunnia.keyed(
    "book-shelf-\{item.id}",
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("moontown-book-entry bunnia-status-\{item.status}"),
        @bunnia.data("book-shelf-role", item.role),
        @bunnia.data("building-id", item.building_id),
      ],
      [
        book_shelf_title(item),
        @bunnia.text(item.safe_summary),
        book_shelf_meta(item),
        book_shelf_actions(item),
      ],
    ),
  )
}

///|
fn book_shelf_title(item : MiniTownBookShelfItem) -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
    @bunnia.text("\{item.title}"),
  ])
}

///|
fn book_shelf_meta(item : MiniTownBookShelfItem) -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
    @bunnia.text(book_shelf_meta_copy(item)),
  ])
}
