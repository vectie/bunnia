#!/usr/bin/env sh
set -eu

output_dir="${1:-_build/bunnia/scaffold/ci_starter}"

moon run cmd/main -- init --name ci_starter --module local/ci_starter --out "$output_dir"

(
  cd "$output_dir"
  moon check
  moon test
  mkdir -p _build

  moon run cmd/main -- ci-plan --target alipay --script --strict > _build/alipay-ci.sh
  if sh _build/alipay-ci.sh; then
    printf '%s\n' "expected deferred alipay CI plan to fail"
    exit 1
  fi

  if moon run cmd/main -- build --target alipay > _build/alipay-build.log 2>&1; then
    printf '%s\n' "expected deferred alipay build to fail"
    exit 1
  fi

  sh scripts/ci.sh
)
