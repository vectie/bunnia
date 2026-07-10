///|
fn discover_watch_button(item : MiniTownDiscoveryItem) -> @bunnia.Node {
  @bunnia.node(
    kind="button",
    attrs=[
      @bunnia.class_name("moontown-secondary-action"),
      @bunnia.data("discovery-id", item.id),
      @bunnia.data("notice-id", "notice-subscribe"),
      @bunnia.data("notice-kind", "subscription"),
      @bunnia.data("target-ref", item.target_ref),
    ],
    events=[@bunnia.tap("request-subscription")],
    children=[@bunnia.text("Watch")],
  )
}
