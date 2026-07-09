///|
fn scoped_project_page_runtime(
  page : @bunnia.WechatProjectPage,
) -> @bunnia.WechatProjectPage {
  let runtime = @bunnia.wechat_runtime(
    initial_data_json=page.runtime.initial_data_json,
    event_patches=scoped_event_patches(
      page.runtime.event_patches,
      page.page.plan.event_messages,
    ),
    page_methods_js=page.runtime.page_methods_js,
  )
  @bunnia.wechat_project_page_with_runtime(page, runtime)
}

///|
fn scoped_event_patches(
  patches : Array[@bunnia.WechatEventPatch],
  messages : Array[String],
) -> Array[@bunnia.WechatEventPatch] {
  let output : Array[@bunnia.WechatEventPatch] = []
  for message in messages {
    output.push(scoped_event_patch(patches, message))
  }
  output
}

///|
fn scoped_event_patch(
  patches : Array[@bunnia.WechatEventPatch],
  message : String,
) -> @bunnia.WechatEventPatch {
  for patch in patches {
    if patch.message == message {
      return patch
    }
  }
  @bunnia.wechat_event_patch(message, [])
}
