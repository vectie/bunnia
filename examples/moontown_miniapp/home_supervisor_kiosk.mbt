///|
fn supervisor_registration_kiosk(
  projection : MiniTownProjection,
) -> @bunnia.Node {
  let setup = projection.supervisor_setup
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("mt-panel moontown-registration-kiosk"),
      @bunnia.data("setup-surface", "supervisor-registration"),
      @bunnia.attr("wx:if", "{{!supervisorSetup.activated}}"),
    ],
    [
      supervisor_kiosk_header(setup),
      supervisor_setup_state_notice(),
      supervisor_identity_step(setup),
      supervisor_purpose_step(setup),
      supervisor_binding_step(setup),
      supervisor_readiness_step(setup),
      supervisor_activation_step(),
    ],
  )
}

///|
fn supervisor_kiosk_header(setup : MiniTownSupervisorSetup) -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-kiosk-header")], [
    @bunnia.view_with_attrs([@bunnia.class_name("moontown-kiosk-sign")], [
      @bunnia.text("FIRST VISIT · REGISTRATION KIOSK"),
    ]),
    @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-title")], [
      @bunnia.text("Create your town supervisor"),
    ]),
    @bunnia.view_with_attrs([@bunnia.class_name("mt-panel-note")], [
      @bunnia.text(
        "Choose who leads your work. You can review every setting before activation.",
      ),
    ]),
    @bunnia.view_with_attrs([@bunnia.class_name("moontown-kiosk-progress")], [
      setup_progress_stop("identity", "1", "Identity", setup.current_step),
      setup_progress_stop("purpose", "2", "Purpose", setup.current_step),
      setup_progress_stop("binding", "3", "Place", setup.current_step),
      setup_progress_stop("review", "4", "Review", setup.current_step),
      setup_progress_stop("activate", "5", "Activate", setup.current_step),
    ]),
  ])
}

///|
fn setup_progress_stop(
  id : String,
  number : String,
  label : String,
  current_step : String,
) -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name(
        if id == current_step {
          "moontown-kiosk-progress-stop active"
        } else {
          "moontown-kiosk-progress-stop"
        },
      ),
      @bunnia.data("setup-step", id),
    ],
    [
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-kiosk-step-number")],
        [@bunnia.text(number)],
      ),
      @bunnia.text(label),
    ],
  )
}

///|
fn supervisor_setup_state_notice() -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-setup-state-stack"),
      @bunnia.attr("aria-live", "polite"),
    ],
    [
      setup_state_row(
        "loading", "Loading your saved kiosk draft…", "{{supervisorSetup.state == 'loading' || (ui.feedback == 'supervisor-load' && requestState.state == 'loading')}}",
      ),
      setup_state_row(
        "empty", "No saved draft yet. Start with a name and portrait.", "{{supervisorSetup.state == 'empty' || (ui.feedback == 'supervisor-load' && requestState.state == 'ready' && !onboardingSnapshot.draft)}}",
      ),
      setup_state_row(
        "error", "The draft could not be loaded. Your local entries are still here.",
        "{{supervisorSetup.state == 'error' || (ui.feedback == 'supervisor-load' && requestState.state == 'failed')}}",
      ),
      @bunnia.view_with_attrs(
        [
          @bunnia.class_name("moontown-setup-state conflict"),
          @bunnia.attr("role", "alert"),
          @bunnia.attr(
            "wx:if", "{{supervisorSetup.state == 'conflict' || (ui.feedback == 'supervisor-save' && requestState.statusCode == 409)}}",
          ),
        ],
        [
          @bunnia.text("A newer draft exists. Reload it before saving again."),
          @bunnia.button("Reload Draft", "load-supervisor-setup"),
        ],
      ),
      setup_state_row(
        "saved", "Draft saved. You can safely leave and resume later.", "{{supervisorSetup.state == 'saved' || (ui.feedback == 'supervisor-save' && requestState.state == 'ready')}}",
      ),
    ],
  )
}

///|
fn setup_state_row(
  state : String,
  copy : String,
  visibility : String,
) -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-setup-state \{state}"),
      @bunnia.attr("wx:if", visibility),
    ],
    [@bunnia.text(copy)],
  )
}

