///|
pub struct MiniTownOwnershipStat {
  id : String
  label : String
  value : Int
} derive(Debug, Eq)

///|
pub struct MiniTownOwnershipItem {
  id : String
  kind : String
  title : String
  summary : String
  target_ref : String
  visibility : String
  status : String
  action_label : String
  action_message : String
} derive(Debug, Eq)

///|
pub struct MiniTownOwnershipFilter {
  id : String
  label : String
  kind : String
  visibility : String
} derive(Debug, Eq)

///|
pub fn mini_town_ownership_stat(
  id~ : String,
  label~ : String,
  value~ : Int,
) -> MiniTownOwnershipStat {
  { id, label, value }
}

///|
pub fn mini_town_ownership_item(
  id~ : String,
  kind~ : String,
  title~ : String,
  summary~ : String,
  target_ref~ : String,
  visibility~ : String,
  status~ : String,
  action_label~ : String,
  action_message~ : String,
) -> MiniTownOwnershipItem {
  {
    id,
    kind,
    title,
    summary,
    target_ref,
    visibility,
    status,
    action_label,
    action_message,
  }
}

///|
pub fn mini_town_ownership_filter(
  id~ : String,
  label~ : String,
  kind? : String = "all",
  visibility? : String = "all",
) -> MiniTownOwnershipFilter {
  { id, label, kind, visibility }
}
