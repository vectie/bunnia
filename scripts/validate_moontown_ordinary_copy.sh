#!/usr/bin/env sh
set -eu

project_dir="${1:-_build/bunnia/wechat/moontown_miniapp}"
script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
guardrail_dir="$script_dir/moontown_guardrails"
ordinary_pages_file="$guardrail_dir/ordinary_wxml_paths.txt"
visible_terms_file="$guardrail_dir/ordinary_visible_terms.txt"
forbidden_tokens_file="$guardrail_dir/ordinary_forbidden_tokens.txt"
reviewer_allowlist_file="$guardrail_dir/reviewer_allowlist_tokens.txt"
failed=0

require_file() {
  if [ ! -f "$1" ]; then
    printf '%s\n' "missing guardrail file: $1"
    failed=1
  fi
}

skip_guardrail_line() {
  case "$1" in
    ''|'#'*) return 0 ;;
    *) return 1 ;;
  esac
}

require_file "$ordinary_pages_file"
require_file "$visible_terms_file"
require_file "$forbidden_tokens_file"
require_file "$reviewer_allowlist_file"

if [ "$failed" -ne 0 ]; then
  exit 1
fi

while IFS= read -r rel || [ -n "$rel" ]; do
  if skip_guardrail_line "$rel"; then
    continue
  fi
  file="$project_dir/$rel"
  if [ ! -f "$file" ]; then
    printf '%s\n' "missing ordinary WXML: $file"
    failed=1
    continue
  fi

  while IFS= read -r term || [ -n "$term" ]; do
    if skip_guardrail_line "$term"; then
      continue
    fi
    if rg -n -o ">[^<]*${term}[^<]*<" "$file"; then
      printf '%s\n' "forbidden visible technical copy '$term' in $rel"
      failed=1
    fi
  done < "$visible_terms_file"

  while IFS= read -r token || [ -n "$token" ]; do
    if skip_guardrail_line "$token"; then
      continue
    fi
    if rg -n -F "$token" "$file"; then
      printf '%s\n' "forbidden ordinary WXML token '$token' in $rel"
      failed=1
    fi
  done < "$forbidden_tokens_file"
done < "$ordinary_pages_file"

reviewer="$project_dir/pages/moontown/reviewer.wxml"
if [ ! -f "$reviewer" ]; then
  printf '%s\n' "missing reviewer WXML: $reviewer"
  failed=1
else
  while IFS= read -r token || [ -n "$token" ]; do
    if skip_guardrail_line "$token"; then
      continue
    fi
    if ! rg -n -F "$token" "$reviewer" >/dev/null; then
      printf '%s\n' "missing reviewer diagnostics allowlist token '$token'"
      failed=1
    fi
  done < "$reviewer_allowlist_file"
fi

if [ "$failed" -ne 0 ]; then
  exit 1
fi

printf '%s\n' "moontown ordinary copy guard ok"
