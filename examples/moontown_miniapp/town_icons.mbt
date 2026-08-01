///|
// Code-native outline icons keep the mini-app asset-light and inherit the
// existing MoonTown palette. Every icon-only control supplies its own label.
fn town_icon(kind : String) -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-line-icon icon-\{kind}"),
      @bunnia.attr("aria-hidden", "true"),
    ],
    [],
  )
}

///|
fn town_icon_label(kind : String, label : String) -> Array[@bunnia.Node] {
  [town_icon(kind), @bunnia.text(label)]
}

///|
fn marketplace_hidden_input(name : String, value : String) -> @bunnia.Node {
  @bunnia.node(
    kind="input",
    attrs=[
      @bunnia.attr("type", "hidden"),
      @bunnia.attr("name", name),
      @bunnia.attr("value", value),
    ],
    children=[],
  )
}

///|
fn marketplace_submit_button(
  label : String,
  icon : String,
  emphasis? : String = "secondary",
) -> @bunnia.Node {
  @bunnia.node(
    kind="button",
    attrs=[
      @bunnia.attr("form-type", "submit"),
      @bunnia.class_name("moontown-market-action action-\{emphasis}"),
      @bunnia.attr("aria-label", label),
    ],
    children=town_icon_label(icon, label),
  )
}
