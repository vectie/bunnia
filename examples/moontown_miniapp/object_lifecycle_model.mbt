///|
priv struct ObjectLifecycleStage {
  id : String
  label : String
  status : String
}

///|
fn object_lifecycle_stage(
  id~ : String,
  label~ : String,
  status~ : String,
) -> ObjectLifecycleStage {
  { id, label, status }
}
