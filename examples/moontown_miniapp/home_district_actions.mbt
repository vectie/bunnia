///|
fn district_cta_label(district : MiniTownDistrict) -> String {
  "\{district.action_label} \{town_tab_label(district_target_tab(district))}"
}

///|
fn district_action_message(district : MiniTownDistrict) -> String {
  if district.action_message == "" {
    "select-\{district.building_id}"
  } else {
    district.action_message
  }
}

///|
fn district_target_tab(district : MiniTownDistrict) -> String {
  if district.action_message.has_prefix("tab-") {
    district.action_message
    .sub(start=4, end=district.action_message.length())
    .to_owned()
  } else {
    "realm"
  }
}
