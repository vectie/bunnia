#!/usr/bin/env sh
set -eu

forbidden='moontown|wenyu|mayor|civic[_ -]?building|moonbook|moonclaw|standing[_ -]?watch|town[_ -]?module'
stale_project='moon''mini'

if rg -n 'vectie/moontown' moon.mod moon.pkg core agent scene effects program adapters tooling bunnia.mbt pkg.generated.mbti; then
  printf '%s\n' 'boundary violation: framework packages must not depend on vectie/moontown'
  exit 1
fi

if rg -n -i "$forbidden" bunnia.mbt pkg.generated.mbti core agent scene effects program adapters tooling -g '*.mbt' -g '*.mbti' -g '!**/*_test.mbt' -g '!**/*_wbtest.mbt'; then
  printf '%s\n' 'boundary violation: product-specific nouns are only allowed in examples, docs, and CLI fixtures'
  exit 1
fi

if rg -n -i "$stale_project" . -g '!_build/**' -g '!.git/**'; then
  printf '%s\n' 'boundary violation: stale renamed-project references are not allowed in Bunnia source'
  exit 1
fi

projection_files='examples/moontown_miniapp/projection_schema.mbt examples/moontown_miniapp/projection_seed.mbt examples/moontown_miniapp/projection_visibility.mbt examples/moontown_miniapp/projection_lifecycle.mbt examples/moontown_miniapp/projection_discovery.mbt examples/moontown_miniapp/projection_actions.mbt examples/moontown_miniapp/projection_inventory.mbt examples/moontown_miniapp/projection_notifications.mbt'

inventory_files='examples/moontown_miniapp/projection_inventory_owned.mbt examples/moontown_miniapp/projection_inventory_stats.mbt examples/moontown_miniapp/projection_inventory_items.mbt examples/moontown_miniapp/projection_inventory_filters.mbt'

visibility_files='examples/moontown_miniapp/projection_visibility_access.mbt examples/moontown_miniapp/projection_visibility_collections.mbt examples/moontown_miniapp/projection_visibility_selection.mbt'

lifecycle_action_files='examples/moontown_miniapp/projection_lifecycle_action_rows.mbt examples/moontown_miniapp/projection_lifecycle_action_open.mbt examples/moontown_miniapp/projection_lifecycle_action_owner.mbt examples/moontown_miniapp/projection_lifecycle_action_reasons.mbt'

lifecycle_files="examples/moontown_miniapp/projection_lifecycle_actions.mbt $lifecycle_action_files examples/moontown_miniapp/projection_lifecycle_publication.mbt examples/moontown_miniapp/projection_lifecycle_agents.mbt"

schema_files='examples/moontown_miniapp/projection_schema_people.mbt examples/moontown_miniapp/projection_schema_content.mbt examples/moontown_miniapp/projection_schema_work.mbt examples/moontown_miniapp/projection_schema_actions.mbt examples/moontown_miniapp/projection_schema_shell.mbt examples/moontown_miniapp/projection_schema_attention.mbt examples/moontown_miniapp/projection_schema_discovery.mbt examples/moontown_miniapp/projection_schema_activity.mbt examples/moontown_miniapp/projection_schema_ownership.mbt examples/moontown_miniapp/projection_schema_backend.mbt examples/moontown_miniapp/projection_schema_projection.mbt'

seed_content_files='examples/moontown_miniapp/projection_seed_content_books.mbt examples/moontown_miniapp/projection_seed_content_activity.mbt examples/moontown_miniapp/projection_seed_content_discovery.mbt examples/moontown_miniapp/projection_seed_content_filters.mbt'

seed_shell_files='examples/moontown_miniapp/projection_seed_shell_roles.mbt examples/moontown_miniapp/projection_seed_shell_tabs.mbt examples/moontown_miniapp/projection_seed_shell_onboarding.mbt examples/moontown_miniapp/projection_seed_shell_districts.mbt examples/moontown_miniapp/projection_seed_shell_presence.mbt'

seed_backend_files='examples/moontown_miniapp/projection_seed_backend_steps.mbt examples/moontown_miniapp/projection_seed_backend_steps_core.mbt examples/moontown_miniapp/projection_seed_backend_steps_workflow.mbt examples/moontown_miniapp/projection_seed_backend_steps_admin.mbt examples/moontown_miniapp/projection_seed_backend_cache.mbt examples/moontown_miniapp/projection_seed_backend_local.mbt'

seed_files="examples/moontown_miniapp/projection_seed_core.mbt examples/moontown_miniapp/projection_seed_review.mbt examples/moontown_miniapp/projection_seed_content.mbt $seed_content_files examples/moontown_miniapp/projection_seed_shell.mbt $seed_shell_files examples/moontown_miniapp/projection_seed_attention.mbt examples/moontown_miniapp/projection_seed_backend.mbt $seed_backend_files examples/moontown_miniapp/projection_seed_places.mbt"

lifecycle_helper_files='examples/moontown_miniapp/projection_action_lifecycle_helper_projection.mbt examples/moontown_miniapp/projection_action_lifecycle_helper_buildings.mbt examples/moontown_miniapp/projection_action_lifecycle_helper_books.mbt examples/moontown_miniapp/projection_action_lifecycle_helper_audit.mbt'

action_files="examples/moontown_miniapp/projection_action_shell.mbt examples/moontown_miniapp/projection_action_buildings.mbt examples/moontown_miniapp/projection_action_lifecycle_helpers.mbt $lifecycle_helper_files examples/moontown_miniapp/projection_action_agents.mbt examples/moontown_miniapp/projection_action_reviews.mbt"

building_action_files='examples/moontown_miniapp/projection_action_building_drafts.mbt examples/moontown_miniapp/projection_action_building_lifecycle.mbt examples/moontown_miniapp/projection_action_building_messages.mbt examples/moontown_miniapp/projection_action_building_placement.mbt'

demo_project_files='examples/moontown_miniapp/demo_project_views.mbt examples/moontown_miniapp/demo_project_pages.mbt examples/moontown_miniapp/demo_project_routes.mbt examples/moontown_miniapp/demo_project_runtime.mbt examples/moontown_miniapp/demo_project_tabs.mbt'

demo_plan_files='examples/moontown_miniapp/demo_patch_plans.mbt examples/moontown_miniapp/demo_agent_plans.mbt examples/moontown_miniapp/demo_backend_contract.mbt examples/moontown_miniapp/demo_backend_plans.mbt'

