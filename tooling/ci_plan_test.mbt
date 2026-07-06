///|
test "ci plan lists active checks and generator snapshots" {
  let plan = ci_plan()
  assert_eq(plan.target, "wechat")
  assert_eq(plan.target_known, true)
  assert_eq(plan.target_generator_status_id, "available")
  assert_eq(plan.target_generator_available, true)
  assert_eq(plan.budget_profile, "tight")
  assert_eq(plan.render_budget_profile, "tight")
  assert_eq(plan.inspection_max_route_risk_score, 50000)
  assert_eq(plan.inspection_max_backend_events, 16)
  assert_eq(plan.inspection_max_backend_streams, 4)
  assert_eq(plan.inspection_max_backend_reviews, 8)
  assert_eq(plan.inspection_max_backend_cancels, 8)
  assert_eq(plan.inspection_max_backend_retries, 8)
  assert_eq(plan.inspection_max_scene_assets, 16)
  assert_eq(plan.inspection_max_scene_remote_assets, 4)
  assert_eq(plan.profile_max_agent_duplicate_stream_chunks, 0)
  assert_eq(plan.profile_max_snapshot_full_replaces, 0)
  assert_eq(plan.profile_max_scene_thread_orphans, 0)
  assert_eq(plan.profile_max_scene_camera_clamped, 0)
  assert_eq(plan.profile_max_scene_surface_fallbacks, 0)
  assert_eq(plan.profile_max_scene_quality_issues, 0)
  assert_eq(plan.profile_max_degraded_scenes, 0)
  assert_eq(plan.examples.length(), 2)
  assert_eq(plan.step_count, 13)
  assert_eq(plan.diagnostics.length(), 0)
  assert_eq(plan.steps[0].name, "check")
  assert_eq(plan.steps[0].command, "moon check")
  assert_eq(plan.steps[1].command, "moon test")
  assert_eq(plan.steps[2].command, "moon info")
  assert_eq(plan.steps[3].command, "moon fmt")
  assert_eq(plan.steps[5].command, "git diff --exit-code")
  assert_eq(
    plan.steps[6].command,
    "moon run cmd/main -- limits --target wechat",
  )
  assert_true(plan.steps[7].command.contains("inspect --target wechat"))
  assert_true(plan.steps[7].command.contains("--budget tight"))
  assert_true(plan.steps[7].command.contains("--render-budget tight"))
  assert_true(plan.steps[8].command.contains("--example agent_map"))
  assert_true(plan.steps[9].command.contains("agent_map.snapshot.txt"))
  assert_true(plan.steps[9].command.contains("--render-budget tight"))
  assert_true(plan.steps[10].command.contains("inspect --target wechat"))
  assert_true(plan.steps[10].command.contains("--example wenyu_overview"))
  assert_true(plan.steps[12].command.contains("wenyu_overview.snapshot.txt"))
  assert_true(plan.summary.contains("examples=2"))
  assert_true(plan.summary.contains("target_generator_status=available"))
  assert_true(plan.summary.contains("target_generator=true"))
  assert_true(plan.summary.contains("render_budget=tight"))
  assert_true(plan.summary.contains("inspection_max_route_risk=50000"))
  assert_true(plan.summary.contains("inspection_max_backend_events=16"))
  assert_true(plan.summary.contains("inspection_max_backend_cancels=8"))
  assert_true(plan.summary.contains("inspection_max_backend_retries=8"))
  assert_true(plan.summary.contains("inspection_max_scene_assets=16"))
  assert_true(plan.summary.contains("profile_max_snapshot_full_replaces=0"))
  assert_true(plan.summary.contains("profile_max_scene_surface_fallbacks=0"))
  assert_true(plan.summary.contains("profile_max_scene_quality_issues=0"))
  assert_true(plan.summary.contains("diagnostics=0"))
  assert_true(plan.summary.contains("steps=13"))
  assert_true(plan.inspection_gate_summary.contains("budget=tight"))
  assert_true(plan.inspection_gate_summary.contains("max_route_risk=50000"))
  assert_true(plan.inspection_gate_summary.contains("max_backend_streams=4"))
  assert_true(plan.profile_gate_summary.contains("budget=tight"))
  assert_true(
    plan.profile_gate_summary.contains("max_snapshot_full_replaces=0"),
  )
  assert_true(
    plan.profile_gate_summary.contains("max_scene_surface_fallbacks=0"),
  )
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
  assert_eq(plan.step_count, 10)
  assert_eq(plan.target_generator_status_id, "available")
  assert_eq(plan.target_generator_available, true)
  assert_eq(plan.examples.length(), 1)
  assert_eq(plan.diagnostics.length(), 0)
  assert_eq(plan.inspection_max_route_risk_score, 1000)
  assert_eq(plan.inspection_max_backend_events, 0)
  assert_eq(plan.inspection_max_backend_streams, 0)
  assert_eq(plan.inspection_max_backend_reviews, 0)
  assert_eq(plan.inspection_max_backend_cancels, 0)
  assert_eq(plan.inspection_max_backend_retries, 0)
  assert_eq(plan.inspection_max_scene_assets, 0)
  assert_eq(plan.inspection_max_scene_remote_assets, 0)
  assert_eq(plan.profile_max_snapshot_full_replaces, 0)
  assert_eq(plan.profile_max_scene_surface_fallbacks, 0)
  assert_true(plan.summary.contains("budget=tiny"))
  assert_true(plan.summary.contains("render_budget=tight"))
  assert_true(plan.summary.contains("inspection_max_route_risk=1000"))
  assert_true(plan.summary.contains("inspection_max_backend_events=0"))
  assert_true(plan.summary.contains("profile_max_degraded_scenes=0"))
  assert_true(
    plan.steps[7].command.contains(
      "moon run cmd/main -- inspect --target wechat --example agent_map --strict --budget tiny --render-budget tight",
    ),
  )
  assert_true(
    plan.steps[8].command.contains(
      "moon run cmd/main -- build --target wechat --example agent_map --strict --budget tiny --render-budget tight",
    ),
  )
  assert_true(
    plan.steps[9].command.contains(
      "--snapshot-out /tmp/bunnia-ci/wechat/agent_map.snapshot.txt",
    ),
  )
  assert_true(plan.steps[9].command.contains("--render-budget tight"))
}

