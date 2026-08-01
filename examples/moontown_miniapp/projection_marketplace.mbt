///|
pub fn organic_marketplace_listings(
  projection : MiniTownProjection,
) -> Array[MiniTownMarketplaceListing] {
  let output : Array[MiniTownMarketplaceListing] = []
  for item in projection.marketplace_listings {
    if !item.sponsored &&
      item.status == "published" &&
      marketplace_listing_matches(projection, item) {
      output.push(item)
    }
  }
  output
}

///|
pub fn recommended_marketplace_listings(
  projection : MiniTownProjection,
) -> Array[MiniTownMarketplaceListing] {
  let output : Array[MiniTownMarketplaceListing] = []
  for item in projection.marketplace_listings {
    if !item.sponsored && item.recommended && item.status == "published" {
      output.push(item)
    }
  }
  output
}

///|
pub fn sponsored_marketplace_listings(
  projection : MiniTownProjection,
) -> Array[MiniTownMarketplaceListing] {
  let output : Array[MiniTownMarketplaceListing] = []
  for item in projection.marketplace_listings {
    if item.sponsored && item.status == "published" {
      output.push(item)
    }
  }
  output
}

///|
pub fn marketplace_channels_by_kind(
  projection : MiniTownProjection,
  kind : String,
) -> Array[MiniTownConversationChannel] {
  let output : Array[MiniTownConversationChannel] = []
  for channel in projection.conversation_channels {
    if kind == "all" || channel.kind == kind {
      output.push(channel)
    }
  }
  output
}

///|
fn marketplace_listing_matches(
  projection : MiniTownProjection,
  item : MiniTownMarketplaceListing,
) -> Bool {
  let kind_match = projection.active_discovery_filter_id == "all" ||
    projection.active_discovery_filter_id == item.kind
  let query = projection.search_query
  let query_match = query == "" ||
    item.title.contains(query) ||
    item.summary.contains(query) ||
    item.publisher.contains(query)
  kind_match && query_match
}