app_shell_files="examples/moontown_miniapp/demo_project.mbt $demo_project_files examples/moontown_miniapp/demo_runtime.mbt examples/moontown_miniapp/demo_plans.mbt $demo_plan_files examples/moontown_miniapp/demo_scene.mbt examples/moontown_miniapp/demo_adapters.mbt examples/moontown_miniapp/town_shell.mbt examples/moontown_miniapp/town_navigation.mbt examples/moontown_miniapp/home_onboarding.mbt examples/moontown_miniapp/home_districts.mbt examples/moontown_miniapp/home_pulse.mbt"

home_pulse_files='examples/moontown_miniapp/home_pulse_model.mbt examples/moontown_miniapp/home_pulse_panel.mbt examples/moontown_miniapp/home_pulse_rows.mbt examples/moontown_miniapp/home_pulse_summaries.mbt'

home_district_files='examples/moontown_miniapp/home_district_panels.mbt examples/moontown_miniapp/home_district_actions.mbt examples/moontown_miniapp/home_district_rows.mbt examples/moontown_miniapp/home_district_presence.mbt'

runtime_files='examples/moontown_miniapp/demo_runtime_shell.mbt examples/moontown_miniapp/demo_runtime_filters.mbt examples/moontown_miniapp/demo_runtime_buildings.mbt examples/moontown_miniapp/demo_runtime_reviewer.mbt examples/moontown_miniapp/demo_runtime_map.mbt'

generated_page_test_files='examples/moontown_miniapp/demo_page_map_test.mbt examples/moontown_miniapp/demo_page_drawer_test.mbt examples/moontown_miniapp/demo_page_lifecycle_test.mbt examples/moontown_miniapp/demo_page_visual_test.mbt examples/moontown_miniapp/demo_page_runtime_test.mbt'

moontown_test_files="examples/moontown_miniapp/demo_page_test.mbt $generated_page_test_files examples/moontown_miniapp/demo_tabs_test.mbt examples/moontown_miniapp/demo_tab_realm_home_test.mbt examples/moontown_miniapp/demo_tab_discover_test.mbt examples/moontown_miniapp/demo_tab_messages_test.mbt examples/moontown_miniapp/demo_tab_my_test.mbt examples/moontown_miniapp/demo_tab_reviewer_test.mbt examples/moontown_miniapp/demo_project_test.mbt examples/moontown_miniapp/demo_project_shell_test.mbt examples/moontown_miniapp/demo_project_routes_test.mbt examples/moontown_miniapp/demo_project_backend_test.mbt examples/moontown_miniapp/demo_project_seed_data_test.mbt examples/moontown_miniapp/demo_project_manifest_test.mbt examples/moontown_miniapp/demo_projection_flows_test.mbt examples/moontown_miniapp/demo_projection_shell_test.mbt examples/moontown_miniapp/demo_projection_attention_work_test.mbt examples/moontown_miniapp/demo_projection_discovery_inventory_test.mbt examples/moontown_miniapp/demo_projection_review_readiness_test.mbt examples/moontown_miniapp/demo_projection_building_lifecycle_test.mbt examples/moontown_miniapp/demo_projection_agent_work_test.mbt examples/moontown_miniapp/demo_pressure_test.mbt examples/moontown_miniapp/demo_test_helpers_test.mbt"

my_workbench_files='examples/moontown_miniapp/my_passport.mbt examples/moontown_miniapp/my_lifecycle.mbt examples/moontown_miniapp/my_tools.mbt examples/moontown_miniapp/my_public_passport.mbt examples/moontown_miniapp/my_inventory_rows.mbt examples/moontown_miniapp/my_inventory_shelves.mbt examples/moontown_miniapp/workbench_alerts.mbt'

my_passport_files='examples/moontown_miniapp/my_passport_panel.mbt examples/moontown_miniapp/my_passport_setup.mbt examples/moontown_miniapp/my_passport_identity.mbt examples/moontown_miniapp/my_passport_metrics.mbt'

my_inventory_shelf_files='examples/moontown_miniapp/my_inventory_shelf_model.mbt examples/moontown_miniapp/my_inventory_shelf_panel.mbt examples/moontown_miniapp/my_inventory_shelf_rows.mbt'

my_public_passport_files='examples/moontown_miniapp/my_public_passport_panel.mbt examples/moontown_miniapp/my_public_passport_items.mbt examples/moontown_miniapp/my_public_passport_rows.mbt examples/moontown_miniapp/my_public_passport_credential.mbt'

workbench_alert_files='examples/moontown_miniapp/workbench_alert_model.mbt examples/moontown_miniapp/workbench_alert_derivation.mbt examples/moontown_miniapp/workbench_alert_filters.mbt examples/moontown_miniapp/workbench_alert_rows.mbt'

discovery_projection_files='examples/moontown_miniapp/projection_discovery_results.mbt examples/moontown_miniapp/projection_discovery_activity.mbt examples/moontown_miniapp/projection_discovery_work.mbt examples/moontown_miniapp/projection_discovery_pulse.mbt'

discover_market_files='examples/moontown_miniapp/discover_market_lists.mbt examples/moontown_miniapp/discover_market_entries.mbt examples/moontown_miniapp/discover_market_actions.mbt'

realm_map_files='examples/moontown_miniapp/realm_map_backdrop.mbt examples/moontown_miniapp/realm_map_markers.mbt examples/moontown_miniapp/realm_map_hud.mbt'

object_drawer_files='examples/moontown_miniapp/object_drawer_shell.mbt examples/moontown_miniapp/object_drawer_header.mbt examples/moontown_miniapp/object_drawer_primitives.mbt examples/moontown_miniapp/object_drawer_labels.mbt examples/moontown_miniapp/object_drawer_actions.mbt'

object_context_files='examples/moontown_miniapp/object_context_model.mbt examples/moontown_miniapp/object_context_section.mbt examples/moontown_miniapp/object_context_cards.mbt examples/moontown_miniapp/object_context_helpers.mbt'

object_lifecycle_files='examples/moontown_miniapp/object_lifecycle_model.mbt examples/moontown_miniapp/object_lifecycle_section.mbt examples/moontown_miniapp/object_lifecycle_stages.mbt examples/moontown_miniapp/object_lifecycle_actions.mbt'

book_shelf_files='examples/moontown_miniapp/book_shelf_model.mbt examples/moontown_miniapp/book_shelf_items.mbt examples/moontown_miniapp/book_shelf_lookup.mbt examples/moontown_miniapp/book_shelf_copy.mbt'

