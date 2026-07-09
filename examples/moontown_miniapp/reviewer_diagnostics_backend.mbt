///|
fn backend_step_by_id(
  projection : MiniTownProjection,
  id : String,
) -> MiniTownBackendStep {
  for step in projection.backend_steps {
    if step.id == id {
      return step
    }
  }
  mini_town_backend_step(
    id~,
    label=id,
    endpoint_id=id,
    http_method="GET",
    path="/miniapp/admin/ops",
    summary="Missing backend step.",
    status="missing",
  )
}
