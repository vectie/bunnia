///|
fn demo_discovery_filters() -> Array[MiniTownDiscoveryFilter] {
  [
    mini_town_discovery_filter(id="all", label="All", kind="all"),
    mini_town_discovery_filter(id="user", label="People", kind="user"),
    mini_town_discovery_filter(id="circle", label="Circles", kind="circle"),
    mini_town_discovery_filter(id="product", label="Products", kind="product"),
    mini_town_discovery_filter(id="demand", label="Demands", kind="demand"),
    mini_town_discovery_filter(id="event", label="Events", kind="event"),
    mini_town_discovery_filter(id="post", label="Posts", kind="post"),
    mini_town_discovery_filter(
      id="building",
      label="Buildings",
      kind="building",
    ),
    mini_town_discovery_filter(id="agent", label="Agents", kind="agent"),
    mini_town_discovery_filter(id="book", label="Books", kind="book"),
    mini_town_discovery_filter(
      id="placeable",
      label="Placeable",
      kind="building",
      placeable_only=true,
    ),
  ]
}