object_worker_files='examples/moontown_miniapp/object_worker_section.mbt examples/moontown_miniapp/object_worker_rows.mbt examples/moontown_miniapp/object_worker_runs.mbt examples/moontown_miniapp/object_worker_labels.mbt'

object_memory_files='examples/moontown_miniapp/object_memory_section.mbt examples/moontown_miniapp/object_memory_rows.mbt examples/moontown_miniapp/object_memory_labels.mbt examples/moontown_miniapp/object_memory_actions.mbt'

display_copy_files='examples/moontown_miniapp/display_copy_counts.mbt examples/moontown_miniapp/display_copy_status.mbt examples/moontown_miniapp/display_copy_kind.mbt examples/moontown_miniapp/display_copy_navigation.mbt'

message_surface_files='examples/moontown_miniapp/message_attention.mbt examples/moontown_miniapp/message_buckets.mbt examples/moontown_miniapp/message_channels.mbt examples/moontown_miniapp/message_context.mbt examples/moontown_miniapp/message_notices.mbt examples/moontown_miniapp/message_results.mbt examples/moontown_miniapp/message_reviews.mbt examples/moontown_miniapp/message_work.mbt'

message_attention_files='examples/moontown_miniapp/message_attention_model.mbt examples/moontown_miniapp/message_attention_panel.mbt examples/moontown_miniapp/message_attention_rows.mbt examples/moontown_miniapp/message_attention_render.mbt'

reviewer_diagnostics_files='examples/moontown_miniapp/reviewer_diagnostics_operations.mbt examples/moontown_miniapp/reviewer_diagnostics_sections.mbt examples/moontown_miniapp/reviewer_diagnostics_moderation.mbt examples/moontown_miniapp/reviewer_diagnostics_developer.mbt examples/moontown_miniapp/reviewer_diagnostics_backend.mbt'

visual_tile_files='examples/moontown_miniapp/visual_tile_source.mbt examples/moontown_miniapp/visual_tile_reviewer.mbt examples/moontown_miniapp/visual_tile_base.mbt examples/moontown_miniapp/visual_tile_map.mbt examples/moontown_miniapp/visual_tile_shell.mbt examples/moontown_miniapp/visual_tile_primitives.mbt examples/moontown_miniapp/visual_tile_state.mbt examples/moontown_miniapp/visual_tile_content.mbt examples/moontown_miniapp/visual_tile_drawers.mbt examples/moontown_miniapp/visual_tile_responsive.mbt examples/moontown_miniapp/visual_tile_selectors.mbt'

for required in $projection_files; do
  if [ ! -f "$required" ]; then
    printf '%s\n' "boundary violation: missing Moontown projection boundary file $required"
    exit 1
  fi
done

for required in $inventory_files; do
  if [ ! -f "$required" ]; then
    printf '%s\n' "boundary violation: missing Moontown inventory projection file $required"
    exit 1
  fi
done

for required in $visibility_files; do
  if [ ! -f "$required" ]; then
    printf '%s\n' "boundary violation: missing Moontown visibility projection file $required"
    exit 1
  fi
done

for required in $lifecycle_files; do
  if [ ! -f "$required" ]; then
    printf '%s\n' "boundary violation: missing Moontown lifecycle projection file $required"
    exit 1
  fi
done

for required in $lifecycle_action_files; do
  if [ ! -f "$required" ]; then
    printf '%s\n' "boundary violation: missing Moontown lifecycle action file $required"
    exit 1
  fi
done

for required in $schema_files; do
  if [ ! -f "$required" ]; then
    printf '%s\n' "boundary violation: missing Moontown schema domain file $required"
    exit 1
  fi
done

for required in $seed_files; do
  if [ ! -f "$required" ]; then
    printf '%s\n' "boundary violation: missing Moontown seeded-data file $required"
    exit 1
  fi
done

for required in $seed_content_files; do
  if [ ! -f "$required" ]; then
    printf '%s\n' "boundary violation: missing Moontown seeded content file $required"
    exit 1
  fi
done

for required in $seed_shell_files; do
  if [ ! -f "$required" ]; then
    printf '%s\n' "boundary violation: missing Moontown seeded shell file $required"
    exit 1
  fi
done

for required in $seed_backend_files; do
  if [ ! -f "$required" ]; then
    printf '%s\n' "boundary violation: missing Moontown seeded backend file $required"
    exit 1
  fi
done

for required in $action_files; do
  if [ ! -f "$required" ]; then
    printf '%s\n' "boundary violation: missing Moontown action workflow file $required"
    exit 1
  fi
done

for required in $lifecycle_helper_files; do
  if [ ! -f "$required" ]; then
    printf '%s\n' "boundary violation: missing Moontown lifecycle helper file $required"
    exit 1
  fi
done

for required in $building_action_files; do
  if [ ! -f "$required" ]; then
    printf '%s\n' "boundary violation: missing Moontown building action workflow file $required"
    exit 1
  fi
done

for required in $app_shell_files; do
  if [ ! -f "$required" ]; then
    printf '%s\n' "boundary violation: missing Moontown app-shell boundary file $required"
    exit 1
  fi
done

for required in $demo_project_files; do
  if [ ! -f "$required" ]; then
    printf '%s\n' "boundary violation: missing Moontown demo project file $required"
    exit 1
  fi
done

for required in $demo_plan_files; do
  if [ ! -f "$required" ]; then
    printf '%s\n' "boundary violation: missing Moontown demo plan file $required"
    exit 1
  fi
done

for required in $home_pulse_files; do
  if [ ! -f "$required" ]; then
    printf '%s\n' "boundary violation: missing Moontown Home Pulse file $required"
    exit 1
  fi
done

for required in $home_district_files; do
  if [ ! -f "$required" ]; then
    printf '%s\n' "boundary violation: missing Moontown District Gates file $required"
    exit 1
  fi
done

for required in $runtime_files; do
  if [ ! -f "$required" ]; then
    printf '%s\n' "boundary violation: missing Moontown runtime boundary file $required"
    exit 1
  fi
done

for required in $moontown_test_files; do
  if [ ! -f "$required" ]; then
    printf '%s\n' "boundary violation: missing Moontown focused test file $required"
    exit 1
  fi
done

for required in $generated_page_test_files; do
  if [ ! -f "$required" ]; then
    printf '%s\n' "boundary violation: missing Moontown generated page test file $required"
    exit 1
  fi
done

