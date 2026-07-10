///|
fn onboarding_panel(_projection : MiniTownProjection) -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("mt-panel moontown-onboarding-compact"),
      @bunnia.attr("wx:if", "{{!bunniaSessionId}}"),
    ],
    [
      @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-title")], [
        @bunnia.text("Enter Moontown"),
      ]),
      @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-note")], [
        @bunnia.text("Start in Realm. Every destination stays one tap away."),
      ]),
      @bunnia.node(
        kind="button",
        attrs=[@bunnia.class_name("moontown-primary-action")],
        events=[@bunnia.tap("dev-login")],
        children=[@bunnia.text("Enter Town")],
      ),
    ],
  )
}

///|
