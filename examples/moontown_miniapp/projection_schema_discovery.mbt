///|
pub struct MiniTownDiscoveryItem {
  id : String
  kind : String
  title : String
  summary : String
  target_ref : String
  visibility : String
  status : String
} derive(Debug, Eq)

///|
pub struct MiniTownDiscoveryFilter {
  id : String
  label : String
  kind : String
  placeable_only : Bool
} derive(Debug, Eq)

///|
pub fn mini_town_discovery_item(
  id~ : String,
  kind~ : String,
  title~ : String,
  summary~ : String,
  target_ref~ : String,
  visibility~ : String,
  status~ : String,
) -> MiniTownDiscoveryItem {
  { id, kind, title, summary, target_ref, visibility, status }
}

///|
pub fn mini_town_discovery_filter(
  id~ : String,
  label~ : String,
  kind~ : String,
  placeable_only? : Bool = false,
) -> MiniTownDiscoveryFilter {
  { id, label, kind, placeable_only }
}
