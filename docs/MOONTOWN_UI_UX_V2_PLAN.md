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

## Validation

Implementation happens before testing for each slice. After the slice is
complete, run focused MoonBit tests, the complete Moontown package, generated
ordinary-copy checks, inspection budgets, and the repository CI script. Device
and DevTools visual checks follow when rendered UI changes are available.
