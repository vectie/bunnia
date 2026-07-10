# Moontown UI/UX Doctrine

This document records the UI/UX reasoning from the reference screenshots in
`/Users/kq/Desktop/ref_design` and turns it into product rules for the Bunnia
Moontown mini-app.

For phase-by-phase execution, use the companion implementation plan in
[MOONTOWN_UI_UX_IMPLEMENTATION_PLAN.md](MOONTOWN_UI_UX_IMPLEMENTATION_PLAN.md).
For exact page jobs and acceptable learning time, use
[MOONTOWN_UI_UX_V4_TASK_MODEL.md](MOONTOWN_UI_UX_V4_TASK_MODEL.md).

The core decision is:

```text
The backend is the engine. The user product is a tile-gamified city.
```

Normal users should see places, people, buildings, agents, actions, progress,
and recoverable problems. They should not see endpoint names, payload keys,
runtime fields, DevTools targets, HTTP paths, or diagnostic state unless they
explicitly enter a developer/reviewer mode.

## Thinking Procedure

Use this reasoning procedure before adding or reviewing any visible UI.

1. Read the screen as an ordinary user, not as an implementer.
2. Ask what one thing the user is trying to achieve at this moment.
3. Identify the user-facing place that owns the job: Home, Discover, Realm,
   Messages, My, building drawer, or review drawer.
4. Translate technical state into a town object, town action, or town warning.
5. Hide anything that does not help the user decide or act now.
6. Keep the surface visually native to Moontown: tile map, districts, market
   board, mail board, inventory shelf, stamps, drawers, badges, signposts.
7. Check whether the screen still works if every backend label is removed.

If a screen only makes sense because the user can read debug terms, the UI is
not product-ready.

## Reference Reading

The reference screenshots show a consistent product pattern.

### First-Run Screens

The onboarding sequence teaches one idea per screen:

- "New AI Walker": identity and emotion.
- "Inspiration Square": people share findings.
- "Community Center": product, demand, activity, and nearby life.
- "City Base": Home, Realm, and My are explained as places.

The screen never starts with system architecture. It gives one title, one short
sentence, one progress marker, and one obvious action.

Moontown rule:

- Onboarding should answer "what is this place?" and "what can I do next?"
- Do not expose backend readiness, sync status, endpoint paths, or payload
  names in onboarding.
- If setup is required, frame it as a town passport, role, consent, and entry
  gate.

### Role Setup

The role screen asks "who are you here?" It offers identity cards and consent.
The user is choosing a social/product posture, not editing account internals.

Moontown rule:

- Profile setup should present roles as town identities.
- Consent and account state can exist, but the visible job is "choose how I
  enter town."
- Disabled completion should explain the missing user action, not the missing
  backend field.

### Home

The reference Home highlights one active circle, key counts, people, and major
entry points. It answers "what is happening and where can I enter?"

Moontown rule:

- Home should be a town pulse, not a backend control panel.
- Show public activity, district gates, people/agents, and attention signals.
- Local backend controls belong in a developer panel or hidden diagnostics mode.

### Discover

Discover is a search-first surface. It offers search, people, circles, and
content. The user job is "find something useful."

Moontown rule:

- Discover should show search, filters, result cards, and one clear action per
  result. Watch and place belong after opening the destination.
- "Next" should become "More" or "Load more" when visible to users.
- Cursor, query payload, result window, and endpoint language should stay
  invisible.

### Realm

The reference Realm is spatial and emotional. It shows membership and places
through a map-like visual system.

Moontown rule:

- Realm is only the existing Moontown map.
- Users care about what is here, what is new, who is active, what can be
  entered, and what can be placed.
- Scene diagnostics, marker ids, projection internals, and sync state should
  stay out of ordinary map UI.

### Messages

The reference Messages screen uses three understandable buckets:

- new follows
- interactions
- system messages

It also asks users to subscribe to important notifications in plain language.

Moontown rule:

- Messages should answer "who needs my attention?"
- Messages should use a familiar conversation-list structure before review and
  agent-work sections: avatar, title, one-line preview, unread state, and a
  whole-row tap target.
- Agent runs should be translated into user tasks: reply, review, accept,
  reject, retry, inspect result.
- "Ack Sync", "Tool Ack", "message center", and backend status should be
  renamed or hidden.

### My

The reference My screen shows identity, simple counts, benefits/assets, and
personal tabs. The user job is "what is mine and what can I manage?"

Moontown rule:

- My should show profile, owned buildings, books, agents, drafts, published
  work, watches, and notices.
- Reviewer/admin tools should not appear in ordinary My unless the user is in a
  reviewer role and has intentionally opened an operations surface.
- Account readiness should be presented as profile completion or publishing
  readiness, not raw permission state.

## One-Thing Rule

At any moment, an ordinary user usually cares about one primary job:

| Moment | User cares about | Best Moontown surface |
| --- | --- | --- |
| First entry | What is this place? | onboarding signpost |
| Setup | Who am I here? | town passport |
| Home | What changed? | town pulse |
| Search | What can I find? | market board |
| Map | Where is it? | Realm map |
| Building | What can this place do? | building drawer |
| Agent work | What did the agent do and what is next? | mail/review row |
| Ownership | What is mine? | inventory shelf |
| Failure | What happened and how do I recover? | retry row |

