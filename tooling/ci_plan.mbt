///|
pub struct CiPlanStep {
  name : String
  command : String
  purpose : String
} derive(Debug, Eq)

///|
pub struct CiPlan {
  target : String
  budget_profile : String
  render_budget_profile : String
  inspection_max_route_risk_score : Int
  inspection_max_scene_assets : Int
  inspection_max_scene_remote_assets : Int
  inspection_gate_summary : String
  examples : Array[String]
  snapshot_dir : String
  step_count : Int
  steps : Array[CiPlanStep]
  diagnostics : Array[String]
  summary : String
} derive(Debug, Eq)

///|
pub fn ci_plan(
  target? : String = "wechat",
  budget_profile? : String = "tight",
  render_budget_profile? : String = "",
  examples? : Array[String] = ["agent_map", "wenyu_overview"],
  snapshot_dir? : String = "_build/bunnia/snapshots",
) -> CiPlan {
  let active_render_budget_profile = if render_budget_profile == "" {
    budget_profile
  } else {
    render_budget_profile
  }
  let diagnostics = ci_plan_diagnostics(
    target, budget_profile, active_render_budget_profile,
  )
  let inspection_budget = ci_plan_inspection_budget(budget_profile)
  let inspection_gate_summary = "Bunnia CI inspection gate: budget=\{budget_profile} max_route_risk=\{inspection_budget.max_route_risk_score} max_scene_assets=\{inspection_budget.max_scene_assets} max_scene_remote_assets=\{inspection_budget.max_scene_remote_assets}"
  let steps : Array[CiPlanStep] = []
  steps.push(ci_step("check", "moon check", "type-check every package"))
  steps.push(ci_step("test", "moon test", "run framework and example tests"))
  steps.push(ci_step("info", "moon info", "regenerate public interface files"))
  steps.push(ci_step("fmt", "moon fmt", "format MoonBit source files"))
  steps.push(
    ci_step("diff-check", "git diff --check", "reject whitespace regressions"),
  )
  steps.push(
    ci_step(
      "diff-clean", "git diff --exit-code", "reject uncommitted interface or formatting changes",
    ),
  )
  steps.push(
    ci_step(
      "limits",
      "moon run cmd/main -- limits --target \{target}",
      "inspect platform component mappings and capability limits",
    ),
  )
  for example in examples {
    steps.push(
      ci_step(
        "inspect-\{example}",
        "moon run cmd/main -- inspect --target \{target} --example \{example} --strict --budget \{budget_profile} --render-budget \{active_render_budget_profile}",
        "route-risk and generated-pressure inspection for \{example}",
      ),
    )
    steps.push(
      ci_step(
        "build-\{example}",
        "moon run cmd/main -- build --target \{target} --example \{example} --strict --budget \{budget_profile} --render-budget \{active_render_budget_profile}",
        "strict generated-output budget gate for \{example}",
      ),
    )
    steps.push(
      ci_step(
        "snapshot-\{example}",
        "moon run cmd/main -- snapshot --target \{target} --example \{example} --snapshot-out \{snapshot_dir}/\{target}/\{example}.snapshot.txt --strict --budget \{budget_profile} --render-budget \{active_render_budget_profile}",
        "deterministic generated-output snapshot for \{example}",
      ),
    )
  }
  {
    target,
    budget_profile,
    render_budget_profile: active_render_budget_profile,
    inspection_max_route_risk_score: inspection_budget.max_route_risk_score,
    inspection_max_scene_assets: inspection_budget.max_scene_assets,
    inspection_max_scene_remote_assets: inspection_budget.max_scene_remote_assets,
    inspection_gate_summary,
    examples,
    snapshot_dir,
    step_count: steps.length(),
    steps,
    diagnostics,
    summary: "Bunnia CI plan: target=\{target} budget=\{budget_profile} render_budget=\{active_render_budget_profile} inspection_max_route_risk=\{inspection_budget.max_route_risk_score} inspection_max_scene_assets=\{inspection_budget.max_scene_assets} inspection_max_scene_remote_assets=\{inspection_budget.max_scene_remote_assets} examples=\{examples.length()} steps=\{steps.length()} diagnostics=\{diagnostics.length()} snapshot_dir=\{snapshot_dir}",
  }
}

///|
fn ci_plan_inspection_budget(name : String) -> ProjectInspectionBudget {
  if is_named_budget_profile(name) {
    inspection_budget_for_profile(name)
  } else {
    inspection_budget_for_profile("default")
  }
}

///|
fn ci_plan_diagnostics(
  target : String,
  budget_profile : String,
  render_budget_profile : String,
) -> Array[String] {
  let output : Array[String] = []
  if target != "wechat" {
    output.push("ci-target-unsupported:\{target}")
  }
  if !is_named_budget_profile(budget_profile) {
    output.push("ci-budget-profile-unknown:\{budget_profile}")
  }
  if !is_named_budget_profile(render_budget_profile) {
    output.push("ci-render-budget-profile-unknown:\{render_budget_profile}")
  }
  output
}

///|
fn ci_step(name : String, command : String, purpose : String) -> CiPlanStep {
  { name, command, purpose }
}
