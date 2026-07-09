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

for required in examples/moontown_miniapp/projection_schema.mbt examples/moontown_miniapp/projection_seed.mbt; do
  if [ ! -f "$required" ]; then
    printf '%s\n' "boundary violation: missing Moontown projection boundary file $required"
    exit 1
  fi
done

projection_lines=$(wc -l < examples/moontown_miniapp/projection.mbt | tr -d ' ')
if [ "$projection_lines" -gt 3000 ]; then
  printf '%s\n' "boundary violation: projection.mbt has $projection_lines lines; keep schema and seed data in focused files"
  exit 1
fi

printf '%s\n' 'boundary=ok'