///|
fn supervisor_identity_step(setup : MiniTownSupervisorSetup) -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-kiosk-step"),
      @bunnia.attr("wx:if", "{{supervisorSetup.currentStep == 'identity'}}"),
    ],
    [
      setup_step_heading(
        "1 · Identity", "Give your supervisor a recognizable town presence.",
      ),
      setup_field_label("Supervisor name"),
      setup_bound_input(
        name="supervisorName",
        value="{{supervisorDraft.name}}",
        state_path="supervisorDraft.name",
        message="edit-supervisor-name",
      ),
      @bunnia.view_with_attrs([@bunnia.class_name("moontown-avatar-choices")], [
        setup_choice_button(
          id="otter-steward",
          label="Otter Steward",
          summary="Warm town guide",
          message="select-supervisor-avatar-otter",
          selected_expr="supervisorDraft.avatarRef == 'avatar://otter-steward'",
          state_path="supervisorDraft.avatarRef",
          state_value="avatar://otter-steward",
          preview_src=supervisor_avatar_asset_src(),
        ),
        setup_choice_button(
          id="moon-lantern",
          label="Moon Lantern",
          summary="Quiet night operator",
          message="select-supervisor-avatar-lantern",
          selected_expr="supervisorDraft.avatarRef == 'avatar://moon-lantern'",
          state_path="supervisorDraft.avatarRef",
          state_value="avatar://moon-lantern",
          preview_src=supervisor_avatar_asset_src(),
        ),
      ]),
      setup_choice_grid("Archetype", setup.archetypes, "archetype"),
      setup_step_actions("", "Continue", "setup-step-purpose"),
    ],
  )
}

///|
fn supervisor_purpose_step(setup : MiniTownSupervisorSetup) -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-kiosk-step"),
      @bunnia.attr("wx:if", "{{supervisorSetup.currentStep == 'purpose'}}"),
    ],
    [
      setup_step_heading(
        "2 · Mission & manner", "Set the durable brief, voice, and first capability set.",
      ),
      setup_field_label("Mission"),
      setup_bound_input(
        name="mission",
        value="{{supervisorDraft.mission}}",
        state_path="supervisorDraft.mission",
        message="edit-supervisor-mission",
      ),
      setup_choice_grid("Tone", setup.tones, "tone"),
      setup_choice_grid(
        "Capabilities · choose up to 3",
        setup.capabilities,
        "capability",
      ),
      setup_step_actions("Back", "Continue", "setup-step-binding"),
    ],
  )
}

