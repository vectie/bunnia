///|
fn available_run_actions(run : MiniTownRun) -> Array[MiniTownRunAction] {
  let actions : Array[MiniTownRunAction] = []
  for action in run_actions(run) {
    if action.allowed {
      actions.push(action)
    }
  }
  actions
}

///|
fn run_action_class(action : MiniTownRunAction) -> String {
  if action.id == "review-accept" || action.id == "retry" {
    "moontown-run-action moontown-primary-action"
  } else if action.id == "review-reject" || action.id == "cancel" {
    "moontown-run-action moontown-danger-action"
  } else {
    "moontown-run-action moontown-secondary-action"
  }
}
