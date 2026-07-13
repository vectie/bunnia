///|
fn discover_entry(
  projection : MiniTownProjection,
  item : MiniTownDiscoveryItem,
) -> @bunnia.Node {
  @bunnia.keyed(
    "discover-\{item.id}",
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name(
          "moontown-discover-entry kind-\{item.kind} bunnia-status-\{item.status}",
        ),
        @bunnia.data("discovery-id", item.id),
        @bunnia.data("discovery-kind", item.kind),
        @bunnia.attr("wx:if", discover_entry_visibility(item)),
      ],
      [
        @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
          @bunnia.text(item.title),
        ]),
        discover_eligibility_row(projection, item),
        discover_entry_action(projection, item),
      ],
    ),
  )
}

///|
fn discover_entry_visibility(item : MiniTownDiscoveryItem) -> String {
  let filters = [
    "discover.filter == 'all'",
    "discover.filter == '\{item.kind}'",
  ]
  if item.kind == "building" {
    filters.push("discover.filter == 'placeable'")
  }
  "{{\{filters.join(" || ")}}}"
}

///|
fn discover_eligibility_row(
  projection : MiniTownProjection,
  item : MiniTownDiscoveryItem,
) -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-discovery-badges")], [
    discover_badge("kind", town_kind_label(item.kind)),
    discover_badge("eligibility", discover_eligibility_label(projection, item)),
  ])
}

///|
fn discover_badge(kind : String, label : String) -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [@bunnia.class_name("moontown-discovery-badge kind-\{kind}")],
    [@bunnia.text(label)],
  )
}

///|
fn discover_eligibility_label(
  projection : MiniTownProjection,
  item : MiniTownDiscoveryItem,
) -> String {
  if item.kind == "building" && item.visibility == "published" {
    if discovery_item_placement_state(projection, item) == "pinned" {
      "Already placed"
    } else {
      "Can place"
    }
  } else if item.visibility == "published" || item.visibility == "public" {
    "Can open"
  } else if item.visibility == "personal" {
    "Owner only"
  } else {
    "Needs setup"
  }
}
