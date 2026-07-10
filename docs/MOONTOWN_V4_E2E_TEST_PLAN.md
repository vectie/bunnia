# Moontown V4 End-To-End Test Plan

This plan validates whether an ordinary user can complete Moontown tasks, not
only whether the generated mini-app renders or its event bindings compile.

Execution starts only after this document is committed. Results belong in
`MOONTOWN_V4_E2E_TEST_REPORT.md`.

## Objective

For every page and cross-page journey, answer six questions:

1. **See:** What does the user see first?
2. **Reason:** Why is that information or control present?
3. **Can do:** Which actions are actually available?
4. **Will do:** Which action is the most likely next step?
5. **Outcome:** What visible and persisted result should follow?
6. **Achievable:** Can an untrained user reach that result without hidden
   knowledge, dead controls, or diagnostics?

A case passes only when the visible hierarchy, event behavior, destination, and
resulting state agree.

## Product Oracles

The page-task model in
[MOONTOWN_UI_UX_V4_TASK_MODEL.md](MOONTOWN_UI_UX_V4_TASK_MODEL.md) is the
primary UX oracle. Generated contracts, backend responses, and test fixtures
are implementation evidence; they do not override a broken user journey.

The expected learning limits are:

| Surface | Familiar model | Maximum first-use learning |
| --- | --- | --- |
| Home | activity dashboard | 5 seconds |
| Discover | search or marketplace | 5 seconds |
| Messages | mobile chat inbox | 10 seconds |
| My | profile and personal library | 15-30 seconds |
| Realm | map and world inspector | 30-60 seconds |
| Reviewer | operations console | trained use |

## Test Environment

- repository: `/Users/kq/Workspace/bunnia`
- target: generated WeChat mini-program
- generated project: `_build/bunnia/wechat/moontown_miniapp`
- ordinary persona: Ada Builder
- secondary fixtures: public users, circles, agents, books, and places from the
  deterministic demo projection
- reviewer persona: deliberate entry through My > Reviewer Tools
- phone baseline: WeChat DevTools iPhone 12/13 Pro viewport
- backend: clean local state on `http://127.0.0.1:18191`

Each simulator run begins from a strict rebuild and reset backend state. Tests
that mutate profile, review, run, message, or building state record both the UI
result and backend response or persisted state.

## Methodology

### Layer 1: Build And Contract Integrity

Run:

```sh
moon check
moon test
moon info
moon run cmd/main -- build --target wechat --example moontown_miniapp --strict --budget large --render-budget large
moon run cmd/main -- inspect --target wechat --example moontown_miniapp --budget large --render-budget large
sh scripts/validate_boundaries.sh
sh scripts/validate_moontown_ordinary_copy.sh
```

Pass conditions:

- all tests pass
- public API generation is stable
- strict release readiness is 8/8
- diagnostics, missing event patches, orphan patches, duplicate keys, and
  degraded scenes are zero
- ordinary pages contain no backend, payload, endpoint, cursor, or DevTools
  labels

### Layer 2: Backend Behavior And Persistence

Run the built-in backend smoke, then start a reset-state server. Exercise login,
snapshot, discover, message center, message send, review decision, run recovery,
profile, ownership, building lifecycle, subscription, and reviewer operations.

Pass conditions:

- successful requests return the documented result shape
- invalid or unauthorized requests fail without corrupting state
- state-changing requests survive a subsequent read
- the UI event has a reachable backend endpoint
- user-visible completion does not depend on a reviewer-only endpoint

### Layer 3: Live Simulator Journeys

Use WeChat DevTools automation for route launch, taps, inputs, scroll, and DOM
inspection. Test through visible controls whenever possible. Direct route
launches are allowed only for setup and isolated page inspection.

For every action record:

- route before and after
- visible label used by the user
- event message emitted
- selected or active state after the action
- relevant text change
- backend state change when applicable

### Layer 4: Visual And Interaction Geometry

Measure the first viewport and scroll completion on every ordinary page.

Pass conditions:

- no blank primary surface, overlap, clipping, or content under the tab bar
- all essential controls are at least 44 by 44 CSS pixels
- adjacent controls have at least 8px separation where separate targeting is
  required
- selected, unread, failed, disabled, and completed states are not indicated by
  color alone
- route purpose and primary action are visible before secondary operations
- text wraps without horizontal overflow
- the final actionable content can scroll above the fixed bottom navigation

