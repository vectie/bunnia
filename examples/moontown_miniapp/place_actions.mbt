///|
fn open_place_button(building_id : String) -> @bunnia.Node {
  @bunnia.node(
    kind="button",
    attrs=[
      @bunnia.data("building-id", building_id),
      @bunnia.data("place-destination", "Realm"),
    ],
    events=[@bunnia.tap("open-place-\{building_id}")],
    children=[@bunnia.text("Open Place")],
  )
}

///|
fn high_leverage_place_route(building_id : String) -> Bool {
  building_id == "policy-hall" ||
  building_id == "private-agent-lab" ||
  building_id == "published-agent-lab"
}