for required in $my_workbench_files; do
  if [ ! -f "$required" ]; then
    printf '%s\n' "boundary violation: missing Moontown My workbench file $required"
    exit 1
  fi
done

for required in $my_passport_files; do
  if [ ! -f "$required" ]; then
    printf '%s\n' "boundary violation: missing Moontown Town Passport file $required"
    exit 1
  fi
done

for required in $my_inventory_shelf_files; do
  if [ ! -f "$required" ]; then
    printf '%s\n' "boundary violation: missing Moontown My Inventory shelf file $required"
    exit 1
  fi
done

for required in $my_public_passport_files; do
  if [ ! -f "$required" ]; then
    printf '%s\n' "boundary violation: missing Moontown Public Passport file $required"
    exit 1
  fi
done

for required in $workbench_alert_files; do
  if [ ! -f "$required" ]; then
    printf '%s\n' "boundary violation: missing Moontown Workbench alert file $required"
    exit 1
  fi
done

for required in $discovery_projection_files; do
  if [ ! -f "$required" ]; then
    printf '%s\n' "boundary violation: missing Moontown Discover projection file $required"
    exit 1
  fi
done

for required in $discover_market_files; do
  if [ ! -f "$required" ]; then
    printf '%s\n' "boundary violation: missing Moontown Discover market file $required"
    exit 1
  fi
done

for required in $realm_map_files; do
  if [ ! -f "$required" ]; then
    printf '%s\n' "boundary violation: missing Moontown Realm map file $required"
    exit 1
  fi
done

for required in $object_drawer_files; do
  if [ ! -f "$required" ]; then
    printf '%s\n' "boundary violation: missing Moontown object drawer file $required"
    exit 1
  fi
done

for required in $object_context_files; do
  if [ ! -f "$required" ]; then
    printf '%s\n' "boundary violation: missing Moontown object context file $required"
    exit 1
  fi
done

for required in $object_lifecycle_files; do
  if [ ! -f "$required" ]; then
    printf '%s\n' "boundary violation: missing Moontown object lifecycle file $required"
    exit 1
  fi
done

for required in $book_shelf_files; do
  if [ ! -f "$required" ]; then
    printf '%s\n' "boundary violation: missing Moontown book shelf file $required"
    exit 1
  fi
done

for required in $object_worker_files; do
  if [ ! -f "$required" ]; then
    printf '%s\n' "boundary violation: missing Moontown object worker file $required"
    exit 1
  fi
done

for required in $object_memory_files; do
  if [ ! -f "$required" ]; then
    printf '%s\n' "boundary violation: missing Moontown object memory file $required"
    exit 1
  fi
done

for required in $display_copy_files; do
  if [ ! -f "$required" ]; then
    printf '%s\n' "boundary violation: missing Moontown display-copy file $required"
    exit 1
  fi
done

for required in $message_surface_files; do
  if [ ! -f "$required" ]; then
    printf '%s\n' "boundary violation: missing Moontown Messages file $required"
    exit 1
  fi
done

for required in $message_attention_files; do
  if [ ! -f "$required" ]; then
    printf '%s\n' "boundary violation: missing Moontown Messages attention file $required"
    exit 1
  fi
done

for required in $reviewer_diagnostics_files; do
  if [ ! -f "$required" ]; then
    printf '%s\n' "boundary violation: missing Moontown reviewer diagnostics file $required"
    exit 1
  fi
done

for required in $visual_tile_files; do
  if [ ! -f "$required" ]; then
    printf '%s\n' "boundary violation: missing Moontown visual tile file $required"
    exit 1
  fi
done

projection_lines=$(wc -l < examples/moontown_miniapp/projection.mbt | tr -d ' ')
if [ "$projection_lines" -gt 80 ]; then
  printf '%s\n' "boundary violation: projection.mbt has $projection_lines lines; keep behavior in focused projection files"
  exit 1
fi

schema_lines=$(wc -l < examples/moontown_miniapp/projection_schema.mbt | tr -d ' ')
if [ "$schema_lines" -gt 80 ]; then
  printf '%s\n' "boundary violation: projection_schema.mbt has $schema_lines lines; keep schema declarations in focused domain files"
  exit 1
fi

seed_lines=$(wc -l < examples/moontown_miniapp/projection_seed.mbt | tr -d ' ')
if [ "$seed_lines" -gt 80 ]; then
  printf '%s\n' "boundary violation: projection_seed.mbt has $seed_lines lines; keep seeded data in focused seed files"
  exit 1
fi

seed_content_lines=$(wc -l < examples/moontown_miniapp/projection_seed_content.mbt | tr -d ' ')
if [ "$seed_content_lines" -gt 40 ]; then
  printf '%s\n' "boundary violation: projection_seed_content.mbt has $seed_content_lines lines; keep seeded content in focused projection_seed_content_* files"
  exit 1
fi

seed_shell_lines=$(wc -l < examples/moontown_miniapp/projection_seed_shell.mbt | tr -d ' ')
if [ "$seed_shell_lines" -gt 40 ]; then
  printf '%s\n' "boundary violation: projection_seed_shell.mbt has $seed_shell_lines lines; keep shell seed data in focused projection_seed_shell_* files"
  exit 1
fi

seed_backend_lines=$(wc -l < examples/moontown_miniapp/projection_seed_backend.mbt | tr -d ' ')
if [ "$seed_backend_lines" -gt 40 ]; then
  printf '%s\n' "boundary violation: projection_seed_backend.mbt has $seed_backend_lines lines; keep backend seed data in focused projection_seed_backend_* files"
  exit 1
fi

actions_lines=$(wc -l < examples/moontown_miniapp/projection_actions.mbt | tr -d ' ')
if [ "$actions_lines" -gt 80 ]; then
  printf '%s\n' "boundary violation: projection_actions.mbt has $actions_lines lines; keep action behavior in focused workflow files"
  exit 1
fi

building_actions_lines=$(wc -l < examples/moontown_miniapp/projection_action_buildings.mbt | tr -d ' ')
if [ "$building_actions_lines" -gt 80 ]; then
  printf '%s\n' "boundary violation: projection_action_buildings.mbt has $building_actions_lines lines; keep building action behavior in focused projection_action_building_* files"
  exit 1
fi

lifecycle_helpers_lines=$(wc -l < examples/moontown_miniapp/projection_action_lifecycle_helpers.mbt | tr -d ' ')
if [ "$lifecycle_helpers_lines" -gt 40 ]; then
  printf '%s\n' "boundary violation: projection_action_lifecycle_helpers.mbt has $lifecycle_helpers_lines lines; keep lifecycle helper behavior in focused projection_action_lifecycle_helper_* files"
  exit 1
