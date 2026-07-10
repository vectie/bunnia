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
