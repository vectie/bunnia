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