Every visible panel should have one of those jobs. If it has multiple jobs,
split it, demote secondary information, or move technical detail into
diagnostics.

## Translate System State

System state is still necessary, but it must be translated before it reaches
ordinary user space.

| System term | User-facing translation |
| --- | --- |
| Backend Loop | Town Updates, hidden developer tools |
| DevTools target | hidden |
| Sync Ownership | Refresh My Stuff |
| Own Sync | My Inventory |
| load-message-center | Latest Messages |
| Ack Sync | Mark Read |
| Tool Ack | Review Result |
| runtime filter | hidden |
| runtime channel | hidden |
| backendStatus idle | hidden |
| endpoint ready | hidden |
| HTTP method/path | hidden |
| cache stale | Needs refresh |
| request failed | Could not update. Try again. |
| cursor/window | More |
| run waiting-review | Agent needs your decision |
| payload | hidden |
| admin ops | Reviewer Tools |
| readiness check | Launch Checks |

The visible UI should explain the user consequence, not the implementation
mechanism.

## Product Surfaces

### Home

Home should prioritize:

- active town/circle summary
- district entry points
- recent activity
- attention counts
- nearby people/agents/buildings

Home should not prioritize:

- endpoint lists
- DevTools URLs
- raw cache rows
- backend method/path text

### Discover

Discover should prioritize:

- search field
- human-readable filters
- people/circles/products/demands/events/posts
- clear result actions
- "More" for additional backend windows

Discover should not prioritize:

- query payloads
- cursor values
- backend result metadata
- endpoint ids

### Realm

Realm should prioritize:

- the map
- buildings and placements
- active/unread/review badges
- selected building drawer
- place/open/query actions

Realm should not prioritize:

- scene diagnostics
- projection details
- marker internals
- backend sync labels

### Messages

Messages should prioritize:

- Needs Review
- Agent Replies
- Interactions
- Town Notices
- subscription prompt
- retryable failures

Messages should not prioritize:

- ack endpoint names
- tool ack terminology
- backend center/sync text
- raw run ids

### My

My should prioritize:

- identity card
- profile readiness
- owned buildings/books/agents
- drafts and published work
- watched places
- manageable alerts

My should not prioritize:

- admin operations by default
- production secret checks
- raw permission fields
- backend ownership endpoint names

## Agentic UI Rule

Agentic UI must make agents first-class, but not as backend processes.

Users need to understand:

- who is speaking or acting
- what the agent did
- what changed in the town
- whether the user must decide
- what action is available now

Therefore, agentic UI should use:

- agent badges
- mail rows
- review stamps
- result cards
- building-thread context
- accept/reject/retry/reply actions

Avoid making users reason about:

- runs as infrastructure
- tool result acknowledgements
- raw thread ids
- backend mutation state

## Map-Heavy UI Rule

The map is the emotional anchor. Other screens should route back to it, but not
compete with it.

Use the map for:

- place
- presence
- activity badges
- building selection
- spatial memory

Use other screens for:

- long search lists
- ownership management
- message streams
- profile setup
- backend recovery

Do not turn Realm into chat, admin, search, or diagnostics. Those jobs can link
to a building or marker, but they should not replace the map.

## Diagnostics Boundary

Developer/reviewer information is allowed, but it needs a boundary.

Ordinary user mode may show:

- "Needs refresh"
- "Try again"
- "Waiting for review"
- "Saved"
- "Published"
- "Agent needs your decision"

Developer/reviewer mode may show:

- endpoint id
- HTTP method/path
- payload key
- backend status
- rate limit bucket
- audit retention
- readiness checks
- package/render diagnostics

If a piece of text is only useful to a developer, it must not appear in the
ordinary surface.

## Implementation Priority

The next UI cleanup should happen in this order:

1. Rename visible system panels into user-facing town surfaces.
2. Hide HTTP paths, endpoint names, payload names, runtime labels, and raw
   backend status from ordinary UI.
3. Convert sync controls into action words: Refresh, More, Retry, Review,
   Mark Read.
4. Move Ops/Readiness tools behind reviewer/admin gating.
5. Make each tab answer one user question:
   - Home: what is happening?
   - Discover: what can I find?
   - Realm: where are places?
   - Messages: who needs me?
   - My: what is mine?
6. Preserve the current tile-gamified style while making labels more ordinary.

## Review Checklist

Before accepting a visible UI change, answer:

- What single user job does this screen serve?
- Does every label use user language?
- Are system details hidden unless they directly help recovery?
- Is the primary action obvious?
- Can a first-time user understand the screen without knowing backend terms?
- Does the UI still feel like a tile town?
- Are touch targets large enough for mini-app use?
- Is content hidden behind the bottom navigation?
- Does the screen remain useful when backend diagnostics are removed?

If any answer is weak, the screen needs another UX pass before more features are
added.