fi

demo_lines=$(wc -l < examples/moontown_miniapp/demo.mbt | tr -d ' ')
if [ "$demo_lines" -gt 80 ]; then
  printf '%s\n' "boundary violation: demo.mbt has $demo_lines lines; keep app assembly in focused demo and town files"
  exit 1
fi

demo_project_lines=$(wc -l < examples/moontown_miniapp/demo_project.mbt | tr -d ' ')
if [ "$demo_project_lines" -gt 40 ]; then
  printf '%s\n' "boundary violation: demo_project.mbt has $demo_project_lines lines; keep generated-project assembly in focused demo_project_* files"
  exit 1
fi

demo_runtime_lines=$(wc -l < examples/moontown_miniapp/demo_runtime.mbt | tr -d ' ')
if [ "$demo_runtime_lines" -gt 80 ]; then
  printf '%s\n' "boundary violation: demo_runtime.mbt has $demo_runtime_lines lines; keep runtime behavior in focused demo_runtime_* files"
  exit 1
fi

demo_plans_lines=$(wc -l < examples/moontown_miniapp/demo_plans.mbt | tr -d ' ')
if [ "$demo_plans_lines" -gt 40 ]; then
  printf '%s\n' "boundary violation: demo_plans.mbt has $demo_plans_lines lines; keep plan assembly in focused demo_*_plans files"
  exit 1
fi

home_pulse_lines=$(wc -l < examples/moontown_miniapp/home_pulse.mbt | tr -d ' ')
if [ "$home_pulse_lines" -gt 80 ]; then
  printf '%s\n' "boundary violation: home_pulse.mbt has $home_pulse_lines lines; keep Town Pulse behavior in focused home_pulse_* files"
  exit 1
fi

home_district_lines=$(wc -l < examples/moontown_miniapp/home_districts.mbt | tr -d ' ')
if [ "$home_district_lines" -gt 40 ]; then
  printf '%s\n' "boundary violation: home_districts.mbt has $home_district_lines lines; keep District Gates behavior in focused home_district_* files"
  exit 1
fi

demo_test_lines=$(wc -l < examples/moontown_miniapp/demo_test.mbt | tr -d ' ')
if [ "$demo_test_lines" -gt 80 ]; then
  printf '%s\n' "boundary violation: demo_test.mbt has $demo_test_lines lines; keep coverage in focused test files"
  exit 1
fi

demo_page_test_lines=$(wc -l < examples/moontown_miniapp/demo_page_test.mbt | tr -d ' ')
if [ "$demo_page_test_lines" -gt 40 ]; then
  printf '%s\n' "boundary violation: demo_page_test.mbt has $demo_page_test_lines lines; keep generated page coverage in focused demo_page_*_test files"
  exit 1
fi

demo_project_test_lines=$(wc -l < examples/moontown_miniapp/demo_project_test.mbt | tr -d ' ')
if [ "$demo_project_test_lines" -gt 80 ]; then
  printf '%s\n' "boundary violation: demo_project_test.mbt has $demo_project_test_lines lines; keep generated-project coverage in focused demo_project_* files"
  exit 1
fi

my_workbench_lines=$(wc -l < examples/moontown_miniapp/my_workbench.mbt | tr -d ' ')
if [ "$my_workbench_lines" -gt 120 ]; then
  printf '%s\n' "boundary violation: my_workbench.mbt has $my_workbench_lines lines; keep My Inventory panels in focused files"
  exit 1
fi

my_passport_lines=$(wc -l < examples/moontown_miniapp/my_passport.mbt | tr -d ' ')
if [ "$my_passport_lines" -gt 40 ]; then
  printf '%s\n' "boundary violation: my_passport.mbt has $my_passport_lines lines; keep Town Passport behavior in focused my_passport_* files"
  exit 1
fi

my_inventory_shelves_lines=$(wc -l < examples/moontown_miniapp/my_inventory_shelves.mbt | tr -d ' ')
if [ "$my_inventory_shelves_lines" -gt 80 ]; then
  printf '%s\n' "boundary violation: my_inventory_shelves.mbt has $my_inventory_shelves_lines lines; keep shelf behavior in focused my_inventory_shelf_* files"
  exit 1
fi

my_public_passport_lines=$(wc -l < examples/moontown_miniapp/my_public_passport.mbt | tr -d ' ')
if [ "$my_public_passport_lines" -gt 80 ]; then
  printf '%s\n' "boundary violation: my_public_passport.mbt has $my_public_passport_lines lines; keep My public identity behavior in focused my_public_passport_* files"
  exit 1
fi

workbench_alert_lines=$(wc -l < examples/moontown_miniapp/workbench_alerts.mbt | tr -d ' ')
if [ "$workbench_alert_lines" -gt 80 ]; then
  printf '%s\n' "boundary violation: workbench_alerts.mbt has $workbench_alert_lines lines; keep My recovery alert behavior in focused workbench_alert_* files"
  exit 1
fi

projection_discovery_lines=$(wc -l < examples/moontown_miniapp/projection_discovery.mbt | tr -d ' ')
if [ "$projection_discovery_lines" -gt 80 ]; then
  printf '%s\n' "boundary violation: projection_discovery.mbt has $projection_discovery_lines lines; keep Discover projection behavior in focused files"
  exit 1
fi

discover_market_lines=$(wc -l < examples/moontown_miniapp/discover_market.mbt | tr -d ' ')
if [ "$discover_market_lines" -gt 120 ]; then
  printf '%s\n' "boundary violation: discover_market.mbt has $discover_market_lines lines; keep Market Board panels in focused files"
  exit 1
fi

realm_map_lines=$(wc -l < examples/moontown_miniapp/realm_map.mbt | tr -d ' ')
if [ "$realm_map_lines" -gt 120 ]; then
  printf '%s\n' "boundary violation: realm_map.mbt has $realm_map_lines lines; keep Realm map parts in focused files"
  exit 1
fi

object_drawer_lines=$(wc -l < examples/moontown_miniapp/object_drawer.mbt | tr -d ' ')
if [ "$object_drawer_lines" -gt 80 ]; then
  printf '%s\n' "boundary violation: object_drawer.mbt has $object_drawer_lines lines; keep selected-building drawer behavior in focused object_drawer_* files"
  exit 1
fi

