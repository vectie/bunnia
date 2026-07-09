#!/usr/bin/env sh
set -eu

mkdir -p _build/bunnia
moon run cmd/main -- ci-plan --script > _build/bunnia/ci.sh
sh _build/bunnia/ci.sh

moon run cmd/main -- build --target wechat --example moontown_miniapp --strict --budget large --render-budget large
sh scripts/validate_moontown_ordinary_copy.sh
