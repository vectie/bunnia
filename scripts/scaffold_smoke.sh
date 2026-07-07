#!/usr/bin/env sh
set -eu

output_dir="${1:-_build/bunnia/scaffold/ci_starter}"

moon run cmd/main -- init --name ci_starter --module local/ci_starter --out "$output_dir"

(
  cd "$output_dir"
  moon check
  moon test
  mkdir -p _build

  moon run cmd/main -- ci-plan --target unknown-mini --script --strict > _build/unknown-ci.sh
  if sh _build/unknown-ci.sh; then
    printf '%s\n' "expected unknown target CI plan to fail"
    exit 1
  fi

  moon run cmd/main -- build --target alipay --strict > _build/alipay-build.log

  sh scripts/ci.sh
)
