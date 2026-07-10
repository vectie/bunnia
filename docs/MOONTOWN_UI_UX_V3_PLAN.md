# Moontown UI/UX V3 Plan

V3 is an information-diet iteration. V2 established the route hierarchy,
responsive shell, semantic color, and device-safe layout. V3 reduces the amount
of interface users must read before they can act.

The governing content budget is:

```text
one route title
one first-screen decision
up to three supporting facts
one primary action per repeated item
details only when they change the decision
```

## Success Criteria

- each first viewport has one dominant question and action
- route titles are not repeated as panel titles
- summaries are not repeated beside equivalent metadata
- secondary discovery, history, and diagnostics stay below the primary task
- repeated rows use quiet surfaces instead of independent card decoration
- existing actions, backend effects, safe areas, and touch targets remain intact

## Phases

| Phase | Priority | Outcome |
| --- | --- | --- |
| V3.0 Content Budget | highest | Remove duplicate titles, notes, summaries, and route-level explanations. |
| V3.1 First Viewports | highest | Give Home, Messages, My, Discover, and Realm one dominant first-screen task. |
| V3.2 Progressive Detail | high | Keep secondary inventory, history, notices, and object detail below the first decision. |
| V3.3 Quiet Surfaces | high | Reduce repeated borders, shadows, badges, and competing color fields. |
| V3.4 Device Validation | continuous | Recheck clipping, scroll completion, contrast, safe areas, and route transitions in DevTools. |

## V3.0 To V3.3 Current Slice

- replace Home's two overlapping onboarding systems with one Realm entry
- keep Home's highest-priority live decision and three facts, removing the
  duplicated activity feed from the first route surface
- make Discover search and filtered results the complete workflow, removing
  repeated browse strips and one redundant badge per result
- keep Messages lead context, metadata, and actions while removing repeated row
  summaries and panel instructions
- lead My with identity and one next task, remove the duplicate Town Credential
  panel, and reduce profile metrics to review and publishing state
- remove repeated selected-place and primary-book labels from the Realm drawer
- quiet repeated row surfaces by removing decorative shadows and blue fill
- remove My's duplicated shelf strip after device review, keep pending setup only,
  and reduce publishing detail to the current and blocking stages

## V3.4 Device Finding

The first iPhone 12/13 Pro capture confirmed the ordinary routes were quieter,
but My still rendered 3,860 text characters across an 8.5-screen scroll. The
duplicate shelf strip, completed setup gates, role catalogue, and full lifecycle
timeline were removed from the default route. The underlying ownership, role,
and lifecycle projections remain available without competing with the next task.
Geometry inspection also found 45-73px secondary columns caused by inherited
grid spans, so My now uses one explicit column without responsive span resets.

## Validation

Implement the complete content and composition slice before testing. Then run
focused route tests, the full MoonBit suite, strict WeChat inspection/build
gates, the ordinary-copy guard, repository CI, and rendered DevTools review.
