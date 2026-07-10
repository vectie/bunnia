# Moontown UI/UX V2 Plan

This iteration starts after the original UI/UX implementation plan. The first
track established product language, route boundaries, diagnostics gating,
recoverable states, and modular town surfaces. V2 turns that complete
foundation into a polished consumer experience.

The governing rule is progressive disclosure:

```text
one screen question
one dominant first-screen action
details after intent
technical state only when it changes the next user action
```

## Success Criteria

- each tab has an immediately recognizable purpose and visual anchor
- the first phone viewport is useful without scanning a wall of rows
- Realm is visually central without weakening the other four destinations
- My separates identity, attention, inventory, publishing, and reviewer work
- town metaphors are expressed by composition, not only by labels
- touch targets, safe areas, recovery states, and rendering budgets stay green

## Phases

| Phase | Priority | Outcome |
| --- | --- | --- |
| V2.0 Experience Hierarchy | highest | Establish screen hierarchy, progressive disclosure, and first-viewport rules. |
| V2.1 Shell And Navigation | highest | Remove duplicate shell controls and give Realm a distinct, stable nav position. |
| V2.2 My Composition | highest | Separate passport, attention, inventory, setup, publishing, and reviewer work. |
| V2.3 Home And Discover | high | Give activity and search stronger visual anchors and shorter action paths. |
| V2.4 Messages | high | Make review, replies, and failed work scan as a true attention inbox. |
| V2.5 Realm And Drawers | high | Strengthen marker hierarchy and make the object drawer feel attached to place. |
| V2.6 Visual Identity | medium | Consolidate type, color, depth, icons, and town-object primitives. |
| V2.7 Device Validation | continuous | Verify small phone, large phone, landscape, accessibility, and DevTools flows. |

## V2.0 And V2.1 Current Slice

- replace product-wide top-bar commands with active-screen context
- keep one deliberate passport entry instead of duplicating navigation
- make the center Realm destination visually distinct without layout movement
- give page grids tab-specific composition hooks
- preserve the existing five-route contract and safe-area behavior

## V2.2 Current Slice

- lead My with identity and tasks that need attention
- keep inventory in its own dominant work area
- move setup, public identity, publishing, creation, and reviewer entry into
  separate sections instead of one nested control surface
- retain all existing actions and backend contracts without compatibility code

## V2.3 Current Slice

- make Home choose one lead item by user impact: review work, recovery, then
  recent change
- keep completed onboarding out of the normal Home flow
- summarize changed places, attention, and nearby presence without duplicating
  navigation commands
- turn district access into a compact gate grid below the town pulse
- make Discover one full-width search workflow instead of pairing it with a
  duplicate district panel
- place search, filters, result count, and actionable results before secondary
  browse strips
- give each result one primary action and visually subordinate place/watch
  actions
- keep the existing discovery, placement, subscription, and route contracts

## V2.4 Current Slice

- choose one inbox lead by urgency: pending review, failed recovery, active
  work, then unread town signals
- separate decisions, active work, completed results, and recent notices into
  clear scanning regions without duplicating their content
- hide unavailable run controls instead of presenting disabled implementation
  state
- establish a consistent action hierarchy: primary next step, secondary
  navigation or acknowledgement, and caution for rejection or cancellation
- keep the inbox summary and notice feed full width, with decision and work
  panels paired on larger screens and stacked on phones
- preserve the existing message, review, work, notification, and place event
  contracts without compatibility branches

## V2.5 Current Slice

- make the selected place the dominant map marker while keeping neighboring
  places quieter and fully tappable
- show marker badges only for the selected place or meaningful review, active,
  private, and shared signals
- move access, placement, worker, and work facts into the selected-place sheet
  instead of duplicating them in a detached bottom HUD
- use a bounded side sheet on larger screens and a bottom sheet above tab
  navigation on phones so the map remains visible and interactive
- keep the first drawer viewport focused on place identity and Ask, with
  Messages and Find Similar visually subordinate
- present drawer sections as separated content bands, move reporting to the
  end, and omit unavailable lifecycle controls
- preserve map gestures, marker coordinates, and all existing action/event
  contracts without compatibility branches

## V2.6 Current Slice

- retain the established ink, rose, blue, green, gold, and cloud palette while
  assigning each color a consistent semantic role
- distinguish Home/My identity, Discover, review attention, and work/inventory
  panels with restrained top accents instead of decorative backgrounds
- differentiate category, access/owner, and eligibility/status badges so their
  meaning can be scanned before reading every label
- give discovery, review, work, notice, ownership, and inventory rows consistent
  semantic edge accents across routes
- allow compact titles and badges to wrap safely instead of truncating dynamic
  names
- align Reviewer with the ordinary town palette and type scale, removing the
  legacy beige and brown visual branch
- keep depth concentrated in navigation, selected map objects, and drawers
  rather than turning every page section into a floating card

## V2.7 Current Slice

- validate Realm, Home, Discover, Messages, My, and Reviewer in WeChat
  DevTools on the iPhone 12/13 simulator at a 390 by 753 content viewport
- remove the universal child selector rejected by the WXSS compiler and guard
  generated styles against reintroducing it
- replace mixed `rpx` and safe-area calculations with independently computed
  safe-area positions and spacing margins so shell geometry remains stable
- style generated list wrappers explicitly so navigation and action controls
  retain their intended horizontal layout
- turn the mobile onboarding guide into a readable two-column grid while
  retaining Discover filters as a verified horizontal overflow strip
- reset Reviewer to a true top-aligned standalone surface instead of inheriting
  the ordinary-route header offset
- restore semantic button-label contrast by inheriting each button's text color
- verify drawer/navigation clearance, touch target sizing, route scrolling, and
  computed primary-action contrast in the live simulator
- keep small-phone, large-phone, and landscape presets in the continuous device
  matrix until each preset is captured and inspected directly

## Validation

Implementation happens before testing for each slice. After the slice is
complete, run focused MoonBit tests, the complete Moontown package, generated
ordinary-copy checks, inspection budgets, and the repository CI script. Device
and DevTools visual checks follow when rendered UI changes are available.