///|
fn supervisor_binding_step(_setup : MiniTownSupervisorSetup) -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-kiosk-step"),
      @bunnia.attr("wx:if", "{{supervisorSetup.currentStep == 'binding'}}"),
    ],
    [
      setup_step_heading(
        "3 · Bind a home", "MoonTown owns these links and can update them later.",
      ),
      @bunnia.view_with_attrs(
        [
          @bunnia.class_name("moontown-setup-state loading"),
          @bunnia.attr(
            "wx:if", "{{installedBookCatalog.state == 'loading' && backendStatus.load_book_registrations.state != 'failed' && backendStatus.load_book_registrations.state != 'timeout' && backendStatus.load_book_registrations.state != 'malformed'}}",
          ),
        ],
        [@bunnia.text("Loading installed MoonBooks from MoonTown…")],
      ),
      @bunnia.view_with_attrs(
        [
          @bunnia.class_name("moontown-kiosk-choice-grid"),
          @bunnia.attr("wx:for", "{{installedBookCatalog.books}}"),
          @bunnia.attr("wx:for-item", "book"),
          @bunnia.attr("wx:key", "id"),
        ],
        [
          @bunnia.node(
            kind="button",
            attrs=[
              @bunnia.class_name(
                "moontown-kiosk-choice {{supervisorDraft.bookId == book.id ? 'selected' : ''}}",
              ),
              @bunnia.data("book-id", "{{book.id}}"),
              @bunnia.data("bunnia-set-path", "supervisorDraft.bookId"),
              @bunnia.data("bunnia-set-value", "{{book.id}}"),
              @bunnia.attr(
                "aria-pressed", "{{supervisorDraft.bookId == book.id}}",
              ),
            ],
            events=[@bunnia.tap("select-supervisor-book")],
            children=[
              @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
                @bunnia.text("{{book.name}}"),
              ]),
              @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
                @bunnia.text("{{book.purpose}}"),
              ]),
              @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
                @bunnia.text("Installed book · {{book.id}}"),
              ]),
            ],
          ),
        ],
      ),
      @bunnia.view_with_attrs(
        [
          @bunnia.class_name("moontown-setup-state error"),
          @bunnia.attr(
            "wx:if", "{{installedBookCatalog.state == 'ready' && !installedBookCatalog.books.length}}",
          ),
        ],
        [
          @bunnia.text(
            "No installed MoonBook is available. Install or register one in MoonTown, then reload this list.",
          ),
          @bunnia.button("Reload installed books", "load-book-registrations"),
        ],
      ),
      @bunnia.view_with_attrs(
        [
          @bunnia.class_name("moontown-setup-state error"),
          @bunnia.attr(
            "wx:if", "{{backendStatus.load_book_registrations.state == 'failed' || backendStatus.load_book_registrations.state == 'timeout' || backendStatus.load_book_registrations.state == 'malformed'}}",
          ),
        ],
        [
          @bunnia.text(
            "MoonTown's installed-book list could not be loaded. No binding was guessed.",
          ),
          @bunnia.button("Try loading again", "load-book-registrations"),
        ],
      ),
      @bunnia.view_with_attrs([@bunnia.class_name("moontown-kiosk-callout")], [
        @bunnia.text(
          "The book stores only reviewed memory. Activation does not accept any proposal by itself.",
        ),
      ]),
      setup_step_actions("Back", "Continue", "setup-step-review"),
    ],
  )
}

///|
fn supervisor_readiness_step(_setup : MiniTownSupervisorSetup) -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-kiosk-step"),
      @bunnia.attr("wx:if", "{{supervisorSetup.currentStep == 'review'}}"),
    ],
    [
      setup_step_heading(
        "4 · Consent & readiness", "Review the supervisor passport before activation.",
      ),
      setup_review_row("Name", "{{supervisorDraft.name}}", "ready"),
      setup_review_row("Mission", "{{supervisorDraft.mission}}", "ready"),
      setup_review_row(
        "Installed MoonBook", "{{supervisorDraft.bookId || 'Not selected'}}", "ready",
      ),
      setup_review_row("Runtime model", "gpt-5.6-sol", "ready"),
      setup_review_row(
        "Worker ceiling", "3 active · reviewable · $2 · 5 min · 12K tokens · 3 artifacts · Web off",
        "ready",
      ),
      setup_consent_button(
        "control", "I can steer or stop supervisor work", "toggle-supervisor-control-consent",
      ),
      setup_consent_button(
        "bookkeeper", "I understand Bookkeeper reviews acceptance separately", "toggle-bookkeeper-consent",
      ),
      setup_consent_button(
        "terms", "I accept the current terms and authority ceiling", "toggle-supervisor-terms-consent",
      ),
      @bunnia.view_with_attrs([@bunnia.class_name("moontown-kiosk-actions")], [
        setup_nav_button("Back", "setup-step-binding", false),
        setup_save_draft_button(),
        @bunnia.node(
          kind="button",
          attrs=[
            @bunnia.class_name("moontown-primary-action"),
            @bunnia.data("bunnia-set-path", "supervisorSetup.currentStep"),
            @bunnia.data("bunnia-set-value", "activate"),
            @bunnia.attr(
              "disabled", "{{!supervisorDraft.bookId || installedBookCatalog.state != 'ready' || !(supervisorDraft.consentTermsAccepted && (supervisorDraft.authorityCeiling == 'suggest_only' || supervisorDraft.consentAgentControl) && (supervisorDraft.authorityCeiling != 'request_bookkeeper_review' || supervisorDraft.consentBookkeeperReview))}}",
            ),
          ],
          events=[@bunnia.tap("setup-step-activate")],
          children=[@bunnia.text("Review Activation")],
        ),
      ]),
    ],
  )
}

