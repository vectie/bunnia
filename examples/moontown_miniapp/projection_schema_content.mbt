///|
pub struct MiniTownBuilding {
  id : String
  title : String
  kind : String
  visibility : String
  owner_id : String
  summary : String
  tags : Array[String]
  x : Int
  y : Int
  status : String
  asset_ref : String
} derive(Debug, Eq)

///|
pub struct MiniTownBook {
  id : String
  building_id : String
  title : String
  owner_id : String
  visibility : String
  summary : String
  accepted_memory_count : Int
  pending_review_count : Int
  status : String
} derive(Debug, Eq)

///|
pub fn mini_town_building(
  id~ : String,
  title~ : String,
  kind~ : String,
  visibility~ : String,
  owner_id~ : String,
  summary~ : String,
  tags~ : Array[String],
  x~ : Int,
  y~ : Int,
  status~ : String,
  asset_ref? : String = "moontown-building",
) -> MiniTownBuilding {
  {
    id,
    title,
    kind,
    visibility,
    owner_id,
    summary,
    tags,
    x,
    y,
    status,
    asset_ref,
  }
}

///|
pub fn mini_town_book(
  id~ : String,
  building_id~ : String,
  title~ : String,
  owner_id~ : String,
  visibility~ : String,
  summary~ : String,
  accepted_memory_count~ : Int,
  pending_review_count~ : Int,
  status~ : String,
) -> MiniTownBook {
  {
    id,
    building_id,
    title,
    owner_id,
    visibility,
    summary,
    accepted_memory_count,
    pending_review_count,
    status,
  }
}