Realm additionally requires nonblank map pixels, visible terrain, tappable
markers, stable selection, and bounded pan/zoom behavior.

### Layer 5: Recovery, Privacy, And Familiarity

Test empty, failed, stale, disabled, selected, and completed states where the
fixture or backend supports them.

Pass conditions:

- an error gives a user-level next step
- retry appears only when retry is possible
- private/shared-private content is absent from public discovery
- reviewer diagnostics remain absent from Home, Discover, Realm, Messages, and
  My
- the stable five-tab navigation always provides an understandable recovery
  path
- ordinary pages do not require memorizing event ids or Moontown internals

## Global Cases

| ID | User should see | Why | User can/will do | Expected outcome | Pass evidence |
| --- | --- | --- | --- | --- | --- |
| G1 | Five stable tabs | Familiar mobile navigation | Tap each tab | Correct route and active state | path, active tab, labels |
| G2 | Page title and concise subtitle | Immediate orientation | Identify page purpose | Purpose is clear before scrolling | first viewport text |
| G3 | Persistent profile entry | Identity and setup recovery | Open My | My opens without losing tab access | route and active state |
| G4 | No technical labels | Ordinary users need product language | Scan all ordinary routes | No endpoint/runtime leakage | generated and live text audit |
| G5 | Safe top and bottom clearance | Controls must remain usable | Scroll to final action | Nothing is hidden by chrome/tab bar | offsets and scroll bounds |
| G6 | Stable state feedback | Taps require confirmation | Tap filters and rows | Active/selected state changes | class/data/text delta |

## Home Cases

| ID | User should see | Why | User can/will do | Expected outcome | Achievable when |
| --- | --- | --- | --- | --- | --- |
| H1 | One highest-priority lead | Home answers "what needs me?" | Tap its single action | Owning workflow opens | destination is reached in one tap |
| H2 | Compact urgency counts | Support prioritization | Scan, not operate | User understands workload | counts do not compete with lead |
| H3 | Town Gates | Familiar shortcut fallback | Tap Browse/Review/Verify/place gate | Correct primary tab opens | every gate emits a live route |
| H4 | Recoverable stale/failed lead | Failures need a next step | Tap Try Again or destination | State reloads or owning page opens | action is allowed and visible |

## Discover Cases

| ID | User should see | Why | User can/will do | Expected outcome | Achievable when |
| --- | --- | --- | --- | --- | --- |
| D1 | Search field and filters first | Familiar universal search | Enter query or tap filter | Results narrow and active filter changes | response and list agree |
| D2 | Title, type, eligibility, one action | Fast result comparison | Tap the result action | Correct object/destination opens | one clear action per result |
| D3 | Ordinary empty state | Recovery without internals | Change query/filter | Results can return | no cursor/payload language |
| D4 | Public results only | Enforce visibility boundary | Search broad terms | Private/shared-private items stay absent | fixture IDs are absent |
| D5 | More only when paging exists | Progressive disclosure | Tap More | Additional results append without duplicates | count/key delta |

## Realm Cases

| ID | User should see | Why | User can/will do | Expected outcome | Achievable when |
| --- | --- | --- | --- | --- | --- |
| R1 | Full-bleed terrain and markers | Realm is spatial first | Scan/pan map | Map remains nonblank and bounded | asset pixels and viewport state |
| R2 | Selected marker plus detail drawer | Familiar map inspection | Tap Policy Hall marker | Drawer shows the same place | selected ID, title, drawer |
| R3 | Ask as dominant action | Core place interaction | Tap Ask and submit message | Message request succeeds in place context | event/backend/readback agree |
| R4 | Messages and Find Similar | Long tasks belong elsewhere | Tap either handoff | Contextual route opens | selected building context persists |
| R5 | Lifecycle action for eligible owner | Placement/publishing belongs here | Tap allowed action | Lifecycle state changes or blocker explains why | visible state and backend agree |
| R6 | Stable pan/zoom and close/reselect | Spatial recovery | Drag, zoom, close, select again | No blank map or lost controls | transform bounds and drawer state |

## Messages Cases