///|
fn supervisor_activation_step() -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-kiosk-step activation"),
      @bunnia.attr("wx:if", "{{supervisorSetup.currentStep == 'activate'}}"),
    ],
    [
      setup_step_heading(
        "5 · Activate", "MoonTown will save the profile, then hand an opaque version to MoonClaw.",
      ),
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-activation-seal")],
        [@bunnia.text("Ready to open the Supervisor Lodge")],
      ),
      @bunnia.view_with_attrs([@bunnia.class_name("moontown-kiosk-callout")], [
        @bunnia.text(
          "Activation starts the controllable supervisor. Any memory proposal remains pending until Bookkeeper decides.",
        ),
      ]),
      @bunnia.view_with_attrs([@bunnia.class_name("moontown-kiosk-callout")], [
        @bunnia.text(
          "Runtime policy: gpt-5.6-sol · up to 3 active workers. Each assignment shows its own finite budget before it is sent.",
        ),
      ]),
      @bunnia.view_with_attrs([@bunnia.class_name("moontown-kiosk-actions")], [
        setup_nav_button("Back", "setup-step-review", false),
        @bunnia.node(
          kind="button",
          attrs=[
            @bunnia.class_name("moontown-primary-action"),
            @bunnia.attr(
              "disabled", "{{!supervisorDraft.bookId || installedBookCatalog.state != 'ready'}}",
            ),
          ],
          events=[@bunnia.tap("activate-supervisor")],
          children=[@bunnia.text("Activate Supervisor")],
        ),
      ]),
      @bunnia.view_with_attrs(
        [
          @bunnia.class_name("moontown-setup-state loading"),
          @bunnia.attr(
            "wx:if", "{{ui.feedback == 'supervisor-activate' && requestState.state == 'loading'}}",
          ),
        ],
        [@bunnia.text("Opening the lodge and starting the supervisor…")],
      ),
      @bunnia.view_with_attrs(
        [
          @bunnia.class_name("moontown-setup-state loading"),
          @bunnia.attr(
            "wx:if", "{{activationResult.runtimeStatus == 'pending_transport' || activationResult.runtime_status == 'pending_transport'}}",
          ),
        ],
        [
          @bunnia.text(
            "Profile saved. The runtime handoff is waiting for transport.",
          ),
        ],
      ),
      @bunnia.view_with_attrs(
        [
          @bunnia.class_name("moontown-setup-state loading"),
          @bunnia.attr(
            "wx:if", "{{activationResult.runtimeStatus == 'claimed' || activationResult.runtime_status == 'claimed'}}",
          ),
        ],
        [
          @bunnia.text(
            "MoonClaw claimed the activation command. Waiting for acknowledgement.",
          ),
        ],
      ),
      @bunnia.view_with_attrs(
        [
          @bunnia.class_name("moontown-setup-state saved"),
          @bunnia.attr(
            "wx:if", "{{activationResult.runtimeStatus == 'runtime_acknowledged' || activationResult.runtimeStatus == 'active' || activationResult.runtime_status == 'runtime_acknowledged' || activationResult.runtime_status == 'active'}}",
          ),
        ],
        [
          @bunnia.text(
            "Runtime acknowledged. Your supervisor is now controllable.",
          ),
        ],
      ),
      @bunnia.view_with_attrs(
        [
          @bunnia.class_name("moontown-setup-state error"),
          @bunnia.attr(
            "wx:if", "{{activationResult.runtimeStatus == 'failed' || activationResult.runtime_status == 'failed'}}",
          ),
        ],
        [
          @bunnia.text(
            "Runtime activation failed. Your saved profile is intact.",
          ),
          @bunnia.button("Retry Runtime Activation", "activate-supervisor"),
        ],
      ),
      @bunnia.view_with_attrs(
        [
          @bunnia.class_name("moontown-setup-state error"),
          @bunnia.attr(
            "wx:if", "{{ui.feedback == 'supervisor-activate' && requestState.state == 'failed'}}",
          ),
        ],
        [
          @bunnia.text("Activation did not finish. The saved draft is intact."),
          @bunnia.button("Try Activation Again", "activate-supervisor"),
        ],
      ),
    ],
  )
}

