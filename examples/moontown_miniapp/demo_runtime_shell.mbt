///|
fn add_shell_event_patches(
  patches : Array[@bunnia.WechatEventPatch],
  projection : MiniTownProjection,
) -> Unit {
  patches.push(@bunnia.wechat_event_patch("load-town-snapshot", []))
  patches.push(
    @bunnia.wechat_event_patch("complete-onboarding", [
      @bunnia.set_string("shell.onboardingCompleted", "true"),
    ]),
  )
  for tab in projection.tabs {
    patches.push(
      @bunnia.wechat_event_patch("tab-\{tab.id}", [
        @bunnia.set_string("shell.activeTab", tab.id),
      ]),
    )
  }
}

///|
fn add_setup_event_patches(
  patches : Array[@bunnia.WechatEventPatch],
  projection : MiniTownProjection,
) -> Unit {
  patches.push(
    @bunnia.wechat_event_patch("enter-town", [
      @bunnia.set_string("session.activeUserId", "user-a"),
    ]),
  )
  patches.push(
    @bunnia.wechat_event_patch("accept-profile-consent", [
      @bunnia.set_string("profile.consentAccepted", "true"),
      @bunnia.set_json("profileDraft.consentAccepted", "true"),
    ]),
  )
  patches.push(
    @bunnia.wechat_event_patch("save-profile", [
      @bunnia.set_string("profile.setupCompleted", "true"),
    ]),
  )
  for role in projection.roles {
    patches.push(
      @bunnia.wechat_event_patch("select-role-\{role.id}", [
        @bunnia.set_string("profile.roleId", role.id),
        @bunnia.set_string("profileDraft.roleId", role.id),
      ]),
    )
  }
}
