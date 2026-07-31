///|
fn backend_feedback(
  feedback_key : String,
  loading_text : String,
  ready_text : String,
  failed_text : String,
) -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-backend-feedback"),
      @bunnia.attr("wx:if", "{{ui.feedback == '\{feedback_key}'}}"),
    ],
    [
      @bunnia.view_with_attrs(
        [
          @bunnia.class_name("mt-meta bunnia-status-running"),
          @bunnia.attr("wx:if", "{{requestState.state == 'loading'}}"),
        ],
        [@bunnia.text(loading_text)],
      ),
      @bunnia.view_with_attrs(
        [
          @bunnia.class_name("mt-meta bunnia-status-stable"),
          @bunnia.attr("wx:if", "{{requestState.state == 'ready'}}"),
        ],
        [@bunnia.text(ready_text)],
      ),
      @bunnia.view_with_attrs(
        [
          @bunnia.class_name("mt-meta bunnia-status-failed"),
          @bunnia.attr("wx:if", "{{requestState.state == 'failed'}}"),
        ],
        [@bunnia.text(failed_text)],
      ),
    ],
  )
}

///|
fn global_request_feedback() -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-request-feedback")], [
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("moontown-request-failure bunnia-status-failed"),
        @bunnia.attr("wx:if", "{{requestState.state == 'failed'}}"),
      ],
      [
        @bunnia.text(
          "Something did not save. Check your connection and try again.",
        ),
      ],
    ),
  ])
}
