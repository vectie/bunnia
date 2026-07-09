# Moontown WeChat DevTools Smoke Path

Use this after visible UI or event-flow changes. The automated checks prove the
generated project is coherent; this smoke path proves the local DevTools loop is
still usable on this Mac.

## Preflight

Run from the repository root:

```sh
moon test
moon run cmd/main -- build --target wechat --example moontown_miniapp --strict --budget large --render-budget large
moon run cmd/main -- inspect --target wechat --example moontown_miniapp --budget large --render-budget large
sh scripts/validate_moontown_ordinary_copy.sh
node examples/moontown_miniapp/backend/local_backend.mjs --smoke
```

Expected result: tests pass, release readiness is `ready`, diagnostics are `0`,
and the generated project is written to:

```text
_build/bunnia/wechat/moontown_miniapp
```

## Local Backend

Start a clean local backend for DevTools:

```sh
node examples/moontown_miniapp/backend/local_backend.mjs --state /tmp/moontown-devtools-state.json --reset-state
```

The generated mini-app points at `http://127.0.0.1:18191`.

## DevTools Flow

Open `_build/bunnia/wechat/moontown_miniapp` in WeChat DevTools, then smoke:

1. Realm: enter town, pan/zoom the map, select Policy Hall, open Messages and Discover from map actions.
2. Discover: search/filter, open a result, place/watch a public item, and verify the action returns to town language.
3. Messages: switch channels, mark a notice read, review an agent result, retry or cancel one run.
4. My: refresh inventory, switch filters, edit profile choices, create or update a private building.
5. Reviewer: open Reviewer Tools from My, run Check Town Safety and Launch Checks, then return to My.

Ordinary pages must not show endpoint ids, HTTP paths, payload keys, response
keys, runtime labels, cursor/offset labels, or DevTools copy. Reviewer Tools is
the deliberate allowlisted diagnostics surface.
