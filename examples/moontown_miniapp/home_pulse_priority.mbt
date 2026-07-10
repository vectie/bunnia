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

///|
fn home_pulse_followups(
  rows : Array[HomePulseRow],
  lead_id : String,
) -> Array[HomePulseRow] {
  let followups : Array[HomePulseRow] = []
  for item in rows {
    if item.id != lead_id {
      followups.push(item)
    }
  }
  followups
}
