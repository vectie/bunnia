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

The build replaces the generated directory. If DevTools already has that
directory open, quit and reopen or re-import the generated project after the
build. Continuing in the old DevTools process can leave its current working
directory pointing at a removed inode and produce an `ENOENT ... uv_cwd`
compile failure. This is a preview-tool lifecycle issue, not an app error.

## Local Backend

Start a clean local backend for DevTools:

```sh
node examples/moontown_miniapp/backend/local_backend.mjs --state /tmp/moontown-devtools-state.json --reset-state
```

The generated mini-app points at `http://127.0.0.1:18191`.

## DevTools Flow

Open `_build/bunnia/wechat/moontown_miniapp` in WeChat DevTools, then smoke:

If the generated `project.config.json` has an empty AppID, use DevTools Import,
choose the generated directory, select `Test Account`, choose no cloud service,
create the local project, and trust it. The resulting test identity belongs in
DevTools local project metadata and must not be committed.

1. Enter Town, then use all five bottom tabs and confirm exactly one active tab.
2. Home: open the priority lead and each Browse/Review/Verify gate; confirm the owning page opens.
3. Discover: switch All/Places/People/Circles/Products/Demands/Events/Posts/Agents/Books/Placeable, confirm every count and result list narrow together, then open a place in Realm.
4. Realm: pan/zoom, select Market Square, confirm marker and drawer titles agree, then open the routed Published Agent Lab. Use Ask and Place; confirm the drawer shows Asked and Placed and does not retain a duplicate Place action.
5. Messages: switch All/Unread/Activity/Replies/Notices, refresh chats, tap a whole chat row, approve or reject the memory review, and confirm it leaves pending UI. Stop one running job and confirm only that job disappears.
6. My: confirm the passport is ready, switch All/Placed/Drafts/Published/Books/Agents/Watches, open a placement, refresh My Stuff, and confirm the queue reaches All Clear. Exercise Create Building and Create Agent and confirm visible success.
7. Reviewer: open Reviewer Tools from My, run Check Town Safety and Launch Checks, exercise the eligible moderation controls, then return to My.
8. Stop the backend, use Ask, and confirm a visible failure. Restart the same backend state, retry, and confirm the failure clears after success.
9. Repeat the critical Realm drawer at 768×1024 and 320×568. Confirm the bottom navigation remains visible and the Details control does not wrap.
10. Clear Console and Network, trigger Ask, and confirm no console diagnostics and a successful request.

If CLI automation connects but page calls hang, inspect the DevTools log for
`appid missing` or `routeTo appLaunch timeout`. Re-import the generated project
with `Test Account` or an authorized local AppID before rerunning automation.
Treat any WXML compiler error as a release blocker even when MoonBit and strict
build checks pass.

Ordinary pages must not show endpoint ids, HTTP paths, payload keys, response
keys, runtime labels, cursor/offset labels, or DevTools copy. Reviewer Tools is
the deliberate allowlisted diagnostics surface.
