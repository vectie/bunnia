# MoonTown Two-user UI-to-UI CI

This qualification is deliberately a real WeChat DevTools journey. It is not an
HTTP contract test with a UI label.

## Runner

Register a private macOS GitHub Actions runner with labels `self-hosted`,
`macOS`, and `wechat-devtools`. Install and sign in to WeChat DevTools, authorize
the generated project AppID/test account, and set repository variable
`WECHAT_DEVTOOLS_CLI` to its CLI executable.

On that trusted runner, a named operator must explicitly enable **WeChat
DevTools → Settings → Security Settings → Service Port**. This exposes the local
automation endpoint and is intentionally not changed by the test script. Keep
the runner private, firewall it from untrusted networks, and disable the port
when the runner is retired.

Pre-provision the complete runtime described by MoonTown's
`docs/DEPLOYMENT_HANDOFF.md`, including MoonBook, an active Bo supervisor,
MoonDesk, MoonClaw, MoonGate, a published agent listing, and two independent API
listeners/sessions. Store the two opaque sessions as repository secrets
`MOONTOWN_ADA_SESSION` and `MOONTOWN_BO_SESSION`. Set:

- `MOONTOWN_ADA_BASE_URL` to Ada's HTTPS or loopback qualification API;
- `MOONTOWN_BO_BASE_URL` to Bo's API;
- `MOONTOWN_TEST_LISTING_ID` to the published, trial-enabled agent;
- `WECHAT_DEVTOOLS_CLI` to the DevTools CLI.

Do not use a request-controlled user-id header. Each base URL/session pair must
resolve to one pre-provisioned tenant principal.

## Journey

The script launches the generated mini-app three times:

1. Ada records her current request cards through the UI, opens Discover,
   refreshes the marketplace, opens the configured agent, and submits **Try**.
   The script captures the newly visible durable request ID.
2. Bo opens Messages / Requests, refreshes, enters an explicit instruction,
   approves the visible bounded policy, and retries the durable handoff if the
   UI offers that recovery action.
3. Ada reopens Messages / Requests and refreshes until that exact request ID
   shows a completed/succeeded receipt.

The JSON artifact records only phase/status evidence; it never records session
tokens. A missing DevTools installation, unauthorized AppID, missing service,
or UI element fails the job. API-only CI remains in `scripts/ci.sh` and is not a
substitute for this workflow.

## Local invocation

```sh
moon run cmd/main -- build --target wechat --example moontown_miniapp --strict --budget large --render-budget large
npm install --prefix _build/ui-e2e-tools --no-save miniprogram-automator
WECHAT_DEVTOOLS_CLI='/Applications/wechatwebdevtools.app/Contents/MacOS/cli' \
MINIPROGRAM_AUTOMATOR_MODULE="$PWD/_build/ui-e2e-tools/node_modules/miniprogram-automator" \
MOONTOWN_ADA_BASE_URL='http://127.0.0.1:18192' \
MOONTOWN_BO_BASE_URL='http://127.0.0.1:18191' \
MOONTOWN_ADA_SESSION='<opaque Ada session>' \
MOONTOWN_BO_SESSION='<opaque Bo session>' \
MOONTOWN_TEST_LISTING_ID='ada-policy-guide-card' \
node scripts/two_user_ui_to_ui.mjs
```