///|
fn setup_step_heading(title : String, note : String) -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-kiosk-step-heading")], [
    @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
      @bunnia.text(title),
    ]),
    @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
      @bunnia.text(note),
    ]),
  ])
}

///|
fn setup_field_label(label : String) -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-section-label")], [
    @bunnia.text(label),
  ])
}

///|
fn setup_bound_input(
  name~ : String,
  value~ : String,
  state_path~ : String,
  message~ : String,
) -> @bunnia.Node {
  @bunnia.node(
    kind="input",
    attrs=[
      @bunnia.attr("name", name),
      @bunnia.attr("value", value),
      @bunnia.data("bunnia-input-path", state_path),
      @bunnia.attr("aria-label", name),
    ],
    events=[@bunnia.event("input", message)],
    children=[],
  )
}

///|
fn setup_choice_grid(
  title : String,
  choices : Array[MiniTownSetupChoice],
  kind : String,
) -> @bunnia.Node {
  let choice_nodes : Array[@bunnia.Node] = []
  for choice in choices {
    choice_nodes.push(
      @bunnia.keyed(
        "supervisor-\{kind}-\{choice.id}",
        setup_choice_button(
          id=choice.id,
          label=choice.label,
          summary=choice.summary,
          message="select-supervisor-\{kind}-\{choice.id}",
          selected_expr=if kind == "capability" {
            "supervisorDraft.capabilityIds && supervisorDraft.capabilityIds.indexOf('\{choice.id}') >= 0"
          } else {
            "supervisorDraft.\{setup_choice_field(kind)} == '\{choice.id}'"
          },
          state_path="supervisorDraft.\{setup_choice_field(kind)}",
          state_value=setup_choice_value(kind, choice.id),
          state_json=kind == "capability",
        ),
      ),
    )
  }
  @bunnia.view_with_attrs(
    [@bunnia.class_name("moontown-kiosk-choice-section")],
    [
      @bunnia.view_with_attrs([@bunnia.class_name("moontown-section-label")], [
        @bunnia.text(title),
      ]),
      @bunnia.view_with_attrs(
        [@bunnia.class_name("moontown-kiosk-choice-grid")],
        choice_nodes,
      ),
    ],
  )
}

///|
fn setup_choice_value(kind : String, id : String) -> String {
  if kind == "capability" {
    if id == "research" {
      "[\"research\"]"
    } else if id == "planning" {
      "[\"research\",\"planning\"]"
    } else {
      "[\"research\",\"planning\",\"drafting\"]"
    }
  } else {
    id
  }
}

///|
fn setup_choice_field(kind : String) -> String {
  if kind == "archetype" {
    "archetypeId"
  } else if kind == "tone" {
    "toneId"
  } else {
    "capabilityIds"
  }
}

///|
fn setup_choice_button(
  id~ : String,
  label~ : String,
  summary~ : String,
  message~ : String,
  selected_expr~ : String,
  state_path~ : String,
  state_value~ : String,
  state_json? : Bool = false,
  preview_src? : String = "",
) -> @bunnia.Node {
  @bunnia.node(
    kind="button",
    attrs=[
      @bunnia.class_name(
        "moontown-kiosk-choice {{\{selected_expr} ? 'selected' : ''}}",
      ),
      @bunnia.data("choice-id", id),
      @bunnia.data("bunnia-set-path", state_path),
      @bunnia.data("bunnia-set-value", state_value),
      @bunnia.data("bunnia-set-json", if state_json { "true" } else { "false" }),
      @bunnia.attr("aria-pressed", "{{\{selected_expr}}}"),
    ],
    events=[@bunnia.tap(message)],
    children=[
      if preview_src.is_empty() {
        @bunnia.view([])
      } else {
        @bunnia.node(
          kind="image",
          attrs=[
            @bunnia.class_name("moontown-avatar-choice-preview"),
            @bunnia.attr("src", preview_src),
            @bunnia.attr("mode", "aspectFill"),
            @bunnia.attr("alt", label),
            @bunnia.data("asset-id", "moontown-supervisor-avatar"),
            @bunnia.data("asset-kind", "image"),
            @bunnia.data("asset-source", supervisor_avatar_asset_source()),
            @bunnia.data("asset-remote", "false"),
            @bunnia.data(
              "asset-bytes",
              supervisor_avatar_asset_bytes().to_string(),
            ),
          ],
          children=[],
        )
      },
      @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
        @bunnia.text(label),
      ]),
      @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
        @bunnia.text(summary),
      ]),
    ],
  )
}

