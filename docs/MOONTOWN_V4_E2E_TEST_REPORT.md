# Moontown V4 End-to-End Test Report

Date: 2026-07-10

Plan: `docs/MOONTOWN_V4_E2E_TEST_PLAN.md`

## Decision

**Product checks pass; final simulator signoff is blocked by the local WeChat
DevTools automation environment.**

No open P0 or P1 product defect remains in build, generated-contract, backend,
privacy, or persistence evidence. The final bundle builds with 8/8 release
readiness and zero diagnostics. Formal E2E release status remains **blocked**
until the seven cross-page journeys are rerun in a DevTools project with a
working AppID/app-launch automation session.

This is not attributed to the final UI patch: the same post-restart launch
failure reproduces from known-good commit `593aba3` in an isolated worktree.

## Method

Each page was tested against the six-part oracle from the plan:

1. what the user should see
2. why it belongs on the page
3. what the user can do
4. what the user will normally do
5. the expected visible and persisted outcome
6. whether the user can complete the task without technical knowledge

Evidence was gathered in five layers: generated contracts, backend and
persistence, live simulator journeys, visual geometry, and recovery/privacy.
Failures were fixed from the highest-impact journey outward, then all automated
checks were rerun together.

## Environment

- repository: `vectie/bunnia`
- plan commit: `7e9fb35`
- secured-session baseline: `593aba3`
- final implementation: the commit containing this report
- target: WeChat mini-program
- generated project: `_build/bunnia/wechat/moontown_miniapp`
- backend: `http://127.0.0.1:18191`
- MoonBit tests: 234/234 passed
- focused Moontown tests: 27/27 passed
- strict build: 187,761 bytes, 8/8 ready, 0 diagnostics
- Realm first screen: 74,737/76,000 bytes
- max update payload: 2,577/4,096 bytes
- event patch operations: 125/160
- engineering debt: 124 pre-existing warning 73 annotations, 0 errors

## Page Outcomes

### Home

- **See:** one priority lead, compact counts, Town Gates, nearby presence, and
  the stable five-tab shell.
- **Why:** Home answers "what needs me now?" and provides familiar fallback
  navigation without exposing operations internals.
- **Can/will do:** open the lead or use Browse, Review, and Verify gates.
- **Expected:** the owning Discover, Messages, or My route opens in one tap.
- **Achievable:** generated route contracts pass; the pre-fix live audit found
  inert controls, and explicit route attributes now cover each one. Final live
  retest is blocked by DevTools launch.

### Discover

- **See:** search and filters first, followed by compact public result rows.
- **Why:** this matches familiar search/catalog behavior and minimizes learning.
- **Can/will do:** narrow to a type or Placeable, then open one result.
- **Expected:** the active filter and visible rows agree; opening a place enters
  Realm with that place selected.
- **Achievable:** reactive filter/list and destination contracts pass. Public
  discovery excludes private and shared-private fixtures. Final live retest is
  blocked by DevTools launch.

### Realm

- **See:** full-bleed terrain, nine markers, one selected marker, and a matching
  detail drawer.
- **Why:** map selection must follow the familiar marker-to-detail model.
- **Can/will do:** pan, select a marker, inspect its title, and use the Policy
  Hall Ask/Messages/Find Similar actions.
- **Expected:** `town.selectedBuildingId`, selected styling, and drawer title
  describe the same place; Policy Hall Ask persists a reviewable request.
- **Achievable:** reactive marker and title contracts pass; Ask backend and
  persistence passed earlier live and in backend smoke. Final visual retest of
  non-default selection is blocked by DevTools launch.

### Messages

- **See:** familiar chat rows first, then a priority lead, review queue, and
  agent work.
- **Why:** inbox scanning should require no Moontown-specific learning before
  operational work appears.
- **Can/will do:** filter, tap a whole conversation row, decide a review, or
  recover agent work.
- **Expected:** filters update rows, ordinary rows open their place/Discover
  destination, and accepted/rejected memory review UI leaves pending state.
- **Achievable:** row destinations, reactive filters, pending-state conditions,
  backend review persistence, retry, and cancel contracts pass. Final live
  retest is blocked by DevTools launch.

### My

- **See:** Ada's ready passport, one recovery alert, inventory filters, owned
  rows, publishing state, refresh, and a deliberate Reviewer Tools gate.
- **Why:** identity and owned work belong in a familiar personal-library page.
- **Can/will do:** filter inventory, open an item, refresh ownership, manage an
  eligible lifecycle, or deliberately enter Reviewer Tools.
- **Expected:** list and filter agree, Realm opens when appropriate, refresh
  preserves authenticated scope, and lifecycle blockers are explicit.
- **Achievable:** ready-state consistency, reactive inventory, navigation,
  authenticated ownership, and lifecycle contracts pass. Final live retest is
  blocked by DevTools launch.

### Reviewer

- **See:** a deliberately denser operational surface with safety, readiness,
  and moderation sections, plus Return to My.
- **Why:** technical diagnostics are confined to a trained-user route.
- **Can/will do:** run fixture-safe checks, inspect results, and return to My.
- **Expected:** backend state is visible and ordinary pages remain free of
  endpoint/runtime language.