| ID | User should see | Why | User can/will do | Expected outcome | Achievable when |
| --- | --- | --- | --- | --- | --- |
| M1 | Chats before task queues | Match familiar messengers | Scan avatar/title/preview/unread | Full inbox understood before domain work | order and first viewport geometry |
| M2 | All/Unread/Activity/Replies/Notices | Familiar narrowing | Tap each filter | Active chip and rows match filter | row kinds/counts agree |
| M3 | Whole-row tap target | Remove repeated button learning | Tap a conversation row | Correct place/person/task opens | row event reaches destination |
| M4 | Priority review below Chats | Separate conversation from decisions | Open Review and accept/reject | Review leaves pending state | UI/backend/readback agree |
| M5 | Agent Work with valid recovery | Operational task completion | Stop active work or retry failed work | Run status changes | action appears only when allowed |
| M6 | Result acknowledgement/review | Close completed work | Open place/review result | Result destination opens or pending ack clears | state transition is visible |
| M7 | Compact refresh icon | Keep inbox synchronized | Activate refresh | Message-center data reloads | endpoint executes and list remains usable |

## My Cases

| ID | User should see | Why | User can/will do | Expected outcome | Achievable when |
| --- | --- | --- | --- | --- | --- |
| Y1 | Identity and highest setup need | Profile is the page anchor | Complete role/consent/profile task | Readiness advances | UI/backend/readback agree |
| Y2 | Inventory filters and owned rows | Familiar personal library | Choose filter and open item | Matching owned item or Realm opens | list and destination agree |
| Y3 | Publishing blocker/current stage | Explain why work cannot advance | Tap available lifecycle action | Stage advances or blocker remains explicit | no hidden prerequisite |
| Y4 | Refresh My Stuff | Restore current ownership state | Tap refresh | Inventory reloads without technical copy | endpoint succeeds |
| Y5 | Deliberate Reviewer Tools gate | Keep operations separate | Open Reviewer Tools | Reviewer route opens intentionally | no other ordinary entry leaks |

## Reviewer Cases

| ID | User should see | Why | User can/will do | Expected outcome | Achievable when |
| --- | --- | --- | --- | --- | --- |
| V1 | Clearly operational, denser console | Trained surface differs from consumer UI | Identify section | Operator can locate safety/readiness/moderation | headings and grouping |
| V2 | Check Town Safety/Launch Checks | Explicit inspection actions | Run checks | Result state appears without blocking UI | backend and visible result |
| V3 | Moderation actions with context | High-impact action needs traceability | Execute fixture-safe action | Case/audit state changes | backend readback |
| V4 | Return to My | Predictable recovery | Tap return | My opens with five-tab shell | route and active state |
| V5 | Diagnostics confined here | Protect ordinary users | Compare route text sets | Allowed technical labels exist only here | cross-route text audit |

## Cross-Page Journeys

These are the release-blocking task paths:

1. **Review:** Home lead -> Messages -> review decision -> decision no longer
   pending.
2. **Find a place:** Discover search/filter -> result -> Realm -> matching
   selected drawer.
3. **Ask a place:** Realm marker -> Ask -> send -> message survives reload.
4. **Handle agent work:** Messages -> Agent Work -> stop/retry/review result ->
   status changes.
5. **Manage owned work:** My -> inventory filter -> owned item -> Realm or
   lifecycle action.
6. **Complete identity:** My setup -> save role/consent/profile -> readiness
   advances.
7. **Operate deliberately:** My -> Reviewer Tools -> safety/launch check ->
   return to My.

A journey fails if a control is present but inert, the route loses the selected
object, a success message appears without persisted state, or the user must use
a direct URL/technical identifier to finish.

## Severity And Release Decision

| Severity | Meaning | Release effect |
| --- | --- | --- |
| P0 | data/privacy loss, destructive wrong action, app cannot launch | block |
| P1 | primary journey cannot be completed, dead primary control | block |
| P2 | recovery, hierarchy, clipping, or state feedback materially impairs use | fix in this iteration |
| P3 | polish or low-frequency inconsistency | document; fix if low risk |

V4 passes E2E only when:

- all seven release-blocking journeys pass
- no P0/P1 findings remain
- no ordinary page exceeds its learning model because of unfamiliar controls
- strict generation and full CI remain green after any fixes
- remaining P2/P3 findings have explicit evidence and disposition

## Evidence Format

The report will contain:

- environment and commit SHA
- commands and machine-readable summaries
- one result row per test ID: pass, fail, blocked, or not applicable
- before/action/after evidence for state-changing journeys
- route geometry and interaction counts
- defects ordered by severity with file references
- fixes and retest results
- final release decision and residual risk
