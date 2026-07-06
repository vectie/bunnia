///|
pub(all) enum SurfaceStatusKind {
  SurfaceLoading
  SurfaceReady
  SurfaceStale
  SurfaceError
  SurfaceRetry
  SurfaceCancelled
  SurfaceDegraded
} derive(Debug, Eq)

///|
pub struct SurfaceStatus {
  kind : SurfaceStatusKind
  label : String
  detail : String
  action_message : String
} derive(Debug, Eq)

///|
pub fn surface_status(
  kind~ : SurfaceStatusKind,
  label~ : String,
  detail? : String = "",
  action_message? : String = "",
) -> SurfaceStatus {
  { kind, label, detail, action_message }
}

///|
pub fn surface_loading(
  label? : String = "Loading",
  detail? : String = "",
) -> SurfaceStatus {
  surface_status(kind=SurfaceLoading, label~, detail~)
}

///|
pub fn surface_ready(
  label? : String = "Ready",
  detail? : String = "",
) -> SurfaceStatus {
  surface_status(kind=SurfaceReady, label~, detail~)
}

///|
pub fn surface_stale(
  label? : String = "Stale",
  detail? : String = "",
  action_message? : String = "",
) -> SurfaceStatus {
  surface_status(kind=SurfaceStale, label~, detail~, action_message~)
}

///|
pub fn surface_error(
  label? : String = "Error",
  detail? : String = "",
  action_message? : String = "",
) -> SurfaceStatus {
  surface_status(kind=SurfaceError, label~, detail~, action_message~)
}

///|
pub fn surface_retry(
  label? : String = "Retry",
  detail? : String = "",
  action_message? : String = "",
) -> SurfaceStatus {
  surface_status(kind=SurfaceRetry, label~, detail~, action_message~)
}

///|
pub fn surface_cancelled(
  label? : String = "Cancelled",
  detail? : String = "",
  action_message? : String = "",
) -> SurfaceStatus {
  surface_status(kind=SurfaceCancelled, label~, detail~, action_message~)
}

///|
pub fn surface_degraded(
  label? : String = "Degraded",
  detail? : String = "",
  action_message? : String = "",
) -> SurfaceStatus {
  surface_status(kind=SurfaceDegraded, label~, detail~, action_message~)
}

///|
pub fn surface_status_kind_id(kind : SurfaceStatusKind) -> String {
  match kind {
    SurfaceLoading => "loading"
    SurfaceReady => "ready"
    SurfaceStale => "stale"
    SurfaceError => "error"
    SurfaceRetry => "retry"
    SurfaceCancelled => "cancelled"
    SurfaceDegraded => "degraded"
  }
}

///|
pub fn surface_status_badge(status : SurfaceStatus) -> Node {
  let events = if status.action_message == "" {
    []
  } else {
    [tap(status.action_message)]
  }
  node(
    kind="view",
    attrs=[
      class_name(
        "bunnia-status-badge bunnia-surface-state-\{surface_status_kind_id(status.kind)}",
      ),
      data("surface-status", surface_status_kind_id(status.kind)),
      data("action-message", status.action_message),
    ],
    events~,
    children=surface_status_children(status),
  )
}

///|
pub fn surface_status_overlay(status : SurfaceStatus, child : Node) -> Node {
  view_with_attrs(
    [
      class_name(
        "bunnia-status-surface bunnia-surface-state-\{surface_status_kind_id(status.kind)}",
      ),
      data("surface-status", surface_status_kind_id(status.kind)),
    ],
    [child, surface_status_badge(status)],
  )
}

///|
fn surface_status_children(status : SurfaceStatus) -> Array[Node] {
  let children = [text(status.label)]
  if status.detail != "" {
    children.push(
      view_with_attrs([class_name("bunnia-status-detail")], [
        text(status.detail),
      ]),
    )
  }
  children
}
