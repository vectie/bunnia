///|
fn home_pulse_lead(rows : Array[HomePulseRow]) -> HomePulseRow {
  for item in rows {
    if item.id == "attention" && item.status == "review" {
      return item
    }
  }
  for item in rows {
    if item.id == "refresh" && item.status == "stale" {
      return item
    }
  }
  rows[0]
}
