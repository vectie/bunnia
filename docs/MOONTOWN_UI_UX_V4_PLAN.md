# Moontown UI/UX V4 Plan

V4 compresses interaction choice after V3 reduced reading density. Repeated
items should help users choose a destination, not expose every downstream
operation at once.

The interaction budget is:

```text
one lead decision per route viewport
one explicit action per repeated result
secondary operations after opening the destination
one navigator for each content set
```

## Phases

| Phase | Priority | Outcome |
| --- | --- | --- |
| V4.0 Action Budget | highest | Enforce one explicit action on repeated Discover results. |
| V4.1 Destination Workflow | highest | Keep placement in the object lifecycle and subscriptions in Messages. |
| V4.2 Inbox Lead | high | Remove the duplicate Messages heading, count note, and bucket navigator. |
| V4.3 Dead-Code Removal | high | Delete superseded action, bucket, style, and boundary modules. |
| V4.4 Device Validation | continuous | Compare route interaction counts, text volume, clipping, and scroll depth. |

## Current Slice

- published Discover results open with one primary action
- placement stays in the opened object's lifecycle actions
- subscription requests stay in Messages notices
- Messages begins with the highest-priority decision and uses its existing
  channel row as the only notice navigator
- route and backend contracts that remain reachable continue to be tested

## Validation

Implement the complete composition change first. Then run focused route tests,
strict WeChat generation, iPhone 12/13 Pro recapture, the full MoonBit suite,
boundary and ordinary-copy guards, backend smoke, clean-tree CI, commit, and
push.

## V4.4 Device Result

The iPhone 12/13 Pro recapture confirmed:

- Discover has 11 explicit result buttons for 11 actionable results
- Discover total buttons fell from 30 to 18
- Discover text fell from 709 to 630 characters
- Discover scroll depth fell from 1,625px to 1,469px
- Messages bucket rows fell from five to zero
- Messages text fell from 1,436 to 1,277 characters
- Messages scroll depth fell from 1,639px to 1,551px
- the strict project fell from 178,772 to 173,350 bytes with zero diagnostics
