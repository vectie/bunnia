#!/usr/bin/env sh
set -eu

mkdir -p _build/bunnia
moon run cmd/main -- ci-plan --script > _build/bunnia/ci.sh
sh _build/bunnia/ci.sh
