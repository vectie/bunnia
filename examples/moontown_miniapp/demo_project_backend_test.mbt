///|
test "moontown generated project keeps backend request contract and hidden runtime labels" {
  let project = demo_wechat_project()
  assert_true(
    file_content(project.files, "bunnia.backend.js").contains(
      "/miniapp/buildings/query",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.backend.js").contains(
      "/miniapp/me/profile",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.backend.js").contains(
      "/miniapp/me/ownership",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.backend.js").contains(
      "/miniapp/discover/search",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.backend.js").contains(
      "/miniapp/messages/center",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.backend.js").contains(
      "/miniapp/messages/subscribe",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.backend.js").contains(
      "/miniapp/messages/send",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.backend.js").contains(
      "/miniapp/moderation/report",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.backend.js").contains(
      "/miniapp/moderation/hide",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.backend.js").contains(
      "/miniapp/moderation/takedown",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.backend.js").contains(
      "/miniapp/moderation/appeal",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.backend.js").contains(
      "/miniapp/admin/ops",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.backend.js").contains(
      "/miniapp/admin/readiness",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.backend.js").contains(
      "/miniapp/buildings/publish",
    ),
  )
  assert_true(
    !file_content(project.files, "bunnia.backend.js").contains(
      "/miniapp/buildings/share",
    ),
  )
  assert_true(
    !file_content(project.files, "bunnia.backend.js").contains(
      "/miniapp/buildings/update",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.backend.js").contains(
      "/miniapp/buildings/submit",
    ),
  )
  assert_true(
    !file_content(project.files, "bunnia.backend.js").contains(
      "/miniapp/buildings/archive",
    ),
  )
  assert_true(
    !file_content(project.files, "bunnia.backend.js").contains(
      "/miniapp/buildings/restore",
    ),
  )
  assert_true(
    backend_contract_contains(
      demo_backend_contract(),
      "share-private-building",
      "/miniapp/buildings/share",
    ),
  )
  assert_true(
    backend_contract_contains(
      demo_backend_contract(),
      "update-private-building",
      "/miniapp/buildings/update",
    ),
  )
  assert_true(
    backend_contract_contains(
      demo_backend_contract(),
      "archive-private-building",
      "/miniapp/buildings/archive",
    ),
  )
  assert_true(
    backend_contract_contains(
      demo_backend_contract(),
      "restore-archived-building",
      "/miniapp/buildings/restore",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.backend.js").contains(
      "/miniapp/reviews/accept",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.backend.js").contains(
      "/miniapp/reviews/reject",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.backend.js").contains(
      "x-miniapp-session",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.backend.js").contains("bunniaSessionId"),
  )
  assert_true(
    file_content(project.files, "pages/moontown/index.data.js").contains(
      "\"shell\":{\"activeTab\":\"realm\"",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/index.data.js").contains(
      "\"backendBaseUrl\":\"http://127.0.0.1:18191\"",
    ),
  )
  assert_true(
    file_content(project.files, "pages/moontown/index.data.js").contains(
      "\"backendStatus\":{}",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.backend.js").contains(
      "backendStatus.' + String(endpointId).replace",
    ),
  )
  assert_true(
    file_content(project.files, "bunnia.backend.js").contains(
      "__bs(loading, endpointId, 'loading', '')",
    ),
  )
  assert_true(
    project.page.js.contains(
      "__bunniaMaybeRequest(this,message,event.currentTarget.dataset||{})",
    ),
  )
  assert_true(
    project.page.js.contains(
      "const { __bunniaBackend, __bunniaRequest, __bunniaRetryRequest, __bk }",
    ),
  )
  assert_true(project.page.js.contains("Object.assign({},p.data[e.p]||{})"))
  assert_true(project.page.js.contains("__bk.map(k=>"))
  assert_true(
    project.page.js.contains("d[k]!==undefined&&d[k]!==''&&(b[k]=d[k],h=1)"),
  )
}
