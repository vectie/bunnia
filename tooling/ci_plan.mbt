///|
pub struct CiPlanStep {
  name : String
  command : String
  purpose : String
} derive(Debug, Eq)

///|
pub struct CiPlan {
  target : String
  target_known : Bool
  target_generator_status_id : String
  target_generator_available : Bool
  budget_profile : String
  render_budget_profile : String
  inspection_max_route_risk_score : Int
  inspection_max_update_operations : Int
  inspection_max_backend_events : Int
  inspection_max_backend_streams : Int
  inspection_max_backend_reviews : Int
  inspection_max_backend_cancels : Int
  inspection_max_backend_retries : Int
  inspection_max_scene_assets : Int
  inspection_max_scene_remote_assets : Int
  inspection_max_scene_package_bytes : Int
  inspection_gate_summary : String
  profile_max_agent_duplicate_stream_chunks : Int
  profile_max_snapshot_full_replaces : Int
  profile_max_scene_thread_orphans : Int
  profile_max_scene_camera_clamped : Int
  profile_max_scene_surface_fallbacks : Int
  profile_max_scene_quality_issues : Int
  profile_max_degraded_scenes : Int
  profile_gate_summary : String
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
  examples? : Array[String] = ["agent_map"],
  snapshot_dir? : String = "_build/bunnia/snapshots",
) -> CiPlan {
  let active_render_budget_profile = if render_budget_profile == "" {
    budget_profile
  } else {
    render_budget_profile
  }
  let target_support = platform_target_support(target~)
  let diagnostics = ci_plan_diagnostics(
    target_support, budget_profile, active_render_budget_profile,
  )
  let inspection_budget = ci_plan_inspection_budget(budget_profile)
  let profile_budget = ci_plan_profile_budget(budget_profile)
  let inspection_gate_summary = "Bunnia CI inspection gate: budget=\{budget_profile} max_route_risk=\{inspection_budget.max_route_risk_score} max_update_ops=\{inspection_budget.max_update_operations} max_backend_events=\{inspection_budget.max_backend_events} max_backend_streams=\{inspection_budget.max_backend_streams} max_backend_reviews=\{inspection_budget.max_backend_reviews} max_backend_cancels=\{inspection_budget.max_backend_cancels} max_backend_retries=\{inspection_budget.max_backend_retries} max_scene_assets=\{inspection_budget.max_scene_assets} max_scene_remote_assets=\{inspection_budget.max_scene_remote_assets} max_scene_package_bytes=\{inspection_budget.max_scene_package_bytes}"
  let profile_gate_summary = "Bunnia CI profile gate: budget=\{budget_profile} max_agent_duplicate_stream_chunks=\{profile_budget.max_agent_duplicate_stream_chunks} max_snapshot_full_replaces=\{profile_budget.max_snapshot_full_replaces} max_scene_thread_orphans=\{profile_budget.max_scene_thread_orphans} max_scene_camera_clamped=\{profile_budget.max_scene_camera_clamped} max_scene_surface_fallbacks=\{profile_budget.max_scene_surface_fallbacks} max_scene_quality_issues=\{profile_budget.max_scene_quality_issues} max_degraded_scenes=\{profile_budget.max_degraded_scenes}"
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
      "boundary", "sh scripts/validate_boundaries.sh", "reject product-specific framework API or dependency leaks",
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
  steps.push(
    ci_step(
      "scaffold-smoke", "sh scripts/scaffold_smoke.sh", "generate and validate the standalone starter scaffold",
    ),
  )
  {
    target,
    target_known: target_support.known,
    target_generator_status_id: target_support.generator_status_id,
    target_generator_available: target_support.generator_available,
    budget_profile,
    render_budget_profile: active_render_budget_profile,
    inspection_max_route_risk_score: inspection_budget.max_route_risk_score,
    inspection_max_update_operations: inspection_budget.max_update_operations,
    inspection_max_backend_events: inspection_budget.max_backend_events,
    inspection_max_backend_streams: inspection_budget.max_backend_streams,
    inspection_max_backend_reviews: inspection_budget.max_backend_reviews,
    inspection_max_backend_cancels: inspection_budget.max_backend_cancels,
    inspection_max_backend_retries: inspection_budget.max_backend_retries,
    inspection_max_scene_assets: inspection_budget.max_scene_assets,
    inspection_max_scene_remote_assets: inspection_budget.max_scene_remote_assets,
    inspection_max_scene_package_bytes: inspection_budget.max_scene_package_bytes,
    inspection_gate_summary,
    profile_max_agent_duplicate_stream_chunks: profile_budget.max_agent_duplicate_stream_chunks,
    profile_max_snapshot_full_replaces: profile_budget.max_snapshot_full_replaces,
    profile_max_scene_thread_orphans: profile_budget.max_scene_thread_orphans,
    profile_max_scene_camera_clamped: profile_budget.max_scene_camera_clamped,
    profile_max_scene_surface_fallbacks: profile_budget.max_scene_surface_fallbacks,
    profile_max_scene_quality_issues: profile_budget.max_scene_quality_issues,
    profile_max_degraded_scenes: profile_budget.max_degraded_scenes,
    profile_gate_summary,
    examples,
    snapshot_dir,
    step_count: steps.length(),
    steps,
    diagnostics,
    summary: "Bunnia CI plan: target=\{target} target_generator_status=\{target_support.generator_status_id} target_generator=\{target_support.generator_available} budget=\{budget_profile} render_budget=\{active_render_budget_profile} inspection_max_route_risk=\{inspection_budget.max_route_risk_score} inspection_max_update_ops=\{inspection_budget.max_update_operations} inspection_max_backend_events=\{inspection_budget.max_backend_events} inspection_max_backend_streams=\{inspection_budget.max_backend_streams} inspection_max_backend_reviews=\{inspection_budget.max_backend_reviews} inspection_max_backend_cancels=\{inspection_budget.max_backend_cancels} inspection_max_backend_retries=\{inspection_budget.max_backend_retries} inspection_max_scene_assets=\{inspection_budget.max_scene_assets} inspection_max_scene_remote_assets=\{inspection_budget.max_scene_remote_assets} inspection_max_scene_package_bytes=\{inspection_budget.max_scene_package_bytes} profile_max_agent_duplicate_stream_chunks=\{profile_budget.max_agent_duplicate_stream_chunks} profile_max_snapshot_full_replaces=\{profile_budget.max_snapshot_full_replaces} profile_max_scene_surface_fallbacks=\{profile_budget.max_scene_surface_fallbacks} profile_max_scene_quality_issues=\{profile_budget.max_scene_quality_issues} profile_max_degraded_scenes=\{profile_budget.max_degraded_scenes} examples=\{examples.length()} steps=\{steps.length()} diagnostics=\{diagnostics.length()} snapshot_dir=\{snapshot_dir}",
  }
}