///|
fn setup_review_row(
  label : String,
  value : String,
  status : String,
) -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [@bunnia.class_name("moontown-setup-review-row \{status}")],
    [
      @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
        @bunnia.text(label),
      ]),
      @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
        @bunnia.text(value),
      ]),
    ],
  )
}

///|
fn setup_consent_button(
  id : String,
  label : String,
  message : String,
) -> @bunnia.Node {
  let field = if id == "control" {
    "consentAgentControl"
  } else if id == "bookkeeper" {
    "consentBookkeeperReview"
  } else {
    "consentTermsAccepted"
  }
  @bunnia.node(
    kind="button",
    attrs=[
      @bunnia.class_name(
        "moontown-consent-row {{supervisorDraft.\{field} ? 'selected' : ''}}",
      ),
      @bunnia.data("consent-id", id),
      @bunnia.data("bunnia-set-path", "supervisorDraft.\{field}"),
      @bunnia.data("bunnia-set-value", "true"),
      @bunnia.data("bunnia-set-json", "true"),
      @bunnia.attr(
        "wx:if",
        if id == "control" {
          "{{supervisorDraft.authorityCeiling != 'suggest_only'}}"
        } else if id == "bookkeeper" {
          "{{supervisorDraft.authorityCeiling == 'request_bookkeeper_review'}}"
        } else {
          "{{true}}"
        },
      ),
    ],
    events=[@bunnia.tap(message)],
    children=[@bunnia.text(label)],
  )
}

///|
fn setup_step_actions(
  back_label : String,
  next_label : String,
  next_message : String,
) -> @bunnia.Node {
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-kiosk-actions")], [
    if back_label == "" {
      @bunnia.view([])
    } else {
      setup_nav_button(back_label, setup_back_message(next_message), false)
    },
    setup_save_draft_button(),
    setup_nav_button(next_label, next_message, true),
  ])
}

///|
fn setup_nav_button(
  label : String,
  message : String,
  primary : Bool,
) -> @bunnia.Node {
  let attrs = [
    @bunnia.class_name(if primary { "moontown-primary-action" } else { "" }),
    @bunnia.data("bunnia-set-path", "supervisorSetup.currentStep"),
    @bunnia.data("bunnia-set-value", setup_step_value(message)),
  ]
  if message == "setup-step-review" {
    attrs.push(
      @bunnia.attr(
        "disabled", "{{!supervisorDraft.bookId || installedBookCatalog.state != 'ready'}}",
      ),
    )
  }
  @bunnia.node(kind="button", attrs~, events=[@bunnia.tap(message)], children=[
    @bunnia.text(label),
  ])
}

///|
fn setup_save_draft_button() -> @bunnia.Node {
  @bunnia.node(
    kind="button",
    attrs=[
      @bunnia.attr(
        "disabled", "{{!supervisorDraft.bookId || installedBookCatalog.state != 'ready'}}",
      ),
    ],
    events=[@bunnia.tap("save-supervisor-draft")],
    children=[@bunnia.text("Save Draft")],
  )
}

///|
fn setup_step_value(message : String) -> String {
  if message == "setup-step-identity" {
    "identity"
  } else if message == "setup-step-purpose" {
    "purpose"
  } else if message == "setup-step-binding" {
    "binding"
  } else if message == "setup-step-review" {
    "review"
  } else {
    "activate"
  }
}

///|
fn setup_back_message(next_message : String) -> String {
  if next_message == "setup-step-binding" {
    "setup-step-identity"
  } else if next_message == "setup-step-review" {
    "setup-step-purpose"
  } else {
    "setup-step-binding"
  }
}