messages_lines=$(wc -l < examples/moontown_miniapp/messages.mbt | tr -d ' ')
if [ "$messages_lines" -gt 120 ]; then
  printf '%s\n' "boundary violation: messages.mbt has $messages_lines lines; keep Messages panels in focused files"
  exit 1
fi

message_attention_lines=$(wc -l < examples/moontown_miniapp/message_attention.mbt | tr -d ' ')
if [ "$message_attention_lines" -gt 40 ]; then
  printf '%s\n' "boundary violation: message_attention.mbt has $message_attention_lines lines; keep attention behavior in focused message_attention_* files"
  exit 1
fi

object_context_lines=$(wc -l < examples/moontown_miniapp/object_context.mbt | tr -d ' ')
if [ "$object_context_lines" -gt 80 ]; then
  printf '%s\n' "boundary violation: object_context.mbt has $object_context_lines lines; keep communication context behavior in focused object_context_* files"
  exit 1
fi

object_lifecycle_lines=$(wc -l < examples/moontown_miniapp/object_lifecycle.mbt | tr -d ' ')
if [ "$object_lifecycle_lines" -gt 80 ]; then
  printf '%s\n' "boundary violation: object_lifecycle.mbt has $object_lifecycle_lines lines; keep lifecycle drawer behavior in focused object_lifecycle_* files"
  exit 1
fi

book_shelf_lines=$(wc -l < examples/moontown_miniapp/book_shelf.mbt | tr -d ' ')
if [ "$book_shelf_lines" -gt 40 ]; then
  printf '%s\n' "boundary violation: book_shelf.mbt has $book_shelf_lines lines; keep memory shelf behavior in focused book_shelf_* files"
  exit 1
fi

object_workers_lines=$(wc -l < examples/moontown_miniapp/object_workers.mbt | tr -d ' ')
if [ "$object_workers_lines" -gt 40 ]; then
  printf '%s\n' "boundary violation: object_workers.mbt has $object_workers_lines lines; keep worker drawer behavior in focused object_worker_* files"
  exit 1
fi

object_memory_lines=$(wc -l < examples/moontown_miniapp/object_memory.mbt | tr -d ' ')
if [ "$object_memory_lines" -gt 40 ]; then
  printf '%s\n' "boundary violation: object_memory.mbt has $object_memory_lines lines; keep memory drawer rendering in focused object_memory_* files"
  exit 1
fi

display_copy_lines=$(wc -l < examples/moontown_miniapp/display_copy.mbt | tr -d ' ')
if [ "$display_copy_lines" -gt 40 ]; then
  printf '%s\n' "boundary violation: display_copy.mbt has $display_copy_lines lines; keep ordinary labels in focused display_copy_* files"
  exit 1
fi

reviewer_diagnostics_lines=$(wc -l < examples/moontown_miniapp/reviewer_diagnostics.mbt | tr -d ' ')
if [ "$reviewer_diagnostics_lines" -gt 80 ]; then
  printf '%s\n' "boundary violation: reviewer_diagnostics.mbt has $reviewer_diagnostics_lines lines; keep reviewer diagnostics behavior in focused reviewer_diagnostics_* files"
  exit 1
fi

visual_tiles_lines=$(wc -l < examples/moontown_miniapp/visual_tiles.mbt | tr -d ' ')
if [ "$visual_tiles_lines" -gt 60 ]; then
  printf '%s\n' "boundary violation: visual_tiles.mbt has $visual_tiles_lines lines; keep tile WXSS chunks in focused visual_tile_* files"
  exit 1
fi

for focused_projection in $projection_files; do
  focused_lines=$(wc -l < "$focused_projection" | tr -d ' ')
  if [ "$focused_lines" -gt 1400 ]; then
    printf '%s\n' "boundary violation: $focused_projection has $focused_lines lines; split the projection concern further"
    exit 1
  fi
done

for focused_schema in $schema_files; do
  focused_lines=$(wc -l < "$focused_schema" | tr -d ' ')
  if [ "$focused_lines" -gt 500 ]; then
    printf '%s\n' "boundary violation: $focused_schema has $focused_lines lines; split the schema domain further"
    exit 1
  fi
done

for focused_seed in $seed_files; do
  focused_lines=$(wc -l < "$focused_seed" | tr -d ' ')
  if [ "$focused_lines" -gt 500 ]; then
    printf '%s\n' "boundary violation: $focused_seed has $focused_lines lines; split the seeded-data concern further"
    exit 1
  fi
done

for focused_seed_content in $seed_content_files; do
  focused_lines=$(wc -l < "$focused_seed_content" | tr -d ' ')
  if [ "$focused_lines" -gt 140 ]; then
    printf '%s\n' "boundary violation: $focused_seed_content has $focused_lines lines; split the seeded content concern further"
    exit 1
  fi
done

for focused_seed_shell in $seed_shell_files; do
  focused_lines=$(wc -l < "$focused_seed_shell" | tr -d ' ')
  if [ "$focused_lines" -gt 120 ]; then
    printf '%s\n' "boundary violation: $focused_seed_shell has $focused_lines lines; split the seeded shell concern further"
    exit 1
  fi
done

for focused_seed_backend in $seed_backend_files; do
  focused_lines=$(wc -l < "$focused_seed_backend" | tr -d ' ')
  if [ "$focused_lines" -gt 120 ]; then
    printf '%s\n' "boundary violation: $focused_seed_backend has $focused_lines lines; split the seeded backend concern further"
    exit 1
  fi
done

for focused_action in $action_files; do
  focused_lines=$(wc -l < "$focused_action" | tr -d ' ')
  if [ "$focused_lines" -gt 500 ]; then
    printf '%s\n' "boundary violation: $focused_action has $focused_lines lines; split the action workflow further"
    exit 1
  fi
done

for focused_lifecycle_helper in $lifecycle_helper_files; do
  focused_lines=$(wc -l < "$focused_lifecycle_helper" | tr -d ' ')
  if [ "$focused_lines" -gt 120 ]; then
    printf '%s\n' "boundary violation: $focused_lifecycle_helper has $focused_lines lines; split the lifecycle helper concern further"
    exit 1
  fi
done

for focused_building_action in $building_action_files; do
  focused_lines=$(wc -l < "$focused_building_action" | tr -d ' ')
  if [ "$focused_lines" -gt 180 ]; then
    printf '%s\n' "boundary violation: $focused_building_action has $focused_lines lines; split the building action workflow further"
    exit 1
  fi
