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

lifecycle_files='examples/moontown_miniapp/projection_lifecycle_actions.mbt examples/moontown_miniapp/projection_lifecycle_publication.mbt examples/moontown_miniapp/projection_lifecycle_agents.mbt'

schema_files='examples/moontown_miniapp/projection_schema_people.mbt examples/moontown_miniapp/projection_schema_content.mbt examples/moontown_miniapp/projection_schema_work.mbt examples/moontown_miniapp/projection_schema_actions.mbt examples/moontown_miniapp/projection_schema_shell.mbt examples/moontown_miniapp/projection_schema_attention.mbt examples/moontown_miniapp/projection_schema_discovery.mbt examples/moontown_miniapp/projection_schema_activity.mbt examples/moontown_miniapp/projection_schema_ownership.mbt examples/moontown_miniapp/projection_schema_backend.mbt examples/moontown_miniapp/projection_schema_projection.mbt'

seed_files='examples/moontown_miniapp/projection_seed_core.mbt examples/moontown_miniapp/projection_seed_review.mbt examples/moontown_miniapp/projection_seed_content.mbt examples/moontown_miniapp/projection_seed_shell.mbt examples/moontown_miniapp/projection_seed_attention.mbt examples/moontown_miniapp/projection_seed_backend.mbt examples/moontown_miniapp/projection_seed_places.mbt'

action_files='examples/moontown_miniapp/projection_action_shell.mbt examples/moontown_miniapp/projection_action_buildings.mbt examples/moontown_miniapp/projection_action_lifecycle_helpers.mbt examples/moontown_miniapp/projection_action_agents.mbt examples/moontown_miniapp/projection_action_reviews.mbt'

building_action_files='examples/moontown_miniapp/projection_action_building_drafts.mbt examples/moontown_miniapp/projection_action_building_lifecycle.mbt examples/moontown_miniapp/projection_action_building_messages.mbt examples/moontown_miniapp/projection_action_building_placement.mbt'

app_shell_files='examples/moontown_miniapp/demo_project.mbt examples/moontown_miniapp/demo_runtime.mbt examples/moontown_miniapp/demo_plans.mbt examples/moontown_miniapp/demo_scene.mbt examples/moontown_miniapp/demo_adapters.mbt examples/moontown_miniapp/town_shell.mbt examples/moontown_miniapp/town_navigation.mbt examples/moontown_miniapp/home_onboarding.mbt examples/moontown_miniapp/home_districts.mbt examples/moontown_miniapp/home_pulse.mbt'

runtime_files='examples/moontown_miniapp/demo_runtime_shell.mbt examples/moontown_miniapp/demo_runtime_filters.mbt examples/moontown_miniapp/demo_runtime_buildings.mbt examples/moontown_miniapp/demo_runtime_reviewer.mbt examples/moontown_miniapp/demo_runtime_map.mbt'

moontown_test_files='examples/moontown_miniapp/demo_page_test.mbt examples/moontown_miniapp/demo_tabs_test.mbt examples/moontown_miniapp/demo_tab_realm_home_test.mbt examples/moontown_miniapp/demo_tab_discover_test.mbt examples/moontown_miniapp/demo_tab_messages_test.mbt examples/moontown_miniapp/demo_tab_my_test.mbt examples/moontown_miniapp/demo_tab_reviewer_test.mbt examples/moontown_miniapp/demo_project_test.mbt examples/moontown_miniapp/demo_project_shell_test.mbt examples/moontown_miniapp/demo_project_routes_test.mbt examples/moontown_miniapp/demo_project_backend_test.mbt examples/moontown_miniapp/demo_project_seed_data_test.mbt examples/moontown_miniapp/demo_project_manifest_test.mbt examples/moontown_miniapp/demo_projection_flows_test.mbt examples/moontown_miniapp/demo_projection_shell_test.mbt examples/moontown_miniapp/demo_projection_attention_work_test.mbt examples/moontown_miniapp/demo_projection_discovery_inventory_test.mbt examples/moontown_miniapp/demo_projection_review_readiness_test.mbt examples/moontown_miniapp/demo_projection_building_lifecycle_test.mbt examples/moontown_miniapp/demo_projection_agent_work_test.mbt examples/moontown_miniapp/demo_pressure_test.mbt examples/moontown_miniapp/demo_test_helpers_test.mbt'

my_workbench_files='examples/moontown_miniapp/my_passport.mbt examples/moontown_miniapp/my_lifecycle.mbt examples/moontown_miniapp/my_tools.mbt examples/moontown_miniapp/my_public_passport.mbt examples/moontown_miniapp/my_inventory_rows.mbt examples/moontown_miniapp/my_inventory_shelves.mbt examples/moontown_miniapp/workbench_alerts.mbt'

my_inventory_shelf_files='examples/moontown_miniapp/my_inventory_shelf_model.mbt examples/moontown_miniapp/my_inventory_shelf_panel.mbt examples/moontown_miniapp/my_inventory_shelf_rows.mbt'

discovery_projection_files='examples/moontown_miniapp/projection_discovery_results.mbt examples/moontown_miniapp/projection_discovery_activity.mbt examples/moontown_miniapp/projection_discovery_work.mbt examples/moontown_miniapp/projection_discovery_pulse.mbt'

discover_market_files='examples/moontown_miniapp/discover_market_lists.mbt examples/moontown_miniapp/discover_market_entries.mbt examples/moontown_miniapp/discover_market_actions.mbt'

