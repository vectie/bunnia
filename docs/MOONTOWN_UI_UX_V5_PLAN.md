# Moontown V5 UI/UX Plan

V5 is a hierarchy and legibility iteration based on a live iPhone 12/13 Pro
review in WeChat DevTools on 2026-07-13. V4 established understandable page
jobs and familiar interaction models. V5 should make those models readable at
normal phone distance without removing product capability.

## Live Findings

- WeChat's native page title and the in-app title block repeat the route name on
  every ordinary page.
- ordinary body copy is commonly `18rpx` and metadata is `16rpx`; both render
  too small for comfortable scanning.
- semi-transparent panels let the detailed Realm map compete with text on Home,
  Discover, Messages, and My.
- Realm gives roughly one third of its first viewport to the map while the
  selected-place workbench begins immediately and dominates the screen.
- Home shows too many equal-weight Town Gate cards after its correct single
  priority lead.
- Discover exposes eleven primary filters at once and renders actions as large
  full-width blocks, making a familiar search page feel crowded.
- Messages is the strongest route because its avatar, title, preview, unread
  state, and whole-row tap target match a familiar inbox.
- My repeats identity and readiness across the global title block, profile,
  Town Passport, Public Passport, and publishing sections.
- status color is useful, but pastel backgrounds are applied to too many
  ordinary containers and weaken hierarchy.

## Product Decision

Keep the five route jobs and V4 handoffs. Do not add new destinations or
features in V5. Improve the shared reading shell first, then simplify each
route's first viewport. Realm remains expressive and map-led; the other routes
should feel like quiet mobile utilities placed within the same world.

## Phases

| Phase | Priority | Outcome |
| --- | --- | --- |
| V5.0 Launch Correctness | complete | Compile route filters into valid, compact WXML and require a live DevTools compile gate. |
| V5.1 Reading Shell | highest | Remove duplicate route headings, raise type sizes, increase surface opacity, and unify active navigation color. |
| V5.2 Realm Map First | highest | Keep at least half of the first viewport for the map and show a compact selected-place sheet before detailed work. |
| V5.3 Home And Discover | high | Reduce equal-weight gates and filters so each page presents one obvious first action. |
| V5.4 My Disclosure | high | Merge identity/readiness and move passport history, publishing detail, and reviewer access below inventory or behind deliberate entry. |
| V5.5 Messages Polish | medium | Preserve the current inbox model while improving type, refresh affordance, and separation between chats and tasks. |
| V5.6 Device Signoff | continuous | Validate first viewport, complete scroll, filters, drawers, and handoffs in WeChat on small and large phones. |

## Shared Shell Contract

- Use the native WeChat title as the route title. Remove the repeated in-app
  eyebrow/title/subtitle block from Home, Discover, Messages, and My.
- Keep ordinary body text at `26rpx` or larger, secondary text at `22rpx` or
  larger, and tab labels at `22rpx` or larger.
- Use near-opaque neutral reading surfaces. The map may remain visible at page
  edges, but never directly beneath dense text.
- Use one product accent for active tabs and primary actions. Reserve green,
  amber, and red for success, waiting, and destructive/error meaning.
- Keep all touch targets at least `88rpx` in both dimensions.
- Keep one dominant action in the first viewport and one explicit action per
  repeated result.

## Route Changes

### Realm

Default to a compact sheet containing selected place, status, one supporting
line, and Ask. Messages, Find Similar, shelves, workers, lifecycle, and
communication expand below or after an explicit detail action. The map should
remain visible for at least half of the first viewport after selection.

### Home

Keep the current priority lead and three counts. Replace five explanatory Town
Gate cards with at most three compact destination rows chosen by relevance.
Nearby presence belongs after those destinations, not in the first decision
area.

### Discover

Keep Search, then expose All, Places, People, and More as the primary filter
set. Put the full taxonomy in a secondary horizontal selector or menu. Render
results as familiar rows with title, type/status metadata, and a compact
trailing action instead of a large empty card plus full-width button.

### Messages

Preserve the current chat-list composition. Make refresh a conventional icon
button with an accessible label, increase preview type, and give Chats and
Tasks a clear section transition. Do not reintroduce nested actions inside chat
rows.

### My

Use one identity header with readiness and counts. Show the single blocking or
recovery task next, then My Inventory. Public Passport, Publishing Shelf, and
Reviewer Tools are secondary management destinations and should not compete in
the first viewport.

## Acceptance

- a user can name each ordinary page's job within five seconds
- no ordinary route repeats its native title inside the first viewport
- all ordinary body and metadata text meets the shared type floor
- textured map pixels do not sit directly behind reading-heavy content
- Realm keeps at least 50% of the first viewport spatial after selecting a place
- Home shows one lead and no more than three first-level destinations
- Discover shows no more than four primary filter choices at once
- Messages retains whole-row chat navigation and distinct unread structure
- My shows identity once and inventory before historical publishing detail
- all six routes compile with zero WXML errors and complete their V4 handoffs