///|
test "ci plan shell script is deterministic and runnable" {
  let plan = ci_plan(examples=["agent_map"])
  let script = ci_plan_shell_script(plan)
  assert_true(script.has_prefix("#!/usr/bin/env sh\nset -eu\n"))
  assert_true(script.contains("# Generated by Bunnia ci-plan --script."))
  assert_true(script.contains("# Bunnia CI profile gate: budget=tight"))
  assert_true(script.contains("printf '%s\\n' \"==> check\""))
  assert_true(script.contains("# type-check every package\nmoon check\n"))
  assert_true(script.contains("moon run cmd/main -- limits --target wechat"))
  assert_true(
    script.contains(
      "moon run cmd/main -- snapshot --target wechat --example agent_map --snapshot-out _build/bunnia/snapshots/wechat/agent_map.snapshot.txt --strict --budget tight --render-budget tight",
    ),
  )
  assert_true(!script.contains("exit 1"))
}

///|
test "ci plan shell script exits before bad workflow commands" {
  let plan = ci_plan(target="alipay", budget_profile="oversized", examples=[
    "agent_map",
  ])
  let script = ci_plan_shell_script(plan)
  assert_true(script.contains("Bunnia CI plan diagnostics:"))
  assert_eq(plan.target_known, true)
  assert_eq(plan.target_generator_status_id, "deferred")
  assert_eq(plan.target_generator_available, false)
  assert_true(script.contains("ci-platform-generator-deferred:alipay"))
  assert_true(script.contains("ci-budget-profile-unknown:oversized"))
  assert_true(script.contains("exit 1\n"))
  assert_true(!script.contains("moon run cmd/main -- build --target alipay"))
}

///|
test "ci plan diagnoses unknown budget profiles" {
  let plan = ci_plan(
    target="alipay",
    budget_profile="oversized",
    render_budget_profile="microscopic",
    examples=["agent_map"],
  )
  assert_eq(plan.diagnostics.length(), 3)
  assert_eq(plan.target_known, true)
  assert_eq(plan.target_generator_status_id, "deferred")
  assert_eq(plan.target_generator_available, false)
  assert_true(
    plan.diagnostics.contains("ci-platform-generator-deferred:alipay"),
  )
  assert_true(plan.diagnostics.contains("ci-budget-profile-unknown:oversized"))
  assert_true(
    plan.diagnostics.contains("ci-render-budget-profile-unknown:microscopic"),
  )
  assert_true(plan.summary.contains("diagnostics=3"))
  assert_true(plan.summary.contains("target_generator_status=deferred"))
  assert_true(plan.summary.contains("target_generator=false"))
  assert_eq(plan.inspection_max_route_risk_score, 250000)
  assert_eq(plan.inspection_max_backend_events, 64)
  assert_eq(plan.profile_max_snapshot_full_replaces, 1)
  assert_eq(plan.profile_max_scene_surface_fallbacks, 4)
  assert_true(plan.inspection_gate_summary.contains("budget=oversized"))
  assert_true(plan.profile_gate_summary.contains("budget=oversized"))
}

///|
test "ci plan distinguishes unknown targets from deferred generators" {
  let plan = ci_plan(target="unknown-mini", examples=["agent_map"])
  assert_eq(plan.target_known, false)
  assert_eq(plan.target_generator_status_id, "unknown")
  assert_eq(plan.target_generator_available, false)
  assert_true(
    plan.diagnostics.contains("ci-platform-target-unknown:unknown-mini"),
  )
  assert_true(plan.summary.contains("target_generator_status=unknown"))
}
