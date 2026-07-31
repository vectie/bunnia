///|
fn reviewer_runtime() -> @bunnia.WechatRuntime {
  @bunnia.wechat_runtime(initial_data_json=reviewer_initial_data_json(), event_patches=[
    @bunnia.wechat_event_patch("load-admin-ops", [
      @bunnia.set_string("ui.feedback", "safety"),
    ]),
    @bunnia.wechat_event_patch("load-admin-readiness", [
      @bunnia.set_string("ui.feedback", "readiness"),
    ]),
    @bunnia.wechat_event_patch("hide-public-building", [
      @bunnia.set_string("ui.feedback", "hide"),
    ]),
    @bunnia.wechat_event_patch("takedown-public-building", [
      @bunnia.set_string("ui.feedback", "takedown"),
    ]),
    @bunnia.wechat_event_patch("tab-my", [
      @bunnia.set_string("shell.activeTab", "my"),
    ]),
  ])
}

///|
fn reviewer_initial_data_json() -> String {
  "{\"backendBaseUrl\":\"\{local_backend_base_url()}\",\"bunniaSessionId\":\"\",\"backendStatus\":{},\"adminOpsQuery\":{},\"adminReadinessQuery\":{},\"reviewer\":{\"mode\":\"open\"},\"shell\":{\"activeTab\":\"reviewer\"}}"
}
