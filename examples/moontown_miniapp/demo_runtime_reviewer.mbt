///|
fn reviewer_runtime() -> @bunnia.WechatRuntime {
  @bunnia.wechat_runtime(initial_data_json=reviewer_initial_data_json(), event_patches=[
    @bunnia.wechat_event_patch("load-admin-ops", []),
    @bunnia.wechat_event_patch("load-admin-readiness", []),
    @bunnia.wechat_event_patch("tab-my", [
      @bunnia.set_string("shell.activeTab", "my"),
    ]),
  ])
}

///|
fn reviewer_initial_data_json() -> String {
  "{\"backendBaseUrl\":\"\{local_backend_base_url()}\",\"bunniaSessionId\":\"\",\"backendStatus\":{},\"adminOpsQuery\":{},\"adminReadinessQuery\":{},\"reviewer\":{\"mode\":\"open\"},\"shell\":{\"activeTab\":\"reviewer\"}}"
}