///|
pub fn ci_plan_shell_script(plan : CiPlan) -> String {
  let out = StringBuilder()
  out.write_string("#!/usr/bin/env sh\n")
  out.write_string("set -eu\n\n")
  out.write_string("# Generated by Bunnia ci-plan --script.\n")
  out.write_string("# \{plan.summary}\n")
  out.write_string("# \{plan.inspection_gate_summary}\n\n")
  out.write_string("# \{plan.profile_gate_summary}\n\n")
  if plan.diagnostics.length() > 0 {
    write_shell_echo(out, "Bunnia CI plan diagnostics:")
    for item in plan.diagnostics {
      write_shell_echo(out, item)
    }
    out.write_string("exit 1\n")
  } else {
    for step in plan.steps {
      write_shell_echo(out, "==> \{step.name}")
      out.write_string("# \{step.purpose}\n")
      out.write_string(step.command)
      out.write_string("\n\n")
    }
  }
  out.to_string()
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
fn ci_plan_profile_budget(name : String) -> BuildProfileBudget {
  if is_named_budget_profile(name) {
    build_profile_budget_for_profile(name)
  } else {
    build_profile_budget_for_profile("default")
  }
}

///|
fn ci_plan_diagnostics(
  target_support : PlatformTargetSupport,
  budget_profile : String,
  render_budget_profile : String,
) -> Array[String] {
  let output : Array[String] = []
  if !target_support.generator_available {
    for item in target_support.diagnostics {
      output.push("ci-\{item}")
    }
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

///|
fn write_shell_echo(out : StringBuilder, text : String) -> Unit {
  out.write_string("printf '%s\\n' ")
  write_shell_double_quoted(out, text)
  out.write_string("\n")
}

///|
fn write_shell_double_quoted(out : StringBuilder, text : String) -> Unit {
  out.write_string("\"")
  for i in 0..<text.length() {
    let code = text[i].to_int()
    if code == 34 {
      out.write_string("\\\"")
    } else if code == 36 {
      out.write_string("\\$")
    } else if code == 92 {
      out.write_string("\\\\")
    } else if code == 96 {
      out.write_string("\\`")
    } else {
      out.write_string(text.sub(start=i, end=i + 1).to_owned())
    }
  }
  out.write_string("\"")
}