done

for focused_app_shell in $app_shell_files; do
  focused_lines=$(wc -l < "$focused_app_shell" | tr -d ' ')
  if [ "$focused_lines" -gt 500 ]; then
    printf '%s\n' "boundary violation: $focused_app_shell has $focused_lines lines; split the app-shell concern further"
    exit 1
  fi
done

for focused_demo_project in $demo_project_files; do
  focused_lines=$(wc -l < "$focused_demo_project" | tr -d ' ')
  if [ "$focused_lines" -gt 120 ]; then
    printf '%s\n' "boundary violation: $focused_demo_project has $focused_lines lines; split the generated-project concern further"
    exit 1
  fi
done

for focused_demo_plan in $demo_plan_files; do
  focused_lines=$(wc -l < "$focused_demo_plan" | tr -d ' ')
  if [ "$focused_lines" -gt 180 ]; then
    printf '%s\n' "boundary violation: $focused_demo_plan has $focused_lines lines; split the demo plan concern further"
    exit 1
  fi
done

for focused_home_pulse in $home_pulse_files; do
  focused_lines=$(wc -l < "$focused_home_pulse" | tr -d ' ')
  if [ "$focused_lines" -gt 140 ]; then
    printf '%s\n' "boundary violation: $focused_home_pulse has $focused_lines lines; split the Home Pulse concern further"
    exit 1
  fi
done

for focused_home_district in $home_district_files; do
  focused_lines=$(wc -l < "$focused_home_district" | tr -d ' ')
  if [ "$focused_lines" -gt 140 ]; then
    printf '%s\n' "boundary violation: $focused_home_district has $focused_lines lines; split the District Gates concern further"
    exit 1
  fi
done

for focused_runtime in $runtime_files; do
  focused_lines=$(wc -l < "$focused_runtime" | tr -d ' ')
  if [ "$focused_lines" -gt 180 ]; then
    printf '%s\n' "boundary violation: $focused_runtime has $focused_lines lines; split the runtime concern further"
    exit 1
  fi
done

for focused_my_workbench in $my_workbench_files; do
  focused_lines=$(wc -l < "$focused_my_workbench" | tr -d ' ')
  if [ "$focused_lines" -gt 500 ]; then
    printf '%s\n' "boundary violation: $focused_my_workbench has $focused_lines lines; split the My Inventory concern further"
    exit 1
  fi
done

for focused_my_passport in $my_passport_files; do
  focused_lines=$(wc -l < "$focused_my_passport" | tr -d ' ')
  if [ "$focused_lines" -gt 140 ]; then
    printf '%s\n' "boundary violation: $focused_my_passport has $focused_lines lines; split the Town Passport concern further"
    exit 1
  fi
done

for focused_my_inventory_shelf in $my_inventory_shelf_files; do
  focused_lines=$(wc -l < "$focused_my_inventory_shelf" | tr -d ' ')
  if [ "$focused_lines" -gt 180 ]; then
    printf '%s\n' "boundary violation: $focused_my_inventory_shelf has $focused_lines lines; split the My Inventory shelf concern further"
    exit 1
  fi
done

for focused_my_public_passport in $my_public_passport_files; do
  focused_lines=$(wc -l < "$focused_my_public_passport" | tr -d ' ')
  if [ "$focused_lines" -gt 140 ]; then
    printf '%s\n' "boundary violation: $focused_my_public_passport has $focused_lines lines; split the Public Passport concern further"
    exit 1
  fi
done

for focused_workbench_alert in $workbench_alert_files; do
  focused_lines=$(wc -l < "$focused_workbench_alert" | tr -d ' ')
  if [ "$focused_lines" -gt 140 ]; then
    printf '%s\n' "boundary violation: $focused_workbench_alert has $focused_lines lines; split the Workbench alert concern further"
    exit 1
  fi
done

for focused_discovery_projection in $discovery_projection_files; do
  focused_lines=$(wc -l < "$focused_discovery_projection" | tr -d ' ')
  if [ "$focused_lines" -gt 500 ]; then
    printf '%s\n' "boundary violation: $focused_discovery_projection has $focused_lines lines; split the Discover projection concern further"
    exit 1
  fi
done

for focused_discover_market in $discover_market_files; do
  focused_lines=$(wc -l < "$focused_discover_market" | tr -d ' ')
  if [ "$focused_lines" -gt 500 ]; then
    printf '%s\n' "boundary violation: $focused_discover_market has $focused_lines lines; split the Market Board concern further"
    exit 1
  fi
done

for focused_realm_map in $realm_map_files; do
  focused_lines=$(wc -l < "$focused_realm_map" | tr -d ' ')
  if [ "$focused_lines" -gt 500 ]; then
    printf '%s\n' "boundary violation: $focused_realm_map has $focused_lines lines; split the Realm map concern further"
    exit 1
  fi
done

for focused_object_drawer in $object_drawer_files; do
  focused_lines=$(wc -l < "$focused_object_drawer" | tr -d ' ')
  if [ "$focused_lines" -gt 140 ]; then
    printf '%s\n' "boundary violation: $focused_object_drawer has $focused_lines lines; split the object drawer concern further"
    exit 1
  fi
done

for focused_object_context in $object_context_files; do
  focused_lines=$(wc -l < "$focused_object_context" | tr -d ' ')
  if [ "$focused_lines" -gt 140 ]; then
    printf '%s\n' "boundary violation: $focused_object_context has $focused_lines lines; split the object context concern further"
    exit 1
  fi
done

for focused_object_lifecycle in $object_lifecycle_files; do
  focused_lines=$(wc -l < "$focused_object_lifecycle" | tr -d ' ')
  if [ "$focused_lines" -gt 140 ]; then
    printf '%s\n' "boundary violation: $focused_object_lifecycle has $focused_lines lines; split the object lifecycle concern further"
    exit 1
  fi
done

for focused_book_shelf in $book_shelf_files; do
  focused_lines=$(wc -l < "$focused_book_shelf" | tr -d ' ')
  if [ "$focused_lines" -gt 120 ]; then
    printf '%s\n' "boundary violation: $focused_book_shelf has $focused_lines lines; split the book shelf concern further"
    exit 1
  fi
done

for focused_object_worker in $object_worker_files; do
  focused_lines=$(wc -l < "$focused_object_worker" | tr -d ' ')
  if [ "$focused_lines" -gt 120 ]; then
    printf '%s\n' "boundary violation: $focused_object_worker has $focused_lines lines; split the object worker concern further"
    exit 1
  fi
