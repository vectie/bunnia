#!/usr/bin/env sh
set -eu

project_dir="${1:-_build/bunnia/wechat/moontown_miniapp}"
ordinary_pages="pages/moontown/index.wxml pages/moontown/home.wxml pages/moontown/discover.wxml pages/moontown/messages.wxml pages/moontown/my.wxml"
failed=0

visible_pattern='>[^<]*(GET /miniapp|POST /miniapp|endpoint|payload|response_key|backendStatus|DevTools|runtime filter|runtime channel|cursor|offset|load-message-center|Ack Sync|Tool Ack|Ops Desk)[^<]*<'

for rel in $ordinary_pages; do
  file="$project_dir/$rel"
  if [ ! -f "$file" ]; then
    printf '%s\n' "missing ordinary WXML: $file"
    failed=1
    continue
  fi

  if rg -n -o "$visible_pattern" "$file"; then
    printf '%s\n' "forbidden visible technical copy in $rel"
    failed=1
  fi

  for token in \
    'data-backend-' \
    'data-payload-key' \
    'data-response-key' \
    'Developer Diagnostics' \
    'adminOpsQuery' \
    'adminReadinessQuery' \
    'Moderation Desk' \
    'Safety Desk' \
    'System Gateway' \
    'profile readiness' \
    'shared-private buildings' \
    'shared private' \
    'shared privately'; do
    if rg -n -F "$token" "$file"; then
      printf '%s\n' "forbidden ordinary WXML token '$token' in $rel"
      failed=1
    fi
  done
done

reviewer="$project_dir/pages/moontown/reviewer.wxml"
if [ ! -f "$reviewer" ]; then
  printf '%s\n' "missing reviewer WXML: $reviewer"
  failed=1
else
  for token in \
    'data-reviewer-route="true"' \
    'Developer Diagnostics' \
    'data-diagnostics-mode="reviewer"' \
    'data-http-path="/miniapp/admin/ops"' \
    'data-http-path="/miniapp/admin/readiness"' \
    'data-payload-key="adminOpsQuery"' \
    'data-response-key="adminReadinessResult"'; do
    if ! rg -n -F "$token" "$reviewer" >/dev/null; then
      printf '%s\n' "missing reviewer diagnostics allowlist token '$token'"
      failed=1
    fi
  done
fi

if [ "$failed" -ne 0 ]; then
  exit 1
fi

printf '%s\n' "moontown ordinary copy guard ok"
