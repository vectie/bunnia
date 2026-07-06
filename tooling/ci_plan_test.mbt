///|
test "ci plan lists active checks and generator snapshots" {
  let plan = ci_plan()
  assert_eq(plan.target, "wechat")
  assert_eq(plan.budget_profile, "tight")
  assert_eq(plan.render_budget_profile, "tight")
  assert_eq(plan.examples.length(), 2)
  assert_eq(plan.step_count, 10)
  assert_eq(plan.diagnostics.length(), 0)
  assert_eq(plan.steps[0].name, "check")
  assert_eq(plan.steps[0].command, "moon check")
  assert_eq(plan.steps[1].command, "moon test")
  assert_eq(plan.steps[2].command, "moon info")
  assert_eq(plan.steps[3].command, "moon fmt")
  assert_eq(plan.steps[5].command, "git diff --exit-code")
  assert_true(plan.steps[6].command.contains("--example agent_map"))
  assert_true(plan.steps[6].command.contains("--budget tight"))
  assert_true(plan.steps[6].command.contains("--render-budget tight"))
  assert_true(plan.steps[7].command.contains("agent_map.snapshot.txt"))
  assert_true(plan.steps[7].command.contains("--render-budget tight"))
  assert_true(plan.steps[8].command.contains("--example wenyu_overview"))
  assert_true(plan.steps[9].command.contains("wenyu_overview.snapshot.txt"))
  assert_true(plan.summary.contains("examples=2"))
  assert_true(plan.summary.contains("render_budget=tight"))
  assert_true(plan.summary.contains("diagnostics=0"))
  assert_true(plan.summary.contains("steps=10"))
}

///|
test "ci plan can target one example and custom budgets" {
  let plan = ci_plan(
    target="wechat",
    budget_profile="tiny",
    render_budget_profile="tight",
    examples=["agent_map"],
    snapshot_dir="/tmp/bunnia-ci",
  )
  assert_eq(plan.step_count, 8)
  assert_eq(plan.examples.length(), 1)
  assert_eq(plan.diagnostics.length(), 0)
  assert_true(plan.summary.contains("budget=tiny"))
  assert_true(plan.summary.contains("render_budget=tight"))
  assert_true(
    plan.steps[6].command.contains(
      "moon run cmd/main -- build --target wechat --example agent_map --strict --budget tiny --render-budget tight",
    ),
  )
  assert_true(
    plan.steps[7].command.contains(
      "--snapshot-out /tmp/bunnia-ci/wechat/agent_map.snapshot.txt",
    ),
  )
  assert_true(plan.steps[7].command.contains("--render-budget tight"))
}

///|
test "ci plan diagnoses unknown budget profiles" {
  let plan = ci_plan(
    budget_profile="oversized",
    render_budget_profile="microscopic",
    examples=["agent_map"],
  )
  assert_eq(plan.diagnostics.length(), 2)
  assert_true(plan.diagnostics.contains("ci-budget-profile-unknown:oversized"))
  assert_true(
    plan.diagnostics.contains("ci-render-budget-profile-unknown:microscopic"),
  )
  assert_true(plan.summary.contains("diagnostics=2"))
}
