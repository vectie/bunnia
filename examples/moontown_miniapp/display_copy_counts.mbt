///|
fn ready_word(ready : Bool) -> String {
  if ready {
    "ready"
  } else {
    "needs setup"
  }
}

///|
fn count_label(count : Int, singular : String, plural : String) -> String {
  if count == 1 {
    "1 \{singular}"
  } else {
    "\{count} \{plural}"
  }
}

///|
fn optional_count_label(
  count : Int,
  singular : String,
  plural : String,
) -> String {
  if count == 0 {
    "no \{plural}"
  } else {
    count_label(count, singular, plural)
  }
}

///|
fn empty_count_label(
  count : Int,
  empty : String,
  singular : String,
  plural : String,
) -> String {
  if count == 0 {
    empty
  } else {
    count_label(count, singular, plural)
  }
}