realm_map_files='examples/moontown_miniapp/realm_map_backdrop.mbt examples/moontown_miniapp/realm_map_markers.mbt examples/moontown_miniapp/realm_map_hud.mbt'

message_surface_files='examples/moontown_miniapp/message_attention.mbt examples/moontown_miniapp/message_buckets.mbt examples/moontown_miniapp/message_channels.mbt examples/moontown_miniapp/message_context.mbt examples/moontown_miniapp/message_notices.mbt examples/moontown_miniapp/message_results.mbt examples/moontown_miniapp/message_reviews.mbt examples/moontown_miniapp/message_work.mbt'

reviewer_diagnostics_files='examples/moontown_miniapp/reviewer_diagnostics_operations.mbt examples/moontown_miniapp/reviewer_diagnostics_sections.mbt examples/moontown_miniapp/reviewer_diagnostics_moderation.mbt examples/moontown_miniapp/reviewer_diagnostics_developer.mbt examples/moontown_miniapp/reviewer_diagnostics_backend.mbt'

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

for required in $action_files; do
  if [ ! -f "$required" ]; then
    printf '%s\n' "boundary violation: missing Moontown action workflow file $required"
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

for required in $my_workbench_files; do
  if [ ! -f "$required" ]; then
    printf '%s\n' "boundary violation: missing Moontown My workbench file $required"
    exit 1
  fi
done

for required in $my_inventory_shelf_files; do
  if [ ! -f "$required" ]; then
    printf '%s\n' "boundary violation: missing Moontown My Inventory shelf file $required"
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

for required in $message_surface_files; do
  if [ ! -f "$required" ]; then
    printf '%s\n' "boundary violation: missing Moontown Messages file $required"
    exit 1
  fi
done

for required in $reviewer_diagnostics_files; do
  if [ ! -f "$required" ]; then
    printf '%s\n' "boundary violation: missing Moontown reviewer diagnostics file $required"
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

demo_lines=$(wc -l < examples/moontown_miniapp/demo.mbt | tr -d ' ')
if [ "$demo_lines" -gt 80 ]; then
  printf '%s\n' "boundary violation: demo.mbt has $demo_lines lines; keep app assembly in focused demo and town files"
  exit 1
fi

demo_runtime_lines=$(wc -l < examples/moontown_miniapp/demo_runtime.mbt | tr -d ' ')
if [ "$demo_runtime_lines" -gt 80 ]; then
  printf '%s\n' "boundary violation: demo_runtime.mbt has $demo_runtime_lines lines; keep runtime behavior in focused demo_runtime_* files"
  exit 1
fi

demo_test_lines=$(wc -l < examples/moontown_miniapp/demo_test.mbt | tr -d ' ')
if [ "$demo_test_lines" -gt 80 ]; then
  printf '%s\n' "boundary violation: demo_test.mbt has $demo_test_lines lines; keep coverage in focused test files"
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

my_inventory_shelves_lines=$(wc -l < examples/moontown_miniapp/my_inventory_shelves.mbt | tr -d ' ')
if [ "$my_inventory_shelves_lines" -gt 80 ]; then
  printf '%s\n' "boundary violation: my_inventory_shelves.mbt has $my_inventory_shelves_lines lines; keep shelf behavior in focused my_inventory_shelf_* files"
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

messages_lines=$(wc -l < examples/moontown_miniapp/messages.mbt | tr -d ' ')
if [ "$messages_lines" -gt 120 ]; then
  printf '%s\n' "boundary violation: messages.mbt has $messages_lines lines; keep Messages panels in focused files"
  exit 1
fi

reviewer_diagnostics_lines=$(wc -l < examples/moontown_miniapp/reviewer_diagnostics.mbt | tr -d ' ')
if [ "$reviewer_diagnostics_lines" -gt 80 ]; then
  printf '%s\n' "boundary violation: reviewer_diagnostics.mbt has $reviewer_diagnostics_lines lines; keep reviewer diagnostics behavior in focused reviewer_diagnostics_* files"
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

for focused_action in $action_files; do
  focused_lines=$(wc -l < "$focused_action" | tr -d ' ')
  if [ "$focused_lines" -gt 500 ]; then
    printf '%s\n' "boundary violation: $focused_action has $focused_lines lines; split the action workflow further"
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

for focused_my_inventory_shelf in $my_inventory_shelf_files; do
  focused_lines=$(wc -l < "$focused_my_inventory_shelf" | tr -d ' ')
  if [ "$focused_lines" -gt 180 ]; then
    printf '%s\n' "boundary violation: $focused_my_inventory_shelf has $focused_lines lines; split the My Inventory shelf concern further"
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

for focused_message_surface in $message_surface_files; do
  focused_lines=$(wc -l < "$focused_message_surface" | tr -d ' ')
  if [ "$focused_lines" -gt 500 ]; then
    printf '%s\n' "boundary violation: $focused_message_surface has $focused_lines lines; split the Messages concern further"
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

for focused_test in $moontown_test_files; do
  focused_lines=$(wc -l < "$focused_test" | tr -d ' ')
  if [ "$focused_lines" -gt 500 ]; then
    printf '%s\n' "boundary violation: $focused_test has $focused_lines lines; split the test concern further"
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

for focused_lifecycle in $lifecycle_files; do
  focused_lines=$(wc -l < "$focused_lifecycle" | tr -d ' ')
  if [ "$focused_lines" -gt 260 ]; then
    printf '%s\n' "boundary violation: $focused_lifecycle has $focused_lines lines; split the lifecycle projection concern further"
    exit 1
  fi
done

printf '%s\n' 'boundary=ok'
