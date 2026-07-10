///|
fn ownership_stat_value(
  stats : Array[MiniTownOwnershipStat],
  id : String,
) -> Int {
  for stat in stats {
    if stat.id == id {
      return stat.value
    }
  }
  0
}

///|
fn ownership_stat_entry(stat : MiniTownOwnershipStat) -> @bunnia.Node {
  @bunnia.keyed(
    "ownership-stat-\{stat.id}",
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("moontown-owned-entry"),
        @bunnia.data("ownership-stat", stat.id),
      ],
      [
        @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
          @bunnia.text(stat.label),
        ]),
        @bunnia.text(stat.value.to_string()),
      ],
    ),
  )
}