done

for focused_object_memory in $object_memory_files; do
  focused_lines=$(wc -l < "$focused_object_memory" | tr -d ' ')
  if [ "$focused_lines" -gt 120 ]; then
    printf '%s\n' "boundary violation: $focused_object_memory has $focused_lines lines; split the object memory concern further"
    exit 1
  fi
done

for focused_display_copy in $display_copy_files; do
  focused_lines=$(wc -l < "$focused_display_copy" | tr -d ' ')
  if [ "$focused_lines" -gt 120 ]; then
    printf '%s\n' "boundary violation: $focused_display_copy has $focused_lines lines; split the display-copy concern further"
    exit 1
  fi
done

for focused_message_surface in $message_surface_files; do
  focused_lines=$(wc -l < "$focused_message_surface" | tr -d ' ')
  if [ "$focused_lines" -gt 500 ]; then
    printf '%s\n' "boundary violation: $focused_message_surface has $focused_lines lines; split the Messages concern further"
    exit 1
  fi
done

for focused_message_attention in $message_attention_files; do
  focused_lines=$(wc -l < "$focused_message_attention" | tr -d ' ')
  if [ "$focused_lines" -gt 140 ]; then
    printf '%s\n' "boundary violation: $focused_message_attention has $focused_lines lines; split the Messages attention concern further"
    exit 1
  fi
done

for focused_reviewer_diagnostics in $reviewer_diagnostics_files; do
  focused_lines=$(wc -l < "$focused_reviewer_diagnostics" | tr -d ' ')
  if [ "$focused_lines" -gt 180 ]; then
    printf '%s\n' "boundary violation: $focused_reviewer_diagnostics has $focused_lines lines; split the reviewer diagnostics concern further"
    exit 1
  fi
done

for focused_visual_tile in $visual_tile_files; do
  focused_lines=$(wc -l < "$focused_visual_tile" | tr -d ' ')
  if [ "$focused_lines" -gt 140 ]; then
    printf '%s\n' "boundary violation: $focused_visual_tile has $focused_lines lines; split the visual tile concern further"
    exit 1
  fi
done

for focused_test in $moontown_test_files; do
  focused_lines=$(wc -l < "$focused_test" | tr -d ' ')
  if [ "$focused_lines" -gt 500 ]; then
    printf '%s\n' "boundary violation: $focused_test has $focused_lines lines; split the test concern further"
    exit 1
  fi
done

for focused_generated_page_test in $generated_page_test_files; do
  focused_lines=$(wc -l < "$focused_generated_page_test" | tr -d ' ')
  if [ "$focused_lines" -gt 140 ]; then
    printf '%s\n' "boundary violation: $focused_generated_page_test has $focused_lines lines; split the generated page test concern further"
    exit 1
  fi
done

tabs_shell_lines=$(wc -l < examples/moontown_miniapp/demo_tabs_test.mbt | tr -d ' ')
if [ "$tabs_shell_lines" -gt 80 ]; then
  printf '%s\n' "boundary violation: demo_tabs_test.mbt has $tabs_shell_lines lines; keep generated tab coverage in focused demo_tab_* files"
  exit 1
fi

projection_flows_shell_lines=$(wc -l < examples/moontown_miniapp/demo_projection_flows_test.mbt | tr -d ' ')
if [ "$projection_flows_shell_lines" -gt 80 ]; then
  printf '%s\n' "boundary violation: demo_projection_flows_test.mbt has $projection_flows_shell_lines lines; keep projection-flow coverage in focused demo_projection_* files"
  exit 1
fi

inventory_lines=$(wc -l < examples/moontown_miniapp/projection_inventory.mbt | tr -d ' ')
if [ "$inventory_lines" -gt 80 ]; then
  printf '%s\n' "boundary violation: projection_inventory.mbt has $inventory_lines lines; keep inventory behavior in focused projection_inventory_* files"
  exit 1
fi

for focused_inventory in $inventory_files; do
  focused_lines=$(wc -l < "$focused_inventory" | tr -d ' ')
  if [ "$focused_lines" -gt 180 ]; then
    printf '%s\n' "boundary violation: $focused_inventory has $focused_lines lines; split the inventory projection concern further"
    exit 1
  fi
done

visibility_lines=$(wc -l < examples/moontown_miniapp/projection_visibility.mbt | tr -d ' ')
if [ "$visibility_lines" -gt 80 ]; then
  printf '%s\n' "boundary violation: projection_visibility.mbt has $visibility_lines lines; keep visibility behavior in focused projection_visibility_* files"
  exit 1
fi

for focused_visibility in $visibility_files; do
  focused_lines=$(wc -l < "$focused_visibility" | tr -d ' ')
  if [ "$focused_lines" -gt 180 ]; then
    printf '%s\n' "boundary violation: $focused_visibility has $focused_lines lines; split the visibility projection concern further"
    exit 1
  fi
done

lifecycle_lines=$(wc -l < examples/moontown_miniapp/projection_lifecycle.mbt | tr -d ' ')
if [ "$lifecycle_lines" -gt 80 ]; then
  printf '%s\n' "boundary violation: projection_lifecycle.mbt has $lifecycle_lines lines; keep lifecycle behavior in focused projection_lifecycle_* files"
  exit 1
fi

lifecycle_actions_lines=$(wc -l < examples/moontown_miniapp/projection_lifecycle_actions.mbt | tr -d ' ')
if [ "$lifecycle_actions_lines" -gt 40 ]; then
  printf '%s\n' "boundary violation: projection_lifecycle_actions.mbt has $lifecycle_actions_lines lines; keep lifecycle action behavior in focused projection_lifecycle_action_* files"
  exit 1
fi

for focused_lifecycle in $lifecycle_files; do
  focused_lines=$(wc -l < "$focused_lifecycle" | tr -d ' ')
  if [ "$focused_lines" -gt 260 ]; then
    printf '%s\n' "boundary violation: $focused_lifecycle has $focused_lines lines; split the lifecycle projection concern further"
    exit 1
  fi
done

for focused_lifecycle_action in $lifecycle_action_files; do
  focused_lines=$(wc -l < "$focused_lifecycle_action" | tr -d ' ')
  if [ "$focused_lines" -gt 140 ]; then
    printf '%s\n' "boundary violation: $focused_lifecycle_action has $focused_lines lines; split the lifecycle action concern further"
    exit 1
  fi
done

printf '%s\n' 'boundary=ok'