- **Achievable:** safety/readiness backend actions, return route, and cross-route
  copy confinement pass. Final live retest is blocked by DevTools launch.

## Case Matrix

`Pass` means the required layer has direct evidence. `Contract pass / live
blocked` means the generated behavior and backend contract pass but the final
post-fix tap journey could not be rerun after DevTools stopped launching pages.

| Cases | Result | Evidence |
| --- | --- | --- |
| G1, G6 | Contract pass / live blocked | five route patches; reactive selected/filter state |
| G2-G5 | Pass | six-route text/geometry audit, copy guard, no horizontal overflow |
| H1, H3 | Contract pass / live blocked | explicit destination attributes and focused tests |
| H2, H4 | Pass | hierarchy and recovery contracts |
| D1-D3, D5 | Contract pass / live blocked | reactive filter/list and paging/empty contracts |
| D4 | Pass | public visibility projection and backend smoke |
| R1, R6 | Pass before final patch; final live blocked | nonblank map, 9/9 markers, bounded scene diagnostics |
| R2, R4 | Contract pass / live blocked | reactive marker/title and route contracts |
| R3, R5 | Pass | ask/lifecycle backend and persistence checks |
| M1 | Pass | Chats precede lead; row geometry measured |
| M2-M7 | Contract/backend pass / live blocked | filters, destinations, review conditions, run recovery endpoints |
| Y1 | Pass | fixture and visible passport both ready |
| Y2-Y5 | Contract/backend pass / live blocked | filters, routes, ownership refresh, reviewer gate |
| V1, V5 | Pass | diagnostic grouping and ordinary-copy confinement |
| V2-V4 | Contract/backend pass / live blocked | check/moderation/return routes and persistence |

## Journey Matrix

| Journey | Product evidence | Final live status |
| --- | --- | --- |
| Home -> Messages -> review | destination and decision persistence pass | blocked |
| Discover -> Realm selection | filter, route, marker, and title contracts pass | blocked |
| Realm -> Ask -> reload | backend persistence passes | blocked after prior live pass |
| Messages -> agent work | retry/cancel/review backend contracts pass | blocked |
| My -> owned item -> Realm/lifecycle | filter and destination contracts pass | blocked |
| My identity completion | ready fixture and profile persistence pass | blocked |
| My -> Reviewer -> checks -> My | routes and check endpoints pass | blocked after prior live pass |

## Defects Found And Fixed

### P0: anonymous private-scope access

Protected snapshot, ownership, and message routes previously defaulted an
unauthenticated request to `user-a`. Protected routes now require an opaque
session and reject missing or spoofed identity with `401 missing_session`.

### P1: session lost across pages

The generated adapter now persists, hydrates, and clears the opaque session.
Cached pages hydrate identity during `onShow`, and local DevTools URL checks are
disabled for the loopback backend.

### P1: visible controls were inert

Home leads/gates, Discover/My Open Place, and drawer handoffs now carry explicit
route destinations. Filters patch visible state and condition their lists.

### P1: map selection and drawer disagreed

Marker styling now follows `town.selectedBuildingId`; Realm uses a compact
Realm-only ID-to-title lookup so the drawer title follows the selected marker
without duplicating event payloads.

### P1: chat rows and completed reviews did not resolve

Whole chat rows now open their concrete place or Discover destination.
Memory-review lead and queue entries are visible only while the review is
pending.

### P2: profile and recovery copy disagreed with backend

Ada's projected profile now matches the ready backend fixture. Recovery copy
uses the visible action name `Refresh My Stuff`.

## Geometry Evidence

The last completed six-route live audit, before the final behavior-only repair,
found:

- all ordinary routes had exactly five tabs and one active tab
- no horizontal overflow or ordinary-page technical-copy leak
- all visible controls were at least 44 by 44 CSS pixels
- Realm showed one map image, nine markers, and one selected marker
- Messages showed Chats before the task lead and seven conversation rows
- My scrolled to all inventory/workbench content without tab-bar occlusion
- Reviewer alone exposed four diagnostic sections

The final generated geometry remains under all node, depth, list, scene, update,
and package gates. A final screenshot/offset comparison is still required once
DevTools app launch is restored.

## Simulator Blocker

After DevTools was restarted, `miniprogram-automator` connected but page APIs
stopped completing. DevTools logged:

```text
routeTo appLaunch timeout
appid missing
```

An isolated build of `593aba3` also failed before page launch, including an
automator `checkVersion` failure on missing DevTools version data. Therefore the
remaining block is assigned to the local DevTools project identity/session, not
to the final UI code.

## Required Signoff Rerun

Once DevTools has a valid authorized test AppID and can launch the generated
page, rerun:

1. all seven journeys in the plan
2. six-route first/final viewport geometry
3. Realm non-default marker/title selection
4. Messages unread filter, whole-row route, and review disappearance
5. My placement filter, Open Place, refresh, and Reviewer return

Release status becomes **pass** only when those live results are recorded with
no P0/P1 failure.
