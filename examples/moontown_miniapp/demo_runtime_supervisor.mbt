///|
fn add_supervisor_setup_event_patches(
  patches : Array[@bunnia.WechatEventPatch],
  projection : MiniTownProjection,
) -> Unit {
  patches.push(
    @bunnia.wechat_event_patch("load-supervisor-setup", [
      @bunnia.set_string("ui.feedback", "supervisor-load"),
    ]),
  )
  patches.push(
    @bunnia.wechat_event_patch("load-book-registrations", [
      @bunnia.set_string("ui.feedback", "supervisor-books"),
    ]),
  )
  patches.push(@bunnia.wechat_event_patch("select-supervisor-book", []))
  patches.push(
    @bunnia.wechat_event_patch("save-supervisor-draft", [
      @bunnia.set_string("ui.feedback", "supervisor-save"),
    ]),
  )
  patches.push(
    @bunnia.wechat_event_patch("activate-supervisor", [
      @bunnia.set_string("ui.feedback", "supervisor-activate"),
    ]),
  )
  patches.push(
    @bunnia.wechat_event_patch("send-supervisor-message", [
      @bunnia.set_string("ui.feedback", "supervisor-message"),
    ]),
  )
  patches.push(
    @bunnia.wechat_event_patch("assign-worker", [
      @bunnia.set_string("ui.feedback", "delegate"),
    ]),
  )
  patches.push(
    @bunnia.wechat_event_patch("steer-run", [
      @bunnia.set_string("ui.feedback", "steer"),
    ]),
  )
  patches.push(
    @bunnia.wechat_event_patch("wake-supervisor", [
      @bunnia.set_string("ui.feedback", "supervisor-wake"),
    ]),
  )
  patches.push(
    @bunnia.wechat_event_patch("stop-supervisor", [
      @bunnia.set_string("ui.feedback", "supervisor-stop"),
    ]),
  )
  patches.push(
    @bunnia.wechat_event_patch("resume-supervisor", [
      @bunnia.set_string("ui.feedback", "supervisor-resume"),
    ]),
  )
  patches.push(
    @bunnia.wechat_event_patch("steer-child-run", [
      @bunnia.set_string("ui.feedback", "child-steer"),
    ]),
  )
  patches.push(
    @bunnia.wechat_event_patch("request-bookkeeper-review", [
      @bunnia.set_string("ui.feedback", "bookkeeper-review"),
    ]),
  )
  for step in ["identity", "purpose", "binding", "review", "activate"] {
    patches.push(@bunnia.wechat_event_patch("setup-step-\{step}", []))
  }
  patches.push(@bunnia.wechat_event_patch("select-supervisor-avatar-otter", []))
  patches.push(
    @bunnia.wechat_event_patch("select-supervisor-avatar-lantern", []),
  )
  for choice in projection.supervisor_setup.archetypes {
    patches.push(
      @bunnia.wechat_event_patch("select-supervisor-archetype-\{choice.id}", []),
    )
  }
  for choice in projection.supervisor_setup.tones {
    patches.push(
      @bunnia.wechat_event_patch("select-supervisor-tone-\{choice.id}", []),
    )
  }
  for choice in projection.supervisor_setup.capabilities {
    patches.push(
      @bunnia.wechat_event_patch("select-supervisor-capability-\{choice.id}", []),
    )
  }
  patches.push(
    @bunnia.wechat_event_patch("toggle-supervisor-control-consent", []),
  )
  patches.push(@bunnia.wechat_event_patch("toggle-bookkeeper-consent", []))
  patches.push(
    @bunnia.wechat_event_patch("toggle-supervisor-terms-consent", []),
  )
  patches.push(@bunnia.wechat_event_patch("edit-supervisor-name", []))
  patches.push(@bunnia.wechat_event_patch("edit-supervisor-mission", []))
  patches.push(@bunnia.wechat_event_patch("edit-supervisor-message", []))
  patches.push(@bunnia.wechat_event_patch("edit-run-guidance", []))
}
