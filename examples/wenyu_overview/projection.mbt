///|
pub struct CivicBuilding {
  id : String
  name : String
  status : String
  summary : String
  x : Int
  y : Int
  asset_ref : String
} derive(Debug, Eq)

///|
pub struct DashboardMetric {
  id : String
  label : String
  value : String
  status : String
} derive(Debug, Eq)

///|
pub struct WenyuProjection {
  id : String
  title : String
  status : String
  selected_building : String
  buildings : Array[CivicBuilding]
  metrics : Array[DashboardMetric]
} derive(Debug, Eq)

///|
pub fn civic_building(
  id~ : String,
  name~ : String,
  status~ : String,
  summary~ : String,
  x~ : Int,
  y~ : Int,
  asset_ref? : String = "",
) -> CivicBuilding {
  { id, name, status, summary, x, y, asset_ref }
}

///|
pub fn dashboard_metric(
  id~ : String,
  label~ : String,
  value~ : String,
  status~ : String,
) -> DashboardMetric {
  { id, label, value, status }
}

///|
pub fn wenyu_projection(
  id~ : String,
  title~ : String,
  status~ : String,
  selected_building~ : String,
  buildings~ : Array[CivicBuilding],
  metrics~ : Array[DashboardMetric],
) -> WenyuProjection {
  { id, title, status, selected_building, buildings, metrics }
}

///|
pub fn demo_projection() -> WenyuProjection {
  wenyu_projection(
    id="wenyu-overview",
    title="Wenyu Overview",
    status="review",
    selected_building="building-dock",
    buildings=[
      civic_building(
        id="building-gate",
        name="North Gate",
        status="stable",
        summary="Entry flow is normal.",
        x=96,
        y=136,
        asset_ref="building-sprite",
      ),
      civic_building(
        id="building-dock",
        name="Review Dock",
        status="review",
        summary="Operator approval is waiting.",
        x=312,
        y=244,
        asset_ref="building-sprite",
      ),
      civic_building(
        id="building-market",
        name="Market Hall",
        status="running",
        summary="Agent is refreshing supply status.",
        x=512,
        y=184,
        asset_ref="building-sprite",
      ),
      civic_building(
        id="building-archive",
        name="Archive",
        status="stale",
        summary="Snapshot is older than target freshness.",
        x=432,
        y=380,
        asset_ref="building-sprite",
      ),
    ],
    metrics=[
      dashboard_metric(
        id="metric-open",
        label="Open Items",
        value="18",
        status="running",
      ),
      dashboard_metric(
        id="metric-review",
        label="Reviews",
        value="3",
        status="review",
      ),
      dashboard_metric(
        id="metric-stale",
        label="Stale",
        value="1",
        status="stale",
      ),
    ],
  )
}

///|
pub fn large_projection(building_count : Int) -> WenyuProjection {
  let buildings : Array[CivicBuilding] = []
  for i in 0..<building_count {
    buildings.push(
      civic_building(
        id="building-\{i}",
        name="Module \{i}",
        status=if i % 5 == 0 { "review" } else { "stable" },
        summary="Synthetic repeated module \{i}.",
        x=64 + i % 8 * 72,
        y=80 + i / 8 * 72,
        asset_ref="building-sprite",
      ),
    )
  }
  wenyu_projection(
    id="wenyu-large",
    title="Large Wenyu Fixture",
    status="running",
    selected_building="building-0",
    buildings~,
    metrics=[
      dashboard_metric(
        id="metric-modules",
        label="Modules",
        value=building_count.to_string(),
        status="running",
      ),
    ],
  )
}

///|
pub fn demo_projection_json() -> String {
  "{\"id\":\"wenyu-overview\",\"title\":\"Wenyu Overview\",\"selectedBuilding\":\"building-dock\",\"buildings\":[{\"id\":\"building-gate\",\"status\":\"stable\"},{\"id\":\"building-dock\",\"status\":\"review\"},{\"id\":\"building-market\",\"status\":\"running\"},{\"id\":\"building-archive\",\"status\":\"stale\"}]}"
}

///|
pub fn migration_notes() -> Array[String] {
  [
    "Map Rabbita repeated building cards to keyed Bunnia list rows.", "Map status badges to generic status strings and CSS classes.",
    "Map building selection to scene marker tap messages and small patches.", "Keep daemon snapshots behind backend contracts, not mini-app runtime code.",
    "Port header status, building card, metric strip, review action, scene marker, artifact link, communication trace, backend refresh, stale notice, and operator submit next.",
  ]
}
