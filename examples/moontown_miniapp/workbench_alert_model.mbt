///|
pub struct MiniTownWorkbenchAlert {
  id : String
  title : String
  summary : String
  target_ref : String
  severity : String
  action_label : String
  action_message : String
  status : String
} derive(Debug, Eq)

///|
pub fn mini_town_workbench_alert(
  id~ : String,
  title~ : String,
  summary~ : String,
  target_ref~ : String,
  severity~ : String,
  action_label~ : String,
  action_message~ : String,
  status~ : String,
) -> MiniTownWorkbenchAlert {
  {
    id,
    title,
    summary,
    target_ref,
    severity,
    action_label,
    action_message,
    status,
  }
}
