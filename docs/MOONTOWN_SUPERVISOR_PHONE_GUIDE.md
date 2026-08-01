# Moontown Supervisor Setup And Phone Guide

This guide covers the Bunnia-generated phone surface for the first-supervisor
closed loop. It is a UI integration guide. MoonTown remains the source of truth
for the character profile, workspace/building/book bindings, readiness,
projection state, and API semantics. MoonClaw runs supervisors and child
workers. Bookkeeper owns acceptance decisions.

## What A First-Time User Sees

Open `Home` after login. The registration kiosk is intentionally a short,
vertical five-stop flow:

1. **Identity** — enter the supervisor name, choose an avatar, and select an
   archetype.
2. **Purpose** — write the mission, choose a tone, and select no more than
   three initial capabilities.
3. **Place** — load and select a genuinely installed MoonBook. MoonTown derives
   the symbolic workspace/building binding; the phone never handles its path.
4. **Review** — inspect the passport and confirm both control and Bookkeeper
   consent statements.
5. **Activate** — send the versioned activation command.

`Save Draft` is available before activation. Leaving the page does not imply
activation or acceptance. On return, the page asks MoonTown for the current
draft and renders loading, empty, recoverable error, version conflict, and
saved states. A conflict means the server owns a newer version; choose
`Reload Draft` before editing again.

Activation progresses through `pending_transport`, `claimed`,
`runtime_acknowledged`, and `active`. Only the acknowledged/active states expose
the supervisor controls. A failed state offers a retry while preserving the
saved profile. None of these transport/runtime states is a Bookkeeper decision,
and the UI must never turn one into accepted memory.

## After Activation

Home and Realm show the projected supervisor as a controllable agent. The
badge and worker count come from the MoonTown projection. The example caps the
visible child set at three and uses a windowed list; it does not infer or spawn
workers in the frontend.

Use `Messages` as the phone control surface:

- **All** shows town notices and the supervisor conversation.
- **Supervisor** opens the focused supervisor thread.
- The supervisor thread exposes distinct parent-run **Wake**, **Stop
  Supervisor**, and **Retry / Resume** controls.
- **Tasks** shows bounded child work with explicit steer, stop, and retry
  commands.
- **Reviews** shows requests that still need a human decision.
- **Receipts** shows Bookkeeper `pending`, `accepted`, and `rejected` receipts.

Rows carry stable run, task, agent, and target references for deep links.
Pending receipts say “not accepted” explicitly. A retry requests new work; it
does not change a prior rejection.

## MoonTown Adapter Contract

The generated project currently declares these phone-safe routes:

| Command id | Method and route | Request state key | Response state key |
| --- | --- | --- | --- |
| `load-book-registrations` | `GET /miniapp/book-registrations` | `bookCatalogQuery` | sanitized `installedBookCatalogResponse` (`id`, `name`, `purpose` only) |
| `load-supervisor-setup` | `GET /miniapp/onboarding/supervisor` | `supervisorSetupQuery` | `onboardingSnapshot` |
| `save-supervisor-draft` | `PUT /miniapp/onboarding/supervisor/draft` | `supervisorDraft` | `supervisorDraftResult` |
| `activate-supervisor` | `POST /miniapp/onboarding/supervisor/activate` | `supervisorActivation` | `activationResult` |
| `send-supervisor-message` | `POST /miniapp/messages` | `supervisorMessage` with durable command/cursors/action | `supervisorMessageResult` |
| `assign-worker` | `POST /miniapp/runs/delegate` | exact finite `task` and `scope` | `delegateResult` |
| `steer-run` | `POST /miniapp/runs/steer` | `runSteer` with durable command/cursors/action | `steerResult` |
| `wake-supervisor` | `POST /miniapp/runs/supervisor/wake` | receipt-backed parent run; action `wake` | `supervisorWakeResult` |
| `stop-supervisor` | `POST /miniapp/runs/supervisor/stop` | receipt-backed parent run; action `supervisor_stop` | `supervisorStopResult` |
| `resume-supervisor` | `POST /miniapp/runs/supervisor/resume` | receipt-backed parent run; action `supervisor_resume` | `supervisorResumeResult` |
| `steer-child-run` | `POST /miniapp/runs/child/steer` | receipt-backed child `runId` and guidance | `childSteerResult` |
| `cancel-run` | `POST /miniapp/runs/cancel` | receipt-backed child `runId`; action `child_stop` | `cancelResult` |
| `retry-run` | `POST /miniapp/runs/retry` | receipt-backed child `runId`; action `child_retry` | `retryResult` |
| `request-bookkeeper-review` | `POST /miniapp/reviews/decision` | unchanged `review_ready` outcome candidate | `bookkeeperReviewResult` |

The draft contains MoonTown-owned persona and symbolic binding fields:
`profileId`, `version`, `expectedVersion`, `expectedCursor`, `name`,
`avatarRef`, `archetypeId`, `mission`, `toneId`, `capabilityIds`,
`workspaceId`, `buildingId`, `bookId`, and the consent flags. The selected
`bookId` must still exist in MoonTown's trusted installed-book view on both
save and activation. MoonTown derives workspace/building ids from it and keeps
the trusted absolute `workspace_root` server-side.

