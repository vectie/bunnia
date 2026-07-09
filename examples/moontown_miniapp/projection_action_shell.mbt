///|
pub fn switch_mock_user(
  projection : MiniTownProjection,
  user_id : String,
) -> MiniTownProjection {
  let next = { ..projection, active_user_id: user_id }
  let visible = visible_buildings(next)
  if visible.length() == 0 {
    next
  } else {
    { ..next, selected_building_id: visible[0].id }
  }
}

///|
pub fn switch_tab(
  projection : MiniTownProjection,
  tab_id : String,
) -> MiniTownProjection {
  { ..projection, active_tab_id: tab_id }
}

///|
pub fn switch_discovery_filter(
  projection : MiniTownProjection,
  filter_id : String,
) -> MiniTownProjection {
  { ..projection, active_discovery_filter_id: filter_id }
}

///|
pub fn search_discovery(
  projection : MiniTownProjection,
  query : String,
) -> MiniTownProjection {
  { ..projection, search_query: query }
}

///|
pub fn switch_notification_channel(
  projection : MiniTownProjection,
  channel_id : String,
) -> MiniTownProjection {
  { ..projection, active_notification_channel_id: channel_id }
}

///|
pub fn complete_onboarding(
  projection : MiniTownProjection,
) -> MiniTownProjection {
  { ..projection, onboarding_completed: true }
}

///|
pub fn select_role(
  projection : MiniTownProjection,
  role_id : String,
) -> MiniTownProjection {
  { ..projection, role_id, profile: { ..projection.profile, role_id, } }
}

///|
pub fn accept_profile_consent(
  projection : MiniTownProjection,
) -> MiniTownProjection {
  { ..projection, profile: { ..projection.profile, consent_accepted: true } }
}

///|
pub fn complete_profile_setup(
  projection : MiniTownProjection,
) -> MiniTownProjection {
  { ..projection, profile: { ..projection.profile, setup_completed: true } }
}

///|
pub fn profile_ready_to_publish(projection : MiniTownProjection) -> Bool {
  projection.profile.setup_completed &&
  projection.profile.consent_accepted &&
  projection.profile.role_id != ""
}

///|
pub fn open_reviewer_tools(
  projection : MiniTownProjection,
) -> MiniTownProjection {
  { ..projection, reviewer_tools_open: true }
}

///|
pub fn close_reviewer_tools(
  projection : MiniTownProjection,
) -> MiniTownProjection {
  { ..projection, reviewer_tools_open: false }
}

///|
pub fn setup_gates(projection : MiniTownProjection) -> Array[MiniTownSetupGate] {
  [
    mini_town_setup_gate(
      id="session",
      label="Town Entry",
      summary=if projection.active_user_id == "" {
        "Enter town before private places and agent work can belong to you."
      } else {
        "Entered as \{projection.profile.display_name}."
      },
      action_label="Enter",
      action_message="dev-login",
      complete=projection.active_user_id != "",
    ),
    mini_town_setup_gate(
      id="onboarding",
      label="Town Intro",
      summary=if projection.onboarding_completed {
        "Realm intro is complete."
      } else {
        "Read the tile-town intro before entering public workflows."
      },
      action_label="Enter Realm",
      action_message="complete-onboarding",
      complete=projection.onboarding_completed,
    ),
    mini_town_setup_gate(
      id="role",
      label="Town Role",
      summary=if projection.profile.role_id == "" {
        "Choose how you show up in town."
      } else {
        "Role selected: \{town_profile_role_label(projection.profile.role_id)}."
      },
      action_label="Choose Role",
      action_message="select-role-builder",
      complete=projection.profile.role_id != "",
    ),
    mini_town_setup_gate(
      id="consent",
      label="Town Consent",
      summary=if projection.profile.consent_accepted {
        "Consent accepted for publishing and sharing."
      } else {
        "Accept consent before publishing or sharing town content."
      },
      action_label="Accept Consent",
      action_message="accept-profile-consent",
      complete=projection.profile.consent_accepted,
    ),
    mini_town_setup_gate(
      id="profile",
      label="Profile Details",
      summary=if projection.profile.setup_completed {
        "Profile setup is complete."
      } else {
        "Save profile details before public building actions."
      },
      action_label="Finish Profile",
      action_message="save-profile",
      complete=projection.profile.setup_completed,
    ),
    mini_town_setup_gate(
      id="publish-ready",
      label="Ready to Publish",
      summary=if profile_ready_to_publish(projection) {
        "Drafts can be submitted, shared, and published."
      } else {
        "Publishing stays blocked until role, consent, and profile are ready."
      },
      action_label=if profile_ready_to_publish(projection) {
        "Open Inventory"
      } else {
        "Finish Profile"
      },
      action_message="tab-my",
      complete=profile_ready_to_publish(projection),
    ),
  ]
}

///|
fn town_profile_role_label(role_id : String) -> String {
  if role_id == "builder" {
    "Builder"
  } else if role_id == "reviewer" {
    "Reviewer"
  } else if role_id == "walker" {
    "Walker"
  } else if role_id == "owner" {
    "Owner"
  } else {
    "Town member"
  }
}

///|
