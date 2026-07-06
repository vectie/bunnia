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
  examples : Array[String]
  snapshot_dir : String
  step_count : Int
  steps : Array[CiPlanStep]
  summary : String
} derive(Debug, Eq)

///|
pub fn ci_plan(
  target? : String = "wechat",
  budget_profile? : String = "tight",
  examples? : Array[String] = ["agent_map", "wenyu_overview"],
  snapshot_dir? : String = "_build/bunnia/snapshots",
) -> CiPlan {
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
  for example in examples {
    steps.push(
      ci_step(
        "build-\{example}",
        "moon run cmd/main -- build --target \{target} --example \{example} --strict --budget \{budget_profile}",
        "strict generated-output budget gate for \{example}",
      ),
    )
    steps.push(
      ci_step(
        "snapshot-\{example}",
        "moon run cmd/main -- snapshot --target \{target} --example \{example} --snapshot-out \{snapshot_dir}/\{target}/\{example}.snapshot.txt --strict --budget \{budget_profile}",
        "deterministic generated-output snapshot for \{example}",
      ),
    )
  }
  {
    target,
    budget_profile,
    examples,
    snapshot_dir,
    step_count: steps.length(),
    steps,
    summary: "Bunnia CI plan: target=\{target} budget=\{budget_profile} examples=\{examples.length()} steps=\{steps.length()} snapshot_dir=\{snapshot_dir}",
  }
}

///|
fn ci_step(name : String, command : String, purpose : String) -> CiPlanStep {
  { name, command, purpose }
}
