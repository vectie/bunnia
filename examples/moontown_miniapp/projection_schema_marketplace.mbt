///|
// Safe UI projections only. These records deliberately exclude runtime memory,
// host paths, authority envelopes, consent records, and provider payloads.
pub struct MiniTownMarketplaceListing {
  id : String
  kind : String
  title : String
  summary : String
  publisher : String
  publisher_id : String
  recommendation_reason : String
  sponsored : Bool
  sponsor_label : String
  status : String
  building_id : String
  price_label : String
  trust_label : String
  recommended : Bool
  actions : Array[String]
} derive(Debug, Eq)

///|
pub struct MiniTownConversationChannel {
  id : String
  kind : String
  title : String
  preview : String
  context_label : String
  building_id : String
  unread_count : Int
  subscribed : Bool
  status : String
} derive(Debug, Eq)

///|
pub struct MiniTownSharePreview {
  id : String
  listing_id : String
  kind : String
  title : String
  safe_summary : String
  publisher : String
  visibility_label : String
  included_fields : Array[String]
  withheld_fields : Array[String]
} derive(Debug, Eq)

///|
pub fn mini_town_marketplace_listing(
  id~ : String,
  kind~ : String,
  title~ : String,
  summary~ : String,
  publisher~ : String,
  publisher_id? : String = "",
  recommendation_reason? : String = "",
  sponsored? : Bool = false,
  sponsor_label? : String = "",
  status? : String = "published",
  building_id? : String = "",
  price_label? : String = "Free to inspect",
  trust_label? : String = "Reviewed listing",
  recommended? : Bool = false,
  actions? : Array[String] = [],
) -> MiniTownMarketplaceListing {
  {
    id,
    kind,
    title,
    summary,
    publisher,
    publisher_id,
    recommendation_reason,
    sponsored,
    sponsor_label,
    status,
    building_id,
    price_label,
    trust_label,
    recommended,
    actions,
  }
}

///|
pub fn mini_town_conversation_channel(
  id~ : String,
  kind~ : String,
  title~ : String,
  preview~ : String,
  context_label~ : String,
  building_id? : String = "",
  unread_count? : Int = 0,
  subscribed? : Bool = true,
  status? : String = "active",
) -> MiniTownConversationChannel {
  {
    id,
    kind,
    title,
    preview,
    context_label,
    building_id,
    unread_count,
    subscribed,
    status,
  }
}

///|
pub fn mini_town_share_preview(
  id~ : String,
  listing_id~ : String,
  kind~ : String,
  title~ : String,
  safe_summary~ : String,
  publisher~ : String,
  visibility_label? : String = "Public Town",
  included_fields? : Array[String] = [],
  withheld_fields? : Array[String] = [],
) -> MiniTownSharePreview {
  {
    id,
    listing_id,
    kind,
    title,
    safe_summary,
    publisher,
    visibility_label,
    included_fields,
    withheld_fields,
  }
}
