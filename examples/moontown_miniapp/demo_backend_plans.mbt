///|
pub fn demo_backend_budget() -> @bunnia.BackendBudget {
  @bunnia.backend_budget(
    max_endpoints=32,
    max_streaming=4,
    max_review_required=18,
  )
}

///|
pub fn demo_backend_plan() -> @bunnia.BackendPlan {
  @bunnia.plan_backend_contract_with_budget(
    demo_backend_contract(),
    demo_backend_budget(),
  )
}

///|
pub fn demo_effect_plan() -> @bunnia.EffectPlan {
  @bunnia.plan_backend_effects_for_platform(
    demo_backend_contract(),
    @bunnia.wechat(),
  )
}
