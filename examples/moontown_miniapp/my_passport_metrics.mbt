///|
fn profile_metric_chips(
  projection : MiniTownProjection,
  stats : Array[MiniTownOwnershipStat],
) -> Array[@bunnia.Node] {
  [
    profile_metric_chip(
      label="Reviews",
      value=pending_reviews(projection).length(),
    ),
    profile_metric_chip(
      label="Published",
      value=ownership_stat_value(stats, "published"),
    ),
  ]
}

///|
fn profile_metric_chip(label~ : String, value~ : Int) -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-profile-metric")], [
    @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
      @bunnia.text(value.to_string()),
    ]),
    @bunnia.text(label),
  ])
}