The activation handoff is versioned as
`moontown.supervisor-activation-handoff.v1`, targets `moonclaw`, and carries
the `moonsuite.supervisor-profile-activation.v1` runtime payload:

```json
{
  "command_id": "activate-supervisor-user-a-v3",
  "profile_id": "supervisor-profile-user-a",
  "profile_version": 3,
  "profile_digest": "opaque-digest",
  "expected_cursor": 0
}
```

The activation payload intentionally carries an immutable `runtime_profile`
(persona, mission, capabilities, bindings, consent metadata, and content
digest) and
`runtime_binding` (symbolic workspace/building/book ids, model, and worker
ceiling). MoonDesk alone resolves the trusted absolute working directory.
Execution authority is conveyed separately by the MoonGate decision in the
MoonClaw command envelope.
Command ids must be idempotent. Draft updates use the expected version/cursor
so MoonTown can return HTTP 409 for a stale edit.

While activation or work is pending, the foreground phone performs bounded
fresh reads and stops polling when hidden. MoonDesk reconciles digest-bound
MoonClaw status plus event replay into MoonTown. The phone renders conversation
history only from canonical `message.sent`, `supervisor.steered`, and
`supervisor.assistant.responded` replay evidence; assistant replies retain
their source event, delivery event, executor run, and provider evidence.

## Trying The Generated UI

Generate and inspect the project from the Bunnia root:

```sh
moon run cmd/main -- build --target wechat --example moontown_miniapp --budget large --render-budget large
moon run cmd/main -- inspect --target wechat --example moontown_miniapp --budget large --render-budget large
sh scripts/validate_moontown_ordinary_copy.sh
```

The first command is the current feature-preview build. Before publishing, run
the same command with `--strict`. The strict release gate intentionally remains
red while the existing all-in-one Messages/Home demo exceeds WeChat page,
JavaScript, initial-data, route-risk, and endpoint/review budgets. Split those
surfaces into lazy subpackages/components and key the remaining unkeyed list;
do not raise the budgets or describe the preview build as release-ready.

Open `_build/bunnia/wechat/moontown_miniapp` in WeChat DevTools, then point
`backendBaseUrl` at the MoonTown mini-app API. The repository's
`examples/moontown_miniapp/backend/local_backend.mjs` and all
`demo_*` projection functions are test providers only. They are useful for
rendering and deterministic contract checks; they are not the runtime,
Bookkeeper, or a source of production policy.

In WeChat DevTools:

1. Login and open `Home`.
2. Select an installed MoonBook, change the name and mission, and navigate
   between kiosk steps. With no installed book, save and activation stay blocked.
3. Save, leave Home, return, and confirm the persisted profile rehydrates the
   complete draft and setup state.
4. Trigger a stale-version response and confirm the conflict/reload plaque.
5. Activate and verify pending transport, claimed, acknowledged/active, and
   failed/retry states remain distinct from the receipt ledger.
6. Open `Messages`, send the supervisor a message, steer and stop the running
   child, retry the failed child, open the review request, and inspect all
   three receipt states.
7. Return to Realm and confirm the supervisor badge and worker count match the
   latest MoonTown projection.

## Marketplace Request To Worker

1. In `Discover`, open a reviewed agent or building listing and choose `Try`,
   `Install`, `Invite`, or `Request access`. This creates a publisher request;
   it does not run the listing.
2. As the publisher, open `Messages → Agent work → Requests` and tap `Refresh`.
3. Read the requester, listing, proposed instruction, and visible ceiling. The
   v1 phone surface caps work at reviewable output, gpt-5.6-sol, five minutes,
   12,000 tokens, three artifacts, USD 2 equivalent provider budget, and web
   off.
4. Edit the exact instruction if needed, then tap `Approve & queue`, or tap
   `Decline`. An approval requires an activated delegation-enabled supervisor.
5. If activation was missing or Town restarted between approval and handoff,
   activate the supervisor, refresh the Requests queue, and tap `Retry
   handoff`. This recovers the deterministic existing handoff before creating
   another one.
6. Refresh the queue after MoonDesk transports the outbox. The row advances
   from `handoff_queued` to `runtime_acknowledged`, `running`, and finally
   `succeeded` or `failed`, using MoonClaw receipts and observations rather than
   animation or optimistic UI.
7. Open Notifications as the requester. Approval, queueing, runtime progress,
   completion, and failure remain visible only to the request participants.

The marketplace request is not a new agent runtime. Bunnia renders the phone
interaction, MoonTown owns the decision and recovery state, the existing
supervisor outbox carries the bounded assignment, MoonDesk transports it, and
MoonClaw remains the sole executor.

Touch controls remain at least 88rpx (44 CSS pixels at the standard WeChat
scale), support immediate pressed feedback, and keep the five global tabs:
`Home`, `Discover`, `Realm`, `Messages`, and `My`.
